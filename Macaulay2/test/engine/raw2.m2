-----------------------------
-- Test of monoid creation --
-----------------------------
needs "raw-util.m2"
mo = rawMonomialOrdering { GRevLex => {1,2,3,4} }
M = rawMonoid(mo, {a,b,c,d}/toString, degring 2, (0,1, 0,1, 1,0, 1,0))

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/test/engine raw2.okay "
-- End:
