#include "pthread-exports.h"
#include "supervisor.hpp"

#include <iostream>
#include <stdlib.h>
#include <assert.h>
const static int numThreads = 3;

static void reverse_run(struct FUNCTION_CELL *p) { if (p) { reverse_run(p->next); (*p->fun)(); } }

extern "C" {
  THREADLOCALDECL(struct atomic_field, interrupts_interruptedFlag);
  THREADLOCALDECL(struct atomic_field, interrupts_exceptionFlag);
  struct ThreadSupervisor* threadSupervisor = 0 ;
  void initializeThreadSupervisor()
  {
    if(NULL==threadSupervisor)
      threadSupervisor = new ThreadSupervisor(numThreads);
    assert(threadSupervisor);
    threadSupervisor->m_TargetNumThreads=numThreads;
    threadSupervisor->initialize();
  }
  void pushTask(struct ThreadTask* task)
  {
    threadSupervisor->m_Mutex.lock();
    if(task->m_Dependencies.empty())
      {
	threadSupervisor->m_ReadyTasks.push_back(task);
      }
    else
      {
	threadSupervisor->m_WaitingTasks.push_back(task);
      }
    pthread_cond_signal(&threadSupervisor->m_TaskWaitingCondition);
    threadSupervisor->m_Mutex.unlock();
  }
  void delThread(pthread_t thread)
  {
    threadSupervisor->m_Mutex.lock();
    std::map<pthread_t, struct ThreadSupervisorInformation*>::iterator it = threadSupervisor->m_ThreadMap.find(thread);
    if(it!=threadSupervisor->m_ThreadMap.end())
      {
	threadSupervisor->m_ThreadMap.erase(it);
      }
    threadSupervisor->m_Mutex.unlock();
  }
  void addCancelTask(struct ThreadTask* task, struct ThreadTask* cancel)
  {
    task->m_Mutex.lock();
    task->m_CancelTasks.insert(cancel);
    task->m_Mutex.unlock();
  }
  void addStartTask(struct ThreadTask* task, struct ThreadTask* start)
  {
    task->m_Mutex.lock();
    task->m_StartTasks.insert(start);
    task->m_Mutex.unlock();
  }
  void addDependency(struct ThreadTask* task, struct ThreadTask* dependency)
  {
    dependency->m_Mutex.lock();
    dependency->m_StartTasks.insert(task);
    dependency->m_Mutex.unlock(); 
    task->m_Mutex.lock();
    task->m_Dependencies.insert(dependency);
    task->m_Mutex.unlock();
  }
  struct ThreadTask* createThreadTask(const char* name, ThreadTaskFunctionPtr func, void* userData, int timeLimitExists, time_t timeLimitSeconds)
  {
    return new ThreadTask(name,func,userData,(bool)timeLimitExists,timeLimitSeconds);
  }
  void* waitOnTask(struct ThreadTask* task)
  {
    return task->waitOn();
  }
  extern void TS_Add_ThreadLocal(int* refno, const char* name)
  {
    if(NULL == threadSupervisor)
      threadSupervisor = new ThreadSupervisor(numThreads);
    assert(threadSupervisor);
    threadSupervisor->m_Mutex.lock();
    if(threadSupervisor->m_ThreadLocalIdPtrSet.find(refno)!=threadSupervisor->m_ThreadLocalIdPtrSet.end())
      {
	threadSupervisor->m_Mutex.unlock();
	return;
      }
    threadSupervisor->m_ThreadLocalIdPtrSet.insert(refno);
    int ref = threadSupervisor->m_ThreadLocalIdCounter++;
    if(ref>threadSupervisor->s_MaxThreadLocalIdCounter)
     abort();
    *refno = ref;
    threadSupervisor->m_Mutex.unlock();
  }

};

ThreadTask::ThreadTask(const char* name, ThreadTaskFunctionPtr func, void* userData, bool timeLimit, time_t timeLimitSeconds):
  m_Name(name),m_Func(func),m_UserData(userData),m_Result(NULL),m_Done(false),m_Started(false),m_TimeLimit(timeLimit),m_Seconds(timeLimitSeconds),m_KeepRunning(true),m_CurrentThread(NULL)
{
   if(pthread_cond_init(&m_FinishCondition,NULL))
    abort();
}
ThreadTask::~ThreadTask()
{
}
void* ThreadTask::waitOn()
{
  m_Mutex.lock();
  while(!m_Done && m_KeepRunning)
    {
      if(pthread_cond_wait(&m_FinishCondition,&m_Mutex.m_Mutex))
	continue;
    }
  void* ret = m_Result;
  m_Mutex.unlock();
  return ret;
}

void staticThreadLocalInit()
{
  THREADLOCALINIT(interrupts_exceptionFlag);
  THREADLOCALINIT(interrupts_interruptedFlag);
}


ThreadSupervisor::ThreadSupervisor(int targetNumThreads):
  m_TargetNumThreads(targetNumThreads),m_ThreadLocalIdCounter(1)
{
  threadSupervisor=this;
  #ifdef GETSPECIFICTHREADLOCAL
  if(pthread_key_create(&m_ThreadSpecificKey,NULL))
    abort();
  m_LocalThreadMemory = new void*[ThreadSupervisor::s_MaxThreadLocalIdCounter];
  if(pthread_setspecific(threadSupervisor->m_ThreadSpecificKey,m_LocalThreadMemory))
    abort();
  #endif
  if(pthread_cond_init(&m_TaskWaitingCondition,NULL))
    abort();
  //once everything is done initialize statics
  staticThreadLocalInit();
}

ThreadSupervisor::~ThreadSupervisor()
{
  if(pthread_key_delete(m_ThreadSpecificKey))
    abort();
}
void ThreadSupervisor::initialize()
{
  for(int i = 0; i < m_TargetNumThreads; ++i)
    {
      SupervisorThread* thread = new SupervisorThread();
      thread->start();
      m_Threads.push_back(thread);
    }
  extern int TS_Test();
  TS_Test();
}
void ThreadSupervisor::_i_finished(struct ThreadTask* task)
{
  m_Mutex.lock();
  m_RunningTasks.remove(task);
  if(task->m_KeepRunning)
    {
      m_FinishedTasks.push_back(task);
    }
  else
    {
      m_CanceledTasks.push_back(task);
    }
  if(pthread_cond_broadcast(&task->m_FinishCondition))
    abort();  
  m_Mutex.unlock();
}
void ThreadSupervisor::_i_startTask(struct ThreadTask* task, struct ThreadTask* launcher)
{
  m_Mutex.lock();
  task->m_Mutex.lock();
  if(!task->m_Dependencies.empty())
    {
      if(!launcher)
	{
	  task->m_Mutex.unlock();
	  m_Mutex.unlock();
	  return;
	}
      std::set<struct ThreadTask*>::iterator it = task->m_Dependencies.find(launcher);
      if(it!=task->m_Dependencies.end())
	{
	  task->m_Dependencies.erase(launcher);
	  task->m_FinishedDependencies.insert(launcher);
	}
      if(!task->m_Dependencies.empty())
	{
	  task->m_Mutex.unlock();
	  m_Mutex.unlock();
	  return;
	}
    }
  m_WaitingTasks.remove(task);
  m_ReadyTasks.push_back(task);
  if(pthread_cond_signal(&m_TaskWaitingCondition))
    abort();
  task->m_Mutex.unlock();
  m_Mutex.unlock();
}
void ThreadSupervisor::_i_cancelTask(struct ThreadTask* task)
{
  m_Mutex.lock();
  task->m_Mutex.lock();
  if(task->m_CurrentThread)
    AO_store(&task->m_CurrentThread->m_Interrupt->field,true);
  task->m_KeepRunning=false;
  task->m_Mutex.unlock();
  m_Mutex.unlock();
}
struct ThreadTask* ThreadSupervisor::getTask()
{
  m_Mutex.lock();
  while(m_ReadyTasks.empty())
    {
    RESTART:
      if(pthread_cond_wait(&m_TaskWaitingCondition,&m_Mutex.m_Mutex))
	goto RESTART;
    }
  if(m_ReadyTasks.empty())
    goto RESTART;
  struct ThreadTask* task = m_ReadyTasks.front();
  m_ReadyTasks.pop_front();
  m_RunningTasks.push_back(task);
  m_Mutex.unlock();
  return task;
}
void ThreadTask::run(SupervisorThread* thread)
{
  m_Mutex.lock();
  if(!m_KeepRunning)
    {
      threadSupervisor->_i_finished(this);
      m_Mutex.unlock();
      return;
    }
  m_CurrentThread=thread;
  m_Started = true;
  m_Mutex.unlock();
  m_Result = m_Func(m_UserData);
  m_Mutex.lock();
  m_Done = true;
  m_CurrentThread=NULL;
  threadSupervisor->_i_finished(this);
  //cancel stuff_
  for(std::set<ThreadTask*>::iterator it = m_CancelTasks.begin(); it!=m_CancelTasks.end(); ++it)
    threadSupervisor->_i_cancelTask(*it);
  //start stuff
  for(std::set<ThreadTask*>::iterator it = m_StartTasks.begin(); it!=m_StartTasks.end(); ++it)
    threadSupervisor->_i_startTask(*it,this);
  m_Mutex.unlock();
}

SupervisorThread::SupervisorThread():m_KeepRunning(true)
{
  m_ThreadLocal = new void*[ThreadSupervisor::s_MaxThreadLocalIdCounter];
}
void SupervisorThread::start()
{
  if(pthread_create(&m_ThreadId,NULL,SupervisorThread::threadEntryPoint,this))
    abort();
}
void SupervisorThread::threadEntryPoint()
{
  #ifdef GETSPECIFICTHREADLOCAL
  if(pthread_setspecific(threadSupervisor->m_ThreadSpecificKey,m_ThreadLocal))
    abort();
  #endif
  m_Interrupt=&THREADLOCAL(interrupts_interruptedFlag,struct atomic_field);
  reverse_run(thread_prepare_list);// re-initialize any thread local variables
  while(m_KeepRunning)
    {
      AO_store(&m_Interrupt->field,false);
      struct ThreadTask* task = threadSupervisor->getTask();
      task->run(this);
    }
}
