--		Copyright 1995 by Daniel R. Grayson and Michael Stillman

Module + Module := (M,N) -> (
     if ring M =!= ring N
     then error "expected modules over the same ring";
     R := ring M;
     if ambient M != ambient N
     or M.?relations and N.?relations and M.relations != N.relations
     or M.?relations and not N.?relations
     or not M.?relations and N.?relations
     then error "expected submodules of the same module";
     subquotient(
	  if not M.?generators or not N.?generators then null else M.generators | N.generators,
	  if M.?relations then M.relations else null
	  )
     )

Module ** Module := (M,N) -> (
     P := youngest(M,N);
     key := (M,N,quote **);
     if P#?key then P#key
     else M**N = (
	  if M.?generators and not isFreeModule N
	  or N.?generators and not isFreeModule M then (
	       if M.?generators then M = cokernel presentation M;
	       if N.?generators then N = cokernel presentation N;
	       );
	  R := ring M;
	  if R =!= ring N then error "expected modules over the same ring";
	  if isFreeModule M then (
	       if M == R^1 then N
	       else if isFreeModule N then (
		    if N == R^1 then M
		    else (
			 sendgg(ggPush M, ggPush N, ggmult);
			 new Module from R
			 )
		    )
	       else subquotient(
		    if N.?generators then M ** N.generators,
		    if N.?relations then M ** N.relations))
	  else (
	       if isFreeModule N then (
		    if N == R^1 then M
		    else subquotient(
			 if M.?generators then M.generators ** N,
			 if M.?relations then M.relations ** N))
	       else (
		    sendgg(ggPush M.relations, ggPush N.relations, ggmodtensor);
		    cokernel getMatrix R))))

Matrix ** Module := (f,M) -> (
     P := youngest(f,M);
     key := (f,M,quote **);
     if P#?key then P#key
     else f**M = (
     	  f ** id_M
	  )
     )
Module ** Matrix := (M,f) -> (
     P := youngest(M,f);
     key := (M,f,quote **);
     if P#?key then P#key
     else M**f = (
     	  id_M ** f
	  )
     )

-----------------------------------------------------------------------------
-- base change
-----------------------------------------------------------------------------
Module ** Ring := (M,R) -> (
     P := youngest(M,R);
     key := (M,R,quote **);
     if P#?key then P#key
     else M**R = (
	  k := ring M;
	  if k === R then M
	  else (
	       try promote(1_k, R) else error "can't tensor by this ring";
	       if M.?generators then coker presentation M ** R
	       else if M.?relations then cokernel (M.relations ** R)
	       else if isQuotientOf(R,k) then R^(- degrees M)
	       else R^(rank M)
	       )
	  ))

Matrix ** Ring := (f,R) -> (
     P := youngest(f,R);
     key := (f,R,quote **);
     if P#?key then P#key
     else f**R = (
	  k := ring source f;
	  S := ring target f;
	  if k === R and S === R then f
	  else if S === R then (
	       -- map(target f, (source f ** R) ** R^(-degree f), f)
	       map(target f, source f ** R, f, Degree => degree f)
	       )
	  else map(
	       -- this will be pretty slow
	       target f ** R, source f ** R, applyTable(entries f, r -> promote(r,R)),
	       Degree => if isQuotientOf(R,k) then degree f else degree 1_R
	       )
	  ))

-----------------------------------------------------------------------------       
gcdDegree Module := F -> (sendgg (ggPush F, gggcd); eePopIntarray());

lcmDegree Module := F -> (sendgg (ggPush F, gglcm); eePopIntarray());

