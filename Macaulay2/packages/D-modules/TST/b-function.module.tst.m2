-- bFunction(Module)
clearAll()
load "D-modules.m2"
Dtrace 1
pInfo(1, "testing bFunction(Module)...")
     
W = QQ[x,y,Dx,Dy, WeylAlgebra => {x=>Dx, y=>Dy}]
w = {1,1}
m = zeroize transpose matrix{{-Dy^2-Dy, -x*Dx-x*Dy-x+1, y*Dy^2+y*Dy-Dy-7},
     {-Dx+Dy, x-(5/4)*y, -1}, {0, -y, -4}, {-1, 0, -x}}
M = cokernel m
wt = {1,1}
shift = {0,0,0}

assert(listForm bFunction(M, wt, shift) == {({6}, 1), ({5}, 24), ({4}, 163), ({3}, 48), ({2}, - 1676), ({1}, 1440)})


