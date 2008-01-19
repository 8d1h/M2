--		Copyright 1995 by Daniel R. Grayson

Ext = new ScriptedFunctor from {
     argument => (
	  (M,N) -> (
	       f := lookup(Ext,class M,class N);
	       if f === null then noMethod(Ext,(M,N),{false,false});
	       f(M,N))),	  
     superscript => (
	  i -> new ScriptedFunctor from {
	       argument => (X -> (
	       	    	 (M,N) -> (
		    	      f := lookup(Ext,class i,class M,class N);
		    	      if f === null then noMethod(Ext,(i,M,N),{false,false,false});
		    	      f(i,M,N))
	       	    	 ) X
	       	    )
	       }
	  )
     }
	  
Ext(ZZ, Module, Module) := Module => (i,M,N) -> (
     R := ring M;
     if not isCommutative R then error "'Ext' not implemented yet for noncommutative rings.";
     if R =!= ring N then error "expected modules over the same ring";
     if i < 0 then R^0
     else if i === 0 then Hom(M,N)
     else (
	  C := resolution(M,LengthLimit=>i+1);
	  b := C.dd;
	  complete b;
	  minimalPresentation if b#?i then (
	       if b#?(i+1) 
	       then homology(Hom(b_(i+1),N), Hom(b_i,N))
	       else cokernel Hom(b_i,N))
	  else (
	       if b#?(i+1) 
	       then kernel Hom(b_(i+1),N)
	       else Hom(C_i,N))))

Ext(ZZ, Matrix, Module) := Matrix => (i,f,N) -> (
     R := ring f;
     if not isCommutative R then error "'Ext' not implemented yet for noncommutative rings.";
     if R =!= ring N then error "expected modules over the same ring";
     if i < 0 then R^0
     else if i === 0 then Hom(f,N)
     else (
	  g := resolution(f,LengthLimit=>i+1);
	  Es := Ext^i(source f, N);
	  Es':= target Es.cache.pruningMap;	  -- Ext prunes everything, so get the original subquotient
	  Et := Ext^i(target f, N);
	  Et':= target Et.cache.pruningMap;
	  Es.cache.pruningMap^-1 * inducedMap(Es',Et',Hom(g_i,N)) * Et.cache.pruningMap))

Ext(ZZ, Module, Matrix) := Matrix => (i,N,f) -> (
     R := ring f;
     if not isCommutative R then error "'Ext' not implemented yet for noncommutative rings.";
     if R =!= ring N then error "expected modules over the same ring";
     if i < 0 then R^0
     else if i === 0 then Hom(N,f)
     else (
	  C := resolution(N,LengthLimit=>i+1);
	  Es := Ext^i(N, source f);
	  Es':= target Es.cache.pruningMap;	  -- Ext prunes everything, so get the original subquotient
	  Et := Ext^i(N, target f);
	  Et':= target Et.cache.pruningMap;
	  Et.cache.pruningMap^-1 * inducedMap(Et',Es',Hom(C_i,f)) * Es.cache.pruningMap))

Ext(ZZ, Ideal, Matrix) := (i,J,f) -> Ext^i(module J,f)
Ext(ZZ, Matrix, Ring) := (i,f,R) -> Ext^i(f,R^1)
Ext(ZZ, Matrix, Ideal) := (i,f,J) -> Ext^i(f,module J)
Ext(ZZ, Module, Ring) := (i,M,R) -> Ext^i(M,R^1)
Ext(ZZ, Module, Ideal) := (i,M,J) -> Ext^i(M,module J)
Ext(ZZ, Ideal, Ring) := (i,I,R) -> Ext^i(module I,R^1)
Ext(ZZ, Ideal, Ideal) := (i,I,J) -> Ext^i(module I,module J)
Ext(ZZ, Ideal, Module) := (i,I,N) -> Ext^i(module I,N)

-- total ext over complete intersections

Ext(Module,Module) := Module => (M,N) -> (
  B := ring M;
  if B =!= ring N
  then error "expected modules over the same ring";
  if not isCommutative B
  then error "'Ext' not implemented yet for noncommutative rings.";
  if not isHomogeneous B
  then error "'Ext' received modules over an inhomogeneous ring";
  if not isHomogeneous N or not isHomogeneous M
  then error "'Ext' received an inhomogeneous module";
  if N == 0 then B^0
  else if M == 0 then B^0
  else (
    p := presentation B;
    A := ring p;
    I := ideal mingens ideal p;
    n := numgens A;
    c := numgens I;
    if c =!= codim B 
    then error "total Ext available only for complete intersections";
    f := apply(c, i -> I_i);
    pM := lift(presentation M,A);
    pN := lift(presentation N,A);
    M' := cokernel ( pM | p ** id_(target pM) );
    N' := cokernel ( pN | p ** id_(target pN) );
    C := complete resolution M';
    X := getGlobalSymbol "X";
    K := coefficientRing A;
    -- compute the fudge factor for the adjustment of bidegrees
    fudge := if #f > 0 then 1 + max(first \ degree \ f) // 2 else 0;
    S := K(monoid [X_1 .. X_c, toSequence A.generatorSymbols,
      Degrees => {
        apply(0 .. c-1, i -> {-2, - first degree f_i}),
	apply(0 .. n-1, j -> { 0,   first degree A_j})
        },
      Heft => {-fudge, 1}
      ]);
    -- make a monoid whose monomials can be used as indices
    Rmon := monoid [X_1 .. X_c,Degrees=>{c:{2}}];
    -- make group ring, so 'basis' can enumerate the monomials
    R := K Rmon;
    -- make a hash table to store the blocks of the matrix
    blks := new MutableHashTable;
    blks#(exponents 1_Rmon) = C.dd;
    scan(0 .. c-1, i -> 
	 blks#(exponents Rmon_i) = nullhomotopy (- f_i*id_C));
    -- a helper function to list the factorizations of a monomial
    factorizations := (gamma) -> (
      -- Input: gamma is the list of exponents for a monomial
      -- Return a list of pairs of lists of exponents showing the
      -- possible factorizations of gamma.
      if gamma === {} then { ({}, {}) }
      else (
	i := gamma#-1;
	splice apply(factorizations drop(gamma,-1), 
	  (alpha,beta) -> apply (0..i, 
	       j -> (append(alpha,j), append(beta,i-j))))));
    scan(4 .. length C + 1, 
      d -> if even d then (
	scan( flatten \ exponents \ leadMonomial \ first entries basis(d,R), 
	  gamma -> (
	    s := - sum(factorizations gamma,
	      (alpha,beta) -> (
		if blks#?alpha and blks#?beta
		then blks#alpha * blks#beta
		else 0));
            -- compute and save the nonzero nullhomotopies
            if s != 0 then blks#gamma = nullhomotopy s;
      	    ))));
    -- make a free module whose basis elements have the right degrees
    spots := C -> sort select(keys C, i -> class i === ZZ);
    Cstar := S^(apply(spots C,
	i -> toSequence apply(degrees C_i, d -> {i,first d})));
    -- assemble the matrix from its blocks.
    -- We omit the sign (-1)^(n+1) which would ordinarily be used,
    -- which does not affect the homology.
    toS := map(S,A,apply(toList(c .. c+n-1), i -> S_i),
      DegreeMap => prepend_0);
    Delta := map(Cstar, Cstar, 
      transpose sum(keys blks, m -> S_m * toS sum blks#m),
      Degree => {-1,0});
    DeltaBar := Delta ** (toS ** N');
    assert isHomogeneous DeltaBar;
    assert(DeltaBar * DeltaBar == 0);
    if debugLevel > 10 then (
	 stderr << describe ring DeltaBar <<endl;
	 stderr << toExternalString DeltaBar << endl;
	 );
    -- now compute the total Ext as a single homology module
    minimalPresentation homology(DeltaBar,DeltaBar)))

Ext(Module, Ring) := (M,R) -> Ext(M,R^1)
Ext(Module, Ideal) := (M,J) -> Ext(M,module J)
Ext(Ideal, Ring) := (I,R) -> Ext(module I,R^1)
Ext(Ideal, Ideal) := (I,J) -> Ext(module I,module J)
Ext(Ideal, Module) := (I,N) -> Ext(module I,N)

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/m2 "
-- End:
