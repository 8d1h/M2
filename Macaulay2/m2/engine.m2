--		Copyright 1993-2002 by Daniel R. Grayson

-- basic type

PrintNames#RawObject = "RawObject"
RawObject.synonym = "raw object"
raw RawObject := x -> error "'raw' received a raw object"

-- monomials

PrintNames#RawMonomial = "RawMonomial"
RawMonomial.synonym = "raw monomial"

RawMonomial == RawMonomial := (x,y) -> x === y
RawMonomial : RawMonomial := (x,y) -> rawColon(x,y)
ZZ == RawMonomial := (i,x) -> x == i

standardForm RawMonomial := m -> new HashTable from toList rawSparseListFormMonomial m
expression RawMonomial := x -> (
     v := rawSparseListFormMonomial x;
     if #v === 0 then expression 1
     else new Product from apply(v, (i,e) -> new Power from {vars i, e})
     )
exponents(ZZ,RawMonomial) := (nvars,x) -> (
     z := new MutableList from (nvars : 0);
     scan(rawSparseListFormMonomial x, (i,e) -> z#i = z#i + e);
     toList z)
net RawMonomial := x -> net expression x
degree RawMonomial := x -> error "degree of raw monomial not defined (no monoid)"
gcd(RawMonomial,RawMonomial) := (x,y) -> rawGCD(x,y)

-- monomial orderings

PrintNames#RawMonomialOrdering = "RawMonomialOrdering"
RawMonomialOrdering.synonym = "raw monomial ordering"

Eliminate = new SelfInitializingType of BasicList
new Eliminate from ZZ := (Eliminate,n) -> Eliminate {n}
expression Eliminate := v -> (
     if #v === 1 
     then new FunctionApplication from {Eliminate, v#0}
     else new FunctionApplication from {Eliminate, toList v})
ProductOrder = new SelfInitializingType of BasicList

net RawMonomialOrdering := o -> stack lines toString o

isSmall := i -> class i === ZZ and i < 2^15 and i > -2^15
isCount := i -> class i === ZZ and i >= 0 and i < 2^15
isListOfIntegers := x -> class x === List and all(x,i -> class i === ZZ)
isListOfListsOfIntegers := x -> class x === List and all(x,isListOfIntegers)
checkCount := i -> if not isCount i then error "expected a small positive integer"

fixup := method(SingleArgumentDispatch => true)
err := o -> error ("unrecognized ordering option " | toString o)

deglist := {}						    -- filled in below each time
getdegs := (m,n) -> (
     -- get m-th through n-th degree, using 1 when there aren't enough
     join ( take(deglist, {m,n}), (n - (#deglist - 1)):1)
     )
numvars := 0						    -- re-initialized below each time
varcount := 0						    -- re-initialized below each time
MonSize := 32						    -- re-initialized below each time
invert := false	    					    -- re-initialized below each time
bump := n -> varcount = varcount + n
optionSizes := hashTable {
     (Lex,8) => LexTiny,
     (Lex,16) => LexSmall,
     (GRevLex,8) => GRevLexTiny,
     (GRevLex,16) => GRevLexSmall
     }
fix := key -> if optionSizes#?(key,MonSize) then optionSizes#(key,MonSize) else key
warn := key -> (
     newkey := GroupRevLex;
     stderr << "--warning: for rawMonomialOrdering, replacing monomial ordering " << key << " by " << newkey << endl;
     newkey)
optionInverses := hashTable {
     Lex => key -> GroupLex,
     RevLex => key -> GroupRevLex,
     GRevLex => warn
     }
fix1 := key -> if invert and optionInverses#?key then optionInverses#key key else key
intOption := (key,n) -> (
     key = fix fix1 key;
     checkCount n;
     bump n;
     key => n)
ensurePositiveWeights := i -> if i <= 0 then 1 else i
grevOption := (key,v) -> (
     key = fix key;
     if class v === ZZ then grevOption (key,ensurePositiveWeights \ getdegs(varcount, varcount+v-1))
     else if isListOfIntegers(v) then (
	  scan(v, i -> if i <= 0 then error "expected positive weights");
	  bump(#v);
	  key => v)
     else error "expected an integer or a list of integers")
optionFixes := hashTable {
     Weights => (key,val) -> key => val,
     Position => (key,val) -> key => val,
     Lex => intOption,
     LexSmall => intOption,
     LexTiny => intOption,
     RevLex => intOption,
     GroupLex => intOption,
     GroupRevLex => intOption,
     NCLex => intOption,
     GRevLex => grevOption,
     GRevLexSmall => grevOption,
     GRevLexTiny => grevOption
     }
     
ordOption := o -> fixup ( o => numvars - varcount )
symbolFixes := hashTable {
     Position => o -> Component => null,
     GLex => o -> (Weights => numvars:1, fixup Lex),
     RevLex => ordOption,
     GRevLex => ordOption,
     Lex => ordOption,
     GRevLexSmall => ordOption,
     LexSmall => ordOption,
     GRevLexTiny => ordOption,
     LexTiny => ordOption
     }

fixup Thing := err
fixup List := v -> toSequence v / fixup
fixup Sequence := v -> v / fixup
fixup Eliminate := e -> Weights => getdegs(0, e#0-1)
fixup ProductOrder := o -> fixup(toSequence o / (i -> GRevLex => i))
fixup Symbol := o -> if symbolFixes#?o then symbolFixes#o o else err o
fixup ZZ := n -> fixup( GRevLex => n )
fixup Option := o -> (
     key := o#0;
     val := o#1;
     if optionFixes#?key then optionFixes#key (key,val)
     else error ("unrecognized ordering option keyword : " | toString key)
     )

makeMonomialOrdering = (monsize,inverses,nvars,degs,weights,ordering) -> (
     -- 'monsize' is the old MonomialSize option, usually 8 or 16, or 'null' if unset
     -- 'inverses' is true or false, and tells whether the old "Inverses => true" option was used.
     -- 'nvars' tells the total number of variables, as a minimum, meaning it could be 0 if
     --      you don't know.  Any extra variables will be ordered with GRevLex or GroupLex.
     -- 'degs' is a list of integers, the first components of the multi-degrees of the variables
     --      if it's too short, additional degrees are taken to be 1.  Could be an empty list.
     -- 'weights' is the list of integers or the list of lists of integers provided by the user under
     --    the *separate* Weights option.  Could be an empty list.
     -- 'ordering' is a list of ordering options, e.g., { Lex => 4, GRevLex => 4 }
     --    If it's not a list, we'll make a list of one element from it.
     if monsize =!= null then (
	  if class monsize =!= ZZ then error "expected an integer as MonomialSize option";
	  if monsize <= 8 then MonSize = 8
	  else if monsize <= 16 then MonSize = 16
	  else MonSize = 32);
     invert = inverses;
     if not isListOfIntegers degs then error "expected a list of integers";
     deglist = degs;
     varcount = 0;
     numvars = nvars;
     if isListOfListsOfIntegers weights then ()
     else if isListOfIntegers weights then weights = {weights}
     else error "expected a list of integers or a list of lists of small integers";
     if class ordering =!= List then ordering = {ordering};
     ordering = join(weights / (i -> Weights => i), ordering);
     t := toList splice fixup ordering;
     if varcount < nvars then t = append(t,fixup(GRevLex => nvars - varcount));
     (t,rawMonomialOrdering t))

RawMonomialOrdering ** RawMonomialOrdering := RawMonomialOrdering => rawProductMonomialOrdering

-- monoids

PrintNames#RawMonoid = "RawMonoid"
RawMonoid.synonym = "raw monoid"
net RawMonoid := o -> stack lines toString o

-- rings

PrintNames#RawRing = "RawRing"
RawRing.synonym = "raw ring"
net RawRing := o -> stack lines toString o
ZZ.RawRing = rawZZ()

-- ring elements (polynomials)

PrintNames#RawRingElement = "RawRingElement"
RawRingElement.synonym = "raw ring element"
RawRingElement == RawRingElement := (x,y) -> x === y

RawRing _ ZZ := (R,n) -> rawRingVar(R,n)
ZZ _ RawRing := (n,R) -> rawFromNumber(R,n)
raw RR := x -> x _ (RR.RawRing)
RR _ RawRing := (n,R) -> rawFromNumber(R,n)
RRR _ RawRing := (n,R) -> rawFromNumber(R,n)
RawRingElement _ RawRing := (x,R) -> rawPromote(R,x)

RawRingElement == RawRingElement := (x,y) -> x === y

ring RawRingElement := rawRing
degree RawRingElement := rawMultiDegree
denominator RawRingElement := rawDenominator
numerator RawRingElement := rawNumerator
isHomogeneous RawRingElement := rawIsHomogeneous
fraction(RawRing,RawRingElement,RawRingElement) := rawFraction

RawRingElement + ZZ := (x,y) -> x + y_(rawRing x)
ZZ + RawRingElement := (y,x) -> y_(rawRing x) + x
RawRingElement - ZZ := (x,y) -> x - y_(rawRing x)
ZZ - RawRingElement := (y,x) -> y_(rawRing x) - x
RawRingElement * ZZ := (x,y) -> x * y_(rawRing x)
ZZ * RawRingElement := (y,x) -> y_(rawRing x) * x
RawRingElement == ZZ := (x,y) -> if y === 0 then rawIsZero x else x === y_(rawRing x)
ZZ == RawRingElement := (y,x) -> if y === 0 then rawIsZero x else y_(rawRing x) === x

RawRingElement // ZZ := (x,y) -> x // y_(rawRing x)
ZZ // RawRingElement := (y,x) -> y_(rawRing x) // x

compvals := hashTable { 0 => symbol == , 1 => symbol > , -1 => symbol < }
comparison := n -> compvals#n
RawRingElement ? RawRingElement := (f,g) -> comparison rawCompare(f,g)

-- monomial ideals

PrintNames#RawMonomialIdeal = "RawMonomialIdeal"
RawMonomialIdeal.synonym = "raw monomial ideal"

-- free modules

PrintNames#RawFreeModule = "RawFreeModule"
RawFreeModule.synonym = "raw ring"

RawFreeModule ++ RawFreeModule := rawDirectSum

degrees RawFreeModule := rawMultiDegree

ZZ _ RawFreeModule := (i,F) -> (
     if i === 0 then rawZero(F,F,0)
     else error "expected integer to be 0"
     )

RawRing ^ ZZ := (R,i) -> rawFreeModule(R,i)
RawRing ^ List := (R,i) -> rawFreeModule(R,toSequence( - flatten splice i ))

rank RawFreeModule := rawRank

RawFreeModule == RawFreeModule := (v,w) -> v === w
RawFreeModule ** RawFreeModule := rawTensor

-- matrices

PrintNames#RawMatrix = "RawMatrix"
RawMatrix.synonym = "raw matrix"

PrintNames#RawMutableMatrix = "RawMutableMatrix"
RawMutableMatrix.synonym = "raw mutable matrix"

extract := method()

extract(RawMatrix,ZZ,ZZ) := 
extract(RawMutableMatrix,ZZ,ZZ) := (m,r,c) -> rawMatrixEntry(m,r,c)

extract(RawMatrix,Sequence,Sequence) := 
extract(RawMutableMatrix,Sequence,Sequence) := (m,r,c) -> rawSubmatrix(m,splice r,splice c)

RawMatrix _ Sequence := 
RawMutableMatrix _ Sequence := (m,rc) -> ((r,c) -> extract(m,r,c)) rc

RawMutableMatrix == RawMutableMatrix := RawMatrix == RawMatrix := rawIsEqual

RawMatrix == ZZ := RawMutableMatrix == ZZ := (v,n) -> if n === 0 then rawIsZero v else error "comparison with nonzero integer"
ZZ == RawMatrix := ZZ == RawMutableMatrix := (n,v) -> if n === 0 then rawIsZero v else error "comparison with nonzero integer"

net RawMatrix := o -> stack lines toString o
net RawMutableMatrix := o -> stack lines toString o
target RawMatrix := o -> rawTarget o
source RawMatrix := o -> rawSource o
transposeSequence := t -> pack(#t, mingle t)
isHomogeneous RawMatrix := rawIsHomogeneous
entries RawMutableMatrix := entries RawMatrix := m -> table(rawNumberOfRows m,rawNumberOfColumns m,(i,j)->rawMatrixEntry(m,i,j))

ZZ * RawMatrix := (n,f) -> (
     R := rawRing rawTarget f;
     n_R * f
     )
QQ * RawMatrix := (n,f) -> (
     R := rawRing rawTarget f;
     n_R * f
     )

RawMatrix ** RawMatrix := rawTensor

rawConcatColumns = (mats) -> rawConcat toSequence mats
rawConcatRows = (mats) -> rawDual rawConcat apply(toSequence mats,rawDual)
rawConcatBlocks = (mats) -> rawDual rawConcat apply(toSequence mats, row -> rawDual rawConcat toSequence (raw \ row))

new RawMatrix from RawRingElement := (RawMatrix,f) -> rawMatrix1(rawFreeModule(ring f,1),1,1:f,0)
new RawMatrix from RawMutableMatrix := rawMatrix
new RawMutableMatrix from RawMatrix := rawMutableMatrix

installAssignmentMethod(symbol "_",RawMutableMatrix,Sequence, (M,ij,val) -> ((i,j) -> rawSetMatrixEntry(M,i,j,val)) ij)

-- computations

PrintNames#RawComputation = "RawComputation"
RawComputation.synonym = "raw computation"
status RawComputation := opts -> c -> rawStatus1 c
RawComputation_ZZ := (C,i) -> rawResolutionGetMatrix(C,i)

-- Groebner bases

RawMatrix % RawComputation := (m,g) -> rawGBMatrixRemainder(g,m)

-- ring maps

PrintNames#RawRingMap = "RawRingMap"
RawRingMap.synonym = "raw ring map"

RawRingMap == RawRingMap := (v,w) -> v === w
net RawRingMap := o -> stack lines toString o

-- clean up


-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/m2 "
-- End:
