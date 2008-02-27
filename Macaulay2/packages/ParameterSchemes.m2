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
     reduceLinears
     }

isReductor = (f) -> (
     inf := leadTerm f;
     part(1,f) != 0 and
     (set support(inf) * set support(f - inf)) === set{})

findReductor = (L) -> (
     L1 := select(L, isReductor);
     L2 := sort apply(L1, f -> (size f,f));
     if #L2 > 0 then L2#0#1)

reduceIdeal = (L) -> (
     L1 := select(L, isReductor);
     L2 := sort apply(L1, f -> (size f,f));
     if #L2 > 0 then (
	  g := L2#0#1;
	  << "reducing with " << g << endl << endl;
	  L = apply(L, f -> f % g))
     else (
	  print "cannot reduce ideal further";
	  L))

reduceLinears = method(Options => {Limit=>infinity})
reduceLinears Ideal := o -> (I) -> (
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
       ing := leadTerm g;
       << "reducing using " << g << endl << endl;
       L = apply(L, f -> f % g);
       (substitute(leadTerm g, R), substitute(-g+leadTerm g,R))
       );
     (substitute(ideal L,R), M)
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

parameterFamily = method()
parameterFamily(Ideal,List,Symbol) := (M,L,t) -> (
     -- M is a monomial ideal
     -- L is a list of lists of monomials, #L is the
     --  number of generators of M.
     R := ring M;
     kk := coefficientRing R;
     nv := sum apply(L, s -> #s);
     R1 := kk[t_1..t_nv, MonomialSize=>8];
     U := R1 (monoid R);
     --U := tensor(R,R1,DegreeRank=>1);  
     lastv := -1;
     Mlist := flatten entries gens M;
     elems := apply(#Mlist, i -> (
	       m := Mlist_i;
	       substitute(m,U) + sum apply(L#i, p -> (
			 lastv = lastv + 1;
			 R1_lastv * substitute(p,U)))));
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
     time J1 := minimalPresentation J;
     B := ring J1;
     phi := J.cache.minimalPresentationMap; -- map: A --> B
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

kk = ZZ/101
R = kk[a..d]
I = ideal"ab,bc,ca"
(J,F) = groebnerScheme(I, Minimize=>false);
time minimalPresentation J
time (L,G) = reduceLinears J;

P = new MutableList from apply(numgens ring J, x -> random kk)
P#(index t_40) = 0_kk
scan(reverse G, (v,g) -> (
	  if leadCoefficient v != 1 then (
	    c := 1/(leadCoefficient v);
	    v = c * v;
	    g = c * g);
          P#(index v) = substitute(g,matrix {toList P});
	  ))
map(kk,ring J,toList P)
oo J


-- Hi Amelia, here is a good example:
-- Amelia Amelia Amelia Amelia Amelia Amelia Amelia Amelia
kk = ZZ/101
R = kk[a..f]
I = ideal"ab,bc,cd,de,ea,ac"
(J,F) = groebnerScheme(gin I, Minimize=>false);
time minimalPresentation J
time (L,G) = reduceLinears J;

P = new MutableList from apply(numgens ring J, x -> random kk)
P#(index t_40) = 0_kk
scan(reverse G, (v,g) -> (
	  if leadCoefficient v != 1 then (
	    c := 1/leadCoefficient v;
	    v = c * v;
	    g = c * g);
          P#(index v) = substitute(g,matrix {toList P});
	  << "set P#" << index v << " to " << P#(index v) << endl;
	  ))
map(kk,ring J,toList P)
oo J
map(R,ring F,join(gens R,toList P))
M = oo F
positions(flatten entries gens oo, f -> f != 0)
G1 = apply(G, (v,g) -> (leadMonomial v, support g))
for i from 0 to #G1-2 list (
     v := G1_i_0;
     member(v,unique join apply(1..#G1-1, i -> G1_i_1))
     )
A = (ZZ/101){support L, MonomialSize=>8}
L = substitute(L,A)
L = ideal compress gens L;
gbTrace=3
L = ideal gens gb L;
support L_0
support L_1
L1 = ideal apply(flatten entries gens L, f -> f // t_40)
reduceLinears L1
-- Amelia Amelia Amelia Amelia Amelia Amelia Amelia Amelia

Alocal = (coefficientRing ring J){gens ring J,MonomialSize=>8}
Jlocal = substitute(J,Alocal);
J1 = select(flatten entries gens Jlocal, f -> f != 0 and first degree leadTerm f == 1);
J0 = trim ideal select(J1, f -> first degree f == 1)
J1 = apply(J1, f -> f % J0)
J0 = trim(J0 + ideal select(J1, f -> first degree f == 1))
J1 = apply(J1, f -> f % J0)
J0 = trim(J0 + ideal select(J1, f -> first degree f == 1))
numgens J0
J1 = apply(J1, f -> f % J0)
J0 = trim(J0 + ideal select(J1, f -> first degree f == 1))
numgens J0
J1 = apply(J1, f -> f % J0)


R = ZZ/101[a..e,MonomialOrder=>Lex]
R = ZZ/101[a..f]
I = ideal"ab,bc,cd,de,ea,ac"
R = ZZ/101[a..g]
I = ideal"ab,bc,cd,de,ea,ac"

R = ZZ/101[a..e,MonomialOrder=>Lex]
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

R = ZZ/101[a..e]
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

R = ZZ/101[a..f]
I = ideal"ab,bc,cd,ade"
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