poincare Module := M -> (
     R := ring M;
     if degreeLength R == 0
     then error "expected nonzero degree length";
     M = coker presentation M;
     -- if not isHomogeneous relations M then error "expected a homogeneous module";
     ZZn := degreesRing R;
     if not M.?poincare then (
	if not M.?poincareComputation then (
            g := generators gb presentation M;
	    sendgg(ggPush ZZn, ggPush g, gghilb);
	    M.poincareComputation = newHandle());
        sendgg(ggPush M.poincareComputation, ggPush (-1), ggcalc, ggpop);
            -- the last ggpop is to remove the return code.  MES: we should
            -- look at it first.
	sendgg(ggPush M.poincareComputation, gggetvalue);
        M.poincare = ZZn.pop());
     M.poincare)

hilbertFunction(ZZ,Module) :=
hilbertFunction(ZZ,Ring) :=
hilbertFunction(ZZ,Ideal) :=
hilbertFunction(List,Ring) := 
hilbertFunction(List,Ideal) := 
hilbertFunction(List,Module) := (d,M) -> (
     if class d === ZZ then (
     	  f := hilbertSeries(M, Order => d+1);
     	  U := monoid ring f;
     	  u := U_0;
     	  f_(u^d))
     else if class d === List and all(d,i->class i === ZZ) then (
	  -- hilbertSeries to finite order doesn't work yet for multi-degrees
	  -- we need more flexible power series handling functions
	  rank source basis(d,M)
	  )
     else error "expected degree to be an integer or list of integers")

geometricSeries := (x,n) -> sum(n, i -> x^i)

trimm := (f,n) -> (
     ff := coefficients(toList(0 .. numgens ring f - 1), f);
     fm := ff#0;			  -- the monomials
     fc := ff#1;			  -- the coefficients
     p := positions(first entries fm, m -> max first exponents m < n);
     (fm_p * transpose fc_p)_(0,0)
     )

hilbertSeries PolynomialRing := options -> (R) -> hilbertSeries(R^1, options)
hilbertSeries Module := options -> (M) -> (
     if M#?{hilbertSeries} and options.Order == infinity
     then M#{hilbertSeries}
     else 
     if M#?{{hilbertSeries}} 
     and options.Order =!= infinity
     and M#{{hilbertSeries}}#1 >= options.Order
     then (
	  if M#{{hilbertSeries}}#1 === options.Order
	  then M#{{hilbertSeries}}#0
	  else trimm(M#{{hilbertSeries}}#0,options.Order)
	  )
     else (
	  A := ring M;
	  num := poincare M;
	  T := degreesRing A;
	  denom := new MutableHashTable from (
	       sort pairs tally apply(generators A, x -> degree x));
	  if options.Order === infinity 
	  then M#{hilbertSeries} = (
	       uf := 0;
	       while 0 == substitute(num, T_0 => 1)
	       do (
		    num = num // (1 - T_0);
		    if denom#?{1} and denom#{1} > 0
		    then (
			 denom#{1} = denom#{1} - 1;
			 if denom#{1} == 0 then remove(denom,{1});
			 )
		    else (
			 uf = uf + 1;
			 )
		    );
	       Divide {
		    if uf == 0 
		    then num
		    else Product {num, Power{1 - T_0, uf}},
		    Product apply(
			 sort pairs denom,
			 (i,e) -> Power{ 1 - product(#i, j -> T_j ^ (i_j)), e }
			 )
		    }
	       )
	  else if class options.Order === ZZ 
	  then first (
	       M#{{hilbertSeries}} = {
		    if num == 0
		    then 0_T
		    else (
			 m := min min(listForm num / first);
			 n := options.Order;
			 N := n - m;
			 f := num * product apply(
			      pairs denom,
			      (i,e) -> (geometricSeries(
				   product(#i, j -> T_j ^ (i_j)),
				   N)) ^ e
			      );
			 trimm(f,n)),
	       options.Order})
	  else error "expected an integer as value of Order option"
	  ))

ProjectiveHilbertPolynomial = new Type of HashTable

ProjectiveHilbertPolynomial ZZ := (P,i) -> sum(pairs P, (n,c) -> c * binomial(n+i,n))

euler ProjectiveHilbertPolynomial := (P) -> P(0)
diff(ProjectiveHilbertPolynomial,ZZ) := (P,i) -> (
     new ProjectiveHilbertPolynomial from select(
     	  apply(pairs P, (n,c) -> (n-i,c)),
	  (n,c) -> n >= 0
	  ))
diff ProjectiveHilbertPolynomial := (P) -> diff(P,1)
ProjectiveHilbertPolynomial + ProjectiveHilbertPolynomial := (h,k) -> (
     select( merge(h,k,plus), c -> c =!= 0 )
     )
- ProjectiveHilbertPolynomial := h -> applyValues(h,minus)
ProjectiveHilbertPolynomial - ProjectiveHilbertPolynomial := (h,k) -> h + -k
ProjectiveHilbertPolynomial == ProjectiveHilbertPolynomial := (h,k) -> h === k
dim ProjectiveHilbertPolynomial := (P) -> if #P === 0 then -1 else max keys P
degree ProjectiveHilbertPolynomial := (P) -> if #P === 0 then 0 else P#(dim P)
ZZ * ProjectiveHilbertPolynomial := (b,h) -> (
     if b === 1 then h 
     else if b === 0 then new ProjectiveHilbertPolynomial from {}
     else applyValues(h,c -> b*c)
     )

PPP := new Holder from {"P"}
expression ProjectiveHilbertPolynomial := (h) -> (
     sum(sort pairs h, (n,c) -> c * new Subscript from {PPP, n})
     )	  
net ProjectiveHilbertPolynomial := (h) -> net expression h

projectiveHilbertPolynomial = method()
projectiveHilbertPolynomial ZZ := (n) -> (
     new ProjectiveHilbertPolynomial from { n => 1 }
     )
projectiveHilbertPolynomial(ZZ,ZZ) := memoize(
     (n,d) -> new ProjectiveHilbertPolynomial from (
     	  if d <= 0 
	  then apply(min(-d+1,n+1), j -> n-j => (-1)^j * binomial(-d,j))
     	  else apply(n+1, j -> n-j => binomial(d-1+j,j))))

i := quote i
hilbertFunctionRing := QQ[i]

hilbertFunctionQ := method()
hilbertFunctionQ(ZZ) := (n) -> (
     if n === 0 then 1_hilbertFunctionRing
     else (1/n) * (n+i) * hilbertFunctionQ(n-1))
hilbertFunctionQ(ZZ,ZZ) := memoize(
     (n,d) -> (
     	  if d === 0 then hilbertFunctionQ(n)
     	  else substitute(hilbertFunctionQ(n), {i => i+d})))

hilbertPolynomial Module := options -> (M) -> (
    if degreeLength ring M != 1 
    then error "expected a singly graded ring";
    n := numgens ring M - 1;
    f := poincare M;
    T := (ring f)_0;
    p := pairs standardForm f;
    if options.Projective 
    then (
	 if #p===0 
	 then new ProjectiveHilbertPolynomial from {}
	 else sum(p, (d,c) -> (
	      	   if #d === 0 then d = 0 else d = d#0;
	      	   c * projectiveHilbertPolynomial(n,-d))))
    else (
	 if #p===0
	 then 0_hilbertFunctionRing
	 else sum(p, (d,c) -> (
	      	   if #d === 0 then d = 0 else d = d#0;
	      	   c * hilbertFunctionQ(n,-d)))))

hilbertPolynomial Ring := options -> (R) -> hilbertPolynomial(R^1, options)

Ideal * Ring := (I,S) -> if ring I === S then I else ideal(I.generators ** S)
Ring * Ideal := (S,I) -> if ring I === S then I else ideal(I.generators ** S)

ZZ == Ideal := (n,I) -> I == n
Ideal == ZZ := (I,n) -> (
     if n === 0
     then I.generators == 0
     else if n === 1
     then 1_(ring I) % I == 0
     else error "attempted to compare ideal to integer not 0 or 1"
     )
ZZ == Module := (n,M) -> M == n
Module == ZZ := (M,n) -> (
     if n =!= 0 then error "attempted to compare module to nonzero integer";
     if M.?generators then (
	  if M.?relations then M.generators % M.relations == 0
	  else M.generators == 0
	  )
     else (
	  if M.?relations then (
	       f := M.relations;
	       id_(target f) % f == 0
	       )
	  else M.numgens === 0
	  )
     )


dim Module := M -> (
     if degreeLength ring M === 0 
     then error "can't compute dimension over a ring with zero degree length";
     if not isHomogeneous M
     then M = cokernel leadTerm gens gb presentation M;
     if poincare M == 0
     then -1
     else 1 + dim hilbertPolynomial M
     )

codim Module := M -> dim ring M - dim M

degree Module := M -> (
  hf := poincare M;
  T := (ring hf)_0;
  if hf == 0 then 0
  else (
       while substitute(hf,{T=>1}) == 0 do hf = hf // (1-T);
       substitute(hf,{T=>1})))

-----------------------------------------------------------------------------

presentation(Module) := M -> (
     if M.?presentation then M.presentation else M.presentation = (
	  if M.?generators then (
	       modulo( M.generators, if M.?relations then M.relations)
	       )
	  else relations M))
-----------------------------------------------------------------------------  

prune(Module) := M -> (
     if M.?pruningMap then M
     else if M.?prune then M.prune else M.prune = (
	  R := ring M;
	  oR := options R;
	  if isFreeModule M then (
	       M.pruningMap = id_M;
	       M)
	  else if (isAffineRing R and isHomogeneous M)
	         or (oR.?SkewCommutative and oR.SkewCommutative and isHomogeneous M) then (
	       f := presentation M;
	       g := complement f;
	       N := cokernel modulo(g, f);
	       N.pruningMap = map(M,N,g);
	       N)
	  else (
	       f = gens gb presentation M;
	       -- MES: can't it do more here?
	       N = cokernel f;
	       N.pruningMap = map(M,N,id_(cover M));
	       N)
	  )
     )

prune(Matrix) := (m) -> (
     M := source m;
     if not M.?pruningMap then m = m * (prune M).pruningMap;
     N := target m;
     if not N.?pruningMap then m = (prune N).pruningMap^-1 * m;
     m)

-----------------------------------------------------------------------------

dual Module := F -> if F.?dual then F.dual else F.dual = (
     if not isFreeModule F then kernel transpose presentation F
     else (
	  sendgg (ggPush F, ggtranspose); 
	  new Module from ring F))

-----------------------------------------------------------------------------
Hom(Ideal, Ideal) := (I,J) -> Hom(module I, module J)
Hom(Ideal, Module) := (I,M) -> Hom(module I, M)
Hom(Module, Ideal) := (M,I) -> Hom(M, module I)

Hom(Module, Ring) := (M,R) -> Hom(M, R^1)
Hom(Ring, Module) := (R,M) -> Hom(R^1, M)
Hom(Ideal, Ring) := (I,R) -> Hom(module I, R^1)
Hom(Ring, Ideal) := (R,I) -> Hom(R^1, module I)

Hom(Module, Module) := (M,N) -> (
     if isFreeModule M 
     then dual M ** N
     else kernel Hom(presentation M, N)
     )
-- An alternate Hom routine:
Hom(Module, Module) := (M,N) -> (
     -- This version is perhaps less transparent, but is
     -- easier to determine the link with homomorphisms.
     m := presentation M;
     mdual := transpose m;
     n := presentation N;
     h1 := modulo(mdual ** target n, target mdual ** n);
     MN := trim subquotient(h1,source mdual ** n);
     -- Now we store the information that 'homomorphism'
     -- will need to reconstruct the map corresponding to
     -- an element.
     MN.Hom = {M,N,source mdual,target n};
     MN)

homomorphism = method()
homomorphism Matrix := (f) -> (
     if not isFreeModule(source f) or 
        numgens source f =!= 1 or
        not (target f).?Hom
	then error "homomorphism may only be determined for maps R --> Hom(M,N)";
     MN := (target f).Hom;
     M := MN#0;
     N := MN#1;
     M0 := MN#2;
     N0 := MN#3;
     deg := (degrees source f)#0;
     map(N,M,adjoint1(super f, M0, N0),Degree=>deg))
-----------------------------------------------------------------------------
pdim Module := M -> max select(keys complete resolution M, i -> class i === ZZ)

Module / Module := (M,N) -> (
     L := ambient M;
     if L != ambient N then error "expected modules with the same ambient module";
     R := ring M;
     if N.?generators
     then (
	  p := N.generators;
	  if M.?relations then (
	       p = p | M.relations;
	       );
	  subquotient(
	       if M.?generators then M.generators,
	       -- mingens image -- do we need this ???
	       p))
     else image id_L)

Module / RingElement := (M,x) -> M / (x * M)
Module / Sequence := Module / List := (M,v) -> (
     R := ring M;
     v = toList v;
     if all(v, w -> class w === M)
     then M / image matrix v
     else if all(v, w -> class w == R)
     then M / (ideal v * M)
     else error("expected a list of elements of ", toString M, " or of ", toString R)
     )
Module / Vector := (M,v) -> (
     if class v =!= M 
     then error("expected ", toString v, " to be an element of ", toString M);
     M / image matrix {v})
-----------------------------------------------------------------------------
--top Module := M -> (
--     R := ring M;
--     c := codim M; 
--     annihilator prune Ext^c(M, R))
--document { quote top,
--     TT "top M", " -- produce the annihilator of Ext^c(M, R), where c
--     is the codimension of the support of the module M."
--     }
-----------------------------------------------------------------------------

ann = annihilator

annihilator Module := M -> (
     f := presentation M;
     image f : target f )
annihilator Ideal := I -> annihilator module I
annihilator RingElement := f -> annihilator ideal f

-----------------------------------------------------------------------------

ZZ _ Module := (i,M) -> (
     if i === 0 then M#0
     else error "expected integer to be zero"
     )

Module _ ZZ := (M,i) -> (
     if M.?generators then (
	  if i < 0 or i >= rank source M.generators
	  then error ("subscript '", toString i, "' out of range");
	  sendgg (ggPush M.generators, ggPush i, ggelem);
	  new M)
     else (
	  if i < 0 or i >= M.numgens 
	  then error ("subscript '", toString i, "' out of range");
     	  sendgg(ggPush M, ggPush i, if M.?newEngine then ggbasisElement else ggfromint);
     	  new M)
     )

-----------------------------------------------------------------------------
Module ^ Array := (M,w) -> if M#?(quote ^,w) then M#(quote ^,w) else M#(quote ^,w) = (
     -- we don't splice any more because natural indices include pairs (i,j).
     w = toList w;
     if not M.?components then error "expected a direct sum module";
     if M.?indexComponents then (
	  ic := M.indexComponents;
	  w = apply(w, i -> if ic#?i 
		    then ic#i 
		    else error "expected an index of a component of a direct sum"));
     -- if the components of M have 3,4,5 generators, then
     -- we want to construct { (0,1,2), (3,4,5,6), (7,8,9,10,11) } for quick access
     k := 0;
     v := apply(M.components, N -> k .. (k = k + numgens N) - 1);
     map(directSum M.components_w, M, (cover M)^(splice apply(w, i -> v#i))))

Module _ Array := (M,w) -> if M#?(quote _,w) then M#(quote _,w) else M#(quote _,w) = (
     -- we don't splice any more because natural indices include pairs (i,j).
     w = toList w;
     if not M.?components then error "expected a direct sum module";
     if M.?indexComponents then (
	  ic := M.indexComponents;
	  w = apply(w, i -> if ic#?i 
		    then ic#i 
		    else error "expected an index of a component of a direct sum"));
     -- if the components of M have 3,4,5 generators, then
     -- we want to construct { (0,1,2), (3,4,5,6), (7,8,9,10,11) } for quick access
     k := 0;
     v := apply(M.components, N -> k .. (k = k + numgens N) - 1);
     map(M, directSum M.components_w, (cover M)_(splice apply(w, i -> v#i))))

-----------------------------------------------------------------------------
Module ^ List := (M,rows) -> submatrix(id_M,rows,)
-----------------------------------------------------------------------------
Module _ List := (M,v) -> (
     N := cover M;
     f := id_N_v;
     map(M, source f, f))
-----------------------------------------------------------------------------
basis(List,Module) := (deg,M) -> (
     if #deg =!= degreeLength ring M then error "expected degree length to match that of ring";
     R := ring M;
     A := ultimate(ambient,R);
     if not (
	  isAffineRing A 
	  or
	  isPolynomialRing A and isField coefficientRing A and (options A).SkewCommutative
	  or
	  isPolynomialRing A and ZZ === coefficientRing A
	  or
	  ZZ === A
	  ) then error "'basis' can't handle this type of ring";
     k := coefficientRing A;
     bottom := generators gb presentation M;
     top := id_(target bottom);
     sendgg(ggPush top, ggPush bottom, ggPush deg, ggkbasis);
     map(M,,getMatrix R))

basis(ZZ,Module) := (deg,M) -> basis({deg},M)
basis(List,Ideal) := basis(ZZ,Ideal) := (n,I) -> basis(n,module I)
basis(List,Ring) := (deg,R) -> basis(deg, R^1)

basis(ZZ,Ring) := (deg,R) -> basis({deg}, R^1)

basis Module := M -> (
     -- check the following:
     --     R = ring m is a polynomial ring
     --     
     R := ring M;
     A := ultimate(ambient,R);
     if not isField coefficientRing A then error "expected an algebra over a field";
     k := coefficientRing A;
     bottom := generators gb presentation M;
     top := id_(target bottom);
     sendgg(ggPush top, ggPush bottom, ggkbasis);
     map(M,,getMatrix R))

basis Ring := R -> basis(R^1)
basis Ideal := I -> basis module I
-----------------------------------------------------------------------------

truncate(List,Ideal) := (deg,I) -> ideal truncate(deg,module I)

truncate(List,Module) := (deg,M) -> (
     -- check the following:
     --     R = ring m is a polynomial ring
     --     
     R := ring M;
     F := ambient M;
     top := (
	  if M.?generators then generators gb (
	       if M.?relations then M.generators | M.relations else M.generators
	       )
	  else id_F
	  );
     bottom := (
	  if M.?relations 
	  then generators gb M.relations 
	  else map(F, R^0, 0)
	  );
     sendgg(ggPush top, ggPush bottom, ggPush deg, ggtruncate);
     subquotient(getMatrix R, if M.?relations then M.relations))

truncate(ZZ,Module) := truncate(ZZ,Ideal) := (deg,M) -> truncate({deg},M)

issub := (f,g) -> (
     g = gb g;
     sendgg(ggPush f, ggPush g, ggissubset);
     -1 == ZZ.pop())

isSubset(Module,Module) := (M,N) -> (
     -- here is where we could use gb of a subquotient!
     ambient M == ambient N and
     if M.?relations and N.?relations then (
	  image M.relations == image N.relations
	  and
	  issub(M.relations | gens M, N.relations | gens N))
     else if not M.?relations and not N.?relations then (
	  issub(gens M, gens N))
     else false
     )
isSubset(Ideal,Ideal) := (I,J) -> isSubset(module I, module J)
isSubset(Module,Ideal) := (M,J) -> isSubset(M, module J)
isSubset(Ideal,Module) := (I,N) -> isSubset(module I, N)

