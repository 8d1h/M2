--		Copyright 1993-1999 by Daniel R. Grayson

ChainComplex = new Type of GradedModule
new ChainComplex := ChainComplex => (cl) -> (
     C := newClass(ChainComplex,new MutableHashTable); -- sigh
     b := C.dd = new ChainComplexMap;
     b.degree = -1;
     b.source = b.target = C;
     C)

complete ChainComplex := ChainComplex => C -> (
     if C.?Resolution then (i := 0; while C_i != 0 do i = i+1);
     C)

ChainComplex _ ZZ := Module => (C,i) -> (
     if C#?i 
     then C#i
     else if C.?Resolution then (
	  gr := C.Resolution;
	  sendgg(ggPush gr, ggPush i, ggresmodule);
	  F := new Module from ring C;
	  if F != 0 then C#i = F;
	  F)
     else (ring C)^0					    -- for chain complexes of sheaves we'll want something else!
     )

ChainComplex ^ ZZ := Module => (C,i) -> C_-i

spots := C -> select(keys C, i -> class i === ZZ)
union := (x,y) -> keys(set x + set y)

rank ChainComplex := C -> sum(spots C, i -> rank C_i)

length ChainComplex := (C) -> (
     complete C;
     s := spots C;
     if #s === 0 then 0 else max s - min s
     )

ChainComplex == ChainComplex := (C,D) -> (
     all(sort union(spots C, spots D), i -> C_i == D_i)
     )     

ChainComplex == ZZ := (C,i) -> all(spots C, i -> C_i == 0)
ZZ == ChainComplex := (i,C) -> all(spots C, i -> C_i == 0)

net ChainComplex := C -> if C.?name then C.name else (
     complete C;
     s := sort spots C;
     if # s === 0 then "0"
     else (
	  a := s#0;
	  b := s#-1;
	  horizontalJoin 
	  between(" <-- ", apply(a .. b,i -> stack (net C_i,"",net i)))))
-----------------------------------------------------------------------------
ChainComplexMap = new Type of MutableHashTable
ring ChainComplexMap := C -> ring source C
complete ChainComplexMap := f -> (
     if f.?Resolution then ( i := 1; while f_i != 0 do i = i+1; );
     f)

lineOnTop := (s) -> concatenate(width s : "-") || s

sum ChainComplex := Module => C -> directSum apply(sort spots C, i -> C_i)
sum ChainComplexMap := Matrix => f -> (
     R := ring f;
     T := target f;
     t := sort spots T;
     S := source f;
     s := sort spots S;
     d := degree f;
     u := spots f;
     if #t === 0 and #s === 0 then map(R^0,0)
     else (
	  tar := if #t === 0 then R^0 else directSum apply(t,i->T_i);
	  src := if #s === 0 then R^0 else directSum apply(s,i->S_i);
	  if #u > 0 and same(apply(u, i -> degree f#i))
	  then (
	       deg := degree f#(u#0);
	       map(tar, src, matrix table(t,s,
			 (j,i) -> if j == i+d then f_i else map(T_j,S_i,0)), Degree=>deg)
	       )
	  else (
	       map(tar, src, matrix table(t,s,
		    	 (j,i) -> if j == i+d then f_i else map(T_j,S_i,0))))))

degree ChainComplexMap := f -> f.degree

net ChainComplexMap := f -> (
     complete f;
     v := between("",
	  apply(sort union(spots f.source, spots f.target),
	       i -> horizontalJoin (
		    net (i+f.degree), " : ", net target f_i, " <--",
		    lineOnTop net f_i,
		    "-- ", net source f_i, " : ", net i
		    )
	       )
	  );
     if # v === 0 then "0"
     else stack v)
ring ChainComplexMap := (f) -> ring source f
ChainComplexMap _ ZZ := Matrix => (f,i) -> (
     if f#?i 
     then f#i
     else if f.?Resolution then (
	  gr := f.Resolution;
	  sendgg(ggPush gr, ggPush i, ggresmap);
	  p := getMatrix ring gr;
	  if p != 0 then f#i = p;
	  p)
     else (
	  if f.?degree
	  then map((target f)_(i+f.degree),(source f)_i,0,Degree=>f.degree)
	  else map((target f)_(i+f.degree),(source f)_i,0)
	  ))

ChainComplex#id = (C) -> (
     complete C;
     f := new ChainComplexMap;
     f.source = f.target = C;
     f.degree = 0;
     scan(spots C, i -> f#i = id_(C_i));
     f)
- ChainComplexMap := ChainComplexMap => f -> (
     complete f;
     g := new ChainComplexMap;
     g.source = f.source;
     g.target = f.target;
     g.degree = f.degree;
     scan(spots f, i -> g#i = -f_i);
     g)
RingElement + ChainComplexMap := (r,f) -> (
     if source f == target f and f.degree === 0 
     then r*id_(source f) + f
     else error "expected map to have same source and target and to have degree 0")
ChainComplexMap + RingElement := (f,r) -> r+f

ChainComplexMap + ZZ := (f,i) -> (
     if i === 0 then f
     else if source f != target f
     then error "expected same source and target"
     else f + i*id_(target f))
ZZ + ChainComplexMap := (i,f) -> f+i

RingElement - ChainComplexMap := (r,f) -> (
     if source f == target f and f.degree === 0 
     then r*id_(source f) - f
     else error "expected map to have same source and target and to have degree 0")
ChainComplexMap - RingElement := (f,r) -> (
     if source f == target f and f.degree === 0 
     then r*id_(source f) - f
     else error "expected map to have same source and target and to have degree 0")


RingElement == ChainComplexMap := (r,f) -> (
     if source f == target f and f.degree === 0 
     then r*id_(source f) == f
     else error "expected map to have same source and target and to have degree 0")
ChainComplexMap == RingElement := (f,r) -> (
     if source f == target f and f.degree === 0 
     then r*id_(source f) == f
     else error "expected map to have same source and target and to have degree 0")
RingElement * ChainComplexMap := (r,f) -> (
     complete f;
     g := new ChainComplexMap;
     g.source = f.source;
     g.target = f.target;
     g.degree = f.degree;
     scan(spots f, i -> g#i = r * f_i);
     g)
ZZ * ChainComplexMap := (n,f) -> (
     complete f;
     g := new ChainComplexMap;
     g.source = f.source;
     g.target = f.target;
     g.degree = f.degree;
     scan(spots f, i -> g#i = n * f_i);
     g)
ChainComplexMap ^ ZZ := ChainComplexMap => (f,n) -> (
     if source f != target f then error "expected source and target to be the same";
     if n < 0 then error "expected nonnegative integer";
     if n === 0 then id_(source f)
     else (
     	  complete f;
	  g := new ChainComplexMap;
	  C := g.source = f.source;
	  g.target = f.target;
	  d := g.degree = n * f.degree;
	  scan(spots f, i ->
	       if C#?(i+d) and C#(i+d) != 0 then (
		    s := f_i;
		    j := 1;
		    while (
			 if j < n then s != 0
			 else (
			      g#i = s;
			      false)
			 ) do (
			 s = f_(i + j * f.degree) * s;
			 j = j+1;
			 )
		    ));
	  g))
ChainComplexMap + ChainComplexMap := ChainComplexMap => (f,g) -> (
     if source f != source g
     or target f != target g
     or f.degree != g.degree then (
	  error "expected maps of the same degree with the same source and target";
	  );
     h := new ChainComplexMap;
     h.source = f.source;
     h.target = f.target;
     h.degree = f.degree;
     complete f;
     complete g;
     scan(union(spots f, spots g), i -> h#i = f_i + g_i);
     h)
ChainComplexMap - ChainComplexMap := ChainComplexMap => (f,g) -> (
     if source f != source g
     or target f != target g
     or f.degree != g.degree then (
	  error "expected maps of the same degree with the same source and target";
	  );
     h := new ChainComplexMap;
     h.source = f.source;
     h.target = f.target;
     h.degree = f.degree;
     complete f;
     complete g;
     scan(union(spots f, spots g), i -> h#i = f_i - g_i);
     h)
ChainComplexMap == ChainComplexMap := (f,g) -> (
     if source f != source g
     or target f != target g
     or f.degree != g.degree then (
	  error "expected maps of the same degree with the same source and target";
	  );
     complete f;
     complete g;
     all(union(spots f, spots g), i -> f_i == g_i))
ChainComplexMap == ZZ := (f,i) -> (
     complete f;
     if i === 0 then all(spots f, j -> f_j == 0)
     else source f == target f and f == i id_(source f))
ZZ == ChainComplexMap := (i,f) -> f == i
ChainComplexMap ++ ChainComplexMap := ChainComplexMap => (f,g) -> (
     if f.degree != g.degree then (
	  error "expected maps of the same degree";
	  );
     h := new ChainComplexMap;
     h.source = f.source ++ g.source;
     h.target = f.target ++ g.target;
     h.degree = f.degree;
     complete f;
     complete g;
     scan(union(spots f, spots g), i -> h#i = f_i ++ g_i);
     h.components = {f,g};
     h)

isHomogeneous ChainComplexMap := f -> all(spots f, i -> isHomogeneous f_i)

isDirectSum ChainComplex := (C) -> C.?components
components ChainComplexMap := f -> if f.?components then f.components else {f}
ChainComplexMap _ Array := ChainComplexMap => (f,v) -> f * (source f)_v
ChainComplexMap ^ Array := ChainComplexMap => (f,v) -> (target f)^v * f

RingMap ChainComplex := ChainComplex => (f,C) -> (
     D := new ChainComplex;
     D.ring = target f;
     complete C;
     scan(spots C, i -> D#i = f C#i);
     complete C.dd;
     scan(spots C.dd, i -> D.dd#i = map(D_(i-1),D_i, f C.dd#i));
     D)

ChainComplexMap * ChainComplexMap := ChainComplexMap => (g,f) -> (
     if target f != source g then error "expected composable maps of chain complexes";
     h := new ChainComplexMap;
     h.source = source f;
     h.target = target g;
     h.degree = f.degree + g.degree;
     complete f;
     complete g;
     scan(union(spots f, apply(spots g, i -> i - f.degree)),
	  i -> h#i = g_(i+f.degree) * f_i);
     h)

extend = method()

extend(ChainComplex,ChainComplex,Matrix) := ChainComplexMap => (D,C,fi)-> (
     i := 0;
     j := 0;
     f := new ChainComplexMap;
     f.source = C;
     f.target = D;
     complete C;
     s := f.degree = j-i;
     f#i = fi;
     n := i+1;
     while C#?n do (
	  f#n = (f_(n-1) * C.dd_n) // D.dd_(n+s);
	  n = n+1;
	  );
     f)

cone ChainComplexMap := ChainComplex => f -> (
     if f.degree =!= 0 then error "expected a map of chain complexes of degree zero";
     C := source f;
     D := target f;
     E := new ChainComplex;
     E.ring = ring f;
     complete C;
     complete D;
     scan(union(spots C /( i -> i+1 ), spots D), i -> E#i = D_i ++ C_(i-1));
     complete C.dd;
     complete D.dd;
     scan(union(spots C.dd /( i -> i+1 ), spots D.dd), i -> E.dd#i = 
	       D.dd_i	      	       |      f_(i-1)    ||
	       map(C_(i-2),D_i,0)      |   - C.dd_(i-1)
	       );
     E)

nullhomotopy ChainComplexMap := ChainComplexMap => f -> (
     s := new ChainComplexMap;
     s.ring = ring f;
     s.source = C := source f;
     c := C.dd;
     s.target = D := target f;
     b := D.dd;
     deg := s.degree = f.degree + 1;
     complete f;
     scan(sort spots f, i -> 
	  (
	       if s#?(i-1) and c#?i
	       then if f#?i
	       then (
		    -- if    (f_i - s_(i-1) * c_i) %  b_(i+deg) != 0
		    -- then error "expected map to be null homotopic";
		    s#i = (f_i - s_(i-1) * c_i) // b_(i+deg)
		    )
	       else (
		    -- if    (    - s_(i-1) * c_i) %  b_(i+deg) != 0
		    -- then error "expected map to be null homotopic";
		    s#i = (    - s_(i-1) * c_i) // b_(i+deg)
		    )
	       else if f#?i 
	       then (
		    -- if    (f_i                ) %  b_(i+deg) != 0
		    -- then error "expected map to be null homotopic";
		    s#i = (f_i                ) // b_(i+deg)
		    )
	       )
	  );
     s)

-----------------------------------------------------------------------------
poincare ChainComplex := C -> (
     R := ring C;
     S := degreesRing R;
     G := monoid S;
     use S;
     f := 0_S;
     complete C;
     scan(keys C, i -> (
	       if class i === ZZ
	       then scanPairs(tally degrees C_i, 
		    (d,m) -> f = f + m * (-1)^i * product(# d, j -> G_j^(d_j)))));
     f)

poincareN ChainComplex := (C) -> (
     s := local S;
     t := local T;
     G := group [s, t_0 .. t_(degreeLength ring C - 1)];
     -- this stuff has to be redone as in Poincare itself, DRG
     R := ZZ G;
     use R;
     f := 0_R;
     complete C;
     scan(keys C, n -> (
	       if class n === ZZ
	       then scanPairs(tally degrees C_n, 
		    (d,m) -> f = f + m * G_0^n * product(# d, j -> G_(j+1)^(d_j)))));
     f )

ChainComplex ** Module := ChainComplex => (C,M) -> (
     P := youngest(C,M);
     key := (C,M,symbol **);
     if P#?key then P#key
     else C**M = (
	  D := new ChainComplex;
	  D.ring = ring C;
	  complete C.dd;
	  scan(keys C.dd,i -> if class i === ZZ then (
		    f := D.dd#i = C.dd#i ** M;
		    D#i = source f;
		    D#(i-1) = target f;
		    ));
	  D))

Module ** ChainComplex := ChainComplex => (M,C) -> (
     P := youngest(M,C);
     key := (M,C,symbol **);
     if P#?key then P#key
     else M**C = (
	  D := new ChainComplex;
	  D.ring = ring C;
	  complete C.dd;
	  scan(keys C.dd,i -> if class i === ZZ then (
		    f := D.dd#i = M ** C.dd#i;
		    D#i = source f;
		    D#(i-1) = target f;
		    ));
	  D))
-----------------------------------------------------------------------------

homology(ZZ,ChainComplex) := Module => opts -> (i,C) -> homology(C.dd_i, C.dd_(i+1))
cohomology(ZZ,ChainComplex) := Module => opts -> (i,C) -> homology(-i, C)

homology(ZZ,ChainComplexMap) := Matrix => opts -> (i,f) -> (
     inducedMap(homology(i+degree f,target f), homology(i,source f),f_i)
     )
cohomology(ZZ,ChainComplexMap) := Matrix => opts -> (i,f) -> homology(-i,f)

homology(ChainComplex) := GradedModule => opts -> (C) -> (
     H := new GradedModule;
     H.ring = ring C;
     complete C;
     scan(spots C, i -> H#i = homology(i,C));
     H)

gradedModule(ChainComplex) := GradedModule => (C) -> (
     H := new GradedModule;
     H.ring = ring C;
     complete C;
     scan(spots C, i -> H#i = C#i);
     H)

homology(ChainComplexMap) := GradedModuleMap => opts -> (f) -> (
     g := new GradedModuleMap;
     g.degree = f.degree;
     g.source = HH f.source;
     g.target = HH f.target;
     scan(spots f, i -> g#i = homology(i,f));
     g)

chainComplex = method(SingleArgumentDispatch=>true)

chainComplex Matrix := ChainComplexMap => f -> chainComplex {f}

chainComplex Sequence := chainComplex List := ChainComplex => maps -> (
     if #maps === 0 then error "expected at least one differential map";
     C := new ChainComplex;
     R := C.ring = ring target maps#0;
     scan(#maps, i -> (
	       f := maps#i;
	       if R =!= ring f
	       then error "expected differential maps over the same ring";
	       if i > 0 and C#i != target f then (
		    diff := degrees C#i - degrees target f;
		    if same diff
		    then f = f ** R^(- diff#0)
		    else error "expected composable differential maps";
		    );
	       C.dd#(i+1) = f;
	       if i === 0 then C#i = target f;
	       C#(i+1) = source f;
	       ));
     C)

betti = method(TypicalValue => Net)

betti Matrix := f -> (
     R := ring target f;
     f = matrix ( f ** R );
     f = map( f , Degree => 0 );
     betti chainComplex f
     )
betti GroebnerBasis := G -> betti generators G
betti Ideal := I -> "generators: " | betti generators I
betti Module := M -> (
     if M.?relations then (
	  if M.?generators then (
	       "generators: " | betti generators M || "relations : " | betti relations M
	       )
	  else "relations : " | betti relations M
	  )
     else "generators: " | betti generators M
     )

ChainComplex.directSum = args -> (
     C := new ChainComplex;
     C.components = toList args;
     C.ring = ring args#0;
     scan(args,D -> (complete D; complete D.dd;));
     scan(unique flatten (args/spots), n -> C#n = directSum apply(args, D -> D_n));
     scan(spots C, n -> if C#?(n-1) then C.dd#n = directSum apply(args, D -> D.dd_n));
     C)
ChainComplex ++ ChainComplex := ChainComplex => (C,D) -> directSum(C,D)

components ChainComplex := C -> if C.?components then C.components else {C}

ChainComplex Array := ChainComplex => (C,A) -> (
     if # A =!= 1 then error "expected array of length 1";
     n := A#0;
     D := new ChainComplex;
     b := D.dd;
     D.ring = ring C;
     complete C;
     scan(pairs C,(i,F) -> if class i === ZZ then D#(i-n) = F);
     complete C.dd;
     if even n
     then scan(pairs C.dd, (i,f) -> if class i === ZZ then b#(i-n) = f)
     else scan(pairs C.dd, (i,f) -> if class i === ZZ then b#(i-n) = -f);
     D)

Hom(ChainComplex, Module) := ChainComplex => (C,N) -> (
     c := C.dd;
     complete c;
     D := new ChainComplex;
     D.ring = ring C;
     b := D.dd;
     scan(spots c, i -> (
	       j := - i + 1;
	       f := b#j = Hom(c_i,N);
	       D#j = source f;
	       D#(j-1) = target f;
	       ));
     D)

Hom(Module, ChainComplex) := ChainComplex => (M,C) -> (
     complete C.dd;
     D := new ChainComplex;
     D.ring = ring C;
     scan(spots C.dd, i -> (
	       f := D.dd#i = Hom(M,C.dd_i);
	       D#i = source f;
	       D#(i-1) = target f;
	       ));
     D)

dual ChainComplex := ChainComplex => (C) -> (
	  R := ring C;
	  Hom(C,R^1))

Hom(ChainComplexMap, Module) := ChainComplexMap => (f,N) -> (
     g := new ChainComplexMap;
     d := g.degree = f.degree;
     g.source = Hom(target f, N);
     g.target = Hom(source f, N);
     scan(spots f, i -> g#(-i-d) = Hom(f#i,N));
     g)

Hom(Module, ChainComplexMap) := ChainComplexMap => (N,f) -> (
     g := new ChainComplexMap;
     d := g.degree = f.degree;
     g.source = Hom(N, source f);
     g.target = Hom(N, target f);
     scan(spots f, i -> g#i = Hom(N,f#i));
     g)

transpose ChainComplexMap := dual ChainComplexMap := ChainComplexMap => f -> Hom(f, (ring f)^1)

regularity ChainComplex := C -> (
     maxrow := null;
     complete C;
     scan(pairs C, (col,F) -> if class col === ZZ then (
	       degs := (transpose degrees F)#0;  -- ... fix ...
	       scanPairs(tally degs, (j,m) -> (
			 row := j-col;
			 maxrow = if maxrow === null then row else max(row,maxrow);
			 ))));
     if maxrow===null then 0 else maxrow)
regularity Module := (M) -> regularity resolution M

firstDegrees := method()
firstDegrees Module := M -> (
     R := ring M;
     if  M#?(symbol firstDegrees) 
     then M#(symbol firstDegrees)
     else M#(symbol firstDegrees) = (
	  rk := numgens M;
	  nd := degreeLength R;
	  if nd == 0 then toList (rk : 0)
	  else (
	       sendgg ggPush M;
	       eePop ConvertList
	       if nd == 1 then ConvertInteger
	       else ConvertApply splice (first, nd : ConvertInteger))))

BettiNumbers := C -> (
     betti := new MutableHashTable;
     maxrow := null;
     minrow := null;
     maxcol := null;
     mincol := null;
     maxcols := new MutableHashTable;
     complete C;
     scan(pairs C, (col,F) -> if class col === ZZ then (
	       if not isFreeModule F
	       then error "expected a chain complex of free modules";
	       degs := firstDegrees F;
	       betti#("total", col) = # degs;
	       maxcol = if maxcol === null then col else max(col,maxcol);
	       mincol = if mincol === null then col else min(col,mincol);
	       scanPairs(tally degs, (j,m) -> (
			 row := j-col;
			 maxrow = if maxrow === null then row else max(row,maxrow);
			 minrow = if minrow === null then row else min(row,minrow);
			 betti#(row,col) = m + (
			      if not betti#?(row,col) then 0 else betti#(row,col)
			      );
			 maxcols#row = (
			      if not maxcols#?row then col 
			      else max(maxcols#row, col)
			      );
			 ))));
     betti#"mincol" = mincol;
     betti#"minrow" = minrow;
     betti#"maxcol" = maxcol;
     betti#"maxrow" = maxrow;
     betti)

resBetti := g -> (
    sendgg(ggPush g, ggbetti);
    eePopIntarray())

betti ChainComplex := C -> (
     if C.?Resolution then (
	  r := C.Resolution;
	  v := resBetti r;
	  minrow := v#0;
	  maxrow := v#1;
	  mincol := 0;
	  maxcol := v#2;
	  leftside := apply(
	       splice {"total:", apply(minrow .. maxrow, i -> toString i | ":")},
	       s -> (6-# s,s));
	  v = drop(v,3);
	  v = pack(v,maxcol-mincol+1);
	  totals := apply(transpose v, sum);
	  v = prepend(totals,v);
	  v = transpose v;
	  t := 0;
	  while t < #v and sum v#(-t-1) === 0 do t = t + 1;
	  v = drop(v,-t);
	  v = applyTable(v, bt -> if bt === 0 then "." else toString bt);
	  v = apply(v, col -> (
		    wid := 1 + max apply(col,i -> #i);
		    apply(col, s -> (
			      n := # s;
			      w := (wid - n + 1)//2; 
			      (w, s, wid-w-n)
			      ))));
	  v = prepend(leftside,v);
	  v = transpose v;
	  stack apply(v, concatenate))
     else (
	  betti := BettiNumbers C;
	  mincol = betti#"mincol";
	  minrow = betti#"minrow";
	  maxcol = betti#"maxcol";
	  maxrow = betti#"maxrow";
	  betti = hashTable apply(pairs betti,(k,v) -> (k,toString v));
	  colwids := newClass(MutableList, apply(maxcol-mincol+1, i->1));
	  scan(pairs betti, (k,v) -> (
		    if class k === Sequence
		    then (
			 (row,col) -> colwids#(col-mincol) = max(colwids#(col-mincol), # v)
			 ) k 
		    ) 
	       );
	  stack apply(splice {"total", minrow .. maxrow},
	       row -> (
		    concatenate(pad(5,toString row), ":",
		    toList apply(mincol .. maxcol,
			 col -> pad(
			      1+colwids#(col-mincol),
			      if not betti#?(row,col) then "." else betti#(row,col)
			      )))))))
-----------------------------------------------------------------------------
syzygyScheme = (C,i,v) -> (
     -- this doesn't work any more because 'resolution' replaces the presentation of a cokernel
     -- by a minimal one.  The right way to fix it is to add an option to resolution.
     g := extend(resolution cokernel transpose (C.dd_i * v), dual C[i], transpose v);
     prune cokernel (C.dd_1  * transpose g_(i-1)))
-----------------------------------------------------------------------------
chainComplex GradedModule := ChainComplex => (M) -> (
     C := new ChainComplex from M;
     b := C.dd = new ChainComplexMap;
     b.degree = -1;
     b.source = b.target = C;
     C)
-----------------------------------------------------------------------------

ggConcatCols := (R,mats) -> (
     sendgg(apply(mats,ggPush), ggPush (#mats), ggconcat);
     getMatrix R)

ggConcatBlocks := (R,mats) -> (
     sendgg (
	  apply(mats, row -> ( apply(row, m -> ggPush m), 
		    ggPush(#row), ggconcat, ggtranspose )),
	  ggPush(#mats), ggconcat, ggtranspose );
     getMatrix R)

tens := (R,f,g) -> (
     sendgg (ggPush f, ggPush g, ggtensor);
     getMatrix R)

ChainComplex ** ChainComplex := ChainComplex => (C,D) -> (
     P := youngest(C,D);
     key := (C,D,symbol **);
     if P#?key then P#key
     else C**D = (
	  R := ring C;
	  if ring D =!= R then error "expected chain complexes over the same ring";
	  E := chainComplex (lookup(symbol **, GradedModule, GradedModule))(C,D);
	  scan(spots E, i -> if E#?i and E#?(i-1) then E.dd#i = map(
		    E#(i-1),
		    E#i,
		    ggConcatBlocks(R, table(
			      E#(i-1).indices,
			      E#i.indices,
			      (j,k) -> (
				   if j#0 === k#0 and j#1 === k#1 - 1 
				   then (-1)^(k#0) * tens(R, map cover C#(j#0), matrix D.dd_(k#1))
				   else if j#0 === k#0 - 1 and j#1 === k#1 
				   then tens(R, matrix C.dd_(k#0), map cover D#(k#1))
				   else map(
					E#(i-1).components#(E#(i-1).indexComponents#j),
					E#i.components#(E#i.indexComponents#k),
					0))))));
	  E))

ChainComplex ** GradedModule := ChainComplex => (C,D) -> (
     P := youngest(C,D);
     key := (C,D,symbol **);
     if P#?key then P#key
     else C**D = (
     	  C ** chainComplex D
	  )
     )

GradedModule ** ChainComplex := ChainComplex => (C,D) -> (
     P := youngest(C,D);
     key := (C,D,symbol **);
     if P#?key then P#key
     else C**D = (
     	  chainComplex C ** D
	  )
     )

ChainComplexMap ** ChainComplexMap := ChainComplexMap => (f,g) -> (
     P := youngest(f,g);
     key := (f,g,symbol **);
     if P#?key then P#key
     else f**g = (
	  h := new ChainComplexMap;
	  E := h.source = source f ** source g;
	  F := h.target = target f ** target g;
	  deg := h.degree = f.degree + g.degree;
	  scan(spots E, n -> if F#?(n+deg) then (
		    E' := E#n;
		    E'i := E'.indexComponents;
		    E'c := E'.components;
		    F' := F#(n+deg);
		    F'i := F'.indexComponents;
		    h#n = map(F',E', matrix {
			      apply(E'.indices, (i,j) -> (
					t := (i+f.degree, j+g.degree);
					if F'i#?t then F'_[t] * ( ((-1)^(g.degree * i) * f_i ** g_j) )
					else map(F',E'c#(E'i#(i,j)),0)))})));
	  h))

ChainComplexMap ** ChainComplex := ChainComplexMap => (f,C) -> (
     P := youngest(f,C);
     key := (f,C,symbol **);
     if P#?key then P#key
     else f**C = (
     	  f ** id_C
	  )
     )
ChainComplex ** ChainComplexMap := ChainComplexMap => (C,f) -> (
     P := youngest(C,f);
     key := (C,f,symbol **);
     if P#?key then P#key
     else C**f = (
     	  id_C ** f
	  )
     )

min ChainComplex := C -> min spots C
max ChainComplex := C -> max spots C

tensorAssociativity(Module,Module,Module) := Matrix => (A,B,C) -> map((A**B)**C,A**(B**C),1)

newMatrix := (tar,src) -> (
     R := ring tar;
     p := new Matrix;
     p.source = src;
     p.target = tar;
     p.handle = newHandle "";
     p)
     
tensorAssociativity(ChainComplex,ChainComplex,ChainComplex) := ChainComplexMap => (A,B,C) -> (
     R := ring A;
     map(
	  F := (AB := A ** B) ** C,
	  E :=  A ** (BC := B ** C),
	  k -> ggConcatBlocks(R, apply(F_k.indices, (ab,c) -> (
			 apply(E_k.indices, (a,bc) -> (
				   b := bc-c;  -- ab+c=k=a+bc, so b=bc-c=ab-a
				   if A#?a and B#?b and C#?c
				   then (
					(AB#ab_[(a,b)] ** C#c)
					* tensorAssociativity(A#a,B#b,C#c)
					* (A#a ** BC#bc^[(b,c)])
					)
				   else map(F_k.components#(F_k.indexComponents#(ab,c)),
					     E_k.components#(E_k.indexComponents#(a,bc)),
					     0))))))
	       ))


     -- 	  k -> sum(E_k.indices, (a,bc) -> (
     -- 		    sum(BC_bc.indices, (b,c) -> (
     -- 			      F_k_[(a+b,c)]
     -- 			      * (AB_(a+b)_[(a,b)] ** C_c)
     -- 			      * tensorAssociativity(A_a,B_b,C_c)
     -- 			      * (A_a ** BC_bc^[(b,c)])
     -- 			      )) * E_k^[(a,bc)]))

Module Array := ChainComplex => (M,v) -> (
     if #v =!= 1 then error "expected array of length 1";
     n := v#0;
     if class n =!= ZZ then error "expected [n] with n an integer";
     C := new ChainComplex;
     C.ring = ring M;
     C#-n = M;
     C)

ChainComplexMap _ Array := ChainComplexMap => (f,v) -> f * (source f)_v
ChainComplexMap ^ Array := ChainComplexMap => (f,v) -> (target f)^v * f

trans := (C,v) -> (
     if C.?indexComponents then (
	  Ci := C.indexComponents;
	  apply(v, i -> if Ci#?i then Ci#i else error "expected an index of a component of the direct sum"))
     else (
     	  if not C.?components then error "expected a direct sum of chain complexes";
	  Cc := C.components;
	  apply(v, i -> if not Cc#?i then error "expected an index of a component of the direct sum");
	  v)
     )
ChainComplex _ Array := ChainComplexMap => (C,v) -> if C#?(symbol _,v) then C#(symbol _,v) else C#(symbol _,v) = (
     v = trans(C,v);
     D := directSum apply(toList v, i -> C.components#i);
     map(C,D,k -> C_k_v))

ChainComplex ^ Array := ChainComplexMap => (C,v) -> if C#?(symbol ^,v) then C#(symbol ^,v) else C#(symbol ^,v) = (
     v = trans(C,v);
     D := directSum apply(toList v, i -> C.components#i);
     map(D,C,k -> C_k^v))

map(ChainComplex,ChainComplex,Function) := ChainComplexMap => options -> (C,D,f) -> (
     h := new ChainComplexMap;
     h.source = D;
     h.target = C;
     deg := h.degree = if options.Degree === null then 0 else options.Degree;
     scan(spots D, k -> (
	       if C#?(k+deg) then (
		    g := f(k);
		    if g =!= null and g != 0 then h#k = map(C#(k+deg),D#k,g);
		    )));
     h
     )

map(ChainComplex,ChainComplex,ChainComplexMap) := ChainComplexMap => options -> (C,D,f) -> map(C,D,k -> f_k)

map(ChainComplex,ChainComplex) := ChainComplexMap => options -> (C,D) -> (
     h := new ChainComplexMap;
     h.source = D;
     h.target = C;
     deg := h.degree = if options.Degree === null then 0 else options.Degree;
     scan(spots D, k -> if C#?(k+deg) then h#k = map(C#(k+deg),D#k));
     h
     )

kernel ChainComplexMap := ChainComplex => options -> (f) -> (
     D := source f;
     C := new ChainComplex;
     C.ring = ring f;
     complete D;
     scan(spots D, k -> C#k = kernel f_k);
     scan(spots C, k -> if C#?(k-1) then C.dd#k = (D.dd_k * map(D_k,C_k)) // map(D_(k-1),C_(k-1)));
     C)

coimage ChainComplexMap := ChainComplex => (f) -> (
     D := source f;
     C := new ChainComplex;
     C.ring = ring f;
     complete D;
     scan(spots D, k -> C#k = coimage f_k);
     scan(spots C, k -> if C#?(k-1) then C.dd#k = map(C#(k-1),C#k,matrix D.dd_k));
     C)

cokernel ChainComplexMap := ChainComplex => (f) -> (
     D := target f;
     deg := f.degree;
     C := new ChainComplex;
     C.ring = ring f;
     complete D;
     scan(spots D, k -> C#k = cokernel f_(k-deg));
     scan(spots C, k -> if C#?(k-1) then C.dd#k = map(C#(k-1),C#k,matrix D.dd_k));
     C)

image ChainComplexMap := ChainComplex => (f) -> (
     D := target f;
     E := source f;
     deg := f.degree;
     C := new ChainComplex;
     C.ring = ring f;
     complete D;
     scan(spots D, k -> C#k = image f_(k-deg));
     scan(spots C, k -> if C#?(k-1) then C.dd#k = map(C#(k-1),C#k,matrix E.dd_(k-deg)));
     C)

prune ChainComplex := ChainComplex => (C) -> (
     D := new ChainComplex;
     complete C;
     complete C.dd;
     D.ring = ring C;
     scan(spots C, i -> D#i = prune C#i);
     scan(spots C.dd, i -> D.dd#i = prune C.dd#i);
     D)

prune ChainComplexMap := ChainComplexMap => (f) -> (
     complete f;
     map(prune target f, prune source f, k -> prune f#k)
     )
