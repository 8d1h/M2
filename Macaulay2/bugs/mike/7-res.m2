----------------------------------
-- Koszul complex on 3 elements --
-- Algorithm 3                  --
----------------------------------
path = prepend("/Users/mike/M2/Macaulay2/test/engine/",path)
needs "raw-util.m2"
R = polyring(rawZZp(101), (symbol a, symbol b, symbol c))
m = mat{{a,b,c}}
gbTrace=10
C = rawResolution(m,true,5,false,0,3,0)

rawGBSetStop(C,false,{},0,0,0,0,0,false,{})

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

rawGBSetStop(C,false,{},0,0,0,0,0,false,{})

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
Ffour = rawSource m3
F5 = rawSource m4
assert(F3 == F3b)

----------------------------------
-- real projective plane        --
-- Algorithm 3                  --
----------------------------------
-- WARNING: algorithm 0 requires a GB!!
needs "raw-util.m2"
R = QQ[symbol a .. symbol f]
I = ideal(a*b*c,a*b*f,a*c*e,a*d*e,a*d*f, b*c*d,b*d*e,b*e*f,c*d*f,c*e*f)
M = module I
m = raw gens gb syz gens I
C = rawResolution(m,true,6,false,0,3,0)
rawGBSetStop(C,false,{},0,0,0,0,0,false,{})
rawStartComputation C
assert(rawbettimat(C,0) == matrix {{10, 15, 7}, {0, 1, 0}})
m1 = rawResolutionGetMatrix(C,1)
m2 = rawResolutionGetMatrix(C,2)
m3 = rawResolutionGetMatrix(C,3)
assert(m1*m2 == 0)
assert(m3 == 0)

----------------------------------
-- 3 by 3 commuting matrices    --
-- Algorithm 3                  --
----------------------------------
needs "raw-util.m2"
R = ZZ/32003[vars(0..17)]
m1 = genericMatrix(R,a,3,3)
m2 = genericMatrix(R,j,3,3)
J = flatten(m1*m2-m2*m1)
J = ideal J
m = raw gens J
time C = rawResolution(m,true,10,false,0,3,0)
rawGBSetStop(C,false,{},0,0,0,0,0,false,{})
time rawStartComputation C
bettimat = matrix {
     {1, 0, 1, 0, 0, 0, 0}, 
     {0, 9, 2, 0, 0, 0, 0}, 
     {0, 0, 31, 32, 3, 0, 0}, 
     {0, 0, 0, 28, 58, 32, 4}, 
     {0, 0, 0, 0, 0, 0, 1}}
assert(bettimat == rawbettimat(C,0))
   
m1 = rawResolutionGetMatrix(C,1);
m2 = rawResolutionGetMatrix(C,2);
m3 = rawResolutionGetMatrix(C,3);
m4 = rawResolutionGetMatrix(C,4);
m5 = rawResolutionGetMatrix(C,5);
m6 = rawResolutionGetMatrix(C,6);
m7 = rawResolutionGetMatrix(C,7)
assert(m1*m2 == 0)
assert(m2*m3 == 0)
assert(m3*m4 == 0)
assert(m4*m5 == 0)
assert(m5*m6 == 0)
assert(m7 == 0)
assert(m1 == m)

--------------------------------
-- non raw versions
--------------------------------
path = prepend("/Users/mike/M2/Macaulay2/test/engine/",path)
needs "raw-util.m2"

bettiMatrix = (C) -> rawbettimat(raw C.Resolution, 0)

R = ZZ/101[a,b,c]
M = coker vars R
C = res(M, Strategy => 2)
assert(C.dd^2 == 0)
bettiMatrix C == matrix"1,3,3,1"

M = coker matrix{{a,b,c}}
C = res(M, Strategy => 3)
assert(C.dd^2 == 0)

R = ZZ/101[a,b,c,d]
M = coker vars R
C = res(M, Strategy => 2)
assert(C.dd^2 == 0)
bettiMatrix C == matrix"1,4,6,4,1"

M = coker matrix{{a,b,c,d}}
C = res(M, Strategy => 3)
assert(C.dd^2 == 0)

R = QQ[symbol a .. symbol f]
I = ideal(a*b*c,a*b*f,a*c*e,a*d*e,a*d*f, b*c*d,b*d*e,b*e*f,c*d*f,c*e*f)
M = coker syz gens I

C = res(M, Strategy => 2)
assert(C.dd^2 == 0)
bettiMatrix C == matrix"10,15,6"

I = ideal(a*b*c,a*b*f,a*c*e,a*d*e,a*d*f, b*c*d,b*d*e,b*e*f,c*d*f,c*e*f)
M = coker syz gens I
C = res(M, Strategy => 3)
assert(C.dd^2 == 0)

R = ZZ/32003[vars(0..17)]
m1 = genericMatrix(R,a,3,3)
m2 = genericMatrix(R,j,3,3)
J = ideal flatten(m1*m2-m2*m1)
time C = res(J, Strategy => 2)
assert(C.dd^2 == 0)
bettiMatrix C == matrix"1,0,0,0,0,0,0;
                        0,8,2,0,0,0,0;
			0,0,31,32,3,0,0;
			0,0,0,28,58,32,4;
			0,0,0,0,0,0,1"
J = ideal flatten(m1*m2-m2*m1)
time C = res(J, Strategy => 1)
assert(C.dd^2 == 0)

J = ideal flatten(m1*m2-m2*m1)
time C = res(J, Strategy => 0)
assert(C.dd^2 == 0)

J = ideal flatten(m1*m2-m2*m1)
C = res(J, Strategy => 3)
assert(C.dd^2 == 0)

R = ZZ/31991 [a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, MonomialSize=>8]
I = ideal" pr-os+mt,          
     jr-is+gt,
     pq-ns+lt,
     oq-nr+kt,
     mq-lr+ks,
     jq-hs+ft,
     iq-hr+et,
     gq-fr+es,
     dq-cr+bs-at,
     jo-ip+dt,
     mn-lo+kp,
     jn-hp+ct,
     in-ho+bt,
     gn-fo+ep+at,
     dn-co+bp,
     jm-gp+ds,
     im-go+dr,
     hm-fo+ep+cr-bs+at,
     jl-fp+cs,
     il-fo+cr+at,
     hl-fn+cq,
     gl-fm+as,
     dl-cm+ap,
     jk-ep+bs-at,
     ik-eo+br,
     hk-en+bq,
     gk-em+ar,
     fk-el+aq,
     dk-bm+ao,
     ck-bl+an,
     gh-fi+ej,
     dh-ci+bj,
     df-cg+aj,
     de-bg+ai,
     ce-bf+ah"
time C = res(I, Strategy=>1);
betti C

I = ideal flatten entries gens I
time C = res(I, Strategy=>0);
betti C

gbTrace=1
I = ideal flatten entries gens I
time C = res(I, Strategy=>2);
betti C
