--		Copyright 1995-2002 by Daniel R. Grayson

gcd(RingElement,RingElement) := RingElement => (r,s) -> new ring r from rawGCD(raw r, raw s)
---- old way:
--  							(
--      if r == 0 then s
--      else if s == 0 then r
--      else (
-- 	  z := syz( matrix{{r,s}}, SyzygyLimit => 1 );
-- 	  a := z_(0,0);
-- 	  if s%a != 0 then error "can't find gcd in this ring";
-- 	  t := s // a;
-- 	  if isField coefficientRing ring t then (
-- 	       c := leadCoefficient t;
-- 	       t = t // c;
-- 	       );
-- 	  t))

gcdCoefficients(RingElement,RingElement) := (f,g) -> (
     R := ring f;
     if R =!= ring g then error "expected elements of the same ring";
     error "gggcdextended not re-implemented";
     sendgg(ggPush f, ggPush g, gggcdextended);
     q := R.pop();
     p := R.pop();
     sendgg(ggpop);
     {p,q})     

pseudoRemainder = method()
pseudoRemainder(RingElement,RingElement) := RingElement => (f,g) -> (
     R := ring f;
     if R =!= ring g then error "expected elements of the same ring";
     new R from rawPseudoRemainder(raw f, raw g));

reorder := I -> (
     f := generators I;
     R := ring I;
     v := rawIdealReorder raw f;
     assert( #v == numgens R );
     v)

lcm2 := (x,y) -> x*y//gcd(x,y)
lcm := args -> (
     n := 1;
     scan(args, i -> n = lcm2(n,i));
     n)
commden := (f) -> (
     lcm apply(
	  first entries lift((coefficients f)#1, QQ),
	  denominator))

irreducibleCharacteristicSeries = method()
irreducibleCharacteristicSeries Ideal := I -> (
     f := generators I;
     --f = compress f;					    -- avoid a bug 
     R := ring I;
     if not isPolynomialRing R 
     then error "expected ideal in a polynomial ring";
     k := coefficientRing R;
     if not isField k then error "factorization not implemented for coefficient rings that are not fields";
     if k === QQ then f = matrix { first entries f / (r -> r * commden r) };
     re := reorder I;
     n := #re;
     f = substitute(f,apply(n,i -> R_(re#i) => R_i));
     ics := rawCharSeries raw f;
     ics = apply(ics, m -> map(R,m));
     phi := map(R,R,apply(n,i->R_(re#i)));
     {ics,phi}
     )

factor ZZ := options -> (n) -> Product apply(sort pairs factorInteger n, (p,i)-> Power{p,i} )
factor QQ := options -> (r) -> factor numerator r / factor denominator r
-----------------------------------------------------------------------------
topCoefficients = method()
topCoefficients Matrix := f -> (
     R := ring f;
     sendgg(ggPush f, ggcoeffs);
     monoms := getMatrix R;
     coeffs := getMatrix R;
     {monoms, coeffs})

decompose = method()
decompose(Ideal) := (I) -> if I.cache.?decompose then I.cache.decompose else I.cache.decompose = (
     R := ring I;
     if isQuotientRing R then (
	  A := ultimate(ambient, R);
	  I = lift(I,A);
	  )
     else A = R;
     if not isPolynomialRing A then error "expected ideal in a polynomial ring or a quotient of one";
     if I == 0 then return {if A === R then I else ideal 0_R};
     ics := irreducibleCharacteristicSeries I;
     Psi := apply(ics#0, CS -> (
	       CS = matrix {CS};
	       chk := topCoefficients CS;
	       chk = chk#1;		  -- just keep the coefficients
	       chk = first entries chk;
	       iniCS := select(chk, i -> degree i =!= {0});
	       CS = ideal CS;
	       -- << "saturating " << CS << " with respect to " << iniCS << endl;
	       -- warning: over ZZ saturate does unexpected things.
	       scan(iniCS, a -> CS = saturate(CS, a, Strategy=>Eliminate));
	       -- << "result is " << CS << endl;
	       CS));
     Psi = new MutableList from Psi;
     p := #Psi;
     scan(0 .. p-1, i -> if Psi#i =!= null then 
	  scan(i+1 .. p-1, j -> 
	       if Psi#i =!= null and Psi#j =!= null then
	       if isSubset(Psi#i, Psi#j) then Psi#j = null else
	       if isSubset(Psi#j, Psi#i) then Psi#i = null));
     Psi = toList select(Psi,i -> i =!= null);
     components := apply(Psi, p -> ics#1 p);
     if A =!= R then (
	  components = apply(components, I -> ideal(generators I ** R));
	  );
     components
     )

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/m2 "
-- End:
