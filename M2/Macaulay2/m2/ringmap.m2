--		Copyright 1995-2000 by Daniel R. Grayson

RingMap = new Type of MutableHashTable
RingMap.synonym = "ring map"
toString RingMap := f -> concatenate(
     "map(", toString target f, ",", toString source f, ",", toString first entries f.matrix, ")"
     )
net RingMap := f -> horizontalJoin(
     "map(", net target f, ",", net source f, ",", net first entries f.matrix, ")"
     )
expression RingMap := f -> new FunctionApplication from {
     map, expression (target f, source f, f.matrix)}

map(Ring,Ring,Matrix) := RingMap => options -> (R,S,m) -> (
     degmap := (
	  if options.DegreeMap =!= null then (
	       if degreeLength R =!= # (options.DegreeMap apply(degreeLength S, i -> 0))
	       then error ("expected DegreeMap function to transform a degree of length ", 
		    toString degreeLength S,
		    " into a degree of length ", toString degreeLength R);
	       options.DegreeMap
	       )
	  else if degreeLength R === degreeLength S then identity
	  else (
	       d := toList ( degreeLength R : 0 );
	       e -> d
	       ));
     if (     ring m === (try coefficientRing R)
     	  and ring m === (try coefficientRing S)
     	  and isFreeModule target m
     	  and isFreeModule source m
	  ) then m = vars R * (m ** R);
     if isFreeModule target m
     and isFreeModule source m
     and 1 == numgens target m 
     and ring m === R
     then (
	  n := 0;
	  ultimate( A -> (
		    r := numgens source m;
		    if r === n 
		    then m = vars A ** R | m
		    else if r < n
		    then error ("encountered values for ", toString r, " variables");
		    n = n + numgens A;
		    coefficientRing A),
	       S);
	  if n != numgens source m 
	  then error ("encountered values for ", toString numgens source m," variables");
	  new RingMap from {
	       symbol source => S,
	       symbol target => R,
	       symbol matrix => m,
	       symbol handle => newHandle(ggPush m, ggringmap),
	       symbol DegreeMap => degmap
	       }
	  )
     else error (
	  if try coefficientRing R === try coefficientRing S
	  then (
	       "expected a 1 by ", numgens S, " matrix over ", toString R, 
	       " or a ", numgens R, " by ", numgens S, " matrix over ", toString coefficientRing S
	       )
	  else ( "expected a 1 by ", numgens S, " matrix over ", toString R )
	  )
     )

map(Ring,Matrix) := RingMap => options -> (S,m) -> map(ring m,S,m)

map(Ring,Ring) := RingMap => options -> (S,R) -> (
     A := R; v := {}; while (
	  if A.?generators then (
	       v = join(apply(A.generators, x -> (
			      x = toString x;
			      if S#?x then S#x else 0_S
			      )), v));
	  A.?ring) do A = A.ring;
     map(S,R,matrix (S,{v})))

map(Ring,Ring,List) := RingMap => options -> (R,S,m) -> map(R,S,matrix(R,{m}),options)

RingMap.AfterPrint = RingMap.AfterNoPrint = f -> (
     << endl;				  -- double space
     << "o" << lineNumber() << " : " << class f;
     << " " << target f << " <--- " << source f << endl;
     )

RingMap RingElement := RingElement => fff := (p,m) -> (
     R := source p;
     S := target p;
     if R =!= ring m then (
	  m = promote(m,R);
	  );
     sendgg(ggPush p, ggPush m, ggev);
     S.pop())

RingMap QQ := RingMap ZZ := (p,m) -> fff(p, promote(m,source p))

RingMap Vector := Vector => (p,m) -> (
     M := class m;
     R := source p;
     S := target p;
     if R =!= ring m 
     then error "expected source of ring map to be the same as ring of matrix";
     F := p M;
     sendgg(ggPush p, ggPush F, ggPush m, ggev);
     new F)

RingMap Matrix := Matrix => (p,m) -> (
     R := source p;
     S := target p;
     if R =!= ring m 
     then error "expected source of ring map to be the same as ring of matrix";
     F := p target m;
     E := p source m;
     sendgg(ggPush p, ggPush F, ggPush m, ggev);
     f := getMatrix S;
     map(F,E,f, Degree => p.DegreeMap degree m))

kernel RingMap := Ideal => options -> (f) -> if f.?kernel then f.kernel else f.kernel = (
     R := source f;
     n2 := numgens R;
     F := target f;
     n1 := numgens F;
     if class F === FractionField then (
	  C := last F.baseRings;
	  if not isHomogeneous f.matrix then error "not implemented yet";
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
	  k := coefficientRing R;
	  d := symbol d;
	  h := symbol h;
	  x := symbol x;
	  y := symbol y;
	  S := k[x_1 .. x_n1, d, y_1 .. y_n2, h,
	       MonomialOrder => Eliminate (n1 + 1),
	       Degrees => join(
		    apply(C.generators, degree), {{1}}, 
		    apply(R.generators, degree), {{1}})];
	  in1 := map(S,C,matrix {take (generators S, n1)});
	  in2 := map(S,R,matrix {take (generators S, {n1 + 1, n1 + n2})});
	  back := map(R,S,map(R^1,R^(n1 + 1),0) | vars R | 1 );
	  ideal back selectInSubring( 1, 
	       generators gb(
		    homogenize (
	       		 in2 vars source in2 - d * in1 matrix {apply(images, first)}
	       		 | d * in1 commonDenominator - 1,
	       		 h),
		    Strategy => LongPolynomial, options)))
     else if (
	  isAffineRing R
	  and isAffineRing F
	  and coefficientRing R === coefficientRing F
	  ) 
     then (
	  JJ := gens graphIdeal(f,
	       MonomialOrder => Eliminate n1, 
	       MonomialSize => 16,
	       VariableBaseName => local X);
	  if isHomogeneous JJ then (
	      hf := poincare (target f)^1;
	      T := (ring hf)_0;
	      hf = hf * product(numgens source JJ, i -> (
			d := (degrees source JJ)#i#0; 
			1 - T^d));
	      (cokernel JJ).poincare = hf;
	      );
	  mapback := map(R, ring JJ, map(R^1, R^n1, 0) | vars R);
	  ideal mapback selectInSubring(1,generators gb(JJ,options))
	  )
     else error "not implemented yet"
     )

image RingMap := coimage RingMap := QuotientRing => f -> f.source / kernel f

RingMap * RingMap := RingMap => (g,f) -> (
     if source g != target f then error "ring maps not composable";
     m := g f.matrix;
     new RingMap from {
	  symbol source => source f,
	  symbol target => target g,
	  symbol matrix => m,
	  symbol handle => newHandle(ggPush m, ggringmap),
	  symbol DegreeMap => g.DegreeMap @@ f.DegreeMap
	  }
     )

isHomogeneous RingMap := (f) -> (
     R := f.source;
     S := f.target;
     isHomogeneous R and isHomogeneous S and
     all(allGenerators R, r -> degree f r === f.DegreeMap degree r))

sub = substitute

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
substitute(RingElement,Ring) := RingElement => (r,S) -> (map(S,ring r)) r

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

sub2 := (R,v) -> (
     m := generators R;
     A := R;
     while (
	  A = try coefficientRing A;
	  A =!= null
	  ) do m = join(generators A, m);
     h := hashTable apply(#m, i -> m#i => i);
     m = new MutableList from m;
     scan(v, opt -> (
	       if class opt =!= Option or #opt =!= 2 then error "expected a list of options";
	       x := opt#0;
	       y := opt#1;
	       if not h#?x then error( "expected ", toString x, " to be a generator of ", toString R );
	       m#(h#x) = y)
	  );
     f := matrix{toList m};
     S := ring f;
     map(S,R,f))

substitute(Matrix,List) := Matrix => (f,v) -> (sub2(ring f,v)) f
substitute(Module,List) := Module => (M,v) -> (sub2(ring M,v)) M
substitute(Ideal,List) := Ideal => (I,v) -> (sub2(ring I,v)) I
substitute(Vector,List) := Vector => (f,v) -> (sub2(ring f,v)) f
substitute(RingElement,List) := RingElement => (f,v) -> (sub2(ring f,v)) f

substitute(Matrix,Option) := (f,v) -> (sub2(ring f,{v})) f
substitute(Module,Option) := (M,v) -> (sub2(ring M,{v})) M
substitute(Ideal,Option) := (I,v) -> (sub2(ring I,{v})) I
substitute(Vector,Option) := (f,v) -> (sub2(ring f,{v})) f
substitute(RingElement,Option) := (f,v) -> (sub2(ring f,{v})) f

RingElement Array := (r,v) -> substitute(r,matrix {toList v})

RingMap Ideal := Ideal => (f,I) -> ideal f module I

fixup := (f) -> if isHomogeneous f then f else map(target f,,f)

RingMap Module := Module => (f,M) -> (
     R := source f;
     S := target f;
     if R =!= ring M then error "expected module over source ring";
     if M.?relations then error "ring map applied to module with relations: use '**' instead";
     if M.?generators then cokernel f M.generators
     else S^-(f.DegreeMap \ degrees M))

RingMap ** Module := Module => (f,M) -> (
     R := source f;
     S := target f;
     if R =!= ring M then error "expected module over source ring";
     cokernel f(presentation M));

isInjective RingMap := (f) -> kernel f == 0
