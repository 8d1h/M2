-------------------------
-- R^3
-------------------------
clearAll()
load "D-modules.m2"
Dtrace 1
pInfo(1, "testing makeCyclic...")

R = QQ[x, dx, WeylAlgebra => {x=>dx}]
M = matrix {{dx, 0, 0}, {0, dx, 0}, {0, 0, dx}}
h = makeCyclic M
assert (listForm bFunction(h.AnnG,{1}) == listForm bFunction(cokernel M, {1}, {0,1,2}))
assert (Drank h.AnnG == Drank cokernel M)
assert (singLocus h.AnnG == singLocus cokernel M)


-------------------------
-- R^1 / dx^3  
-------------------------
use R
M = presentation prune image map( R^1/ideal dx^3, R^3, matrix{{1, x, x^2}} )
h = makeCyclic M
b1 = bFunction(ideal dx^3, {1})
b2 = bFunction(cokernel M, {1}, {0,-1,-2})
assert (listForm b1 == listForm b2)






