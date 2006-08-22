--		Copyright 1993-2002 by Daniel R. Grayson

-----------------------------------------------------------------------------

Monoid = new Type of Type
Monoid.synonym = "monoid"
use Monoid := x -> ( if x.?use then x.use x; x)

options Monoid := x -> null

baseName Symbol := identity

OrderedMonoid = new Type of Monoid
OrderedMonoid.synonym = "ordered monoid"
degreeLength OrderedMonoid := M -> M.degreeLength

-----------------------------------------------------------------------------

terms := symbol terms
PolynomialRing = new Type of EngineRing
PolynomialRing.synonym = "polynomial ring"

isPolynomialRing = method(TypicalValue => Boolean)
isPolynomialRing Thing := x -> false
isPolynomialRing PolynomialRing := (R) -> true

exponents RingElement := (f) -> listForm f / ( (monom,coeff) -> monom )

describe PolynomialRing := R -> net expression R
expression PolynomialRing := R -> (
     k := last R.baseRings;
     (expression if ReverseDictionary#?k then ReverseDictionary#k else k) (expression monoid R)
     )

tex PolynomialRing := R -> "$" | texMath R | "$"	    -- silly!

texMath PolynomialRing := R -> (
     if R.?tex then R.tex
     else if ReverseDictionary#?R then "\\text{" | toString ReverseDictionary#R  | "}"
     else (texMath last R.baseRings)|(texMath expression monoid R)
     )

net PolynomialRing := R -> (
     if ReverseDictionary#?R then toString ReverseDictionary#R
     else net expression R)
toString PolynomialRing := R -> (
     if ReverseDictionary#?R then toString ReverseDictionary#R
     else toString expression R)
toExternalString PolynomialRing := R -> toString expression R

degreeLength PolynomialRing := (RM) -> degreeLength monoid RM

protect basering
protect flatmonoid

degreesRing ZZ := PolynomialRing => memoize(
     (n) -> (
	  local ZZn;
	  local Zn;
	  if n == 0 then (
	       ZZn = new PolynomialRing from rawPolynomialRing();
	       ZZn.basering = ZZ;
	       ZZn.flatmonoid = ZZn.monoid = monoid[];
	       ZZn.numallvars = 0;
	       ZZn.baseRings = {ZZ};
	       ZZn.Adjust = identity;
	       ZZn.Repair = identity;
	       ZZn.degreesRing = ZZn;
	       ZZn.isCommutative = true;
	       ZZn.generatorSymbols = {};
	       ZZn.generatorExpressions = {};
	       ZZn.generators = {};
	       ZZn.indexSymbols = new HashTable;
	       ZZn.indexStrings = new HashTable;
	       ZZn)
	  else ZZ degreesMonoid n))

degreesRing PolynomialRing := PolynomialRing => R -> (
     if R.?degreesRing then R.degreesRing
     else degreesRing degreeLength R)

degreesRing Ring := R -> error "no degreesRing for this ring"

generators PolynomialRing := R -> R.generators
coefficientRing PolynomialRing := Ring => R -> last R.baseRings
allGenerators PolynomialRing := (stashValue symbol allGenerators) (R -> join(generators R, apply(allGenerators coefficientRing R, a -> a * 1_R)))
isHomogeneous PolynomialRing := R -> (
     k := coefficientRing R;
     isField k or isHomogeneous k)

standardForm RingElement := (f) -> (
     R := ring f;
     k := coefficientRing R;
     (cc,mm) := rawPairs(raw k, raw f);
     new HashTable from toList apply(cc, mm, (c,m) -> (standardForm m, new k from c)))

-- this way turns out to be much slower by a factor of 10
-- standardForm RingElement := (f) -> (
--      R := ring f;
--      k := coefficientRing R;
--      (mm,cc) := coefficients f;
--      new HashTable from apply(
-- 	  flatten entries mm / leadMonomial / raw / standardForm,
-- 	  flatten entries lift(cc, k),
-- 	  identity))

listForm = method()
listForm RingElement := (f) -> (
     R := ring f;
     n := numgens R;
     k := coefficientRing R;
     (cc,mm) := rawPairs(raw k, raw f);
     toList apply(cc, mm, (c,m) -> (exponents(n,m), new k from c)))

-- this way turns out to be much slower by a factor of 10
-- listForm RingElement := (f) -> (
--      R := ring f;
--      k := coefficientRing R;
--      (mm,cc) := coefficients f;
--      reverse apply(
-- 	  flatten entries mm / leadMonomial / exponents,
-- 	  flatten entries lift(cc, k),
-- 	  identity))

protect diffs0						    -- private keys for storing info about indices of WeylAlgebra variables
protect diffs1

protect indexStrings
protect generatorSymbols
protect generatorExpressions
protect indexSymbols

Ring OrderedMonoid := PolynomialRing => (			  -- no memoize
     (R,M) -> (
	  if not M.?RawMonoid then error "expected ordered monoid handled by the engine";
	  if not R.?RawRing then error "expected coefficient ring handled by the engine";
     	  num := numgens M;
	  (basering,flatmonoid,numallvars) := (
	       if R.?isBasic then (R,M,num)
	       else if R.?basering and R.?flatmonoid 
	       then ( 
		    R.basering, 
		    tensor(M, R.flatmonoid, Degrees => degrees M | toList ( numgens R.flatmonoid : toList (degreeLength M : 0))),
		    num + R.numallvars)
	       else if instance(R,FractionField) then (R,M,num)
	       else error "internal error: expected coefficient ring to have a base ring and a flat monoid"
	       );
     	  local RM;
	  quotfix := rawRM -> if isQuotientOf(PolynomialRing,R) then rawQuotientRing(rawRM, raw R) else rawRM;
	  Weyl := M.Options.WeylAlgebra =!= {};
	  skews := monoidIndices(M,M.Options.SkewCommutative);
	  degRing := if degreeLength M != 0 then degreesRing degreeLength M else ZZ;
	  coeffOptions := options R;
	  coeffWeyl := coeffOptions =!= null and coeffOptions.WeylAlgebra =!= {};
	  coeffSkew := coeffOptions =!= null and coeffOptions.SkewCommutative =!= {};
	  if Weyl or coeffWeyl then (
	       if Weyl and R.?SkewCommutative then error "coefficient ring has skew commuting variables";
	       if Weyl and skews =!= {} then error "skew commutative Weyl algebra requested";
	       diffs := M.Options.WeylAlgebra;
	       if class diffs === Option then diffs = {diffs}
	       else if class diffs =!= List then error "expected list as WeylAlgebra option";
	       diffs = apply(diffs, x -> if class x === Option then toList x else x);
	       h    := select(diffs, x -> class x =!= List);
	       if #h > 1 then error "WeylAlgebra: expected at most one homogenizing variable";
	       h = monoidIndices(M,h);
	       if #h === 1 then h = h#0 else h = -1;
     	       if R.?homogenize then (
		    if h == -1 then h = R.homogenize + num
		    else if R.homogenize + num =!= h then error "expected the same homogenizing variable";
		    )
	       else if coeffWeyl and h != -1 then error "coefficient Weyl algebra has no homogenizing variable";
	       diffs = select(diffs, x -> class x === List);
	       diffs = apply(diffs, x -> (
			 if #x =!= 2 then error "WeylAlgebra: expected x=>dx, {x,dx}";
			 if class x#0 === Sequence and class x#1 === Sequence
			 then (
			      if #(x#0) =!= #(x#1) then error "expected sequences of the same length";
			      mingle x
			      )
			 else toList x
			 ));
	       diffs = flatten diffs;
	       local diffs0; local diffs1;
	       diffs = pack(2,diffs);
	       diffs0 = monoidIndices(M,first\diffs);
	       diffs1 = monoidIndices(M,last\diffs);
	       if any(values tally join(diffs0,diffs1), n -> n > 1) then error "WeylAlgebra option: a variable specified more than once";
	       if coeffWeyl then (
		    diffs0 = join(diffs0, apply(R.diffs0, i -> i + num));
		    diffs1 = join(diffs1, apply(R.diffs1, i -> i + num));
		    );
	       scan(diffs0,diffs1,(x,dx) -> if not x<dx then error "expected differentiation variables to occur to the right of their variables");
	       RM = new PolynomialRing from quotfix rawWeylAlgebra(rawPolynomialRing(raw basering, raw flatmonoid),diffs0,diffs1,h);
	       RM.diffs0 = diffs0;
	       RM.diffs1 = diffs1;
     	       addHook(RM, QuotientRingHook, S -> (S.diffs0 = diffs0; S.diffs1 = diffs1));
     	       if h != -1 then RM.homogenize = h;
	       )
	  else if skews =!= {} or R.?SkewCommutative then (
	       if R.?diffs0 then error "coefficient ring is a Weyl algebra";
	       if R.?SkewCommutative then skews = join(skews, apply(R.SkewCommutative, i -> i + num));
	       RM = new PolynomialRing from quotfix rawSkewPolynomialRing(rawPolynomialRing(raw basering, raw flatmonoid),skews);
	       RM.SkewCommutative = skews;
	       )
	  else (
	       log := FunctionApplication {rawPolynomialRing, (raw basering, raw flatmonoid)};
	       RM = new PolynomialRing from quotfix value log;
	       RM#"raw creation log" = Bag {log};
	       );
	  RM.basering = basering;
	  RM.flatmonoid = flatmonoid;
	  RM.numallvars = numallvars;
	  RM.promoteDegree = makepromoter degreeLength M;
	  RM.liftDegree = makepromoter degreeLength R;
	  RM.baseRings = append(R.baseRings,R);
	  commonEngineRingInitializations RM;
	  RM.monoid = M;
	  RM.Adjust = (options M).Adjust;
	  RM.Repair = (options M).Repair;
	  RM.degreesRing = degRing;
	  RM.isCommutative = not Weyl and not RM.?SkewCommutative;
     	  ONE := RM#1;
	  if R.?char then RM.char = R.char;
-- monomial arithmetic is getting deprecated
--	  R * M := (r,m) -> new RM from rawTerm(RM.RawRing,raw r,m.RawMonomial);
--	  M * R := (m,r) -> new RM from rawTerm(RM.RawRing,raw r,m.RawMonomial);
--	  RM * M := (p,m) -> p * (R#1 * m);
--	  M * RM := (m,p) -> (R#1 * m) * p;
--	  M / RM := (m,f) -> (m * ONE) / f;
--	  M / R := (m,r) -> (m * ONE) / (r * ONE);
--	  RM / M := (f,m) -> f / (m * ONE);
--	  R / M := (r,m) -> (r * ONE) / (m * ONE);
--	  M % RM := (m,f) -> (m * ONE) % f;
--	  M % R := (m,r) -> (m * ONE) % (r * ONE);
--	  RM % M := (f,m) -> f % (m * ONE);
--	  R % M := (r,m) -> (r * ONE) % (m * ONE);
--	  R + M := (r,m) -> r * M#1 + R#1 * m;
--	  M + R := (m,r) -> r * M#1 + R#1 * m;
--	  RM + M := (p,m) -> p + R#1 * m;
--	  M + RM := (m,p) -> p + R#1 * m;
--	  R - M := (r,m) -> r * M#1 - R#1 * m;
--	  M - R := (m,r) -> R#1 * m - r * M#1;
--	  RM - M := (p,m) -> p - R#1 * m;
--	  M - RM := (m,p) -> R#1 * m - p;
	  RM _ M := (f,m) -> new R from rawCoefficient(R.RawRing, raw f, raw m);
	  expression RM := f -> (
	       (coeffs,monoms) -> (
		    if #coeffs === 0
		    then expression 0
		    else sum(coeffs,monoms, (a,m) -> expression (if a == 1 then 1 else new R from a) * expression (if m == 1 then 1 else new M from m))
		    )
	       ) rawPairs(raw R, raw f);
	  toString RM := toExternalString RM := x -> toString expression x;
	  factor RM := options -> f -> (
	       c := 1;
	       (facs,exps) := rawFactor raw f;	-- example value: ((11, x+1, x-1, 2x+3), (1, 1, 1, 1)); constant term is first, if there is one
     	       facs = apply(facs, p -> new RM from p);
	       if degree facs#0 === {0} then (
	       	    assert(exps#0 == 1);
		    c = facs#0;
		    facs = drop(facs,1);
		    exps = drop(exps,1);
		    );
	       if #facs != 0 then (facs,exps) = toSequence transpose sort transpose {toList facs, toList exps};
	       if c != 1 then (
		    -- c = lift(c,R); -- this is a bad idea, because code depends now on even the constant factor being in the poly ring
		    facs = append(facs,c);
		    exps = append(exps,1);
		    );
	       new Product from apply(facs,exps,(p,n) -> new Power from {p,n}));
	  isPrime RM := f -> (
	       v := factor f;				    -- constant term last
	       #v === 1 and last v#0 === 1 and not isConstant first v#0
	       or
	       #v === 2 and v#0#1 === 1 and isConstant first v#0 and v#1#1 === 1
	       );
	  RM.generatorSymbols = M.generatorSymbols;
	  RM.generatorExpressions = M.generatorExpressions;
	  RM.generators = apply(num, i -> RM_i);
	  RM.indexSymbols = new HashTable from join(
	       if R.?indexSymbols then apply(pairs R.indexSymbols, (nm,x) -> nm => new RM from rawPromote(raw RM,raw x)) else {},
	       apply(num, i -> M.generatorSymbols#i => RM_i)
	       );
     	  RM.indexStrings = applyKeys(RM.indexSymbols, toString);
	  RM.use = x -> (
--	       M + M := (m,n) -> R#1 * m + R#1 * n;
--	       M - M := (m,n) -> R#1 * m - R#1 * n;
--	       - M := (n) -> - R#1 * n;
--	       scan(RM.baseRings, A -> (
--		    if A =!= R then (
--		    	 A * M := (i,m) -> (i * R#1) * m;
--		    	 M * A := (m,i) -> m * (i * R#1);
--			 );
--		    A + M := (i,m) -> i * ONE + m * ONE;
--		    M + A := (m,i) -> m * ONE + i * ONE;
--		    A - M := (i,m) -> i * ONE - m * ONE;
--		    M - A := (m,i) -> m * ONE - i * ONE;
--		    M / A := (m,r) -> (m * ONE) / (r * ONE);
--		    A / M := (r,m) -> (r * ONE) / (m * ONE);
--		    M % A := (m,r) -> (m * ONE) % (r * ONE);
--		    A % M := (r,m) -> (r * ONE) % (m * ONE);
--		    ));
	       RM);
	  RM
	  )
     )

samering := (f,g) -> (
     if ring f =!= ring g then error "expected elements from the same ring";
     )

Ring Array := PolynomialRing => (R,variables) -> use R monoid variables
PolynomialRing _ List := (R,v) -> product ( #v , i -> R_i^(v#i) )
Ring _ List := RingElement => (R,w) -> product(#w, i -> (R_i)^(w_i))
dim PolynomialRing := R -> dim coefficientRing R + # generators R - if R.?SkewCommutative then #R.SkewCommutative else 0
char PolynomialRing := (R) -> char coefficientRing R
numgens PolynomialRing := R -> numgens monoid R
isSkewCommutative PolynomialRing := R -> (
     o := options R;
     0 < #o.SkewCommutative and 0 == #o.WeylAlgebra)

weightRange = method()
weightRange(List,RingElement) := (w,f) -> rawWeightRange(w,raw f)

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/m2 "
-- End:
