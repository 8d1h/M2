R = ZZ[a,b][x,y];
f = a+x;
substitute(f, { a => b } )
a' = a + 0_R
leadMonomial a'
baseName a'
-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/test subst4.out"
-- End:
