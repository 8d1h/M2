


R = ZZ/101[a..d,SkewCommutative=>true]
basis(3,R)
basis(4,R)
basis(5,R)
basis(-1,R)
basis(0,R)
basis(1,R)

-- syz coker vars R
f = vars R
coker f
g = syz vars R
h = syz g
syz h

p = poincare (R^1)
T = (ring p)_0
p // (1-T)^4
-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/test testskew.okay "
-- End:
