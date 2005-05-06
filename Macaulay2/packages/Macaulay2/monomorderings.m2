----------- File Irena is Working on!  Taken from Mike.  ---------------------


document {
     Key => "polynomial rings",
     "Create a polynomial ring using the usual mathematical notation.",
     EXAMPLE {
	  "R = QQ[x,y,z];",
          "R",
	  },
     "Notice that after assignment to a global variable, Macaulay 2
     knows the ring's name, and this name is used when printing the ring.",
     "The original description of the ring can be recovered
     with ", TO "describe", ".",
     EXAMPLE "describe R",
     "Use the following subscript notation to obtain 0,1, or any multiple of 1,
     as elements in the ring.",
     EXAMPLE {
	  "0_R",
      	  "1_R",
      	  "11_R",
	  },
     "Obtain the variables (generators) of the ring by subscripting the name of 
     the ring.  As always in Macaulay 2, indexing starts at 0.",
     EXAMPLE "R_0^10+R_1^3+R_2",
     "The number of variables is provided by ", TO "numgens", ".",
     EXAMPLE {
	  "numgens R",
      	  "apply(numgens R, i -> R_i^i)",
      	  "sum(numgens R, i -> R_i^i)"
	  },
     "(for more information, see ", TO "apply", " and ", TO "sum", ". ",
     "Use ", TO "generators", " to obtain a list of the variables of the ring.",
     EXAMPLE "gens R",
     "A (one row) matrix containing the variables of the ring can be obtained
     using ", TO (vars,Ring), ".",
     EXAMPLE "vars R",
     "The ", TO "index", " of a variable:",
     EXAMPLE {
	  "index x, index y, index z",
	  },
     "The coefficient ring can be recovered with ", TO "coefficientRing", ".",
     EXAMPLE "coefficientRing R",

     "A random homogeneous element can be obtained with ", TO "random", ".",
     EXAMPLE "random(2,R)",

     "A basis of the subspace of ring elements of a given degree can be obtained
     in matrix form with ", TO "basis", ".",
     EXAMPLE "basis(2,R)",

     "We may construct polynomial rings over polynomial rings.",
     EXAMPLE "ZZ[a,b,c][d,e,f];",
     "When displaying an element of an iterated polynomial ring,
     parentheses are used to organize the coefficients recursively, which
     may themselves be polynomials.",
     EXAMPLE "(a+d+1)^2",

     "Variable names may be words.",
     EXAMPLE {
	  "QQ[rho,sigma,tau];",
      	  "(rho - sigma)^2",
	  },
     "There are various other ways to specify the variables in a polynomial
     ring.  A sequence of variables can be obtained as follows.",
     EXAMPLE "ZZ[b..k];",
     "In this example, if you had previously assigned either b or k a value that
     was not a ring generator, then Macaulay 2 would complain about this: it would
     no longer understand what variables you wanted.  To get around this, we could
     either do",
     EXAMPLE "ZZ[symbol b .. symbol k];",
     "or we may obtain the single-letter variables with ", TO "vars", ".",
     EXAMPLE {
	  "vars (0..4)",
      	  "ZZ[vars (0..4),vars(26..30),vars 51]",
	  },
     "Subscripted variables can be used, provided the base for the subscripted
     variable has not been used for something else.",
     EXAMPLE "ZZ[t,p_0,p_1,q_0,q_1];",
     "Sequences of subscripted variables can also be used.",
     EXAMPLE {
      	  "ZZ[p_(0,0) .. p_(2,1),q_0..q_5]",
	  "(p_(0,0)+q_2-1)^2",
	  },
     "The subscripts can be much more general, but care is required when using
     symbols as subscripts, for the symbols may acquire values later that would
     interfere with your original use of them as symbols.  Thus you should
     protect symbols that will be used in this way.",
     EXAMPLE {
	  "protect xx; protect yy; protect zz;",
      	  "ZZ[ee_[xx],ee_[yy],ee_[zz]]",
	  },
     PARA,NOINDENT,
     "Some things to watch out for when using polynomial rings:",
     UL {
	  SEQ ("Defining a ring twice gives different rings, as far as
	  Macaulay 2 is concerned:
     	 We use the strict comparison operator ", TO "===", " to	    
     	 demonstrate this.",     
     	 EXAMPLE "ZZ[a,b,c] === ZZ[a,b,c]",
     	 "Thus it is a good idea to assign a new ring to a variable for
     	 future reference."),
	 SEQ ("OBSOLETE MonomialSize OBSOLETE
	 Variables in monomials are compacted into a smaller space
	 in the machine, for efficiency reasons."),
  SEQ ("Polynomial rings whose coefficient rings are polynomial rings
  can be very useful for organizing and extracting coefficients easily,
  but currently most computations cannot be done for these rings. This
  includes Groebner bases, and therefore all of the applications of
  Groebner bases.")
       }
     }

document {
     Key => "monomial orderings", 
     "Every polynomial ring in Macaulay 2 comes equipped with an ordering on
     the monomials.  See below for the definitions of all implemented
     orderings.  The default ordering is GRevLex, the graded reverse
     lexicographic order.",
     PARA,
     "Polynomials are displayed by ordering the monomials in decreasing order.
     The choice of monomial order can make a difference in the
     time and space required for various computations,
     especially Groebner basis computations.",
     PARA,
     Subnodes => {
	  TO "examples of specifying alternate monomial orders",
	  TO "monomial orders for free modules",
	  TO "operations involving monomial orders",
	  TO "packing monomials for efficiency",
      "Definitions of the specific monomial orders",
	  TO "definition of graded reverse lexicographic order: GRevLex",
	  TO "definition of lexicographic order: Lex",
	  TO "definition of weight orders: Weights",
	  TO "definition of elimination orders: Eliminate",
	  TO "definition of group lexicographic order: GroupLex",
	  TO "definition of group reverse lexicographic order: GroupRevLex",
	  TO "definition of product (block) orders",
	  TO "definition of reverse lexicographic order: RevLex",
	  TO "definition of non-commutative lexicographic order: NCLex",
      "Developers corner",
	  TO "obtaining the monomial order of a ring"
	  }
     }

document {
     Key => "examples of specifying alternate monomial orders",
     "For definitions of these monomial orders, see ", 
     TO "GRevLex,", TO " Lex,", TO " Weights,", TO " Eliminate,", TO " GroupLex,",
     TO " GroupRevLex,", TO " product orders,", TO " RevLex,", TO " NCLex.",
     HEADER2 "Graded reverse lexicographic order",
     EXAMPLE {
	  "R = ZZ[a..d];",
	  "a+b^100+c*d"
	  },
     HEADER2 "Lexicographic order",
     EXAMPLE {
	  "R = ZZ[a..d, MonomialOrder=>Lex];",
	  "a+b^100+c*d"
	  },
     HEADER2 "Weight order",
     EXAMPLE {
	  "R = ZZ[a..d, MonomialOrder => Weights => {201,2}];",
	  "a+b^100+c*d"
	  },
     HEADER2 "Graded lexicographic order",
     EXAMPLE {
	  "R = ZZ[a..d, MonomialOrder=>{Weights=>4:1,Lex}];",
	  "a+b^100+c*d"
	  },
     HEADER2 "Elimination order",
     "To use an elimination order, which eliminates the first 2 variables,
     use",
     EXAMPLE {
	  "R = ZZ[a..f, MonomialOrder=>Eliminate 2];",
	  "a+b^100+c*d"
	  },
     "Alternatively, use a weight vector",
     EXAMPLE {
	  "R = ZZ[a..f, MonomialOrder=>Weights=>2:1];",
	  "a+b^100+c*d"
	  },
     HEADER2 "Product (block) order",
     "To make a product order where each block has the GRevLex order:",
     EXAMPLE {
	  "R = ZZ[a..f, MonomialOrder=>{2,4}];",
	  "a^2*(c+d) + b*(c^100+d^100)*(c + e + f)"
	  },
     "The orders in each block can be other orders as well.",
     EXAMPLE {
	  "R = ZZ[a..f, MonomialOrder=>{Weights=>2:1,Lex}]",
	  "a^2*(c+d) + b*(c^100+d^100)*(c + e + f)"
	  },
     HEADER2 "GroupLex",
     "This order is useful for making degree rings, and allows some
     variables to appear with negative exponent.",
     EXAMPLE {
	  "R = ZZ[a..f, MonomialOrder => GroupLex => 3];",
	  "a^-2*(c+d) + b*(c^100+d^100)*(c + e + f)"
	  },
     HEADER2 "GroupRevLex",
     "This order is useful for making degree rings, and allows some
     variables to appear with negative exponent.  Not implemented yet.",
     HEADER2 "RevLex",
     "Warning: this is not a well-ordering.",
     EXAMPLE {
	  "R = ZZ[a..f, MonomialOrder=>RevLex];",
	  "a^2*(c+d) + b*(c^100+d^100)*(c + e + f)"
	  },
     HEADER2 "NCLex",
     "For non-commutative Groebner bases.  Not implemented yet.",
     }

document {
     Key => "monomial orders for free modules",
     }

document {
     Key => "operations involving monomial orders"
     }

document {
     Key => "packing monomials for efficiency",
     "Sometimes for efficiency reasons, it is important to pack exponent vectors 
     several exponents per machine word.  Polynomials take less space, and monomial 
     operations such as comparison and multiplication become faster.",
     PARA,
     "The monomial order keys ", TO "Lex", " and ", TO "GRevLex", " have alternate
     versions, which allow the packing of monomials 2 per machine word (LexSmall and
	  GRevLexSmall), and 4 per machine word (LexTiny and GRevLexTiny).",
     EXAMPLE {
	  "A = QQ[a..d,MonomialOrder=>Lex];",
	  "a^1000000000",
	  },
     "This exponent would give a monomial overflow error in the next ring",
     EXAMPLE {
	  "B = QQ[a..d,MonomialOrder=>LexSmall];",
  	  "C = QQ[a..d,MonomialOrder=>LexTiny];"
	  }
     }

document {
     Key => "definition of graded reverse lexicographic order: GRevLex",
     "The graded reverse lexicographic order is defined by: x^A > x^B if either
     the degree(x^A) > degree(x^B) or degree(x^A) = degree(x^B) and
     the LAST non-zero entry of the vector of integers A-B is NEGATIVE.",
     PARA,
     "This is the default order in Macaulay 2, in large part because it is often
     the most efficient order for use with Groebner bases.  By giving GRevLex
     a list of integers, one may change the definition of the order: deg(x^A) is
     the dot product of A with the argument of GRevLex.",
     EXAMPLE {
	  "R = QQ[a..d];",
	  "a^3 + b^2 + b*c",
	  "S = QQ[a..d, MonomialOrder => GRevLex => {1,2,3,4}];",
	  "a^3 + b^2 + b*c"
	  },
     "The largest possible exponent of variables in ", TT "GRevLex",
     " order is 2^31-1.  For efficiency reasons, the size of the exponents
     of variables may be restricted.  Then instead of ", TT "GRevLex", ", one can use ",
     TT " GRevLexSmall", ", which allows maximal exponent 2^15-1, 
     or ", TT "GRevLexTiny", ", which allows maximal exponent 2^7-1.", 
     EXAMPLE {
	  "B = QQ[a..d,MonomialOrder=>GRevLexSmall];",
	  "a^(2^15-1)",
  	  "C = QQ[a..d,MonomialOrder=>GRevLexTiny];",
	  "try a^(2^15-1) else \"failed\"",
	  "a^(2^7-1)"
	  },
     SeeAlso => {GRevLex, Weights}
     }

document {
     Key => "definition of lexicographic order: Lex",
     "The lexicographic order is defined by: x^A > x^B if the FIRST
     non-zero entry of the vector of integers A-B is POSITIVE.",
     EXAMPLE {
	  "R = QQ[a..d, MonomialOrder => Lex];",
	  "a^3 + a^2*b^2 + b*c"
	  },
     "The largest possible exponent of variables in ", TT "Lex",
     " order is 2^31-1.  For efficiency reasons, the size of the exponents
     of variables may be restricted.  Then instead of ", TT "Lex", ", one can use ",
     TT " LexSmall", ", which allows maximal exponent 2^15-1, 
     or ", TT "LexTiny", ", which allows maximal exponent 2^7-1.", 
     EXAMPLE {
	  "B = QQ[a..d,MonomialOrder=>LexSmall];",
	  "a^(2^15-1)",
  	  "C = QQ[a..d,MonomialOrder=>LexTiny];",
	  "try a^(2^15-1) else \"failed\"",
	  "a^(2^7-1)"
	  },
     "Any of these versions of ", TT "Lex", " order may be combined with
     a weight order given by a weight vector: x^A > x^B if
     weight(x^A) > weight(x^B) or if weight(x^A) = weight(x^B)
     and if the FIRST non-zero entry of the vector of integers A-B is POSITIVE.",
     EXAMPLE {
	  "B = QQ[a..d,MonomialOrder=>{Weights => {1,2,3,4}, LexSmall}];",
	  "a^2 + b+ c + b*d"
	  },
     SeeAlso => {Lex, Weights}
     }

document {
     Key => "definition of weight orders: Weights",
     "Given a list L of n integers, the weight order on a polynomial ring
     in n variables is defined by: x^A > x^B if A_1 L_1 + ... + A_n L_n
     > B_1 L_1 + ... + B_n L_n.",
     PARA,
     "The leading component of a polynomial
     under a weight order need not be a monomial.  When two monomials
     have the same weight, by default they are further distinguished
     with the GRevLex order.",
     EXAMPLE {
	  "R = QQ[a..d,MonomialOrder=>{Weights => {-1,2,3,4}}];",
	  "f = a^2 + b+ c^2 + b*d",
	  "leadTerm f",
	  },
     "However, we can retrieve the entire leading component with
     the command ", TT "leadTerm(1,f)",
     ". The plain ", TT "leadTerm f", " is in this case the same as ",
     TT "leadTerm(2,f)", ": they both use the full specification of
     the monomial ordering, first by
     weight and then by the ", TT "GRevLex", " order.  In contrast, ",
     TT "leadTerm(1,f)", "only distinguishes monomials by the first,
     i.e., weight, specification.",
     EXAMPLE {
	  "leadTerm(1,ideal(f))"
	  },
     "The weight order may be combined with further weight vectors,
     or with ", TT "Lex", ".",
     EXAMPLE {
	  "R = QQ[a..d,MonomialOrder=>{Weights => {1,2,3,4}, Weights => {2,4,2,1}}];",
	  "f = a^6 + b^3+ c^2",
	  "leadTerm(f)",
	  "leadTerm(1, ideal(f))",
	  "leadTerm(2, ideal(f))",
	  "leadTerm(3, ideal(f))",
	  },
     TT "leadTerm(3, ideal(f))", " uses both the specified weights and the ",
     TT "GRevLex", " order to calculate the leading component.",
     PARA,
     "When the number of weights is smaller than the number of variables,
     the remaining variables are given weight 0.
     In the following example, ", TT "c", " and ", TT "d",
     " have weight 0.",
     EXAMPLE {
	  "R = QQ[a..d,MonomialOrder=>{Weights => {1,2}, Lex}];",
	  "f = a^2 + b+ c^2 + b*d",
	  },
     SeeAlso => {Weights, leadTerm}
     }

document {
     Key => "definition of elimination orders: Eliminate",
     "The option ", TT "Eliminate => n",
     " is a shortcut for ", TT "Weights => {n:1}",
     " The remaining variables are given weight 0.",
     EXAMPLE {
       "R = QQ[a..i, MonomialOrder => Eliminate 3];",
       "R = QQ[a..i, MonomialOrder => {Eliminate 3,4,2}];",
       "I = ideal(a^3+e, a*b, e-f, a-b, f*c, a*b+e*c, i)"
       },
     "In the last example, the order is block order:
     the first four variables are in the first block, the
     subsequent 2 variables are in the second block,
     the remaining variables are in the third block,
     and the weights of the variables are 1,1,1,0,..., 0.",
     SeeAlso => {Weights, "definition of product (block) orders"},
     }

document {
     Key => "definition of product (block) orders",
     TT "MonomialSize => {n_1, ..., n_l}", " divides the variables of the
     ring into ", TT "l", " blocks, the first block consisting of the first ",
     TT "n_1", " variables, the second block consisting of the subsequent ",
     TT "n_2", " variables, and so on.  For each block of variables,
     we can compute the total degree of a monomial with respect to the
     variables in that block.  This gives a length ", TT "l",
     " vector of total degrees for each monomial.  We say
     x^A > x^B if the total degree vector of x^A is lexicographically
     greater than the total degree vector of x^B, or if the two
     total degree vectors are equal and if in the first block of
     variables where A and B differ, A > B in GRevLex order.",
     EXAMPLE {
	  "R = QQ[a..l, MonomialOrder => {3,3,3,3}];",
	  "a*e^3 + a^2*c*i + a*b^2*i + b^2*e*i"
	  },
     "We may replace ", TT "MonomialOrder => {3,3,3,3}",
     " with the shorter ", TT "MonomialOrder => {4:3}",
     PARA,
     "The default ", TT "GRevLex", " order on any block may be
     changed to other orders, as follows.",
     EXAMPLE {
	     "R = QQ[a..i, MonomialOrder => {Lex =>3,3:1,3}];",
	     "a*e^3 + a^2*c*i + a*b^2*i + b^2*e*i + d^2*f*h + d*e^2*h",
	  },
     }

document {
     Key => "definition of group lexicographic order: GroupLex",
     TT "MonomialOrder => GroupLex => n", " inverts the first ",
     TT "n", " variables in the polynomial ring.
     In the following example, ", TT "a^-1", " is in the ring,
     but ", TT "c^-1", " is not.",
     EXAMPLE {
	  "R = QQ[a..d, MonomialOrder=> GroupLex=>2];",
	  "a^-1",
	  "try c^(-1) else \"failed\"",
	  },
     Caveat => {"The element ", TT "a/b", " is in the fraction ring,
        while ", TT "a*b^(-1)", " belongs to ", TT "R", "."}
     }

document {
     Key => "obtaining the monomial order of a ring",
     "The monomial order of a ring is stored as an option in the monoid of the ring.",
     EXAMPLE {
	  "R = QQ[x_1 .. x_10, MonomialOrder=>{4,6}];",
	  "(monoid R).Options.MonomialOrder",
	  "S = QQ[a..d]",
	  "(monoid R).Options.MonomialOrder"
	  }
     }



document {
     Key => "monomial orderings1", 
     HEADER2 "The default monomial order: GRevLex",
     "Every polynomial ring in Macaulay 2 comes equipped with an ordering on
     the monomials.  The default ordering is GRevLex: the graded reverse lexicographic
     order. Suppose that m = x^A and n = x^B are monomials of a polynomial ring R having 
     r variables,
     where A = (a1, ..., ar) and B = (b1, ..., br) are exponent vectors.  Then 
     the GRevLex order is defined by: x^A > x^B if either x^A has higher degree
     than x^B, or the degrees are the same, and the LAST non-zero entry of A-B is NEGATIVE.",
     HEADER2 "Specifying alternate monomial orders",
     "We can choose different orderings of the monomials.  The
     choice of ordering can make a difference in the time taken in
     various computations.",
     EXAMPLE {
	  "R = ZZ[a..d];",
	  "a*d + b*c"     
     	  },
     "Notice that the monomials are displayed in descending monomial order .",
     HEADER2 "Examples of monomial orders",
     HEADER3 "Lex => n",
     EXAMPLE {
	  "R = ZZ[a..d, MonomialOrder => {Lex => 4}];",
	  "1+a+b+c+d+a*d+b*c"
	  },
     HEADER3 "Weights => {...}",
     EXAMPLE {
	  "R = ZZ[a..d,MonomialOrder => {Weights => {1,0,0,1}}];",
	  "1+a+b+c+d+a*d+b*c"
	  },
     "The explicit way to get GRevLex is given in the following example:",
     EXAMPLE {
	  "R = ZZ[a..d,MonomialOrder=>GRevLex]"
     },
     HEADER3 "GRevLex => {...}",
     HEADER3 "Position => Up or Position => Down",
     HEADER3 "GroupLex => n",
     HEADER3 "GroupRevLex => n",
     Subnodes => {
	  TO "examples of monomial orders",
	  TO "general monomial orders",
	  TO "term orders",
	  TO "local orders",
	  TO "negative exponents"
	  }
     }

TEST "
R = QQ[a..d, MonomialOrder => GRevLex]
a*c + b^2 + a*c^3
R = QQ[a..d, MonomialOrder => {GRevLex=>2, GRevLex=>2}]
a*c + b^2 + a*c^3
R = QQ[a..d, MonomialOrder => {2,2}]
a*c + b^2 + a*c^3
R = QQ[a..d, MonomialOrder => RevLex => 4]
1 + a*c + b^2 + a*c^3
a+a^2
"

document {
     Key => "monomial orderingsOLD",
     -- Defining the orders
     -- MonomialOrder option.  Currently: Weights option.
     -- Philosophy: each ring comes equipped with a monomial order.
     -- ProductOrder, Eliminate, Lex, RevLex, GRevLex...
     -- What are these order in free modules.  Point to the Schreyer order
     -- information, either in the manual, or in the overview.
     "We can make polynomial rings with various other orderings of the
     monomials used in storing and displaying the polynomials.  The
     choice of ordering can make a difference in the time taken in
     various computations.",
     PARA,
     "The material in this section will be completely redone soon.",
     PARA,
     "The default is to use the graded reverse lexicographic ordering 
     of monomials.
     This means that terms of higher total degree come first;
     and for two terms of the same degree, the term with the higher
     power of the last variable comes last; for terms with the same 
     power of the last variable, the exponent on the next to last 
     variable is consulted, and so on.",
     EXAMPLE {
	  "R=ZZ/101[a,b,c]",
      	  "(a+b+c+1)^2",
	  },
     "Explicit comparison of monomials with respect to the chosen
     ordering is possible.",
     EXAMPLE "b^2 > a*c",
     "The comparison operator ", TO "?", " returns a symbol indicating
     the result of the comparison: the convention is that the larger
     monomials are printed first (leftmost).",
     EXAMPLE "b^2 ? a*c",
     "The monomial ordering is also used when sorting lists with ", TO "sort", ".",
     EXAMPLE "sort {1_R, a, a^2, b, b^2, a*b, a^3, b^3}",
     "The next ring uses ", TO "MonomialOrder", " to specify reverse
     lexicographic ordering.  This means that the term with 
     the higher power of the last variable comes last; for terms with the same 
     power of the last variable, the exponent on the next to last variable 
     is consulted, and so on.  Under this ordering the monomials are not
     well ordered.",
     EXAMPLE "R=ZZ/101[x,y,z,MonomialOrder=>RevLex];",
     "We currently get a monomial overflow if we try to compute anything
     in this ring, sigh.",
     -- EXAMPLE "(x+y+z+1)^2",
     PARA,
     "The next ring uses graded lexicographic ordering.  This means that
     terms of higher total degree come first; for two terms of the
     same degree, the term with the higher power of the first variable comes
     first: for terms with the same power of the first variable the
     power of the second variable is consulted, and so on.",
     EXAMPLE {
	  "R=ZZ/101[a,b,c,MonomialOrder=>GLex];",
      	  "(a+b+c+1)^2",
	  },
     NOINDENT,
     "(Notice how similar the result above is to the one obtained when
     graded reverse lexicographic ordering is used.)",
     PARA,
     "The next ring uses lexicographic ordering.  This means that 
     terms with the highest power of the first variable come
     first: for two terms with the same power of the first variable the
     power of the second variable is consulted, and so on.",
     EXAMPLE {
	  "R=ZZ/101[a,b,c,MonomialOrder=>Lex];",
      	  "(a+b+c+1)^2",
	  },
     "The next ring uses an elimination order suitable for eliminating
     the first two variables, ", TT "a", " and ", TT "b", ".  In such an 
     ordering we want all terms in which either of the first two
     variables appears to come before all of those terms in which
     the first two variables don't appear.  This particular ordering
     accomplishes this by consulting first the graded reverse lexicographic
     ordering ignoring all variables but the first two, and in case of
     a tie, consulting the graded reverse lexicographic ordering of the
     entire monomials.",
     EXAMPLE {
	  "R=ZZ/101[a,b,c,MonomialOrder=>Eliminate 2];",
      	  "(a+b+c+1)^2",
	  },
     "The next ring uses the product ordering that segregates the
     first variable from the next two.  This means that terms come
     first that would come first in the graded reverse lexicographic
     ordering when their parts involving the
     second two variables are ignored, and in case of equality,
     the graded reverse lexicographic ordering of their parts involving
     just the next two variables is consulted.",
     EXAMPLE {
	  "R=ZZ/101[a,b,c,MonomialOrder=>ProductOrder{1,2}];",
      	  "(a+b+c+1)^2"
	  },
     PARA,
     "See ", TO "MonomialOrder", " for further details."
     }

document {
     Key => "graded and multigraded polynomial rings",
     "It is possible to set up a polynomial ring so that the degree of an
     element is a vector of integers.  For this, the option
     ", TO "Degrees", " is used, together with a list of degrees for the
     variables in the ring.  Each degree is itself a list of integers.  The
     degrees given must all be of the same length, and length zero is
     allowed, to get an ungraded ring.",
     EXAMPLE {
	  "R = ZZ/101[a,b,c,Degrees=>{{1,2},{2,1},{1,0}}]",
      	  "describe R",
	  },
     "STILL VALID??? At the moment there is a restriction on the degree vectors: the first
     entry must be greater than zero.  This restriction will be removed soon.",
     EXAMPLE {
	  "degree a",
      	  "degree b^2",
      	  "degree 0_R",
      	  "degree 1_R",
	  },
     "A random element of bi-degree ", TT "{m,n}", " can be obtained with
     ", TO "random", ".",
     EXAMPLE "random({15,15},R)",
     "The function ", TO "degree", " applied to a polynomial will
     return the least upper bound of the degrees of its monomials.",
     EXAMPLE "degree (a+b)",
     "We may recover the number of integers in each degree list for our ring
     as follows.",
     EXAMPLE {
	  "degreeLength R",
      	  "degreeLength ZZ"
	  },
     }

document {
     Key => "graded modules",
     -- Mike must have wanted a node with this name...
     }

document {
     Key => "constructing maps between modules",
	"Let's start with a free module.",
	EXAMPLE {
		"R = ZZ/5[x,y,z];",
		"F = R^3"
		},
	"A list of indices can be used to produce homomorphisms corresponding to the corresponding basis vectors.",
	EXAMPLE {
		"F_{0,1,2}",
		"F_{0,1}",
		"F_{1,2}"
		},
	"Matrices are viewed as linear transformations.",
	EXAMPLE {
		"f = matrix{{x,y,z}}"
		},
--     "The standard way to define a map from an R-module M to an 
--     R-module N is to give a matrix whose columns are the image vectors
--     of the generators of M.",
--     EXAMPLE {
--	  "R = QQ[x,y,z];",
--	  "m = cokernel vars R",
--	  "--F = map(m/m^2, R^1/m, {{x*y*z}})"
--	  }
     }

document {
     Key => "monomial orderings v1.0",
     "This section is only valid for Macaulay2, versions 1.0 and higher.",
     PARA,
     "Each ring in Macaulay2 comes equipped with an ordering on the
monomials.  This ordering is used in the display and storing of polynomials.
The choice of ordering can make a difference in the time taken in various
computations.  Groebner bases performed on ideals and modules will use the
chosen monomial ordering.",
     PARA,
     "The default is to use the graded lexicographic order.  This order is defined 
     as follows: x^A > x^B "
     }


document {
     Key => "what is a Groebner basis?",
     "A Groebner basis is a specific generating set
     of an ideal or submodule over a polynomial ring, not usually minimal, 
     which has extremely nice properties, from which 
     it is reasonably easy to extract information about the ideal or submodule.",
     "We first define and describe Groebner bases in the important special case
     of an ideal in a polynomial ring.  We then
     describe Groebner bases of submodules, and over more general rings.",
     PARA,
     TEX "Let $R = k[x_1, ..., x_n]$ be a polynomial ring, over a field k,
     and let I \\subset R be an ideal.  A term order on R is, by definition, a total
     order, >,  on the monomials of R, which satisfies two conditions: (1) 
     m > 1, for every monomial m \\neq 1, and (2) the order is multiplicative:
     m > n implies that mp > np, for all monomials m,n,p.",
     PARA,
     "In Macaulay 2, each ring has a multiplicative order associated with it.
     The default is the graded reverse lexicographic order:",
     EXAMPLE {
	  "R = QQ[a..d,MonomialOrder=>GRevLex]",
     	  "F = a^3 + d^2 + a*d + b*c + 1",
	  "R = QQ[a..d,MonomialOrder=>RevLex]",
	  "substitute(F,R)",
	  "R = QQ[a..d,MonomialOrder=>Lex]",
	  "substitute(F,R)",
	  "R = QQ[a..d,Weights=>{1,1,0,0}]",
	  "substitute(F,R)",
	  "R = QQ[a..d,Weights=>{-1,0,0,0}]",
	  "substitute(F,R)",
	  "R = QQ[a..d,Weights=>{-1,-1,-1,-1}]",
	  "substitute(F,R)",
	  "R = QQ[a..d,MonomialOrder=>ProductOrder{1,3}]",
	  "substitute(F,R)"},
     "Given a term order, the lead monomial is the term whose monomial is greatest
     in this order.",
     EXAMPLE "leadTerm F"          
     }

document {
     Key => "fine control of a Groebner basis computation",
     "Sometimes a Groebner basis computation doesn't finish quickly enough.  If so
     then this section might be of use. THIS PAGE IS UNDER CONSTRUCTION.",
     
	  SUBSECTION "Partially computed Groebner bases",
	       "Suppose that you have computed part of a Groebner basis.  For
	       example, you may have interrupted the computation using CTRL-C 
	       (typing 'c' while holding the CTRL key down, in emacs, you have to 
	       type CTRL-C twice), or you may have given options requesting only
	       partial computation.",
     	       EXAMPLE {
		    "R = ZZ/32003[a..e];",
	            "I = ideal(random(3,R),random(3,R),random(3,R))",
	            "gens gb(I,PairLimit=>7);"},
	       "Get the Groebner basis object:",
	       EXAMPLE {
		    "g = gb(I,StopBeforeComputation => true);",
	       	    "leadTerm gens g"},
	       "We can make a Groebner basis snapshot by using StopBeforeComputation:",
	       EXAMPLE {
		    "gbSnapshot = (I) -> gens gb(I,StopBeforeComputation => true);",
	            "leadTerm gbSnapshot(I)"}
--	  SUBSECTION ""
     }

///

gbRemove = method()
gbRemove Module := (M) -> remove((generators M).cache, {false,0})
gbRemove Ideal := (I) -> remove((generators I).cache, {false,0})
  -- PROBLEM: what about the other GB
  
R = QQ[a..d,Weights=>{-1,0,0,0}]
f = a+b^2+c^3-2*d^4+1+a*b*c*d
leadTerm f
leadCoefficient f
leadTerm(1,f)

M = image vars R
gbSnapshot(M)
gb(M,PairLimit=>2)
m1 = gbSnapshot(M)
--gb(M,PairLimit=>4)
--m1  -- This has changed!  We probably don't want that
    -- BUG: segmentation fault!!

///

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/m2 "
-- End:
