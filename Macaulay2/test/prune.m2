kk=ZZ/101
R=kk[a,b,c,SkewCommutative=>true]
m=map(R^{-1,0},R^{-2,-1},matrix{{a,0},{b*c,a}})
betti m
F=res(coker m, LengthLimit=>5)
betti F
assert( prune coker F.dd_2 == prune image F.dd_1 )


-- and now 'prune' for coherent sheaves

S = QQ[x]
X = Proj S
n = ideal vars S

F = OO_X(8)
degrees F
F' = sheaf HH^0 F
degrees F'				
assert( first first degrees F' <= 0 )		    -- too much, but that's okay

F = OO_X(-8)
degrees F
F' = sheaf HH^0  F
degrees F'
assert( F' == S^{0} )					    -- on the nose, okay
-----------------------------------------------------------------------------

S = QQ[x..z]
X = Proj S
n = ideal vars S

F = S^{8}
M = n^3 * F
M' = module prune sheaf_X M
degrees M'
assert ( M' == F )

-----------------------------------------------------------------------------
-- Local Variables:
-- compile-command: "make prune.okay"
-- End:
