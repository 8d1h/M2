--		Copyright 1997 by Daniel R. Grayson

GradedModule = new Type of MutableHashTable
document { quote GradedModule,
     TT "GradedModule", " -- the class of all graded modules.",
     PARA,
     "A new graded module can be made with 'M = new GradedModule'.
     The i-th module can be installed with a statement like ", TT "M#i=N", ",
     and can be retrieved with an expression like ", TT "M_i", ".  The ground
     ring should be installed with a statement like ", TT "M.ring = R", ".",
     PARA,
     "Operations on graded modules:",
     MENU {
	  (TO "==", "                -- comparison"),
	  (TO "length", "            -- length")
	  },
     "Producing graded modules:",
     MENU {
	  TO "coimage",
	  TO "gradedModule"
	  },
     SEEALSO "GradedModuleMap"
     }
spots := C -> select(keys C, i -> class i === ZZ)
union := (x,y) -> keys(set x + set y)
GradedModule == GradedModule := (C,D) -> (
     ring C === ring D
     and
     all( union(spots C, spots D), i -> (
	       C#?i and D#?i and C#i == D#i or
	       not D#?i and C#i == 0 or
	       not C#?i and D#i == 0
	       )))
GradedModule _ ZZ := (M,i) -> if M#?i then M#i else (ring M)^0
net GradedModule := C -> if C.?name then C.name else (
     s := sort spots C;
     if # s === 0 then "0"
     else (
	  horizontalJoin 
	  between("  ", apply(s, i -> stack (net C_i,"",net i)))))
length GradedModule := (M) -> (
     s := spots M;
     if #s === 0 then 0 else max s - min s)
GradedModuleMap = new Type of MutableHashTable
net GradedModuleMap := f -> (
     d := f.degree;
     v := between("",
	  apply( sort toList (
		    set spots f +
		    set spots source f +
		    set (apply(spots target f, i -> i-d))
		    ),
	       i -> horizontalJoin (
		    net (i+d), ": ", net target f_i, " <--",
		    net f_i, "-- ", net source f_i, " :", net i
		    )
	       )
	  );
     if # v === 0 then "0"
     else stack v)
document { quote GradedModuleMap,
     TT "GradedModuleMap", " -- the class of all maps between graded modules.",
     PARA,
     "Operations on graded module maps:",
     MENU {
	  },
     "Producing graded module maps:",
     MENU {
	  TO "gradedModuleMap"
	  },
     PARA,
     SEEALSO "GradedModule"
     }
GradedModuleMap _ ZZ := (f,i) -> (
     if f#?i then f#i else map((target f)_(i+f.degree),(source f)_i,0)
     )
GradedModule#id = (M) -> (
     f := new GradedModuleMap;
     f.ring = M.ring;
     f.source = f.target = M;
     f.degree = 0;
     scan(spots M, i -> f#i = id_(M_i));
     f
     )
- GradedModuleMap := f -> (
     g := new GradedModuleMap;
     g.source = f.source;
     g.target = f.target;
     g.degree = f.degree;
     g.ring = f.ring;
     scan(spots f, i -> g#i = -f_i);
     g)
RingElement + GradedModuleMap := (r,f) -> (
     if source f == target f and f.degree === 0 
     then r*id_(source f) + f
     else error "expected map to have same source and target and to have degree 0")
GradedModuleMap + RingElement := (f,r) -> (
     if source f == target f and f.degree === 0 
     then r*id_(source f) + f
     else error "expected map to have same source and target and to have degree 0")
RingElement - GradedModuleMap := (r,f) -> (
     if source f == target f and f.degree === 0 
     then r*id_(source f) - f
     else error "expected map to have same source and target and to have degree 0")
GradedModuleMap - RingElement := (f,r) -> (
     if source f == target f and f.degree === 0 
     then r*id_(source f) - f
     else error "expected map to have same source and target and to have degree 0")
RingElement == GradedModuleMap := (r,f) -> (
     if source f == target f and f.degree === 0 
     then r*id_(source f) == f
     else error "expected map to have same source and target and to have degree 0")
GradedModuleMap == RingElement := (f,r) -> (
     if source f == target f and f.degree === 0 
     then r*id_(source f) == f
     else error "expected map to have same source and target and to have degree 0")
RingElement * GradedModuleMap := (r,f) -> (
     g := new GradedModuleMap;
     g.ring = f.ring;
     g.source = f.source;
     g.target = f.target;
     g.degree = f.degree;
     scan(spots f, i -> g#i = r * f_i);
     g)
ZZ * GradedModuleMap := (n,f) -> (
     g := new GradedModuleMap;
     g.ring = f.ring;
     g.source = f.source;
     g.target = f.target;
     g.degree = f.degree;
     scan(spots f, i -> g#i = n * f_i);
     g)
GradedModuleMap ^ ZZ := (f,n) -> (
     if n === -1 then (
	  h := new GradedModuleMap;
	  h.ring = f.ring;
	  h.source = f.target;
	  h.target = f.source;
	  d := f.degree;
	  h.degree = - d;
	  scan(spots f, i -> h#(i+d) = f#i^-1);
	  h
	  )
     else if n < 0 then f^-1^-n
     else if n === 0 then id_(source f)
     else if n === 1 then f
     else (
     	  if source f != target f then error "expected source and target to be the same";
	  g := new GradedModuleMap;
	  g.ring = f.ring;
	  C := g.source = f.source;
	  g.target = f.target;
	  d = g.degree = n * f.degree;
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
GradedModuleMap + GradedModuleMap := (f,g) -> (
     if source f != source g
     or target f != target g
     or f.degree != g.degree then (
	  error "expected maps of the same degree with the same source and target";
	  );
     h := new GradedModuleMap;
     h.ring = f.ring;
     h.source = f.source;
     h.target = f.target;
     h.degree = f.degree;
     scan(union(spots f, spots g), i -> h#i = f_i + g_i);
     h)
GradedModuleMap - GradedModuleMap := (f,g) -> (
     if source f != source g
     or target f != target g
     or f.degree != g.degree then (
	  error "expected maps of the same degree with the same source and target";
	  );
     h := new GradedModuleMap;
     h.ring = f.ring;
     h.source = f.source;
     h.target = f.target;
     h.degree = f.degree;
     scan(union(spots f, spots g), i -> h#i = f_i - g_i);
     h)
GradedModuleMap == GradedModuleMap := (f,g) -> (
     if source f != source g
     or target f != target g
     or f.degree != g.degree then (
	  error "expected maps of the same degree with the same source and target";
	  );
     all(union(spots f, spots g), i -> f_i == g_i))
GradedModuleMap == ZZ := (f,i) -> (
     if i === 0 then all(spots f, j -> f_j == 0)
     else source f == target f and f == i id_(source f))
ZZ == GradedModuleMap := (i,f) -> f == i

degree GradedModuleMap := G -> G.degree
GradedModule.directSum = v -> (
     E := new GradedModule;
     rings := apply(v, ring);
     if not same rings
     then error "expected graded module maps in matrix to have the same ring";
     E.ring = rings#0;
     spts := new MutableHashTable;
     scan(v, M -> scan(spots M, i -> spts#i = 1));
     spts = toList spts;
     scan(spts, i -> E#i = directSum apply(v, M -> M_i));
     E	       
     )

GradedModuleMap ++ GradedModuleMap := (f,g) -> (
     if f.degree != g.degree then (
	  error "expected maps of the same degree";
	  );
     h := new GradedModuleMap;
     h.ring = f.ring;
     h.source = f.source ++ g.source;
     h.target = f.target ++ g.target;
     h.degree = f.degree;
     scan(union(spots f, spots g), i -> h#i = f_i ++ g_i);
     h.components = {f,g};
     h)


isDirectSum GradedModule := (M) -> M.?components
components GradedModuleMap := f -> if f.?components then f.components else {f}
GradedModuleMap _ Array := (f,v) -> f * (source f)_v
GradedModuleMap ^ Array := (f,v) -> (target f)^v * f

GradedModuleMap * GradedModuleMap := (g,f) -> (
     if target f != source g then error "expected composable maps of graded modules";
     h := new GradedModuleMap;
     h.ring = f.ring;
     h.source = source f;
     h.target = target g;
     h.degree = f.degree + g.degree;
     scan(union(spots f, apply(spots g, i -> i - f.degree)),
	  i -> h#i = g_(i+f.degree) * f_i);
     h)
GradedModule ** Module := (C,M) -> (
     P := youngest(C,M);
     key := (C,M,quote **);
     if P#?key then P#key
     else C**M = (
	  D := new GradedModule;
	  D.ring = C.ring;
	  scan(spots C, i -> D#i = C#i ** M);
	  D))
Module ** GradedModule := (M,C) -> (
     P := youngest(M,C);
     key := (M,C,quote **);
     if P#?key then P#key
     else M**C = (
	  D := new GradedModule;
	  D.ring = C.ring;
	  scan(spots C, i -> D#i = M ** C#i);
	  D))

gradedModule = method(SingleArgumentDispatch=>true)

document { quote gradedModule,
     TT "gradedModule", " -- a method for creating graded modules."
     }

gradedModule Sequence := gradedModule List := modules -> (
     C := new GradedModule;
     R := C.ring = ring modules#0;
     scan(#modules, i -> (
	       M := modules#i;
	       if R =!= ring M
	       then error "expected modules over the same ring";
	       C#i = M;
	       ));
     C)
gradedModule Module := M -> gradedModule singleton M

GradedModule ++ GradedModule := (C,D) -> (
     E := new GradedModule;
     R := E.ring = C.ring;
     if R =!= D.ring then error "expected graded modules over the same ring";
     scan(union(spots C, spots D), i -> E#i = C_i ++ D_i);
     E.components = {C,D};
     E)

GradedModule ++ Module := (C,M) -> C ++ gradedModule M
Module ++ GradedModule := (M,C) -> gradedModule M ++ C

components GradedModule := C -> if C.?components then C.components else {C}

GradedModule Array := (C,A) -> (
     if # A =!= 1 then error "expected array of length 1";
     n := A#0;
     D := new GradedModule;
     D.ring = C.ring;
     scan(spots C, i -> D#(i-n) = C#i);
     D)

GradedModule ** GradedModule := (C,D) -> (
     P := youngest(C,D);
     key := (C,D,quote **);
     if P#?key then P#key
     else C**D = (
	  R := C.ring;
	  if R =!= D.ring then error "expected graded modules over the same ring";
	  c := spots C;
	  d := spots D;
	  pairs := new MutableHashTable;
	  scan(c, i -> scan(d, j -> (
			 k := i+j;
			 p := if not pairs#?k then pairs#k = new MutableHashTable else pairs#k;
			 p#(i,j) = 1;
			 )));
	  scan(keys pairs, k -> pairs#k = sort toList pairs#k);
	  E := new GradedModule;
	  E.ring = R;
	  scan(keys pairs, k -> (
		    p := pairs#k;
		    E#k = directSum apply(p, v -> v => C#(v#0) ** D#(v#1));
		    ));
	  E
	  ))

gradedModuleMap = method(SingleArgumentDispatch=>true)

document { quote gradedModuleMap,
     TT "gradedModuleMap", " -- a method for creating maps of graded modules."
     }

gradedModuleMap Sequence := gradedModuleMap List := maps -> (
     if #maps === 0 then error "expected at least one argument";
     f := new GradedModuleMap;
     R := f.ring = ring maps#0;
     scan(#maps, i -> (
	       g := maps#i;
	       if R =!= ring g
	       then error "expected modules over the same ring";
	       f#i = g;
	       ));
     f.source = gradedModule(source \ maps);
     f.target = gradedModule(target \ maps);
     f.degree = 0;
     f)
gradedModuleMap ModuleMap := M -> gradedModuleMap singleton M

single := (v) -> (
     if not same v 
     then error "incompatible sources or targets in graded module maps in matrix";
     v#0)

GradedModuleMap.matrix = options -> (e) -> (
     nrows := #e;
     ncols := #(e#0);
     tars := apply(          e, row -> single apply(row,source));
     srcs := apply(transpose e, col -> single apply(col,source));
     R := single apply(join(tars,srcs), ring);
     f := new GradedModuleMap;
     f.ring = R;
     f.degree = 0;
     src := f.source = directSum srcs;
     tar := f.target = directSum tars;
     scan(toList(set spots src * set spots tar), k -> (
	       f#k = matrix apply(nrows, i -> apply(ncols, j -> (
			      if e#i#j#?k then e#i#j#k else map(tars#i_k,srcs#j_k,0)
			      )));
	       ));
     f
     )

kernel GradedModuleMap := options -> (f) -> (
     E := new GradedModule;
     E.ring = f.ring;
     scan(spots f, i -> E#i = kernel f#i);
     E
     )

image GradedModuleMap := (f) -> (
     E := new GradedModule;
     E.ring = f.ring;
     d := f.degree;
     scan(spots f, i -> E#(i+d) = image f#i);
     E
     )

coimage GradedModuleMap := (f) -> (
     E := new GradedModule;
     E.ring = f.ring;
     scan(spots f, i -> E#i = coimage f#i);
     E
     )

document { quote coimage,
     TT "coimage f", " -- coimage of a map of graded modules.",
     PARA,
     "The coimage of a map differs slightly from the image, in that the
     coimage is a quotient module of the source of the map, but the image
     is a submodule of the target of the map.",
     SEEALSO "GradedModule"
     }

cokernel GradedModuleMap := (f) -> (
     E := new GradedModule;
     E.ring = f.ring;
     d := f.degree;
     scan(spots f, i -> E#(i+d) = cokernel f#i);
     E
     )

cover GradedModule := (M) -> (
     E := new GradedModule;
     E.ring = M.ring;
     scan(spots M, i -> E#i = cover M#i);
     E)

ambient GradedModule := (M) -> (
     E := new GradedModule;
     E.ring = M.ring;
     scan(spots M, i -> E#i = ambient M#i);
     E)

super GradedModule := (M) -> (
     E := new GradedModule;
     E.ring = M.ring;
     scan(spots M, i -> E#i = super M#i);
     E)

prune GradedModule := (M) -> (
     E := new GradedModule;
     E.ring = M.ring;
     scan(spots M, i -> E#i = prune M#i);
     E)

prune GradedModuleMap := f -> map(prune(f.target), prune(f.source), k -> prune f_k)

complete GradedModule := (M) -> null
rank GradedModule := (M) -> sum(spots M, i -> rank M#i)

map(GradedModule,GradedModule,Function) := options -> (C,D,f) -> (
     h := new GradedModuleMap;
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

ggConcatBlocks := (R,mats) -> (
     sendgg (
	  apply(mats, row -> ( apply(row, m -> ggPush m), 
		    ggPush(#row), ggconcat, ggtranspose )),
	  ggPush(#mats), ggconcat, ggtranspose );
     getMatrix R)
     
tensorAssociativity(GradedModule,GradedModule,GradedModule) := (A,B,C) -> (
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

TEST ///
     -- here we test the commutativity of the pentagon of associativities!
     C = QQ^1[0] ++ QQ^1[-1]
     assert(
	  (tensorAssociativity(C,C,C) ** C) * tensorAssociativity(C,C**C,C) * (C ** tensorAssociativity(C,C,C))
	  ==
	  tensorAssociativity(C**C,C,C) * tensorAssociativity(C,C,C**C)
	  )
     ///
