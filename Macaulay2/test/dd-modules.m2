loadPackage "Dmodules"
-- Dtrace 666
R = QQ[x,y]
A = deRhamAll(x^2+y^3)
assert A.?TransferCycles
B = deRhamAll(x^2+y^2)
assert B.?TransferCycles				    -- seems to fail for homgeneous polynomials
-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/test d-modules.okay "
-- End:
