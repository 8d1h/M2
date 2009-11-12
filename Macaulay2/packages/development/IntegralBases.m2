needsPackage "UPolynomials"
needsPackage "FractionalIdeals"
needsPackage "Puiseux"

newPackage(
        "IntegralBases",
        Version => "0.1", 
        Date => "7 Aug 2009",
        Authors => {{Name => "Mike Stillman", 
                  Email => "mike@math.cornell.edu", 
                  HomePage => "http://www.math.cornell.edu/~mike"}},
        Headline => "integral bases for plane curves, a la van Hoeij, and Trager",
        DebuggingMode => true
        )

needsPackage "UPolynomials"
needsPackage "FractionalIdeals"
needsPackage "Puiseux"
needsPackage "MatrixNormalForms"

export {
     integralBasis,
     vanHoeij,
     Trager,
     principalPart,
     makeEquations,
     findPuiseuxSeries,
     puiseuxTruncations,
     findBranches,
     traceRadical,
     trager
     }

principalPart = (P, f, truncdegree) -> (
     -- returns the list of coefficients in t of f(x(t),y(t))/fdenom(x(t),y(t)) 
     -- up to, but not including deg_t x(t).
     R := ring f;
     (xt,yt) := P;
     S := ring xt;
     S1 := S/S_0^truncdegree;
     xt = sub(xt,S1);
     yt = sub(yt,S1);
     f' := sub(f, {R_0 => xt, R_1 => yt});
     lift(f',S))

makeEquations = (Ps, base, denomdegree) -> (
     -- First make the matrices to split the principal part into coefficients
     R := ring base_0;
     KK := coefficientRing R;
     Ms := apply(Ps, P -> (
	       d := first degree P_0;
	       d = d * denomdegree;
	       t := (ring P_0)_0;
	       M := matrix {apply(toList(0..d-1), i -> t^i)};
	       (d, M) -- d is the truncation degree, M is t^0..t^(d-1) as a matrix
	       ));
     -- Now loop through each element of base, and create the matrix
     -- whose rows are the coefficients of the principal part of base_i
     -- at each of the parametrizations P.
     transpose matrix apply(base, f -> flatten apply(#Ps, i -> (
		    ft := principalPart(Ps#i,f,Ms#i#0);
		    cfs := (coefficients(ft, Monomials => Ms#i#1))_1;
		    cfs = lift(cfs,KK);
		    flatten entries cfs)))
     )

findPuiseuxSeries = method()
findPuiseuxSeries(RingElement) := (F) -> (
     R := ring F;
     Px := (coefficientRing R)[(gens R)_0];
     ds := disc(F, R_1);
     ds = apply(ds, d -> sub(d#0,Px));
     as := apply(ds, adjoinRoot);
     Rs := apply(as, a -> if ring a === coefficientRing R then R else (ring a)[gens R]);
     Fs := apply(#ds, i -> (S := Rs#i; sub(F, {R_0 => S_0 + as#i, R_1 => S_1})));
     << "warning: still need to set the truncation degrees correctly" << endl;
     hashTable apply(#Fs, i -> (ds#i,as#i) => (
	  P := puiseux(Fs#i,10);
	  join apply(P, (xt,yt) -> (xt+sub(as#i,ring xt),yt))
	  ))
     )

puiseuxTruncations = method()
puiseuxTruncations RingElement := (F) -> (
     -- Compute the Puiseux tree
     -- and the degrees
     -- and then make the Puiseux series to that degree
     -- returns a list of {(x(t),y(t)), Ni, Inti}
     PT := puiseuxTree F;
     L := findVanHoeijWeights PT;
     B := branches F; -- TODO: compute this from PT!! -- but: these are in the same order as L
       -- and should have the same length as L
     if #L =!= #B then error "my logic is somehow wrong";
     truncationDegrees := apply(L, f -> floor(f#"Info"#"Multiplicity" * f.cache#"Ni")+1);
     apply(#B, i -> (
	       b := B#i;
	       f := L#i;
	       {f.cache#"Ni", f.cache#"Int", truncationDegrees#i, series extend(b, truncationDegrees#i)}
	       ))
     )

findBranches = method()
findBranches(RingElement) := (F) -> (
     R := ring F;
     Px := (coefficientRing R)[(gens R)_0];
     ds := disc(F, R_1);
     ds = apply(ds, d -> sub(d#0,Px));
     as := apply(ds, adjoinRoot);
     Rs := apply(as, a -> if ring a === coefficientRing R then R else (ring a)[gens R]);
     Fs := apply(#ds, i -> (S := Rs#i; sub(F, {R_0 => S_0 + as#i, R_1 => S_1})));
     hashTable apply(#Fs, i -> (ds#i,as#i) => (
	  P := branches(Fs#i);
	  << netList P << endl;
	  apply(P, p -> (series p#0, p#1))
	  ))
     )

-- van Hoeij algorithm
-- step 1: computing the factors of the discriminant, roots and Puiseux series
-- step 2: Creation of (and solving) the equations in van Hoiej
-- step 3: van Hoeij

-- Trager algorithm
-- step 1: computing the trace and mult map matrices
-- step 2: Hermite normal form
-- step 3: p-trace radical

needsPackage "TraceForm"

selectdisc = (L) -> L#0#0

trager1 = (vs, omega, Ms, dx) -> (
     n := #vs;
     KA := ring omega;
     A := KA.baseRings#-1;
     M := dx*id_(A^n) | lift(omega,A);
     H := hermiteNF(M, ChangeMatrix=>false);
     H = submatrix(H, 0..n-1);
     H = transpose sub(H,KA);
     -- columns of dx * H^-1 are the A-generators of rad(dx)
     -- 1/dx * H is the change of basis matrix from vs to gens or rad(dx).
     -- Now compute Hom(rad(dx),rad(dx)).
     Hinv := dx * H^-1; -- columns are the A1-basis of the radical of dx.
     -- First, compute the mult maps for each A1-gen of rad(dx).
     Msnewbasis := apply(entries transpose lift(Hinv,A), rs -> (
	  sum apply(#rs, i -> rs#i * Ms#i)
	  ));
     MM := matrix{apply(Msnewbasis, m -> transpose(1/dx * H * m))};
     MM = lift(MM,A);
     L := hermiteNF(MM, ChangeMatrix => false);
     L = transpose submatrix(L, 0..n-1);
     (sub(L,KA))^-1
     --(H, Hinv, Msnewbasis, MM, L)
     )

trager = method(Options => {Verbosity => 0})
trager Ring := opts -> (R) -> (
     -- R should be of the form: K[ys]/I, where
     -- KK = frac(kk[x]).
     (vs, omega, Ms) := traceFormAll R;
     n := #vs;
     KA := coefficientRing R;
     A := KA.baseRings#-1;
     D := lift(det omega, A);
     Ds := (factor D)//toList/toList/(x -> if x#1 >= 2 then {x#0,floor(x#1/2)} else null);
     Ds = select(Ds, x -> x =!= null);
     S := id_(KA^n);
     while (
	 dx := selectdisc(Ds);
	 L = trager1(vs, omega, Ms, dx);
	 L != 1)
       do (
	 omega = (transpose L) * omega * L;
	 -- change Ds
	 S = S * L;
	 << "at end of loop, L = " << L << " and S = " << S << endl;
	 );
     matrix{vs} * S
     )

beginDocumentation()

doc ///
Key
  IntegralBases
Headline
  computing integral bases of plane curves
Description
  Text
  Example
Caveat
SeeAlso
///


TEST ///
-- test code and assertions here
-- may have as many TEST sections as needed
///

end
doc ///
Key
Headline
Inputs
Outputs
Consequences
Description
  Text
  Example
Caveat
SeeAlso
///

restart
loadPackage "IntegralBases"

-- ZZZ
kk = ZZ/32003
kk = QQ
P = kk[x]
R = kk[x,y]
F = y^5+2*x*y^2+2*x*y^3+x^2*y-4*x^3*y+2*x^5
ds = disc(F,y)
dx = disc(F,x)
ds = apply(ds, d -> sub(d#0,P))
as = apply(ds, adjoinRoot)
Rs = apply(as, a -> if ring a === coefficientRing R then R else (ring a)[gens R])
Fs = apply(#ds, i -> (S := Rs#i; sub(F, {R_0 => S_0 + as#i, R_1 => S_1})))
netList puiseux(Fs#0,10)
netList (P = puiseux(Fs#1,10)) -- seems nasty, this one does.
P/(x -> ring x_1)
puiseux(Fs#2,10) -- doesn't work

puiseuxTruncations F
Ps = oo/last
syz matrix makeEquations(Ps, {1_R,y,y^2,y^3}, 1)
syz matrix makeEquations(Ps, {x*1_R,x*y,x*y^2,y^3,y^4}, 2)
syz matrix makeEquations(Ps, {1_R,y,y^2,y^3}, 1)

-- how does Fractional Ideals do on this one?
S = kk[y,x,MonomialOrder=>{1,1}]
A = S/(sub(F,S))
integralClosureHypersurface A

--------------------
-- A good example --
--------------------
restart
needsPackage "IntegralBases"
P = QQ[x]
R = QQ[x,y]
F = y^4-y^2+x^3+x^4
ds = disc(F,y)
dx = disc(F,x)
ds = apply(ds, d -> sub(d#0,P))
as = apply(ds, adjoinRoot)
Rs = apply(as, a -> if ring a === coefficientRing R then R else (ring a)[gens R])
Fs = apply(#ds, i -> (S := Rs#i; sub(F, {R_0 => S_0 + as#i, R_1 => S_1})))
netList (P1 = puiseux(Fs#0,10))
netList (P2 = puiseux(Fs#1,10)) -- seems nasty, this one does.
P2/(x -> ring x_1)
P2a = apply(P2, (xt,yt) -> (xt+sub(as#1,ring xt),yt))
testPuiseux(P2a_0,F,15)
(xt,yt) = P2a_0
yt^3-yt -- something seems wrong here...


-- 



S = QQ[y,x,MonomialOrder=>{1,1}]
A = S/(sub(F,S))
integralClosureHypersurface A

-- Example
restart
needsPackage "IntegralBases"
R = QQ[x,y]
F = y^4-y^2+x^3+x^4
puiseuxTruncations F
Ps = oo/last
syz matrix makeEquations(Ps, {1_R,y,y^2,y^3}, 1)

Ps = findBranches F
series (values Ps)_0_0_0
series (values Ps)_1_0_0

Ps = findPuiseuxSeries F
keys Ps
syz matrix makeEquations(Ps#((keys Ps)_0), {1_R,y,y^2,y^3}, 1)
syz matrix makeEquations(Ps#((keys Ps)_1), {1_R,y,y^2,y^3}, 1)
syz matrix makeEquations(Ps#((keys Ps)_2), {1_R,y,y^2,y^3}, 1)


-- switch x and y
restart
needsPackage "IntegralBases"
R = QQ[x,y]
F = x^4-x^2+y^3+y^4
Ps = findPuiseuxSeries F
syz matrix makeEquations(Ps#((keys Ps)_0), {1_R,y,y^2,y^3}, 1)
syz matrix makeEquations(Ps#((keys Ps)_1), {1_R,y,y^2,y^3}, 1)
syz matrix makeEquations(Ps#((keys Ps)_2), {1_R,y,y^2,y^3}, 1)

S = QQ[y,x,MonomialOrder=>{1,1}]
A = S/(sub(F,S))
integralClosureHypersurface A

-- Example for M2 meeting, Aug 2009, MSRI
restart
loadPackage "IntegralBases"
kk = QQ
R = kk[x,y]
F = y^5+2*x*y^2+2*x*y^3+x^2*y-4*x^3*y+2*x^5
disc(F,y)

S = QQ[y,x,MonomialOrder=>{1,1}]
A = S/(sub(F,S))
integralClosureHypersurface A -- generated over A by one fraction with denom. x^2(x^3+1).

kk = QQ
R = kk[x,y,z]
F = z*(x^2+y^2)-x^2+y^2
F = (z+x+y)*(x^2+y^2)-x^2+y^2
F = (z+x+y)*(x^2+y^2)^2-x^2+y^2
F = (z+x+y)*(x^3+y^3)^2-x^3+y^3
A = R/F
integralClosure A
icFractions A

R = kk[y,x,z,MonomialOrder=>{1,2}]
F = sub(F,R)
F = sub(F, {y => x+y, z => z-x})
A = R/F
integralClosureHypersurface A
disc(F,y)

-- Trager algorithm
-- 
restart
debug loadPackage "IntegralBases"
loadPackage "MatrixNormalForms"
loadPackage "TraceForm"

A1 = QQ[x]
B1 = frac A1
R = QQ[x,y]
F = y^4 - y^2 + (x^3 + x^4)

D = sub(discriminant(F,y), A1)
Ds = select((factor D)//toList/toList, x -> x#1 > 1)

C1 = B1[y]
D1 = C1/sub(F,C1)
(vs, omega, Ms) = traceFormAll D1
trager D1
P = trager1(vs, omega, Ms, Ds#0#0)
(transpose P) * omega * P
trager1(vs, omega, Ms, dx)
-- Compute the radical
n = #vs
dx = sub(Ds#0#0,A1)
M = dx*id_(A1^n) | lift(omega,A1)
H = hermiteNF(M, ChangeMatrix=>false)
H = submatrix(H, 0..n-1)
H = transpose sub(H,B1)
-- change of basis matrix from vs to radical generators:
1/dx * H
Hinv = dx * H^-1 -- columns are the A1-basis of the radical of dx.

-- Now compute Hom(rad(dx),rad(dx)).
-- First, compute the mult maps for each A1-gen of rad(dx).
Msnewbasis = apply(entries transpose lift(Hinv,A1), rs -> (
	  sum apply(#rs, i -> rs#i * Ms#i)
	  ))
M = matrix{apply(Msnewbasis, m -> transpose(1/dx * H * lift(m,A1)))}
-- Second, concat these together, do hermite.
M = matrix {Msnewbasis}
M = lift(M, A1)
M = H * M

M = lift(M,A1)
L = hermiteNF(M, ChangeMatrix => false)
L = submatrix(L, 0..n-1)
-- Third, this gives the changes of basis vs to the new basis.
--   Use this to change omega for the next step.
L = sub(transpose L,B1)
L^-1 -- columns are the new basis elements
(transpose L) * omega * L
L^-1
matrix {vs} * oo


transpose H
H1 = sub(transpose H, ring Ms_0)
use ring Ms_0
use coefficientRing ring Ms_0
x*Ms_0
H * (x*Ms_0)
H * (x*Ms_1)
H * (x*Ms_2)
H * (Ms_3-Ms_1)
H * matrix{{x*Ms_0, x*Ms_1, x*Ms_2, Ms_3-Ms_1}}
sub(oo,A1)
hermiteNF(oo, ChangeMatrix=>false)
submatrix(oo,{0..3})
sub(oo,B1)
transpose(oo^-1)
