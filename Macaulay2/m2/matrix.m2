--		Copyright 1995 by Daniel R. Grayson and Michael Stillman

ModuleMap = new Type of MutableHashTable
document { quote ModuleMap,
     TT "ModuleMap", " -- the class of all maps between modules.",
     PARA,
     "This class is experimental, designed to support graded modules.",
     SEEALSO {"Matrix"}
     }

Matrix = new Type of ModuleMap
ring Matrix := f -> (
     S := ring target f;
     R := ring source f;
     if R === S then R
     else error "expected module map with source and target over the same ring"
     )
document { quote Matrix,
     TT "Matrix", " -- the class of all matrices for which Groebner basis operations
     are available from the ", TO "engine", ".",
     PARA,
     "A matrix is a map from a graded module to a graded module, see ",
     TO "Module", ".  The degree of the map is not necessarily 0, and may
     be obtained with ", TO "degree", ".",
     PARA,
     "Multiplication of matrices corresponds to composition of maps, and when
     ", TT "f", " and ", TT "g", " are maps so that the target ", TT "Q", "
     of ", TT "g", " equals the source ", TT "P", " of ", TT "f", ", the
     product ", TT "f*g", " is defined, its source is the source of ", TT
     "g", ", and its target is the target of ", TT "f", ".  The degree of ",
     TT "f*g", " is the sum of the degrees of ", TT "f", " and of ", TT "g",
     ".  The product is also defined when ", TT "P", " != ", TT "Q", ",
     provided only that ", TT "P", " and ", TT "Q", " are free modules of the
     same rank.  If the degrees of ", TT "P", " differ from the corresponding
     degrees of ", TT "Q", " by the same degree ", TT "d", ", then the degree
     of ", TT "f*g", " is adjusted by ", TT "d", " so it will have a good
     chance to be homogeneous, and the target and source of ", TT "f*g", "
     are as before.", 
     PARA,
     "If ", TT "h", " is a matrix then ", TT "h_j", " is the ", TT "j", "-th
     column of the matrix, and ", TT "h_j_i", " is the entry in row ", TT
     "i", ", column ", TT "j", ".  The notation ", TT "h_(i,j)", " can be
     used as an abbreviation for ", TT "h_j_i", ", allowing row and column
     indices to be written in the customary order.",
     PARA,
     "If ", TT "m", " and ", TT "n", " are matrices, ", TT "a", " is a ring element, 
     and ", TT "i", " is an integer, then ", TT "m+n", ", ", TT "m-n", ", 
     ", TT "-m", ", ", TT "m n", ", ", TT "a*m", ", and ", TT "i*m", " denote the
     usual matrix arithmetic.  Use ", TT "m == n", ", and ", TT "m == 0", " to 
     check equality of matrices.",
     PARA,
     "Operations which produce matrices:", 
     MENU {
	  TO "flip",
          (TO "genericMatrix", " -- an generic matrix"),
          (TO "genericSkewMatrix", " -- an generic skew-symmetric matrix"),
          (TO "genericSymmetricMatrix", " -- a generic symmetric matrix"),
	  (TO "id", " -- identity maps"),
	  (TO "matrix", " -- create a matrix"),
	  (TO "map", " -- create a map of modules"),
	  (TO "random", " -- a random homgeneous matrix")
	  },
     "Operations on matrices:",
     MENU {
	  (TO "==", " -- equality test"),
	  (TO "!=", " -- inequality test"),
	  (TO "+", " -- sum"),
	  (TO "-", " -- difference"),
	  (TO "*", " -- product"),
	  (TO "^", " -- power"),
	  (TO (quote ^, Matrix, List), " -- extracting or permuting rows"),
	  (TO (quote ^, Matrix, Array), " -- extracting or permuting blocks of rows"),
	  (TO (quote %,Matrix,Matrix), " -- remainder"),
	  (TO (quote %,Matrix,RingElement), " -- remainder"),
	  (TO (quote //,Matrix,Matrix), " -- quotient"),
	  (TO (quote //,Matrix,RingElement), " -- quotient"),
	  (TO (quote _, Matrix, Sequence), " -- getting an entry"),
	  (TO (quote _, Matrix, List), " -- extracting or permuting columns"),
	  (TO (quote _, Matrix, Array), " -- extracting or permuting blocks of columns"),
	  (TO (quote |, Matrix, Matrix), " -- horizontal concatenation"),
	  (TO (quote ||, Matrix, Matrix), " -- vertical concatenation"),
	  (TO (quote ++, Matrix, Matrix), " -- direct sum"),
	  (TO (quote **,Matrix, Matrix), " -- tensor product of matrices"),
	  (TO (quote **, Matrix, Module), " -- tensor product, e.g., degree shifting"),
	  (TO (quote **,Matrix,Ring), " -- tensor product, base change"),
	  TO ":",
	  TO "adjoint",
	  TO "adjoint1",
	  TO "ambient",
	  (TO "basis", "               -- k-basis of a module in a given degree"),
	  (TO "borel", " m              -- smallest Borel submodule containing lead
		monomials of m"),
	  TO "codim",
	  TO "complement",
	  (TO "compress", "             -- removal of zero columns"),
	  TO "content",
	  (TO {"contract", "(m,n)"}, " -- contraction of n by m (differentiation without 
                          the coefficients)"),
	  TO "degree",
	  (TO "det", "                 -- determinant"),
	  (TO "diff", "                -- differentiation"),
	  (TO "divideByVariable", "    -- divide columns by a variable repeatedly"),
	  TO "dual",
	  TO "selectInSubring",
	  (TO "entries", "             -- the entries of m"),
	  (TO "exteriorPower", "       -- exterior power of m"),
          (TO "flatten", "             -- collect entries of a matrix into one row"),
	  (TO "inducedMap", "          -- a map induced on subquotients"),
	  (TO "inducesWellDefinedMap", " -- whether a matrix would induce a well defined map"),
          (TO "isHomogeneous", "       -- whether a matrix is homogeneous"),
	  (TO "isInjective", "         -- whether a map is injective"),
          (TO "isIsomorphism", "       -- whether a map is an isomorphism"),
	  (TO "isSurjective", "        -- whether a map is surjective"),
	  (TO "isWellDefined", "       -- whether a map is well-defined"),
	  (TO "homogenize", "          -- homogenize a matrix"),
	  (TO "jacobian", "            -- Jacobian matrix of a matrix"),
	  (TO "koszul", "              -- i-th Koszul matrix of a matrix"),
          (TO "leadTerm", "            -- lead monomial matrix of the columns of a matrix"),
 	  (TO "minors", "              -- ideal minors of a matrix"),
	  TO "modulo",
	  (TO "pfaffians", " -- ideal of i by i Pfaffians of a skew symmetric matrix"),
	  TO "poincare",
	  TO "reshape",
          (TO "ring", "                -- the base ring of a matrix"),
	  TO "singularLocus",
	  (TO "sortColumns", "         -- sort the columns of a matrix"),
          (TO "source", "              -- the source free module of a map"),
 	  (TO "submatrix", "           -- extract a submatrix"),
	  (TO "substitute", "          -- replacing the variables in a matrix"),
	  (TO "symmetricPower", "      -- symmetric power of a matrix"),
          (TO "target", "              -- the target module of a map"),
	  TO "top",
	  TO "topCoefficients",
	  (TO "trace", "               -- trace"),
 	  (TO "transpose", "           -- transpose a matrix")
	  },
     PARA,
     "Operations which produce modules from matrices:",
     MENU {
	  (TO "cokernel", "            -- the cokernel of a map"),
	  TO "homology",
	  TO "image",
	  TO "kernel",
	  (TO "kernel", "              -- the kernel of a map"),
	  TO "submodule",
	  TO "subquotient"
	  },
     "Operations which produce Groebner bases from matrices:",
     MENU {
	  TO "gb",
	  TO "mingens",
	  TO "syz"
	  },
     "Printing matrices:",
     MENU {
	  TO "compactMatrixForm",
	  }
     }

document { quote gcdDegree,
     TT "gcdDegree F", " -- I don't know what this is supposed to do.",
     }
document { quote lcmDegree,
     TT "lcmDegree F", " -- I don't know what this is supposed to do.",
     }

local newMatrix				  -- defined below

reduce := (tar) -> (
     if not isFreeModule tar and not ring tar === ZZ then (
	  g := gb presentation tar;
	  sendgg(ggPush g, ggPush 1, ggpick, ggreduce, ggpop);
	  ))

ZZ * Matrix := (i,m) -> (
     sendgg(ggPush ring m, ggPush i, ggfromint, ggPush m, ggmult);
     T := target m;
     reduce T;
     newMatrix(T, source m))

Matrix * ZZ := (m,i) -> (
     sendgg(ggPush ring m, ggPush i, ggfromint, ggPush m, ggmult);
     T := target m;
     reduce T;
     newMatrix(T, source m))

RingElement * Matrix := (r,m) -> (
     R := ring r;
     if R =!= ring m then error "scalar not in ring of matrix";
     sendgg (ggPush r, ggPush m, ggmult);
     T := target m;
     reduce T;
     newMatrix(T, source m))

newMatrix = (tar,src) -> (
     R := ring tar;
     p := new Matrix;
     p.source = src;
     p.target = tar;
     p.handle = newHandle "";
     p)

getMatrix = (R) -> newMatrix(
     (sendgg(ggdup,gggetrows); new Module from R),
     (sendgg(ggdup,gggetcols); new Module from R)
     )

document { quote getMatrix,
     TT "getMatrix R", " -- pops a matrix over ", TT "R", " from the top of 
     the engine's stack and returns it."
     }

BinaryMatrixOperation := (operation) -> (m,n) -> (
     if ring m =!= ring n then (
	  try m = promote(m,ring n)
	  else try n = promote(n,ring m)
	  else error "expected matrices over compatible rings");
     sendgg (ggPush m, ggPush n, operation);
     getMatrix ring m)

BinaryMatrixOperationSame := (operation) -> (m,n) -> (
     -- same source and target
     if ring m =!= ring n then (
	  try m = promote(m,ring n)
	  else try n = promote(n,ring m)
	  else error "expected matrices over compatible rings");
     sendgg (ggPush m, ggPush n, operation);
     T := target m;
     reduce T;
     newMatrix(T, source m))

Matrix _ Sequence := (m,ind) -> (
     if # ind === 2
     then (
     	  R := ring m;
	  rows := numgens target m;
	  cols := numgens source m;
	  i := ind#0;
	  j := ind#1;
	  if i < 0 or i >= rows then error (
	       "encountered row index ", name i,
	       " out of range 0 .. ", name (rows-1));
	  if j < 0 or j >= cols then error (
	       "encountered column index ", name j,
	       " out of range 0 .. ", name (cols-1));
     	  sendgg (ggPush m, ggINT, gg ind#0, ggINT, gg ind#1, ggelem);
     	  R.pop())
     else error "expected a sequence of length two"
     )
document { (quote _, Matrix, Sequence),
     TT "f_(i,j)", " -- provide the element in row ", TT "i", " and
     column ", TT "j", " of the matrix ", TT "f", ".",
     SEEALSO {"_", "Matrix"}
     }

Matrix _ ZZ := (m,i) -> (
     if 0 <= i and i < numgens source m then (
     	  sendgg (ggPush m, ggPush i, ggelem);
     	  new m.target)
     else error ("subscript '", name i, "' out of range"))
document { (quote _, Matrix, ZZ),
     TT "f_i", " -- provide the ", TT "i", "-th column of a matrix ", TT "f", " as a vector.",
     PARA,
     "Vectors are disparaged, so we may do away with this function in the future.",
     SEEALSO "_"
     }

Matrix == Matrix := (m,n) -> (
     target m == target n
     and source m == source n
     and (
     	  sendgg (ggPush m, ggPush n, ggisequal); 
     	  eePopBool()))
Matrix == RingElement := (m,f) -> m - f == 0
RingElement == Matrix := (f,m) -> m - f == 0
Matrix == ZZ := (m,i) -> (
     if i === 0
     then (
	  sendgg(ggPush m, ggiszero); 
	  eePopBool()
	  )
     else (
	  R := ring m;
	  m == i_R
	  )
     )
ZZ == Matrix := (i,m) -> m == i

Matrix + Matrix := BinaryMatrixOperationSame ggadd
Matrix + RingElement := (f,r) -> if r == 0 then f else f + r*id_(target f)
RingElement + Matrix := (r,f) -> if r == 0 then f else r*id_(target f) + f
ZZ + Matrix := (i,f) -> if i === 0 then f else i*1_(ring f) + f
Matrix + ZZ := (f,i) -> if i === 0 then f else f + i*1_(ring f)

Matrix - Matrix := BinaryMatrixOperationSame ggsubtract
Matrix - RingElement := (f,r) -> if r == 0 then f else f - r*id_(target f)
RingElement - Matrix := (r,f) -> if r == 0 then -f else r*id_(target f) - f
ZZ - Matrix := (i,f) -> if i === 0 then -f else i*1_(ring f) - f
Matrix - ZZ := (f,i) -> if i === 0 then f else f - i*1_(ring f)

- Matrix := f -> (
     h := new Matrix;
     h.source = source f;
     h.target = target f;
     h.handle = newHandle (ggPush f, ggnegate);
     h)

Matrix * Matrix := (m,n) -> (
     if source m == target n then (
	  if ring target m =!= ring target n then (
	       n = matrix n ** ring target m;
	       );
     	  sendgg (ggPush m, ggPush n, ggmult);
	  M := target m;
	  N := source n;
	  reduce M;
	  newMatrix(M,N))
     else (
     	  R := ring m;
	  S := ring n;
	  if R =!= S then (
	       try m = m ** S else
	       try n = n ** R else
	       error "maps over incompatible rings";
	       );
	  M = target m;
	  P := source m;
	  N = source n;
	  Q := target n;
	  if not isFreeModule P or not isFreeModule Q or rank P =!= rank Q
	  then error "maps not composable";
	  dif := degrees P - degrees Q;
	  if same dif then (
	       sendgg (ggPush m, ggPush n, ggmult, 
		    ggdup, ggPush (degree m + degree n + dif#0), ggsetshift);
	       reduce M;
	       newMatrix(M,N))
	  else (
	       sendgg (ggPush m, ggPush n, ggmult, 
		    ggdup, ggPush toList (degreeLength R:0), ggsetshift);
	       reduce M;
	       newMatrix(M,N))))

Matrix ^ ZZ := (f,n) -> (
     if n === 0 then id_(target f)
     else SimplePowerMethod (f,n))

TEST "
R=ZZ/101[a,b]
f=matrix(R,{{1,a},{0,1}})
g=matrix(R,{{1,0},{b,1}})
h=f*g*f*g
assert( h^3 * h^-1 == h^2 * h^0 )
assert( h * h^-1 == 1 )
"

TEST "
R=ZZ/101[a,b]
f = matrix {{a}}
assert( source f != target f)
assert( target f == target f^2 )
assert( source f == source f^2 )
assert( target f == target f^0 )
assert( source f != source f^0 )
"

transpose Matrix :=  (m) -> (
     if not (isFreeModule source m and isFreeModule target m) 
     then error "expected a map between free modules";
     sendgg (ggPush m, ggtranspose);
     f := getMatrix ring m;
     map(dual source m, dual target m, f, Degree => - degree m))

ring(Matrix) := m -> (
     R := m.source.ring;
     if R =!= m.target.ring
     then error "expected map to have source and target over same ring";
     R)

Matrix * Vector := (m,v) -> (
     if class v =!= source m then error "map not applicable to vector";
     if not isFreeModule source m then notImplemented();
     sendgg(ggPush m, ggPush v, ggmult);
     new m.target)

expression Matrix := m -> MatrixExpression applyTable(entries m, expression)

name Matrix := m -> concatenate (
     -- "matrix (", name target m, ", ", name source m, ", ", name entries m, ")"
     "matrix ", name entries m
     )

isIsomorphism Matrix := f -> coker f == 0 and ker f == 0

isHomogeneous Matrix := m -> (
     if m.?isHomogeneous then m.isHomogeneous 
     else m.isHomogeneous = (
	  isHomogeneous ring target m
	  and isHomogeneous ring source m
	  and (
	       M := source m;
	       N := target m;
	       (sendgg(ggPush m, ggishomogeneous); eePopBool())
	       and
	       ( not M.?generators or isHomogeneous M.generators )
	       and
	       ( not N.?generators or isHomogeneous N.generators )
	       )))

isWellDefined Matrix := f -> matrix f * presentation source f % presentation target f == 0

document { quote isWellDefined,
     TT "isWellDefined m", " -- tells whether a map m of modules is 
     well-defined."
     }

ggConcatCols := (tar,src,mats) -> (
     sendgg(apply(mats,ggPush), ggPush (#mats), ggconcat);
     f := newMatrix(tar,src);
     if same(degree \ mats) and degree f != degree mats#0
     then f = map(target f, source f, f, Degree => degree mats#0);
     f)

ggConcatRows := (tar,src,mats) -> (
     sendgg(
	  apply(mats,m -> (ggPush m, ggtranspose)), 
	  ggPush (# mats), ggconcat, ggtranspose
	  );
     f := newMatrix(tar,src);
     if same(degree \ mats)
     and degree f != degree mats#0
     then f = map(target f, source f, f, Degree => degree mats#0);
     f)

ggConcatBlocks := (tar,src,mats) -> (
     sendgg (
	  apply(mats, row -> ( 
		    apply(row, m -> ggPush m), 
		    ggPush(#row), ggconcat, ggtranspose )),
	  ggPush(#mats), ggconcat, ggtranspose );
     f := newMatrix(tar,src);
     if same(degree \ flatten mats)
     and degree f != degree mats#0#0
     then f = map(target f, source f, f, Degree => degree mats#0#0);
     f)

samering := mats -> (
     R := ring mats#0;
     if not all ( mats, m -> ring m === R )
     then error "expected matrices over the same ring";
     R)

Matrix.directSum = args -> (
     R := ring args#0;
     if not all(args, f -> ring f === R) 
     then error "expected matrices all over the same ring";
     sendgg(apply(args, ggPush), ggPush (#args), ggdirectsum);
     f := newMatrix(directSum apply(args,target),directSum apply(args,source));
     f.components = toList args;
     f)

isDirectSum = method()
isDirectSum Module := (M) -> M.?components
document { quote isDirectSum,
     TT "isDirectSum M", " -- returns ", TT "true", " if ", TT "M", " was
     formed as a direct sum.",
     PARA,
     "Works for modules, graded modules, etc.  The components of the sum
     can be recovered with ", TO "components", "."
     }

TEST "
assert isDirectSum (QQ^1 ++ QQ^2)
assert isDirectSum (QQ^1 ++ QQ^2)
"

components Module := M -> if M.?components then M.components else {M}
components Matrix := f -> if f.?components then f.components else {f}

Module.directSum = args -> (
	  R := ring args#0;
	  if not all(args, f -> ring f === R) 
	  then error "expected modules all over the same ring";
	  N := if all(args, M -> not M.?generators) 
	  then (
	       if all(args, M -> not M.?relations) 
	       then R ^ (- join toSequence apply(args, degrees))
	       else subquotient( null, directSum apply(args,relations) )
	       )
	  else (
	       if all(args, M -> not M.?relations) then (
		    subquotient( directSum apply(args,generators), null )
		    )
	       else subquotient(
		    directSum apply(args,generators), 
		    directSum apply(args,relations)));
	  N.components = toList args;
	  N)

single := v -> (
     if not same v 
     then error "incompatible objects in direct sum";
     v#0)

indices = method()
indices MutableHashTable := X -> (
     if not X.?components then error "expected an object with components";
     if X.?indices then X.indices else toList ( 0 .. #X.components - 1 ) )

document { quote youngest,
     TT "youngest s", " -- return the youngest mutable hash table in the sequence
     ", TT "s", ", if any, else ", TT "null", "."
     }

directSum List := args -> directSum toSequence args
directSum Sequence := args -> (
     if #args === 0 then error "expected more than 0 arguments";
     y := youngest args;
     key := (directSum, args);
     if y =!= null and y#?key then y#key else (
	  type := single apply(args, class);
	  if not type.?directSum then error "no method for direct sum";
	  S := type.directSum args;
	  if y =!= null then y#key = S;
	  S))
Option ++ Option := directSum
Option.directSum = args -> (
     if #args === 0 then error "expected more than 0 arguments";
     modules := apply(args,last);
     y := youngest modules;
     key := (directSum, args);
     if y =!= null and y#?key then y#key else (
	  type := single apply(modules, class);
	  if not type.?directSum then error "no method for direct sum";
	  S := type.directSum modules;
	  if y =!= null then y#key = S;
     	  keys := S.indices = toList args/first;
     	  S.indexComponents = new HashTable from toList apply(#keys, i -> keys#i => i);
	  S))
Matrix ++ Matrix := directSum
Module ++ Module := directSum

document { (quote ++,Module,Module),
     TT "M++N", " -- computes the direct sum of two modules.",
     PARA,
     EXAMPLE {
	  "R = ZZ/101[a..c];",
      	  "image vars R ++ kernel vars R",
	  },
     "Projection and inclusion maps for direct sums:",
     MENU {
	  TO (quote ^,Module,Array),
	  TO (quote _,Module,Array)
	  },
     SEEALSO directSum
     }

document { (quote ++,Matrix,Matrix),
     TT "f++g", " -- computes the direct sum of two maps between modules.",
     PARA,
     "If an argument is a ring element or integer, it is promoted
     to a one by one matrix.",
     EXAMPLE {
	  "R = ZZ/101[a..c];",
      	  "vars R ++ transpose vars R",
      	  "oo^[1]",
      	  "a++b++c",
	  },
     "Selecting rows or columns of blocks:",
     MENU {
	  TO (quote ^,Matrix,Array),
	  TO (quote _,Matrix,Array)
	  },
     SEEALSO {directSum, (quote |, Matrix, Matrix), (quote ||, Matrix, Matrix)}
     }

document { quote directSum,
     TT "directSum(M,N,...)", " -- forms the direct sum of matrices or modules.",
     PARA,
     "The components can be recovered later with ", TO "components", ".",
     PARA,
     "Projection and inclusion maps for direct sums:",
     MENU {
	  TO (quote ^,Module,Array),
	  TO (quote _,Module,Array),
	  TO (quote ^,Matrix,Array),
	  TO (quote _,Matrix,Array)
	  },
     PARA,
     "It sometimes happens that the user has indices for the components of
     a direct sum preferable to the usual consecutive small integers.  In 
     this case the preferred indices can be specified with code
     like ", TT "directSum(a=>M,b=>N,...)", ", as in the following example.",
     EXAMPLE {
	  ///F = directSum(a=>ZZ^1, b=>ZZ^2, c=>ZZ^3)///,
	  ///F_[b]///,
	  ///F^[c]///,
	  },
     "Similar syntax works with ", TO "++", ".",
     EXAMPLE {
	  ///F = (a => ZZ^1) ++ (b => ZZ^2)///,
	  ///F_[b]///,
	  },
     SEEALSO {"++", "components", "indexComponents", "indices"}
     }

document { quote indexComponents,
     TT "indexComponents", " -- a symbol used as a key in a direct sum
     under which to store a hash table in which to register preferred keys used
     to index the components of the direct sum.",
     PARA,
     SEEALSO {"directSum", "components", "indices"}
     }

document { quote indices,
     TT "indices", " -- a symbol used as a key in a direct sum
     under which to store a list of the preferred keys used
     to index the components of the direct sum.",
     PARA,
     SEEALSO {"directSum", "components", "indexComponents"}
     }

Matrix ++ ZZ :=
Matrix ++ RingElement := (f,r) -> f ++ matrix {{r}}

ZZ ++ Matrix :=
RingElement ++ Matrix := (r,f) -> matrix {{r}} ++ f

ZZ ++ RingElement :=
RingElement ++ ZZ :=
RingElement ++ RingElement := (r,s) -> matrix {{r}} ++ matrix {{s}}

concatCols := mats -> (
     mats = select(toList mats,m -> m =!= null);
     if # mats === 1 
     then mats#0
     else (
	  samering mats;
	  targets := unique apply(mats,target);
	  M := targets#0;
	  if not all(targets, F -> F == M) 
	  and not all(targets, F -> isFreeModule F)
	  then error "unequal targets";
	  ggConcatCols(targets#0, Module.directSum apply(mats,source), mats)))

concatRows := mats -> (
     mats = select(toList mats,m -> m =!= null);
     if # mats === 1 
     then mats#0
     else (
	  samering mats;
	  sources := unique apply(mats,source);
	  N := sources#0;
	  if not all(sources, F -> F == N) 
	  and not all(sources, F -> isFreeModule F)
	  then error "unequal sources";
	  ggConcatRows(Module.directSum apply(mats,target), sources#0, mats)))

concatBlocks := mats -> (
     if not isTable mats then error "expected a table of matrices";
     if #mats === 1
     then concatCols mats#0
     else if #(mats#0) === 1
     then concatRows (mats/first)
     else (
     	  samering flatten mats;
	  sources := unique applyTable(mats,source);
	  N := sources#0;
	  if not all(sources, F -> F == N) and not all(sources, F -> all(F,isFreeModule))
	  then error "unequal sources";
	  targets := unique transpose applyTable(mats,target);
	  M := targets#0;
	  if not all(targets, F -> F == M) and not all(targets, F -> all(F,isFreeModule))
	  then error "unequal targets";
     	  ggConcatBlocks(
	       Module.directSum (mats/first/target),
	       Module.directSum (mats#0/source),
	       mats)))

Matrix | Matrix := (f,g) -> concatCols(f,g)
RingElement | Matrix := (f,g) -> concatCols(f**id_(target g),g)
Matrix | RingElement := (f,g) -> concatCols(f,g**id_(target f))
ZZ | Matrix := (f,g) -> concatCols(f*id_(target g),g)
Matrix | ZZ := (f,g) -> concatCols(f,g*id_(target f))

Matrix || Matrix := (f,g) -> concatRows(f,g)
RingElement || Matrix := (f,g) -> concatRows(f**id_(source g),g)
     -- we would prefer for f**id_(source g) to have the exact same source as g does
Matrix || RingElement := (f,g) -> concatRows(f,g**id_(source f))
ZZ || Matrix := (f,g) -> concatRows(f*id_(source g),g)
Matrix || ZZ := (f,g) -> concatRows(f,g*id_(source f))

listZ := v -> (
     if not all(v,i -> class i === ZZ) then error "expected list of integers";
     )

submatrix(Matrix,List,Nothing) := (m,rows,cols) -> (
     submatrix(m, rows, 0 .. numgens source m - 1)
     )

submatrix(Matrix,Nothing,List) := (m,rows,cols) -> (
     submatrix(m, 0 .. numgens target m - 1, cols)
     )

submatrix(Matrix,Sequence,Sequence) := 
submatrix(Matrix,Sequence,List) := 
submatrix(Matrix,List,Sequence) := 
submatrix(Matrix,List,List) := (m,rows,cols) -> (
     if not isFreeModule source m or not isFreeModule target m
     then error "expected a homomorphism between free modules";
     rows = toList splice rows;
     listZ rows;
     cols = toList splice cols;
     listZ cols;
     sendgg(ggPush m, 
	  ggINTARRAY, gg rows, ggINTARRAY, gg cols, ggsubmatrix);
     getMatrix ring m)

submatrix(Matrix,List) := (m,cols) -> (
     cols = toList splice cols;
     listZ cols;
     sendgg(ggPush m, 
	  ggINTARRAY, gg cols, 
	  ggsubmatrix);
     getMatrix ring m)
     
document { quote submatrix,
     TT "submatrix(m, rows, cols)", " -- yields a submatrix of the matrix ", TT "m", ".",
     BR,NOINDENT,
     TT "submatrix(m, cols)", " -- yields a submatrix of the matrix ", TT "m", ".",
     PARA,
     "Yields an r by c matrix, where r is the length of the list of integers
     ", TT "rows", ", and c is the length of the list of integers ", TT "cols", ".  
     The (i,j)-th entry of the result is m_(rows_i, cols_j).  If necessary, any
     sequences in the lists are spliced into the list.",
     PARA,
     EXAMPLE {
	  "R = ZZ/101[a .. o]",
      	  "m = genericMatrix(R, a, 3, 5)",
      	  "submatrix(m, {1,2,0}, {0..2, 4})",
	  },
     PARA,
     "If ", TT "rows", " or ", TT "cols", " is omitted, all the indices are used.",
     EXAMPLE "submatrix(m, {1,2}, )",
     PARA,
     "It is an error if any element of ", TT "rows", " or ", TT "cols", " is out 
     of range."
     }

diff(Matrix, Matrix) := BinaryMatrixOperation ggdiff
diff(RingElement, RingElement) := (f,g) -> (
     (diff(matrix{{f}},matrix{{g}}))_(0,0)
     )
diff(Matrix, RingElement) := (m,f) -> diff(m,matrix{{f}})
diff(RingElement, Matrix) := (f,m) -> diff(matrix{{f}},m)
diff(Vector, RingElement) := (v,f) -> (diff(matrix{v},matrix{{f}}))_0
diff(RingElement, Vector) := (f,v) -> diff(matrix{{f}},transpose matrix{v})
diff(Vector, Vector) := (v,w) -> diff(matrix{v}, transpose matrix{w})
diff(Matrix, Vector) := (m,w) -> diff(m,transpose matrix {w})
diff(Vector, Matrix) := (v,m) -> diff(matrix {v}, m)
document { quote diff,
     TT "diff(m,n)", " -- differentiate the matrix n by the matrix m",
     BR,NOINDENT,
     TT "diff P", " -- compute the difference polynomial for a projective
     Hilbert polynomial, see ", TO "ProjectiveHilbertPolynomial", ".",
     BR,NOINDENT,
     TT "diff(P,i)", " -- compute the i-th difference polynomial for a projective
     Hilbert polynomial, see ", TO "ProjectiveHilbertPolynomial", ".",
     PARA,
     "Given matrices m : F0 <--- F1, and n : G0 <--- G1, produce a matrix
     with the shape diff(m,n) : F0' ** G0 <--- F1' ** G1, whose 
     entry in the slot ((i,j),(k,l)) is the result of differentiating
     n_(j,l) by the differential operator corresponding to m_(i,k).",
     PARA,
     "If ", TT "m", " or ", TT "n", " is a ring element, then it is interpreted
     as a one-by-one matrix.  If ", TT "m", " is a vector, it is interpreted as
     a matrix with one column, and if ", TT "n", " is a vector, it is interpreted
     as a matrix with one row.  If both ", TT "m", " and ", TT "n", " are ring
     elements, then the result will be a ring element rather than a one-by-one
     matrix.  If ", TT "m", " is a vector and ", TT "n", " is a ring element,
     then the result will be a vector rather than a matrix with one column.",
     PARA,
     EXAMPLE {
	  "R = ZZ/101[a..d]",
      	  "m = genericMatrix(R,a,2,2)",
      	  "diff(transpose m,m*m)",
	  },
     PARA,
     "The most common usage of this function is when m : F <--- R^1
     and n : R^1 <--- G.  In this case the result is a matrix with shape
     diff(m,n) : F' <--- G, and the (i,j) th entry is the result of
     differentiating n_j by the differential operator corresponding to m_i.",
     EXAMPLE {
	  "m = matrix {{a,b,c,d}}",
      	  "n = matrix {{a^2, (b + c)*(a + d), a*b*c}}",
      	  "p = diff(transpose m,n)",
      	  "target p",
      	  "source p",
	  },
     PARA,
     "As another example, we show how to compute the Wronskian of a
     polynomial f.",
     EXAMPLE {
	  "R = ZZ/101[a, x .. z]",
      	  "f = matrix {{x^3 + y^3 + z^3 - a*x*y*z}}",
      	  "v = matrix {{x,y,z}}",
      	  "W = diff(transpose v * v, f)",
      	  "Wf = minors(3,W)",
	  },
     PARA,
     SEEALSO { "contract", "jacobian" }
     }

contract(Matrix, Matrix) := BinaryMatrixOperation ggcontract
contract(RingElement, RingElement) := (f,g) -> (
     (contract(matrix{{f}},matrix{{g}}))#(0,0)
     )
contract(Matrix, RingElement) := (m,f) -> contract(m,matrix{{f}})
contract(RingElement, Matrix) := (f,m) -> contract(matrix{{f}},m)
contract(Vector, RingElement) := (v,f) -> (contract(matrix{v},matrix{{f}}))_0
contract(RingElement, Vector) := (f,v) -> contract(matrix{{f}},transpose matrix{v})
contract(Vector, Vector) := (v,w) -> contract(matrix{v}, transpose matrix{w})
contract(Matrix, Vector) := (m,w) -> contract(m,transpose matrix {w})
contract(Vector, Matrix) := (v,m) -> contract(matrix {v}, m)
document { quote contract,
     TT "usage: contract(m, n)", " -- contract the matrix n by the matrix m",
     PARA,
     "This function is identical to ", TO "diff", ", except that contraction is
     used instead of differentiation.  This means for example that x^3
     contracted by x^2 is x, not 6 x.  For example, ",
     EXAMPLE {
	  "R = ZZ/101[a..c]",
      	  "diff(transpose matrix {{a,b,c}}, matrix {{(a+b+c)^3, a^2 * b^3 * c^2}})",
	  },
     PARA,
     "As another example, the Sylvester resultant between homogeneous polynomials
     f(x,y) and g(x,y) can be found in the following way.",
     EXAMPLE {
	  "R = (ZZ/101[a,b])[x,y]",
      	  "f = a * x^3 + b * x^2 * y + y^3",
      	  "g = b * x^3 + a * x * y^2 + y^3",
	  },
     "Multiply each of these by all quadrics, obtaining a set of elements in
     degree 5:",
     EXAMPLE "n = matrix {{f,g}} ** symmetricPower(2,vars R)",
     "Now create the matrix of coefficients by using contract against all
     monomials of degree 5 in x and y.",
     EXAMPLE {
	  "M = contract(transpose symmetricPower(5,vars R), n)",
      	  "Resfg = minors(6, M)",
	  },
     PARA,
     SEEALSO "diff"
     }

jacobian = method()
jacobian Matrix := (m) -> diff(transpose vars ring m, m)

jacobian Ring := (R) -> jacobian presentation R ** R

TEST "
R = ZZ/101[a..d]
I = monomialCurve(R,{1,3,4})
A = R/I
jacobian A
singA = minors(codim ideal presentation A, jacobian A)
generators gb singA
"
document { quote jacobian,
     TT "jacobian R", " -- calculates the Jacobian matrix of the ring R",
     BR,NOINDENT,
     TT "jacobian f", " -- calculates the Jacobian matrix of the matrix f,
     which will normally be a matrix with one row.",
     BR,NOINDENT,
     TT "jacobian I", " -- compute the matrix of derivatives of the 
     generators of I w.r.t. all of the variables",
     PARA,
     EXAMPLE {
	  "R = ZZ/101[a..d];",
      	  "I = monomialCurve(R,{1,3,4})",
      	  "A = R/I",
      	  "jacobian A",
	  },
     "For a one row matrix, the derivatives w.r.t. all the variables
     is given",
     EXAMPLE {
	  "R = ZZ/101[a..c]",
      	  "p = symmetricPower(2,vars R)",
      	  "jacobian p",
	  },
     "Caveat: if a matrix or ideal over a quotient polynomial ring S/J
     is given, then only the derivatives of the given elements are
     computed and NOT the derivatives of elements of J."
     }

leadTerm(ZZ, Matrix) := (i,m) -> (
     sendgg(ggPush m, ggINT, gg i, gginitial);
     getMatrix ring m)
leadTerm(Matrix) := m -> (
     sendgg(ggPush m, gginitial);
     getMatrix ring m)

document { quote leadTerm,
     TT "leadTerm f", " -- return the leading term of the polynomial or 
     vector f.",
     BR, NOINDENT,
     TT "leadTerm m", " -- return the matrix of initial forms of 
     the columns of the matrix m.",
     BR, NOINDENT,
     TT "leadTerm(i,m)", " -- return the matrix of polynomials formed 
     by retaining those monomials of each entry which agree on the first i 
     weight vectors.",
     PARA,
     EXAMPLE {
	  "R = ZZ/101[a..d]",
      	  "leadTerm (3 + 8*a^2*b + 7*b*c^2)",
      	  "leadTerm matrix {{a,b},{c,d}}",
      	  "leadTerm matrix {{c,d},{a,b}}",
	  },
     SEEALSO {"leadCoefficient", "leadMonomial", "leadComponent"}
     }

borel Matrix := m -> (
     sendgg (
	  ggPush m, ggINT, gg 0, ggmonideal,  -- get monomial lead ideal
	  ggborel,                            -- monomial borel now on stack
	  ggmatrix);
     getMatrix ring m)
document { quote borel,
  TT "usage: borel m", " -- create a matrix of monomials",
  PARA,
  "Yields the matrix with the same target as the matrix ", TT "m", ", whose columns
   generate the smallest Borel fixed submodule containing the lead monomials
   of the columns of ", TT "m", ".",
  PARA,
  "For example, if R = ZZ/101[a..f], then",
  EXAMPLE {
       "R = ZZ/101[a..e]",
       "borel matrix {{a*d*e, b^2}}"
       }
  }

--------------------------------------------------------------------------
------------------------ matrix and map for modules ----------------------
--------------------------------------------------------------------------

mopts := Options => {
     Degree => null
     }

matrix = method mopts
map = method mopts

map(Module,Module) := options -> (M,N) -> (
     F := ambient N;
     if F == ambient M
     then map(M,N,
	  if M.?generators 
	  then map(M,N,generators N // generators M) -- sigh, should we check for zero remainder?
	  else generators N,
	  options)
     else error "expected modules to have the same ambient free module"
     )

TEST "
R = ZZ/101[a..d]
F = R^3
H = subquotient(F_{1,2}, F_{2})
f = map(H,cover H,id_(cover H))
assert( cokernel f == 0 )
assert( kernel f == image R^2_{1} )
assert( isWellDefined f )
assert( isSurjective f )
assert( not isInjective f )
"

map(Module,Module,RingElement) := options -> (M,N,r) -> (
     R := ring M;
     if r == 0 then (
	  f := new Matrix;
	  f.handle = newHandle(ggPush cover M, ggPush cover N, ggzeromat);
	  f.source = N;
	  f.target = M;
	  f.ring = ring M;
	  f)
     else if numgens cover M == numgens cover N then map(M,N,r * id_(cover M)) 
     else error "expected 0, or source and target with same number of generators")

map(Module,Module,ZZ) := options -> (M,N,i) -> (
     if i === 0 then (
	  R := ring M;
	  f := new Matrix;
	  f.handle = newHandle(ggPush cover M, ggPush cover N, ggzeromat);
	  f.source = N;
	  f.target = M;
	  f.ring = ring M;
	  f)
     else if M == N then map(M,i)
     else if numgens cover M == numgens cover N then map(M,N,i * id_(cover M)) 
     else error "expected 0, or source and target with same number of generators")

map(Module,RingElement) := options -> (M,r) -> (
     R := ring M;
     try r = r + R#0
     else error "encountered scalar of unrelated ring";
     if r == 0 then map(M,M,0)
     else if r == 1 then map(M,1)
     else r * (map(M,1)))

map(Module) := options -> (M) -> (
     R := ring M;
     f := new Matrix;
     sendgg(ggPush cover M, ggiden);
     if options.Degree =!= null 
     then sendgg(ggdup, ggPush options.Degree, ggsetshift);
     reduce M;
     f.handle = newHandle "";
     f.source = f.target = M;
     f)

map(Module,ZZ) := options -> (M,i) -> (
     if i === 0 then map(M,M,0)
     else if i === 1 then map(M,options)
     else i * map M)

map(Module,Matrix) := options -> (M,f) -> (
     R := ring M;
     if R =!= ring f then error "expected the same ring";
     if # degrees M =!= # degrees target f then (
	  error "expected ambient modules of the same rank";
	  );
     diffs := degrees M - degrees target f;
     if not same diffs then (
	  error "expected to find uniform difference between degrees"
	  );
     map(M,source f ** R^{-first diffs},f)
     )

degreeCheck := (d,R) -> (
     if class d === ZZ then d = {d};
     if class d === List
     and all(d,i -> class i === ZZ) 
     and #d === degreeLength R
     then d
     else (
	  if degreeLength R === 1
	  then error "expected degree to be an integer or list of integers of length 1"
	  else error (
	       "expected degree to be a list of integers of length ",
	       string degreeLength R
	       )
	  )
     )

map(Module,Module,Matrix) := options -> (M,N,f) -> (
     if M === f.target and N === f.source
     and (options.Degree === null or options.Degree === degree f)
     then f
     else (
	  R := ring M;
	  N' := cover N ** R;
	  sendgg (ggPush cover M, ggPush N', ggPush f,
	       ggPush (
		    if options.Degree === null
		    then toList (degreeLength R : 0)
		    else degreeCheck(options.Degree, R)),
	       ggmatrix);
	  reduce M;
	  newMatrix(M,N)))

inducedMap = method (
     Options => {
	  Verify => true,
	  Degree => null 
	  })
inducedMap(Module,Module,Matrix) := options -> (M,N,f) -> (
     sM := target f;
     sN := source f;
     if ambient M != sM
     then error "'inducedMap' expected target of map to be a subquotient of target module provided";
     if ambient N != sN
     then error "'inducedMap' expected source of map to be a subquotient of source module provided";
     g := f * generators N;
     h := generators M;
     p := map(M, N, g // h, Degree => options.Degree);
     if options.Verify then (
	  if g % h != 0
	  then error "'inducedMap' expected matrix to induce a map";
	  if not isWellDefined p
	  then error "'inducedMap' expected matrix to induce a well-defined map";
	  );
     p)
inducedMap(Module,Nothing,Matrix) := o -> (M,N,f) -> inducedMap(M,source f, f,o)
inducedMap(Nothing,Module,Matrix) := o -> (M,N,f) -> inducedMap(target f,N, f,o)
inducedMap(Nothing,Nothing,Matrix) := o -> (M,N,f) -> inducedMap(target f,source f, f,o)

inducedMap(Module,Module) := o -> (M,N) -> (
     if ambient M != ambient N 
     then error "'inducedMap' expected modules with same ambient free module";
     inducedMap(M,N,id_(ambient N),o))

document { quote inducedMap,
     TT "inducedMap(M,N,f)", " -- produce the map from ", TT "N", " to ", TT "M", " 
     induced by ", TT "f", ".",
     PARA,
     "Here ", TT "M", " should be a subquotient module of the target of ", TT "f", ", and
     ", TT "N", " should be a subquotient module of the source of ", TT "f", ".",
     PARA,
     "Options: ",
     MENU {
	  TO (inducedMap => Verify),
	  TO (inducedMap => Degree)
	  },
     SEEALSO "inducesWellDefinedMap"
     }

document { (inducedMap => Degree),
     TT "Degree => n", " -- an option to ", TO "inducedMap", " that provides the
     degree of the map produced."
     }

document { quote Verify,
     TT "Verify", " -- an option that can be used to request verification
     that a map is well defined.",
     PARA,
     MENU {
	  TO (inducedMap => Verify)
	  }
     }

document { (inducedMap => Verify),
     TT "Verify => true", " -- an option for ", TO "inducedMap", " which
     requests verification that the induced map produced is well defined."
     }


inducesWellDefinedMap = method()
inducesWellDefinedMap(Module,Module,Matrix) := (M,N,f) -> (
     sM := target f;
     sN := source f;
     if ambient M =!= sM
     then error "'inducesWellDefinedMap' expected target of map to be a subquotient of target module provided";
     if ambient N =!= sN
     then error "'inducesWellDefinedMap' expected source of map to be a subquotient of source module provided";
     (f * generators N) % (generators M) == 0
     and
     (f * relations N) % (relations M) == 0)     
inducesWellDefinedMap(Module,Nothing,Matrix) := (M,N,f) -> inducesWellDefinedMap(M,source f,f)
inducesWellDefinedMap(Nothing,Module,Matrix) := (M,N,f) -> inducesWellDefinedMap(target f,N,f)
inducesWellDefinedMap(Nothing,Nothing,Matrix) := (M,N,f) -> true

document { quote inducesWellDefinedMap,
     TT "inducesWellDefinedMap(M,N,f)", " -- tells whether the matrix ", TT "f", " would
     induce a well defined map from ", TT "N", " to ", TT "M", ".",
     SEEALSO "inducedMap"
     }

matrix(Ring,List) := options -> (R,m) -> (
     if not isTable m then error "expected a table";
     map(R^#m,,m,options))

map(Module,Module,Function) := options -> (M,N,f) -> (
     map(M,N,table(numgens M, numgens N, f))
     )

document { (map,Module,Module,Function),
     TT "map(M,N,f)", " -- creates a map from the module N to the module M whose
     matrix entries are obtained from the function f by evaluating f(i,j)"
     }

map(Matrix) := options -> (f) -> (
     if options.Degree === null then f
     else (
     	  R := ring source f;
	  d := options.Degree;
	  if class d === ZZ then d = {d};
     	  map(target f, source f ** R^{d - degree f}, f, options)))

map(Module,ZZ,Function) := options -> (M,n,f) -> map(M,n,table(numgens M,n,f),options)
map(Module,ZZ,List) := options -> (M,rankN,p) -> (
     if options.Degree =!= null
     then error "Degree option given with indeterminate source module";
     R := ring M;
     p = apply(splice p,splice);
     if #p != numgens M
     or #p > 0 and ( not isTable p or # p#0 != rankN )
     then error( "expected ", name numgens M, " by ", name rankN, " table");
     p = applyTable(p,x -> promote(x,R));
     m := new Matrix;
     m.target = M;
     coverM := cover M;
     m.handle = newHandle(
	  apply(
	       if # p === 0 then splice {rankN:{}}
	       else transpose p, 
	       col -> {apply(col, r -> ggPush r), ggPush coverM, ggvector}
	       ),
	  ggPush coverM,
	  ggPush rankN,
	  ggmatrix);
     m.source = ( sendgg(ggPush m,gggetcols); new Module from R );
     m)

TEST "
R = ZZ/101[x,y,z]
assert isHomogeneous map(R^2,2,(i,j)->R_j)
assert isHomogeneous map(R^2,5,{{x,y,z,x^2,y^2},{x,0,z,z^2,0}})
"

map(Module,Nothing,Matrix) := options -> (M,nothing,p) -> (
     R := ring M;
     coverM := cover M;
     n := numgens cover source p;
     colvectors := apply(n, i -> p_i);
     if options.Degree =!= null
     then error "Degree option given with indeterminate source module";
     m := new Matrix;
     m.target = M;
     m.handle = newHandle( colvectors / ggPush, ggPush coverM, ggPush n, ggmatrix);
     m.source = (sendgg(ggPush m,gggetcols); new Module from R);
     m
     )

map(Module,Nothing,List) := map(Module,Module,List) := options -> (M,N,p) -> (
     R := ring M;
     if N === null
     then (
	  k := R;
	  if #p === 0 then error "expected non-empty list of entries for matrix";
	  rankN := #p#0;
	  )
     else (
     	  k = ring N;
     	  try promote(1_k,R) else error "modules over incompatible rings";
	  -- later, allow a ring homomorphism
	  rankN = numgens N;
	  );
     p = apply(splice p,splice);
     if #p != numgens M
     or #p > 0 and ( not isTable p or # p#0 != rankN )
     then error( "expected ", name numgens M, " by ", name rankN, " table");
     p = applyTable(p,x -> promote(x,R));
     m := new Matrix;
     m.target = M;
     coverM := cover M;
     m.handle = newHandle(
	  apply(
	       if # p === 0 then splice {rankN:{}}
	       else transpose p, 
	       col -> {apply(col, r -> ggPush r), ggPush coverM, ggvector}
	       ),
	  ggPush coverM,
	  if N === null
	  then (
	       if options.Degree =!= null
	       then error "Degree option given with indeterminate source module";
	       ggPush rankN
	       )
	  else (
	       ggPush cover N,
	       ggPush (
		    if options.Degree === null
	       	    then toList (degreeLength R:0)
	       	    else degreeCheck(options.Degree,R)
		    )
	       ),
	  ggmatrix);
     m.source = (
     	  if N === null then (sendgg(ggPush m,gggetcols); new Module from R)
     	  else N
	  );
     m)

fixDegree := (m,d) -> (
     M := target m;
     N := source m;
     R := ring M;
     sendgg (
	  ggPush cover M,
	  ggPush cover N,
	  ggPush m, 
	  ggPush degreeCheck(d,R),
	  ggmatrix);
     newMatrix(M,N)
     )

Matrix.matrix = options -> (f) -> concatBlocks f

matrixTable := options -> (f) -> (
     types := unique apply(flatten f, class);
     if # types === 1 then (
	  type := types#0;
	  if instance(type,Ring) then (
	       R := type;
	       map(R^#f,, f, options))
	  else if type.?matrix then (type.matrix options)(f)
	  else error "no method for forming a matrix from elements of this type")
     else if all(types, T -> instance(T,Ring)) then (
	  R = ring (
	       try sum apply(types, R -> R#0)
	       else error "couldn't put matrix elements into the same ring"
	       );
	  map(R^#f,,f,options))
     else if all(types, T -> instance(T,Ring) or T === Matrix) then (
	  rings := unique apply(select(flatten f,m -> class m === Matrix), ring);
	  if #rings > 1 then error "matrices over different rings";
	  R = rings#0;
	  f = apply(f, row -> new MutableList from row);
	  m := #f;
	  n := #f#0;
	  tars := new MutableHashTable;
	  srcs := new MutableHashTable;
	  scan(m, i->scan(n, j-> (
			 r := f#i#j;
			 if class r === Matrix then (
			      if tars#?i and tars#i != target r
			      then error "matrices not compatible";
			      tars#i = target r;
			      if srcs#?i and srcs#i != source r
			      then error "matrices not compatible";
			      srcs#j = source r;
			      ))));
	  scan(m, i->scan(n, j-> (
			 r := f#i#j;
			 if instance(class r,Ring) and r != 0 then (
			      r = R#0 + r;
			      d := degree r;
			      if tars#?i then (
				   M := tars#i;
				   if srcs#?j then (
					N := srcs#j;
					if apply(degrees M, e -> e + d) =!= degrees N 
					then error ("matrices not compatible");
					f#i#j = map(M,N,r))
				   else (
					srcs#j = N = M ** R^{-d};
					f#i#j = map(M,N,r)))
			      else (
				   if srcs#?j then (
					N = srcs#j;
					tars#i = M = N ** R^{d};
					f#i#j = map(M,N,r))
				   else (
					tars#i = M = R^1;
					srcs#j = N = R^{-d};
					f#i#j = map(M,N,r)))))));
	  scan(m, i->scan(n, j-> (
			 r := f#i#j;
			 if r == 0 then (
			      if tars#?i then (
				   M := tars#i;
				   if srcs#?j then (
					N := srcs#j;
					f#i#j = map(M,N,0);)
				   else (
					srcs#j = M;
					f#i#j = map(M,M,0); ) )
			      else (
				   if srcs#?j then (
					N = srcs#j;
					tars#i = N;
					f#i#j = map(N,N,0);
					)
				   else (
					M = tars#i = srcs#j = R^1;
					f#i#j = map(M,M,0);
					))))));
	  mm := concatBlocks f;
	  if options.Degree === null
	  then mm
	  else fixDegree(mm,options.Degree)
	  )
     else error "expected ring elements or matrices")

document { quote matrix,
  TT "matrix(...)", " -- create a matrix.",
  PARA,
  "This function can be used to create a matrix or map (homomorphism) between
  modules, but it is complicated because there are many different ways it can
  be used.  The entries of the matrix can be provided as a list of lists of ring
  elements, or as a function which accepts row and column indices.  The ring of
  the matrix can be provided explicitly, or the source and target modules can be 
  provided.  There are other alternatives.",
  PARA,
  "Various ways to use ", TT "matrix", ":",
  MENU {
       TO (matrix, List),
       TO (matrix,Matrix),
       TO (matrix,Ring,List)
       },
  "Optional arguments, valid with each form above:",
  MENU {
       (TO "Degree", " -- specify the degree of the resulting map."),
       },
  RETURNS "Matrix",
  SEEALSO {"map"}
  }

document { "making module maps",
     "There are several different ways to use ", TO "map", " to make maps
     maps between modules.  In all case, if a matrix is provided, and the
     modules are subquotient modules, then the matrix is understood to be
     formed with respect to generators of the subquotient modules.",
     PARA,
     MENU {
	  TO (map,Matrix),
	  TO (map,Module),
       	  TO (map,Module,Module),
       	  TO (map,Module,Module,List),
       	  TO (map,Module,Module,Function),
       	  TO (map,Module,Module,Matrix),
       	  TO (map,Module,RingElement),
       	  TO (map,Module,Nothing,List),
       	  TO (map,Module,ZZ,List),
       	  TO (map,Module,ZZ,Function),
       	  TO (map,Module,Matrix),
	  TO (map,Module,Module,RingElement),
	  TO (map,Module,Module,ZZ),
	  TO (map,ChainComplex,ChainComplex,Function),
	  },
     SEEALSO {"map", "matrix"}
     }

matrix(Matrix) := options -> (m) -> (
     if isFreeModule target m and isFreeModule source m
     and ring source m === ring target m
     then m
     else map(cover target m, cover source m ** ring target m, m, Degree => degree m)
     )

document { (map,Matrix),
     TT "map(f, Degree => d)", " -- make a map of degree d from a map f
     of modules by tensoring the source module with a free module of
     rank 1 and appropriate degree."
     }

document { (matrix,Matrix),
     TT "matrix f", " -- produce the matrix of a map f.",
     PARA,
     "If the source and target of f are free, then the result is
     f itself.  Otherwise, the source and target will be replaced by
     the free modules whose basis elements correspond to the generators
     of the modules.",
     SEEALSO {"map", "matrix"}
     }

document { (matrix,Ring,List),
     TT "matrix(R,v)", " -- create a matrix over R from a doubly-nested list of
     ring elements or matrices.",
     PARA,
     "This is essentially the same as ", TO (matrix,List), " together with
     the specification of the ring.",
     PARA,
     EXAMPLE {
	  "R = ZZ/101[a..f]",
      	  "matrix(R, {{a,b,0},{d,0,f}})",
	  },
     SEEALSO {"map", "matrix"}
     }

document { (map,Module,Module),
     TT "map(M,N)", " -- constructs the natural map from N to M.",
     PARA,
     "The modules M and N should be subquotient modules of the same
     free module",
     SEEALSO {"map", "isWellDefined"}
     }

document { (map,Module,Matrix),
     TT "map(M,p)", " -- recasts a matrix p to a map whose target is M by
     tensoring p with a graded free module of rank 1.",
     PARA,
     EXAMPLE {
	  "R = ZZ/101[x,y]",
      	  "p = matrix{{x,y}}",
      	  "q = map(R^{3},p)",
      	  "degrees target q",
      	  "degrees source q",
	  },
     SEEALSO {"map", "matrix"}
     }

document { (map,Module,Module,List),
     TT "map(M,N,v)", " -- produces a map (matrix) from the module N
     to the module M whose entries are obtained from the doubly-nested list
     v of ring elements.",
     PARA,
     EXAMPLE {
	  "R = ZZ/101[x,y,z]",
      	  "p = map(R^2,R^{-2,-2},{{x^2,0},{0,y^2}})",
      	  "isHomogeneous p",
	  },
     SEEALSO {"map", "matrix"}
     }
document { (map,Module,Module,Matrix),
     TT "map(M,N,p)", " -- recasts the matrix p as a map (matrix) from
     the module N to the module M.",
     PARA,
     EXAMPLE {
	  "R = ZZ/101[x,y,z]",
      	  "p = matrix {{x,y,z}}",
      	  "q = map(R^1,R^3,p)",
      	  "degrees source p",
      	  "degrees source q",
	  },
     SEEALSO {"map", "matrix"}
     }
document { (map,Module,Module,RingElement),
     TT "map(M,N,r)", " -- construct a map from a module ", TT "N", " to ", TT "M", " which is provided
     by the ring element ", TT "r", ".",
     PARA,
     "If ", TT "r", " is nonzero, then ", TT "M", " and ", TT "N", " should be equal, 
     or at least have the same number of generators.",
     PARA,
     EXAMPLE {
	  "R = ZZ/101[x]",
      	  "map(R^2,R^3,0)",
      	  "map(R^2,R^2,x)",
      	  "q = map(R^2,R^2,x,Degree=>1)",
      	  "isHomogeneous q",
	  },
     PARA,
     SEEALSO {(map,Module,Module,ZZ), "map", "matrix"}
     }
document { (map,Module,Module,ZZ),
     TT "map(M,N,k)", " -- construct a map from a module ", TT "N", " to ", TT "M", " 
     which is provided by the integer ", TT "k", ".",
     PARA,
     "If ", TT "k", " is ", TT "0", ", then the zero map is constructed.  If ", TT "k", " is 1,
     then ", TT "M", " and ", TT "N", " should have the same number and degrees of generators 
     in the sense that the modules ", TT "cover M", " and ", TT "cover N", " are equal, and then the map
     which sends the ", TT "i", "-th generator of ", TT "N", " to the ", TT "i", "-th generator 
     of ", TT "M", " is constructed (and it may not be well-defined).
     Otherwise, ", TT "M", " and ", TT "N", " should be equal, or 
     at least have the same number of generators.",
     PARA,
     EXAMPLE {
	  "R = QQ[x,y];",
	  "M = image vars R",
	  "N = coker presentation M",
	  "f = map(M,N,1)",
	  "isWellDefined f",
	  "isIsomorphism f",
	  "g = map(M,cover M,1)",
	  "isWellDefined g",
	  "isIsomorphism g",
	  "h = map(cover M,M,1)",
	  "isWellDefined h",
	  },
     PARA,
     SEEALSO {(map,Module,Module,RingElement), "map", "matrix"}
     }
document { (map,Module),
     TT "map M", " -- construct the identity map from M to itself.",
     PARA,
     "This can also be accomplished with ", TT "id_M", " or ", TT "map(M,1)", ".",
     SEEALSO {"map", "id"}
     }
document { (map,Module,RingElement),
     TT "map(M,r)", " -- construct the map from M to itself which is provided
     by scalar multiplication by the ring element r.",
     PARA,
     EXAMPLE {
	  "R = ZZ/101[x]",
      	  "map(R^2,x)",
	  },
     SEEALSO {"map", "matrix"}
     }
document { quote Degree,
     TT "Degree => d", " -- an optional argument to ", TO "matrix", " that
     specifies that the degree of the map created should be ", TT "d", ".",
     PARA,
     "The degree may be an integer or a list of integers (multidegree).  The
     length of the list should be the same as the length of a degree for the
     ring, see ", TO "degreeLength", ".",
     PARA,
     EXAMPLE {
	  "R = ZZ/101[x]",
      	  "p = map(R^1, R^1, {{x^4}})",
      	  "isHomogeneous p",
      	  "q = map(R^1, R^1, {{x^4}}, Degree => 4)",
      	  "isHomogeneous q",
	  },
     SEEALSO {"map", "matrix", (inducedMap => Degree)}
     }

document { (map,Module,ZZ,Function),
     TT "map(M,n,f)", " -- construct a map from a free graded module of
     rank n to M whose entries are obtained from the function f by 
     evaluating f(i,j).",
     PARA,
     "The degrees of the basis elements of the source module are chosen
     in an attempt to ensure that the resulting map is homogeneous of
     degree zero."
     }

document { (map,Module,ZZ,List),
     TT "map(M,n,v)", " -- construct a map from a free graded module of
     rank n to M whose entries are in the doubly nested list v.",
     PARA,
     "The degrees of the basis elements of the source module are chosen
     in an attempt to ensure that the resulting map is homogeneous of
     degree zero."
     }

document { (map,Module,Nothing,List),
     TT "map(M,,v)", " -- construct a map from a free graded module to M
     whose entries are obtained from the doubly-nested list v of
     ring elements.",
     PARA,
     "The absence of the second argument indicates that the source of the map
     is to be a free module constructed with an attempt made to assign degrees
     to its basis elements so as to make the map homogeneous of degree zero.",
     PARA,
     EXAMPLE {
	  "R = ZZ/101[x,y]",
      	  "f = map(R^2,,{{x^2,y^2},{x*y,0}})",
      	  "degrees source f",
      	  "isHomogeneous f",
	  },
     SEEALSO {"map", "matrix"}
     }

matrix(List) := options -> (m) -> (
     if #m === 0 then error "expected nonempty list";
     m = apply(splice m,splice);
     types := unique apply(m,class);
     if #types === 1 then (
	  type := types#0;
	  if instance(type,Module) 
	  then map(type,,table(numgens type, #m, (i,j) -> m_j_i))
	  else if type === List then (
	       if isTable m then (matrixTable options)(m)
	       else error "expected rows all to be the same length"
	       )
	  else error "expected a table of ring elements or matrices")
     else error "expected a table of ring elements or matrices")
document { (matrix,List),
     TT "matrix v", " -- create a matrix from a doubly-nested list of
     ring elements or matrices, or from a list of (column) vectors.",
     PARA,
     "An attempt is made to coerce the ring elements and matrices to
     a common ring.  If the entries are ring elements, they are used as
     the entries of the matrix, and if the entries are matrices, then
     they are used to provide blocks of entries in the resulting matrix.",
     PARA,
     "An attempt is made to set up the degrees of the generators of the
     free module serving as source so that the map will be homogeneous and of
     degree zero.",
     PARA,
     EXAMPLE {
	  "R = ZZ/101[x,y,z]",
      	  "p = matrix {{x,y,z}}",
      	  "degrees source p",
      	  "isHomogeneous p",
	  },
     "Notice that the degrees were set up so that p is homogeneous, because
     the source module is not explicitly specified by the user.  The next
     example involves block matrices.",
     EXAMPLE {
	  "q = vars R",
      	  "matrix {{q,q,q}}",
      	  "matrix {{q},{q},{q}}",
	  },
     "Here we construct a matrix from column vectors.",
     EXAMPLE {
	  "F = R^3",
      	  "matrix {F_2, F_1, x*F_0 + y*F_1 + z*F_2}",
	  },
     SEEALSO {"map", "matrix"}
     }

--------------------------------------------------------------------------

Module#id = (M) -> map(M,1)

document { quote id,
     TT "id_M", " -- the identity homomorphism from M to M.",
     PARA,
     "M may be a ", TO "Module", " or a ", TO "ChainComplex", ".",
     PARA,
     SEEALSO{"Matrix", "ChainComplexMap", "ScriptedFunction"}
     }

reshape = (F, G, m) -> (
     if not isFreeModule F or not isFreeModule G
     then error "expected source and target to be free modules";
     sendgg(ggPush m, ggPush F, ggPush G, ggreshape);
     getMatrix ring m)
document { quote reshape,
     TT "reshape(F,G,m)", " -- reshapes the matrix m to give a map from G to F.",
     PARA,
     "It yields the matrix obtained from ", TT "m", " of shape F <--- G, by
     taking elements from the first row of ", TT "m", ", then the second, and
     so on, filling them into the result row by row.  Currently, it is assumed
     that ", TT "m", " and the result both have the same number of entries.
     The resulting map is always of degree zero."
     }

TEST "
R=ZZ/101[a..d]
f = matrix {{a}}
assert( isHomogeneous f )

g = reshape(R^1, R^{-1}, f)
assert isHomogeneous g
"

-- adjoint1:  m : F --> G ** H ===> F ** dual G --> H
-- adjoint:   m : F ** G --> H ===> F --> dual G ** H
adjoint1 = (m,G,H) -> reshape(H, (source m) ** (dual G), m)
document { quote adjoint1,
     TT "adjoint1 (f,G,H)", " -- if f is a homomorphism of free modules of the
     form F -> G ** H, then produce the adjoint homomorphism of the
     form F ** (dual G) -> H.",
     SEEALSO "adjoint"
     }
adjoint =  (m,F,G) -> reshape((dual G) ** (target m), F, m)
document { quote adjoint,
     TT "adjoint (f,F,G)", " -- if f is a homomorphism of free modules of the
     form F ** G -> H, then produce the adjoint homomorphism of the
     form F -> (dual G) ** H.",
     SEEALSO "adjoint1"
     }

flatten Matrix := m -> (
     R := ring m;
     F := target m;
     G := source m;
     if not isFreeModule F or not isFreeModule G
     then error "expected source and target to be free modules";
     if numgens F === 1 
     then m
     else reshape(R^1, G ** dual F ** R^{- degree m}, m))

flip = (F,G) -> (
  sendgg(ggPush F, ggPush G, ggflip);
  getMatrix ring F)
document { quote flip,
     TT "flip(F,G)", " -- yields the matrix representing the map F ** G --> G ** F."
     }

subquotient(Nothing,Matrix) := (null,relns) -> (
     M := new Module of Vector;
     M.ring = ring relns;
     E := target relns;
     M.handle = handle E;
     relns = matrix relns;
     if E.?generators then (
	  M.generators = E.generators;
	  relns = E.generators * relns;
	  );
     if E.?relations then relns = relns | E.relations;
     if relns != 0 then M.relations = relns;
     M.numgens = (sendgg (ggPush M.handle, gglength); eePopInt());
     M#0 = (sendgg(ggPush M, ggzero); new M);
     M)
subquotient(Matrix,Nothing) := (subgens,null) -> (
     M := new Module of Vector;
     E := target subgens;
     subgens = matrix subgens;
     if E.?generators then subgens = E.generators * subgens;
     M.handle = E.handle;
     M.generators = subgens;
     if E.?relations then M.relations = E.relations;
     M.ring = ring subgens;
     M.numgens = (sendgg (ggPush M.handle, gglength); eePopInt());
     M#0 = (sendgg(ggPush M, ggzero); new M);
     M)
subquotient(Matrix,Matrix) := (subgens,relns) -> (
     E := target subgens;
     if E != target relns then error "expected maps with the same target";
     M := new Module of Vector;
     M.ring = ring subgens;
     M.handle = handle E;
     M.numgens = (sendgg (ggPush M.handle, gglength); eePopInt());
     M#0 = ( sendgg(ggPush M, ggzero); new M);
     if M == 0 then M
     else (
	  relns = matrix relns;
	  subgens = matrix subgens;
	  if E.?generators then (
	       relns = E.generators * relns;
	       subgens = E.generators * subgens;
	       );
	  if E.?relations then relns = relns | E.relations;
	  M.generators = subgens;
	  if relns != 0 then M.relations = relns;
	  M))
document { quote subquotient,
     TT "subquotient(f,g)", " -- given matrices f and g with the same target, 
     produces a new module representing the image of f in the cokernel
     of g.",
     PARA,
     "The columns of f are called the generators, and the columns of
     g are the relations.",
     PARA,
     "Functions:",
     MENU {
	  {TO "generators", " -- recover the generators"},
	  {TO "relations", "  -- recover the relations"},
	  {TO "prune", "      -- convert to a module with presentation"}
	  },
     "This is the general form in which modules are represented, and
     subquotient modules are often returned as values of computations.",
     EXAMPLE {
	  "R = ZZ/101[a..d]",
      	  "M = kernel vars R ++ cokernel vars R",
      	  "generators M",
      	  "relations M",
      	  "prune M",
	  },
     SEEALSO {"generators", "relations"}
     }

Matrix ** Matrix := (f,g) -> (
     R := ring target f;
     if ring target g =!= R 
     or ring source g =!= ring source f
     then error "expected matrices over the same ring";
     sendgg (ggPush f, ggPush g, ggtensor);
     h := getMatrix R;
     map(target f ** target g, source f ** source g, h, Degree => degree f + degree g))

document { (quote **, Matrix, Matrix),
     TT "f ** g", " -- computes the tensor product of two matrices.",
     PARA,
     SEEALSO "Matrix"
     }

TEST "
ZZ[t]
assert (matrix {{t}} ** matrix {{t}} == matrix{{t^2}})
"

Matrix ** RingElement := (f,r) -> f ** matrix {{r}}
RingElement ** Matrix := (r,f) -> matrix {{r}} ** f
RingElement ** RingElement := (r,s) -> matrix {{r}} ** matrix {{s}}

AfterPrint Matrix := AfterNoPrint Matrix := f -> (
     << endl;				  -- double space
     << "o" << lineNumber() << " : Matrix";
     if isFreeModule target f and isFreeModule source f
     then << " " << target f << " <--- " << source f;
     << endl;
     )

precedence Matrix := x -> precedence quote x

compactMatrixForm = true

document { quote compactMatrixForm,
     TT "compactMatrixFormat", " -- a global flag which specifies whether to display
     matrices in compact form.",
     PARA,
     "The default value is ", TT "true", ".  The compact form is the form used by
     ", ITALIC "Macaulay", ", in which the multiplication and exponentiation operators
     are suppressed from the notation.",
     EXAMPLE {
	  "R = ZZ[x,y];",
	  "f = random(R^{2},R^2)",
	  "compactMatrixForm = false;",
	  "f"
	  }
     }

net Matrix := f -> (
     if f == 0 
     then "0"
     else if compactMatrixForm then (
	  R := ring target f;
	  m := verticalJoin toSequence apply(
	       lines sendgg(ggPush f,ggsee,ggpop), x -> concatenate("| ",x,"|"));
	  if degreeLength R > 0 -- and isHomogeneous f
	  then m = horizontalJoin(verticalJoin(degrees cover target f / name), " ", m);
	  m)
     else net expression f				    -- add row labels somehow
     )

image Matrix := f -> (
     if f.?image then f.image else f.image = subquotient(f,)
     )
coimage Matrix := f -> (
     if f.?coimage then f.coimage else f.coimage = cokernel map(source f, kernel f)
     )
cokernel Matrix := m -> (
     if m.?cokernel then m.cokernel else m.cokernel = subquotient(,m)
     )

cokernel RingElement := f -> cokernel matrix {{f}}
image RingElement := f -> image matrix {{f}}

Ideal = new Type of MutableHashTable
expression Ideal := (I) -> new FunctionApplication from { 
     ideal,
     (
	  v := expression toSequence first entries generators I;
     	  if #v === 1 then v#0 else v
	  )
     }
net Ideal := (I) -> (
     if numgens I === 0 then "0"
     else net expression I
     )
name Ideal := (I) -> name expression I

isHomogeneous Ideal := (I) -> isHomogeneous I.generators
genera(Ideal) := (I) -> genera module I
euler(Ideal) := (I) -> euler module I

RingElement * Ideal := (r,I) -> ideal (r ** generators I)
ZZ * Ideal := (r,I) -> ideal (r * generators I)

generators Ideal := (I) -> I.generators
mingens Ideal := options -> (I) -> mingens(module I,options)
Ideal / Ideal := (I,J) -> module I / module J
Module / Ideal := (M,J) -> M / (J * M)

AfterPrint Ideal := AfterNoPrint Ideal := (I) -> (
     << endl;				  -- double space
     << "o" << lineNumber() << " : Ideal of " << ring I << endl;
     )

Ideal ^ ZZ := (I,n) -> ideal symmetricPower(n,generators I)
Ideal * Ideal := (I,J) -> ideal flatten (generators I ** generators J)
Ideal * Module := (I,M) -> subquotient (generators I ** generators M, relations M)
dim Ideal := I -> dim cokernel generators I
codim Ideal := I -> codim cokernel generators I
Ideal + Ideal := (I,J) -> ideal (generators I | generators J)
document { (quote +, Ideal, Ideal), 
     TT "I + J", " -- the sum of two ideals."
     }
degree Ideal := I -> degree cokernel generators I
trim Ideal := options -> (I) -> ideal trim(module I, options)
map(Ideal) := options -> (I) -> map(module I,options)
map(Ideal,Ideal) := options -> (I,J) -> map(module I,module J,options)
Ideal _ ZZ := (I,n) -> (generators I)_(0,n)
Matrix % Ideal := (f,I) -> f % gb I
numgens Ideal := (I) -> numgens source generators I
leadTerm Ideal := (I) -> leadTerm generators gb I
leadTerm(ZZ,Ideal) := (n,I) -> leadTerm(n,generators gb I)
jacobian Ideal := (I) -> jacobian generators I
poincare Ideal := (I) -> poincare module I
hilbertPolynomial Ideal := options -> (I) -> hilbertPolynomial(module I,options)

protect quote Order
assert( class infinity === InfiniteNumber )
hilbertSeries = method(Options => {
     	  Order => infinity
	  }
     )

hilbertSeries Ideal := options -> (I) -> hilbertSeries(module I,options)

TEST "
R = ZZ/101[x,y,z]
I = ideal(x,y)
assert( 1 == dim I )
assert( 2 == codim I )
"

document { quote Ideal,
     TT "Ideal", " -- the class of all ideals.",
     PARA,
     "The justification for considering an ideal I as different from a
     submodule M of R^1 is some methods are different.  For example, M^3 is a
     direct sum, whereas I^3 is still an ideal.  Similar remarks apply to
     ", TO "dim", " and ", TO "codim", ".",
     PARA,
     "Creating ideals:",
     MENU {
	  TO "annihilator",
	  TO "fittingIdeal",
	  TO "Grassmannian",
	  TO "ideal",
	  TO "quotient"
	  },
     "Operations on ideals:",
     MENU {
	  TO (quote +,Ideal,Ideal),
	  TO (quote *,Ideal, Ideal),
	  TO (quote ^,Ideal, ZZ),
	  TO "codim",
	  TO "decompose",
	  TO "dim",
	  TO "Fano",
	  TO "module",
	  TO "radical",
	  TO "removeLowestDimension",
	  TO "top"
	  }
     }

document { (quote *,Ideal,Ideal),
     TT "I * J", " -- the product of two ideals."
     }

document { (quote ^,Ideal,ZZ),
     TT "I^n", " -- the n-th power of an ideal I."
     }

ring Ideal := (I) -> I.ring

Ideal == Ring := (I,R) -> (
     if ring I =!= R
     then error "expected ideals in the same ring";
     1_R % I == 0)

Ring == Ideal := (R,I) -> I == R

Ideal == Ideal := (I,J) -> (
     if ring I =!= ring J
     then error "expected ideals in the same ring";
     ( I.generators == J.generators or 
	  -- if isHomogeneous I and isHomogeneous J  -- can be removed later
	  -- then gb I == gb J 
	  -- else
	  isSubset(I,J) and isSubset(J,I)	  -- can be removed later
	  ))

Ideal == Module := (I,M) -> module I == M
Module == Ideal := (M,I) -> M == module I

module = method()
module Ideal := submodule Ideal := I -> image I.generators

document { quote module,
     TT "module I", " -- produce the submodule of R^1 corresponding to an
     ideal I."
     }

ideal Matrix := (f) -> (
     R := ring f;
     if not isFreeModule target f or not isFreeModule source f 
     then error "expected map between free modules";
     f = flatten f;			  -- in case there is more than one row
     if target f != R^1 then (
     	  f = map(R^1,,f);
	  )
     else if not isHomogeneous f and isHomogeneous R then (
     	  g := map(R^1,,f);			  -- in case the degrees are wrong
     	  if isHomogeneous g then f = g;
	  );
     new Ideal from { quote generators => f, quote ring => R } )

ideal Module := (M) -> (
     F := ambient M;
     if isSubmodule M and rank F === 1 then ideal generators M
     else error "expected a submodule of a free module of rank 1"
     )
ideal List := ideal Sequence := v -> ideal matrix {toList v}
submodule List := submodule Sequence := v -> image matrix toList v
ideal RingElement := v -> ideal {v}
submodule(Vector) := (v) -> image matrix {v}
ideal ZZ := v -> ideal {v}
ideal QQ := v -> ideal {v}

document { quote submodule,
     TT "submodule (u,v,w)", " -- form the submodule generated by a sequence
     or list of elements of a module.",
     BR,NOINDENT,
     TT "submodule I", " -- form the submodule corresponding to an ideal."
     }

document { quote ideal,
     "ideal v", " -- produces the ideal spanned by a list or sequence of ring
     elements.",
     PARA,
     EXAMPLE {
	  "ZZ[a..i]",
      	  "ideal (c..h)"
	  },
     }

kernel = method(Options => {
	  SubringLimit => infinity
	  })

ker = kernel
document { quote ker,
     "See ", TO "kernel", "."
     }

document { quote kernel,
     TT "kernel f", " -- produces the kernel of a matrix or ring homomorphism.",
     PARA,
     "If f is a ring element, it will be interpreted as a one by one
     matrix.",
     PARA,
     "Options:",
     MENU {
	  TO "SubringLimit"
	  },
     PARA,
     "For an abbreviation, use ", TO "ker", "."
     }

document { quote SubringLimit,
     TT "SubringLimit => n", " -- an option for ", TO "kernel", " which
     causes the computation of the kernel of a ring map to stop after n
     elements have been discovered."
     }

kernel Matrix := options -> (g) -> if g.?kernel then g.kernel else g.kernel = (
     N := source g;
     P := target g;
     g = matrix g;
     if P.?generators then g = P.generators * g;
     h := modulo(g, if P.?relations then P.relations);
     if N.?generators then h = N.generators * h;
     subquotient( h, if N.?relations then N.relations))

kernel RingElement := options -> (g) -> kernel (matrix {{g}},options)

homology(Matrix,Matrix) := opts -> (g,f) -> (
     R := ring f;
     M := source f;
     N := target f;
     P := target g;
     if source g != N then error "expected maps to be composable";
     f = matrix f;
     if not all(degree f, i -> i === 0) then f = map(target f, source f ** R^{-degree f}, f);
     g = matrix g;
     if P.?generators then g = P.generators * g;
     h := modulo(g, if P.?relations then P.relations);
     if N.?generators then (
	  f = N.generators * f;
	  h = N.generators * h;
	  );
     subquotient(h, if N.?relations then f | N.relations else f))

document { (homology,Matrix,Matrix),
     TT "homology(g,f)", " -- computes the homology module ", TT "ker g/im f", ".",
     PARA,
     "Here ", TT "g", " and ", TT "f", " should be composable maps with ", TT "g*f", "
     equal to zero.",
     SEEALSO "homology"
     }

Hom(Matrix, Module) := (f,N) -> (
     if isFreeModule source f and isFreeModule target f
     then transpose f ** N
     else notImplemented())

Hom(Module, Matrix) := (N,f) -> (
     if isFreeModule N 
     then dual N ** f
     else notImplemented())

dual(Matrix) := f -> (
     R := ring f;
     Hom(f,R^1)
     )
document { (dual, Matrix),
     TT "dual f", " -- the dual (transpose) of a homomorphism."
     }

InverseMethod Matrix := m -> if m#?-1 then m#-1 else m#-1 = (
     id_(target m) // m
     )

singularLocus(Ring) := (R) -> (
     if not isAffineRing(R) then error "expected an affine ring";
     R / minors(codim R, jacobian presentation R))

singularLocus(Ideal) := (I) -> singularLocus(ring I / I)

document { quote singularLocus,
     TT "singularLocus R", " -- produce the singular locus of a ring,
     which is assumed to be integral and defined by a homogeneous ideal.",
     PARA,
     "Can also be applied to an ideal, in which case the singular locus of
     the quotient ring is returned."
     }

TEST "
     R=ZZ/101[x,y,z]

     assert( dim singularLocus ideal {y^2*z - x*(x - z)*(x + z) } === 0 )
     assert( dim singularLocus ideal {y^2*z - x*(x - z)*(x - z) } === 1 )

     S = ZZ/103[a..d]
     assert( dim singularLocus ideal { a^2 + b^2 + c^2 + d^2, a^2 + b^2 + 3*c^2 + 2*d^2 } === 1 )
     assert( dim singularLocus ideal { a^2 + b^2 + c^2 + d^2, a^2 + 5*b^2 + 3*c^2 + 2*d^2 } === 0 )
     "

Matrix _ Array := (f,v) -> f * (source f)_v
Matrix ^ Array := (f,v) -> (target f)^v * f
document { (quote ^,Matrix,Array),
     TT "f^[i,j,k]", " -- extract some rows of blocks from a matrix ", TT "f", ".",
     PARA,
     "The target of ", TT "f", " should be a direct sum, and the result is obtained by
     composition with the projection onto the sum of the components numbered
     ", TT "i, j, k", ".  Free modules are regarded as direct sums.",
     PARA,
     EXAMPLE {
	  "f = map(ZZ^2 ++ ZZ^2, ZZ^2, {{1,2},{3,4},{5,6},{7,8}})",
      	  "f^[0]",
      	  "f^[1]",
      	  "f^[1,0]",
	  },
     SEEALSO {submatrix, (quote ^,Module,Array), (quote _,Matrix,Array)}
     }

document { (quote _,Matrix,Array),
     TT "f_[i,j,k]", " -- extract some columns of blocks from a matrix ", TT "f", ".",
     PARA,
     "The source of ", TT "f", " should be a direct sum, and the result is obtained by
     composition with the inclusion into the sum of the components numbered
     ", TT "i, j, k", ".  Free modules are regarded as direct sums.",
     PARA,
     EXAMPLE {
	  "f = map(ZZ^2 ++ ZZ^2, ZZ^2, {{1,2},{3,4},{5,6},{7,8}})",
      	  "f^[0]",
      	  "f^[1]",
      	  "f^[1,0]",
	  },
     SEEALSO {submatrix, (quote _,Module,Array), (quote ^,Matrix,Array)}
     }

Matrix _ List := (f,v) -> (
     v = splice v;
     listZ v;
     submatrix(f,v)
     )

document { (quote _, Matrix, List),
     TT "f_{i,j,k,...}", " -- produce the submatrix of a matrix f consisting of 
     columns numbered i, j, k, ... .",
     PARA,
     "Repetitions of the indices are allowed.",
     PARA,
     "If the list of column indices is a permutation of 0 .. n-1, where n is
     the number of columns, then the result is the corresponding permutation
     of the columns of f.",
     PARA,
     EXAMPLE "R = ZZ/101[a..f];",
     EXAMPLE {
	  "p = matrix {{a,b,c},{d,e,f}}",
      	  "p_{1}",
      	  "p_{1,1,2}",
      	  "p_{2,1,0}",
	  },
     SEEALSO "_"
     }

Matrix ^ List := (f,v) -> (
     v = splice v;
     listZ v;
     submatrix(f,v,)
     )
document { (quote ^,Matrix,List),
     TT "f^{i,j,k,...}", " -- produce the submatrix of a matrix f consisting of 
     rows numbered i, j, k, ... .",
     PARA,
     "Repetitions of the indices are allowed.",
     PARA,
     "If the list of row indices is a permutation of 0 .. n-1, where n is
     the number of rows, then the result is the corresponding permutation
     of the rows of f.",
     PARA,
     EXAMPLE {
	  "R = ZZ/101[a..f]",
      	  "p = matrix {{a,b,c},{d,e,f}}",
      	  "p^{1}",
      	  "p^{1,0}",
	  },
     SEEALSO "^"
     }

entries = method()
entries Matrix := (m) -> (
     M := target m;
     R := ring M;
     N := source m;
     sendgg (ggPush m,
      	  apply(numgens M, i -> apply(numgens N, j -> (
		    	 ggdup, ggINT, gg i, ggINT, gg j, ggelem, ggINT, gg 1, ggpick
		    	 ))));
     RPop := R.pop;
     sendgg ggpop;
     r := reverse apply(numgens M, i -> reverse apply(numgens N, j -> RPop()));
     r)
document { quote entries,
     TT "entries f", " -- produces the matrix of the homomorphism f as a doubly
     nested list of ring elements.",
     PARA,
     EXAMPLE {
	  "R = ZZ/101[x,y,z]",
      	  "p = matrix {{x^2,y^2},{x*y*z, x^3-y^3}}",
      	  "entries p"
	  },
     }
TEST"
R=ZZ/101[a..f]
p = {{a,b},{c,d},{e,f}}
assert( entries matrix p == p )
"

TEST "
R = ZZ/101[a .. r]
assert ( genericMatrix(R,a,3,6) == genericMatrix(R,a,3,6) )
ff = genericMatrix(R,a,3,6)
fff = genericMatrix(R,a,3,6)
assert( # expression ff == 3 )
assert( ff == matrix {{a,d,g,j,m,p},{b,e,h,k,n,q},{c,f,i,l,o,r}} )
assert( -ff == matrix {
	  {-a,-d,-g,-j,-m,-p},
	  {-b,-e,-h,-k,-n,-q},
	  {-c,-f,-i,-l,-o,-r}} )
assert( 2*ff == matrix {
	  {2*a,2*d,2*g,2*j,2*m,2*p},
	  {2*b,2*e,2*h,2*k,2*n,2*q},
	  {2*c,2*f,2*i,2*l,2*o,2*r}} )
assert( ff != 0 )
assert( ff - ff == 0 )
assert( transpose ff - matrix{{a,b,c},{d,e,f},{g,h,i},{j,k,l},{m,n,o},{p,q,r}} == 0 )
--assert( transpose ff == matrix{{a,b,c},{d,e,f},{g,h,i},{j,k,l},{m,n,o},{p,q,r}} ) -- mike will fix.  DRG: these are not equal: they have different degrees...
--assert( ff_0 == vector {a,b,c} )
--assert( ff_1 == vector {d,e,f} )
--assert( ff_2 == vector {g,h,i} )
M = cokernel ff
assert ( ff === presentation M )		  -- original map saved
assert ( cokernel ff === M )		  -- cokernel memoized
-- gbTrace 3
-- << \"gb ff ...\" << flush
G = gb ff
pM = poincare M
MM = cokernel fff
MM.poincare = pM
-- << \"gb fff (with poincare provided) ...\" << flush
GG = gb fff

assert( numgens source generators G == numgens source generators GG )
T := (ring pM)_0
assert ( pM == 3-6*T+15*T^4-18*T^5+6*T^6 )
assert ( gb ff === G )
assert ( numgens source generators G == 41 )
assert ( numgens source mingens G == 6 )
time C = resolution M
assert( C === resolution M )
-- betti C
time D = resolution cokernel leadTerm generators G
-- betti D
"

getshift := (f) -> (
     sendgg(ggPush f, gggetshift);
     eePopIntarray())

degree(Matrix) := (f) -> (
     M := source f;
     N := target f;
     d := getshift f;
     if M.?generators then d = d - getshift M.generators;
     if N.?generators then d = d + getshift N.generators;
     d)

promote(Matrix,ZZ) := (f,ZZ) -> (
     if ring f === ZZ then f
     else error "can't promote");
promote(Matrix,QQ) := (f,QQ) -> (
     if ring f === QQ then f
     else matrix applyTable(entries f, r -> promote(r,QQ)));

super(Matrix) := (f) -> (
     M := target f;
     if M.?generators then map(super M, M, M.generators) * f
     else f
     )

isInjective Matrix := (f) -> kernel f == 0
isSurjective Matrix := (f) -> cokernel f == 0

document { quote isInjective,
     TT "isInjective f", " -- tells whether the ring map or module
     map f is injective.",
     SEEALSO "isSurjective"
     }

document { quote isSurjective,
     TT "isSurjective f", " -- tells whether the map f of modules is
     surjective",
     SEEALSO "isInjective"
     }

TEST "
R = ZZ/101[a]
assert isInjective R^2_{0}
assert not isInjective R^2_{0,0}
assert isSurjective R^2_{0,0,1}
assert not isSurjective R^2_{1}
"


scan({ZZ}, S -> (
	  lift(Matrix,S) := (f,S) -> (
	       -- this will be pretty slow
	       if ring target f === S then f
	       else if isQuotientOf(ring f,S) and
		       isFreeModule source f and
		       isFreeModule target f then
		   map(S^(-degrees target f), S^(-degrees source f), 
		       applyTable(entries f, r -> lift(r,S)))
	       else matrix(S, applyTable(entries f, r -> lift(r,S)))
	       );
	  lift(Ideal,S) := (I,S) -> (
	       -- this will be pretty slow
	       if ring I === S then I
	       else
		   (ideal lift(I.generators,S)) +
		   ideal (presentation ring I ** S));
	  ));

content(RingElement) := content(Matrix) := (f) -> (
     R := ring f;
     n := numgens R;
     k := coefficientRing R;
     trim ideal lift((coefficients(splice {0..n-1},f))#1, k))

document { quote content,
     TT "content f", " -- returns the content of a matrix or polynomial.",
     PARA,
     "The content is the ideal of the base ring generated by the 
     coefficients."
     }

cover(Matrix) := (f) -> matrix f

rank Matrix := (f) -> rank image f
