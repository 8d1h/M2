--		Copyright 1995-2002 by Daniel R. Grayson

RingMap = new Type of HashTable
RingMap.synonym = "ring map"
matrix RingMap := opts -> f -> f.matrix
toString RingMap := f -> concatenate(
     "map(", toString target f, ",", toString source f, ",", toString first entries matrix f, ")"
     )
net RingMap := f -> horizontalJoin(
     "map(", net target f, ",", net source f, ",", net first entries matrix f, ")"
     )
source RingMap := f -> f.source
target RingMap := f -> f.target
raw RingMap := f -> f.RawRingMap

expression RingMap := f -> new FunctionApplication from {
     map, expression (target f, source f, matrix f)}

degmap0 := n -> ( d := toList ( n : 0 ); e -> d )

map(Ring,Ring,Matrix) := RingMap => opts -> (R,S,m) -> (
     if not isFreeModule target m or not isFreeModule source m
     then error "expected a homomorphism between free modules";
     if ring m === (try coefficientRing R) and ring m === (try coefficientRing S)
     then (
	  if numgens R != rank target m
	  then error ("expected a matrix with ", toString numgens R, " rows");
	  m = vars R * (m ** R);   -- handle a change of coordinates
	  )
     else if ring m =!= R
     then error "expected a matrix over the target ring";
     if rank target m != 1
     then error "expected a matrix with 1 row";
     degmap := (
	  if opts.DegreeMap =!= null then (
	       if degreeLength R =!= # (opts.DegreeMap apply(degreeLength S, i -> 0))
	       then error ("expected DegreeMap function to transform a degree of length ", 
		    toString degreeLength S,
		    " into a degree of length ", toString degreeLength R);
	       opts.DegreeMap
	       )
	  else if degreeLength R === degreeLength S then identity
	  else degmap0 degreeLength R);
     mdegs := {};
     n := 0;
     A := S;
     record := new MutableHashTable; -- we should look for variables with the same symbol
     justonce := s -> (
	  if record#?s then error "map: multiple variables would map to the same variable, by name";
	  record#s = true;
	  R.indexSymbols#s);
     while true do (
	  mdegs = join(mdegs, promote(degrees A,A,S) / degmap);
	  r := numgens source m;
	  if r > n then (
	       if instance(A,GaloisField) then (
		    -- the engine wants to know where the primitive element will go
		    p := map(R,ambient A,m_(toList(n .. r-1)));
		    m' := new MutableMatrix from m;
		    m'_(0,n) = p A.PrimitiveElement;
		    m = matrix m';))
	  else if r < n then error ("encountered values for ", toString r, " variables, but expected ", toString n)
	  else if r == n then (
	       if numgens A > 0 then (
		    m = m |
		    if member(A, R.baseRings) then (
			 -- we can promote
			 if instance(A,GaloisField) then (
		    	      -- the engine wants to know where the primitive element will go
		    	      promote(A.PrimitiveElement, R)
			      )
			 else promote(vars A, R)
			 )
		    else (
			 mm := matrix(R, {apply(A.generatorSymbols, s -> if R.?indexSymbols and R.indexSymbols#?s then justonce s else 0_R)});
			 if instance(A,GaloisField) then (
			      -- the engine wants to know where the primitive element will go
			      matrix {{(map(R,ambient A,mm)) A.PrimitiveElement}}
			      )
			 else mm)));
	  n = n + numgens A;
	  try A = coefficientRing A else break
	  );
     if n != numgens source m then error ("encountered values for ", toString numgens source m," variables");
     zdeg  := toList ( degreeLength R : 0 );
     if degrees target m =!= {zdeg} or degrees source m =!= mdegs or degree m =!= zdeg then m = map(R^{zdeg}, R^-mdegs, m, Degree => zdeg);
     new RingMap from {
	  symbol source => S,
	  symbol target => R,
	  symbol matrix => m,
	  symbol RawRingMap => rawRingMap m.RawMatrix,
	  symbol DegreeMap => degmap,
	  symbol cache => new CacheTable
	  }
     )

map(Ring,Matrix) := RingMap => opts -> (S,m) -> map(ring m,S,m)

map(Ring,Ring) := RingMap => opts -> (S,R) -> map(S,R,{},opts)

Ring#id = (R) -> map(R,R,vars R)

RingMap.AfterPrint = RingMap.AfterNoPrint = f -> (
     << endl;				  -- double space
     << concatenate(interpreterDepth:"o") << lineNumber << " : " << class f;
     << " " << target f << " <--- " << source f << endl;
     )

RingMap RingElement := RingElement => fff := (p,m) -> (
     R := source p;
     S := target p;
     if R =!= ring m then (
	  m = promote(m,R);
	  );
     new S from rawRingMapEval(raw p, raw m))

RingMap Number := (p,m) -> fff(p, promote(m,source p))

RingMap Matrix := Matrix => (p,m) -> (
     R := source p;
     S := target p;
     if R =!= ring m 
     then error "expected source of ring map to be the same as ring of matrix";
     F := p target m;
     E := p source m;
     map(F,E,map(S,rawRingMapEval(raw p, raw F, raw m)), Degree => p.DegreeMap degree m))

RingMap Vector := Vector => (p,m) -> (
     f := p new Matrix from m;
     new target f from f)

kernel RingMap := Ideal => opts -> (cacheValue symbol kernel) (
     (f) -> (
	  R := source f;
	  n2 := numgens R;
	  F := target f;
	  n1 := numgens F;
	  if class F === FractionField then (
	       C := last F.baseRings;
	       if not (
		    (isPolynomialRing C or isQuotientOf(PolynomialRing,C))
		    and
		    (isPolynomialRing R or isQuotientOf(PolynomialRing,R))
		    and
		    coefficientRing R === coefficientRing C
		    ) then error "kernel: not implemented yet";
	       k := coefficientRing R;
	       prs := presentation C;
	       B := ring prs;
	       images := apply(generators R, x -> (
			 w := f x;
			 new Divide from {numerator w, denominator w} ));
	       -- now make a common denominator for all images
	       images = new MutableList from images;
	       i := 1;
	       while i < #images do (
		    z := syz(
			 matrix{{denominator images#0,denominator images#i}},
			 SyzygyLimit => 1 );
		    a := -z_(0,0);
		    b := z_(1,0);
		    j := 0;
		    while j < i do (
			 images#j = apply(images#j, s -> s*a);
			 j = j+1;
			 );
		    images#i = apply(images#i, s -> s*b);
		    i = i+1;
		    );
	       images = toList images;
	       commonDenominator := images#0#1;
	       d := symbol d;
	       h := symbol h;
	       x := symbol x;
	       y := symbol y;
	       S := k[x_1 .. x_n1, d, y_1 .. y_n2, h,
		    MonomialOrder => Eliminate (n1 + 1),
		    Degrees => join(
			 apply(generators C, degree), {{1}}, 
			 apply(generators R, degree), {{1}})];
	       in1 := map(S,C,matrix {take (generators S, n1)});
	       in2 := map(S,B,matrix {take (generators S, n1)});
	       in3 := map(S,R,matrix {take (generators S, {n1 + 1, n1 + n2})});
	       back := map(R,S,map(R^1,R^(n1 + 1),0) | vars R | 1 );
	       ideal back selectInSubring( 1, 
		    generators gb(
			 in2 prs |
			 homogenize (
			      in3 vars source in3 - d * in1 matrix {apply(images, first)}
			      | d * in1 commonDenominator - 1,
			      h),
			 Strategy => LongPolynomial, opts)))
	  else if (
	       isAffineRing R and instance(ambient R, PolynomialRing) and isField coefficientRing R
	       and isAffineRing F and instance(ambient F, PolynomialRing)
	       and coefficientRing R === coefficientRing F
	       ) 
	  then (
	       graph := generators graphIdeal f;
	       assert( not isHomogeneous f or isHomogeneous graph );
	       SS := ring graph;
	       chh := checkHilbertHint graph;
	       if chh then (
		   hf := poincare (target f)^1;
		   T := (ring hf)_0;
		   degs := degrees source graph;
		   hf = hf * product(numgens source graph, i -> 1 - T^(degs#i#0));
		   (cokernel graph).cache.poincare = hf;
		   );
	       mapback := map(R, ring graph, map(R^1, R^n1, 0) | vars R);
	       G := gb(graph,opts);
	       assert (not chh or G#?"rawGBSetHilbertFunction log"); -- ensure the Hilbert function hint was actually used in gb.m2
	       ideal mapback selectInSubring(1,generators G)
	       )
	  else (
	       numsame := 0;
	       while (
		    R.baseRings#?numsame and
		    F.baseRings#?numsame and 
		    R.baseRings#numsame === F.baseRings#numsame
		    )
	       do numsame = numsame + 1;
	       while not (
		    isField F.baseRings#(numsame-1)
		    or
		    F.baseRings#(numsame-1).?isBasic
		    )
	       do numsame = numsame - 1;
	       k = F.baseRings#(numsame-1);
	       (R',p) := flattenRing(R, CoefficientRing => k);
	       (F',r) := flattenRing(F, CoefficientRing => k);
	       if R' === R and F' === F then error "kernel Ringmap: not implemented yet";
	       p^-1 kernel (r * f * p^-1))))

coimage RingMap := QuotientRing => f -> f.source / kernel f

RingMap * RingMap := RingMap => (g,f) -> (
     if source g =!= target f then error "ring maps not composable";
     m := g matrix f;
     new RingMap from {
	  symbol source => source f,
	  symbol target => target g,
	  symbol matrix => m,
	  symbol RawRingMap => rawRingMap raw m,
	  symbol DegreeMap => g.DegreeMap @@ f.DegreeMap,
	  symbol cache => new CacheTable
	  }
     )

isHomogeneous RingMap := (f) -> (
     R := f.source;
     S := f.target;
     isHomogeneous R and isHomogeneous S and
     all(generators(R, CoefficientRing=>ZZ), r -> r == 0 or (
	       s := f r;
	       s == 0 or isHomogeneous s and degree s === f.DegreeMap degree r
	       )))

substitute(Power,Thing) := (v,s) -> Power{substitute(v#0,s),v#1}
substitute(Divide,Thing) := (v,s) -> Divide{substitute(v#0,s),substitute(v#1,s)}
substitute(Sum,Thing) := substitute(Product,Thing) := (v,s) -> apply(v,t -> substitute(t,s))

substitute(RingElement,Matrix) := RingElement => (r,f) -> (map(ring f,ring r,f)) r
substitute(Vector,Matrix) := Vector => (v,f) -> (map(ring f,ring v,f)) v
substitute(Matrix,Matrix) := Matrix => (m,f) -> (map(ring f,ring m,f)) m
substitute(Module,Matrix) := Module => (M,f) -> (map(ring f,ring M,f)) M
substitute(Ideal,Matrix) := Ideal => (I,f) -> (map(ring f,ring I,f)) I

substitute(Matrix,Ring) := Matrix => (m,S) -> (map(S,ring m)) m
substitute(Module,Ring) := Module => (M,S) -> (map(S,ring M)) M
substitute(Ideal,Ring) := Ideal => (I,S) -> (map(S,ring I)) I
substitute(Vector,Ring) := Vector => (v,S) -> (map(S,ring v)) v
substitute(Number,Ring) := substitute(RingElement,Ring) := RingElement => (r,S) -> (map(S,ring r)) r

substitute(Matrix,ZZ) := Matrix => (m,i) -> (
     R := ring m;
     if i === 0 then (
     	  if isPolynomialRing R 
	  or isQuotientRing R and isPolynomialRing ultimate(ambient,R)
	  then substitute(m,map(R^1, R^(numgens R), 0))
     	  else m
	  )
     else error "expected integer to be zero"
     )

sub2 = (S,R,v) -> (
     m := generators R;
     A := R;
     while try (A = coefficientRing A; true) else false
     do m = join(m, generators A);
     h := hashTable apply(#m, i -> m#i => i);
     m = new MutableList from m;
     scan(v, opt -> (
	       if class opt =!= Option or #opt =!= 2 then error "expected a list of options";
	       x := opt#0;
	       y := opt#1;
	       if not h#?x then error( "expected ", toString x, " to be a generator of ", toString R );
	       m#(h#x) = y)
	  );
     f := if S === null then matrix{toList m} else matrix(S,{toList m});
     map(ring f,R,f))

map(Ring,Ring,List) := RingMap => opts -> (S,R,m) -> (
     if #m>0 and all(m, o -> class o === Option) then sub2(S,R,m)
     else map(S,R,matrix(S,{m}),opts)
     )

substitute(Matrix,List) := Matrix => (f,v) -> (sub2(,ring f,v)) f
substitute(Module,List) := Module => (M,v) -> (sub2(,ring M,v)) M
substitute(Ideal,List) := Ideal => (I,v) -> (sub2(,ring I,v)) I
substitute(Vector,List) := Vector => (f,v) -> (sub2(,ring f,v)) f
substitute(RingElement,List) := RingElement => (f,v) -> (sub2(,ring f,v)) f

substitute(Matrix,Option) := (f,v) -> (sub2(,ring f,{v})) f
substitute(Module,Option) := (M,v) -> (sub2(,ring M,{v})) M
substitute(Ideal,Option) := (I,v) -> (sub2(,ring I,{v})) I
substitute(Vector,Option) := (f,v) -> (sub2(,ring f,{v})) f
substitute(RingElement,Option) := (f,v) -> (sub2(,ring f,{v})) f

RingElement Array := (r,v) -> substitute(r,matrix {toList v})

RingMap Ideal := Ideal => (f,I) -> ideal f module I

fixup := (f) -> if isHomogeneous f then f else map(target f,,f)

RingMap Module := Module => (f,M) -> (
     R := source f;
     S := target f;
     if R =!= ring M then error "expected module over source ring";
     if M.?relations then error "ring map applied to module with relations: use '**' or 'tensor' instead";
     if M.?generators then image f M.generators
     else (
	  d := degrees M;
	  e := f.DegreeMap \ d;
	  if R === S and d === e
	  then M -- use the same module if we can
     	  else S^-e
	  )
     )

RingMap ** Module := Module => (f,M) -> (
     R := source f;
     S := target f;
     if R =!= ring M then error "expected module over source ring";
     cokernel f presentation M);

RingMap ** Matrix := Matrix => (f,m) -> (
     if source f =!= ring m then error "expected matrix over source ring";
     map(f ** target m, f ** source m, f cover m))

tensor(Ring,RingMap,Module) := opts -> (S,f,M) -> (
     if S =!= target f then error "tensor: expected ring and target of ring map to be the same";
     f ** M)

tensor(Ring,RingMap,Matrix) := opts -> (S,f,m) -> (
     if S =!= target f then error "tensor: expected ring and target of ring map to be the same";
     f ** m)

tensor(RingMap,Module) := Module => opts -> (f,M) -> (
     R := source f;
     S := target f;
     if R =!= ring M then error "expected module over source ring";
     cokernel f presentation M);

tensor(RingMap,Matrix) := Matrix => opts -> (f,m) -> (
     if source f =!= ring m then error "expected matrix over source ring";
     map(f ** target m, f ** source m, f cover m))

isInjective RingMap := (f) -> kernel f == 0

preimage(RingMap,Ideal) := (f,J) -> (
     R := ring J;
     kernel ( map(R/J,R) * f ))

List / RingMap := List => (v,f) -> apply(v,x -> f x)
RingMap \ List := List => (f,v) -> apply(v,x -> f x)

RingMap == RingMap := (f,g) -> (
     f.target === g.target and
     f.source === g.source and 
     matrix f === matrix g and (
	  d := degreeLength f.source;
	  m := f.DegreeMap;
	  n := g.DegreeMap;
	  e := toList prepend(1, d-1 : 0);
	  null === for i from 1 to d do (
	       if m e =!= n e then break false;
	       e = rotate(1,e))))

RingMap == ZZ := (f,n) -> (
     if n == 1 then (source f === target f and f == id_(source f))
     else error "encountered integer other than 1 in comparison with a ring map")

ZZ == RingMap := (n,f) -> f == n

RingMap.InverseMethod = (cacheValue symbol inverse) ( f -> notImplemented() )
RingMap ^ ZZ := BinaryPowerMethod

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/m2 "
-- End:
