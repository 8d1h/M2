-- Test of exterior power of a matrix, and determinants
-- and associated optional computation arguments

testexterior = (p,m1,m2) -> 
  assert(exteriorPower(p,m1*m2) == exteriorPower(p,m1) * exteriorPower(p,m2))

testsame = (p,m) ->
     assert(minors(p,m) == ideal exteriorPower(p,m))

testsame1 = (p,m) -> (
     remove(m.cache, MinorsComputation{p});
     time answer1 := gens minors(p,m,Strategy=>Bareiss);
     remove(m.cache, MinorsComputation{p});
     time answer2 := gens minors(p,m,Strategy=>Cofactor);
     assert(answer1 == answer2))

testsame2 = (p,m) -> (
     time answer1 := exteriorPower(p,m,Strategy=>Bareiss);
     time answer2 := exteriorPower(p,m,Strategy=>Cofactor);
     assert(answer1 == answer2))

R = ZZ/101[a..d]
m = matrix{{a,b},{c,d}}
assert(minors(2,m) == ideal(a*d-b*c))
assert(minors(1,m) == ideal(a,b,c,d))
assert(minors(0,m) == ideal(1_R))
assert(minors(-1,m) == 0)
assert(minors(3,m) == 0)

testsame1(1,m)
testsame1(2,m)
testsame1(3,m)

assert(exteriorPower(2,m) == matrix{{det m}})
assert(exteriorPower(1,m) == m)
assert(exteriorPower(0,m) == matrix{{1_R}})

assert(exteriorPower(2,m^3) == (exteriorPower(2,m))^3)
assert(exteriorPower(2,m^6) == (exteriorPower(2,m))^6)

R = ZZ[vars(0..34)]
m1 = genericMatrix(R,a,3,5)
m2 = genericMatrix(R,p,5,4)

testexterior(-1,m1,m2)  
testexterior(0,m1,m2)  
testexterior(1,m1,m2)  
testexterior(2,m1,m2)  
testexterior(3,m1,m2)  
testexterior(4,m1,m2)

testsame(-1,m1)
testsame(0,m1)
testsame(1,m1)
testsame(2,m1)
testsame(3,m1)
testsame(4,m1)

testsame1(-1,m1)
testsame1(0,m1)
testsame1(1,m1)
testsame1(2,m1)
testsame1(3,m1)
testsame1(4,m1)

R = QQ
m = random(QQ^8,QQ^8)
testsame1(8,m)
m = random(QQ^9,QQ^9)
-- testsame1(8,m) time on my Mac PB G3: 0.58 sec (Bareiss), 148.44 sec (Cofactor).
-- 4/30/2001.

R = ZZ/32003[a..d]
m = random(R^6, R^{6:-1})
testsame1(6,m)

R = ZZ/32003[x,y,z]
m = random(R^18, R^{18:-1})
time minors(18,m,Strategy=>Bareiss);
-- minors(18,m,Strategy=>Cofactor) -- doesn't end in reasonable time.

R = ZZ/101[vars(0..14)]
m = genericMatrix(R,a,3,5)
exteriorPower(3,m)
m = genericMatrix(R,a,2,5)
mm = transpose exteriorPower(2,m)
transpose mm

R = ZZ[vars(0..24)]
m = genericMatrix(R,a,5,5)
minors(1,m)
minors(2,m)
assert(minors(3,m) == ideal exteriorPower(3,m))
assert(minors(4,m) == ideal exteriorPower(4,m))
assert(minors(5,m) == ideal exteriorPower(5,m))
assert(minors(6,m) == ideal exteriorPower(6,m))
assert(gens minors(0,m) == matrix{{1_R}})
assert(numgens minors(-1,m) == 0)

R = ZZ[vars(0..24)]
m = genericMatrix(R,a,3,6)
minors(1,m)
minors(6,m)
minors(0,m)
minors(-1,m)
exteriorPower(-1,m)
exteriorPower(0,m)
time exteriorPower(1,m);
time exteriorPower(2,m);
time exteriorPower(3,m);
time exteriorPower(4,m);
time exteriorPower(5,m);
testsame2(1,m);
testsame2(2,m);
testsame2(3,m);
testsame2(4,m);
testsame2(5,m);

-- The following are examples where Cofactors are better...
m2 = (transpose m) * m
testsame2(1,m2);
testsame2(2,m2);
testsame2(3,m2);
testsame2(4,m2);
testsame2(5,m2);
testsame2(6,m2);

testsame1(1,m2);
testsame1(2,m2);
testsame1(3,m2);
testsame1(4,m2);
testsame1(5,m2);
testsame1(6,m2);

x = symbol x
R = QQ[x_1 .. x_36]
m = genericMatrix(R,x_1,6,6)
time exteriorPower(3,m);
time exteriorPower(4,m);
time exteriorPower(5,m);
time exteriorPower(6,m);
testsame2(3,m) 
testsame2(4,m)
testsame2(5,m)
testsame2(6,m)

-- What about a non-domain
R = ZZ/101[a..d]/(a^2)
m = matrix{{c,b,a},{a,d,1},{a,b,c}}
answer1 = det(m,Strategy=>Bareiss)
answer2 = det(m,Strategy=>Cofactor)
assert(a * (answer1 - answer2) == 0) -- They should differ by a zero-divisor.

x = symbol x
R = ZZ[x_1 .. x_49]
m = genericMatrix(R,x_1,7,7)
time exteriorPower(3,m);
time exteriorPower(4,m);

R = ZZ/101
F = R^4
wedgeProduct(1,2,F)
wedgeProduct(0,0,F)
wedgeProduct(0,1,F)
exteriorPower(0,F)  -- doesn't even accept this yet!
target exteriorPower(0,id_F)
F == target exteriorPower(1,id_F)
target exteriorPower(2,id_F)

-- testing computation of some minors:
R = ZZ[vars(0..35)]
m = genericMatrix(R,a,6,6)
m3 = minors(3,m,Limit=>10)
m3 = minors(3,m,Limit=>10)
numgens m3

minors(3,m,First=>{{2,3,4},{0,1,2}},Limit=>10)
time minors(3,m);
testsame1(3,m)
testsame2(3,m)
-- Local Variables:
-- compile-command: "make testdet.okay"
-- End:
