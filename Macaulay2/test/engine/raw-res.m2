-- Test of the raw resolution routines

needs "raw-util.m2"

----------------------------------
-- Koszul complex on 3 elements --
-- Algorithm 1                  --
----------------------------------
R = polyring(rawZZp(101), (symbol a, symbol b, symbol c))
m = mat{{a,b,c}}
gbTrace=3
C = rawResolution(m,true,5,false,0,1,0)

rawGBSetStop(C,false,false,{},0,0,0,0,0,false,{})

rawStartComputation C
rawGBBetti(C,0)
m1 = rawResolutionGetMatrix(C,1)
m2 = rawResolutionGetMatrix(C,2)
m3 = rawResolutionGetMatrix(C,3)
m4 = rawResolutionGetMatrix(C,4)
assert(m1*m2 == 0)
assert(m2*m3 == 0)
assert(m3*m4 == 0)

R = ZZ/101[a,b,c]
m = matrix{{a^2,b^2,c^2*b-a^3}}
M = coker m
gbTrace = 3
C = res(M, Strategy => 2)
C.dd
C.dd^2
betti C
res M
----------------------------------
-- Koszul complex on 3 elements --
-- Algorithm 0                  --
----------------------------------
needs "raw-util.m2"
R = polyring(rawZZp(101), (symbol a, symbol b, symbol c))
m = mat{{a,b,c}}
gbTrace=3
C = rawResolution(m,true,5,false,0,0,0)

rawGBSetStop(C,false,false,{},0,0,0,0,0,false,{})

rawStartComputation C
rawGBBetti(C,0)
m1 = rawResolutionGetMatrix(C,1)
m2 = rawResolutionGetMatrix(C,2)
m3 = rawResolutionGetMatrix(C,3)
m4 = rawResolutionGetMatrix(C,4)
assert(m1*m2 == 0)
assert(m2*m3 == 0)
assert(m3*m4 == 0)
----------------------------------
-- Koszul complex on 3 elements --
-- Algorithm 2                  --
----------------------------------
needs "raw-util.m2"
R = polyring(rawZZp(101), (symbol a, symbol b, symbol c))
m = mat{{a,b,c}}
gbTrace=10
C = rawResolution(m,true,5,false,0,2,0)

rawGBSetStop(C,false,false,{},0,0,0,0,0,false,{})

rawStartComputation C
rawGBBetti(C,0)
m1 = rawResolutionGetMatrix(C,1)
m2 = rawResolutionGetMatrix(C,2)
m3 = rawResolutionGetMatrix(C,3)
m4 = rawResolutionGetMatrix(C,4)
assert(m1*m2 == 0)
assert(m2*m3 == 0)
assert(m3*m4 == 0)
F = rawSource m1
F2 = rawTarget m2
F3 = rawSource m2
F4 = rawSource m3
F3b = rawTarget m3
assert(F3 == F3b)
----------------------------------
-- Koszul complex on 3 elements --
-- Algorithm 3                  --
----------------------------------
needs "raw-util.m2"
R = polyring(rawZZp(101), (symbol a, symbol b, symbol c))
m = mat{{a,b,c}}
gbTrace=10
C = rawResolution(m,true,5,false,0,3,0)

rawGBSetStop(C,false,false,{},0,0,0,0,0,false,{})

rawStartComputation C
rawGBBetti(C,0)
m1 = rawResolutionGetMatrix(C,1)
m2 = rawResolutionGetMatrix(C,2)
m3 = rawResolutionGetMatrix(C,3)
m4 = rawResolutionGetMatrix(C,4)
assert(m1*m2 == 0)
assert(m2*m3 == 0)
assert(m3*m4 == 0)
F = rawSource m1
F2 = rawTarget m2
F3 = rawSource m2
F3b = rawTarget m3
assert(F3 == F3b)
----------------------------------
-- Koszul complex on 4 elements --
-- Algorithm 3                  --
----------------------------------
needs "raw-util.m2"
R = polyring(rawZZp(101), (symbol a, symbol b, symbol c, symbol d))
m = mat{{a,b,c^2,d^2}}
gbTrace=10
C = rawResolution(m,true,5,false,0,3,0)

rawGBSetStop(C,false,false,{},0,0,0,0,0,false,{})

rawStartComputation C
rawGBBetti(C,0)
m1 = rawResolutionGetMatrix(C,1)
m2 = rawResolutionGetMatrix(C,2)
m3 = rawResolutionGetMatrix(C,3)
m4 = rawResolutionGetMatrix(C,4)
assert(m1*m2 == 0)
assert(m2*m3 == 0)
assert(m3*m4 == 0)
F = rawSource m1
F2 = rawTarget m2
F3 = rawSource m2
F3b = rawTarget m3
F4 = rawSource m3
F5 = rawSource m4
assert(F3 == F3b)
----------------------------------
-- Twisted cubic                --
-- Algorithm 2                  --
----------------------------------
needs "raw-util.m2"
R = polyring(rawZZp(101), (symbol a, symbol b, symbol c, symbol d))
m = mat{{b^2-a*c,a*d-b*c,c^2-b*d}}
gbTrace=3
C = rawResolution(m,true,5,false,0,2,0)

rawGBSetStop(C,false,false,{},0,0,0,0,0,false,{})

rawStartComputation C
rawGBBetti(C,0)
m1 = rawResolutionGetMatrix(C,1)
m2 = rawResolutionGetMatrix(C,2)
m3 = rawResolutionGetMatrix(C,3)
m4 = rawResolutionGetMatrix(C,4)
assert(m1*m2 == 0)
assert(m2*m3 == 0)
assert(m3*m4 == 0)
F = rawSource m1
F2 = rawTarget m2
F3 = rawSource m2
F3b = rawTarget m3
assert(F3 == F3b)
----------------------------------
needs "raw-util.m2"
R = QQ[symbol a .. symbol f]
I = ideal(a*b*c,a*b*f,a*c*e,a*d*e,a*d*f, b*c*d,b*d*e,b*e*f,c*d*f,c*e*f)
M = module I
gbTrace = 3
C = res M
X = C.Resolution
rawGBBetti(X.RawComputation, 0)

m = raw syz gens I
m = raw gens gb syz gens I
rawTarget m
rawSource m

C = rawResolution(m,true,10,false,0,0,0) -- CORRECT
C = rawResolution(m,true,10,false,0,1,0) -- CORRECT
C = rawResolution(m,true,5,false,0,2,0) -- CORRECT
C = rawResolution(m,true,5,false,0,3,0) -- CORRECT

rawGBSetStop(C,false,false,{},0,0,0,0,0,false,{})
rawStartComputation C
rawGBBetti(C,0)
m1 = rawResolutionGetMatrix(C,1)
m2 = rawResolutionGetMatrix(C,2)
m3 = rawResolutionGetMatrix(C,3)
m4 = rawResolutionGetMatrix(C,4)

----------------------------------








R = polyring(rawZZp(101), (symbol a, symbol b, symbol c, symbol d))
m = mat{{b^2-a*c,a*d-b*c,c^2-b*d}}
C = rawResolution(m,true,5,false,0,1,0)
rawStartComputation C
rawGBBetti(C,0)
m1 = rawResolutionGetMatrix(C,1)
m2 = rawResolutionGetMatrix(C,2)
m3 = rawResolutionGetMatrix(C,3)
m4 = rawResolutionGetMatrix(C,4)
m1*m2

R = polyring(rawZZp(101), (symbol a, symbol b, symbol c, symbol d))
m = mat{{b^2-a*c,a*d-b*c,c^3-b*d^2}}
C = rawResolution(m,true,5,false,0,1,0)
rawStartComputation C
rawGBBetti(C,0)
m1 = rawResolutionGetMatrix(C,1)
m2 = rawResolutionGetMatrix(C,2)
m3 = rawResolutionGetMatrix(C,3)
m4 = rawResolutionGetMatrix(C,4)
m1*m2
m2*m3
assert(rawStatus1 C == 6)

R = polyring(rawQQ(), (symbol a, symbol b, symbol c, symbol d))
m = mat{{2*b^2-a*c,a*d-3*b*c,c^3-7*b*d^2}}
C = rawResolution(m,true,5,false,0,1,0)
rawStartComputation C
rawGBBetti(C,0)
m1 = rawResolutionGetMatrix(C,1)
m2 = rawResolutionGetMatrix(C,2)
m3 = rawResolutionGetMatrix(C,3)
m4 = rawResolutionGetMatrix(C,4)
m1*m2
m2*m3
assert(rawStatus1 C == 6)

rawbetti = (C,typ) -> (
     w := rawGBBetti(C,typ);
     w1 := drop(w,3);
     matrix pack(w1,w#2+1)
     )

needs "raw-util.m2"
R = polyring(rawZZp 101, (vars 0 .. vars 17))
m1 = mat{{a,b,c},{d,e,f},{g,h,i}}
m2 = mat{{j,k,l},{m,n,o},{p,q,r}}
m = rawReshape(m1*m2-m2*m1,R^1,R^{9:-2})
rawIsHomogeneous m
C = rawResolution(m,true,18,false,0,1,0)
time rawStartComputation C
rawGBBetti(C,0)
rawbetti(C,0)
rawbetti(C,1)
rawbetti(C,2)
rawbetti(C,3)

m1 = rawResolutionGetMatrix(C,1);
m2 = rawResolutionGetMatrix(C,2);
m3 = rawResolutionGetMatrix(C,3);
m4 = rawResolutionGetMatrix(C,4);
m5 = rawResolutionGetMatrix(C,5);
m6 = rawResolutionGetMatrix(C,6);
m7 = rawResolutionGetMatrix(C,7);
assert(m1*m2 == 0)
assert(m2*m3 == 0)
assert(m3*m4 == 0)
assert(m4*m5 == 0)
assert(m5*m6 == 0)
assert(m7 == 0)

