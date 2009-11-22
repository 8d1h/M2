-- -*- coding: utf-8 -*-
needsPackage "Polyhedra"
newPackage(
     "NormalToricVarieties",
     AuxiliaryFiles => true,
     Version => "0.75",
     Date => "12 November 2009",
     Authors => {{
	       Name => "Gregory G. Smith", 
	       Email => "ggsmith@mast.queensu.ca", 
	       HomePage => "http://www.mast.queensu.ca/~ggsmith"}},
     Headline => "normal toric varieties",
     DebuggingMode => true
     )

export { 
     NormalToricVariety, 
     normalToricVariety, 
     projectiveSpace, 
     hirzebruchSurface, 
     weightedProjectiveSpace, 
     classGroup, 
     isDegenerate,
     isProjective,
     isSimplicial,
     latticeIndex,
     makeSimplicial,
     weilDivisors, 
     cartierDivisors, 
     cartierToPicard,
     cartierToWeil, 
     picardGroup,
     picardToClass,
     nef,
     smoothFanoToricVariety,
     WeilToClass,
     weilToClass
     }

---------------------------------------------------------------------------
-- CODE
---------------------------------------------------------------------------
needsPackage "FourierMotzkin"
needsPackage "Polyhedra"


---------------------------------------------------------------------------
-- some local functions
makePrimitive = method()
makePrimitive List := w -> (g := gcd w; apply(w, e -> e//g))

---------------------------------------------------------------------------
NormalToricVariety = new Type of Variety
NormalToricVariety.synonym = "normal toric variety"
NormalToricVariety.GlobalAssignHook = globalAssignFunction
NormalToricVariety.GlobalReleaseHook = globalReleaseFunction
expression NormalToricVariety := X -> new FunctionApplication from { normalToricVariety, Adjacent{rays X, Adjacent{",",max X}}}

normalToricVariety = method(TypicalValue => NormalToricVariety, Options => {
	  CoefficientRing => QQ,
	  Variable => symbol x,	  
	  WeilToClass => null
	  })
normalToricVariety (List, List) := opts -> (V,F) -> (
     X := new NormalToricVariety from {
	  symbol rays => V,
	  symbol max => F,
	  symbol cache => new CacheTable};
     if opts.WeilToClass =!= null then X.cache.weilToClass = opts.WeilToClass;
     X.cache.CoefficientRing = opts.CoefficientRing;
     X.cache.Variable = opts.Variable;
     return X)

--rays = method(TypicalValue => List)
rays NormalToricVariety := List => X -> X.rays
max NormalToricVariety := List => X -> X.max

projectiveSpace = method()
projectiveSpace ZZ := NormalToricVariety => d -> (
     if d < 0 then error "-- expected nonnegative integer";
     V := entries transpose (map(ZZ^d,ZZ^1, i -> -1) | map(ZZ^d,ZZ^d,1));
     F := subsets(d+1,d);
     X := normalToricVariety(V,F),
     return X)

hirzebruchSurface = method()
hirzebruchSurface ZZ := NormalToricVariety => a -> (
     V := {{1, 0}, {0, 1}, { -1, a}, {0, -1}};
     F := {{0,1}, {1,2}, {2,3}, {0,3}};
     X := normalToricVariety(V,F,WeilToClass => matrix{{1,-a,1,0},{0,1,0,1}});
     return X)

weightedProjectiveSpace = method()
weightedProjectiveSpace List := NormalToricVariety => q -> (
     if not all(q, i -> i > 0) then error "-- expected positive integers";
     if gcd q != 1 then error "-- expected the gcd to be one";
     d := #q-1;
     Q := transpose matrix{q};
     N := prune cokernel Q;
     V := transpose entries (N.cache.pruningMap)^-1;
     F := subsets(d+1,d);
     X := normalToricVariety(V,F);
     return X)

NormalToricVariety ** NormalToricVariety := NormalToricVariety => (X,Y) -> (
     V1 := transpose matrix rays X;
     V2 := transpose matrix rays Y;
     V := entries transpose (V1 ++ V2);
     F1 := max X;
     F2 := max Y;
     n := #rays X;
     F2 = apply(F2, s -> apply(s, i -> i+n));
     F := flatten table(F1,F2, (s,t) -> s|t);
     XY := normalToricVariety(V,F);
     return XY)

dim NormalToricVariety := ZZ => (cacheValue symbol dim)(X -> #(rays X)#0)


--??
dim (List,NormalToricVariety):= ZZ => (sigma,X) -> (
	if (not X.cache.?cones) then X.cache.cones = new MutableHashTable;
	if (not X.cache.cones#?sigma) then (
		X.cache.cones#sigma = if #sigma>1 then (
			N := (smithNormalForm matrix (rays X)_sigma)_0;
			(rank N,  product toList apply(rank N, i-> N_(i,i)))
			) else (1,1));
	X.cache.cones#sigma#0)

--??
latticeIndex = method()
latticeIndex (List,NormalToricVariety):= (sigma,X) ->(
	if (not X.cache.?cones) then X.cache.cones = new MutableHashTable;
	if (not X.cache.cones#?sigma) then ( 
		X.cache.cones#sigma = if #sigma>1 then (
			N := (smithNormalForm matrix (rays X)_sigma)_0;
			(rank N,  product toList apply(rank N, i-> N_(i,i)))
			) else (1,1));
	X.cache.cones#sigma#1)

isDegenerate = method()
isDegenerate NormalToricVariety := Boolean => (cacheValue symbol isDegenerate)(X -> kernel matrix rays X != 0)

isSimplicial = method()
isSimplicial NormalToricVariety := Boolean => (cacheValue symbol isSimplicial)(X -> (
     	  V := transpose matrix rays X;
     	  return all(max X, s -> #s == rank V_s)))
     
isSmooth NormalToricVariety := Boolean => (cacheValue symbol isSmooth)(X -> (
     	  V := transpose matrix rays X;
     	  b := all(max X, s -> #s == rank V_s and 1 == minors(#s,V_s));
	  if b == true then X.cache.simplicial = true;
	  return b))

classGroup = method()
classGroup NormalToricVariety := Module => (cacheValue symbol classGroup)(X -> (
	  rawC := cokernel matrix rays X;
	  C := prune rawC;
	  W := weilDivisors X;
	  if X.cache.?weilToClass then X.cache.WeilToClass = map(C, W, matrix X.cache.weilToClass)
	  else X.cache.weilToClass = map(C, W, matrix (C.cache.pruningMap)^-1);
     	  return C))

weilToClass = method()
weilToClass NormalToricVariety := Matrix => X -> (
     if not X.cache.?classGroup then classGroup X;
     return X.cache.weilToClass)

weilDivisors = method()
weilDivisors NormalToricVariety := Module => (cacheValue symbol weilDivisors)(X -> ZZ^(#rays X))

cartierDivisors = method()
cartierDivisors NormalToricVariety := Module => (cacheValue symbol CDiv)(X -> (
	  local CDiv;
	  if isSmooth X then (
	       CDiv = weilDivisors X;
	       X.cache.cartierToWeil = id_CDiv;
	       return CDiv)
	  else (
	       V := transpose matrix rays X;
	       F := max X;
	       d := rank target V;
	       n := #rays X;
	       H1 := new HashTable from apply(F, s -> {s, coker (fourierMotzkin V_s)#1});
	       H2 := new HashTable from flatten apply(toList(0..#F-1), 
     	       	    i -> apply(toList(i+1..#F-1), j -> (
	       		      s := select(F#i, k -> member(k,F#j));
	       		      if #s > 0 then {(F#i,F#j), coker (fourierMotzkin V_s)#1})));
	       K := keys H1;	       
	       P1 := directSum apply(K, k -> k => H1#k);
	       local D;
	       if #keys H2 == 0 then D = ker map(ZZ^0,P1,0) else (
     		    P2 := directSum apply(keys H2, k -> k => H2#k);
     		    M := transpose matrix table(K, keys H2, (j,k) -> if j == k#0 then 1 
     	  		 else if j == k#1 then -1 else 0);
     		    D = kernel map(P2,P1,M ** id_(ZZ^d)));
	       CDiv = prune D;
	       L := apply(n, i -> position(K, s -> member(i,s)));
	       inc := matrix table(n,keys H1, (i,s) -> if s == K#(L#i) then 1 else 0);
	       local iota;
	       iota = inc^{0} ** transpose V_{0};
	       scan(#L -1, i -> iota = iota || inc^{i+1} ** transpose V_{i+1});
	       iota = map(weilDivisors X, D, iota * gens D);
	       X.cache.cartierToWeil = map(weilDivisors X, CDiv, iota * (CDiv.cache.pruningMap));
	       return CDiv)))

cartierToWeil = method()
cartierToWeil NormalToricVariety := Matrix => X -> (
     if not X.cache.?cartierToWeil then cartierDivisors X;
     return X.cache.cartierToWeil)

picardGroup = method()
picardGroup NormalToricVariety := Module => (cacheValue symbol picardGroup)(X -> (
	  local C;
	  if isSmooth X then (
	       C = classGroup X;
	       X.cache.picardToClass = id_C;
	       X.cache.cartierToPicard = weilToClass X;
	       return C)
	  else (
               V := rays X;
               d := dim X;
               phi := map(weilDivisors X, ZZ^d, matrix V);
               psi := cartierToWeil X;
	       rawP := subquotient(psi,phi);
	       P := prune rawP;
	       iota := P.cache.pruningMap;
	       X.cache.cartierToPicard = map(P,cartierDivisors X, iota^-1);
	       C = cokernel matrix rays X;
	       theta := inducedMap(C,rawP);
	       eta := map(classGroup X, C, matrix weilToClass X);
               X.cache.picardToClass = eta * theta * iota;
	       return P)))

picardToClass = method()
picardToClass NormalToricVariety := Matrix => X -> (
     if not X.cache.?picardToClass then picardGroup X;
     return X.cache.picardToClass)

cartierToPicard = method()
cartierToPicard NormalToricVariety := Matrix => X -> (
     if not X.cache.?cartierToPicard then picardGroup X;
     return X.cache.cartierToPicard)
     

nef = method()
nef NormalToricVariety := List => X -> (
     if not isSimplicial X then error "not yet implemented for non-simplicial toric varieties";
     B := ideal X;
     A := transpose matrix degrees ring X;
     outer := 0 * A_{0};
     scan(B_*, m -> outer = outer | (fourierMotzkin A_(apply(support(m), z -> index z)))#0 );
     entries transpose ((fourierMotzkin outer)#0)^{0..(#rays X - dim X-1)})


ring NormalToricVariety := PolynomialRing => (cacheValue symbol ring)(X -> (
	  if isDegenerate X then error "--total coordinate ring for degenerate varieties is not yet implemented";
	  if not isFreeModule classGroup X then error "--gradings by torsion groups not yet implemented";	  
	  n := #rays X;
	  A := matrix weilToClass X;
	  deg := entries transpose A;
	  x := X.cache.Variable;
	  K := X.cache.CoefficientRing;
	  return K(monoid[x_0..x_(n-1), Degrees => deg])))

ideal NormalToricVariety := Ideal => (cacheValue symbol ideal)(X -> (
	  S := ring X;
	  n := numgens S;
	  return ideal apply(max X, L -> product(n, i -> if member(i,L) then 1_S else S_i))))
monomialIdeal NormalToricVariety := MonomialIdeal => X -> monomialIdeal ideal X

sheaf (NormalToricVariety,Module) := CoherentSheaf => (X,M) -> (
     if ring M =!= ring X then error "expected module and variety to have the same ring";
     if not isHomogeneous M then error "expected a homogeneous module";
     new CoherentSheaf from {
	  symbol module => M,
	  symbol variety => X})
sheaf (NormalToricVariety,Ring) := SheafOfRings => (X,R) -> (
     if ring X =!= R then error "expected the ring of the variety";
     if not X.cache.?structureSheaf then (
     	  X.cache.structureSheaf = new SheafOfRings from { 
	       symbol variety => X, 
	       symbol ring => R });
     X.cache.structureSheaf)
sheaf NormalToricVariety := X -> sheaf_X ring X

installMethod(symbol _, OO, NormalToricVariety, (OO,X) -> sheaf(X, ring X))

CoherentSheaf Sequence := CoherentSheaf => (F,a) -> sheaf(variety F, F.module ** (ring F)^{toList(a)})
SheafOfRings Sequence := CoherentSheaf => (O,a) -> O^1 a

super   CoherentSheaf := CoherentSheaf => F -> sheaf(variety F, super   module F)
ambient CoherentSheaf := CoherentSheaf => F -> sheaf(variety F, ambient module F)
cover   CoherentSheaf := CoherentSheaf => F -> sheaf(variety F, cover   module F)

-- internal code which creates a HashTable describing the cohomology
-- of all twists of the structure sheaf; see Propositon~3.2 in 
-- Maclagan-Smith "Multigraded regularity"
setupHHOO = X -> (
     X.cache.emsBound = new MutableHashTable;
     -- create a fine graded version of the total coordinate ring
     S := ring X;
     n := numgens S;
     fineDeg := entries id_(ZZ^n);
     h := toList(n:1);
     R := QQ(monoid [gens S, Degrees => fineDeg, Heft => h]);
     RfromS := map(R, S, gens R);
     B := RfromS ideal X;
     -- use simplicial cohomology find the support sets 
     quasiCech := Hom(res (R^1/B), R^1);
     supSets := delete({},subsets(toList(0..n-1)));
     d := dim X;
     sigma := new MutableHashTable;
     sigma#0 = {{}};
     scan(1..d, i -> (
	       sHH := prune HH^(i+1)(quasiCech);
	       sigma#i = select(supSets, 
		    s -> basis(-degree product(s, j -> R_j), sHH) != 0)));
     -- create rings
     degS := degrees S; 
     X.cache.rawHHOO = new HashTable from apply(d+1, 
	  i -> {i,apply(sigma#i, s -> (
		    v := - degree product(n, 
			 j -> if member(j,s) then S_j else 1_S);
		    degT := apply(n, 
			 j -> if member(j,s) then -degS#j else degS#j);
		    T := (ZZ/2)(monoid [gens S, Degrees => degT]);
		    {v,T,s}))});)



-- internal code for the Frobenius power of an ideal
Ideal ^ Array := (I,p) -> ideal apply(I_*, i -> i^(p#0))

-- internal code which creates a HashTable which stores data for 
-- determining the appropriate Frobenius power need to compute
-- the cohomology of a general coherent sheaf; see Proposition~4.1
-- in Eisenbud-Mustata-Stillman
emsbound = (i,X,deg) -> (
     if not X.cache.emsBound#?{i,deg} then (
	  if i < 0 or i > dim X then X.cache.emsBound#{i,deg} = 1
	  else X.cache.emsBound#{i,deg} = max ( {1} | apply(X.cache.rawHHOO#i, 
	       t -> #t#2 + max apply(first entries basis(deg-t#0,t#1),
		    m -> max (first exponents m)_(t#2)))));
     X.cache.emsBound#{i,deg})

cohomology (ZZ,NormalToricVariety,CoherentSheaf) := Module => opts -> (i,X,F) -> (
     if ring F =!= ring X then error "expected a coherent sheaf on the toric variety";
     S := ring X;
     kk := coefficientRing S;
     if not isField kk then error "expected a toric variety over a field";
     if i < 0 or i > dim X then kk^0
     else (
     	  if not X.cache.?rawHHOO then setupHHOO X;
     	  M := module F;
     	  if isFreeModule M then kk^(
	       sum apply(degrees M, deg -> sum apply(X.cache.rawHHOO#i,
		    	 t -> rank source basis(-deg-t#0,t#1))))
     	  else (
	       B := ideal X;
	       C := res M;
	       deg := toList(degreeLength S : 0);
	       bettiNum := flatten apply(1+length C, 
	  	    j -> apply(unique degrees C_j, alpha -> {j,alpha}));
	       b1 := max apply(bettiNum, 
		    beta -> emsbound(i+beta#0-1,X,deg-beta#1));
     	       b2 := max apply(bettiNum, 
			 beta -> emsbound(i+beta#0,X,deg-beta#1));	       
	       b := max(b1,b2);
     	       if i > 0 then kk^(rank source basis(deg, Ext^(i+1)(S^1/B^[b],M)))
	       else (
     	  	    h1 := rank source basis(deg, Ext^(i+1)(S^1/B^[b],M));
     	  	    h0 := rank source basis(deg, Ext^i(S^1/B^[b1],M));
     	  	    kk^(rank source basis(deg,M) + h1 - h0)))))
cohomology (ZZ,NormalToricVariety,SheafOfRings) := Module => opts -> (i,X,O) -> HH^i(X,O^1)

-- internal code creating a HashTable with the defining data of low dimensional smooth
-- Fano toric varieties
fanoFile := currentFileDirectory | "NormalToricVarieties/smoothFanoToricVarieties.txt"
getFano := memoize(
     () -> (
	  if notify then stderr << "--loading file " << fanoFile << endl;
	  hashTable apply( lines get fanoFile,
	       x -> (
	       	    x = value x;
	       	    ((x#0,x#1),drop(x,2))))))

smoothFanoToricVariety = method()
smoothFanoToricVariety (ZZ,ZZ) := NormalToricVariety => (d,i) -> (
     if d < 0 or i < 0 then error "expected positive integers"
     else if d === 1 and i > 0 then error "there is only one smooth Fano toric curve"
     else if d === 2 and i > 4 then error "there are only five smooth Fano toric surfaces"
     else if d === 3 and i > 17 then error "there are only 18 smooth Fano toric 3-folds"
     else if d === 4 and i > 123 then error "there are only 124 smooth Fano toric 4-folds"
     else if d > 4 then error "database doesn't (yet?) include smooth Fano toric varieties of dimension greater than 4"
     else if i === 0 then return projectiveSpace d
     else (
	  s := (getFano())#(d,i);
	  X := normalToricVariety(s#0,s#1, WeilToClass => matrix s#2);
	  return X))



---------------------------------------------------------------------------
-- code that interfaces with the Polyhedra package

normalToricVariety Fan := F -> (
     R := rays F;
     Fs := apply(genCones F, C -> (Cr:=rays C; Cr = set apply(numColumns Cr, i -> Cr_{i}); positions(R,r -> Cr#?r)));
     X := new NormalToricVariety from {
	  symbol rays => apply(R, r -> flatten entries r),
	  symbol max => Fs,
	  symbol cache => new CacheTable};
     X.cache.isFan = true;
     X.cache.Fan = F;
     X)

normalToricVariety Polyhedron := P -> normalToricVariety normalFan P

isWellDefined NormalToricVariety := Boolean => X -> (
     if not X.cache.?isFan then (
	  X.cache.isFan = false;
	  if all(rays X, r -> gcd r == 1) and sort unique flatten max X == toList(0..#(rays X)-1) then (
	       F := max X;
	       if all(#F-1, i -> all(i+1..#F-1, j -> not (isSubset(set F#i,set F#j) or isSubset(set F#j,set F#i)))) then (
		    R := matrix transpose rays X;
		    F = apply(F, f -> (f,posHull R_f));
		    if all(F, f -> #(f#0) == numColumns rays f#1) then (
			 F = apply(F, f -> f#1);
			 if commonFace F then (
			      X.cache.Fan = fan F;
			      X.cache.isFan = true)))));
     X.cache.isFan)

isComplete NormalToricVariety := X -> (
     if not X.cache.?Fan or not X.cache.?isComplete then X.cache.isComplete = isComplete fan X;
     X.cache.isComplete)

isPure NormalToricVariety := X -> (
     if not X.cache.?Fan or not X.cache.?isPure then X.cache.isPure = isPure fan X;
     X.cache.isPure)

isProjective = method(TypicalValue => Boolean)
isProjective NormalToricVariety := X -> (
     if not X.cache.?isFan then isFan X;
     if not X.cache.isFan then error("The data does not define a Fan");
     isPolytopal X.cache.Fan)

fan NormalToricVariety := X -> (
     if not X.cache.?Fan then (
	  R := promote(matrix transpose rays X,QQ);
	  L := sort apply(max X, C -> posHull R_C);
	  X.cache.Fan = new Fan from {
	       "generatingCones" => set L,
	       "ambient dimension" => numRows R,
	       "top dimension of the cones" => dim L#0,
	       "number of generating cones" => #L,
	       "rays" => set apply(rays X, r -> promote(matrix transpose {r},QQ)),
	       "number of rays" => numColumns R,
	       "isPure" => dim L#0 == dim last L,
	       symbol cache => new CacheTable});
     X.cache.Fan)


halfspaces (List,NormalToricVariety) := Matrix => (sigma,X) -> (
     if not X.cache.?halfspaces then X.cache.halfspaces = new MutableHashTable;
     if not X.cache.halfspaces#?sigma then X.cache.halfspaces#sigma = -(fourierMotzkin matrix transpose ((rays X)_sigma))#0;
     X.cache.halfspaces#sigma)

makeSimplicial = method()
makeSimplicial NormalToricVariety := NormalToricVariety => X ->(
     R := rays X;
     Rm := matrix rays X;
     Cones := partition(l -> dim(l,X) == #l,max X);
     simpCones := if Cones#?true then Cones#true else {};
     Cones = if Cones#?false then Cones#false else {};
     while Cones != {} do (
	  C := Cones#0;
	  HS := halfspaces(C,X);
	  FL := reverse faceLatticeSimple(dim(C,X),transpose Rm^C,HS);
	  r := {};
	  for i from 1 to #FL-1 do (
	       nonsimpFace := select(1,FL#i, e -> #(toList e#0) != i+2);
	       if nonsimpFace != {} then (r = makePrimitive flatten entries sum toList nonsimpFace#0#0; break));
	  Y := normalToricVariety(R,Cones);
	  Y.cache.halfspaces = X.cache.halfspaces;
	  Y.cache.cones = X.cache.cones;
	  X = stellarSubdivision(Y,r);
	  R = rays X;
	  Rm = matrix R;
	  Cones = partition(l -> dim(l,X) == #l, max X);
	  if Cones#?true then simpCones = simpCones | Cones#true;
	  if Cones#?false then Cones = Cones#false else Cones = {});
     Xsimp := normalToricVariety(R,simpCones);
     Xsimp.cache.cones = X.cache.cones;
     if X.cache.?halfspaces then Xsimp.cache.halfspaces = X.cache.halfspaces;
     Xsimp)


faceLatticeSimple = (d,R,HS) -> (
     R = apply(numColumns R, i -> R_{i});
     HS = apply(numColumns HS, i -> transpose HS_{i});
     L := {(set R,set {},set HS)};
     {L}|apply(d-2, i -> (
	       Lnew := flatten apply(L, l -> (
			 l = (toList l#0,toList l#1,toList l#2);
			 lnew := apply(#(l#2), j -> (
				   hs := (l#2)#j;
				   newrs := select(l#0, r -> hs * r == 0);
				   newHS := select(drop(l#2,{j,j}), k -> any(newrs, r -> k * r == 0));
				   (set newrs,set(l#1|{hs}),set newHS)));
			 lnew = select(lnew, e -> all(lnew, f -> not isSubset(e#0,f#0) or e === f))));
	       L = unique Lnew)))


stellarSubdivision (NormalToricVariety,List) := (X,r) -> (
     replacement := {};
     rm := matrix transpose {r};
     n := #(rays X);
     R := matrix rays X;
     newMax := flatten apply(max X, C -> (
	       M := promote(R^C,QQ);
	       if replacement == {} then (		    
		    if dim(C,X) == #C then (
			 -- Simplicial Cone
			 M = inverse M;
			 v := flatten entries (transpose M * rm);
			 if all(v, i -> i >= 0) then (
			      replacement = positions(v, i -> i > 0);
			      replacement = apply(replacement, i -> C#i);
			      C = toList (set C - set replacement) | {n};
			      apply(#replacement, i -> sort(C|drop(replacement,{i,i}))))
			 else {C})
		    else (
			 -- Non-simplicial Cone
			 HS := transpose halfspaces(C,X);
			 w := flatten entries (HS * rm);
			 if all(w, i -> i >= 0) then (
			      replacement = positions(w, i -> i == 0);
			      correctFaces := submatrix'(HS,replacement);
			      HS = HS^replacement;
			      replacement = select(C, i -> HS * (transpose R^{i}) == 0);
			      apply(numRows correctFaces, i -> select(C, j -> (correctFaces^{i}) * (transpose R^{j}) == 0) | {n}))
			 else {C}))
	       else (
		    if isSubset(set replacement,set C) then (
			 if dim(C,X) == #C then (
			      -- Simplicial Cone
			      C = toList (set C - set replacement) | {n};
			      apply(#replacement, i -> sort(C|drop(replacement,{i,i}))))
			 else (
			      HS1 := transpose halfspaces(C,X);
			      for i from 0 to numRows HS1 -1 list (
				   if HS1^{i} * (transpose R^replacement) == 0 then continue else select(C, j -> HS1^{i} * (transpose R^{j}) == 0) | {n})))
		    else {C})));
     newRays := rays X | {r};
     Y := new NormalToricVariety from {
	  symbol rays => newRays,
	  symbol max => newMax,
	  symbol cache => new CacheTable};
     if X.cache.?halfspaces then Y.cache.halfspaces = X.cache.halfspaces;
     Y.cache.cones = X.cache.cones;
     Y)

---------------------------------------------------------------------------
-- THINGS TO IMPLEMENT?
--   isFano
--   cotangentBundle
--   homology,NormalToricVariety
--   blow-ups
--   operational Chow rings
--   vector bundles?
--   faces
--   linear series
--   isComplete
--   isProjective
--   isCartier
--   isAmple
--   isVeryAmple
--   isSemiprojective
--

---------------------------------------------------------------------------
-- DOCUMENTATION
---------------------------------------------------------------------------
beginDocumentation()
    
document { 
     Key => NormalToricVarieties,
     Headline => "normal toric varieties",
     "A toric variety is an integral scheme such that an algebraic
     torus forms a Zariski open subscheme and the natural action this
     torus on itself extends to an action on the entire scheme.
     Normal toric varieties correspond to combinatorial objects,
     namely strongly convex rational polyhedral fans.  This makes the
     theory of normal toric varieties very explicit and computable.",
     PARA{},     
     "This ", EM "Macaulay 2", " package is designed to manipulate
     normal toric varieties and related geometric objects.  An
     introduction to the theory of normal toric varieties can be found
     in the following textbooks:",     
     UL { 
	  {"David A. Cox, John B. Little, Hal Schenck, ", EM "Toric
	  varieties", ", preprint available at ", 
	  HREF("http://www.cs.amherst.edu/~dac/toric.html", TT "www.cs.amherst.edu/~dac/toric.html")},	       
	  {"Günter Ewald, ", EM "Combinatorial convexity and algebraic
           geometry", ", Graduate Texts in Mathematics 168. 
	   Springer-Verlag, New York, 1996. ISBN: 0-387-94755-8" },
	  {"William Fulton, ", EM "Introduction to toric varieties",
	   ", Annals of Mathematics Studies 131, Princeton University 
	   Press, Princeton, NJ, 1993. ISBN: 0-691-00049-2" }, 
	  {"Tadao Oda, ", EM "Convex bodies and algebraic geometry, an
	   introduction to the theory of toric varieties", ",
	   Ergebnisse der Mathematik und ihrer Grenzgebiete (3) 15,
	   Springer-Verlag, Berlin, 1988. ISBN: 3-540-17600-4" },
	   },
     SUBSECTION "Contributors",
     "The following people have generously contributed code or worked
     on our code.",     
     UL {
	  {HREF("http://www.math.purdue.edu/~cberkesc/","Christine Berkesch")},	  
	  {HREF("http://page.mi.fu-berlin.de/rbirkner/indexen.htm","René Birkner")},
     	  {HREF("http://www.warwick.ac.uk/staff/D.Maclagan/","Diane Maclagan")},
	  {HREF("http://www.math.uiuc.edu/~asecele2/","Alexandra Seceleanu")},
	  },
     Subnodes => {
	  TO NormalToricVariety,
	  TO "Basic properties and invariants",
	  TO "Working with Cartier and Weil divisors",
	  TO "Cox ring and coherent sheaves",
	  TO "Resolution of singularities",
	  }
     }  

document { 
     Key => NormalToricVariety,
     Headline => "the class of all normal toric varieties",  
     "A normal toric variety corresponds to a strongly convex rational
     polyhedral fan in affine space.  ", 
     "In this package, the fan associated to a normal ", TEX ///$d$///,
     "-dimensional toric variety lies in the rational vector space ",
     TEX ///$\QQ^d$///, " with underlying lattice ", 
     TEX ///$N = \ZZ^d$///, ".  The fan is encoded by the minimal
     nonzero lattice points on its rays and the set of rays defining
     the maximal cones (meaning cones that are not proper subsets of
     another cone in the fan).",
     Subnodes => {
	  TO (rays,NormalToricVariety),
	  TO (max,NormalToricVariety),
	  TO (expression,NormalToricVariety),
	  TO normalToricVariety,	  
	  }
     }  

document { 
     Key => {(rays, NormalToricVariety)},
     Headline => "the rays of the fan",
     Usage => "rays X",
     Inputs => {"X" => NormalToricVariety},
     Outputs => {List => " of lists of integers; each entry
          corresponds to a minimal nonzero lattice point on the ray in
          the fan" },
     "A normal toric variety corresponds to a strongly convex rational
     polyhedral fan in affine space.  ", 	  	  
     "In this package, the fan associated to a normal ", 
     TEX ///$d$///, "-dimensional toric variety lies in the rational
     vector space ", TEX ///$\QQ^d$///, " with underlying
     lattice ", TEX ///$N = \ZZ^d$///, ".  As a result, each
     ray in the fan is determined by the minimal nonzero lattice point
     it contains.  Each such lattice point is given as a ",
     TO2(List,"list"), " of ", TEX ///$d$///, " ", TO2(ZZ,"integers"),
     ".",
     PARA{},
     "There is a bijection between the rays and torus-invariant Weil
     divisor on the toric variety.",
     PARA{},
     "The examples show the rays for the projective plane, projective
     ", TEX ///$3$///, "-space, a Hirzebruch surface, and a weighted
     projective space.",
     EXAMPLE lines ///
	  PP2 = projectiveSpace 2;
	  rays PP2
	  dim PP2
	  ///,
     EXAMPLE lines ///
	  PP3 = projectiveSpace 3;
	  rays PP3
	  dim PP3
	  ///,
     EXAMPLE lines ///
	  FF7 = hirzebruchSurface 7;
	  rays FF7
	  dim FF7
	  ///,
     EXAMPLE lines ///
	  X = weightedProjectiveSpace {1,2,3};
	  rays X
	  dim X
	  ///,     	  
     "When ", TT "X", " is nondegerenate, the number of rays equals
     the number of variables in the total coordinate ring.",
     EXAMPLE lines ///
	  #rays X == numgens ring X
          ///,
     "An ordered list of the minimal nonzero lattice points on the
     rays in the fan is part of the defining data of a toric variety.",
     SeeAlso => {
	  normalToricVariety, 
	  (max, NormalToricVariety),
	  (ring, NormalToricVariety)
	  } 
     }

document { 
     Key => {(max, NormalToricVariety)},
     Headline => "the maximal cones in the fan",
     Usage => "max X",
     Inputs => {"X" => NormalToricVariety},
     Outputs => {List => " of lists of nonnegative integers; each
	  entry indexes the rays which generate a maximal cone in the
	  fan"},
     "A normal toric variety corresponds to a strongly convex rational
     polyhedral fan in affine space.  ", 	  	  
     "In this package, the fan associated to a normal ", TEX ///$d$///,
     "-dimensional toric variety lies in the rational vector space ",
     TEX ///$\QQ^d$///, " with underlying lattice ", 
     TEX ///$N = \ZZ^d$///, ".  The fan is encoded by the minimal
     nonzero lattice points on its rays and the set of rays defining
     the maximal cones (meaning cones that are not proper subsets of
     another cone in the fan).  ",
     "The rays are ordered and indexed by nonnegative integers: ",
     TEX ///$0,\dots, n$///, ".  Using this indexing, a maximal cone
     in the fan corresponds to a sublist of ", 
     TEX ///$\{0,\dots,n\}$///, "; the entries index the
     rays that generate the cone.",
     PARA{},     
     "The examples show the maximal cones for the projective plane,
     projective 3-space, a Hirzebruch surface, and a weighted
     projective space.",
     EXAMPLE lines ///
	  PP2 = projectiveSpace 2;
	  #rays PP2
	  max PP2
	  ///,
     EXAMPLE lines ///
	  PP3 = projectiveSpace 3;
	  #rays PP3
	  max PP3
	  ///,
     EXAMPLE lines ///
	  FF7 = hirzebruchSurface 7;
	  #rays FF7
	  max FF7
	  ///,
     EXAMPLE lines ///
	  X = weightedProjectiveSpace {1,2,3};
	  #rays X
	  max X
	  ///,   
     "A list corresponding to the maximal cones in the fan is part of the 
     defining data of a toric variety.",
     SeeAlso => {
	  normalToricVariety, 
	  (rays, NormalToricVariety)
	  }
     }     

document { 
     Key => {(expression, NormalToricVariety)},
     Headline => "expression used to format for printing",
     Usage => "expression X",
     Inputs => {"X" => NormalToricVariety },
     Outputs => {Expression => {" used to format ", TT "X", 
	  " for printing"}},
     "This function is the primary function called upon by ", TO(symbol <<),
     " to format for printing.  It displays the minimal nonzero lattice 
     points on each ray and the subsets of rays which determine the maximal
     cones in the fan.",
     EXAMPLE lines ///
	  projectiveSpace 3
     	  rays projectiveSpace 3
	  max projectiveSpace 3
          ///,	
     EXAMPLE lines ///
	  hirzebruchSurface 7
	  rays hirzebruchSurface 7
	  max hirzebruchSurface 7
          ///,		    
     "After assignment to a global variable, ", EM "Macaulay 2", "
     knows the toric variety's name, and this name is used when
     printing.",
     EXAMPLE lines ///
	  PP2 = projectiveSpace 3
	  FF7 = hirzebruchSurface 7
	  ///,
     SeeAlso => {
	  normalToricVariety,
	  (rays,NormalToricVariety),
	  (max,NormalToricVariety)
	  }
     }   

document { 
     Key => {normalToricVariety, 
	  (normalToricVariety,List,List), 
	  [normalToricVariety,CoefficientRing],
	  [normalToricVariety,Variable],
	  [normalToricVariety,WeilToClass]	  
	  },
     Headline => "create a normal toric variety",
     Usage => "normalToricVariety(Rho,Sigma)",
     Inputs => {
	  "Rho" => List => "of lists of integers; each entry is the
	  minimal nonzero lattice point on a ray in the fan",
	  "Sigma" => List => "of lists of nonnegative integers; each
	  entry indexes the rays defining a maximal cone in the fan",
	  CoefficientRing => Ring => { "the coefficient ring of the
	  total coordinate ring"},
	  Variable => Symbol => {"the base symbol for the indexed
	  variables in the total coordinate ring"},
	  WeilToClass => Matrix => {"allows one to specify the map
	  from the group of torus-invariant Weil divisors to the class
	  group"},
          },
     Outputs => {NormalToricVariety => "the normal toric variety
	  determined by the fan" },
     "A normal toric variety corresponds to a strongly convex rational
     polyhedral fan in affine space.  ", 	  
     "In this package, the fan associated to a normal ", TEX ///$d$///,
     "-dimensional toric variety lies in the rational vector space ",
     TEX ///$\QQ^d$///, " with underlying lattice ", 
     TEX ///$N = \ZZ^d$///, ".  The fan is encoded by the minimal
     nonzero lattice points on its rays and the set of rays defining
     the maximal cones (meaning cones that are not proper subsets of
     another cone in the fan).  More precisely, ", TT "Rho", " lists
     the minimal nonzero lattice points on each ray
     (a.k.a. one-dimensional cone) in the fan.  Each lattice point is
     a ", TO2(List,"list"), " of ", TO2(ZZ,"integers"), ".  The rays
     are ordered and indexed by nonnegative integers: ",     
     TEX ///$0,\dots, n$///, ".  Using this indexing, a maximal cone
     in the fan corresponds to a sublist of ", 
     TEX ///$\{0,\dots,n\}$///, ".  All maximal cones are listed in ", 
     TT "Sigma", ".",
     PARA{},
     "The first example is projective ", TEX ///$2$///, "-space blown up
     at two points",
     EXAMPLE lines ///
	  Rho = {{1,0},{0,1},{-1,1},{-1,0},{0,-1}}
          Sigma = {{0,1},{1,2},{2,3},{3,4},{0,4}}
	  X = normalToricVariety(Rho,Sigma)
	  rays X
	  max X
	  dim X
	  ///,	 
     "The second example illustrates the data defining projective ",
     TEX ///$4$///, "-space.",     
     EXAMPLE lines ///	  
	  PP4 = projectiveSpace 4;
	  rays PP4
	  max PP4
	  dim PP4
	  ring PP4
	  PP4' = normalToricVariety(rays PP4, max PP4, CoefficientRing => ZZ)
	  ring PP4'
          ///,   
     "The optional argument ", TO WeilToClass, " allows one to specify
     the map from the group of torus-invariant Weil divisors to the
     class group.  In particular, this allows the user to choose her
     favourite basis for the class group.  This map also determines
     the grading on the total coordinate ring of the toric variety.",
     PARA{}, 
     "For example, we can choose the opposite generator for the class
     group of projective space as follows.",
     EXAMPLE lines ///
     	  PP2 = projectiveSpace 2;
	  A = weilToClass PP2
	  source A == weilDivisors PP2
	  target A == classGroup PP2
	  degrees ring PP2
     	  X = normalToricVariety(rays PP2, max PP2, WeilToClass => matrix{{-1,-1,-1}});
	  A' = weilToClass X
	  source A' == weilDivisors X
	  target A' == classGroup X	  
	  degrees ring X
     	  (matrix A')*(matrix rays X)
	  ///,
     "The integer matrix ", TT "A", " should span the kernel of the
     matrix whose columns are the minimal nonzero lattice points on
     the rays of the fan.",
     PARA{},	  
     "We can also choose a basis for the class group of a
     blow-up of the projective plane such that the nef cone is the
     positive quadrant.",     
     EXAMPLE lines ///
          Y = normalToricVariety({{1,0},{0,1},{-1,1},{-1,0},{0,-1}},{{0,1},{1,2},{2,3},{3,4},{0,4}});
     	  weilToClass Y
	  nef Y
          Y' = normalToricVariety(rays Y, max Y, WeilToClass => matrix{{1,-1,1,0,0},{0,1,-1,1,0},{0,0,1,-1,1}});	  
     	  weilToClass Y'
	  nef Y'
     	  ///,	  	  
     Caveat => {"This method assumes that the lists ", TT "Rho", " and
     	  ", TT "Sigma", " correctly encode a strongly convex rational
     	  polyhedral fan.  One can verify this by using ", 
	  TO (isWellDefined,NormalToricVariety), "."},
     Subnodes => {
	  TO projectiveSpace,
	  TO weightedProjectiveSpace,
	  TO hirzebruchSurface,
	  TO (symbol **, NormalToricVariety, NormalToricVariety),
	  TO smoothFanoToricVariety,	  
	  TO WeilToClass
	  },	  
     SeeAlso => {
	  (rays, NormalToricVariety), 
	  (max,NormalToricVariety)
	  }
     }	

document { 
     Key => {WeilToClass},
     Headline => "name for an optional argument",
     "A symbol used as the name of an optional argument",
     SeeAlso => {
     	  normalToricVariety,
	  weilToClass,
	  (ring,NormalToricVariety)
	  }
     }     


document { 
     Key => {projectiveSpace, 
	  (projectiveSpace,ZZ)},
     Headline => "projective space",
     Usage => "projectiveSpace d",
     Inputs => {
	  "d" => "a nonnegative integer",
	  },
     Outputs => {NormalToricVariety => {"projective ", TT "d", "-space"}},
     "Projective ", TEX ///$d$///, "-space is a smooth complete normal toric
     variety.  The rays are generated by the standard basis ", 
     TEX ///$e_1,\dots,e_d$///, " of ", TEX ///$\ZZ^d$///, " together with ",
     TEX ///$-e_1-\dots-e_d$///, ".  The maximal cones in the fan
     correspond to the ", TEX ///$d$///, "-element subsets of ", 
     TEX ///$\{0,...,d\}$///, ".",     
     PARA{},
     "The examples illustrate the projective line and projective ",
     TEX ///$3$///, "-space.",
     EXAMPLE lines ///
	  PP1 = projectiveSpace 1;
	  rays PP1
	  max PP1
	  dim PP1
	  ring PP1
	  ideal PP1
	  ///,
     EXAMPLE lines ///
	  PP3 = projectiveSpace 3;
	  rays PP3
	  max PP3
	  dim PP3
	  ring PP3
	  ideal PP3
	  ///,	  
     "We can also create a point as projective ", TEX ///$0$///,
     "-space",
     EXAMPLE lines ///
	  projectiveSpace 0
	  dim projectiveSpace 0
          ///,
     SeeAlso => {
	  normalToricVariety, 
	  weightedProjectiveSpace,
	  (ring,NormalToricVariety), 
	  (ideal,NormalToricVariety)
	  }
     }     

document { 
     Key => {hirzebruchSurface, 
	  (hirzebruchSurface,ZZ)},
     Headline => "Hirzebruch surface",
     Usage => "hirzebruchSurface a",
     Inputs => {"a" => ZZ},
     Outputs => {NormalToricVariety => "a Hirzebruch surface"},    
     "The ", TEX ///$a^{th}$///, " Hirzebruch surface is a
     complete normal toric variety.  It can be defined as the ",
     TEX ///$\PP^1$///, "-bundle over ", TEX ///$X = \PP^1$///,
     " associated to the sheaf ", 
     TEX ///${\mathcal O}_X(0) \oplus  {\mathcal O}_X(a)$///,
     ".  It is also the quotient of affine ", TEX ///$4$///, "-space by
     a rank two torus.",
     EXAMPLE lines ///
	  FF3 = hirzebruchSurface 3;
	  rays FF3
	  max FF3
	  dim FF3
	  ring FF3
	  degrees ring FF3
	  ideal FF3
          ///,
     "When ", TEX ///a = 0///, ", we obtain ", 
     TEX ///$\PP^1 \times \PP^1$///,
     ".",
     EXAMPLE lines ///
	  FF0 = hirzebruchSurface 0;
	  rays FF0
	  max FF0
	  dim FF0
	  ring FF0
	  degrees ring FF0
	  I = ideal FF0
	  decompose I
          ///,
     "The map from the torus-invariant Weil divisors to the class
     group is chosen so that the positive orthant corresponds to 
     the cone of nef line bundles.",
     EXAMPLE lines ///
     	  FF2 = hirzebruchSurface 2;
	  nef FF2     
     	  ///,     
     SeeAlso => {
	  normalToricVariety, 
	  (ring,NormalToricVariety), 
	  nef
	  }
     }     

document { 
     Key => {weightedProjectiveSpace, 
	  (weightedProjectiveSpace,List)},
     Headline => "weighted projective space",
     Usage => "weightedProjectiveSpace q",
     Inputs => {
	  "q" => {" a ", TO(List), " of relatively prime positive integers"}
	  },
     Outputs => {NormalToricVariety => "a weighted projective space"},
     "The weighted projective space associated to a list ", 
     TEX ///$\{q_0,\dots, q_d \}$///, ",  where ", 
     TEX ///$gcd(q_0,\dots, q_d) = 1$///, ", is a normal
     toric variety built from a fan in ", 
     TEX ///$N = \ZZ^{d+1}/\ZZ(q_0,\dots,q_d)$///, 
      ".  The rays are generated by the images of the standard basis
     for ", TEX ///$\ZZ^{d+1}$///, " and the maximal cones in the fan
     correspond to the ", TEX ///$d$///, "-element subsets of ", 
     TEX ///$\{0,...,d\}$///, ".",
     PARA{},
     "The first examples illustrate the defining data for three different
     weighted projective spaces.",     
     EXAMPLE lines ///
	  PP4 = weightedProjectiveSpace {1,1,1,1};
	  rays PP4
	  max PP4
	  dim PP4
	  X = weightedProjectiveSpace {1,2,3};
	  rays X
	  max X
	  dim X
	  Y = weightedProjectiveSpace {1,2,2,3,4};
	  rays Y
	  max Y
	  dim Y
          ///,
     "The grading of the total coordinate ring for weighted projective
     space is determined by the weights.  In particular, the class 
     group is ", TEX ///$\ZZ$///, ".",
     EXAMPLE lines ///
	  classGroup PP4
	  degrees ring PP4
	  classGroup X
	  degrees ring X
	  classGroup Y
	  degrees ring Y
          ///,
     "A weighted projective space is always simplicial but is typically 
     not smooth",
     EXAMPLE lines ///
     	  isSimplicial PP4
	  isSmooth PP4
	  isSimplicial X
	  isSmooth X
	  isSimplicial Y
	  isSmooth Y
	  ///,
     SeeAlso => {
	  projectiveSpace, 
	  (ring,NormalToricVariety), 
	  classGroup,
	  isSimplicial, 
	  isSmooth
	  } 
     }     

document { 
     Key => {(symbol **,NormalToricVariety,NormalToricVariety)},
     Headline => "the cartesian product",
     Usage => "X ** Y",
     Inputs => {"X", "Y" => NormalToricVariety },
     Outputs => {{"the product of ", TT "X", " and ", TT "Y"}},     
     "The cartesian product of two varieties ", TEX ///$X$///, " and
     ", TEX ///$Y$///, ", both defined the same ground field ", 
     TEX ///$k$///, ", is the fiber product ", 
     TEX ///$X \times_k Y$///, ".  For normal toric varieties, the fan
     of the product is given by the cartesian product of each pair of
     cones in the fans of the factors.",
     EXAMPLE lines ///
	  PP2 = projectiveSpace 2;
	  FF2 = hirzebruchSurface 2;
	  X = FF2 ** PP2;
	  #rays X == #rays FF2 + #rays PP2
     	  transpose matrix rays X
     	  transpose matrix rays FF2 ++ transpose matrix rays PP2
	  primaryDecomposition ideal X
	  flatten (primaryDecomposition \ {ideal FF2,ideal PP2})
          ///,
     SeeAlso => {normalToricVariety}
     }  

document { 
     Key => {smoothFanoToricVariety, 
	  (smoothFanoToricVariety,ZZ,ZZ)},
     Headline => "database of smooth Fano toric varieties",
     Usage => "smoothFanoToricVariety(d,i)",
     Inputs => {
	  "d" => ZZ => " dimension of toric variety",
	  "i" => ZZ => " index of toric variety in database",
	  },
     Outputs => {NormalToricVariety => " a smooth Fano toric variety"},
     "This function accesses a database of all smooth Fano toric
     varieties of dimension at most 4.  The enumeration of the toric
     varieties follows ",  
     HREF("http://www.mathematik.uni-tuebingen.de/~batyrev/batyrev.html.en", "Victor V. Batyrev's"), 
     " classification; see ", 
     HREF("http://arxiv.org/abs/math/9801107", TT "arXiv:math/9801107v2"), " and ",
     HREF("http://arxiv.org/abs/math/9911022", TT "arXiv:math/9011022"),   
     ".  There is a unique smooth Fano toric curve, five smooth Fano
     toric surfaces, eighteen smooth Fano toric threefolds, and ", 
     TEX ///$124$///, " smooth Fano toric fourfolds.",
     PARA{},
     "For all ", TEX ///$d$///, ", ", TT "smoothFanoToricVariety(d,0)", "
     yields projective ", TEX ///$d$///, "-space.",
     EXAMPLE lines ///
     	  PP1 = smoothFanoToricVariety(1,0);
     	  rays PP1	  
     	  max PP1
     	  PP4 = smoothFanoToricVariety(4,0);
     	  rays PP4
     	  max PP4
	  ///,
     "The following example was missing from Batyrev's table.",
     EXAMPLE lines ///
	  W = smoothFanoToricVariety(4,123);
	  rays W
	  max W
	  ///,
     SeeAlso => {normalToricVariety}
     }     

document { 
     Key => "Basic properties and invariants",
     "Once a ", TO2(NormalToricVariety, "normal toric variety"), " has
     been defined, one can compute some basic invariants or test for
     some elementary properties.",
     Subnodes => {
	  TO (dim,NormalToricVariety),
	  TO latticeIndex,
     	  TO isDegenerate,
     	  TO isProjective,
	  TO isSimplicial,
	  TO (isSmooth,NormalToricVariety),
	  TO (isWellDefined,NormalToricVariety)
	  }
     }  

document { 
     Key => {(dim, NormalToricVariety)},
     Headline => "the dimension of a normal toric variety",
     Usage => "dim X",
     Inputs => {"X" => NormalToricVariety },
     Outputs => {ZZ => "the dimension of the normal toric variety" },
     "The dimension of a normal toric variety equals the dimension of
     its dense algebraic torus.  In this package, the fan associated
     to a normal ", TEX ///$d$///, "-dimensional toric variety lies in
     the rational vector space ", TEX ///$\QQ^d$///, " with underlying
     lattice ", TEX ///$N = \ZZ^d$///, ".  Hence, the dimension equals
     the number of entries in a minimal nonzero lattice point on a
     ray.",
     PARA{},   
     "The following examples illustrate normal toric varieties of
     various dimensions.",
     EXAMPLE lines ///
     	  dim projectiveSpace 0
	  dim projectiveSpace 5
	  dim hirzebruchSurface 7
	  dim weightedProjectiveSpace {1,2,2,3,4}
	  W = normalToricVariety({{4,-1,0},{0,1,0}},{{0,1}})
	  dim W
	  isDegenerate W
          ///,
     Subnodes => {TO (dim,List,NormalToricVariety)},
     SeeAlso => {normalToricVariety, (rays, NormalToricVariety)}
     }  

doc ///
  Key
	(dim,List,NormalToricVariety)
  Headline
	the dimension of a cone in the fan of a normal toric variety
  Usage
	d = dim(sigma,X)
  Inputs
	sigma:List
	  of integers indexing a subset of (rays X)
	X:NormalToricVariety
  Outputs
	d:ZZ
	  The dimension of the cone in the fan of {\tt X} defined by the rays indexed by {\tt sigma}.
  Description
   Text
   Text
   Example
   Text
   Example
  Caveat 
	It is not checked that {\tt sigma} actually defines a face of the fan of X.
  SeeAlso
///

doc ///
  Key
	latticeIndex
	(latticeIndex,List,NormalToricVariety)
  Headline
	the index in the ambient lattice of a lattice generated by primitive vectors in the fan of a normal toric variety
  Usage
	m = latticeIndex(sigma, X)
  Inputs
	sigma:List
	  of integers indexing a subset of (rays X)
	X:NormalToricVariety
  Outputs
	m:ZZ
	  The index in the ambient lattice of the lattice generated by the rays indexed by {\tt sigma}.
  Description
   Text
   Text
   Example
   Text
   Example
  Caveat
	It is not checked that {\tt sigma} actually defines a face of the fan of X.
  SeeAlso
///

document { 
     Key => {isDegenerate, 
	  (isDegenerate,NormalToricVariety)},
     Headline => "whether a toric variety is degenerate",
     Usage => "isDegenerate X",
     Inputs => {"X" => NormalToricVariety},
     Outputs => {Boolean => {TO2(true,"true"), " if the fan of ", 
	       TT "X", " is contained in a proper subspace of its ambient
	       space and ", TO2(false, "false"), " otherwise" }},
     "A ", TEX ///$d$///, "-dimensional normal toric variety is
     degenerate if its rays do not span ", TEX ///$\QQ^d$///, ".  For
     example, projective spaces and Hirzebruch surfaces are not
     degenerate.",
     EXAMPLE lines ///
	  isDegenerate projectiveSpace 3
	  isDegenerate hirzebruchSurface 7
	  ///,
     "Although one typically works with non-degenerate toric varieties,
     not all normal toric varieties are non-degenerate.",
     EXAMPLE lines ///
	  U = normalToricVariety({{4,-1,0},{0,1,0}},{{0,1}});
	  isDegenerate U
	  ///,
     SeeAlso => {(rays,NormalToricVariety), 
	  (ring, NormalToricVariety)}
     }     

document { 
     Key => {isProjective, (isProjective,NormalToricVariety)},
     Headline => "whether a toric variety is projective",
     Usage => "isProjective X",
     Inputs => {"X" => NormalToricVariety},
     Outputs => {{TO2(true,"true"), " if ", TT "X", " is a projective
     	       variety" }},
     "Insert details.",     
     SeeAlso => {
	  (max, NormalToricVariety)
	  }
     }     

document { 
     Key => {isSimplicial, 
	  (isSimplicial,NormalToricVariety)},
     Headline => "whether a toric variety is simplicial",
     Usage => "isSimplicial X",
     Inputs => {"X" => NormalToricVariety},
     Outputs => {Boolean => {TO2(true,"true"), " if the minimal
	       nonzero lattice points on the rays in each maximal cone
	       in the fan of ", TT "X", " form part of a ", 
	       TO QQ,"-basis and ", TO2(false, "false"), " otherwise" }},
     "A normal toric variety is simplical if every cone in its fan is
     simplicial and a cone is simplicial if its minimal generators are
     linearly independent over ", TEX ///$\QQ$///, ".  In fact, the
     following conditions on a normal toric variety ", TEX ///$X$///,
     " are equivalent:",
     UL{
	  {TEX ///$X$///, " is simplicial;"},
	  {"every Weil divisor on ", TEX ///$X$///, " has a positive
	  integer multiple that is Cartier;"},
	  {TEX ///$X$///, " is ", TEX ///$\QQ$///, "-Cartier;"},
	  {"the Picard group of ", TEX ///$X$///, " has finite index
	  in the class group of ", TEX ///$X$///, ";"},
	  {TEX ///$X$///, " has only finite quotient singularities."},
	  },
     "Projective spaces, weighted projective spaces and Hirzebruch 
     surfaces are simplicial.",
     EXAMPLE lines ///
	  isSimplicial projectiveSpace 4
	  isSimplicial weightedProjectiveSpace {1,2,3}
	  isSimplicial hirzebruchSurface 7
	  ///,
     "However, not all normal toric varieties are simplicial.",
     EXAMPLE lines ///
	  U = normalToricVariety({{4,-1},{0,1}},{{0,1}});
	  isSimplicial U
	  isSmooth U
	  ///,
     EXAMPLE lines ///
	  C = normalToricVariety({{1,0,0},{0,1,0},{0,0,1},{1,1,-1}},{{0,1,2,3}});
	  isSimplicial C
	  ///,
     SeeAlso => {
	  (rays,NormalToricVariety), 
	  (max, NormalToricVariety), 
	  isSmooth}
     }     

document { 
     Key => {(isSmooth,NormalToricVariety)},
     Headline => "whether a toric variety is smooth",
     Usage => "isSmooth X",
     Inputs => {"X" => NormalToricVariety},
     Outputs => {Boolean => {TO2(true,"true"), " if the minimal
	       nonzero lattice points on the rays in each maximal cone
	       in the fan of ", TT "X", " form part of a ", TO ZZ,
	       "-basis and ", TO2(false, "false"), " otherwise"}},
     "A normal toric variety is smooth if every cone in its fan is
     smooth and a cone is smooth if its minimal generators are
     linearly independent over ", TEX ///$\ZZ$///, ".  In fact, the
     following conditions on a normal toric variety ", TEX ///$X$///,
     " are equivalent:",
     UL{
	  {TEX ///$X$///, " is smooth;"},
	  {"every Weil divisor on ", TEX ///$X$///, " is Cartier;"},
	  {"the Picard group of ", TEX ///$X$///, " equals
	  the class group of ", TEX ///$X$///, ";"},
	  {TEX ///$X$///, " has no singularities."},
	  },
     "Projective spaces and Hirzebruch surfaces are smooth.",
     EXAMPLE lines ///
	  isSmooth projectiveSpace 4
	  isSmooth hirzebruchSurface 7
	  ///,
     "However, not all normal toric varieties are smooth.",  
     EXAMPLE lines ///
     	  isSmooth weightedProjectiveSpace {1,2,3}
     	  ///,  
     EXAMPLE lines ///
	  U = normalToricVariety({{4,-1},{0,1}},{{0,1}});
	  isSimplicial U
	  isSmooth U
	  ///,
     EXAMPLE lines ///
	  U' = normalToricVariety({{4,-1},{0,1}},{{0},{1}});
	  isSmooth U'
	  ///,
     SeeAlso => {(rays,NormalToricVariety), 
	  (max, NormalToricVariety), 
	  isSimplicial}
     }     

document { 
     Key => {(isWellDefined,NormalToricVariety)},
     Headline => "whether a toric variety is well defined",
     Usage => "isWellDefined X",
     Inputs => {"X" => NormalToricVariety},
     Outputs => {{TO2(true,"true"), " if the lists of rays and maximal
	       cones associated to ", TT "X", " determine a strongly
	       convex rational polyhedral fan" }},
     "Insert information.",
     SeeAlso => {
	  (NormalToricVariety), 
	  (rays, NormalToricVariety),
	  (max, NormalToricVariety)
	  }
     }     

document { 
     Key => "Working with Cartier and Weil divisors",
     Subnodes => {
	  TO weilDivisors,
	  TO classGroup,
	  TO cartierDivisors,
	  TO picardGroup,
	  TO nef,  
	  }
     }  

document { 
     Key => {weilDivisors, 
	  (weilDivisors, NormalToricVariety)},
     Headline => "the group of torus-invariant Weil divisors",
     Usage => "weilDivisors X",
     Inputs => {"X" => NormalToricVariety },
     Outputs => {Module => "a finitely generated free abelian group" },
     "The group of torus-invariant Weil divisors on a normal toric variety ",
     TEX ///$X$///, " is the free abelian group generated by the prime 
     torus-invariant divisors.  Since the rays in the fan of ", TEX ///$X$///, 
     " are indexed by ", TEX ///0,\dots, n///, ", the group of Weil divisors is
     canonically isomorphic to ", TEX ///$\ZZ^{n+1}$///, ".",
     PARA {},
     "The examples illustrate various possible Weil groups.",
     EXAMPLE lines ///
     	  PP2 = projectiveSpace 2;
	  #rays PP2
	  weilDivisors PP2
     	  ///,
     EXAMPLE lines ///
     	  FF7 = hirzebruchSurface 7;
	  #rays FF7
	  weilDivisors FF7
	  ///,
     EXAMPLE lines ///
	  U = normalToricVariety({{4,-1},{0,1}},{{0,1}});
	  #rays U
	  weilDivisors U
	  ///,
     Subnodes => {TO weilToClass},
     SeeAlso => {classGroup, 
	  cartierDivisors, 
	  cartierToWeil}
     }   

document { 
     Key => {weilToClass, 
	  (weilToClass, NormalToricVariety)},
     Headline => "map from Weil divisors to the class group",
     Usage => "weilDivisors X",
     Inputs => {"X" => NormalToricVariety },
     Outputs => {Matrix => "defining the surjection from the
     	  torus-invariant Weil divisors to the class group" },
     "For a normal toric variety, the class group has a presentation
     defined by the map from the group of torus-characters to group of
     torus-invariant Weil divisors induced by minimal nonzero lattice
     points on the rays of X.  Hence, there is a surjective map from
     the group of torus-invariant Weil divisors to the class group.
     This function returns a matrix representing this map.  Since the
     ordering on the rays of the toric variety determines a basis for
     the group of torus-invariant Weil divisors, this matrix is
     determined by a choice of basis for the class group.",
     PARA{},
     "The examples illustrate various possible Weil groups.",
     EXAMPLE lines ///
     	  PP2 = projectiveSpace 2;
     	  A = weilToClass PP2
	  source A == weilDivisors PP2
	  target A == classGroup PP2
     	  ///,
     EXAMPLE lines ///
     	  X = weightedProjectiveSpace {1,2,2,3,4};
     	  weilToClass X
     	  ///,	  
     EXAMPLE lines ///
     	  FF7 = hirzebruchSurface 7;
	  A' = weilToClass FF7
     	  (source A', target A') == (weilDivisors FF7, classGroup FF7)
	  ///,
     EXAMPLE lines ///
	  U = normalToricVariety({{4,-1},{0,1}},{{0,1}});
	  weilToClass U
	  weilDivisors U
	  classGroup U
	  ///,
     "This matrix also induces the grading on the total coordinate
     ring of toric variety.",
     EXAMPLE lines ///
     	  degrees ring PP2
	  degrees ring X
	  degrees ring FF7
     	  ///,
     "The optional argument ", TO WeilToClass, " for the constructor ",
     TO normalToricVariety, " allows one to specify a basis of the class
     group.",	       
     SeeAlso => {weilDivisors,
	  cartierDivisors, 
	  normalToricVariety,
	  (ring,NormalToricVariety)}

     }   

document { 
     Key => {classGroup, 
	  (classGroup, NormalToricVariety)},
     Headline => "the class group",
     Usage => "classGroup X",
     Inputs => {
	  "X" => NormalToricVariety,
	  "A" => Matrix => {" which defines the map from the torus-invariant 
	  Weil divisors to the class group; this input is optional"}},
     Outputs => {Module => "a finitely generated abelian group" },
     "The class group of a variety is the group of Weil divisors divided by 
     the subgroup of principal divisors.  For a toric variety ", TEX ///$X$///, 
     ", the class group has a presentation defined by the map from the group 
     of torus-characters to group of torus-invariant Weil divisors induced 
     by minimal nonzero lattice points on the rays of ", TEX ///$X$///, ".",
     PARA {},
     "The following examples illustrate various possible class groups.",
     EXAMPLE lines ///
	  classGroup projectiveSpace 2
	  classGroup hirzebruchSurface 7
	  AA3 = normalToricVariety({{1,0,0},{0,1,0},{0,0,1}},{{0,1,2}});
     	  classGroup AA3
	  X = normalToricVariety({{4,-1},{0,1}},{{0,1}});
	  classGroup X
	  C = normalToricVariety({{1,0,0},{0,1,0},{0,0,1},{1,1,-1}},{{0,1,2,3}});
	  classGroup C
          ///,
     PARA {},	  
     "The total coordinate ring of a toric variety is graded by its
     class group.",
     SeeAlso => {(rays,NormalToricVariety), 
	  weilDivisors,
	  (ring, NormalToricVariety), 
	  picardToClass,
	  weilToClass}
     }   

document { 
     Key => {cartierDivisors, 
	  (cartierDivisors, NormalToricVariety)},
     Headline => "the group of torus-invariant Cartier divisors",
     Usage => "cartierDivisors X",
     Inputs => {"X" => NormalToricVariety },
     Outputs => {Module => "a finitely generated abelian group" },
     "The group of torus-invariant Cartier divisors on ", 
     
     TEX ///$X$///, " is the subgroup of all locally principal
     torus-invarient Weil divisors.  On a normal toric variety, the
     group of torus-invariant Cartier divisors can be computed as an
     inverse limit.  More precisely, if ", TEX ///$M$///, " denotes
     the lattice of characters on ", TEX ///$X$///, " and the maximal
     cones in the fan of ", TEX ///$X$///, " are ", 
     TEX ///$s_0,\dots,s_{r-1}$///, " then we have ",
     TEX ///$CDiv(X) = ker( \oplus_{i} M/M(s_i{}) \to{} \oplus_{i<j} M/M(s_i \cap s_j{})$///, 
     ".",
     PARA{},     
     "When ", TEX ///$X$///, " is smooth, every Weil divisor is Cartier.",
     EXAMPLE lines ///
	  PP2 = projectiveSpace 2;
	  Div = weilDivisors PP2
	  Div == cartierDivisors PP2
	  id_Div == cartierToWeil PP2
	  isSmooth PP2
	  ///,
     EXAMPLE lines ///
	  FF1 = hirzebruchSurface 1;
	  cartierDivisors FF1
	  isIsomorphism cartierToWeil FF1
	  isSmooth FF1
          ///,
     "When ", TEX ///$X$///, " is simplicial, every Weil divisor is ",
     TEX ///$\QQ$///, "-Cartier --- every Weil divisor has a positive
     integer multiple that is Cartier.",
     EXAMPLE lines ///
	  U = normalToricVariety({{4,-1},{0,1}},{{0,1}});
	  cartierDivisors U
	  weilDivisors U
	  cartierToWeil U
	  prune cokernel cartierToWeil U
	  isSimplicial U
	  ///,
     EXAMPLE lines ///
	  U' = normalToricVariety({{4,-1},{0,1}},{{0},{1}});
	  cartierDivisors U'
	  weilDivisors U'
	  cartierToWeil U'
	  isSmooth U'
          ///,     
     "In general, the Cartier divisors are only a subgroup of the Weil 
     divisors.",
     EXAMPLE lines ///
	  C = normalToricVariety({{1,0,0},{0,1,0},{0,0,1},{1,1,-1}},{{0,1,2,3}});
	  cartierDivisors C
	  weilDivisors C
	  prune coker cartierToWeil C
	  isSimplicial C
	  ///,
     EXAMPLE lines ///	  
	  X = normalToricVariety({{ -1,-1,-1},{1,-1,-1},{ -1,1,-1},{1,1,-1},{ -1,-1,1},{1,-1,1},{ -1,1,1},{1,1,1}},{{0,2,4,6},{0,1,4,5},{0,1,2,3},{1,3,5,7},{2,3,6,7},{4,5,6,7}});
	  weilDivisors X
	  cartierDivisors X
	  prune cokernel cartierToWeil X
	  isSimplicial X
	  ///,
     Subnodes => {TO cartierToWeil,
	  TO cartierToPicard},
     SeeAlso => {weilDivisors, 
	  cartierToWeil, 
	  picardGroup}
     }   

document { 
     Key => {cartierToWeil, 
	  (cartierToWeil, NormalToricVariety)},
     Headline => "map from Cartier divisors to Weil divisors",
     Usage => "cartierToWeil X",
     Inputs => {"X" => NormalToricVariety },
     Outputs => {Matrix => " the inclusion map from the group of 
	  torus-invariant Cartier divisors to the group of torus-invariant
	  Weil divisors" },
     "The group of torus-invariant Cartier divisors is the
     subgroup of all locally principal torus-invariant Weil divisors.",
     PARA{},	  
     "On a smooth normal toric variety, every Weil divisor is Cartier.",
     EXAMPLE lines ///
	  PP2 = projectiveSpace 2;
	  cartierDivisors PP2
	  cartierToWeil PP2
	  isSmooth PP2
	  ///,
     EXAMPLE lines ///
	  FF1 = hirzebruchSurface 1;
	  cartierDivisors FF1
	  cartierToWeil FF1
	  isSmooth FF1
          ///,
     "On a simplicial normal toric variety, every Weil divisor is ", 
     TEX ///$\QQ$///, "-Cartier --- every Weil divisor has a positive 
     integer multiple that is Cartier.",
     EXAMPLE lines ///
	  U = normalToricVariety({{4,-1},{0,1}},{{0,1}});
	  cartierDivisors U
	  weilDivisors U
	  cartierToWeil U
	  prune cokernel cartierToWeil U
	  isSimplicial U
	  ///,
     EXAMPLE lines ///
	  U' = normalToricVariety({{4,-1},{0,1}},{{0},{1}});
	  cartierDivisors U'
	  weilDivisors U'
	  cartierToWeil U'
	  isSmooth U'
          ///,     
     "In general, the Cartier divisors are only a subgroup of the Weil 
     divisors.",
     EXAMPLE lines ///
	  C = normalToricVariety({{1,0,0},{0,1,0},{0,0,1},{1,1,-1}},{{0,1,2,3}});
	  cartierDivisors C
	  weilDivisors C
	  cartierToWeil C
	  prune coker cartierToWeil C
	  isSimplicial C
	  ///,
     EXAMPLE lines ///
	  X = normalToricVariety({{ -1,-1,-1},{1,-1,-1},{ -1,1,-1},{1,1,-1},{ -1,-1,1},{1,-1,1},{ -1,1,1},{1,1,1}},{{0,2,4,6},{0,1,4,5},{0,1,2,3},{1,3,5,7},{2,3,6,7},{4,5,6,7}});
	  weilDivisors X
	  cartierDivisors X
	  cartierToWeil X
	  prune cokernel cartierToWeil X
	  isSimplicial X
	  ///,
     SeeAlso => {weilDivisors, 
	  cartierDivisors}
     }   

document { 
     Key => {cartierToPicard, 
	  (cartierToPicard, NormalToricVariety)},
     Headline => "map from Cartier divisors to the Picard group",
     Usage => "cartierToPicard X",
     Inputs => {"X" => NormalToricVariety },
     Outputs => {Matrix => " the surjective map from the group of 
	  torus-invariant Cartier divisors to the Picard group" },
     "The Picard group of a variety is the group of Cartier divisors
     divided by the subgroup of principal divisors.  For a normal
     toric variety , the Picard group has a presentation defined by
     the map from the group of torus-characters to the group of
     torus-invariant Cartier divisors.  Hence, there is a surjective
     map from the group of torus-invariant Cartier divisors to the
     Picard group.  This function returns a matrix representing this
     map.",     	  
     PARA{},	  
     "On a smooth normal toric variety, the map from the Cartier
     divisors to the Picard group is the same as the map from the Weil
     divisors to the class group.",
     EXAMPLE lines ///
	  PP2 = projectiveSpace 2;
	  eta = cartierToPicard PP2
     	  eta == weilToClass PP2
	  ///,
     EXAMPLE lines ///
	  FF1 = hirzebruchSurface 1;
	  xi = cartierToPicard FF1
     	  xi == weilToClass FF1
          ///,
     "In general, there is a commutative diagram relating the map from
     the Cartier divisors to the Picard group and the map from the
     Weil divisors to the class group.",
     EXAMPLE lines ///
	  C = normalToricVariety({{1,0,0},{0,1,0},{0,0,1},{1,1,-1}},{{0,1,2,3}});
	  cartierToPicard C
	  picardGroup C	  
	  weilToClass C
	  cartierToWeil C
	  picardToClass C
	  weilToClass C * cartierToWeil C == picardToClass C * cartierToPicard C
	  ///,
     EXAMPLE lines ///
	  X = normalToricVariety({{ -1,-1,-1},{1,-1,-1},{-1,1,-1},{1,1,-1},{-1,-1,1},{1,-1,1},{ -1,1,1},{1,1,1}},{{0,2,4,6},{0,1,4,5},{0,1,2,3},{1,3,5,7},{2,3,6,7},{4,5,6,7}});
	  cartierToPicard X
	  picardGroup X
	  weilToClass X
	  cartierToWeil X
	  picardToClass X
	  weilToClass X * cartierToWeil X == picardToClass X * cartierToPicard X
	  ///,
     SeeAlso => {cartierDivisors,
	  picardGroup,
	  weilToClass}
     }   

document { 
     Key => {picardGroup, 
	  (picardGroup,NormalToricVariety)},
     Headline => "the Picard group",
     Usage => "picardGroup X",
     Inputs => {"X" => NormalToricVariety},
     Outputs => {Module => " a finitely generated abelian group"},
     "The Picard group of a variety is the group of Cartier divisors
     divided by the subgroup of principal divisors.  For a normal toric
     variety ", TEX ///$X$///, ", the Picard group has a presentation
     defined by the map from the group of torus-characters to the
     group of torus-invariant Cartier divisors.",
     PARA {},
     "When ", TEX ///$X$///, " is smooth, the Picard group is
     isomorphic to the class group.",
     EXAMPLE lines ///
	  PP3 = projectiveSpace 3;
	  picardGroup PP3
	  classGroup PP3
	  ///,
     EXAMPLE lines ///
	  FF7 = hirzebruchSurface 7;
	  picardGroup FF7 == classGroup FF7
	  ///,
     "For an affine toric variety, the Picard group is trivial.",
     EXAMPLE lines ///
	  U = normalToricVariety({{4,-1},{0,1}},{{0,1}});
	  picardGroup U
	  classGroup U
	  ///,
     EXAMPLE lines ///
	  U' = normalToricVariety({{4,-1},{0,1}},{{0},{1}});
	  picardGroup U'
	  classGroup U'
	  ///,
     "If the fan of ", TEX ///$X$///, " contains a cone of dimension
     ", TEX ///$dim(X)$///, " then the Picard group is free.",
     EXAMPLE lines ///
	  C = normalToricVariety({{1,0,0},{0,1,0},{0,0,1},{1,1,-1}},{{0,1,2,3}});
	  picardGroup C
	  classGroup C
	  ///,
     EXAMPLE lines ///
	  X = normalToricVariety({{ -1,-1,-1},{1,-1,-1},{ -1,1,-1},{1,1,-1},{ -1,-1,1},{1,-1,1},{ -1,1,1},{1,1,1}},{{0,2,4,6},{0,1,4,5},{0,1,2,3},{1,3,5,7},{2,3,6,7},{4,5,6,7}});
	  picardGroup X
	  classGroup X
	  ///,
     Subnodes => {TO picardToClass},
     SeeAlso => {classGroup, 
	  cartierDivisors, 
	  weilDivisors},
     }     

document { 
     Key => {picardToClass, 
	  (picardToClass,NormalToricVariety)},
     Headline => "map from Picard group to class group",
     Usage => "picardToClass X",
     Inputs => {"X" => NormalToricVariety},
     Outputs => {Matrix => " the inclusion map from the Picard group to the
	   class group"},
     "The Picard group of a normal toric variety is a subgroup of the
     class group.",
     PARA{},
     "On a smooth normal toric variety, the Picard group is isomorphic
     to the class group, so the inclusion map is the identity.",
     EXAMPLE lines ///
	  PP3 = projectiveSpace 3;
	  picardGroup PP3
	  classGroup PP3
	  picardToClass PP3
	  ///,
     EXAMPLE lines ///
	  FF7 = hirzebruchSurface 7;
	  picardGroup FF7 == classGroup FF7
	  picardToClass FF7
	  ///,
     "For weighted projective space, the inclusion corresponds to ", 
     TEX ///$l \ZZ$///, " in ", TEX ///$\ZZ$///, ", where ", 
     TEX ///$l = lcm(q_0,\dots, q_d {})$///, ".",
     EXAMPLE lines ///
	  X = weightedProjectiveSpace {1,2,3};
	  picardGroup X
	  classGroup X
	  picardToClass X
	  ///,
     EXAMPLE lines ///
	  Y = weightedProjectiveSpace {1,2,2,3,4};
	  picardGroup Y
	  classGroup Y
	  picardToClass Y
	  ///,
     "The following examples illustrate some other possibilities.",
     EXAMPLE lines ///
	  C = normalToricVariety({{1,0,0},{0,1,0},{0,0,1},{1,1,-1}},{{0,1,2,3}});
	  picardGroup C
	  classGroup C
	  picardToClass C
	  ///,
     EXAMPLE lines ///
	  X = normalToricVariety({{ -1,-1,-1},{1,-1,-1},{ -1,1,-1},{1,1,-1},{ -1,-1,1},{1,-1,1},{ -1,1,1},{1,1,1}},{{0,2,4,6},{0,1,4,5},{0,1,2,3},{1,3,5,7},{2,3,6,7},{4,5,6,7}});
	  picardGroup X
	  classGroup X
	  picardToClass X
	  prune cokernel picardToClass X
	  ///,
     SeeAlso => {
	  picardGroup, 
	  classGroup}
     }     

document { 
     Key => {nef, (nef,NormalToricVariety)},
     Headline => "generators for the Nef cone",
     Usage => "L = nef X",
     Inputs => {"X" => NormalToricVariety},     
     Outputs => {"L" => List => {" generators for the Nef cone"}},
     "The positive hull (a.k.a. convex cone) of the entries in ", 
     TT "L", ", each of which is a list of integers, equals the
     cone of numerically effective divisors up to linear equivalence
     in the class group.",
     PARA{},
     "For projective space, the Nef cone corresponds to the
     nonnegative integers.",
     EXAMPLE lines ///
	  PP3 = projectiveSpace 3;
	  nef PP3
          ///,
     "For a Hirzebruch surface, the grading of the total coordinate
     ring is chosen so that the positive quadrant corresponds to the
     nef line bundles.",
     EXAMPLE lines ///
	  FF3 = hirzebruchSurface 3;
	  nef FF3
          ///,
     "As projective 2-space blown up at three points demonstrates, the
     Nef cone is not always an orthant.",
     EXAMPLE lines ///
	  B = normalToricVariety({{1,0},{0,1},{-1,1},{-1,0},{0,-1},{1,-1}},{{0,1},{1,2},{2,3},{3,4},{4,5},{0,5}});
	  nef B
          ///,               
     "If interior of the Nef cone is empty then the toric variety is
     not projective.  In the following example, the Nef cone lies a
     two dimensional subspace of the Picard group, so this complete toric
     variety is not projective.",     
     EXAMPLE lines ///
	  Rho = {{1,0,0},{0,1,0},{0,0,1},{0,-1,-1},{-1,0,-1},{-1,-1,0},{-1,-1,-1}};
	  Sigma = {{0,1,2},{0,1,3},{1,2,4},{0,2,5},{1,3,4},{0,3,5},{2,4,5},{3,4,6},{3,5,6},{4,5,6}};
	  X = normalToricVariety(Rho,Sigma);
	  nef X
	  ///,     
     SeeAlso => {classGroup}
     }     

document { 
     Key => "Cox ring and coherent sheaves",
     Subnodes => {
	  TO (ring,NormalToricVariety),
	  TO (ideal,NormalToricVariety),
	  TO (sheaf,NormalToricVariety,Ring),	  	  
	  TO (sheaf,NormalToricVariety,Module),	  
	  TO (cohomology,ZZ,NormalToricVariety,CoherentSheaf)
	  }
     }  

document { 
     Key => {(ring, NormalToricVariety)},
     Headline => "the total coordinate ring (a.k.a. Cox ring)",
     Usage => "ring X",
     Inputs => {
	  "X" => NormalToricVariety,
	  },
     Outputs => {PolynomialRing => "the total coordinate ring"},
     "The total coordinate ring (a.k.a. the Cox ring) of a normal
     toric variety is a polynomial ring in which the variables
     correspond to the rays in the fan.  It is graded by the ",
     TO2(classGroup,"class group"), ".",
     PARA{},
     "The total coordinate ring for projective space is the standard graded 
     polynomial ring.",
     EXAMPLE lines ///
	  PP3 = projectiveSpace 3;
	  S = ring PP3;
	  isPolynomialRing S
	  gens S
	  degrees S
	  numgens S == #rays PP3
	  coefficientRing S
          ///,     
     "For a product of projective spaces, the total coordinate ring has a 
     bigrading.",
     EXAMPLE lines ///
	  X = projectiveSpace(2) ** projectiveSpace(3);
	  gens ring X
	  degrees ring X
	  ///,
     "A Hirzebruch surface also has a ", TT "ZZ", SUP TT "2", "-grading.",
     EXAMPLE lines ///
	  FF3 = hirzebruchSurface 3;
     	  gens ring FF3
	  degrees ring FF3
          ///,
     Caveat => "The total coordinate ring is not (yet?) implemented when
     the toric variety is degenerate or the class group has torsion.",  
     SeeAlso => {rays, classGroup, (ideal, NormalToricVariety), 
	  (sheaf,NormalToricVariety,Module)}
     }   

document { 
     Key => {(ideal, NormalToricVariety), (monomialIdeal, NormalToricVariety)},
     Headline => "the irrelevant ideal",
     Usage => "ideal X",
     Inputs => {"X" => NormalToricVariety},
     Outputs => {Ideal => {"in the total coordinate ring of
     	       ", TT "X", "."}},	       	       
     "The irrelevant ideal is a reduced monomial ideal in the total
     coordinate ring which encodes the combinatorics of the fan.  For
     each maximal cone in the fan, it has a minimal generator, the
     product of the variables not indexed by elements of the list
     corresponding to the maximal cone.",
     PARA{},
     "For projective space, the irrelevant ideal is generated by the
     variables.",
     EXAMPLE lines ///
	  PP4 = projectiveSpace 4;
	  I = ideal PP4
	  isMonomialIdeal I
          ///,
     "For an affine toric variety, the irrelevant ideal is the unit ideal.",
     EXAMPLE lines ///
	  C = normalToricVariety({{1,0,0},{0,1,0},{0,0,1},{1,1,-1}},{{0,1,2,3}});
	  ideal C
	  ///,	  
     "The irrelevant ideal for a product of toric varieties is
     intersection of the irrelevant ideal of the factors.",
     EXAMPLE lines ///
	  X = projectiveSpace(3) ** projectiveSpace(4);
	  S = ring X;
	  I = ideal X
	  primaryDecomposition I
	  dual monomialIdeal I
          ///,
     "For a complete simplicial toric variety, the irrelevant ideal is
     the Alexander dual of the Stanley-Reisner ideal of the fan.",
     EXAMPLE lines ///
	  B = normalToricVariety({{1,0},{0,1},{ -1,1},{ -1,0},{0,-1}},{{0,1},{1,2},{2,3},{3,4},{0,4}});
	  max B
	  dual monomialIdeal B
	  ///,
     "Since the irrelevent ideal is a monomial ideal, the command ",
     TT "monomialIdeal", " also produces the irrelevant ideal.",
     EXAMPLE lines ///
	  code(monomialIdeal, NormalToricVariety)
	  ///,
     SeeAlso => {(max,NormalToricVariety), (ring,NormalToricVariety)}
     }     

document { 
     Key => {(sheaf,NormalToricVariety,Module)},
     Headline => "make a coherent sheaf",
     Usage => "sheaf(X,M)",
     Inputs => {
	  "X" => NormalToricVariety,
	  "M" => {"a graded ", TO2(Module,"module"), " over the total 
	       coordinate ring of ", TT "X"}
	       },
     Outputs => {CoherentSheaf => {"the coherent sheaf on ", TT "X", 
	       " corresponding to ", TT "M"}},
     "Let ", TT "I", " denote the irrelevent ideal of ", TT "X", ".  The 
     category of coherent ", TT "OO", TT SUB "X", "-modules is equivalent 
     to the category of graded modules over the total coordinate ring of ", 
     TT "X", " divided by the full subcategory of ", TT "I", "-torsion
     modules.  In particular, each finitely generated module over the total 
     coordinate ring of ", TT "X", " corresponds to coherent sheaf on ", 
     TT "X", " and every coherent sheaf arises in this manner.",
     PARA {},
     "Free modules correspond to reflexive sheaves.",
     EXAMPLE lines ///
	  PP3 = projectiveSpace 3;
	  sheaf(PP3, (ring PP3)^{{1},{2},{3}})
          ///,
     EXAMPLE lines ///
	  FF7 = hirzebruchSurface 7;
     	  sheaf(FF7, (ring FF7)^{{1,0},{0,1}})
	  ///,
     SeeAlso => {(ring,NormalToricVariety),(ideal,NormalToricVariety),
	  (sheaf,NormalToricVariety)}
     }     

document { 
     Key => {(sheaf,NormalToricVariety,Ring), (symbol _,OO,NormalToricVariety),
	  (sheaf,NormalToricVariety)},
     Headline => "make a coherent sheaf of rings",
     Usage => "sheaf(X,S)",
     Inputs => {
	  "X" => NormalToricVariety,
	  "S" => {"the total coordinate ring of ", TT "X"}
	       },
     Outputs => {SheafOfRings => {"the structure sheaf on ", TT "X"}},
     "Let ", TT "I", " denote the irrelevent ideal of ", TT "X", ".  The 
     category of coherent ", TT "OO", TT SUB "X", "-modules is equivalent 
     to the category of graded modules over the total coordinate ring of ", 
     TT "X", " divided by the full subcategory of ", TT "I", "-torsion
     modules.  In particular, the total coordinate ring corresponds to 
     the structure sheaf.",
     EXAMPLE lines ///
	  PP3 = projectiveSpace 3;
	  F = sheaf(PP3, ring PP3)
	  G = sheaf PP3
	  F === G
	  H = OO_PP3
	  F === H
          ///,
     EXAMPLE lines ///
	  FF7 = hirzebruchSurface 7;
	  sheaf FF7
	  ///,
     SeeAlso => {(ring,NormalToricVariety),(sheaf,NormalToricVariety,Module)}
     }    

document { 
     Key => {(cohomology,ZZ,NormalToricVariety,CoherentSheaf),
	  (cohomology,ZZ,NormalToricVariety,SheafOfRings)},
     Headline => "cohomology of a coherent sheaf",
     Usage => "HH^i(X,F)",
     Inputs => {"i" => ZZ,
	  "X" => NormalToricVariety,
	  "F" => CoherentSheaf => {" on ", TT "X"}
	  },
     Outputs => {{"the ", TT "i", "-th cohomology group of ", TT "F"}},
     "The cohomology functor ", TT "HH", TT SUP "i", TT "(X,-)", " from the
     category of sheaves of abelian groups to the category of abelian 
     groups is the right derived functor of the global sections functor.",
     PARA {},
     "As a simple example, we compute the dimensions of the cohomology 
     groups for some line bundles on the projective plane.",
     EXAMPLE {
	  "PP2 = projectiveSpace 2;",
	  "HH^0(PP2,OO_PP2(1))",
	  "apply(10, i -> HH^2(PP2,OO_PP2(-i)))",
	  ///loadPackage "BoijSoederberg";///,
	  ///loadPackage "BGG";///,
	  "cohomologyTable (CoherentSheaf, NormalToricVariety, ZZ,ZZ) := CohomologyTally => (F,X,lo,hi) -> (
     	       new CohomologyTally from select(flatten apply(1+dim X, 
	       		 j -> apply(toList(lo-j..hi), 
		    	      i -> {(j,i),rank HH^j(X,F(i))})), p -> p#1 != 0));",	  
          "cohomologyTable(OO_PP2^1,PP2,-10,10)",
     	  },
     "Compare this table with the first example in ", TO "BGG::cohomologyTable", 
     ".",
     PARA{},
     "For a second example, we compute the dimensions of the cohomology
     groups for some line bundles on a Hirzebruch surface",
     EXAMPLE {
	  "cohomologyTable (ZZ, CoherentSheaf, List, List) := (k,F,lo,hi) -> (
     	       new CohomologyTally from select(flatten apply(toList(lo#0..hi#0),
	       		 j -> apply(toList(lo#1..hi#1), 
		    	      i -> {(j,i-j), rank HH^k(variety F, F(i,j))})), 
	  	    p -> p#1 != 0));",
	  "FF2 = hirzebruchSurface 2;",
	  "cohomologyTable(0,OO_FF2^1,{ -7,-7},{7,7})",
	  "cohomologyTable(1,OO_FF2^1,{ -7,-7},{7,7})",
	  "cohomologyTable(2,OO_FF2^1,{ -7,-7},{7,7})",
      	  },
     PARA{},     
     "When ", TT "F", " is free, the algorithm based on Diane
     Maclagan, Gregory G. Smith, ",
     HREF("http://arxiv.org/abs/math.AC/0305214", "Multigraded
     Castelnuovo-Mumford regularity"), ", ", EM "J. Reine
     Angew. Math. ", BOLD "571", " (2004), 179-212.  The general case
     uses the methods described in David Eisenbud, Mircea Mustaţǎ,
     Mike Stillman, ", HREF("http://arxiv.org/abs/math.AG/0001159",
     "Cohomology on toric varieties and local cohomology with monomial
     supports"), ", ", EM "J. Symbolic Comput. ", BOLD "29", " (2000),
     583-600.",     
     SeeAlso => {(sheaf,NormalToricVariety,Module),
	  (sheaf,NormalToricVariety,Ring)}
     }     

document { 
     Key => "Resolution of singularities",
     Subnodes => {
	  TO (makeSimplicial,NormalToricVariety),
	  }
     }  

document { 
     Key => {makeSimplicial, (makeSimplicial,NormalToricVariety)},
     Headline => "???",
     Usage => "makeSimplical X",
     Inputs => {"X" => NormalToricVariety},
     Outputs => {NormalToricVariety},
     SeeAlso => {
	  NormalToricVariety, 
	  }
     }     

 
---------------------------------------------------------------------------
-- TEST
---------------------------------------------------------------------------

TEST ///
PP4 = projectiveSpace 4;
assert(rays PP4 == {{-1,-1,-1,-1},{1,0,0,0},{0,1,0,0},{0,0,1,0},{0,0,0,1}})
assert(max PP4 == {{0,1,2,3},{0,1,2,4},{0,1,3,4},{0,2,3,4},{1,2,3,4}})
assert(dim PP4 == 4)
assert(isSimplicial PP4 == true)
assert(isSmooth PP4 == true)
assert(isDegenerate PP4 == false)
assert(cartierDivisors PP4 == ZZ^5)
assert(weilDivisors PP4 == ZZ^5)
assert(cartierToWeil PP4 == id_(ZZ^5))
assert(classGroup PP4 == ZZ^1)
assert(degrees ring PP4 == {{1},{1},{1},{1},{1}})
assert(picardGroup PP4 == ZZ^1)
assert(picardToClass PP4 == id_(ZZ^1))
assert(ideal PP4 == ideal gens ring PP4)
assert(nef PP4 == {{1}})
assert(apply(6, i -> rank HH^0(PP4,OO_PP4(i))) == apply(6, i -> binomial(4+i,i)))
F = sheaf_PP4 truncate(2, (ring PP4)^1);
assert(apply(6, i -> rank HH^0(PP4,F(i))) == apply(6, i -> binomial(4+i,i)))
///

TEST ///
PP0 = projectiveSpace 0;
assert(rays PP0 == {{}})
assert(max PP0 == {{}})
assert(dim PP0 == 0)
assert(isSimplicial PP0 == true)
assert(isSmooth PP0 == true)
assert(isDegenerate PP0 == false)
assert(cartierDivisors PP0 == ZZ^1)
assert(weilDivisors PP0 == ZZ^1)
assert(cartierToWeil PP0 == id_(ZZ^1))
assert(classGroup PP0 == ZZ^1)
assert(degrees ring PP0 == {{1}})
assert(picardGroup PP0 == ZZ^1)
assert(picardToClass PP0 == id_(ZZ^1))
assert(ideal PP0 == ideal gens ring PP0)
assert(nef PP0 == {{1}})
assert(apply(6, i -> rank HH^0(PP0,OO_PP0(i))) == apply(6, i -> binomial(0+i,i)))
///

TEST ///
FF2 = hirzebruchSurface 2;
assert(rays FF2 == {{1,0},{0,1},{-1,2},{0,-1}})
assert(max FF2 == {{0,1},{1,2},{2,3},{0,3}})	  
assert(dim FF2 == 2)	  
assert(degrees ring FF2 == {{1,0},{-2,1},{1,0},{0,1}})
assert(isSimplicial FF2 == true)	  
assert(isSmooth FF2 == true)
assert(isDegenerate FF2 == false)
assert(cartierDivisors FF2 == ZZ^4)
assert(weilDivisors FF2 == ZZ^4)
assert(cartierToWeil FF2 == id_(ZZ^4))
assert(classGroup FF2 == ZZ^2)
assert(picardGroup FF2 == ZZ^2)
assert(picardToClass FF2 == id_(ZZ^2))
assert(ideal FF2 == intersect(ideal (gens ring FF2)_{0,2}, ideal (gens ring FF2)_{1,3}))
assert(nef FF2 == {{1,0},{0,1}})
assert(apply(6, i -> rank HH^0(FF2,OO_FF2(0,i))) == apply(6, i -> rank source basis({0,i},ring FF2)))	  
///

TEST ///
X = weightedProjectiveSpace {1,2,3};
assert(rays X == {{-2,3},{1,0},{0,-1}})
assert(max X == {{0,1},{0,2},{1,2}})
assert(dim X == 2)	  
assert(degrees ring X == {{1},{2},{3}})
assert(isSimplicial X == true)	  
assert(isSmooth X == false)
assert(isDegenerate X == false)
assert(cartierDivisors X == ZZ^3)
assert(weilDivisors X == ZZ^3)
assert(cartierToWeil X != id_(ZZ^4))
assert(classGroup X == ZZ^1)
assert(picardGroup X == ZZ^1)
assert(abs first first entries picardToClass X == lcm {1,2,3})
assert(ideal X == ideal gens ring X)
assert(nef X == {{1}})
assert(apply(6, i -> rank HH^0(X,OO_X(i))) == apply(6, i -> rank source basis({i},ring X)))     	  
///

TEST ///
U = normalToricVariety({{4,-1},{0,1}},{{0,1}});
assert(rays U == {{4,-1},{0,1}})
assert(max U == {{0,1}})
assert(dim U == 2)	  
assert(isSimplicial U == true)	  
assert(isSmooth U == false)
assert(isDegenerate U == false)
assert(cartierDivisors U == ZZ^2)
assert(weilDivisors U == ZZ^2)
assert(cartierToWeil U != id_(ZZ^2))
assert(classGroup U == cokernel matrix{{4}})
assert(picardGroup U == 0)
assert(picardToClass U == 0)
///

TEST ///
U' = normalToricVariety({{4,-1},{0,1}},{{0},{1}});
assert(rays U' == {{4,-1},{0,1}})
assert(max U' == {{0},{1}})
assert(dim U' == 2)	  
assert(isSimplicial U' == true)	  
assert(isSmooth U' == true)
assert(isDegenerate U' == false)
assert(cartierDivisors U' == ZZ^2)
assert(weilDivisors U' == ZZ^2)
assert(cartierToWeil U' == id_(ZZ^2))
assert(classGroup U' == cokernel matrix {{4}})
assert(picardGroup U' == cokernel matrix {{4}})
assert(matrix picardToClass U' == id_(ZZ^1))
///

TEST ///
Q = normalToricVariety({{-1,-1,-1},{1,-1,-1},{-1,1,-1},{1,1,-1},{-1,-1,1},{1,-1,1},{-1,1,1},{1,1,1}},{{0,2,4,6},{0,1,4,5},{0,1,2,3},{1,3,5,7},{2,3,6,7},{4,5,6,7}});
assert(rays Q == {{-1,-1,-1},{1,-1,-1},{-1,1,-1},{1,1,-1},{-1,-1,1},{1,-1,1},{-1,1,1},{1,1,1}})
assert(max Q == {{0,2,4,6},{0,1,4,5},{0,1,2,3},{1,3,5,7},{2,3,6,7},{4,5,6,7}})
assert(dim Q == 3)	  
assert(isSimplicial Q == false)	  
assert(isSmooth Q == false)
assert(isDegenerate Q == false)
assert(cartierDivisors Q == ZZ^4)
assert(weilDivisors Q == ZZ^8)
assert(classGroup Q == cokernel transpose matrix{{2,0,0,0,0,0,0},{0,2,0,0,0,0,0}})
assert(picardGroup Q == ZZ^1)
///

end     

---------------------------------------------------------------------------
-- SCRATCH SPACE
---------------------------------------------------------------------------
uninstallPackage "NormalToricVarieties"
restart
installPackage "NormalToricVarieties"
check NormalToricVarieties





