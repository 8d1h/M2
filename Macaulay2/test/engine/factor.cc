#define NEWNEW 1		// adds 1.4 seconds to 7.5 sec running time

#include <stdarg.h>
#include <stdlib.h>
#include <stdio.h>
#include <gmp.h>
#include <gc.h>
#include <factory.h>
#include <templates/ftmpl_inst.cc>

extern "C" void factory_setup() {
  On(SW_USE_NTL);
}

extern "C" void outofmem() {
  cerr << "out of memory" << endl;
  exit(1);
}

extern "C" void dummy_GC_warn_proc(char *msg, GC_word arg) { }

extern "C" void IM2_initialize()
{
  factory_setup();
}

#if NEWNEW

void* operator new( size_t size ) {
  void *p = GC_MALLOC( size );
  if (p == NULL) outofmem();
  return p;
}

void operator delete( void* obj ) {
  if (obj != NULL) GC_FREE( obj );
}

void* operator new []( size_t size ) {
  void *p = GC_MALLOC( size );
  if (p == NULL) outofmem();
  return p;
}

void operator delete []( void* obj ) {
  if (obj != NULL) GC_FREE( obj );
}

#endif

int main() {
  Variable z( 'z' );
  Variable y( 'y' );
  Variable x( 'x' );
  CanonicalForm f;
  setCharacteristic( 0 );
  cin >> f;
  cout << "factorize(f) = " << factorize(f) << endl;
  return 0;
}

// Local Variables:
// compile-command: "make -C $M2BUILDDIR/Macaulay2/test/engine benchmark"
// End:
