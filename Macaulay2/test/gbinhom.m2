R = ZZ/101[a..d]
try matrix{{a,b},{c,d}} % gb ideal(b+1,d) -- crashes, but should just give error
-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/test gbinhom.out"
-- End:
