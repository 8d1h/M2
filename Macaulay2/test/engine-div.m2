-- Test of division in various rings
-- ggdiv, ggmod, ggdivmod.
-- For the purposes of this test, we define:
quot = (m,n) -> (
     sendgg(ggPush m, ggPush n, ggdiv);
     new ring m
     )
rem = (m,n) -> (
     sendgg(ggPush m, ggPush n, ggmod);
     new ring m
     )

remquot = (m,n) -> (
     sendgg(ggPush m, ggPush n, ggdivmod);
     {new ring m, new ring m})

checkremquot = (m,n) -> (
     q := quot(m,n);
     r := rem(m,n);
     assert(m - (q*n+r) == 0);
     rq := remquot(m,n);
     assert(r == rq#0);
     assert(q == rq#1);
     )
    
R = ZZ
checkremquot(3,5)
checkremquot(3,-5)
checkremquot(-3,-5)
checkremquot(-3,5)
checkremquot(0,124321412421412)
checkremquot(247412471271237214721847124714712741477,124321412421412)

R = ZZ/13
checkremquot(1_R,3_R)
checkremquot(0_R,1_R)
assert(try checkremquot(1_R,0_R) else true)

R = GF(27)
checkremquot(R_0,R_0 + 1)
remquot(R_0,R_0 + 1)

-- QQ stuff fails, since we cannot make a QQ.
R = QQ
--checkremquot(3_R,7_R)

-- Polynomials over the integers, one variable.
R = ZZ[x]

f = x^3-13*x^2-27
g = 13*x-5
rem(f,g)
quot(f,g)
checkremquot(f,g)

f = (x-3)*(2*x-5)*(13*x^2-x-1)^2
g = (x-3)*(2*x-5)
assert(div(f,g) == (13*x^2-x-1)^2)
assert(rem(f,g) == 0)
checkremquot(f,g)

checkremquot(0_R,f)
checkremquot(f,f)
checkremquot(f+1,f)
checkremquot(f^2,f)
checkremquot(f,2*f)
remquot(f,2*f)

-- Polynomials over the integers, more variables
R = ZZ[x,y,z]
f = x^3*y*z-13*x^2-27*z^2+134
g = 13*x-5*y+7
remquot(f,g)
checkremquot(f,g)
checkremquot(g,f)
checkremquot(f*g,f)
checkremquot(f*g,g)
checkremquot(f*g+1,f)
checkremquot(f,2_R)
checkremquot(f,7_R)

-- Polynomials over a finite field
R = ZZ/7[x]

f = x^3-13*x^2-27
g = 13*x-5
rem(f,g)
quot(f,g)
checkremquot(f,g)

f = (x-3)*(2*x-5)*(13*x^2-x-1)^2
g = (x-3)*(2*x-5)
assert(div(f,g) == (13*x^2-x-1)^2)
assert(rem(f,g) == 0)
checkremquot(f,g)

checkremquot(0_R,f)
checkremquot(f,f)
checkremquot(f+1,f)
checkremquot(f^2,f)
checkremquot(f,2*f)
remquot(f,2*f)

-- Polynomials over a finite field
R = GF(8)[x]
a = (coefficientRing R)_0
f = a*x^3-13*x^2-27
g = 13*x-5*a^3+1
rem(f,g)
quot(f,g)
checkremquot(f,g)

f = (x-a)*(2*x-5)*(13*x^2-x-a^2)^2
g = (x-a)*(2*x-5)
assert(div(f,g) == (13*x^2-x-a^2)^2)
assert(rem(f,g) == 0)
checkremquot(f,g)

checkremquot(0_R,f)
checkremquot(f,f)
checkremquot(f+1,f)
checkremquot(f^2,f)

-- Fractions field
R = frac(ZZ[x,y])
checkremquot(x/y,y/(x+1))
remquot(x/y,y/(x+1))
checkremquot(x/y,(y^2+y+1)/(x+1))
checkremquot(0_R,(x+y)/(x-y))
checkremquot(1_R,(x+y)/(x-y))

-- Polynomials in an algebraic extension
-- Currently not implemented:
R = QQ[x]/(x^2+1)[y]
remquot(1_R,x*1_R)

-- Polynomials in an algebraic extension
K = toField(QQ[x]/(x^2+1))
R = K[y]
checkremquot(1_R,x*1_R)
checkremquot(y^2+1, y-x)

R = QQ[x,y]/(x^3+x+1)
checkremquot(1_R,x)
checkremquot((x+y)^3,x)
checkremquot((y^2+x)^3,y+x)
checkremquot((y^2+x)^3,y^2+x)

-- Polynomials in a Laurent polynomial ring
R = ZZ[x,y,z,Inverses=>true]
f = 1 - x^-1
g = x-1
checkremquot(f,g)
checkremquot(g,f)
checkremquot(f^14,g)
f = 1 - 3*x^2 + 2*x^3
checkremquot(f,(1-x)^4)
g = quot(f,1-x)
g = quot(g,1-x)
rem(g,1-x)
checkremquot(f,1-x^-1)
checkremquot(f,1-x^-1-y^-1)

R = QQ[t,u,Inverses => true]

(1 - t^4) / (1 - t^2)
(1 + t^4) / (1 - t^2)
(1 - t^-4) / (1 - t^-2)
(1 + t^-4) / (1 - t^-2)
(1 - t^-4 * u^-4) / (1 - t^-2 * u^-2)
remquot((1 + t + t^-4 * u^-4), (1 - t^-2 * u^-2))

-- Polynomials in a skew commutative polynomial ring
R = QQ[symbol a..symbol d,SkewCommutative=>true]
f = a*b-c
g = a-3
rq = remquot(f,g)
(a-3)*(rq#1)
(rq#1)*(a-3)
checkremquot(f,g)

-- ZZ[vars]/I
-- These shouldn't work, but they do...
R = ZZ[x,y,z]/(x^2+y^2+2*z^2,134)
f = x^2+1
g = x+1
checkremquot(f,g)
f = (x+y+z)^2*(x-y-1)
g = (x-y-1)
checkremquot(f,g)
checkremquot(x^2,y^2+2*z^2)

-- NOT CONSIDERED YET (11/13/00 MES)
-- rings of the form A[x,y,z].
