-- From: Neil Epstein <epstein@math.uchicago.edu>
-- Subject: bug fix for hom.m2
-- To: Macaulay2@math.uiuc.edu
-- Date: Wed, 10 Apr 2002 17:07:20 -0500 (CDT)
-- 
-- Hi.
-- 
-- I discovered recently that there was a bug in my program "hom.m2".  In
-- particular, the homEvaluation functor malfunctioned in certain cases
-- where I was checking some maximal Cohen-Macaulay modules to see
-- whether they were of Gorenstein dimension zero.  After much
-- frustration, I figured out that the functions I defined do not mesh
-- well with the "prune" function in the M2 distribution.  So I made a
-- function "prePrune", which is nothing but a alteration of the existing
-- "prune" function so that it doesn't give special treatment to
-- homogeneous modules over affine rings.
-- 
-- I've done further testing, and I think that "hom.m2" is now relatively
-- bug-free -- at least for the purposes I was putting it to.  So, here
-- it is:

--- begin hom.m2 ---

Hom(Module,Module) := Module => (M,N) -> (
     -- This is almost the original code for Hom, but with "trim" 
     -- performed only if it leaves the ambient free module alone,
     -- since I'm not sure if my new "Hom" routines will work
     -- with trimmed Hom modules.
     m := presentation M;
     mdual := transpose m;
     n := presentation N;
     h1 := modulo(mdual ** target n, target mdual ** n);
     MN := conditionalTrim subquotient(h1,source mdual ** n);
     MN.Hom = {M,N,source mdual,target n};
     MN);

conditionalTrim = method();

conditionalTrim(Module) := Module => (M) -> (
     if not M#?trim then M.cache.trim = trim M;
     if ambient M.cache.trim == ambient M then M.cache.trim else M
     );

prePrune = method();

prePrune(Module) := Module => M -> ( -- like "prune", but less destructive
     if M.?pruningMap then M
     else if M.?prePruningMap then M
     else if M.?prePrune then M.prePrune
     else M.prePrune = (
	  if isFreeModule M then (
	       M.prePruningMap = id_M;
	       M)
	  else (
	       N = cokernel gens gb presentation M;
	       N.prePruningMap = map(M,N,id_(cover M));
	       N)
	  )
     );

prePrune(Matrix) := Matrix => (m) -> (
     M := source m;
     if not M.?prePruningMap then m = m * (prePrune M).prePruningMap;
     N := target m;
     if not N.?prePruningMap then m = (prePrune N).prePruningMap^-1 * m;
     m)

-- The following commented-out functions are the versions before I
-- decided to make "Hom(Matrix,Matrix)" my basic function.

--Hom(Matrix,Module) := Matrix => (f,N) -> (
--     if isFreeModule source f and isFreeModule target f
--     then transpose f ** N
--     else (
--         fp := prePrune f;
--         L := source f;
--         M := target f;
--         fpl := (fp * (coverMap source fp)) // (coverMap target fp);
--         inducedMap(Hom(M,N), Hom(L,N), transpose fpl ** cover N,
--  	        Verify => true)));

--Hom(Module,Matrix) := Matrix => (L,g) -> (
--     if isFreeModule L then dual L ** g
--     else (
--          gp := prePrune g;
--          M := source g;
--          N := target g;
--          gpl := (gp * (coverMap source gp)) // (coverMap target gp);
--          inducedMap(Hom(L,N),Hom(L,M), (dual cover L) ** gpl,
--	         Verify => true));

Hom(Matrix,Matrix) := Matrix => (f,g) -> (
     if isFreeModule source f and isFreeModule target f
     then transpose f ** g
     else (
  	  fp := prePrune f;
	  K := source f; L := target f;
	  fpl := (fp * (coverMap source fp)) // (coverMap target fp);
	  gp := prePrune g;
	  M := source g; N := target g;
	  gpl := (gp * (coverMap source gp)) // (coverMap target gp);
	  inducedMap(Hom(K,N),Hom(L,M), transpose fpl ** gpl,
	       Verify => true)));

Hom(Matrix,Module) := Matrix => (f,N) -> Hom(f,id_N);

Hom(Matrix,Ring) := Matrix => (f,R) -> (
     if ring f =!= R then error "expected matrix to have the given ring";
     Hom(f,R^1));

Hom(Module,Matrix) := Matrix => (L,g) -> Hom(L,id_g);

homomorphism Matrix := Matrix => (f) -> (
     -- This is almost the original code for homomorphism, but 
     -- with one change at the end, as marked.  I think I
     -- may have fixed a bug here.
     if not isFreeModule(source f) or
     numgens source f =!= 1 or
     not (target f).?Hom
     then error "homomorphism may only be determined for maps R --> Hom(M,N)";
     MN := (target f).Hom;
     M := MN#0;
     Mp := prePrune M;  -- added line
     N := MN#1;
     Np := prePrune N;  -- added line
     M0 := MN#2;
     N0 := MN#3;
     deg := (degrees source f)#0;
     -- My final two lines replace the original ending line:
     -- map(N,M,adjoint1(super f, M0, N0),Degree=>deg).  I
     -- needed to make sure the resulting map would be well-
     -- defined, and I wasn't sure the existing code would do that;
     a := map(Np,Mp,adjoint1(super f, M0, N0),Degree=>deg);
     Np.prePruningMap * a * Mp.prePruningMap^-1);

homElement = method();
-- The reverse of "homomorphism".  It takes as input a homomorphism
-- from M to N, and returns as output an 'element' of Hom(M,N);

homElement(Matrix) := Matrix => (f) -> (
     deg := degree f;
     fp := prePrune f;
     H := Hom(source f, target f);
     j := super id_H;
     Mp := source fp; m := coverMap Mp; M0 := source m;
     Np := target fp; n := coverMap Np; N0 := source n;
     fpl := (fp * m) // n;
     assert (fp*m - n*fpl == 0);
     R := ring f;
     F := R^{-deg};	-- makes it a map from R with degrees {deg}.
     a := adjoint(fpl,F,M0);
     map(H,F,a));

tensorHomAdjoint = method();

tensorHomAdjoint(Matrix,Module,Module) := Matrix => (f,L,M) -> (
     if isFreeModule L and isFreeModule M
     and isFreeModule target f then adjoint(f,L,M)
     else (
	  if source f != (L ** M) then
 	  error "expected input (f,L,M), where f is a map L ** M -> N.";
	  N := target f;
	  Lp := prePrune L;
	  Mp := prePrune M;
	  Np := prePrune N; n := coverMap Np;
	  fpp := Np.prePruningMap^-1 * f *
	         (Lp.prePruningMap ** Mp.prePruningMap);
	  fppl := (fpp * t) // n;
	  a := adjoint(fppl,L0,M0);
	  inducedMap(Hom(M,N),Lp,a, 
	       Verify=>true) * Lp.prePruningMap^-1));

tensorHomAdjoint(Module,Module,Module) := Matrix => (L,M,N) -> (
    taInverse := tensorAssociativity(dual cover L, dual cover M, 
	 cover N)^-1;
    inducedMap(Hom(L,Hom(M,N)), Hom(L**M,N), taInverse,
	 Verify=>true));

homTensorAdjoint = method();

homTensorAdjoint(Matrix,Module,Module) := Matrix => (f,L,M) -> (
     if isFreeModule L and isFreeModule M
     and isFreeModule target f then adjoint1(f,L,dual M)
     else (
	  H := target f;
	  if source f != L or not H#?Hom or H.Hom#0 != M then
	  error "expected input (f,L,M), where f is a map L -> Hom(M,N)";
	  N := H.Hom#1;
	  Lp := prePrune L; l := coverMap Lp; L0 := source l;
	  Mp := prePrune M; M0 := cover Mp;
	  Np := prePrune N;
	  sf := super f;
	  fl := (sf * Lp.prePruningMap * l) // (coverMap target sf);
	  a := adjoint1(fl,L0,dual cover Mp);
	  Np.prePruningMap * inducedMap(Np, Lp ** Mp, a, Verify =>
	       true) * (Lp.prePruningMap ** Mp.prePruningMap)^-1));

homTensorAdjoint(Module,Module,Module) := Matrix => (L,M,N) -> (
     ta := tensorAssociativity(dual cover L, dual cover M, cover N);
     inducedMap(Hom(L**M,N), Hom(L,Hom(M,N)), ta,Verify=>true));

homEvaluation = method();

homEvaluation(Module,Module,Module) := Matrix => (L,M,N) -> (
     Lp := prePrune L; l := coverMap Lp; L0 := source l;
     Mp := prePrune M; m := coverMap Mp; M0 := source m;
     Np := prePrune N; n := coverMap Np; N0 := source n;
     H2 := Hom(M,N);
     k := super id_H2;
     p := coverMap target k;
     ta := tensorAssociativity(L0,dual M0, N0);
     H1 := Hom(L,M); Hp := prePrune H1;
     j := super id_H1;
     v := (j * Hp.prePruningMap * (coverMap Hp)) // coverMap target j;
     vsN := (transpose v) ** N0;
     w := inducedMap(Hom(Hp,N), Lp ** target k,
	       vsN * ta, Verify => true);
     w * (Lp ** k) * (Lp.prePruningMap^-1 ** source k));

tensorEvaluation = method();

tensorEvaluation(Module,Module,Module) := Matrix => (L,M,N) -> (
     H1 := Hom(L,M);
     Lp := prePrune L; l := coverMap Lp; L0 := source l;
     Mp := prePrune M; m := coverMap Mp; M0 := source m;
     Np := prePrune N; n := coverMap Np; N0 := source n;
     j := super id_H1;
     p := coverMap (target j);
     ta := tensorAssociativity(dual L0, M0,N0)^-1;
     w := inducedMap(Hom(L, M**N), (target j) ** Np, ta,
	       Verify => true);
     w * (j ** Np.prePruningMap^-1));

bidualMap = method();

bidualMap(Module) := Matrix => (M) -> (
     R := ring M;
     h := homEvaluation(M,R^1,R^1));
---

document{ prePrune,
     Headline => {"a simplified version of the ", TT "prune", " function."}
     }

document{ (prePrune, Module),
     Synopsis => {
	  "N = prePrune M",
	  "M" => null,
	  "N" => {"a module isomorphic to ", TT "M", "
	       which is represented as the cokernel of a matrix."}
	  },
     {"This is similar to ", TT "prune", ", except that the number of 
	  generators and relations is not minimized.  However, the 
	  form obtained is more convenient for certain purposes.", PARA,
	  "The isomorphism from ", TT "N", " to ", TT "M", "can be obtained
	  with ", TT "g = N.prePruningMap", ".  This is intentionally similar
	  in form to the case with ", TT "prune", " and ", TT "pruningMap",
	  "."},
     SEEALSO {
	  "prune", "pruningMap", "prePruningMap"
	  }	  
     }

document { prePruningMap,
     Headline => "store the isomorphism obtained by 'prePruning'",
     TT "prePruningMap", " -- the key under which is stored the isomorphism to
     a module ", TT "M", " from the module ", TT "prePrune M", ".",
     PARA,
     "This map exists only after ", TT "N = prePrune M", " has been executed
     at least once, and then the map can be obtained with ", TT "N.prePruningMap", ".",
     SEEALSO {(prePrune, Module), "pruningMap"}
     }

document{ homElement,
     Headline => "get the element of Hom from a homomorphism",
     Synopsis => {
          "h = homElement f",
          "f" => TT "M --> N",
          "h" => {"the corresponding map ", TT "R^1 --> Hom(M,N)", ", 
	       where ", TT "R", " is the ring of ", TT "f", "."}
	  },
     PARA, "This is designed to be the inverse of the function ",
     TO "homomorphism", ".",
     SEEALSO "homomorphism"
     }

document{ tensorHomAdjoint,
     Headline => {"adjunction, ", TT "**", " to ", TT "Hom", "."}
     }

document{ (tensorHomAdjoint, Matrix, Module, Module),
     Headline => {"adjoint map, ", TT "**", " to ", TT "Hom", "."},
     Synopsis => {
          "g = tensorHomAdjoint(f,L,M)",
          "f" => TT "L ** M --> N",
          "L" => null, "M" => null,
          "g" => {"the adjoint ", TT "L --> Hom(M,N)",
	       " of ", TT "f", ".", PARA,
	       "In terms of 'elements': ",
	       TT "g(l)(m) = f(l ** m)", "."}
          },
     SEEALSO (homTensorAdjoint,Matrix,Module,Module)
     }

document{ (tensorHomAdjoint, Module, Module, Module),
     Headline => {TT "**", "-", TT "Hom", " adjunction functor."},
     Synopsis => {
          "g = tensorHomAdjoint(L,M,N)",
          "L" => null,
          "M" => null,
          "N" => null,
          "g" => {TT "Hom(L ** M,N) --> Hom(L,Hom(M,N))",
	       PARA, "In terms of 'elements': ",
	       TT "g(f)(l)(m) = f(l ** m)", "."}
          },
     SEEALSO (homTensorAdjoint,Module,Module,Module)
     }

document{ homTensorAdjoint,
     Headline => {"adjunction, ", TT "Hom", " to ", TT "**", "."}
     }

document{ (homTensorAdjoint, Matrix, Module, Module),
     Headline => {"adjoint map, ", TT "Hom", " to ", TT "**"},
     Synopsis => {
          "g = homTensorAdjoint(f,L,M)",
          "f" => TT "L --> Hom(M,N)",
          "L" => null, "M" => null,
          "g" => {"the adjoint ", TT "L ** M --> N", " of ",
	       TT "f", ".", PARA, "In terms of 'elements': ",
	       TT "g(l ** m) = f(l)(m)", "."}
	  },
     SEEALSO (tensorHomAdjoint,Matrix,Module,Module)
     }

document{ (homTensorAdjoint, Module, Module, Module),
     Headline => {TT "Hom", "-", TT "**", " adjunction functor."},
     Synopsis => {
          "g = homTensorAdjoint(L,M,N)",
          "L" => null,
          "M" => null,
          "N" => null,
          "g" => {TT "Hom(L,Hom(M,N)) --> Hom(L ** M, N)", PARA,
	       "In terms of 'elements': ",
	       TT "g(f)(l ** m) = f(l)(m)", "."}
          },
     SEEALSO (tensorHomAdjoint,Module,Module,Module)
     }

document{ homEvaluation,
     Headline => "Hom evaluation functor."
     }

document{ (homEvaluation,Module,Module,Module),
     Synopsis => {
          "h = homEvaluation(L,M,N)",
          "L" => null,
          "M" => null,
          "N" => null,
          "h" => {TT "L ** Hom(M,N) --> Hom(Hom(L,M),N)", ".", PARA,
	       "In terms of 'elements': ",
	       TT "h(l ** g)(f) = f(g(l))", "."}
          },
     SEEALSO { "tensorEvaluation", "bidualMap",
               (homTensorAdjoint,Module,Module,Module),
               (tensorHomAdjoint,Module,Module,Module) }
     }

document{ tensorEvaluation,
     Headline => "tensor evaluation functor."
     }

document{ (tensorEvaluation,Module,Module,Module),
     Synopsis => {
          "h = tensorEvaluation(L,M,N)",
          "L" => null, "M" => null, "N" => null,
          "h" => {TT "Hom(L,M) ** N --> Hom(L, M ** N)", ".", PARA,
	       "In terms of 'elements': ",
	       TT "h(f ** n)(l) = f(l) ** n", "."}
          },
     SEEALSO { "homEvaluation",
               (homTensorAdjoint,Module,Module,Module),
               (tensorHomAdjoint,Module,Module,Module) }
     }

document{ bidualMap,
     Headline => "map from a module to its bi-dual",
     Synopsis => {
          "h = bidualMap M",
          "M" => null,
          "h" => {TT "M --> Hom(Hom(M,R^1),R^1)", ", where ", TT "R",
	       " is the ring of ", TT "M", ".", PARA, 
               "In terms of 'elements': ", 
	       TT "h(m)(f) = f(m)", "."}
          },
     SEEALSO (homEvaluation,Module,Module,Module)
     }

--- end ---
-- 
-- 	All the best,
-- 	-Neil Epstein
-- 
