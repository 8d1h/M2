R = ZZ[x,y]
d = 5*x^2*y+7*x^3-y^4
f = (3*x^3-x*y+y^2) * d
g = (3*x^3+x*y+y^2) * d
h = gcd(f,g)
assert(h == d)

R = QQ[x,y]
d = 5*x^2*y+7*x^3-1/11*y^4
f = (3*x^3-x*y+y^2) * d
g = (3*x^3+x*y+y^2) * d
h = gcd(f,g)
assert(h == d)

debug Macaulay2
R = QQ[x,y]
f = 1+x^2
g = 1+x^3
rawGCD( raw ( f ), raw ( g ))
rawGCD( raw ( 1/2*f ), raw ( 1/3*g ))                       -- crashes, probably because convert() in x-factor.cpp doesn't handle rational coefficients at all
rawExtendedGCD( raw ( f ), raw ( g ))
rawExtendedGCD( raw ( 1/2*f ), raw ( 1/3*g ))               -- loops forever

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/test gcd.out"
-- End:
