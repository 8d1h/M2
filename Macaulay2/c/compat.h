/*		Copyright 1993 by Daniel R. Grayson		*/

typedef char bool;

extern char posfmt[];
extern char errfmt[];
extern char errfmtnc[];

#ifndef TRUE
#define TRUE 1
#endif

#ifndef FALSE
#define FALSE 0
#endif

#define OKAY 0

#define ERROR (-1)

#define GRAIN 8

#if defined(__ppc__) && defined(__MACH__)
/* This is how we identify MacOS X, and Darwin */
#define __DARWIN__ 1
#endif

#if HAVE_UNISTD_H
#include <unistd.h>
#endif

#if HAVE_SYSTYPES_H
#include <sys/types.h>
#endif

#if HAVE_TYPES_H
#include <types.h>
#endif

#if HAVE_SYS_STAT_H
#include <sys/stat.h>
#endif

#if HAVE_STDLIB_H
#include <stdlib.h>
#endif

#if HAVE_STRING_H
#include <string.h>
#endif

#include <ctype.h>

#if HAVE_MEMORY_H
#include <memory.h>
#endif

#include <stdio.h>
#include <fcntl.h>

#ifdef __STDC__
#include <stdarg.h>
#else
#include <varargs.h>
#endif

#include <gc/gc.h>

#define malloc(n) GC_MALLOC(n)
#define free(n) GC_FREE(n)

