--		Copyright 1996-2002,2004 by Daniel R. Grayson

newPackage(
	"SchurRings",
    	Version => "1.0", 
    	Date => "March 11, 2005",
    	Author => "Michael Stillman and Hal Schenck",
	Email => "mike@math.cornell.edu",
    	HomePage => "http://www.math.cornell.edu/~mike/",
    	Headline => "representation rings of general linear groups and of symmetric groups",
    	DebuggingMode => true
    	)

export (schurRing, SchurRing, symmRing, plethysmMap, jacobiTrudiE, plethysm, cauchy, bott)

debug Macaulay2Core

SchurRing = new Type of EngineRing
SchurRing.synonym = "Schur ring"
expression SchurRing := S -> new FunctionApplication from { schurRing, (S.Symbol, numgens monoid S) }
toExternalString SchurRing := R -> toString expression R
toString SchurRing := R -> (
     if ReverseDictionary#?R then toString ReverseDictionary#R
     else toString expression R)
net SchurRing := R -> (
     if ReverseDictionary#?R then toString ReverseDictionary#R
     else net expression R)

coefficientRing SchurRing := Ring => R -> last R.baseRings

newSchur := (R,M,p) -> (
     if not (M.?Engine and M.Engine) 
     then error "expected ordered monoid handled by the engine";
     if not (R.?Engine and R.Engine) 
     then error "expected coefficient ring handled by the engine";
     RM := R M;
     SR := new SchurRing from rawSchurRing(RM.RawRing);
     SR.Symbol = p;
     SR.baseRings = append(R.baseRings,R);
     ONE := SR#1;
     if degreeLength M != 0 then (
	  -- there must be something smarter to do, but if we
	  -- do not do this, then we get into an infinite loop
	  -- because each monoid ring ZZ[a,b,c] needs its degrees ring
	  -- ZZ[t], which in turn needs to make its degrees ring 
	  -- ZZ[], which in turn needs one.
	  SR.degreesRing = degreesRing degreeLength M;
	  )
     else (
	  SR.degreesRing = ZZ;
	  );
     if R.?char then SR.char = R.char;
     SR.monoid = M;
     SR ? SR := (f,g) -> (
	  if f == g then symbol ==
	  else leadMonomial f ? leadMonomial g
	  );
     R * M := (r,m) -> new SR from rawTerm(SR.RawRing,raw r,m.RawMonomial);
     M * R := (m,r) -> new SR from rawTerm(SR.RawRing,raw r,m.RawMonomial);
     SR * M := (p,m) -> p * (R#1 * m);
     M * SR := (m,p) -> (R#1 * m) * p;
     R + M := (r,m) -> r * M#1 + R#1 * m;
     M + R := (m,r) -> r * M#1 + R#1 * m;
     SR + M := (p,m) -> p + R#1 * m;
     M + SR := (m,p) -> p + R#1 * m;
     R - M := (r,m) -> r * M#1 - R#1 * m;
     M - R := (m,r) -> R#1 * m - r * M#1;
     SR - M := (p,m) -> p - R#1 * m;
     M - SR := (m,p) -> R#1 * m - p;
     toExternalString SR := 
     expression SR := f -> (
	  (coeffs,monoms) -> sum(
	       coeffs,monoms,
	       (a,m) -> new Subscript from {p, (
		    t := new MutableHashTable;
		    apply(rawSparseListFormMonomial m, (x,e) -> scan(0 .. x, i -> if t#?i then t#i = t#i + e else t#i = e)); 
		    toSequence values t
		    )})
	  ) rawPairs(raw R, raw f);
     SR.generators = apply(M.generators, m -> SR#(toString m) = SR#0 + m);
     scan(keys R,k -> if class k === String then SR#k = promote(R#k,SR));
     SR.use = x -> (
	  M + M := (m,n) -> R#1 * m + R#1 * n;
	  M - M := (m,n) -> R#1 * m - R#1 * n;
	  - M := (m,n) -> - R#1 * n;
	  scan(SR.baseRings, A -> (
	       if A =!= R then (
		    A * M := (i,m) -> (i * R#1) * m;
		    M * A := (m,i) -> m * (i * R#1);
		    );
	       A + M := (i,m) -> i * R#1 + m;
	       M + A := (m,i) -> m + i * R#1;
	       A - M := (i,m) -> i * R#1 - m;
	       M - A := (m,i) -> m - i * R#1;
	       M / A := (m,r) -> (m * ONE) / (r * ONE);
	       M % A := (m,r) -> (m * ONE) % (r * ONE);
	       ));
	  SR);
     -- leadMonomial R := f -> new M from rawLeadMonomial(n, f.RawRingElement); -- fix this?
     SR
     )

ck := i -> if i < 0 then error "expected decreasing row lengths" else i

schurRing = method ()
schurRing(Symbol,ZZ) := SchurRing => (p,n) -> (
     R := ZZ;
     x := symbol x;
     prune := v -> drop(v, - # select(v,i -> i === 0));
     M := monoid[x_1 .. x_n];
     vec := apply(n, i -> apply(n, j -> if j<=i then 1 else 0));
     -- toString M := net M := x -> first lines toString x;
     S := newSchur(R,M,p);
     dim S := s -> rawSchurDimension raw s;
     Mgens := M.generators;
     methodTable#p = (p,a) -> (
	  m := (
	       if # a === 0 then 1_M
	       else product(# a, i -> (Mgens#i) ^ (
			 ck if i+1 < # a 
			 then a#i - a#(i+1)
			 else a#i)));
	  new S from rawTerm(S.RawRing, raw 1, m.RawMonomial));
     S)

beginDocumentation()

document {
     Key => "Schur rings",
     Headline => "monomials representing irreducible representations of GL(n)",
     "Given a positive integer ", TT "n", ", 
     we may define a polynomial ring over ", TO "ZZ", " in ", TT "n", " variables, whose
     monomials correspond to the irreducible representations of GL(n), and where 
     multiplication is given by the decomposition of the tensor product of representations",
     PARA,
     "We create such a ring in Macaulay 2 using the ", TO "Schur", " function:",
     EXAMPLE "R = Schur 4;",
     "A monomial represents the irreducible representation with a given highest weight. 
     The standard 4 dimensional representation is",
     EXAMPLE "V = R_{1}",
     "We may see the dimension of the corresponding irreducible representation using ", TO "dim",
     ":",
     EXAMPLE "dim V",
     "The third symmetric power of V is obtained by",
     EXAMPLE "W = R_{3}",
     EXAMPLE "dim W",
     "and the third exterior power of V can be obtained using",
     EXAMPLE "U = R_{1,1,1}",
     EXAMPLE "dim U",
     "Multiplication of elements corresponds to tensor product of representations.  The 
     value is computed using a variant of the Littlewood-Richardson rule.",
     EXAMPLE "V * V",
     EXAMPLE "V^3",
     "One cannot make quotients of this ring, and Groebner bases and related computations
     do not work, but I'm not sure what they would mean..."
     }

document {
     Key => schurRing,
     Headline => "make a Schur ring",
     TT "schurRing(x,n)", " -- creates a Schur ring of degree n with variables based on the symbol x",
     PARA,
     "This is the representation ring for the general linear group of n by n matrices.",
     PARA,
     SeeAlso => {"SchurRing"}}

document {
     Key => SchurRing,
     Headline => "the class of all Schur rings",
     "A Schur ring is the representation ring for the general linear group of 
     n by n matrices, and one can be constructed with ", TO "Schur", ".",
     EXAMPLE "R = Schur 4",
     "The element corresponding to the Young diagram ", TT "{3,2,1}", " is
     obtained as follows.",
     EXAMPLE "R_{3,2,1}",
     "The dimension of the underlying virtual representation can be obtained
     with ", TO "dim", ".",
     EXAMPLE "dim R_{3,2,1}",
     "Multiplication in the ring comes from tensor product of representations.",
     EXAMPLE "R_{3,2,1} * R_{1,1}",
     SeeAlso => {schurRing}}

-- document {
--      Key => (symbol _, SchurRing, List),
--      Headline => "make an element of a Schur ring",
--      TT "S_v", " -- produce the element of the Schur ring ", TT "S", " corresponding
--      to the Young diagram whose rows have lengths as in the list ", TT "v", ".",
--      PARA,
--      "The row lengths should be in decreasing order.",
--      SeeAlso => "SchurRing"}

-----------------------------------------------------------------------------
-- the rest of this file used to be schur.m2
-----------------------------------------------------------------------------

-- BUG in M2: R_0 .. R_n does not always give elements in the ring R!!
-- workaround:
varlist = (i,j,R) -> apply(i..j, p -> R_p)

symmRings := new MutableHashTable;
symmRing = (n) -> (
     if not symmRings#?n then (
     	  e := global e;
     	  h := global h;
     	  p := global p;
     	  R := QQ[e_1..e_n,p_1..p_n,
	       Degrees => toList(1..n,1..n)];
     	  S := Schur n;
     	  R.Schur = S;
     	  R.dim = n;
     	  R.mapToE = map(R,R,flatten splice {varlist(0,n-1,R),apply(n, i -> PtoE(i+1,R))});
     	  R.mapToP = map(R,R,flatten splice {apply(n, i -> EtoP(i+1,R)), varlist(n,2*n-1,R)});
     	  R.plethysmMaps = new MutableHashTable;
	  symmRings#n = R;
	  );
     symmRings#n)

plethysmMap = (d,R) -> (
     -- d is an integer
     -- R is symmRing n
     -- returns the map p_d : R --> R
     --    which sends p_i to p_(i*d).
     n := R.dim;
     if not R.plethysmMaps#?d then (
	 fs := splice {varlist(0,n-1,R),apply(1..n, j -> PtoE(d*j,R))};
         R.plethysmMaps#d = map(R,R,fs);
	 );
     R.plethysmMaps#d
     )

jacobiTrudiE = (lambda, R) -> (
     -- lambda is a partition of d
     -- R is a "symmRing n", some n.
     -- returns: s[lambda] as an element of R, in e variables
     lambda' := conjugate lambda;
     n := #lambda';
     det map(R^n, n, (i,j) -> (
	       p := lambda'#i-i+j;
	       if p < 0 or p > R.dim then 0_R
	       else if p == 0 then 1_R else R_(p-1))) -- R_(p-1) IS e_p
     )

parts = (d, n) -> (
     -- d is an integer >= 0
     -- n is an integer >= 1
     -- returns a list of all of the partitions of d
     --    having <= n parts.
     x := partitions(d);
     select(x, xi -> #xi <= n))     

etos = (d,R) -> (
     -- d is an integer >= 0
     -- R is a 'symmRing n'
     if not R.?toSchur then R.toSchur = new MutableHashTable;
     if not R.toSchur#?d then (
     	  n := R.dim;
     	  P := parts(d,n);
     	  S := matrix {apply(P, x -> jacobiTrudiE(x,R)) };
	  v := ideal varlist(n,2*n-1,R);
     	  E := transpose matrix basis(d,coker gens v);
     	  B := transpose contract(E,S);
	  R.toSchur#d = (E,B^(-1), P);
	  );
     R.toSchur#d
     )     

toS = (f) -> (
     -- f is a homogeneous polynomial in 'symmRing n', of degree d
     d := first degree f;
     R := ring f;
     (E,C,P) := etos(d,R);
     fInS := transpose contract(E,matrix{{f}}) * C;
     fInS = flatten entries fInS;
     fInS = apply(fInS, x -> if x == 0 then 0 else leadCoefficient(x));
     S := R.Schur;
     --sum apply(#P, i -> lift(fInS_i,ZZ) * S_(P_i))
     v := select(apply(#P, i -> if fInS_i == 0 then null else  (P_i, fInS_i)),
	  x -> x =!= null);
     --result := sum apply(v, w -> lift(w#1,ZZ) * S_(w#0));
     --result
     apply(v, v1 -> (v1#0, lift(v1#1,ZZ)))
     )

toE = (f) -> (ring f).mapToE f
toP = (f) -> (ring f).mapToP f

PtoE = (m,R) -> (
     -- R is a symmring n
     -- R should have a field named PtoETable, which is
     --  a mutable hash table with i => p_i values for i = 1,...,??
     -- this computes the values up through m.
     n := R.dim;
     if not R.?PtoETable then
     	  R.PtoETable = new MutableHashTable;
     P := R.PtoETable;
     s := #(keys P);
     for i from s+1 to m do (
	  f := if i > n then 0_R else -i*R_(i-1); -- R_(i-1) IS e_i
	  for r from max(1,i-n) to i-1 do 
	       f = f + (-1)^(r-1) * R_(i-r-1) * P#r; -- R_(i-r-1) IS e_(i-r)
	  P#i = if i%2 == 0 then f else -f;
	  );
     P#m
     )

EtoP = (m,R) -> (
     -- R is a symmring n
     -- R should have a field named EtoPTable, which is
     --  a mutable hash table with i => e_i for i = 1,...,??
     -- this computes the values up through m.
     n := R.dim;
     if not R.?EtoPTable then (
     	  R.EtoPTable = new MutableHashTable;
	  R.EtoPTable#0 = 1_R;
	  );
     E := R.EtoPTable;
     s := #(keys E); -- keys includes 0,1,2,...
     if m > n then return 0_R;
     for i from s to m do (
	  f := 0_R;
	  for r from 1 to i do 
	       f = f + (-1)^(r-1) * E#(i-r) * R_(n-1+r); -- R_(n-1+r) IS p_r
	  E#i = (1/i) * f;
	  );
     E#m
     )

plethysm = method()
plethysm(RingElement,RingElement) := (f,g) -> (
     -- f is a polynomial in symmRing N
     -- g is a polynomial in symmRing n
     -- result is in symmRing n, in the e basis.
     R := ring g;
     Rf := ring f;
     f = toP f;
     g = toP g;
     n := R.dim;
     N := Rf.dim;
     phi := map(R,Rf,flatten splice {N:0_R,apply(1..N, j -> (plethysmMap(j,R)) g)});
     phi f)

plethysm(List,RingElement) := (lambda,g) -> (
     d := sum lambda;
     Rf := symmRing d;
     f := jacobiTrudiE(lambda,Rf);
     plethysm(f,g))

-- cauchy = (i,f,g) -> (
--      -- f and g are elements of symmRing's (possibly different)
--      -- compute the i th exterior power of the representation f ** g
--      P := partitions i;
--      n := (ring f).dim;
--      n' := (ring g).dim;
--      result := apply(P, lambda -> (
-- 	       if #lambda > n or lambda#0 > n' then null
-- 	       else (
-- 		    plethysm(lambda, f),
-- 	     	    plethysm(conjugate lambda, g))
-- 		    ));
--      select(result, x -> x =!= null)
--      )

cauchy = (i,f,g) -> (
     -- f and g are elements of symmRing's (possibly different)
     -- compute the i th exterior power of the representation f ** g
     P := partitions i;
     n := (ring f).dim;
     n' := (ring g).dim;
     result := apply(P, lambda -> (
	       --if #lambda > n or lambda#0 > n' then null
	       --else 
	       (
		   a := plethysm(lambda,f);
		   if a == 0 then null
		   else (
			b := plethysm(conjugate lambda, g);
			if b == 0 then null else (a,b)
		    ))));
     select(result, x -> x =!= null)
     )

bott = (QRreps) -> (
     -- returns a list of either: null, or (l(w), w.((Qrep,Rrep)+rho) - rho)
     s := QRreps; -- join(Qrep,Rrep);
     rho := reverse toList(0..#s-1);
     s = s + rho;
     len := 0;
     s = new MutableList from s;
     n := #s;
     for i from 0 to n-2 do
     	  for j from 0 to n-i-2 do (
	       if s#j === s#(j+1) then return null;
	       if s#j < s#(j+1) then (
		    tmp := s#(j+1);
		    s#(j+1) = s#j;
		    s#j = tmp;
		    len = len+1;
		    )
	       );
     (len, toList s - rho)
     )

compositions = (r,n) -> (
     -- return a list of all of the n-compositions of r.
     if n === 1 then {{r}}
     else if r === 0 then {toList(n:0)}
     else (
	  flatten for i from 0 to r list (
	       w := compositions(r-i,n-1);
	       apply(w, w1 -> prepend(i,w1)))))


pairProduct = L -> (
     -- L is a list of lists of (f,g), f,g both in symm rings.
     -- result: a list of pairs (f,g).
     if #L === 1 then first L
     else (
	  L' := drop(L,1);
	  P' := pairProduct L';
	  flatten apply(L#0, fg -> (
	       (f,g) := fg;
	       apply(P', pq -> (
		    (p,q) := pq;
		    (f*p, g*q)))))
     ))
wedge = method()		    
wedge(List,List) := (C,L) -> (
     -- MES MES: we are working on this function now.  It is fucked up.
     -- the plethysmMap seems messed up.  We really need to make a routine
     -- plethysm(partition,representation)
     -- MES MES
     -- C is a composition of 0..n-1, n == #L
     -- form the product of the exterior powers of the corresponding representations.
     result := {}; -- each entry will be of the form (f,g)
     C0 := positions(C, x -> x =!= 0);
     wedgeL := flatten apply(C0, i -> (
	       apply(L#i, fg -> cauchy(C#i,fg#0,fg#1))));
     pairProduct wedgeL     
     )

wedge(ZZ,List,List) := (r,L,ranks) -> (
     -- r is an integer >= 1
     -- L is a list of pairs (f,g), f,g are in (possibly different) symm rings.
     -- returns wedge(r)(L), as a sum of irreducible representations of GL(m) x GL(n)
     n := #L;
     p := compositions(r,n);
     p = select(p, x -> all(ranks-x, i -> i>=0));
     join apply(p, x -> wedge(x,L))
     )
preBott = (i,L,ranks) -> (
     R1 := ring L#0#0#0;
     R2 := ring L#0#0#1;
     dimQ := R1.dim; -- for general bundles we will need to know the ranks concerned
     dimR := R2.dim;
     x := flatten wedge(i,L,ranks);
     x = apply(x, x0 -> (toS x0#0, toS x0#1));
     B := new MutableHashTable;
     scan(x, uv -> (
	       (u,v) := uv;
	       scan(u, u0 -> (
			 scan(v, v0 -> (
			       pQ := u0#0;
			       pR := v0#0;
			       if #pQ < dimQ then
			         pQ = join(pQ,toList((dimQ-#pQ):0));
			       if #pR < dimR then
			         pR = join(pR,toList((dimR-#pR):0));
			       b := join(pQ,pR);
			       c := u0#1 * v0#1;
			       if B#?b then B#b = B#b + c
			       else B#b = c))))));
     B)

doBott = (nwedges,B) -> (
     -- B is the output of preBott
     kB := keys B;
     S := Schur (#(first kB));
     apply(keys B, x -> (
	       b := bott x;
	       if b === null then null
	       else (
		    glb = b#1;
		    d := B#x * dim S_(b#1);
		    (b#0, nwedges - b#0, b#1, B#x, d)))))


weyman = (i,L,ranks) -> (
     B := preBott(i,L,ranks);
     doBott(i,B))

------- old stuff
---- cauchy = (i,L,Rs) -> (
----      -- Rs is a list (R1,R2) of symmRing's, R1 <--> V, R2 <--> W
----      -- L is a list of pairs (f,g), where
----      --   f in R1, g in R2.
----      -- compute the i th exterior power of L.
----      -- 
---- 	       
----      )
---- 
---- jacobiTrudi = (lambda, R) -> (
----      -- lambda is a partition of d
----      -- R is an "hring n", some n.
----      -- returns: s[lambda] as an element of R.
----      n := #lambda;
----      det map(R^n, n, (i,j) -> (
---- 	       p := lambda#i-i+j;
---- 	       if p < 0 then 0_R
---- 	       else if p == 0 then 1_R else h_p))
----      )
---- htos = (d,R) -> (
----      -- d is an integer >= 0
----      -- R is an 'hring n'
----      if not R.?toSchur then R.toSchur = new MutableHashTable;
----      if not R.toSchur#?d then (
----      	  n := numgens R;
----      	  P := parts(d,n);
----      	  S := matrix {apply(P, x -> jacobiTrudi(x,R)) };
----      	  H := transpose basis(d,R);
----      	  B := transpose contract(H,S);
---- 	  R.toSchur#d = (H,B^(-1), P);
---- 	  );
----      R.toSchur#d
----      )     
---- 
---- tos = (f) -> (
----      -- f is a homogeneous polynomial in 'hring n', of degree d
----      d := first degree f;
----      R := ring f;
----      (H,C,P) := htos(d,R);
----      fInS := transpose contract(H,matrix{{f}}) * C;
----      fInS = flatten entries fInS;
----      fInS = apply(fInS, x -> if x == 0 then 0 else leadCoefficient(x));
----      S := R.Schur;
----      sum apply(#P, i -> fInS_i * S_(P_i))
----      )
     
end

-----------------------------------------------------------------------------
-- some tests that can be incorporated into the documentation later
-----------------------------------------------------------------------------

restart
load "schur.m2"
R = symmRing 4
describe R
f = jacobiTrudiE({4,1},R)
toS f
f = jacobiTrudiE({2,1},R)
toE toP f

toP jacobiTrudiE({2},R)
toP jacobiTrudiE({1,1,1,1},R)
toP jacobiTrudiE({4,4,4,4},R)
toP e_4

R = symmRing 5
PtoE(1,R)
PtoE(2,R)
PtoE(3,R)
PtoE(4,R)
PtoE(5,R)

EtoP(1,R)
EtoP(2,R)
EtoP(3,R)
EtoP(4,R)
EtoP(5,R)

apply(1..10, i -> toP(PtoE(i,R)))
apply(1..5, i -> toE(EtoP(i,R)))

toE EtoP(1,R)
toE EtoP(2,R)
toE EtoP(3,R)
toE EtoP(4,R)

toP PtoE(1,R)
toP PtoE(2,R)
toP PtoE(3,R)
toS toE toP PtoE(4,R)
toS PtoE(4,R)
PtoE(4,R)

toS (jacobiTrudiE({2,1},R))^2
R.Schur_{2,1}^2

f = toS plethysm(jacobiTrudiE({2},R), jacobiTrudiE({2},R)) -- assert(f == {({4}, 1), ({2, 2}, 1)})
f = toS plethysm(jacobiTrudiE({3},R), jacobiTrudiE({2},R)) -- assert(f == 
f = toS plethysm(jacobiTrudiE({2,1},R), jacobiTrudiE({2},R)) -- assert(f == 
f = toS plethysm(jacobiTrudiE({1,1,1},R), jacobiTrudiE({2},R)) -- assert(f == 
toS (jacobiTrudiE({1},R))^3
ps2 = plethysm(e_2, e_1^2 - e_2)
toP ps2
toS ps2
toP e_2
toP (e_1^2-e_2)

PtoE(20,R)
R = symmRing 6
PtoE(4,R)
PtoE(12,R)

R = symmRing 4
apply(1..20, i -> PtoE(i,R) - PtoE(i,R))
PtoE(30,R)
R = symmRing 6
PtoE(12,R)
apply(1..10, i -> PtoE(i,R) - PtoE(i,R))
time PtoE(12,R)

plethysmMap(3,R)

R10 = symmRing 10
R = symmRing 3
f = toS plethysm(jacobiTrudiE({10},R10), jacobiTrudiE({2},R)) -- assert(f == {({4}, 1), ({2, 2}, 1)})

R = symmRing 5
f = toS plethysm(jacobiTrudiE({1,1},R), jacobiTrudiE({2},R)) -- {3,1}
f = toS plethysm(jacobiTrudiE({1,1},R), jacobiTrudiE({3},R)) -- {5,1} + {3,3}


--------------------
-- test of cauchy --
--------------------
restart
load "schur.m2"
R1 = symmRing 5
f = jacobiTrudiE({2},R1)
g = jacobiTrudiE({1},R1)
cauchy(2,f,g)
cauchy(3,f,g)
R1 = symmRing 1
R2 = symmRing 2
cauchy(2,jacobiTrudiE({1},R1),jacobiTrudiE({2},R2))
toS oo_0_1
cauchy(3,1_R1,jacobiTrudiE({3},R2))
toS oo_0_1
--------------------
-- test of bott ----
--------------------
restart
load "schur.m2"
R1 = symmRing 5
bott({0,3,0}) == (1, {2, 1, 0})
bott({1,2,0}) === null
bott({2,1,0}) == (0, {2, 1, 0})
bott({2,4,0}) == (1, {3, 3, 0})
bott({0,3,3}) == (2, {2, 2, 2})
bott({3,2,1,20,10,1})
--------------------
-- test of pairProduct
--------------------
restart
load "schur.m2"
R1 = symmRing 1
R2 = symmRing 2
L = {{(1_R1, jacobiTrudiE({3},R2))}, 
     {(jacobiTrudiE({1},R1), jacobiTrudiE({2},R2))}, 
     {(jacobiTrudiE({2},R1), jacobiTrudiE({1},R2))}}
pairProduct L
L1 = drop(L,1)
pairProduct L1
wedge({2,1,0},L)
c1 = cauchy(3,L#0#0#0, L#0#0#1)
c2 = cauchy(2,L#1#0#0, L#1#0#1)
(c1_0)/toS
(c2_0)/toS
(c2_1)/toS
wedge({3,2,0},L)
L#0#0#0
L#0#0#1

L/(v -> (toS v#0#1))

--------------------
-- test of plethysm
--------------------
restart
load "schur.m2"
R = symmRing 2
plethysm({1,1},jacobiTrudiE({2},R))
toS oo
plethysm({1,1,1},jacobiTrudiE({4},R))
toS oo
--------------------
-- test of wedge
--------------------
restart
load "schur.m2"
R1 = symmRing 1
R2 = symmRing 2
L = {{(1_R1, jacobiTrudiE({3},R2))}, 
     {(jacobiTrudiE({1},R1), jacobiTrudiE({2},R2))}, 
     {(jacobiTrudiE({2},R1), jacobiTrudiE({1},R2))}}
wedge({3,2,0},L)
wedge({3,0,0},L)
z = preBott(1,L,{4,3,2})
doBott(5,z)

weyman(1,L,{4,3,2})
weyman(2,L,{4,3,2})
weyman(3,L,{4,3,2})
weyman(4,L,{4,3,2})
weyman(5,L,{4,3,2})
weyman(6,L,{4,3,2})
weyman(7,L,{4,3,2})
weyman(8,L,{4,3,2})
weyman(9,L,{4,3,2})
--------------------
restart
load "schur.m2"
R1 = symmRing 1
R2 = symmRing 3
L = {{(1_R1, jacobiTrudiE({4},R2))}, 
     {(jacobiTrudiE({1},R1), jacobiTrudiE({3},R2))}, 
     {(jacobiTrudiE({2},R1), jacobiTrudiE({2},R2))},
     {(jacobiTrudiE({3},R1), jacobiTrudiE({1},R2))}}
wedge({3,2,0},L)
wedge({3,0,0},L)
z = preBott(1,L,{4,3,2})
doBott(5,z)

weyman(1,L,{15,10,6,3})
weyman(2,L,{15,10,6,3})
weyman(3,L,{15,10,6,3})
weyman(4,L,{15,10,6,3})
weyman(7,L,{15,10,6,3})
weyman(15,L,{15,10,6,3})

y

weyman(2,L,{4,3,2})
weyman(3,L,{4,3,2})
weyman(4,L,{4,3,2})
weyman(5,L,{4,3,2})
weyman(6,L,{4,3,2})
weyman(7,L,{4,3,2})
weyman(8,L,{4,3,2})
weyman(9,L,{4,3,2})
	       
--------------------
#(compositions(9,3))



n = 3
--R = QQ[x_1 .. x_n]
p = symbol p
R = QQ[x_1 .. x_n, p_1 .. p_n, MonomialOrder => ProductOrder {n,n}]
slambda = (lambda) -> (
     map(R^n, n, (i,j) -> x_(i+1)^(lambda#j+n-j-1))
     )

schur = (lambda) -> (
     p := toList(#lambda:0);
     det slambda(lambda) // det slambda p)


end

restart
load "schur.m2"
(H,E,P,S) = symmRings 4
f = jacobiTrudiE({4,1},E)
tos f 
tos f == S_{4,1}
f = jacobiTrudiE({2,1},E)
tos f
tos f == S_{2,1}
f = jacobiTrudiE({7,4,2},E)
tos f
tos f == S_{2,1}


R = hring 4
describe R
f = jacobiTrudi([2,1],R)
tos f




f = jacobiTrudi([4,1],H)
tos f

dualPartition {4,1}

dualPartition {4,2,2,1,1}
dualPartition {5,4,4,4,1}
dualPartition {2,2,2,2}

htos(3,R)

parts(3,1)
parts(3,2)
parts(3,3)
parts(0,1)
parts(1,1)

schur {2,1,0}
schur {2,0,0}
schur {1,1,1}

I = ideal apply(n, i -> p_(i+1) - sum apply(n, j -> x_(j+1)^(i+1)))
schur{2,0,0}  % I
schur{2,1,0} % I
schur{1,1,1} % I
exponents oo
