-----------------------------
-- Test of monoid creation --
-----------------------------
needs "raw-util.m2"
mo = rawMonomialOrdering { GRevLex => {1,2,3,4} }
M = rawMonoid(mo, {a,b,c,d}/toString, degring 2, (0,1, 0,1, 1,0, 1,0))
R = rawPolynomialRing(rawZZ(), M)
a = rawRingVar(R,0,1)
c = rawRingVar(R,2,1)
rawMultiDegree (a*c^2)

-----------------------------
-- Test of GaloisField ------
-----------------------------
needs "raw-util.m2"
R = ZZ/5[x]
f = x^2-x+1
factor f
A = R/f
x = A_0
x^2
x^3
x^4
x^5
x^6
use R
a = 1
f = (x-a)^2-(x-a)+1
factor f
A = R/f
x = A_0
apply(1..24, i -> x^i)
f

needs "raw-util.m2"
R = ZZ/5[x]
f = x^2+2*x-2 -- x is primitive here
A = R/f
A' = raw A
B = rawGaloisField raw x
x = B_0
apply(1..24, i -> x^i)

-- compile-command: "make -C $M2BUILDDIR/Macaulay2/test/engine raw2.okay "
-- End:
