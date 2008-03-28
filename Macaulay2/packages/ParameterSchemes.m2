newPackage(
	"ParameterSchemes",
    	Version => "0.01", 
    	Date => "February 21, 2008",
    	Authors => {{Name => "Mike Stillman", 
		  Email => "mike@math.cornell.edu", 
		  HomePage => "http://www.math.cornell.edu/~mike/"}},
    	Headline => "a Macaulay 2 package for local equations of Hilbert and other parameter schemes",
    	DebuggingMode => true
    	)

export { smallerMonomials, 
     standardMonomials, 
     parameterFamily, 
     parameterIdeal, 
     pruneParameterScheme, 
     groebnerScheme,
     reduceLinears,
     minPressy,
     subMonomialOrder,
     subMonoid,
     isReductor
     }

subMonoid = method()
subMonoid (Monoid, List) := (M, l) -> (
     -- 2 arguments: a monoid and a list that is a list of the
     -- variables, or positions of the variables to be used in 
     -- the new monoid.
     -- return: A new monoid corresponding to the subset of the
     -- variables in l.
     --if not isPolynomialRing then error "input must be a polynomial ring.";
     if #l == 0 then M else (
     	  newM := new MutableHashTable from M.Options;
     	  numVars := #newM#Variables;
     	  count := 0;
     	  if class l_0 === ZZ then newM#Variables = apply(l, i -> newM#Variables#i)
     	  else (newM#Variables = l;
	       l = l/index);
     	  newM#MonomialOrder = subMonomialOrder(newM#MonomialOrder, l);
     	  skewC := newM#SkewCommutative;
     	  skewN := #newM#SkewCommutative;
     	  if  skewN =!= 0 then (
	       if skewN =!= numVars then (
	       	    if class skewC#0 === IndexedVariable then skewC = skewC/index;
	       	    L := (set l) * (set skewC);
	       	    newM#SkewCommutative = toList L;
	       	    );
	       );
     	  newM#Degrees = apply(l, i -> newM#Degrees#i);
     	  OP := new OptionTable from newM;
     	  monoid([OP])
	  )
     )
	  


subMonomialOrder = method()
subMonomialOrder (List,List) := (Ord, l) -> (
     -- 2 arguments: a monomial order, given as a list, and a list of
     -- the positions of the variables to be used in the new ring.
     -- return:  a new monomial order corresponding to the subset of 
     --          of variables in l.
     localListCheck = l_(#l-1);
     subMonOrderHelper(Ord,l, 0, {})
     )

subMonOrderHelper = (Ord, l, count, newOrd) -> (
     -- 4 arguments: a monomial order, given as a list, a list of the
     -- positions of the variables to be used in the new ring, 
     if #Ord == 0 then (
	  if  localListCheck > count-1 then error("expected variable indices in range 0.." | count-1)
	  else (
	       newOrd = select(newOrd, i -> (i#1 =!= {} and i#1 =!= 0));
	       return newOrd))
     else(
     	  if Ord#0#0 === Weights then (
	       w := #Ord#0#1;  -- the old list of weights
	       lw := select(l, i -> i <= w+count-1); 
	       ww := apply(lw, i -> Ord#0#1#(i-count));
	       return subMonOrderHelper(drop(Ord,1),l, count, append(newOrd, Ord#0#0 => ww)) 	   	     
	       );
     	  if Ord#0#0 === GRevLex then (
	       w = #Ord#0#1;
	       lw = select(l, i -> i <= #Ord#0#1+count-1);
	       return subMonOrderHelper(drop(Ord,1), 
		    drop(l, #lw), 
		    count + #Ord#0#1, 
		    append(newOrd, Ord#0#0 => apply(lw, i -> Ord#0#1#(i-1-count)))); 
	       );    
     	  if (Ord#0#0 === Lex or Ord#0#0 === RevLex or 
	       Ord#0#0 === GroupLex or 
	       Ord#0#0 ===  GroupRevLex) 
     	  then ( 
	       u = #(select(l, i -> i <= count + Ord#0#1 - 1));
	       return subMonOrderHelper(drop(Ord, 1), 
		    drop(l, u), 
		    count + Ord#0#1, 
		    append(newOrd, Ord#0#0 => u));
	       );
     	  if (Ord#0#0 === Position or Ord#0#0 === MonomialSize) then (
	       return subMonOrderHelper(drop(Ord, 1), l, count, 
		    append(newOrd, Ord#0#0 => Ord#0#1));
	       );
	  )
     )

--- needs work for operation over ZZ	    	    
isReductor = (f) -> (
     inf := leadTerm part(1,f);
     inf != 0 and
     (set support(inf) * set support(f - inf)) === set{})

findReductor = (L) -> (  
     L1 := sort apply(L, f -> (size f,f));
     L2 := select(1, L1, p -> isReductor(p#1));
     if #L2 > 0 then (
	  p := part(1,L2#0#1);
	  coef := (terms p)/leadCoefficient;
	  pos := position(coef, i -> (i == 1) or (i == -1));
	  if pos =!= null then (
     	       t := (terms p)_pos;
	       lct := leadCoefficient t;
	       (lct*t, lct*t - lct*L2#0#1)
	       )
	  else(t = leadTerm p;
	       lct = 1/(leadCoefficient t);
	       (lct*t, lct*t - lct*L2#0#1))
     	  )
     )

reduceLinears = method(Options => {Limit=>infinity})
reduceLinears Ideal := o -> (I) -> (
     -- returns (J,L), where J is an ideal,
     -- and L is a list of: (variable x, poly x+g)
     -- where x+g is in I, and x doesn't appear in J.
     -- also x doesn't appear in any poly later in the L list
     R := ring I;
     L := flatten entries gens I;
     count := o.Limit;
     M := while count > 0 list (
       count = count - 1;
       g := findReductor L;
       if g === null then break;
       << "reducing using " << g#0 << endl << endl;
       F = map(R,R,{g#0 => g#1});
       L = apply(L, i -> F(i));
--       error "checking";
       g
       );
     -- Now loop through and improve M
     M = backSubstitute M;  -- rewrite as M will now be a list of pairs....
     (ideal L, M)
     )

backSubstitute = method()
backSubstitute List := (M) -> (
     -- If M has length <= 1, then nothing needs to be done
     if #M <= 1 then M
     else (
     	  xs := set apply(M, i -> i#0);
     	  R := ring M#0#0;
     	  F := map(R,R, apply(M, g -> g#0 => g#1));
     	  H := new MutableHashTable from apply(M, g -> g#0 =>  g#1);
     	  scan(reverse M, g -> (
	       v := g#0;
	       restg := H#v;
	       badset := xs * set support restg;
	       if badset =!= set{} then (
		    H#v = F(restg))
	       ));
         pairs H)
     )

minPressy = method()
minPressy Ideal := (I) -> (
     -- if the ring I is a tower, flatten it here...
     R := ring I;
     flatList := flattenRing R;
     flatR := flatList_0;
     if any((monoid flatR).Options.Degrees, i -> i =!= {1}) then (
	  S := (coefficientRing flatR)(monoid[gens flatR,
		    MonomialOrder => (monoid flatR).Options.MonomialOrder,
		    Global => (monoid flatR).Options.Global]);
	  presR := substitute(ideal presentation flatR, S);
	  S = S/presR;
	  )
     else  S = flatR; 
     IS := substitute(I, vars S);
     if class S === QuotientRing then (
	  defI := ideal presentation S; 
	  S = ring defI;
	  IS = defI + substitute(IS, S)
  	  );
     (J,G) := reduceLinears(IS);
     xs := set apply(G, first);
     varskeep := rsort (toList(set gens S - xs));
     newS := (coefficientRing S)(subMonoid(monoid S,varskeep));
     if not isSubset(set support J, set varskeep) -- this should not happen
     then error "internal error in minPressy: not all vars were reduced in ideal";
     I.cache.minimalPresentationMapInv = map(R,S)*map(S, newS, varskeep);
     -- Now we need to make the other map...
     X := new MutableList from gens S;
     scan(G, (v,g) -> X#(index v) = g);
     maptoS := apply(toList X, f -> substitute(f,newS));
     I.cache.minimalPresentationMap = map(newS,S,maptoS)*map(S, flatR)*flatList_1;
     substitute(ideal compress gens J,newS)
     )

minimalPresentation Ideal := opts -> (I) -> (
     << "entering minPressy"<< endl;
--     error "debug me";
     result := minPressy(I);
     result)

minimalPresentation Ring := opts -> (R) -> (
     << "entering minPressy"<< endl;
--     error "debug me";
     result := minPressy(ideal presentation R);
     (ring result)/result)


findReductorOld = (L) -> ( 
     L1 := select(L, isReductor);
     L2 := sort apply(L1, f -> (size f,f));
     if #L2 > 0 then L2#0#1)

reduceLinearsOld = method(Options => {Limit=>infinity})
reduceLinearsOld Ideal := o -> (I) -> (
     -- returns (J,L), where J is an ideal,
     -- and L is a list of: (variable x, poly x+g)
     -- where x+g is in I, and x doesn't appear in J.
     -- also x doesn't appear in any poly later in the L list
     R := ring I;
     -- make sure that R is a polynomial ring, no quotients
     S := (coefficientRing R)[gens R, Weights=>{numgens R:-1}, Global=>false];
     IS := substitute(I,S);
     L := flatten entries gens IS;
     count := o.Limit;
     M := while count > 0 list (
       count = count - 1;
       g := findReductor L;
       if g === null then break;
       g = 1/(leadCoefficient g) * g;
       << "reducing using " << leadTerm g << endl << endl;
       L = apply(L, f -> f % g);
       g
       );
     -- Now loop through and improve M -- list of pairs of var and
     -- what it goes to...substitute vs. reduction.
     M = backSubstituteOld M;
     M = apply(M, (x,g) -> (substitute(x,R),substitute(g,R)));
     (substitute(ideal L,R), M)
     )

backSubstituteOld = method()
backSubstituteOld List := (M) -> (
     xs := set apply(M, leadMonomial);
     H := new MutableHashTable from apply(M, g -> leadTerm g => (-g+leadTerm g));
     scan(reverse M, g -> (
	       v := leadTerm g;
	       restg := H#v;
	       badset := xs * set support restg;
	       scan(toList badset, x -> (
			 << "back reducing " << v << " by " << x << endl; --<< " restg = " << restg << endl;
			 restg = restg % (x-H#x)));
	       H#v = restg;
	       ));
     pairs H
     ) 

smallerMonomials = method()
smallerMonomials(Ideal,RingElement) := (M,f) -> (
     -- input: a polynomial in a poly ring R
     -- output: an ordered list of monomials of R less than f, but of the same
     --   degree as (the leadterm of) f.
     d := degree f;
     m := flatten entries basis(d,coker gens M);
     m = f + sum m;
     b := apply(listForm m, t -> R_(first t));
     x := position(b, g -> g == f);
     drop(b,x+1))

smallerMonomials(Ideal,RingElement,ZZ) := (M,f,dummy) -> (
     -- input: a polynomial in a poly ring R
     -- output: an ordered list of monomials of R less than f, but of the same
     --   degree as (the leadterm of) f.
     d := degree f;
     m := flatten entries basis(d,coker gens M);
     select(m, m0 -> m0 < f))

smallerMonomials(Ideal) := (M) -> (
     Mlist := flatten entries gens M;
     apply(Mlist, m -> smallerMonomials(M,m)))

smallerMonomials(List) := (L) -> (
     M := ideal L;
     apply(L, m -> smallerMonomials(M,m)))

standardMonomials = method()
standardMonomials(ZZ,Ideal) :=
standardMonomials(List,Ideal) := (d,M) -> (
     (terms sum flatten entries basis(d,comodule M))/leadMonomial
     )

standardMonomials(Ideal) := (I) -> (
     L := flatten entries generators I;
     apply(L, f -> standardMonomials(degree f, I))
     )
standardMonomials(List) := (L) -> (
     I := ideal L;
     apply(L, f -> standardMonomials(degree f, I))
     )

parameterFamily = method(Options=>{Local=>false})
parameterFamily(Ideal,List,Symbol) := opts -> (M,L,t) -> (
     -- M is a monomial ideal
     -- L is a list of lists of monomials, #L is the
     --  number of generators of M.
     local R1;
     local U;
     local phi;
     R := ring M;
     kk := coefficientRing R;
     nv := sum apply(L, s -> #s);
     if opts.Local then (
         R1 = kk{t_1..t_nv}; -- removed MonomialSize=>8
	 U = kk[gens R,t_1..t_nv,MonomialOrder=>{
		   Weights=>splice{numgens R:0,nv:-1},numgens R,nv},
	           Global=>false];
	 phi = map(U,R1,toList(U_(numgens R) .. U_(nv - 1 + numgens R)));
         )
     else (
	 R1 = kk[t_1..t_nv]; -- removed MonomialSize=>8
     	 U = R1 (monoid R);
	 phi = map(U,R1);
     );
     lastv := -1;
     Mlist := flatten entries gens M;
     elems := apply(#Mlist, i -> (
	       m := Mlist_i;
	       substitute(m,U) + sum apply(L#i, p -> (
			 lastv = lastv + 1;
			 phi(R1_lastv) * substitute(p,U)))));
     ideal elems
     )

parameterIdeal = method()
parameterIdeal(Ideal,Ideal) := (M,family) -> (
     -- M is a monomial ideal in a polynomial ring
     -- family is the result of a call to 'parameterFamily'
     R := ring M;
     time G = forceGB gens family;
     time syzM = substitute(syz gens M, ring family);
     time eq = compress((gens family * syzM) % G);
     --time (mons,eqns) := toSequence coefficients(toList(0..(numgens R)-1), eq);
     time (mons,eqns) = coefficients(eq); -- , Variables=>apply(gens R, x -> substitute(x,ring eq)));
     ideal lift(eqns,coefficientRing ring eqns))

pruneParameterScheme = method()
pruneParameterScheme(Ideal,Ideal) := (J,F) -> (
     R := ring F;
     A := coefficientRing R;
     if ring J =!= A then error "expected(ideal in coeffring A, family in A[x])";
     time J1 := minPressy J;
     map1 := J.cache.minimalPresentationMap;
     map2 := J.cache.minimalPresentationMapInv;
     B := ring J1;
     phi := map2; -- map: A --> B
     -- want the induced map from A[x] -> B[x]
     S := B (monoid R);
     phi' := map(S,R,vars S | substitute(phi.matrix,S));
     (J1, phi' F)
     )

groebnerScheme = method(Options=>{Minimize=>true})
groebnerScheme Ideal := opts -> (I) -> (
     L1 := smallerMonomials I;
     F0 := parameterFamily(I,L1,symbol t);
     J0 := parameterIdeal(I,F0);
     if opts.Minimize then
       (J0,F0) = pruneParameterScheme(J0,F0);
     (J0,F0)
     )

beginDocumentation()
document { 
     Key => ParameterSchemes,
     Headline => "a Macaulay 2 package for local equations of Hilbert and other parameter schemes",
     EM "ParameterSchemes", " is a package containing tools to create parameter schemes, 
     especially about a monomial ideal.",
     PARA{},
     "An example of using the functions in this package:",
     EXAMPLE lines ///
         R = ZZ/101[a..e,MonomialOrder=>Lex];
         I = ideal"ab,bc,cd,ad";
         L1 = smallerMonomials I;
	 ///,
     PARA{"We will construct the family of all ideals having I as its lexicographic initial ideal."},
     EXAMPLE lines ///
         F0 = parameterFamily(I,L1,symbol t);
	 netList first entries gens F0
	 J0 = parameterIdeal(I,F0);
         ///,
     "At this point F0 is the universal family, and J0 is a (very non-minimally generated) ideal that
     the parameters must satisfy in order for the family to be flat.",
     PARA{},
     "We can minimalize the family, and the ideal.",
     EXAMPLE lines ///
         (J,F) = pruneParameterScheme(J0,F0);
	 J
	 netList first entries gens F
	 ///,
     "Notice that J is zero.  This means that the base is an affine space (in this case affine 8-space).
     Now let's find a random fiber over the base:",
     EXAMPLE lines ///
         B = ring J
	 S = ring F
	 rand = map(R,S,(vars R) | random(R^1, R^(numgens B)))
	 L = rand F
         ///,
     "In some sense, L is the 'generic' ideal having I as its lexicographic initial ideal.  
     Let's investigate
     L further:",
     EXAMPLE lines ///
	 leadTerm L
         betti res L
     	 primaryDecomposition L	 
     ///,
     "Note that this strongly indicates that every ideal with I as its 
     lexicographic initial ideal is not prime."
     }

document {
     Key => {(groebnerScheme,Ideal),groebnerScheme},
     Headline => "find the family of all ideals having a given monomial ideal as initial ideal",
     Usage => "(J,F) = groebnerScheme I\n(J,F) = groebnerScheme(I, Minimize=>false)",
     Inputs => { "I" => "a monomial ideal in a polynomial ring R",
	  Minimize => "set to false if minimalization of the ideal and family is 
	  not desired, or is too compute intensive" },
     Outputs => {
	  "J" => Ideal => "the ideal defining the base space",
	  "F" => Ideal => "the family"
	  },
     "The ideal J is in a ring A = kk[t_1, t_2, ....].  The scheme defined by J
     is the Groebner scheme of (I,>), where > is the monomial order in the ring of I.
     The ideal F is the ideal of the family, in the ring: A[gens R] (more precisely: A (monoid R)",
     PARA{},
     "As an example, we compute the groebner scheme of the following ideal.  The resulting parameter space
     is affine 8-space, and so is smooth, rational and irreducible.",	  
     EXAMPLE lines ///
         R = ZZ/101[a..e];
	 I = ideal"ab,bc,cd,ad";
	 (J,F) = groebnerScheme I;
	 J
	 netList first entries gens F
	 ///,
     SourceCode => {(groebnerScheme,Ideal)},
     SeeAlso => {parameterIdeal, parameterFamily, pruneParameterScheme, smallerMonomials}
     }

--document {
--     Key => {subMonomialOrder}

{* 
document {
	Key => {(firstFunction,ZZ),firstFunction},
	Headline => "a silly first function",
	Usage => "firstFunction n",
	Inputs => { "n" },
	Outputs => {{ "a silly string, depending on the value of ", TT "n" }},
        SourceCode => {(firstFunction,ZZ)},
	EXAMPLE lines ///
	   firstFunction 1
	   firstFunction 0
     	///
	}
*}
TEST ///
    assert ( firstFunction 2 == "D'oh!" )
///


end
restart
loadPackage "ParameterSchemes"
installPackage ParameterSchemes
viewHelp ParameterSchemes

R = ZZ/101[x_1..x_4, MonomialOrder =>{Lex => 2, GroupLex => 2}, Global => false]
M = (monoid R).Options.MonomialOrder
w = {2, 4}
inducedMonomialOrder(M,w)


-- Example: triangle, giving twisted cubic --
kk = ZZ/101
R = kk[a..d]
I = ideal"ab,bc,ca"
time (J,F) = groebnerScheme(I);
A = ring J; B = ring F
-- Since J is 0, let's see what a random such fiber looks like
phi = map(R,B,(vars R)|random(R^1, R^(numgens A)))
L = phi F
leadTerm L
decompose L

-- Hi Amelia, here is a good example:
-- Amelia Amelia Amelia Amelia Amelia Amelia Amelia Amelia
kk = ZZ/101
R = kk[a..f]
I = ideal"ab,bc,cd,de,ea,ac"
time (J,F) = groebnerScheme(I);
time (J,F) = groebnerScheme(I, Minimize=>false);
time minimalPresentation J;
A = ring J
B = ring F
Alocal = kk{gens A, MonomialSize => 8} 
Jlocal = sub(J,Alocal);
gbTrace=3
Jlocal = ideal gens gb Jlocal
J1 = trim(ideal(t_40) + Jlocal)
J2 = Jlocal : t_40
P = minPressy J2;
-- Now: I want a point on V(J), on this component...
-- This should be a function?
A1 = ring P
phi2
psi = map(kk,A1,random(kk^1, kk^(numgens A1)))
g = psi * phi2
g Jlocal
g = map(kk,A,g.matrix)
g J
g' = map(R,B,(vars R) | sub(g.matrix,R))
L = g' F
leadTerm L
res L

use ring J
J' = ideal apply(flatten entries gens J, f -> f // t_40);
minPressy J'
-- There are two smooth components through the ideal I.
-- Amelia Amelia Amelia Amelia Amelia Amelia Amelia Amelia

-- Example: in the local case --
kk = ZZ/101
R = kk[a,b,c]
I = ideal"ab,ac,bc"
Z = syz gens I
A = apply(degrees source gens I, d -> matrix basis(d,comodule I))
B = apply(degrees source Z, d -> matrix basis(d, coker Z))
ngens = sum apply(A, a -> numgens source a)
nsyz = sum apply(B, b -> numgens source b)
S = kk[gens R, s_1..s_nsyz, t_1..t_ngens, MonomialSize=>8]
firstvar = numgens R+nsyz-1;
G' = matrix {apply(numgens I, i -> (
	  substitute(I_i,S) + sum apply(first entries A_i, m -> (
		    firstvar=firstvar+1;substitute(m,S) * S_firstvar))
	  ))}
firstvar = numgens R - 1;
Z' = matrix{apply(numgens source Z, i -> (
	  substitute(Z_{i},S) + sum apply(numgens source B_i, j -> (
		    firstvar=firstvar+1;S_firstvar ** substitute((B_i)_{j}, S)))
	  ))}
coefficients(G' * Z', Variables => {S_0 .. S_(numgens R-1)})
J = ideal flatten entries oo_1
J0 = (minPressy J)_0
S = kk{gens S, MonomialSize=>8}
J0 = substitute(J0,S)
gbTrace=3
gens gb J0

Istd = standardMonomials I
F = parameterFamily(I,Istd,symbol t,Local=>true)
parameterIdeal(I,F)
f = F_0
g = F_1
h = F_2
c*f-b*g + t_4*a*f -a*g*t_1 - b*t_2*h
(b*c^2) % G
b*c^2 - c*h + a*t_7*g
--------------------------------


R = ZZ/101[a..e,MonomialOrder=>Lex]
I = ideal"ab,bc,cd,ad"
time (J,F) = groebnerScheme I

L1 = smallerMonomials I
F0 = parameterFamily(I,L1,symbol t)
J0 = parameterIdeal(I,F0)
(J,F) = pruneParameterScheme(J0,F0)
B = ring J
rand = map(R,ring F,(vars R) | random(R^1, R^(numgens B)))
L = rand F
primaryDecomposition L
primaryDecomposition I

R = ZZ/101[a..f]
I = ideal"ab,bc,cd,ad"
L1 = smallerMonomials I
F0 = parameterFamily(I,L1,symbol t)
J0 = parameterIdeal(I,F0)
(J,F) = pruneParameterScheme(J0,F0)
B = ring J
rand = map(R,ring F,(vars R) | random(R^1, R^(numgens B)))
L = rand F
primaryDecomposition L
primaryDecomposition I

R = ZZ/101[a..f]
I = ideal"ab,bc,cd,de,ea,ad"
(J,F) = groebnerScheme I
Alocal = kk{gens ring J, MonomialSize=>8}
Jlocal = sub(J,Alocal)
gbTrace=3
time gens gb Jlocal;

L1 = smallerMonomials I
F0 = parameterFamily(I,L1,symbol t)
J0 = parameterIdeal(I,F0);
time (J,F) = pruneParameterScheme(J0,F0);
B = ring J
rand = map(R,ring F,(vars R) | random(R^1, R^(numgens B)))
L = rand F
decompose J
intersect oo == J -- yes
primaryDecomposition L
primaryDecomposition I

R = ZZ/101[a..e]
I = ideal"ab,bc,cd,ade"
time (J,F) = groebnerScheme(I, Minimize=>false);
time (J,F) = groebnerScheme(I);
B = ring J
rand = map(R,ring F,(vars R) | random(R^1, R^(numgens B)))
L = rand F
decompose L
intersect oo == L -- 
primaryDecomposition L
primaryDecomposition I


L1 = smallerMonomials I
F0 = parameterFamily(I,L1,symbol t)
J0 = parameterIdeal(I,F0);
time minPressy J0;
time (J,F) = pruneParameterScheme(J0,F0);


R = ZZ/101[a..f,MonomialOrder=>Lex]
I = ideal"ab,bc,cd,ad,de"
L1 = smallerMonomials I
F0 = parameterFamily(I,L1,symbol t)
S = ring F1
J0 = parameterIdeal(I,F0)
(J,F) = pruneParameterScheme(J0,F0)

time minimalPresentation J
substitute(J.cache.minimalPresentationMap F1,S)
see oo

T = ZZ/101[gens ring J]
JT = substitute(J,T)
gens gb JT;
debug ParameterSchemes
B = flatten entries ((gens F1) * syzM)
B_0 % G
B_1 % G
H = flatten entries gens G
netList H
netList B
B_1 - e*t_18*H_1 +c*t_13*H_0 - d*t_13*t_19*H_0 + e*t_14*H_0 - e*t_13*t_20*H_0
B_1 % G

matrix{{B_1}} % G

A = (ZZ/101){t_1..t_30}
S = A[gens R]
smallerMonomials flatten entries gens I
L2 = standardMonomials I
F1 = parameterFamily(I,L1,symbol t)
S = ring F1
J = parameterIdeal(I,F1)
T = ZZ/101[gens ring J]
J = substitute(J,T)
gens gb J;
K = ideal select(flatten entries oo, f -> first degree f > 1)
minimalPresentation K
decompose oo
gens gb K
decompose K
(gens substitute(F1,T)) % J
ideal((gens F1) % (trim parameterIdeal(I,F1)))
compress gens oo
R = ZZ/101[a..e, MonomialOrder=>Lex]
I = ideal"ab,bc,cd,ad"
smallerMonomials I
smallerMonomials flatten entries gens I
standardMonomials I

-- AFTER THIS: TESTS FOR ROUTINES THAT HAVE BEEN RENAMED...
end
restart
path = prepend("/Users/mike/Macaulay2/code/",path)
load "localhilb.m2"
R = ZZ/32003[a..c]
I = ideal(a^2,a*b^2)
(J,fam) = localEquations(I,symbol t)
transpose gens gb J


R = ZZ/32003[a..d]
(J,fam) = localEquations(ideal(a*b, a*c, b^3), symbol t)
gbTrace = 3
gens gb J;
G = forceGB gens fam
syzI
eqs


F = J_(0,0)
F % G
g1 = fam_0 -- lead term a*b
g2 = fam_1 -- lead term a*c
g3 = fam_2 -- lead term b^3
F
use ring F
F + t_1 * a * g2 + t_5* d * g2 - t_9*a*g1 -t_10*g3 -t_13*d*g1 - t_2*t_9*b*g1
gens gb J


getStandardMonomials(I,3)
getStds I


family = familyIdeal(I,getStds I,t)
U = ring family
time G = forceGB gens family;
time syzI = substitute(syz gens I, ring family);
eqs = ((gens family) * syzI)
eqs1 = eqs % G
eqs2 = compress eqs1
coefficients({a,b,c},eqs2)
J = ideal oo_1
gbTrace = 3
gens gb J;
transpose gens gb J
R = ZZ/32003[s,t_1..t_11,MonomialOrder=>Eliminate 1]
J = ideal(t_2-t_1*t_6+t_6^2,
     t_4-t_3*t_6+t_2*t_7-t_1*t_8+2*t_6*t_8-t_6^2*t_7,
     -t_10+t_7*t_8+t_6*t_9-t_6*t_7^2,
     t_5+t_4*t_7-t_3*t_8+t_8^2+t_2*t_9-t_1*t_10+t_6*t_10-t_6*t_7*t_8,
     -t_11+t_8*t_9-t_6*t_7*t_9,
     t_5*t_7+t_4*t_9-t_3*t_10+t_8*t_10-t_1*t_11+t_6*t_11-t_6*t_7*t_10,
     t_5*t_9-t_3*t_11+t_8*t_11-t_6*t_7*t_11)
J = homogenize(J,s)
gens gb J
transpose gens gb J
mingens ideal substitute(leadTerm gens gb J, {s=>1})

-- example: initial ideal is an edge ideal
restart
path = prepend("/Users/mike/Macaulay2/code/",path)
load "localhilb.m2"
R = ZZ/32003[a..f]
I = ideal"ab,bc,cd,de,ea"
(J,fam) = localEquations(I,symbol t)
transpose gens gb J

--- Starting a possible test list for inducedMonomialOrder


restart
loadPackage"ParameterSchemes"

kk = ZZ/32003
R1 = kk[x_1..x_5, MonomialOrder => {GRevLex => 3, Weights => {2,2}, Lex => 2}]
R2 = kk[x_1..x_5, MonomialOrder => {GroupLex => 2, GroupRevLex => 1, Weights => {2,2}, Lex => 2}, Global => false]
R3 = kk[x_1..x_5, MonomialOrder => {Weights => {1,2,3}, Lex => 3, Weights => {2,2}, Lex => 2}]
M1 = (monoid R1).Options.MonomialOrder
M2 = (monoid R2).Options.MonomialOrder
M3 = (monoid R3).Options.MonomialOrder
l1 = {0, 1, 4}
l2 = {1, 2, 3}
l3 = {1, 4}
inducedMonomialOrder(M1,l1)
inducedMonomialOrder(M1,l2)
inducedMonomialOrder(M1,l3)
inducedMonomialOrder(M2,l1)
inducedMonomialOrder(M2,l2)
inducedMonomialOrder(M2,l3)
inducedMonomialOrder(M3,l1)
inducedMonomialOrder(M3,l2)
inducedMonomialOrder(M3,l3)
inducedMonomialOrder(M3,{0,2,3})
inducedMonomialOrder(M3,{1,3,4})

-- Tests of new minimal presentation (of ring) code:
restart
loadPackage "ParameterSchemes"

TEST ///
A = ZZ/101[x,y]/(y-x^3-x^5-x^7)
B = minimalPresentation A
F = A.minimalPresentationMap
G = A.minimalPresentationMapInv
assert(G*F == map(A,A,gens A))
assert(F*G == map(B,B,gens B))
assert(ideal B == 0)
assert(numgens B == 1)
///

TEST ///
R = ZZ/101[x,y]
I = ideal(y-x^3-x^5-x^7)
J = minimalPresentation I
F = I.cache.minimalPresentationMap
G = I.cache.minimalPresentationMapInv
assert(numgens ring J == 1)
assert(J == 0)
assert(target F === ring I)
assert(source F === ring J)
assert(target G === ring J)
assert(source G === ring I)
///


TEST ///
A = QQ[x,y]/(y-x^3-x^5-x^7)
B = minimalPresentation A
F = A.minimalPresentationMap
G = A.minimalPresentationMapInv
assert(G*F == map(A,A,gens A))
assert(F*G == map(B,B,gens B))
assert(ideal B == 0)
assert(numgens B == 1)
///

TEST ///
A = QQ[x,y]/(2*y-x^3-x^5-x^7)
B = minimalPresentation A
F = A.minimalPresentationMap
G = A.minimalPresentationMapInv
assert(G*F == map(A,A,gens A))
assert(F*G == map(B,B,gens B))
assert(ideal B == 0)
assert(numgens B == 1)
///

TEST ///
R = QQ[x,y]
I = ideal(2*y-x^3-x^5-x^7)
J = minimalPresentation I
F = I.cache.minimalPresentationMap
G = I.cache.minimalPresentationMapInv
assert(numgens ring J == 1)
assert(J == 0)
assert(target F === ring I)
assert(source F === ring J)
assert(target G === ring J)
assert(source G === ring I)
///

TEST ///  -- FAILS
A = ZZ[x,y,z]/(2*y+z-x^3-x^5-x^7, z^2)
B = minimalPresentation A
F = A.minimalPresentationMap
G = A.minimalPresentationMapInv
assert(G*F == map(A,A,gens A))
assert(F*G == map(B,B,gens B))
assert(ideal B == 0)
assert(numgens B == 1)

TEST ///
R = ZZ[x,y,z]
I = ideal(2*y+z-x^3-x^5-x^7, z^2)
J = minimalPresentation I
assert(numgens ring J == 2)
use ring J
assert(J == ideal"x14+2x12+3x10+2x8-4x7y+x6-4x5y-4x3y+4y2")
F = I.cache.minimalPresentationMap
G = I.cache.minimalPresentationMapInv
assert(numgens ring J == 2)
assert(target F === ring I)
assert(source F === ring J)
assert(target G === ring J)
assert(source G === ring I)
///

A = QQ[a,b,c]/(a^2-3*b,a*c-c^4*b)
I = ideal 0_A
J = minimalPresentation I
F = I.cache.minimalPresentationMap
G = I.cache.minimalPresentationMapInv
assert(numgens ring J == 2)
assert(target F === ring I)
assert(source F === ring J)
assert(target G === ring J)
assert(source G === ring I)

A = QQ[a,b,c]/(a^2-3*b^2,a^3-c^4*b)
I = ideal 0_A
J = minimalPresentation I
F = I.cache.minimalPresentationMap
G = I.cache.minimalPresentationMapInv
assert(target F === ring I)
assert(source F === ring J)
assert(target G === ring J)
assert(source G === ring I)

A = ZZ/101[a,b]/(a^2+b^2)
B = A[c,d]/(a*c+b*d-1)
C = B[e,f]/(e^2-b-1)
I = ideal 0_C
J = minimalPresentation I
F = I.cache.minimalPresentationMap
G = I.cache.minimalPresentationMapInv
assert(target F === ring I)
assert(source F === ring J)
assert(target G === ring J)
assert(source G === ring I)

I = ideal presentation (flattenRing C)#0
J = minimalPresentation I
F = I.cache.minimalPresentationMap
G = I.cache.minimalPresentationMapInv
assert(target F === ring I)
assert(source F === ring J)
assert(target G === ring J)
assert(source G === ring I)

-- Examples from parameter schemes
kk = ZZ/101
R = kk[a..f]
I = ideal"ab,bc,cd,de,ea,ac"
time (J,F) = groebnerScheme(I);

time (J,F) = groebnerScheme(I, Minimize=>false);
time J = minimalPresentation J;

kk = ZZ/101
R = kk[a..d]
I = ideal borel monomialIdeal"b2c"
time (J,F) = groebnerScheme(I, Minimize=>false);
time J = minimalPresentation J;
betti J
J = trim J
see J
R = ZZ/101[x,y]/(y-x^3-x^5-x^7)
I = ideal presentation R
minimalPresentation I

