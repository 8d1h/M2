-- this one is from David Eisenbud, makes version 0.4.48 crash

R = ZZ/32003[a..d]
C = resolution cokernel substitute(
     random(R^{0},R^{-1,-1}),
     R/monomialCurve(R,{1,3,4})
     )
try transpose C.dd_2 % C.dd_1
