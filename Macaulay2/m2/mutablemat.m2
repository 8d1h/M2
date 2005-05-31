--		Copyright 2005 by Daniel R. Grayson

MutableMatrix = new Type of HashTable
raw MutableMatrix := m -> m.RawMutableMatrix
ring MutableMatrix := m -> m.Ring
MutableMatrix == ZZ := (m,i) -> raw m == i
ZZ == MutableMatrix := (i,m) -> raw m == i
entries MutableMatrix := m -> (
     R := ring m;
     applyTable(entries raw m, r -> new R from r))
toString MutableMatrix := m -> "mutableMatrix " | toString entries m
net MutableMatrix := m -> (
     m = raw m;
     if m == 0 then return "0";
     stack toSequence apply(lines toString m, x -> concatenate("| ",x,"|")))
map(Ring,RawMutableMatrix) := opts -> (R,m) -> (
     new MutableMatrix from {
	  symbol Ring => R,
	  symbol RawMutableMatrix => m,
	  symbol cache => new CacheTable
	  }
     )
new Matrix from MutableMatrix := (typeofMatrix       ,m) -> map(ring m,rawMatrix        raw m)
new MutableMatrix from Matrix := (typeofMutableMatrix,m) -> map(ring m,rawMutableMatrix raw m)

mutableMatrix = method(Options => {Dense => true})
mutableMatrix Matrix := o -> m -> map(ring m, rawMutableMatrix(raw m, o.Dense))
mutableMatrix List := o -> m -> (m1 := matrix m; map(ring m1, rawMutableMatrix(raw m1, o.Dense)))
mutableMatrix MutableMatrix := o -> (m) -> map(ring m, rawMutableMatrix(raw m, o.Dense))

matrix MutableMatrix := o -> m -> map(ring m, rawMatrix raw m)

installAssignmentMethod(symbol "_",MutableMatrix, Sequence, (M,ij,val) -> (raw M)_ij = raw val)

mutableZero = method(Options => {Dense => true})
mutableZero(Ring,ZZ,ZZ) := o -> (R,nrows,ncols) -> 
  map(R,rawMutableMatrix(raw R,nrows,ncols,o.Dense))

mutableIdentity = method(Options => {Dense => true})
mutableIdentity(Ring,ZZ) := o -> (R,nrows) -> 
  map(R,rawMutableIdentity(raw R,nrows,o.Dense))

MutableMatrix _ Sequence := (m,rc) -> (
     n := (raw m)_rc;
     if class n === RawRingElement then new ring m from n
     else if class n === RawMutableMatrix then map(ring m, n)
     else error "internal error"
     )
MutableMatrix == MutableMatrix := (m,n) -> raw m == raw n

assgn := method()
assgn(RawMutableMatrix,ZZ,ZZ,RingElement) := (m,r,c,x) -> rawSetMatrixEntry(m,r,c,raw x)
assgn(RawMutableMatrix,ZZ,ZZ,ZZ) := (m,r,c,x) -> rawSetMatrixEntry(m,r,c,raw x)
assgn(RawMutableMatrix,ZZ,ZZ,QQ) := (m,r,c,x) -> rawSetMatrixEntry(m,r,c,raw x)
assgn(RawMutableMatrix,ZZ,ZZ,RR) := (m,r,c,x) -> rawSetMatrixEntry(m,r,c,raw x)
assgn(RawMutableMatrix,ZZ,ZZ,CC) := (m,r,c,x) -> rawSetMatrixEntry(m,r,c,raw x)
installAssignmentMethod(symbol _, MutableMatrix, Sequence, (m,rc,x) -> ((r,c) -> assgn(raw m,r,c,x)) rc)

numRows = method()
numRows(RawMutableMatrix) := (m) -> rawNumberOfRows m
numRows(MutableMatrix) := (m) -> rawNumberOfRows raw m

numColumns = method()
numColumns(RawMutableMatrix) := (m) -> rawNumberOfColumns m
numColumns(MutableMatrix) := (m) -> rawNumberOfColumns raw m

rowSwap = method()
rowSwap(RawMutableMatrix,ZZ,ZZ) := (m,i,j) -> rawMatrixRowSwap(m,i,j)
rowSwap(MutableMatrix,ZZ,ZZ) := (m,i,j) -> rawMatrixRowSwap(raw m,i,j)

columnSwap = method()
columnSwap(RawMutableMatrix,ZZ,ZZ) := (m,i,j) -> rawMatrixColumnSwap(m,i,j)
columnSwap(MutableMatrix,ZZ,ZZ) := (m,i,j) -> rawMatrixColumnSwap(raw m,i,j)


rowPermute = method()
rowPermute(RawMutableMatrix,ZZ,List) := (m,start,p) -> rawPermuteRows(m,start,p)
rowPermute(MutableMatrix,ZZ,List) := (m,start,p) -> rawPermuteRows(raw m,start,p)

columnPermute = method()
columnPermute(RawMutableMatrix,ZZ,List) := (m,start,p) -> rawPermuteColumns(m,start,p)
columnPermute(MutableMatrix,ZZ,List) := (m,start,p) -> rawPermuteColumns(raw m,start,p)

rowMult = method()
rowMult(MutableMatrix,ZZ,RingElement) := (A,r,f) -> rawMatrixRowScale(raw A,raw f,r,false)
rowMult(MutableMatrix,ZZ,ZZ) := (A,r,f) -> rawMatrixRowScale(raw A,raw f,r,false)
rowMult(MutableMatrix,ZZ,QQ) := (A,r,f) -> rawMatrixRowScale(raw A,raw f,r,false)
rowMult(MutableMatrix,ZZ,RR) := (A,r,f) -> rawMatrixRowScale(raw A,raw f,r,false)
rowMult(MutableMatrix,ZZ,CC) := (A,r,f) -> rawMatrixRowScale(raw A,raw f,r,false)

columnMult = method()
columnMult(MutableMatrix,ZZ,RingElement) := (A,r,f) -> rawMatrixColumnScale(raw A,raw f,r,false)
columnMult(MutableMatrix,ZZ,ZZ) := (A,r,f) -> rawMatrixColumnScale(raw A,raw f,r,false)
columnMult(MutableMatrix,ZZ,QQ) := (A,r,f) -> rawMatrixColumnScale(raw A,raw f,r,false)
columnMult(MutableMatrix,ZZ,RR) := (A,r,f) -> rawMatrixColumnScale(raw A,raw f,r,false)
columnMult(MutableMatrix,ZZ,CC) := (A,r,f) -> rawMatrixColumnScale(raw A,raw f,r,false)

rowAdd = method()
rowAdd(MutableMatrix,ZZ,RingElement,ZZ) := (A,r,f,i) -> 
    rawMatrixRowChange(raw A,r,raw f,i,false)
rowAdd(MutableMatrix,ZZ,ZZ,ZZ) := (A,r,f,i) -> 
    rawMatrixRowChange(raw A,r,raw f,i,false)
rowAdd(MutableMatrix,ZZ,QQ,ZZ) := (A,r,f,i) -> 
    rawMatrixRowChange(raw A,r,raw f,i,false)
rowAdd(MutableMatrix,ZZ,RR,ZZ) := (A,r,f,i) -> 
    rawMatrixRowChange(raw A,r,raw f,i,false)
rowAdd(MutableMatrix,ZZ,CC,ZZ) := (A,r,f,i) -> 
    rawMatrixRowChange(raw A,r,raw f,i,false)

columnAdd = method()
columnAdd(MutableMatrix,ZZ,RingElement,ZZ) := (A,r,f,i) -> 
    rawMatrixColumnChange(raw A,r,raw f,i,false)
columnAdd(MutableMatrix,ZZ,ZZ,ZZ) := (A,r,f,i) -> 
    rawMatrixColumnChange(raw A,r,raw f,i,false)
columnAdd(MutableMatrix,ZZ,QQ,ZZ) := (A,r,f,i) -> 
    rawMatrixColumnChange(raw A,r,raw f,i,false)
columnAdd(MutableMatrix,ZZ,RR,ZZ) := (A,r,f,i) -> 
    rawMatrixColumnChange(raw A,r,raw f,i,false)
columnAdd(MutableMatrix,ZZ,CC,ZZ) := (A,r,f,i) -> 
    rawMatrixColumnChange(raw A,r,raw f,i,false)

randomMutableMatrix = method(Options=>{Dense=>false})

randomMutableMatrix(ZZ,ZZ,RR,ZZ) := options -> (n,m,percentagezero,maxentry) -> (
    M := mutableZero(ZZ,n,m,options);
    randomentry := () -> (
        x := random 1.0;
        if x < percentagezero then 0
        else (random (2*maxentry)) - maxentry);
    scan(n, r-> scan(m, c-> (
	a := randomentry();
	if a != 0 then M_(r,c) = a)));
    M)

LU = method()
LU MutableMatrix := (A) -> (
     nrows := rawNumberOfRows raw A;
     P := mutableZero(RR,nrows,nrows);
     rawLU(raw A, raw P, raw P, raw P);
     P)

solve = method()
solve(MutableMatrix,MutableMatrix) := (A,b) -> (
     x := mutableZero(ring A,0,0);
     rawSolve(raw A,raw b,raw x);
     x)
solve(Matrix,Matrix) := (A,b) -> (
     matrix solve(mutableMatrix(A,Dense=>true),
                  mutableMatrix(b,Dense=>true)))

eigenvalues = method(Options => {Hermitian => false})
eigenvalues(MutableMatrix) := o -> (A) -> (
     if ring A =!= RR and ring A =!= CC then
       error "eigenvalues requires matrices over RR or CC";
     e := if o.Hermitian 
          then mutableZero(RR,0,0)
          else mutableZero(CC,0,0);
     rawEigenvalues(raw A,raw e,o.Hermitian);
     e)
eigenvalues(Matrix) := o -> (A) -> (
     matrix eigenvalues(mutableMatrix(A,Dense=>true),o))

eigenvectors = method(Options => {Hermitian => false})
eigenvectors(MutableMatrix) := o -> (A) -> (
     if ring A =!= RR and ring A =!= CC then
       error "eigenvalues requires matrices over RR or CC";
     e := if o.Hermitian 
          then mutableZero(RR,0,0, Dense=>true)
          else mutableZero(CC,0,0, Dense=>true);
     v := if ring A === RR and o.Hermitian
          then mutableZero(RR,0,0, Dense=>true)
	  else mutableZero(CC,0,0, Dense=>true);
     rawEigenvectors(raw A,raw e,raw v,o.Hermitian);
     (e,v))
eigenvectors(Matrix) := o -> (A) -> (
     (e,v) := eigenvectors(mutableMatrix(A,Dense=>true),o);
     (matrix e, matrix v))

SVD = method(Options=>{DivideConquer=>false})
SVD MutableMatrix := o -> A -> (
     if ring A =!= RR and ring A =!= CC then
       error "eigenvalues requires matrices over RR or CC";
     Sigma := mutableZero(RR,0,0);
     U := if ring A === RR then mutableZero(RR,0,0) else mutableZero(CC,0,0);
     VT := if ring A === RR then mutableZero(RR,0,0) else mutableZero(CC,0,0);
     rawSVD(raw A, raw Sigma, raw U, raw VT, o.DivideConquer);
     (Sigma,U,VT))
SVD Matrix := o -> A -> (
     A = mutableMatrix(A,Dense=>true);
     (Sigma,U,VT) := SVD(A,o);
     (matrix Sigma,matrix U,matrix VT))
     
     

testLU = (f) -> (
     g := mutableMatrix(f);
     nrows := rawNumberOfRows(raw g);
     ncols := rawNumberOfColumns(raw g);
     P := map(RR,rawMutableIdentity(raw RR,nrows,true));
     L := map(RR,rawMutableIdentity(raw RR,nrows,true));
     U := map(RR,rawMutableIdentity(raw RR,nrows,true));
     time rawLU(raw g, raw P, raw P, raw P);
     time for i from 0 to nrows-1 do
       for j from 0 to ncols-1 do
          if j >= i then U_(i,j) = g_(i,j)
	  else L_(i,j) = g_(i,j);
--     (matrix entries L, matrix entries U, matrix entries P))
     time (new Matrix from L, new Matrix from U, new Matrix from P))

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/m2 "
-- End:
