---------------------------------------------------
-- Test of engine ring creation code --------------
---------------------------------------------------
-- Also tests whether these are connected at top level correctly

needs "raw-util.m2"
errorDepth = 0

-- Test of the following routines:
-- Arithmetic for each of these is tested in its own file.
-- Here we make sure that the interface is correct for them.
--   rawZZ
--   rawQQ
--   rawZZp
--   rawGaloisField
--   rawRR
--   rawCC
--   rawBigRR
--   rawBigCC
--   rawPolynomialRing (2 forms)
--   rawSkewPolynomialRing
--   rawWeylAlgebra
--   rawSolvableAlgebra
--   rawFractionRing
--   rawLocalRing
--   rawQuotientRing (2 forms)
--   rawSchurRing
-- and
--   rawIsField
--   rawDeclareField
--   rawGetZeroDivisor
--   rawAmbientRing
--   rawDenominatorRing

assert(raw ZZ === rawZZ())
assert(raw QQ === rawQQ())
print "ERROR: remove the precision from rawRR, rawCC"
print "WARNING: how to change the precision for RR, CC, BigReal, BigComplex"
assert(raw RR === rawRR .000000000001)
assert(raw CC === rawCC .000000000001)
rawZZp 32003
assert (raw (ZZ/32003) =!= rawZZp 32003)
R = ZZ/5
S = ZZ/5
assert(R === S)

assert(class rawGaloisField === Function)
assert(class rawSchurRing === Function)
assert(class rawQuotientRing === Function)
assert(class rawLocalRing === Function)
assert(class rawFractionRing === Function)
assert(class rawSolvableAlgebra === Function)
assert(class rawWeylAlgebra === Function)
assert(class rawSkewPolynomialRing === Function)
assert(class rawPolynomialRing === Function)

assert(class rawIsField === Function)
assert(class rawDeclareField === Function)
assert(class rawGetZeroDivisor === Function)
assert(class rawAmbientRing === Function)
assert(class rawDenominatorRing === Function)

needs "raw-util.m2"
-- Polynomial rings ZZ[a,b][c,d],[e,f]
A = rawPolynomialRing(rawZZ(), singlemonoid(symbol a, symbol b))
B = rawPolynomialRing(A, singlemonoid(symbol c, symbol d))
C = rawPolynomialRing(B, singlemonoid(symbol e, symbol f))

fa = rawRingVar(A,0,3)
ga = rawRingVar(A,1,5)
ha = 3*fa-7*ga
fb = rawPromote(B,fa)
gb1 = rawPromote(B,ga)
hb = rawPromote(B,ha)
assert(hb == 3*fb -7* gb1)

fc = rawPromote(C,fb)
gc1 = rawPromote(C,gb1)
hc = rawPromote(C,hb)
assert(hc == 3*fc -7* gc1)

e = rawRingVar(C,0,1)
f = rawRingVar(C,1,1)
p = rawLeadCoefficient(hc*e*f + f^3)
assert(rawRing p === B)
p = rawLeadCoefficient(hc*e + f)
assert(p === hb)


-- Polynomial rings QQ[a,b][c,d],[e,f]
A = rawPolynomialRing(rawQQ(), singlemonoid(symbol a, symbol b))
B = rawPolynomialRing(A, singlemonoid(symbol c, symbol d))
C = rawPolynomialRing(B, singlemonoid(symbol e, symbol f))

fa = rawRingVar(A,0,3)
ga = rawRingVar(A,1,5)
ha = 3*fa-7*ga
fb = rawPromote(B,fa)
gb1 = rawPromote(B,ga)
hb = rawPromote(B,ha)
assert(hb == 3*fb -7* gb1)

fc = rawPromote(C,fb)
gc1 = rawPromote(C,gb1)
hc = rawPromote(C,hb)
assert(hc == 3*fc -7* gc1)

e = rawRingVar(C,0,1)
f = rawRingVar(C,1,1)
p = rawLeadCoefficient(hc*e*f + f^3)
assert(rawRing p === B)
p = rawLeadCoefficient(hc*e + f)
assert(p === hb)

F = hc*e*f + f^2
<< "rawIsHomogeneous NOT WORKING" << endl;
--assert rawIsHomogeneous F
--assert(rawMultiDegree F === {2})

-- Quotients of polynomial rings, and towers of such
A = rawPolynomialRing(rawZZ(), singlemonoid(symbol a, symbol b))
a = rawRingVar(A,0,1)
b = rawRingVar(A,1,1)
M = mat{{a^2-1, b^2-1}}
B = rawQuotientRing(A,M)
print "ERROR: rawAmbientRing needs to be implemented"
--assert(A === rawAmbientRing B)

C1 = rawPolynomialRing(A, singlemonoid(symbol x, symbol y))
print "ERROR: rawQuotientRing(Ring,Ring) needs to be implemented"
--C = rawQuotientRing(C1,B) -- B must be a quotient ring of the coefficient ring of C1.

----------------------------------
-- Monomial orders ---------------
----------------------------------
needs "raw-util.m2"
mo = rawMonomialOrdering { Lex => 2, GRevLex => {1,2,3}, Weights => {-1}, Position => Up }
M = rawMonoid(mo, {"a","b","c","d","e"}, degring 1, {1,1,1,2,3})
R = rawPolynomialRing(rawZZp 32003, M)
a = rawRingVar(R,0,1)
b = rawRingVar(R,1,1)
c = rawRingVar(R,2,1)
d = rawRingVar(R,3,1)
e = rawRingVar(R,4,1)
a*a
a+b
a*b^3
b^(2^31-1)
2^31-1
assert try ((a+b^(2^31-1))^2;false) else true
b1 = b^(2^31-1)
assert try (b1*b;false) else true
print "QUESTION: why is monomial overflow happening 5 times?"
a*b^(2^31-1)
print "ERROR: this power should give an error"
  --assert (try (b^(2^31); false) else true)
  --b^(2^31)

a
a*b
(c^1000*d^2000*e^3000)^3

needs "raw-util.m2"
mo = rawMonomialOrdering {
     Lex => 3,
     GroupLex => 1,
     Weights => {1,1,1,1,1},
     LexTiny => 4,
     Position => Down}
M = rawMonoid(mo, {"a","b","c",
	           "d",
		   "g","h","i","j"},
	      degring 1, {1,1,1,1,1,1,1,1})
R = rawPolynomialRing(rawZZ(), M)
a = rawRingVar(R,0,1)
b = rawRingVar(R,1,1)
c = rawRingVar(R,2,1)
d = rawRingVar(R,3,1)

g = rawRingVar(R,4,1)
h = rawRingVar(R,5,1)
i = rawRingVar(R,6,1)
j = rawRingVar(R,7,1)

p = g*h^3*j^255
print "ERROR: overflow is not being checked in the engine here?"
  --j * p

assert try(a^(-1);false) else true
d^(-1)
F = a * d^-1 + d^-2
F^3


-------------------------------
-- all the monordering types --
-------------------------------
needs "raw-util.m2"
--------------
-- Lex -------
--------------
mo = rawMonomialOrdering {
     Lex => 3 }
M = rawMonoid(mo, {"a","b","c"},
	      degring 1, 3:1)
R = rawPolynomialRing(rawZZ(), M)
a = rawRingVar(R,0,1)
b = rawRingVar(R,1,1)
c = rawRingVar(R,2,1)
assert(toString a === "a")
assert(toString b === "b")
assert(toString c === "c")
assert(toString(a*b*c) === "abc")
assert(toString(a*b^41*c^513) === "ab41c513")
assert(toString(a^1000*b^41*c^513) === "a1000b41c513")
-------------------
-- LexSmall -------
-------------------
mo = rawMonomialOrdering {
     LexSmall => 3 }
M = rawMonoid(mo, {"a","b","c"},
	      degring 1, 3:1)
R = rawPolynomialRing(rawZZ(), M)
a = rawRingVar(R,0,1)
b = rawRingVar(R,1,1)
c = rawRingVar(R,2,1)
assert(toString a === "a")
assert(toString b === "b")
assert(toString c === "c")
assert(toString(a*b*c) === "abc")
assert(toString(a*b^41*c^513) === "ab41c513")
assert(toString(a^1000*b^41*c^513) === "a1000b41c513")
assert(toString(a^32767*b^41*c^513) === "a32767b41c513")
print "ERROR: a^32768 should not be allowed?"
  --assert try (assert(toString(a^32768*b^41*c^513) === "a32768b41c513"); false) else true
-------------------
-- LexTiny -------
-------------------
mo = rawMonomialOrdering {
     LexTiny => 3 }
M = rawMonoid(mo, {"a","b","c"},
	      degring 1, 3:1)
R = rawPolynomialRing(rawZZ(), M)
a = rawRingVar(R,0,1)
b = rawRingVar(R,1,1)
c = rawRingVar(R,2,1)
assert(toString a === "a")
assert(toString b === "b")
assert(toString c === "c")
assert(toString(a*b*c) === "abc")
assert(toString(a*b^41*c^127) === "ab41c127")
assert try (a*b^41*c^128;false) else true

R = ZZ[symbol a .. symbol c, MonomialOrder => {LexTiny=>3}]
print "ERROR: max exponent size should be 127 here"
f = a+b^255
a+b^256
assert try(a*f;false) else true
------------------
-- GRevLex -------
------------------
mo = rawMonomialOrdering {
     GRevLex => {1,1,1} }
M = rawMonoid(mo, {"a","b","c"},
	      degring 1, 3:1)
R = rawPolynomialRing(rawZZ(), M)
a = rawRingVar(R,0,1)
b = rawRingVar(R,1,1)
c = rawRingVar(R,2,1)
assert(toString a === "a")
assert(toString b === "b")
assert(toString c === "c")
assert(toString(a*b*c) === "abc")
assert(toString(a*b^41*c^513) === "ab41c513")
assert(toString(a^1000*b^41*c^513) === "a1000b41c513")
toString(a^2312321*b^32352352*c^56464646) === "a2312321b32352352c56464646"
-----------------------
-- GRevLexSmall -------
-----------------------
mo = rawMonomialOrdering {
     GRevLexSmall => {1,1,1} }
M = rawMonoid(mo, {"a","b","c"},
	      degring 1, 3:1)
R = rawPolynomialRing(rawZZ(), M)
a = rawRingVar(R,0,1)
b = rawRingVar(R,1,1)
c = rawRingVar(R,2,1)
assert(toString a === "a")
assert(toString b === "b")
assert(toString c === "c")
assert(toString(a*b*c) === "abc")
assert(toString(a*b^41*c^513) === "ab41c513")
assert(toString(a^1000*b^41*c^513) === "a1000b41c513")
assert try(a^2312321*b^32352352*c^56464646;false) else true
-----------------------
-- GRevLexTiny --------
-----------------------
mo = rawMonomialOrdering {
     GRevLexTiny => {1,1,1} }
M = rawMonoid(mo, {"a","b","c"},
	      degring 1, 3:1)
R = rawPolynomialRing(rawZZ(), M)
a = rawRingVar(R,0,1)
b = rawRingVar(R,1,1)
c = rawRingVar(R,2,1)
assert(toString a === "a")
assert(toString b === "b")
assert(toString c === "c")
assert(toString(a*b*c) === "abc")
assert(toString(a*b*c^125) === "abc125")
assert try (a*b*c^126;false) else true
assert try (toString(a^1000*b^41*c^513); false) else true
-------------------
-- GroupLex -------
-------------------
mo = rawMonomialOrdering {
     GroupLex => 3 }
M = rawMonoid(mo, {"a","b","c"},
	      degring 1, 3:1)
R = rawPolynomialRing(rawZZ(), M)
a = rawRingVar(R,0,1)
b = rawRingVar(R,1,1)
c = rawRingVar(R,2,1)
assert(toString a === "a")
assert(toString b === "b")
assert(toString c === "c")
assert(toString(a*b*c) === "abc")
assert(toString(a*b^41*c^513) === "ab41c513")
assert(toString(a^1000*b^41*c^513) === "a1000b41c513")
toString(a^-100000 * b * c^-5) === "a^(-100000)bc^(-5)"
-------------------
-- GroupRevLex -------
-------------------
needs "raw-util.m2"
mo = rawMonomialOrdering {
     GroupRevLex => 3 }
M = rawMonoid(mo, {"a","b","c"},
	      degring 1, 3:1)
R = rawPolynomialRing(rawZZ(), M)
a = rawRingVar(R,0,1)
b = rawRingVar(R,1,1)
c = rawRingVar(R,2,1)
assert(toString a === "a")
assert(toString b === "b")
assert(toString c === "c")
assert(toString(a*b*c) === "abc")
assert(toString(a*b^41*c^513) === "ab41c513")
assert(toString(a^1000*b^41*c^513) === "a1000b41c513")
toString(a^-100000 * b * c^-5) === "a^(-100000)bc^(-5)"
--------------------------
-- GRevLex weights -------
--------------------------
needs "raw-util.m2"
mo = rawMonomialOrdering {
     GRevLex => {3,5,7} }
M = rawMonoid(mo, {"a","b","c"},
	      degring 1, 3:1)
R = rawPolynomialRing(rawZZ(), M)
a = rawRingVar(R,0,1)
b = rawRingVar(R,1,1)
c = rawRingVar(R,2,1)
assert(toString(a^3+b^3+c^3) == "c3+b3+a3")
assert(toString a === "a")
assert(toString b === "b")
assert(toString c === "c")
assert(toString(a*b*c) === "abc")
assert(toString(a*b^41*c^513) === "ab41c513")
assert(toString(a^1000*b^41*c^513) === "a1000b41c513")
toString(a^2312321*b^32352352*c^56464646) === "a2312321b32352352c56464646"
-------------------------------
-- GRevLexSmall weights -------
-------------------------------
needs "raw-util.m2"
mo = rawMonomialOrdering {
     GRevLexSmall => {3,5,7} }
M = rawMonoid(mo, {"a","b","c"},
	      degring 1, 3:1)
R = rawPolynomialRing(rawZZ(), M)
a = rawRingVar(R,0,1)
b = rawRingVar(R,1,1)
c = rawRingVar(R,2,1)
b+c
assert(toString(a^3+b^3+c^3) == "c3+b3+a3")
assert(toString a === "a")
assert(toString b === "b")
assert(toString c === "c")
assert(toString(a*b*c) === "abc")
assert(toString(a*b^41*c^513) === "ab41c513")
assert(toString(a^1000*b^41*c^513) === "a1000b41c513")
assert try (a^2312321*b^32352352*c^56464646;false) else true
-------------------------------
-- GRevLexTiny weights --------
-------------------------------
mo = rawMonomialOrdering {
     GRevLexTiny => {3,5,7} }
M = rawMonoid(mo, {"a","b","c"},
	      degring 1, 3:1)
R = rawPolynomialRing(rawZZ(), M)
a = rawRingVar(R,0,1)
b = rawRingVar(R,1,1)
c = rawRingVar(R,2,1)
assert(toString a === "a")
assert(toString b === "b")
assert(toString c === "c")
assert(toString(a*b*c) === "abc")
assert(toString(a^3+b^3+c^3) == "c3+b3+a3")
--------------------------
-- All together ----------
--------------------------
needs "raw-util.m2"
mo = rawMonomialOrdering {
     Lex => 3,
     GroupLex => 1,
     Weights => {1,1,1,1,1},
     LexTiny => 4,
     LexSmall => 3,
     Position => Down,
     GRevLex => {1,1},
     GRevLexSmall => {1,1,1},
     GRevLexTiny => {2,3,4}}
M = rawMonoid(mo, {"a","b","c",
	           "d",
		   "g","h","i","j",
		   "k","m","n",
		   "o","p",
		   "q","r","s",
		   "t","u","v"},
	      degring 1, 19:1)
R = rawPolynomialRing(rawZZ(), M)

a = rawRingVar(R,0,1)
b = rawRingVar(R,1,1)
c = rawRingVar(R,2,1)

d = rawRingVar(R,3,1)

g = rawRingVar(R,4,1)
h = rawRingVar(R,5,1)
i = rawRingVar(R,6,1)
j = rawRingVar(R,7,1)

k = rawRingVar(R,8,1)
m = rawRingVar(R,9,1)
n = rawRingVar(R,10,1)

o = rawRingVar(R,11,1)
p = rawRingVar(R,12,1)

q = rawRingVar(R,13,1)
r = rawRingVar(R,14,1)
s = rawRingVar(R,15,1)

t = rawRingVar(R,16,1)
u = rawRingVar(R,17,1)
v = rawRingVar(R,18,1)

assert(toString(a*g*m^4) === "agm4")
assert(toString(a*m) === "am")
assert(toString(b*m) === "bm")
assert(toString(a*b^2*c^3*d^4*g^5*h^6*i^7*j^6*k^5*m^4*n^3*o^2*p*r^2*s^3*t^4*u^5*v^6)
     === "ab2c3d4g5h6i7j6k5m4n3o2pr2s3t4u5v6")
c+g^4
t+u
t+u+v

-----------------------------
-- testing non term orders --
-----------------------------
needs "raw-util.m2"
mo = rawMonomialOrdering {
     Weights => {0,0,-1,-1,0,3},
     GRevLex => 3:1,
     Lex => 2,
     RevLex => 1
     }

M = rawMonoid(mo, {"a","b","c","d","e","f"},
	      degring 1, 6:1)
R = rawPolynomialRing(rawZZ(), M)

a = rawRingVar(R,0,1)
b = rawRingVar(R,1,1)
c = rawRingVar(R,2,1)
d = rawRingVar(R,3,1)
e = rawRingVar(R,4,1)
f = rawRingVar(R,5,1)
(1+c)*(1+b)
1+c+d^4
end
-----------------------------
complement(A,P) -- need a GB of P.
affine(A,f) -- creates a ring A[t]/(tf-1)...
product(S1,S2,...,Sr) -- not always a multiplicatively closed set
intersect(S1,S2,...,Sr)

poly(K, M, I, S)
  -- K is either basic or ZZ
  -- M is a monoid
  -- I is an ideal in K[M], equipped with a GB (over a field, if base is not ZZ, or
  --  if the ring contains QQ).  Not quite...
  -- S is a multiplicatively closed set in K[M], s.t.
  -- (K[M]/I)_S is K[M]_S/I
poly(K,M)

fractions(K[M], S)

-- Local Variables:
-- compile-command: "M2 -e errorDepth=0 --stop -e 'load \"raw-ring.m2\"' -e 'exit 0' "
-- End:
