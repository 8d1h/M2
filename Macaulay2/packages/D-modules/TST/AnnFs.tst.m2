-- AnnFs
clearAll()
load "Dloadfile.m2"
Dtrace 1
pInfo(1, "testing AnnFs...")

R = QQ[x_1..x_4, z, d_1..d_4, Dz, WeylAlgebra => ( toList(1..4) / (i -> (x_i => d_i)) | {z => Dz} ) ]
f = x_1 + x_2 * z + x_3 * z^2 + x_4 * z^3

Ann = AnnFs f
R = ring Ann
s = R_(numgens R - 1)
assert ( Ann == ideal {
	  z * d_1 - d_2,
	  z * d_2 - d_3,
	  z * d_3 - d_4,
	  d_2^2 - d_1 * d_3,
	  d_3^2 - d_2 * d_4,
	  d_2 * d_3 - d_1 * d_4,
	  x_2 * d_1 + 2 * x_3 * d_2 + 3 * x_4 * d_3 - Dz,
	  x_2 * d_2 + 2 * x_3 * d_3 + 3 * x_4 * d_4 - z * Dz,
	  x_1 * d_1 - x_3 * d_3 - 2 * x_4 * d_4 + z * Dz - s,
	  3 * x_4 * z * d_4 - z^2 * Dz + x_2 * d_3 + 2 * x_3 * d_4
	  })

-- AnnFIs
clearAll()
load "Dloadfile.m2"
W = QQ[x,dx, WeylAlgebra=>{x=>dx}]
Ann = AnnIFs(ideal dx, x^2)
WS = ring Ann
assert( Ann == ideal (x*dx - 2*WS_2) )  








