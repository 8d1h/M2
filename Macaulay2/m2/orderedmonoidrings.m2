--		Copyright 1994 by Daniel R. Grayson

terms := quote terms
PolynomialRing = new Type of EngineRing
options PolynomialRing := R -> options monoid R

isPolynomialRing = method()
isPolynomialRing Thing := x -> false
isPolynomialRing PolynomialRing := (R) -> true

document { quote isPolynomialRing,
     TT "isPolynomialRing R", " -- tells whether R is a polynomial ring."
     }

document { quote PolynomialRing,
     TT "PolynomialRing", " -- denotes the class of all ordered monoid rings.",
     PARA,
     "If R is a ring and M is an ordered monoid, then R M denotes
     the ordered monoid ring constructed from them.",
     PARA,
     "If r is an element of R and m is an element of M
     then r m denotes the corresponding element of R M,
     provided R M has already been constructed.",
     PARA,
     "Elements of these rings are displayed with the monoid
     elements appearing in decreasing order from left to right.",
     PARA,
     "Operations on rings:",
     MENU {
	  TO "modifyRing",
	  TO "numgens",
	  TO "vars"
	  },
     "Operations on ring elements:",
     MENU {
	  TO quote +,
	  TO quote -,
	  TO quote *,
	  TO "coefficients",
	  TO "content",
	  TO "exponents",
	  TO "index",
	  TO "isPrime",
	  TO "isPrimitive",
	  TO "isUnit",
	  TO "leadComponent",
	  TO "leadCoefficient",
	  TO "leadMonomial",
	  TO "leadTerm",
	  TO "lift",
	  TO "liftable",
	  TO "listForm",
	  TO "promote",
	  TO "size",
	  TO "someTerms",
	  TO "standardForm",
	  TO "substitute",
	  TO "terms"
	  },
     PARA,
     "Producing ring elements:",
     MENU {
	  TO "random"
	  },
     PARA,
     "Keys used:",
     MENU {
  	  TO "ring",
	  TO "degreesRing"
	  },
     SEEALSO {"OrderedMonoid", "RingElement"},
     }

exponents RingElement := (f) -> listForm f / ( (monom,coeff) -> monom )

document { quote isUnit,
     TT "isUnit r", " -- determines whether a ring element is a unit.",
     PARA,
     EXAMPLE {
	  "S = QQ[x,y]/(1-(x-1)*(y-1));",
	  "isUnit (x^2 - 2*x + 1)"
	  }
     }

document { quote exponents,
     TT "exponents m", " -- for a monomial ", TT "m", " provides the list
     of exponents.",
     TT "exponents f", " -- for a polynomial ", TT "f", " provides a list
     whose elements are the lists of exponents of the terms of ", TT "f", ".",
     EXAMPLE {
	  "R = ZZ/101[x,y,z];",
      	  "exponents (x^2 - 7 + x*y*z^11 + y)"
	  },
     }

name PolynomialRing := R -> name R.baseRings#-1 | name monoid R
expression PolynomialRing := R -> (
     if R.?name then R.name
     else (expression R.baseRings#-1) (expression monoid R)
     )
net PolynomialRing := R -> (
     if R.?name then R.name
     else (net R.baseRings#-1) | (net monoid R)
     )

degreeLength PolynomialRing := (RM) -> degreeLength monoid RM

degreesRing2 := memoize(
     (n) -> (
	  Zn := degreesMonoid n;
	  ZZn := ZZ Zn;
	  ZZn.name = "ZZ[" | Zn.name | "]";
--	  ZZn.handle = newHandle (ggPush ZZ, ggPush Zn, ggpolyring);
--	  ZZn.pop = () -> eePop ConvertList ConvertJoin(Zn.ConversionFormat, ConvertInteger);
--	  ggPush ZZn := x -> (
--	       if # x === 0 then (ggPush ZZn, ggPush 0, ggfromint)
--	       else (
--		    apply(list x, (m,c) -> (
--		    	      ggPush ZZn, 
--			      ggPush ZZ, ggPush c, ggfromint, 
--			      ggPush m, ggterm)),
--		    #x-1:ggadd));
     	  use ZZn			  -- this doesn't actually set any global variables
	  ))

degreesRing ZZ := n -> degreesRing2 n

degreesRing PolynomialRing := R -> (
     if R.?degreesRing then R.degreesRing
     else degreesRing degreeLength R)

document { quote degreesRing,
     TT "degreesRing n", " -- produce the ring in n variables whose monomials
     are to be used to represent degrees in another ring with multi-degrees
     of length n",
     BR,NOINDENT,
     TT "degreesRing R", " -- produce the ring in n variables whose
     monomials are the degrees of elements of R.",
     PARA,
     "Elements of this ring are used as Poincare polynomials for modules
     over R.",
     SEEALSO "poincare"
     }

generators PolynomialRing := R -> R.generators
isHomogeneous PolynomialRing := R -> true
coefficientRing PolynomialRing := R -> R.baseRings#-1

standardForm = method()
standardForm RingElement := (f) -> (
     RM := ring f;
     if not isPolynomialRing RM then error "expected a polynomial";
     -- was: convert(RM.standardForm, sendgg(ggPush f, ggtonet))
     c := coefficients f;
     new HashTable from apply(
	  first entries c#0 / leadMonomial / standardForm,
	  first entries lift(c#1, coefficientRing RM),
	  identity))

document { quote standardForm,
     TT "standardForm f", " -- converts a polynomial or monomial to a
     form involving hash tables.",
     PARA,
     "A polynomial is represented by hash tables in which the keys are
     hash tables representing the monomials and the values are the 
     coefficients.",
     PARA,
     "The monomials themselves are represented by hash tables 
     in which the keys are the variables and the values are the 
     corresponding exponents.",
     EXAMPLE {
	  "R = ZZ/101[x,y,z];",
      	  "standardForm (x^2 - 7 + x*y*z^11 + y)"
	  },
     }

listForm = method()
listForm RingElement := (f) -> (
     RM := ring f;
     if not isPolynomialRing RM then error "expected a polynomial";
     -- was: convert(RM.listForm, sendgg(ggPush f, ggtonet))
     c := coefficients f;
     apply(
	  first entries c#0 / leadMonomial / exponents,
	  first entries lift(c#1, coefficientRing RM),
	  identity))

document { quote listForm,
     TT "listForm f", " -- converts a polynomial or monomial to a form
     represented by nested lists.",
     PARA,
     "A monomial is represented by the list of its exponents.",
     PARA,
     "A polynomial is represented by lists of pairs (m,c), one for each
     term, where m is a list of exponents for monomial, and c is the
     coefficient.",
     EXAMPLE {
	  "R = ZZ/101[x,y,z];",
      	  "listForm (x^2 - 7 + x*y*z^11 + y)"
	  },
     }

lcm2 := (x,y) -> x*y//gcd(x,y)
lcm := args -> (
     n := 1;
     scan(args, i -> n = lcm2(n,i));
     n)
commden := (f) -> (
     lcm apply(
	  first entries lift((coefficients f)#1, QQ),
	  denominator))

Ring OrderedMonoid := (			  -- no memoize
     (R,M) -> (
	  if not (M.?Engine and M.Engine) 
	  then error "expected ordered monoid handled by the engine";
	  if not (R.?Engine and R.Engine) 
	  then error "expected coefficient ring handled by the engine";
	  Weyl := M.Options.WeylAlgebra =!= {};
	  RM := if not Weyl then (
	       new PolynomialRing from (ggPush R, ggPush M, ggpolyring)
	       )
	  else (
	       diffs := M.Options.WeylAlgebra;
	       if class diffs === Option 
	       then diffs = {diffs}
	       else if class diffs =!= List 
	       then error "expected list as WeylAlgebra option";
	       diffs = apply(diffs, x -> (
			 if not ((class x === Option or class x === List) and #x === 2)
			 then error "expected x=>dx or {x,dx}";
			 if class x#0 === Sequence and class x#1 === Sequence
			 then (
			      if #(x#0) =!= #(x#1)
			      then error "expected sequences of the same length";
			      x = mingle x;
			      )
			 else x = toList x;
			 x));
	       diffs = flatten diffs;
	       diffs = apply(diffs, x -> (
			 x = baseName x;
			 if M.index#?x
			 then M.index#x
			 else error "expected a variable of the ring"));
	       new PolynomialRing from (ggPush R, ggPush M, ggPush diffs, ggweylalgebra)
	       );
	  RM.isCommutative = not Weyl and M.Options.SkewCommutative === false;
	  RM.baseRings = append(R.baseRings,R);
     	  ONE := RM#1;
	  if degreeLength M != 0 then (
	       -- there must be something smarter to do, but if we
	       -- do not do this, then we get into an infinite loop
	       -- because each monoid ring ZZ[a,b,c] needs its degrees ring
	       -- ZZ[t], which in turn needs to make its degrees ring 
	       -- ZZ[], which in turn needs one.
	       RM.degreesRing = degreesRing degreeLength M;
	       )
	  else (
	       RM.degreesRing = ZZ;
	       );
	  if R.?char then RM.char = R.char;
	  RM.monoid = M;
	  RM ? RM := (f,g) -> (
	       if f == g then quote ==
	       else leadMonomial f ? leadMonomial g
	       );
	  R * M := (r,m) -> (
	       sendgg(ggPush RM, ggPush r, ggPush m, ggterm);
	       new RM);
	  M * R := (m,r) -> (
	       sendgg(ggPush RM, ggPush r, ggPush m, ggterm);
	       new RM);
	  RM * M := (p,m) -> p * (R#1 * m);
	  M * RM := (m,p) -> (R#1 * m) * p;
	  M / RM := (m,f) -> (m * ONE) / f;
	  M / R := (m,r) -> (m * ONE) / (r * ONE);
	  RM / M := (f,m) -> f / (m * ONE);
	  R / M := (r,m) -> (r * ONE) / (m * ONE);
	  M % RM := (m,f) -> (m * ONE) % f;
	  M % R := (m,r) -> (m * ONE) % (r * ONE);
	  RM % M := (f,m) -> f % (m * ONE);
	  R % M := (r,m) -> (r * ONE) % (m * ONE);
	  R + M := (r,m) -> r * M#1 + R#1 * m;
	  M + R := (m,r) -> r * M#1 + R#1 * m;
	  RM + M := (p,m) -> p + R#1 * m;
	  M + RM := (m,p) -> p + R#1 * m;
	  R - M := (r,m) -> r * M#1 - R#1 * m;
	  M - R := (m,r) -> R#1 * m - r * M#1;
	  RM - M := (p,m) -> p - R#1 * m;
	  M - RM := (m,p) -> R#1 * m - p;
	  RM _ M := (f,m) -> (
	       sendgg(ggPush f, ggPush m, gggetcoeff);
	       R.pop()
	       );
	  RM.ConvertToExpression = ConvertApply(
	       args -> (
		    if # args === 1 
		    then args#0
		    else Sum toList args
		    ),
	       ConvertRepeat ConvertApply ( 
		    (m,r) -> r * m,
		    ConvertJoin(M.ConvertToExpression, R.ConvertToExpression)));
	  expression RM := f -> convert(
	       RM.ConvertToExpression,
	       sendgg(ggPush f, ggtonet)
	       );
	  name RM := x -> name expression x;
	  net RM := x -> net expression x;
	  fac := options -> f -> (
	       sendgg(ggPush f, ggfactor);
	       new Product from 
	       apply(eePopInt(), i -> (
			 exp := eePopInt();
			 fact := RM.pop();
			 Power{fact,exp})));
	  factor RM := if R === QQ then (
	       options -> f -> (
		    error "factorization over QQ not implemented yet";
	       	    d := commden f;
		    f = d * f;
		    new Divide from { (fac options)(f), d }
		    )
	       )
	  else fac;
	  isPrime RM := f -> (
	       v := factor f;		  -- constant term always last
	       #v === 2 and v#1#1 === 1 and v#0#1 === 1
	       );
	  RM.generatorSymbols = M.generatorSymbols;
	  RM.generatorExpressions = M.generatorExpressions;
	  RM.generators = apply(M.generators, m -> RM#(name m) = RM#0 + m);
	  scan(keys R, k -> if class k === String then RM#k = promote(R#k,RM));
	  RM.use = x -> (
	       M + M := (m,n) -> R#1 * m + R#1 * n;
	       M - M := (m,n) -> R#1 * m - R#1 * n;
	       - M := (m,n) -> - R#1 * n;
	       scan(RM.baseRings, A -> (
		    if A =!= R then (
		    	 A * M := (i,m) -> (i * R#1) * m;
		    	 M * A := (m,i) -> m * (i * R#1);
			 );
		    A + M := (i,m) -> i * ONE + m * ONE;
		    M + A := (m,i) -> m * ONE + i * ONE;
		    A - M := (i,m) -> i * ONE - m * ONE;
		    M - A := (m,i) -> m * ONE - i * ONE;
		    M / A := (m,r) -> (m * ONE) / (r * ONE);
		    A / M := (r,m) -> (r * ONE) / (m * ONE);
		    M % A := (m,r) -> (m * ONE) % (r * ONE);
		    A % M := (r,m) -> (r * ONE) % (m * ONE);
		    ));
	       RM);
	  RM
	  )
     )

document { (quote " ",Ring, OrderedMonoid),
     TT "R M", " -- produces the monoid ring from a ring ", TT "R", " and an ordered monoid
     ", TT "M", ".",
     SEEALSO {"Ring", "OrderedMonoid"}
     }

document { quote WeylAlgebra,
     TT "WeylAlgebra", " -- an option used when creating a polynomial ring
     to specify that a Weyl algebra is to be produced.",
     PARA,
     "A Weyl algebra is an algebra in which some of the variables behave
     as derivatives with respect to the other variables.",
     PARA,
     EXAMPLE "R = ZZ/101[x,dx,y,dy,WeylAlgebra => {x=>dx, y=>dy}];",
     "The list ", TT "{x=>dx, y=>dy}", " indicates that the variable ", TT "dx", "
     is to play the role of the derivative with respect to ", TT "x", ", and
     that ", TT "y", " is to play the role of the derivative with respect
     to ", TT "y", ".",
     EXAMPLE {
	  "dx*x",
      	  "dx*x^10",
      	  "dx*y^10"
	  }
     }

samering := (f,g) -> (
     if ring f =!= ring g then error "expected elements from the same ring";
     )

Ring Array := (R,variables) -> use R monoid variables

document { (quote _, RingElement, RingElement),
     TT "f_m", " -- provide the coefficient of the monomial m in the polynomial f.",
     PARA,
     EXAMPLE {
	  "ZZ[y];",
      	  "((1+y)^5) _ (y^2)",
	  },
     SEEALSO {"_"}
     }

document { (quote _, Ring, String),
     TT "R_\"x\"", " -- produce the indeterminate of the polynomial ring R 
     whose name is x.",
     PARA,
     EXAMPLE {
	  "R = ZZ[x,y,z];",
      	  ///R_"x"///,
	  },
     PARA,
     "Eventually we will implement this for monoids, too."
     }

PolynomialRing _ List := (RM,v) -> (
     k := coefficientRing RM;
     M := monoid RM;
     1_k * M_v
     )

document { (quote _, Ring, ZZ),
     TT "R_i", " -- produce the ", TT "i", "-th generator of a ring ", TT "R", ".",
     PARA,
     EXAMPLE {
	  "R = ZZ[a..d]",
      	  "R_2"
	  }
     }

Ring _ List := (R,w) -> product(#w, i -> (R_i)^(w_i))

document { (quote _, Ring, List),
     TT "R_w", " -- produce the monomial of the ring ", TT "R", " by using the 
     integers in the list ", TT "w", " as exponents of the variables.",
     PARA,
     EXAMPLE {
	  "R = ZZ[a..d]",
      	  "R_{1,2,3,4}"
	  }
     }

dim PolynomialRing := R -> dim R.baseRings#-1 + # generators R

TEST "
-- test name
R = ZZ/101[a..e]
f = symmetricPower(2,vars R)
assert( f == value name f )
"

char PolynomialRing := (R) -> char coefficientRing R
