-- Copyright 1996 by Michael E. Stillman

----------------
-- quotients ---
----------------

quot0 := options -> (I,J) -> (
    -- this is the version when I, J are ideals,
    R := (ring I)/I;
    mR := transpose generators J ** R;
    g := syz gb(mR,
           options,
           Strategy=>LongPolynomial,
           Syzygies=>true,SyzygyRows=>1);
    -- The degrees of g are not correct, so we fix that here:
    -- g = map(R^1, null, g);
    lift(ideal g, ring I)
    )

quot1 := options -> (I,J) -> (
    -- This is the iterative version, where I and J
    -- are ideals
    R := ring I;
    M1 := ideal(1_R);
    scan(numgens J, i -> (
       f := J_i;
       if generators(f*M1) % (generators I) != 0 then (
	    M2 := quotient(I,f);
	    M1 = intersect(M1,M2);)));
    M1)

quot2 := options -> (I,J) -> (
     error "not implemented yet";
     -- linear case, I,J ideals homog. J=(x) linear
     )

quotmod0 := options -> (M,J) -> (
     m := generators M;
     F := target m;
     mm := generators M;
     if M.?relations then mm = mm | M.relations;
     j := transpose generators J;
     g := (j ** F) | (target j ** mm);
     -- We would like to be able to inform the engine that
     -- it is not necessary to compute various of the pairs
     -- of the columns of the matrix g.
     h := syz gb(g, options,
	  Strategy=>LongPolynomial,
	  SyzygyRows=>numgens F,
	  Syzygies=>true);
     if M.?relations then
         subquotient(h % M.relations, 
	             M.relations)
     else
         image h
     )

quotmod1 := options -> (I,J) -> (
    -- This is the iterative version, where I is a 
    -- submodule of F/K, or ideal, and J is an ideal.
    M1 := super I;
    m := generators I | relations I;
    scan(numgens J, i -> (
       f := J_i;
       if generators(f*M1) % m != 0 then (
	    M2 := quotient(I,f);
	    M1 = intersect(M1,M2);)));
    M1)

quotmod2 := options -> (I,J) -> (
     error "not implemented yet";
     -- This is the case when J is a single linear 
     -- element, and everything is homogeneous
     )

quotann0 := options -> (M,J) -> (
     m := generators M;
     if M.?relations then m = m | M.relations;
     j := adjoint(generators J, (ring J)^1, source generators J);
     F := target m;
     g := j | (source generators J ** m);
     -- << g << endl;
     -- We would like to be able to inform the engine that
     -- it is not necessary to compute various of the pairs
     -- of the columns of the matrix g.
     h := syz gb(g, options,
	  Strategy=>LongPolynomial,
	  SyzygyRows=>1,
	  Syzygies=>true);
     ideal h
     )

quotann1 := options -> (I,J) -> (
    R := ring I;
    M1 := ideal(1_R);
    m := generators I | relations I;
    scan(numgens J, i -> (
       f := image (J_{i});
       if generators(f**M1) % m != 0 then (
	    M2 := quotient(I,f);
	    M1 = intersect(M1,M2);)));
    M1)


doQuotientOptions := (options) -> (
    options = new MutableHashTable from options;
    remove(options,Strategy);
    remove(options,MinimalGenerators);
    --options.SyzygyLimit = options.BasisElementLimit;
    --remove(options,BasisElementLimit);
    new OptionTable from options
    )

quotientIdeal := options -> (I,J) -> (
     if ring I =!= ring J
       then error "expected ideals in the same ring";
     domins := options.MinimalGenerators;
     strat := options.Strategy;
     options = doQuotientOptions options;
     local IJ;
     if strat === symbol Iterate then
         IJ = (quot1 options)(I,J)
     else if strat === symbol Linear then
         IJ = (quot2 options)(I,J)
     else 
     	 IJ = (quot0 options)(I,J);
     if domins then trim IJ else IJ)

quotientModule := options -> (I,J) -> (
     if ring I =!= ring J
       then error "expected same ring";
     domins := options.MinimalGenerators;
     strat := options.Strategy;
     options = doQuotientOptions options;
     local IJ;
     if strat === symbol Iterate then
         IJ = (quotmod1 options)(I,J)
     else if strat === symbol Linear then
         IJ = (quotmod2 options)(I,J)
     else 
     	 IJ = (quotmod0 options)(I,J);
     if domins then trim IJ else IJ)

quotientAnn := options -> (I,J) -> (
     if ring I =!= ring J
       then error "expected same ring";
     domins := options.MinimalGenerators;
     strat := options.Strategy;
     options = doQuotientOptions options;
     local IJ;
     if strat === symbol Iterate then
         IJ = (quotann1 options)(I,J)
     else if strat === symbol Linear then
         error "'Linear' not allowable strategy"
     else
     	 IJ = (quotann0 options)(I,J);
     if domins then trim IJ else IJ)

quotient(Ideal ,Ideal      ) := Ideal  => options -> (I,J) -> (quotientIdeal options)(I,J)
quotient(Ideal ,RingElement) := Ideal  => options -> (I,f) -> (quotientIdeal options)(I,ideal(f))
quotient(Module,Ideal      ) := Module => options -> (M,I) -> (quotientModule options)(M,I)
quotient(Module,RingElement) := Module => options -> (M,f) -> (quotientModule options)(M,ideal(f))
quotient(Module,Module     ) := Ideal  => options -> (M,N) -> (quotientAnn options)(M,N)
Ideal : Ideal := Ideal => (I,J) -> quotient(I,J)
Ideal : RingElement := Ideal => (I,r) -> quotient(I,r)
Module : Ideal := Module => (M,I) -> quotient(M,I)
Module : RingElement := Module => (M,r) -> quotient(M,r)
Module : Module := Ideal => (M,N) -> quotient(M,N)
    
----------------
-- saturation --
----------------

saturate = method(
     Options => {
	  DegreeLimit => {},
	  --BasisElementLimit => infinity,
	  --PairLimit => infinity,
	  MinimalGenerators => true,
	  Strategy => null
	  }
     )

satideal0old := options -> (I,J) -> (
    R := ring I;
    I = lift(I,ring presentation R);
    m := transpose generators J;
    while I != 0 do (
	S := (ring I)/I;
	m = m ** S;
	I = ideal syz gb(m, Syzygies => true);
        );
    -- lift(I,R)
    ideal (presentation ring I ** R)
    )
satideal0 := options -> (I,J) -> (
    R := ring I;
    m := transpose generators J;
    while (
	S := (ring I)/I;
	m = m ** S;
	I = ideal syz gb(m, Syzygies => true);
	I != 0
        ) do ();
    -- lift(I,R)
    ideal (presentation ring I ** R)
    )

satideal1 := options -> (I,f) -> (
    I1 := ideal(1_(ring I));
    f = f_0;
    while not(I1 == I) do (
	I1 = I;
	I = ideal syz gb(matrix{{f}}|generators I,
                SyzygyRows=>1,Syzygies=>true););
    I)

satideal2 := options -> (I,f) -> (
    -- This version may be used if f is a linear form
    -- and I is a submodule
    -- We need an easy test whether the ring of I
    -- uses rev lex order
    R := ring I;
    f = f_0;
    -- either check that R is rev lex, or make new ring...
    if degree f === {1} then (
	res := newCoordinateSystem(R,matrix{{f}});
	fto := res#1;
	fback := res#0;
	J := fto generators I;
	gb(J,options);
	m := divideByVariable(generators gb J, R_(numgens R-1));
	ideal fback m)
    )

satideal3 := options -> (I,f) -> (
     -- Bayer method.  This may be used if I,f are homogeneous.
     -- Basic idea: in a ring R[z]/(f-z), with the rev lex order,
     -- compute a GB of I.
     R := ring I;
     n := numgens R;
     f = f_0;
     degs := append((monoid R).degrees, degree f);
     R1 := (coefficientRing R)[Variables=>n+1,Degrees=>degs,MonomialSize=>16];
     i := map(R1,R,(vars R1)_{0..n-1});
     f1 := i f;
     I1 := ideal (i generators I);
     A := R1/(f1-R1_n);
     iback := map(R,A,vars R | f);
     IA := generators I1 ** A;
     g := generators gb(IA,options);
     g = divideByVariable(g, A_n);
     ideal iback g
     )

satideal4 := options -> (I,f) -> (
     f = f_0;
     R := ring I;
     n := numgens R;
     R1 := (coefficientRing R)[Variables=>n+1,MonomialOrder=>Eliminate 1,MonomialSize=>16];
     fto := map(R1,R,genericMatrix(R1,R1_1,1,n));
     f1 := fto f;
     R2 := R1/(f1*R1_0-1);
     fback := map(R,R2,matrix{{0_R}} | vars R);
     fto =  map(R2,R,genericMatrix(R2,R2_1,1,n));
     II := ideal fto generators I;
     g := gb(II,options);
     p1 := selectInSubring(1, generators g);
     ideal fback p1)

removeOptions := (options, badopts) -> (
    options = new MutableHashTable from options;
    scan(badopts, k -> remove(options, k));
    new OptionTable from options)

saturate(Ideal,Ideal) := Ideal => options -> (J,I) -> (
    -- various cases here
    n := numgens I;
    R := ring I;
    if ring J =!= R then error "expected ideals in the same ring";
    linearvar := (n === 1 and degree(I_0) === {1});
    homog := isHomogeneous I and isHomogeneous J;
    
    strategy := options.Strategy;
    domins := options.MinimalGenerators;
    options = removeOptions(options, {MinimalGenerators,Strategy});
    if strategy === null then
       if linearvar and homog and isPolynomialRing R 
          then strategy = Linear
          else strategy = Iterate;

    local f;
    if strategy === Linear then
      (
	if not linearvar or not homog 
	then error "'Linear' method requires saturation w.r.t. single linear element";
        f = satideal2;
      )
    else if strategy === Bayer then 
      (
	if not homog
	then error "Bayer method cannot be used in inhomogeneous case";
	if n =!= 1
	then error "Bayer method only saturates w.r.t. a single element";
        f = satideal3;
      )
    else if strategy === Elimination then
      (
	if n =!= 1
	then error "'Elimination' method requires a single element";
        f = satideal4
      )
    else if strategy === Iterate then
        f = satideal0
    else
        f = satideal0;

    g := (f options)(J,I);
    if domins then trim g else g
    )

saturate(Ideal, RingElement) := Ideal => options -> (I,f) -> saturate(I,ideal f,options)

saturate Ideal := Ideal => options -> (I) -> saturate(I,ideal vars ring I, options)

saturate(Module,Ideal) := Module => options -> (M,I) -> (
    -- various cases here
    M1 := M : I;
    while M1 != M do (
	 M = M1;
	 M1 = M : I;
	 );
    M)
saturate(Module,RingElement) := Module => options -> (M,f) -> saturate(M,ideal(f),options)
saturate(Module) := Module => options -> (M) -> saturate(M,ideal vars ring M, options)
saturate(Vector) := Module => options -> (v) -> saturate(image matrix {v}, options)


-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/m2 "
-- End:
