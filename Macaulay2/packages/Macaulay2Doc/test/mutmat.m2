R = QQ
M = mutableMatrix(QQ,3,5)
M_(0,0) = 1_QQ
M_(2,4) = 3/4
M
debug Core
rawSubmatrix(raw M,(0,1),(0,1))

R = QQ[x,y,z]
f = vars R
f = f ++ f
m = mutableMatrix f;
m == mutableMatrix f
entries m
toString m
net m
m
assert(m_(0,2) == z)
m_(1,2) = x+y
assert(m_(1,2) == x+y)
assert(not (m == mutableMatrix f))
m
rowSwap(m,0,1)
assert (entries m == {{0, 0, x + y, x, y, z}, {x, y, z, 0, 0, 0}})
columnSwap(m,4,3)
assert(entries m == {{0, 0, x + y, y, x, z}, {x, y, z, 0, 0, 0}})

m
m = mutableMatrix({{0, 0, x + y, y, x, z}, {x, y, z, 0, 0, 0}}, Dense=>true)
numcols m
numrows m
rowMult
columnMult
rowAdd
columnAdd
-- 2by2's?
-- 
rowPermute
columnPermute

-- what else?
mutableIdentity
mutableMatrix
randomMutableMatrix

-- linear algebra
-- LUdecomposition, solve, eigenvalues, eigenvectors, SVD, leastSquares, LLL
