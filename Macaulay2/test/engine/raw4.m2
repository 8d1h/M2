-- MES
-- Test of the rawGB commands

load "raw-util.m2"

R1 = polyring(rawQQ(), (symbol x, symbol y, symbol z))

R1 = rawPolynomialRing(rawQQ(), singlemonoid{x,y,z})
x = rawRingVar(R1,0,1)
y = rawRingVar(R1,1,1)
z = rawRingVar(R1,2,1)

algorithm = 0
algorithm = 1

-- Test 1.  A very simple GB.
G = mat {{x,y,z}}
Gcomp = rawGB(G,false,0,{},false,0,algorithm,0)
rawStartComputation Gcomp
m = rawGBGetMatrix Gcomp -- Groebner basis
assert(m === mat{{z,y,x}})

rawGBMatrixRemainder(Gcomp,mat{{x}})

Gcomp = rawGB(G,true,3,{},false,0,0,0)
rawStartComputation Gcomp
m = rawGBGetMatrix Gcomp -- Groebner basis
assert(m === mat{{z,y,x}})

msyz = rawGBSyzygies Gcomp
zeroelem = rawFromNumber(R1,0)
assert(msyz == mat{{zeroelem,z,y},{z,zeroelem,-x},{-y,-x,zeroelem}})

-- Test 1Z.
G = mat {{x,y^2,z^3}}
Gcomp = rawGB(G,false,0,{},false,0,2,0)
rawStartComputation Gcomp
m = rawGBGetMatrix Gcomp -- Groebner basis
assert(m === G)

assert(rawGBMatrixRemainder(Gcomp,mat{{x-1}}) === mat{{1_R1}})

-- Test 1A.
G = mat {{x,y,z^2, x*z+z^2}}
Gcomp = rawGB(G,false,0,{},false,0,0,0)
rawStartComputation Gcomp
m = rawGBGetMatrix Gcomp -- Groebner basis
assert(m == mat{{y,x,z^2}})
m1 = rawGBMinimalGenerators Gcomp -- mingens
assert(m1 == mat{{y,x,z^2}})


-- Test 2. 
G = mat {{x*y-y^2, x^2}}
Gcomp = rawGB(G,false,0,{},false,0,algorithm,0)
rawStartComputation Gcomp
m = rawGBGetMatrix Gcomp -- Groebner basis
assert(m == mat{{x*y-y^2, x^2, y^3}})

Gcomp = rawGB(G,true,-1,{},false,0,0,0)
rawStartComputation Gcomp
m = rawGBSyzygies Gcomp
m = rawGBGetMatrix Gcomp
RawStatusCodes#(rawStatus1 Gcomp)
rawStatus2 Gcomp -- last degree something was computed in

assert(rawGBMatrixRemainder(Gcomp,mat{{x*y}}) === mat{{y^2}})

-- Test 3. 

G = mat{{(3*x+y+z)^2, (7*x+2*y+3*z)^2}}
Gcomp = rawGB(G,false,0,{},false,0,0,0)
rawStartComputation Gcomp
m = rawGBGetMatrix Gcomp
answerm = mat{{21*x^2-2*y^2+42*x*z+8*y*z+13*z^2,
	       42*x*y+13*y^2-84*x*z-10*y*z-32*z^2,
	       y^3-6*y^2*z+12*y*z^2-8*z^3}}
--assert(m == answerm)  -- is this correct????

-- Test 4. -- module GB
R2 = polyring(rawQQ(), symbol a .. symbol f)

m = mat {{a,b,c},{d,e,f}}
Gcomp = rawGB(m,false,0,{},false,0,0,0)
rawStartComputation Gcomp
mgb = rawGBGetMatrix Gcomp


Gcomp = rawGB(m,true,-1,{},false,0,0,0)
rawStartComputation Gcomp
mgb = rawGBGetMatrix Gcomp
msyz = rawGBSyzygies Gcomp
mchange = rawGBChangeOfBasis Gcomp
assert(mgb == m * mchange)
mgb
m * mchange
m

m * mchange
-- Test 5. -- Semi-random cubics
needs "raw-util.m2"
R2 = polyring(rawQQ(), symbol a .. symbol f)
M = mat {{(5*a+b+3*c)^10, (3*a+17*b+4*d)^10, (9*b+13*c+12*d)^10}}
Gcomp = rawGB(M,false,0,{0},false,0,0,0)
rawStartComputation Gcomp
mgb = rawGBGetMatrix Gcomp ;
Gcomp = rawGB(M,false,0,{0},false,0,1,0)
rawStartComputation Gcomp
mgb = rawGBGetMatrix Gcomp; -- I get warnings from gc here...

rawGBGetLeadTerms(Gcomp,6)
-- Test 6. -- same in char 101
R2 = polyring(rawZZp(101), symbol a .. symbol f)
M = mat {{(5*a+b+3*c)^10, (3*a+17*b+4*d)^10, (9*b+13*c+12*d)^10}}
Gcomp = rawGB(M,false,0,{0},false,0,0,0)
rawStartComputation Gcomp  -- crashes due to bad access in spair_sorter
mgb = rawGBGetMatrix Gcomp;
Gcomp = rawGB(M,false,0,{0},false,0,1,0)
rawStartComputation Gcomp
mgb = rawGBGetMatrix Gcomp;


rawGBGetLeadTerms(Gcomp,6)

--rawGBSetStop(Gcomp, ...) -- MES: make sure the default is set correctly
-- Actual computation is done in, eg:

mmin = rawGBMinimalGenerators Gcomp
msyz = rawGBSyzygies Gcomp

--- Tests for gbA: inhomogeneous and local
needs "raw-util.m2"
R1 = polyring(rawQQ(), (symbol x,symbol y,symbol z))
algorithm = 1

G = mat {{x*y-1, x^2-x, x^3-z-1}}
Gcomp = rawGB(G,false,0,{},false,0,algorithm,0)
rawStartComputation Gcomp
mgb = rawGBGetMatrix Gcomp
assert(mgb === mat{{z,y-1,x-1}})

R2 = rawPolynomialRing(rawQQ(), lex{x,y,z})
x = rawRingVar(R2,0,1)
y = rawRingVar(R2,1,1)
z = rawRingVar(R2,2,1)
algorithm = 1
G = mat {{x*y-1, x^2-x, x^3-z-1}}
Gcomp = rawGB(G,false,0,{0},false,0,algorithm,0)
rawStartComputation Gcomp
mgb = rawGBGetMatrix Gcomp


G = mat {{x^2*y-y^3-1, x*y^2-x-1}}
Gcomp = rawGB(G,false,0,{},false,0,algorithm,0)
rawStartComputation Gcomp
mgb = rawGBGetMatrix Gcomp
assert(mgb === mat{{y^7-2*y^5+y^4+y^3-2*y^2-y+1, x-y^6+y^4-y^3+y+1}})
-- I haven't checked the actual polynomials yet. !!

G = mat {{x^2*y-17*y^3-23, 3*x*y^2-x-6}}
Gcomp = rawGB(G,false,0,{},false,0,algorithm,0)
rawStartComputation Gcomp
mgb = rawGBGetMatrix Gcomp

-- fixed: BUG -- actually 2 separate bugs here: depending in the ring
--        used (now works with both R1,R2).
f1 = mat {{x+y+z, x*y+y*z+z*x, x*y*z-1, (x+y+z)^5+x*(x*y*z-1) + 13}}
G1 = rawGB(f1,true,-1,{},false,0,algorithm,0)
rawStartComputation G1
gb1 = rawGBGetMatrix G1
ch1 = rawGBChangeOfBasis G1
f2 = rawGBSyzygies G1
assert(f1 * ch1 - gb1 == 0) 
assert(f1 * f2 == 0)

G2 = rawGB(f2,true,-1,{},false,0,algorithm,0)
rawStartComputation G2
gb2 = rawGBGetMatrix G2
ch2 = rawGBChangeOfBasis G2
f3 = rawGBSyzygies G2
assert(f2 * ch2 - gb2 == 0) 
assert(f2 * f3 == 0) 
rawGBGetLeadTerms(Gcomp,3)
--------------------------------

R2 = rawPolynomialRing(rawQQ(), lex{x,y,z})
x = rawRingVar(R2,0,1)
y = rawRingVar(R2,1,1)
z = rawRingVar(R2,2,1)
algorithm = 1
G = mat {{x+y+z, x*y+y*z+z*x, x*y*z-1, (x+y+z)^5+x*(x*y*z-1) + 13}}
Gcomp = rawGB(G,true,-1,{},false,0,algorithm,0)
rawStartComputation Gcomp
m = rawGBGetMatrix Gcomp
ch = rawGBChangeOfBasis Gcomp
G * ch
syzm = rawGBSyzygies Gcomp
assert(G * syzm == 0)

Gcomp = rawGB(syzm,true,-1,{},false,0,algorithm,0)
rawStartComputation Gcomp
ch = rawGBChangeOfBasis(Gcomp)
g2 = rawGBGetMatrix Gcomp
syzm * ch - g2  -- 8..10 elements are NOT zero: BUG
syz2m = rawGBSyzygies Gcomp
assert(syzm * syz2m == 0)

G = mat {{3*x-y^20, 4*y-z^20, x*y-x-1}}
Gcomp = rawGB(G,false,0,{},false,0,algorithm,0)
rawStartComputation Gcomp
m = rawGBGetMatrix Gcomp

-- Koszul syzygies
needs "raw-util.m2"
R1 = rawPolynomialRing(rawQQ(), singlemonoid{x,y,z,w,t})
x = rawRingVar(R1,0,1)
y = rawRingVar(R1,1,1)
z = rawRingVar(R1,2,1)
w = R1_3
t = R1_4
algorithm = 1
G = mat {{x-1,y-t^3-2,2*z-t^7-3,5*w-t-7}}
Gcomp = rawGB(G,true,-1,{},false,0,algorithm,0)
rawStartComputation Gcomp
m = rawGBGetMatrix Gcomp
m1 = rawGBSyzygies Gcomp
assert(G * m1 == 0)
Gcomp = rawGB(m1,true,-1,{},false,0,algorithm,0)
rawStartComputation Gcomp
m2 = rawGBSyzygies Gcomp
assert(m1 * m2 == 0)

Gcomp = rawGB(m2,true,-1,{},false,0,algorithm,0)
rawStartComputation Gcomp
m3 = rawGBSyzygies Gcomp
assert(m2 * m3 == 0)

-- M2 code:
///
R = QQ[x,y,z,MonomialOrder=>Lex]
G = matrix{{x^2*y-17*y^3-23, 3*x*y^2-x-6}}
gens gb G

G = matrix {{x+y+z, x*y+y*z+z*x, x*y*z-1, (x+y+z)^5+x*(x*y*z-1) + 13}}
gens gb G
syz G
syz oo
ooo * oo
///

needs "raw-util.m2"
algorithm = 1

R1 = rawPolynomialRing(rawQQ(), elim({t},{a,b,c,d}))
t = rawRingVar(R1,0,1)
a = rawRingVar(R1,1,1)
b = rawRingVar(R1,2,1)
c = rawRingVar(R1,3,1)
d = rawRingVar(R1,4,1)
G = mat{{b^4-13*a*c, 12*b*c^2-7*a*d^3, t*a-1}}
Gcomp = rawGB(G,false,0,{},false,0,algorithm,0)
rawStartComputation Gcomp -- Groebner basis
m = rawGBGetMatrix Gcomp

R2 = rawPolynomialRing(rawQQ(), lex{u,v,x,y,z})
u = rawRingVar(R2,0,1)
v = rawRingVar(R2,1,1)
x = rawRingVar(R2,2,1)
y = rawRingVar(R2,3,1)
z = rawRingVar(R2,4,1)
G = mat{{x - 3*u-3*u*v^2+u^3, y-3*v-3*u^2*v+v^3, z-3*u^2+3*v^2}}
Gcomp = rawGB(G,false,0,{},false,0,algorithm,0)
--gbTrace = 4
rawStartComputation Gcomp  -- Groebner basis -- infinite loop BUG!!
time m = rawGBGetMatrix Gcomp
rawGBGetLeadTerms(Gcomp,6)

///
R = ZZ/32003[u,v,x,y,z,t,MonomialOrder=>Lex]
G = matrix{{x - 3*u-3*u*v^2+u^3, y-3*v-3*u^2*v+v^3, z-3*u^2+3*v^2}}
G = homogenize(G,t)
gens gb G
///

needs "raw-util.m2"
algorithm = 1
R2 = rawPolynomialRing(rawZZp(32003), lex{u,v,x,y,z})
u = rawRingVar(R2,0,1)
v = rawRingVar(R2,1,1)
x = rawRingVar(R2,2,1)
y = rawRingVar(R2,3,1)
z = rawRingVar(R2,4,1)
G = mat{{x - 3*u-3*u*v^2+u^3, y-3*v-3*u^2*v+v^3, z-3*u^2+3*v^2}}
Gcomp = rawGB(G,false,0,{},false,0,algorithm,0)
gbTrace = 4
rawStartComputation Gcomp 
time m = rawGBGetMatrix Gcomp
rawGBGetLeadTerms(Gcomp,6)


-- Is this correct?

-- Try the other routines:
-- rawGB, rawGBSetHilbertFunction, rawGBForce
-- rawGBSetStop
-- rawResolutionGetMatrix, rawGBChangeOfBasis, rawGBGetLeadTerms, rawResolutionGetFree
-- rawStatus, rawStatusLevel, rawGBBetti
-- rawGBMatrixRemainder, rawGBMatrixLift, rawGBContains

needs "raw-util.m2"
R1 = rawPolynomialRing(rawQQ(), singlemonoid{a,b,c,d})
a = rawRingVar(R1,0,1)
b = rawRingVar(R1,1,1)
c = rawRingVar(R1,2,1)
d = rawRingVar(R1,3,1)
algorithm = 1
G = mat{{b^4-13*a*c, 12*b*c^2-7*a*b*d^3-1}}
Gcomp = rawGB(G,false,0,{},false,0,algorithm,0)
rawStartComputation Gcomp
m = rawGBGetMatrix Gcomp

f = (7*a^2+a+1)*(a^20+a^17+4*a^13+1)^7
g = (7*a^2+a+1)*(6*a^20-123*a^17+4*a^13+1)^6
G = mat{{f,g}}
Gcomp = rawGB(G,false,0,{},false,0,algorithm,0)
time rawStartComputation Gcomp -- seems to be in an INFINITE LOOP!!
m = rawGBGetMatrix Gcomp
assert(m === mat{{7*a^2+a+1}})
-------------------------------------------
-- Groebner bases with Schreyer orders ----
-------------------------------------------
needs "raw-util.m2"
R = polyring(rawZZp(101), (symbol a, symbol b, symbol c))
m = mat{{a^2,b^2,a*c}}
F = rawFreeModule m
m = rawMatrix1(F,1,(b,a,0_R),false,0)
G = rawGB(m,false,0,{},false,0,0,0)
gbTrace = 10
rawStartComputation G 
rawGBGetLeadTerms(G,10)
<< "DO A MORE SUBSTANTIAL Schreyer order GB" << endl;
--------------------------------------------
-- Groebner bases using hilbert functions --
--------------------------------------------
needs "raw-util.m2"
gbTrace = 3
R = polyring(rawQQ(), (symbol x, symbol y, symbol z, symbol w))
G = mat{{(3*x+y+z+w)^4, (7*x+2*y+3*z)^4 + x*w^3, (x+y+z)^4}}
Gcomp = rawGB(G,false,0,{},false,0,0,0)
rawStartComputation Gcomp
m = rawGBGetMatrix Gcomp;
h = rawHilbert m
-- redo the computation, using this HF.
Gcomp = rawGB(G,false,0,{},false,0,0,0)
rawGBSetHilbertFunction(Gcomp, h)
rawStartComputation Gcomp
m1 = rawGBGetMatrix Gcomp;
assert(m == m1)

R1 = polyring2(rawQQ(), (symbol x, symbol y, symbol z, symbol w), rawMonomialOrdering { Lex  => 4})
G = mat{{(3*x+y+z+w)^4, (7*x+2*y+3*z)^4 + x*w^3, (x+y+z)^4}}
Gcomp = rawGB(G,false,0,{},false,0,0,0)
time rawStartComputation Gcomp
m1 = rawGBGetMatrix Gcomp;
assert(rawHilbert m1 == h)
Gcomp = rawGB(G,false,0,{},false,0,0,0)
rawGBSetHilbertFunction(Gcomp, h)
time rawStartComputation Gcomp
m2 = rawGBGetMatrix Gcomp;
assert(m1 == m2)
------------------------------
-- Groebner bases over ZZ ----
------------------------------
needs "raw-util.m2"
R = polyring(rawZZ(), (symbol x, symbol y))
f = y^2 - x*(x-12_R)*(x-13_R)
f = y^2 + y - (x^3 - x^2) -- conductor is 11 -- from SLN #476 (Swinnerton-Dyer)
rawConcat(rawDual rawMatrixDiff(rawDual mat{{x,y}}, mat{{f}}), mat{{f}})  -- BUG in diff!!
algorithm = 1

needs "raw-util.m2"
R = polyring(rawZZ(), (symbol x, symbol y))
G = mat{{2*y+1, 3*x^2+2*x, y^2 + y - (x^3 - x^2)}}
Gcomp = rawGB(G,false,0,{},false,0,0,0)
rawStartComputation Gcomp
m = rawGBGetMatrix Gcomp
assert(m == mat{{53_R, y-26, x-17}})

Gcomp = rawGB(G,true,-1,{},false,0,0,0)
rawStartComputation Gcomp
m = rawGBSyzygies Gcomp
Gcomp2 = rawGB(m,true,-1,{},false,0,0,0)
rawStartComputation Gcomp2
mgb = rawGBGetMatrix Gcomp2
rawGBGetLeadTerms(Gcomp2,10)
m2 = rawGBSyzygies Gcomp2
Gcomp3 = rawGB(mgb,true,-1,{},false,0,0,0)
rawStartComputation Gcomp3
m2 = rawGBSyzygies Gcomp3


needs "raw-util.m2"
R = polyring(rawZZ(), (symbol x, symbol y))
G = mat{{2*y+1, 3*x^2-2*x, y^2 + y - (x^3 - x^2)}}
Gcomp = rawGB(G,false,0,{},false,0,0,0)
rawStartComputation Gcomp
m = rawGBGetMatrix Gcomp
assert(m == mat{{11_R, y-5, x+3}})

needs "raw-util.m2"
R = polyring(rawZZ(), (symbol x, symbol y))
G = mat{{-3*x^2+50*x-156,  2*y, -x^3+25*x^2+y^2-156*x}}
Gcomp = rawGB(G,false,0,{},false,0,0,0)
gbTrace = 10
rawStartComputation Gcomp
m = rawGBGetMatrix Gcomp
assert(m == mat{{24336_R, 2*y, 4*x-7800, y^2+2*x-3900, x^2+2*x-3900}})
     
needs "raw-util.m2"
R = rawPolynomialRing(rawZZ(), lex{symbol y, symbol x})
y = rawRingVar(R,0,1)
x = rawRingVar(R,1,1)
G = mat{{-3*x^2+50*x-156,  2*y, -x^3+25*x^2+y^2-156*x}}
Gcomp = rawGB(G,false,0,{},false,0,0,0)
rawStartComputation Gcomp
m = rawGBGetMatrix Gcomp
assert(m == mat{{24336_R, 4*x-7800, x^2+2*x-3900, 2*y, y^2+2*x-3900}})

needs "raw-util.m2"
R = rawPolynomialRing(rawZZ(), lex{symbol x, symbol y})
y = rawRingVar(R,1,1)
x = rawRingVar(R,0,1)
G = mat{{-3*x^2+50*x-156,  2*y, -x^3+25*x^2+y^2-156*x}}
Gcomp = rawGB(G,false,0,{},false,0,0,0)
rawStartComputation Gcomp
m = rawGBGetMatrix Gcomp
assert(m == mat{{24336_R, 2*y, y^3, 2*x+y^2-3900, x*y^2+12168, x^2+y^2}})

-- The following example fails, probably due to huge numbers
R1 = polyring2(rawZZ(), (symbol x, symbol y, symbol z, symbol w), rawMonomialOrdering { Lex  => 4})
G = mat{{(3*x+y+z+w)^4, (7*x+2*y+3*z)^4 + x*w^3, (x+y+z)^4}}
Gcomp = rawGB(G,false,0,{},false,0,0,0)
<< "can we get thisZZ GB working?" << endl;
--time rawStartComputation Gcomp
--m1 = rawGBGetMatrix Gcomp;

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/test/engine raw4.okay "
-- compile-command: "M2 --debug-M2 --stop -e 'input \"raw4.m2\"' -e 'exit 0' "
-- End:
