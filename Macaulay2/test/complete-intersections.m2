-- take from Avramov-Grayson chapter.

changeRing = H -> (
   S := ring H;
   K := coefficientRing S;
   degs := select(degrees source vars S,
        d -> 0 != first d);
   R := K[X_1 .. X_#degs, Degrees => degs,
        Repair => S.Repair, Adjust => S.Adjust];
   phi := map(R,S,join(gens R,(numgens S - numgens R):0));
   prune (phi ** H));
Ext(Module,Ring) := (M,k) -> (
   B := ring M;
   if ideal k != ideal vars B
   then error "expected the residue field of the module";
   changeRing Ext(M,coker vars B));
T = ZZ[t,u,Inverses=>true];
poincareSeries2 = M -> (
   B := ring M;
   k := B/ideal vars B;
   H := Ext(M,k);
   S := ring H;
   T' := degreesRing ring H;
   substitute(hilbertSeries H, {T'_0=>t^-1,T'_1=>u^-1} ));
poincareSeries1 = M -> (
   substitute(poincareSeries2 M, {u=>1_T})
   );
K = ZZ/103;
A = K[x,y,z];
I = trim ideal(x^3,y^4,z^5)
B = A/I;
f = random (B^3, B^{-2,-3})
M = cokernel f;
k = B/(x,y,z);
H = Ext(M,k);
S = ring H;
g = poincareSeries1 M
inv = map(T,T,{t^-1,u^-1})
expansion = (n,g) -> (inv value numerator g + t^-n)//(inv value denominator g)
r = expansion(20,poincareSeries1 M)
m = 7
rks1 = take (flatten entries last coefficients r, m)
psi = map(K,B)
rks2 = apply(m, i -> rank (psi ** Ext^i(M,coker vars B)))
assert( rks1 == rks2 )
-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/test complete-intersections.out"
-- End:
