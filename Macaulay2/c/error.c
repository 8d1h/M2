/*		Copyright 1993 by Daniel R. Grayson		*/

#include "scc.h"

volatile void fatal(char *s,...)
{
     va_list ap;
#ifdef VA_START_HAS_TWO_ARGS
     va_start(ap,s);
#else
     va_start(ap);
#endif
     if (cur.filename != NULL) {
     	  fprintf(stderr,errfmt,cur.filename,cur.lineno,cur.column+1,"");
     	  }
     vfprintf(stderr,s,ap);
     fprintf(stderr,"\n");
     fflush(stderr);
     va_end(ap);
     exit(1);
     }

int errors = 0;
#define ERRLIMIT 24
int warnings = 0;
#define WARNLIMIT 24

void error(char *s,...)
{
     va_list ap;
#ifdef VA_START_HAS_TWO_ARGS
     va_start(ap,s);
#else
     va_start(ap);
#endif
     fprintf(stderr,errfmt,
	  cur.filename!=NULL?cur.filename:"",cur.lineno,cur.column+1,"");
     vfprintf(stderr,s,ap);
     fprintf(stderr,"\n");
     fflush(stderr);
     va_end(ap);
     errors++;
     if (errors > ERRLIMIT) fatal("too many errors");
     }

void warning(char *s,...)
{
     va_list ap;
#ifdef VA_START_HAS_TWO_ARGS
     va_start(ap,s);
#else
     va_start(ap);
#endif
     vfprintf(stderr,s,ap);
     fprintf(stderr,"\n");
     fflush(stderr);
     va_end(ap);
     warnings++;
     if (warnings > WARNLIMIT) fatal("too many errors");
     }

volatile void fatalpos(node p, char *s,...)
{
     va_list ap;
     downpos(p);
#ifdef VA_START_HAS_TWO_ARGS
     va_start(ap,s);
#else
     va_start(ap);
#endif
     vfprintf(stderr,s,ap);
     fprintf(stderr,"\n");
     fflush(stderr);
     va_end(ap);
     exit(1);
     }

void errorpos(node p, char *s,...)
{
     va_list ap;
     downpos(p);
#ifdef VA_START_HAS_TWO_ARGS
     va_start(ap,s);
#else
     va_start(ap);
#endif
     vfprintf(stderr,s,ap);
     fprintf(stderr,"\n");
     fflush(stderr);
     va_end(ap);
     errors++;
     if (errors > ERRLIMIT) fatal("too many errors");
     }

void warningpos(node p, char *s,...)
{
     va_list ap;
     downpos(p);
     fprintf(stderr,"warning: ");
#ifdef VA_START_HAS_TWO_ARGS
     va_start(ap,s);
#else
     va_start(ap);
#endif
     vfprintf(stderr,s,ap);
     fprintf(stderr,"\n");
     fflush(stderr);
     va_end(ap);
     warnings++;
     if (warnings > WARNLIMIT) fatal("too many errors");
     }

node typemismatch(node e){
     errorpos(e,"type mismatch");
     return bad_K;
     }

node badnumargs(node e,int n){
     errorpos(e,"should have %d argument%s",n,n==1?"":"s");
     return bad_K;
     }

node notimpl(node e){
     errorpos(e,"not implemented yet");
     return bad_K;
     }

volatile void quit(){
     myexit(errors != 0);
     }

void fail(char *filename, int lineno) {
     fprintf(stderr,"%s:%d: assertion failed\n", filename,lineno);
     if (cur.filename != NULL) {
     	  fprintf(stderr,"%s:%d: <- here\n",
	       cur.filename, cur.lineno);
	  }
     myexit(1);
     }

void downpos(node n){
     struct POS *p = pos(n);
     if (p != NULL && p->filename != NULL) {
	  fprintf(stderr,errfmt,p->filename,p->lineno,p->column+1,"");
	  }
     else if (cur.filename != NULL) {
	  fprintf(stderr,errfmt,cur.filename,cur.lineno,cur.column+1,"");
	  }
     else fprintf(stderr,errfmt,"",0,0,"");
     }


void failpos(char *filename, int lineno, node p) {
     downpos(p);
     fprintf(stderr,"(%s:%d): assertion failed\n", filename,lineno);
     if (cur.filename != NULL) {
     	  fprintf(stderr,"%s:%d: <- here\n",
	       cur.filename, cur.lineno);
	  }
     myexit(1);
     }
