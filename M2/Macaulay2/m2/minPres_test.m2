-- This file written by Amelia Taylor <ataylor@math.rutgers.edu>


--This is not really a test file yet.  It computes the minimal presentations,
--but does not have boolean tests for checking computations the way we want to.

load "minPres.m2"

--A test underconstruction for minPres.m2

C=ZZ/101[x,y,z,Degrees => {2,3,1}]/ideal(x-x^2-y,z+x*y)
V= time minPres(C)
gens V == {x}
degrees V == {{2}}

C=ZZ/101[x,y,z,Degrees => {{1,2},{1,3},{1,1}}]/ideal(x-x^2-y,z+x*y)
V = time minPres(C,Variable => a)
gens V == {a_0}
degrees V == {{1,2}}

C=ZZ/101[x,y,z,u,w]/ideal(x-x^2-y,z+x*y,w^2-u^2)
V= time minPres(C)
gens V == {x,u,w}
use ring ideal V
ideal V == ideal(u^2-w^2)

w = symbol w
y = symbol y
S = ZZ/101[w_16, w_11, w_12, w_13, w_14, w_15, w_8, w_9, w_10, y_1, y_2, y_3, y_4, y_5, y_6, y_7, y_8,
     Degrees => {{1}, {1}, {2}, {2}, {2}, {2}, {2}, {3}, {3}, {1}, {1}, {1}, {1}, {1}, {1}, {1}, {1}}, MonomialOrder => ProductOrder {1, 5, 3, 8}, MonomialSize => 16]

J=ideal(y_2*y_6-y_3*y_7,w_11*y_6-w_8,w_11*y_1-y_3*y_7,w_11^2-w_15,w_16*y_6-y_1*y_5,w_16*y_3-w_13,w_16*y_2-w_15,w_16*y_1-w_8,w_16*w_11-y_2*y_5,w_16^2-w_11*y_5,y_1*y_4*y_5-y_2*y_3*y_8,w_11*y_3*y_8-y_4*y_5*y_6,w_11*y_2*y_8-y_4*y_5*y_7,w_11*y_4*y_7-w_9,w_14*y_6-y_1*y_2*y_8,w_14*y_5-w_15*y_8,w_14*y_3-w_8*y_4,w_14*y_2-w_9,w_14*y_1-y_4*y_6*y_7,w_12*y_7-y_1*y_2*y_8,w_12*y_6-y_1*y_3*y_8,w_12*y_5-w_13*y_8,w_12*y_3-w_10,w_12*y_2-w_8*y_4,w_12*y_1-y_4*y_6^2,w_11*w_14-y_2^2*y_8,w_11*w_12-y_2*y_3*y_8,w_16*y_4*y_7-y_2^2*y_8,w_16*w_14-y_4*y_5*y_7,w_16*w_12-y_4*y_5*y_6,w_14^2-y_2*y_4*y_7*y_8,w_12*w_14-y_3*y_4*y_7*y_8,w_12^2-y_3*y_4*y_6*y_8)

minPresIdeal(J) == ideal(y_2*y_6-y_3*y_7,y_1*y_5-w_16*y_6,w_11*y_1-y_3*y_7,w_16*y_1-w_11*y_6,w_11^2-w_16*y_2,w_16*w_11-y_2*y_5,w_16^2-w_11*y_5,y_4*y_5*y_7-w_11*y_2*y_8,w_16*y_4*y_7-y_2^2*y_8,w_12*y_7-y_1*y_2*y_8,y_4*y_5*y_6-w_11*y_3*y_8,w_14*y_6-y_1*y_2*y_8,w_12*y_6-y_1*y_3*y_8,w_16*y_4*y_6-y_2*y_3*y_8,w_14*y_5-w_16*y_2*y_8,w_12*y_5-w_16*y_3*y_8,w_14*y_3-w_11*y_4*y_6,w_14*y_2-w_11*y_4*y_7,w_12*y_2-w_11*y_4*y_6,w_14*y_1-y_4*y_6*y_7,w_12*y_1-y_4*y_6^2,w_11*w_14-y_2^2*y_8,w_16*w_14-w_11*y_2*y_8,w_11*w_12-y_2*y_3*y_8,w_16*w_12-w_11*y_3*y_8,w_14^2-y_2*y_4*y_7*y_8,w_12*w_14-y_3*y_4*y_7*y_8,w_12^2-y_3*y_4*y_6*y_8)

C = S/J
V = time minPres(C,Variable => a)
gens V == {a_0,a_1,a_2,a_3,a_4,a_5,a_6,a_7,a_8,a_9,a_10,a_11}
use ring ideal V
ideal V == ideal(a_5*a_9-a_6*a_10,a_4*a_8-a_0*a_9,a_1*a_4-a_6*a_10,a_0*a_4-a_1*a_9,a_1^2-a_0*a_5,a_0*a_1-a_5*a_8,a_0^2-a_1*a_8,a_7*a_8*a_10-a_1*a_5*a_11,a_0*a_7*a_10-a_5^2*a_11,a_2*a_10-a_4*a_5*a_11,a_7*a_8*a_9-a_1*a_6*a_11,a_3*a_9-a_4*a_5*a_11,a_2*a_9-a_4*a_6*a_11,a_0*a_7*a_9-a_5*a_6*a_11,a_3*a_8-a_0*a_5*a_11,a_2*a_8-a_0*a_6*a_11,a_3*a_6-a_1*a_7*a_9,a_3*a_5-a_1*a_7*a_10,a_2*a_5-a_1*a_7*a_9,a_3*a_4-a_7*a_9*a_10,a_2*a_4-a_7*a_9^2,a_1*a_3-a_5^2*a_11,a_0*a_3-a_1*a_5*a_11,a_1*a_2-a_5*a_6*a_11,a_0*a_2-a_1*a_6*a_11,a_3^2-a_5*a_7*a_10*a_11,a_2*a_3-a_6*a_7*a_10*a_11,a_2^2-a_6*a_7*a_9*a_11)



