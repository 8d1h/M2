-- Basic D-routines

-- this function associates to a Weyl algebra W
-- the key "dpairVars", which consists of the following 3 lists
-- 1. coordinate variables 
-- 2. corresponding derivative variables
-- 3. central variables
-- and the key "dpairInds", which consists of lists holding the
-- index in W of each variable in the lists of "dpairVars".
createDpairs = method()
createDpairs(PolynomialRing) := (W) -> (
     if (W.monoid.Options.WeylAlgebra === {}) then
     error "Expected a Weyl algebra" ;

     coordListV := {};
     diffListV := {};
     centralListV := {};
     coordListI := {};
     diffListI := {};
     centralListI := {};
     nW := numgens W;
     i := 0;
     while (i < numgens W) do (
	  tempFlag := false;
     	  j := 0;
	  while (j < numgens W) do (
	       if (W_i * W_j - W_j * W_i == -1) then (
		    coordListV = append(coordListV, W_i);
		    diffListV = append(diffListV, W_j);
		    coordListI = append(coordListI, i);
		    diffListI = append(diffListI, j);		    
		    tempFlag = true;
		    );
	       if (W_i * W_j - W_j * W_i == 1) then
	       tempFlag = true;
	       j = j + 1;
	       );
	  if (tempFlag == false) then (
	       centralListV = append(centralListV, W_i);
	       centralListI = append(centralListI, i);
	       );
	  i = i + 1;
	  );
     W.dpairVars = {coordListV, diffListV, centralListV}; 
     W.dpairInds = {coordListI, diffListI, centralListI};
     );

-- This routine attaches to a Weyl algebra W the key "CommAlgebra"
-- which holds a commutative ring with the same variables
createCommAlgebra = method()
createCommAlgebra(PolynomialRing) := (W) -> (
     if (W.monoid.Options.WeylAlgebra === {}) then
     error "Expected a Weyl algebra" ;     
     W.CommAlgebra = (coefficientRing W)[(entries vars W)#0];
     W.WAtoCA = map(W.CommAlgebra, W, vars W.CommAlgebra);
     W.CAtoWA = map(W, W.CommAlgebra, vars W);
     use W;
     );

-- This routine takes a list {k_0 .. k_n} representing the permutation
--            {0   1   ... n  }
--            {k_0 k_1 ... k_n}
-- and returns the list representing the inverse permutation
invPermute = method()
invPermute(List) := (L) -> (
     tempL := {};
     i := 0;
     while (i < #L) do (
          j := 0;
          tempFlag := false;
          while (j < #L) do (
               if (L#j == i) then (
                    tempL = append(tempL, j);
                    tempFlag = true;
                    );
               j = j+1;
               );
          if (tempFlag == false) then
          error "expected list from 0 to n";
          i = i+1;
          );
     tempL)

-- This routine attaches to a Weyl algebra the Fourier transform map
-- and its inverse under the key "Fourier".  
-- It is the fastest method for Fourier transforms.
createFourier = method()
createFourier(PolynomialRing) := (W) -> (
     if (W.monoid.Options.WeylAlgebra === {}) 
     then error "expected a Weyl algebra";
     if (W.?dpairVars === false) then createDpairs(W);
     L := new MutableList from join(W.dpairInds#0, W.dpairInds#1, W.dpairInds#2);
     InvL := new MutableList from join(W.dpairInds#0, W.dpairInds#1, W.dpairInds#2);
     i := 0;
     while (i < #W.dpairVars#0) do (
	  L#(W.dpairInds#0#i) = -W.dpairVars#1#i;
	  L#(W.dpairInds#1#i) = W.dpairVars#0#i;
	  InvL#(W.dpairInds#0#i) = W.dpairVars#1#i;
	  InvL#(W.dpairInds#1#i) = -W.dpairVars#0#i;
	  i = i+1;
	  );
     i = 0;
     while (i < #W.dpairVars#2) do (
	  L#(W.dpairInds#2#i) = W.dpairVars#2#i;
	  i = i+1;
	  );	  
     W.Fourier = map(W, W, matrix {toList L});
     W.FourierInverse = map(W, W, matrix {toList InvL});
     )

-- These routines compute the Fourier transform which is the automorhpism
-- of the Weyl algebra sending x -> -dx, dx -> x.
-- Input: RingElement f, Matrix m, Ideal I, or List L
-- Output: Fourier transform of f, m, I, or L
Fourier = method()
Fourier(RingElement) := (f) -> (
     W := ring f;
     if (W.monoid.Options.WeylAlgebra === {})
     then error "expected a Weyl algebra";
     if (W.?dpairVars === false) then createDpairs (W);
     n := #W.dpairVars#0;
     subList := splice apply (toList(0..n-1) , 
	  i ->  (W.dpairVars#0#i => -W.dpairVars#1#i,
	         W.dpairVars#1#i => W.dpairVars#0#i) );
     substitute(f, subList) )	    

Fourier(Matrix) := (m) -> (
     W := ring m;
     if (W.monoid.Options.WeylAlgebra === {})
     then error "expected a Weyl algebra";
     if (W.?dpairVars === false) then createDpairs (W);
     n := #W.dpairVars#0;
     subList := splice apply (toList(0..n-1) , 
	  i ->  (W.dpairVars#0#i => -W.dpairVars#1#i,
	         W.dpairVars#1#i => W.dpairVars#0#i) );
     substitute(m, subList) )	    

Fourier(Ideal) := (I) -> (
     W := ring I;
     if (W.monoid.Options.WeylAlgebra === {})
     then error "expected a Weyl algebra";
     if (W.?dpairVars === false) then createDpairs (W);
     n := #W.dpairVars#0;
     subList := splice apply (toList(0..n-1) , 
	  i ->  (W.dpairVars#0#i => -W.dpairVars#1#i,
	         W.dpairVars#1#i => W.dpairVars#0#i) );
     substitute(I, subList) )	    

Fourier(List) := (L) -> (apply (L, i -> Fourier i) )

-- These routines compute the transposition automorphism, which is used
-- to turn right modules to left modules and vice versa.  Currently slow.
Dtransposition = method()
Dtransposition(RingElement) := (L) -> (
     W := ring L;
     if (W.monoid.Options.WeylAlgebra === {}) then
     error "expected an element of a Weyl algebra";
     if (W.?dpairVars === false) then createDpairs(W);

     if (L != 0) then (     
     	  coordPart := substitute( (coefficients L)#0, 
	       join ( apply(W.dpairVars#1, j -> j=>1), 
		    apply(W.dpairVars#2, j -> j=>1) ) );
     	  otherPart := substitute( matrix{terms L}, 
	       join ( apply(W.dpairVars#0, j -> j=>1),
	       	    apply(W.dpairVars#1, j -> j=>-j) ) );
     	  transL := (coordPart * (transpose otherPart))_(0,0);
	  )
     else transL = 0_W;
     transL
     )

Dtransposition(Matrix) := (m) -> (
     W := ring m;
     if (W.monoid.Options.WeylAlgebra === {}) then
     error "expected an element of a Weyl algebra";
     if (W.?dpairVars === false) then createDpairs(W);
     
     if (numgens source m == 0 or numgens target m == 0) then mtrans := m
     else mtrans = matrix apply( entries m, i -> 
	  (apply (i, j -> Dtransposition j)) );
     mtrans
     )

Dtransposition(Ideal) := (I) -> (
     ideal Dtransposition gens I
     )

Dtransposition(ChainComplex) := (C) -> (
     W := ring C;
     if (W.monoid.Options.WeylAlgebra === {}) then
     error "expected an element of a Weyl algebra";
     if (W.?dpairVars === false) then createDpairs(W);

     apply( keys C.dd, i -> if (class C.dd#i === Matrix) then
	       	    C.dd#i = Dtransposition C.dd#i);
     C
     )

-- puts a module or matrix purely in shift degree 0.
zeroize = method()
zeroize(Module) := (M) -> (
     W := ring M;
     P := presentation M;
     coker map(W^(numgens target P), W^(numgens source P), P)
     )

zeroize(Matrix) := (m) -> (
     W := ring m;
     map(W^(numgens target m), W^(numgens source m), m)
     )

-- Auto-reduction
autoReduce = method()
autoReduce Matrix := (m) -> (
     sendgg(ggPush m, ggautoreduce);
     getMatrix ring m)


-- This routine computes the dimension of a D-module
Ddim = method()
Ddim(Ideal) := (I) -> (
     -- preprocessing
     W := ring I;
     -- error checking
     if  W.monoid.Options.WeylAlgebra === {} 
     then error "expected a Weyl algebra";
     -- do the computation
     gbI := gb I;
     if (W.?CommAlgebra == false) then createCommAlgebra(W);
     ltI := W.WAtoCA leadTerm gens gbI;
     dim ideal ltI
     )

Ddim(Module) := (M) -> (
     -- preprocessing
     W := ring M;
     m := presentation M;
     -- error checking
     if  W.monoid.Options.WeylAlgebra === {} 
     then error "expected a Weyl algebra";
     -- do the computation
     gbm := gb m;
     if (W.?CommAlgebra == false) then createCommAlgebra(W);
     ltm := W.WAtoCA leadTerm gens gbm;
     dim cokernel ltm
     )

-- This routine determines whether a D-module is holonomic
isHolonomic = method()
isHolonomic(Ideal) := (I) -> (
     -- preprocessing
     W := ring I;
     -- error checking
     if (W.monoid.Options.WeylAlgebra === {})
     then error "expected a Weyl algebra";
     if (W.?dpairVars == false) then createDpairs(W);
     if (W.dpairVars#2 =!= {})
     then error "expected a Weyl algebra without central parameters";
     Ddim I == #(W.dpairVars#0)
     )

isHolonomic(Module) := (M) -> (
     -- preprocessing
     W := ring M;
     -- error checking
     if (W.monoid.Options.WeylAlgebra === {})
     then error "expected a Weyl algebra";
     if (W.?dpairVars == false) then createDpairs(W);
     if (W.dpairVars#2 =!= {})
     then error "expected a Weyl algebra without central parameters";
     Ddim M == #(W.dpairVars#0)
     )

-- This routine computes the rank of a D-module
Drank = method()
Drank(Ideal) := (I) -> (
     Drank ((ring I)^1/I)
     )

Drank(Module) := (M) -> (
     W := ring M;
     if (W.?dpairVars === false) then createDpairs(W);
     n := #(W.dpairInds#0);
     m := numgens W;
     presM := presentation M;
     -- get weight vectors for the order filtration refined 
     -- by lex on the derivatives
     weightList := { apply ( toList(0..m-1), i -> if member(i, W.dpairInds#1) 
	  then 1 else 0 ) };
     -- ring equipped with the new order
     tempW := (coefficientRing W)[(entries vars W)#0,
	  WeylAlgebra => W.monoid.Options.WeylAlgebra,
	  Weights => weightList];
     WtotempW := map (tempW, W, vars tempW);
     -- commutative ring of derivative variables
     Rvars := symbol Rvars;
     R := (coefficientRing W)[apply(toList(0..n-1), i -> Rvars_i)];
     newInds := invPermute join(W.dpairInds#1, W.dpairInds#0);
     matList := apply( toList(0..m-1), i -> if (newInds#i < n) 
	  then R_(newInds#i) else 1_R );
     tempWtoR = map (R, tempW, matrix{ matList });
     -- computing GB with respect to new order
     ltM := leadTerm gens gb WtotempW presM;
     -- compute the rank
     redI := cokernel tempWtoR ltM;
     if (dim redI > 0) then holRank := infinity
     else if (redI == 0) then holRank = 0
     else holRank = numgens source basis (redI);
     holRank
     )

-- This routine computes the characteristic ideal of a D-module
charIdeal = method()
charIdeal(Ideal) := (I) -> (
     W := ring I;
     if (W.monoid.Options.WeylAlgebra == {})
     then error "expected a Weyl algebra";
     if (W.?dpairVars == false) then createDpairs(W);
     w := apply( toList(0..numgens W - 1), 
	  i -> if member(i, W.dpairInds#1) then 1 else 0 );
     ideal mingens inw (I, w)
     )

charIdeal(Module) := (M) -> (
     W := ring M;
     m := presentation M;
     if (W.monoid.Options.WeylAlgebra == {})
     then error "expected a Weyl algebra";
     if (W.?dpairVars == false) then createDpairs(W);
     w := apply( toList(0..numgens W - 1), 
	  i -> if member(i, W.dpairInds#1) then 1 else 0 );
     ideal mingens ann cokernel inw (m, w)
     )

-- This routine computes the singular locus of a D-ideal
-- SHOULD IT BE CHANGED SO THAT OUTPUT IS IN POLY SUBRING?
singLocus = method()
singLocus(Ideal) := (I) -> (
     singLocus ((ring I)^1 / I)
     )

singLocus(Module) := (M) -> (
     W := ring M;
     if (W.?dpairVars === false) then createDpairs(W);
     if (W.?CommAlgebra === false) then createCommAlgebra(W);
     I1 := charIdeal(M);
     I2 := W.WAtoCA (ideal W.dpairVars#1) ;
     -- do the saturation
     SatI := saturate(I1, I2);
     -- set up an auxilary ring to perform intersection
     tempCA := (coefficientRing W)[W.dpairVars#1, W.dpairVars#0, 
          MonomialOrder => Eliminate (#W.dpairInds#1)];
     newInds := invPermute join(W.dpairInds#1, W.dpairInds#0);
     CAtotempCA := map(tempCA, W.CommAlgebra, 
	  matrix {apply(newInds, i -> tempCA_i)});
     tempCAtoCA := map(W.CommAlgebra, tempCA, matrix{ join (
		    apply(W.dpairVars#1, i -> W.WAtoCA i),
	            apply(W.dpairVars#0, i -> W.WAtoCA i) ) } );
     use W;
     -- do the intersection
     gbSatI := gb CAtotempCA SatI;
     I3 = ideal compress tempCAtoCA selectInSubring(1, gens gbSatI);
     if (I3 == ideal 1_(W.CommAlgebra)) then (W.CAtoWA I3)
     else (W.CAtoWA radical I3)
     )

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- This routine prunes a matrix (whose cokernel represents a module) by
-- computing a GB and removing any column whose leadterm is a constatnt
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
GBprune = method()
GBprune(Matrix) := (M) -> (
     Mgb := gens gb M;
     n := numgens source Mgb;
     columnList := {};
     i := 0;
     while (i < n) do (
     	  lc := leadComponent Mgb_i;
	  if (Mgb_(lc,i) != 1) then
	       columnList = append(columnList, i);
	  i = i+1;
	  );
     if (columnList == {}) then Mnew = 0
     else Mnew := transpose compress matrix apply(columnList, 
     	  i -> ( (entries transpose Mgb_{i})#0 ) );
     Mnew
     )

GBprune(Module) := (M) -> (
     if (not isQuotientModule M) then error "GBprune expected a quotient module";
     cokernel GBprune relations M
     )


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- The routine Dprune prunes a matrix by using engine's reduceCompress()
--
-- Options:
--   2) GB:     By default, a Grobner basis is computed and returned.
--     	    	The algorithm doesn't stop until the GB stabilizes.
--     	    	To only return the matrix after reducing pivots and compressing,
--     	    	set "GB => false".  The difference is that computing a gb may
--     	    	lead to the appearance of more 1's
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Dprune = method(Options => {GB => true})
Dprune(Matrix) := options -> (M) -> (
     temp = reduceCompress M;
     if (options.GB) then (
	  proceedflag := true;
	  while (proceedflag) do (
	       temp2 := reduceCompress gens gb temp;
	       if (temp2 === null or temp2 == temp) then proceedflag = false;
	       temp = temp2;
	       );
	  );
     temp
     )

Dprune(Module) := options -> (M) -> (
     if (not isQuotientModule M) then error "Dprune expected a quotient module";
     cokernel Dprune relations M
     )

--- OLD VERSION OF Dprune.  Will be phased out ---
Dprune2 = method(Options => {GB => true})
Dprune2(Matrix) := options -> (M) -> (
     Dprune cokernel M
     )
