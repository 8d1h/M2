S = (ZZ/101 [a, b, c, d, SkewCommutative => true])/(a*b,c*d)

A = matrix {{c, a}, {b, 0}}
B = matrix {{a}, {c}}

A * B
assert(A*B==0)

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/test skewmult.out"
-- End:
