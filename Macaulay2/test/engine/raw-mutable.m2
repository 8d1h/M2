-- Test of the routines for mutable matrices

-- Test: 
--   rawMutableIdentity
--   rawMutableMatrix (2 forms)
--   rawNumberOfRows, rawNumberOfColumns
--   rawMatrixEntry (2 forms for mutable matrices)
--   rawMatrixRowSwap, rawMatrixColSwap
--   rawMatrixRowChange, rawMatrixColChange
--   rawMatrixRowScale, rawMatrixColumnScale
needs "raw-util.m2"
R = ZZ[vars(0..11)]
id10 = rawMutableIdentity(raw R, 10, true); net id10
m = genericMatrix(R,a,3,4)
p = rawMutableMatrix(raw m,true); net p
assert(rawColumnDotProduct(p, 1, 1) == raw(d^2+e^2+f^2))
assert(rawColumnDotProduct(p, 1,2) == raw(d*g+e*h+f*i))
assert(rawNumberOfColumns p == 4)
assert(rawNumberOfRows p == 3)
assert(raw m === rawMatrix p)


rawMatrixRowSwap(p,0,1); net p
assert(rawMatrix p - raw transpose matrix{{b,a,c},{e,d,f},{h,g,i},{k,j,l}} == 0)
rawMatrixColumnSwap(p,1,2); net p
assert(rawMatrix p == raw matrix{{b,h,e,k},{a,g,d,j},{c,i,f,l}})
net p
rawMatrixRowScale(p, raw (5_R), 2, false); net p
rawMatrixColumnScale(p, raw (7_R), 1, false); net p
rawMatrixRowChange(p, 0, raw c, 1, false); net p
rawMatrixColumnChange(p, 1, raw d, 0, false); net p

rawMatrixColumnOperation2(p,1,2,raw e,raw f,raw g,raw h,false) -- WRONG!
net p



p = rawMutableMatrix(raw R, 3,4,true)
rawSetMatrixEntry(p, 1,3, raw(a+b))
net toString p
p1 = rawMutableMatrix (raw m, true)
raw m === rawMatrix p1
p = rawMutableMatrix(raw ((transpose m) * m), true)
net toString p

p = rawMutableMatrix(raw R, 10, 20, true); net p      
scan(50, i -> (rawSetMatrixEntry(p,random 10, random 20, raw (random 100)_R)))
net p

map(R, rawMatrix p)

rawMatrixEntry(p,0,0)
rawMatrixEntry(p,0,1)

rawMutableIdentity(raw R, 10, true)

--------------------------------------------
-- Test of mutable dense matrices over RR --
--------------------------------------------
needs "raw-util.m2"
p = rawMutableIdentity(raw RR, 10, true)
rawSetMatrixEntry(p,3,5,rawFromNumber(raw RR, 3.5))
net p

p = rawMutableMatrix(raw RR, 10, 20, true); net p      
scan(50, i -> (rawSetMatrixEntry(p,random 10, random 20, rawFromNumber(raw RR, random 1.0))))
net p
map(RR,rawMatrix p)

--------------------------------------------
-- Test of mutable sparse matrices ---------
--------------------------------------------
needs "raw-util.m2"
R = ZZ[a..d]
p = rawMutableIdentity(raw R, 10, false)
net p
rawSetMatrixEntry(p,1,3,raw(a+b))
net p

R = ZZ[vars(0..11)]
m = genericMatrix(R,a,3,4)
p = rawMutableMatrix(raw m,false); net p
assert(rawNumberOfColumns p == 4)
assert(rawNumberOfRows p == 3)

rawMatrixColumnOperation2(p,1,2,raw e,raw f,raw g,raw h,false) -- WRONG!
net p

-- smith normal form?
restart
load "raw-smith.m2"
R = ZZ
m = matrix {{22, 32, 55, 76, 9, 4, 35, 8, 27, 33}, {44, 57, 29, 14, 8, 66, 26, 99, 27, 61}, {75, 86, 34, 90, 99, 82, 40, 54, 14, 35}, {13, 92, 23, 59, 47, 62, 65, 30, 7, 74}, {95, 71, 37, 1, 41, 45, 43, 17, 42, 41}, {75, 6, 11, 91, 29, 24, 15, 78, 7, 52}, {84, 39, 75, 53, 76, 38, 21, 91, 16, 72}, {83, 58, 20, 77, 38, 23, 90, 89, 77, 12}, {31, 58, 66, 29, 45, 74, 13, 59, 70, 64}, {8, 65, 68, 7, 44, 55, 63, 9, 2, 13}}
p = rawMutableMatrix(raw m, true); net p
reduceRowsColsGcd(p,9,9); net p
reduceRowsColsGcd(p,8,8); net p
reduceRowsColsGcd(p,7,7); net p
reduceRowsColsGcd(p,6,6); net p
reduceRowsColsGcd(p,5,5); net p
reduceRowsColsGcd(p,4,4); net p
reduceRowsColsGcd(p,3,3); net p
reduceRowsColsGcd(p,3,3); net p
reduceRowsColsGcd(p,2,2); net p
reduceRowsColsGcd(p,1,1); net p

-- smith normal form?
restart
load "raw-smith.m2"
R = ZZ
m = matrix {{22, 32, 55, 76, 9, 4, 35, 8, 27, 33}, {44, 57, 29, 14, 8, 66, 26, 99, 27, 61}, {75, 86, 34, 90, 99, 82, 40, 54, 14, 35}, {13, 92, 23, 59, 47, 62, 65, 30, 7, 74}, {95, 71, 37, 1, 41, 45, 43, 17, 42, 41}, {75, 6, 11, 91, 29, 24, 15, 78, 7, 52}, {84, 39, 75, 53, 76, 38, 21, 91, 16, 72}, {83, 58, 20, 77, 38, 23, 90, 89, 77, 12}, {31, 58, 66, 29, 45, 74, 13, 59, 70, 64}, {8, 65, 68, 7, 44, 55, 63, 9, 2, 13}}
p = rawMutableMatrix(raw m, false); net p
reduceRowsColsGcd(p,9,9); net p
reduceRowsColsGcd(p,8,8); net p
reduceRowsColsGcd(p,7,7); net p
reduceRowsColsGcd(p,6,6); net p
reduceRowsColsGcd(p,5,5); net p
reduceRowsColsGcd(p,4,4); net p
reduceRowsColsGcd(p,3,3); net p
reduceRowsColsGcd(p,3,3); net p
reduceRowsColsGcd(p,2,2); net p
reduceRowsColsGcd(p,1,1); net p

reduceRowGCD(p,8,8,7); net p
reduceRowGCD(p,9,9,8); net p
reduceRowGCD(p,9,9,7); net p
reduceRowGCD(p,9,9,6); net p
reduceRowGCD(p,9,9,5); net p
reduceRowGCD(p,9,9,4); net p
reduceRowGCD(p,9,9,3); net p
reduceRowGCD(p,9,9,2); net p
reduceRowGCD(p,9,9,1); net p
reduceRowGCD(p,9,9,0); net p

-- smith normal form example 2
restart
load "raw-smith.m2"
R = ZZ
p = rawMutableMatrix(raw matrix table(20,20,(i,j)->random 100), true)
net p
det map(ZZ,rawMatrix p)
reduceRowsColsGcd(p,19,19); net p
reduceRowsColsGcd(p,18,18); net p
reduceRowsColsGcd(p,17,17); net p
reduceRowsColsGcd(p,16,16); net p
reduceRowsColsGcd(p,15,15); net p
reduceRowsColsGcd(p,14,14); net p
reduceRowsColsGcd(p,14,14); net p
reduceRowsColsGcd(p,13,0); net p
reduceRowsColsGcd(p,12,1); net p
reduceRowsColsGcd(p,11,2); net p
reduceRowsColsGcd(p,10,3); net p
scan(reverse (1..18), i -> reduceRowsColsGcd(p,i,i))
rawMatrixRowOperation2(p,0,1,raw(1_ZZ),raw(1_ZZ),raw(1_ZZ),raw(-1_ZZ),false)
net p

det m
assert(rawToInteger (2 * rawMatrixEntry(p,0,0)) == det m)

rawMatrixColumnSwap(p,3,9); net p
rawMatrixRowSwap(p,4,9); net p
reduceRowsColsGcd(p,9,9); net p
reduceRowsColsGcd(p,8,8); net p

reduceGCD(p,9,9,8)
net p
reduceGCD(p,9,9,7)
net p
reduceRowsCols(p,8,8); net p
net p

gcdCoefficients(2001,1007)
gcd(2001,1007)


rawMatrixColumnChange(p,8,raw (-42_R),9,false)
net p
m = map(R,p)
toString m
p = rawMutableMatrix(p, true)
net p
rawMatrix
rawMinors(5,p,0)
rawMatrixEntry(oo,0,0)


R
reduceRowsCols(p,9,9)
///
     for r from 0 to nrows-1 do
         if r =!= i then (
	     a := 
     )
///

---------------------------------------
-- mutable matrix routines ------------
---------------------------------------
needs "raw-util.m2"
R = polyring(rawZZ(), (symbol a .. symbol g))

<< "change these routines to call the correct raw routines with correct argument" << endl
r5 = rawIdentity(R^5,0) -- mutable r5

  -----------------------
  -- rawMatrixEntry -----
  -----------------------
  rawMatrixEntry(r5,1,2,a+b)
  assert(rawMatrixEntry(r5,1,2) === a+b)

  rawMatrixEntry(r5,0,0,a^5)
  assert try(rawMatrixEntry(r5,5,5,a^5);false) else true
  rawMatrixEntry(r5,0,0,0_R)
  assert(rawMatrixEntry(r5,0,0) === 0_R)

  ----------------------
  -- rawMatrixRowSwap --
  ----------------------
  m = rawMatrix1(R^3, 4, (a,b,c,d,e,f,g,0_R,a+b,c+d,0_R,e+f), true, 0)
  rawMatrixRowSwap(m, 0,1)
  m
  rawMatrixRowSwap(m, 0,1)
  m0 = rawMatrixRemake1(rawTarget m, m, 0)
  assert(m0 ==  rawMatrix1(R^3, 4, (a,b,c,d,e,f,g,0_R,a+b,c+d,0_R,e+f), 0))

  rawMatrixRowSwap(m, 0,0)
  m
  assert try(rawMatrixRowSwap(m, 0,4); false) else true
  
  ----------------------
  -- rawMatrixColSwap --
  ----------------------

  ------------------------
  -- rawMatrixRowChange --
  ------------------------

  ------------------------
  -- rawMatrixColChange --
  ------------------------

  -----------------------
  -- rawMatrixRowScale --
  -----------------------

  --------------------------
  -- rawMatrixColumnScale --
  --------------------------

  ----------------------
  -- rawInsertColumns --
  ----------------------

  ----------------------
  -- rawInsertRows -----
  ----------------------

  ----------------------
  -- rawDeleteColumns --
  ----------------------

  ----------------------
  -- rawDeleteRows -----
  ----------------------

  -------------------------------
  -- rawMatrixColumnOperation2 --
  -------------------------------

  -------------------------------
  -- rawMatrixRowOperation2 -----
  -------------------------------

  -------------------------------
  -- rawSortColumns -------------
  -------------------------------

  -------------------------------
  -- rawPermuteRows -------------
  -------------------------------

  -------------------------------
  -- rawRowChange ---------------
  -------------------------------

  -------------------------------
  -- rawColumnChange-------------
  -------------------------------

  -------------------------------
  -- rawSolve -------------------
  -------------------------------
  load "raw-util.m2"
  m = mat table(4,4, (i,j) -> rawFromNumber(raw RR, random 1.0))
  b0 = mat table(4,1, (i,j) -> rawFromNumber(raw RR, random 1.0))
  A = rawMutableMatrix(m,true)
  b = rawMutableMatrix(b0,true)
  x = rawMutableMatrix(b0,true)
  net p
  rawSolve(A,b,x)
  net x
  x1 = rawMatrix b
  m*(rawMatrix x)
  rawMinors(4,m,0,-1,null,null)
