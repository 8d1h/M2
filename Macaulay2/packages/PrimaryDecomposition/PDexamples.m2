restart
load "Elimination.m2"
load "GTZ.m2"
R = ZZ/32003[a,b,c,d,e,f]
I = ideal(
    a^2*c*d*f^2,
    b^2*c*d*f^2,
    a^2*b*d*f^2,
    b^3*d*f^2,
    a^3*d*f^2,
    a*b^2*d*f^2,
    a^2*c*d*e,
    b^2*c*d*e,
    a^2*b*d*e,
    b^3*d*e,
    a^3*d*e,
    a*b^2*d*e,
    a^2*c*d^2,
    b^2*c*d^2,
    a^2*b*d^2,
    b^3*d^2,
    a^3*d^2,
    a*b^2*d^2,
    a^2*c^2*f^2,
    b^2*c^2*f^2,
    a^2*b*c*f^2,
    b^3*c*f^2,
    a^3*c*f^2,
    a*b^2*c*f^2,
    a^2*b^2*f^2,
    b^4*f^2,
    a^3*b*f^2,
    a*b^3*f^2,
    a^4*f^2)
GTZ1 I


R = ZZ/32003[b,s,t,u,v,w,x,y,z]
I = ideal(
    b*v+s*u,
    b*w+t*u,
    s*w+t*v,
    b*y+s*x,
    b*z+t*x,
    s*z+t*y,
    u*y+v*x,
    u*z+w*x,
    v*z+w*y)
GTZ1 I

R = ZZ/32003[x,y,z]
I = ideal(
    x*y^2*z^2-x*y^2*z+x*y*z^2-x*y*z,
    x*y^3*z+x*y^2*z,
    x*y^4-x*y^2,
    x^2*y*z^2-x^2*y*z,
    x^2*y^3-x^2*y^2,
    x^4*z^3-x^4*z^2+2*x^3*z^3-2*x^3*z^2+x^2*z^3-x^2*z^2,
    x^2*y^2*z,
    x^4*y*z+x^3*y*z,
    2*x^4*y^2+6*x^3*y^2+6*x^2*y^2+x*y^3+x*y^2,
    x^5*z+x^4*z^2+x^4*z+2*x^3*z^2-x^3*z+x^2*z^2-x^2*z,
    x^6*y+3*x^5*y+3*x^4*y+x^3*y)
GTZ1 I

R = ZZ/32003[b,s,t,u,v,w,x,y,z]
I = ideal(
    s*u-b*v,
    t*v-s*w,
    v*x-u*y,
    w*y-v*z)
GTZ1 I -- becomes non-binomial...

R = ZZ/32003[a,b,c,d,e,f,g,h]
I = ideal(
    h+f+e-d-a,
    2*f*b+2*e*c+2*d*a-2*a^2-a-1,
    3*f*b^2+3*e*c^2-3*d*a^2-d+3*a^3+3*a^2+4*a,
    6*g*e*b-6*d*a^2-3*d*a-d+6*a^3+6*a^2+4*a,
    4*f*b^3+4*e*c^3+4*d*a^3+4*d*a-4*a^4-6*a^3-10*a^2-a-1,
    8*g*e*c*b+8*d*a^3+4*d*a^2+4*d*a-8*a^4-12*a^3-14*a^2-3*a-1,
    12*g*e*b^2+12*d*a^3+12*d*a^2+8*d*a-12*a^4-18*a^3-14*a^2-a-1,
    -24*d*a^3-24*d*a^2-8*d*a+24*a^4+36*a^3+26*a^2+7*a+1)
codim I
I1 = eliminate(I, {d,e,f,h});
degree I
GTZ0 I
independentSets I
flatt(I,b*c*g)

-----------------------------------------------------
needsPackage "Markov"
G = makeGraph {{},{1},{1},{1},{2,3,4}}
R = markovRing(2,2,2,2,2)
F = marginMap(1,R)
I = F markovIdeal(R, localMarkovStmts G)
transpose gens I

codim I -- takes a while to get 14
degree I -- 336

debug PrimaryDecomposition
time GTZ0 I;
J0 = oo_0;
J1 = ooo_1;
codim J1
degree J0
degree J1

time GTZ0 J1;
-----------------------------------------------------
