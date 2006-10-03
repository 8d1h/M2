-- Copyright 1999-2002 by Anton Leykin and Harrison Tsai

-----------------------------------------------------------------------
-- globalBFunction (f) -> bf
-- f = polynomial (assumed to be an element of 
-- 	     a Weyl algebra with no parameters)
-- bf = global b-function (polynomial in K[s], where K is 
-- 	     the coefficient field)
--
-- (method: definition 5.3.10 in Saito-Strumfels-Takayama)
-----------------------------------------------------------------------

globalBFunction = method(Options => {Strategy => ReducedB})

-- makes polynomial f monic (internal) 
makeMonic := f -> ( if coefficientRing ring f === QQ 
     then (1 / (leadCoefficient f)) * f 
     else (1 // (leadCoefficient f)) * f
     );

--------------------------------------------------------
-- version that uses bFunction
--------------------------------------------------------
globalBFunctionIdeal := method(Options => {Strategy => TryGeneric})
globalBFunctionIdeal RingElement := RingElement => o -> f -> (
     W := ring f;
     createDpairs W;
     dpI := W.dpairInds;
     
     -- sanity check
     if (#(W.dpairInds#2) != 0) then
     error "expected no central variables in Weyl algebra";
     if any(listForm f, m -> any(dpI#1, i -> m#0#i != 0)) then
     error "expected no differentials in the polynomial";
     
     t := symbol t;
     dt := symbol dt;     
     WT := (coefficientRing W)[ t, dt, (entries vars W)#0, 
	       WeylAlgebra => W.monoid.Options.WeylAlgebra | {t => dt}];
     w := {1} | toList (((numgens W) // 2):0);
     f' := substitute(f,WT);
     If := ideal ({t - f'} 
     	  | (dpI#1 / (i->(
	       	    	 DX := WT_(i+2);
	       	    	 (DX * f' - f' * DX) * dt + DX
	       	    	 )))
	  );
     pInfo(666, toString If);
     bfunc := bFunction(If, w, Strategy => o.Strategy);
     s := (ring bfunc)_0;
     result := makeMonic substitute(bfunc, { s => -s - 1 });
     use W;
     result
     );--end of globalBFunction

------------------------------------------------------------------
-- REDUCED global b-function: b(s)/(s+1)
------------------------------------------------------------------
globalRB := method()
globalRB (RingElement,Boolean) := RingElement => (f,isRed) -> (
     W := ring f;
     AnnI := AnnFs f;
     Ws := ring AnnI;
     ns := numgens Ws;
     createDpairs W;
     use W;
     df := apply(W.dpairVars#1, dx->dx*f-f*dx);
     
     elimWs := (coefficientRing Ws)[(entries vars Ws)#0,
	  WeylAlgebra => Ws.monoid.Options.WeylAlgebra,
	  MonomialOrder => Eliminate (ns-1)];
     ff := substitute(matrix{{f}|
	       if isRed then df else {}
	       },elimWs);
     elimAnnI := substitute(AnnI, elimWs);
     H := gens elimAnnI | ff;
     
     gbH := gb H;

     bpolys := selectInSubring(1, gens gbH);
     if (bpolys == 0) then error "module not specializable";
     if (rank source bpolys > 1) then error "ideal principal but not
     realized as such.  Need better implementation";
     bpoly := bpolys_(0,0);

     Ks := (coefficientRing W)[Ws_(ns-1)];
     bpoly = substitute(bpoly, Ks);
     if isRed then bpoly = bpoly*(Ks_0+1);
     use W;
     bpoly
     )

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- This routine computes a Bernstein operator for a polynomial f
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
globalB = method()

globalB(Ideal, RingElement) := HashTable => (I, f) -> (
     W := ring I;
     AnnI := AnnIFs (I,f);
     Ws := ring AnnI;
     ns := numgens Ws;
     
     elimWs := (coefficientRing Ws)[(entries vars Ws)#0,
	  WeylAlgebra => Ws.monoid.Options.WeylAlgebra,
	  MonomialOrder => Eliminate (ns-1)];
     ff := substitute(f,elimWs);
     elimAnnI := substitute(AnnI, elimWs);
     H := gens elimAnnI | matrix{{ff}};
     
     gbH := gb(H, ChangeMatrix => true);

     bpolys := selectInSubring(1, gens gbH);
     if (bpolys == 0) then error "module not specializable";
     if (rank source bpolys > 1) then error "ideal principal but not
     realized as such.  Need better implementation";
     bpoly := bpolys_(0,0);

     ind := position((entries gens gbH)#0, i -> (i == bpoly));
     C := getChangeMatrix gbH;
     Bop := C_(numgens source H - 1, ind);
     
     Ks := (coefficientRing W)[Ws_(ns-1)];
     bpoly = substitute(bpoly, Ks);
     use W;
     hashTable {Bpolynomial => bpoly, Boperator => Bop}
     )

globalBoperator = method()
globalBoperator(RingElement) := RingElement => (f) -> (
     W := ring f;
     createDpairs W;
     I := ideal W.dpairVars#1;
     (globalB(I,f))#Boperator
     )

--------------------------------------------------------------
-- MAIN function
-------------------------------------------------------------
globalBFunction RingElement := RingElement => o -> f -> (
     result := (
	  if o.Strategy == IntRing 
	  or o.Strategy == TryGeneric 
	  or o.Strategy == NonGeneric 
     	  then globalBFunctionIdeal(f, o)
     	  else if o.Strategy == ReducedB
	  then globalRB (f,true)
	  else if o.Strategy == ViaAnnFs
	  then globalRB (f,false)
	  else error "wrong Strategy option"
	  );
     use ring f;
     result
     )

















