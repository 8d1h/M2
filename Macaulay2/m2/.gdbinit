file ../bin/Macaulay2
set environment LD_LIBRARY_PATH ../lib
dir ../e ../d ../../gc ../../factory ../../libfac ../../gmp
handle SIGSEGV nostop pass noprint
run setup.m2
