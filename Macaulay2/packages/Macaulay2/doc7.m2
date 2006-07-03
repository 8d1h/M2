--		Copyright 1993-1999 by Daniel R. Grayson
document {
     Key => (symbol _, Matrix, List),
     Headline => "select columns",
     Usage => "f_cols",
     Inputs => {
	  "f" => {"a matrix between free modules"},
	  "cols" => "a list of integers denoting the choice of columns",
	  },
     Outputs => {
	  {"the submatrix of ", TT "f", " corresponding to the columns ", TT "cols", "."}
	  },
     "This is the same as calling ", 
     TO2 ((submatrix,Matrix,VisibleList), TT "submatrix(f,cols)"), ".",
     EXAMPLE {
	  "R = QQ[a..f];",
	  "p = matrix {{a,b,c},{d,e,f}}",
      	  "p_{1}",
      	  "p_{1,2,0}"
	  },
     SeeAlso => {submatrix, (symbol ^, Matrix, List)}
     }
document {
     Key => (symbol ^, Matrix, List),
     Headline => "select rows",
     Usage => "f_rows",
     Inputs => {
	  "f" => {"a matrix between free modules"},
	  "rows" => "a list of integers denoting the choice of rows",
	  },
     Outputs => {
	  {"the submatrix of ", TT "f", " corresponding to the rows in the list ", TT "rows", "."}
	  },
     "This is the same as calling ", 
     TO2 ((submatrix,Matrix,VisibleList,VisibleList), TT "submatrix(f,rows,)"), ".",
     EXAMPLE {
	  "R = QQ[a..f];",
	  "p = matrix {{a,b,c},{d,e,f}}",
      	  "p^{1}",
      	  "p^{1,0}"
	  },
     SeeAlso => {submatrix, (symbol _, Matrix, List)}
     }
TEST ///
     R = ZZ[x_1..x_12,y]
     f = genericMatrix(R,3,4)
     assert(source (f_{1,2}) == R^{-1,-1})
     assert(target (f_{1,2}) == target f)
     M1 = (target f)/(y * target f)
     M2 = (source f)/(y * source f)
     g = map(target f,M2,f)
     h = map(M1,M2,f)
     k = submatrix(g, {1})
     assert(target k === target g)
     l = submatrix(h, {1})
     assert(target l === target h)
     assert(source l === R^{-1})
     m = submatrix(h, {1,2},{2,3})
     assert(target m === R^2)
     assert(source m === R^{2:-1})
     n = submatrix(h, {1,2}, )
     assert(target n === R^2)
     assert(source n === source h)
///
document {
     Key => (submatrix,Matrix,VisibleList,VisibleList),
     Headline => "select part of a matrix",
     Usage => "submatrix(f, rows, cols) or submatrix(f,,cols) or submatrix(f,rows,)",
     Inputs => { "f" => "a map between free modules",
	  "rows" => "a list of integers denoting the choice of rows.  
	            If omitted, use all rows",
	  "cols" => "a list of integers denoting the choice of columns.
	            If omitted, use all columns"},
     Outputs => {Matrix => {"the submatrix of ", TT "f", " corresponding to the lists ", TT "rows", 
	  " and ", TT "cols", ""}},
     "Yields an r by c matrix, where r is the length of the list of integers
     ", TT "rows", ", and c is the length of the list of integers ", TT "cols", ".  
     The ", TT "(i,j)", "-th entry of the result is ", TT "f_(rows_i, cols_j)", ".",
     PARA{},
     "Each ", TO "list of integers", " may contain ranges and repetitions, as in ", 
     TT "{3, 5..7, 3:0}",
     PARA{},
     "If ", TT "rows", " or ", TT "cols", " is omitted, all the corresponding indices are used.",
     PARA{},
     "Both ", TT "rows", " and/or ", TT "cols", " may contain duplicate values, 
     in which case the result will contain
     duplicate rows and/or columns.",
     EXAMPLE {
	  "R = ZZ/101[a .. o];",
      	  "f = genericMatrix(R, a, 3, 5)",
      	  "submatrix(f, {1,2,0}, {0..2, 4})",
	  },
     PARA{},
     EXAMPLE {"submatrix(f, {1,2}, )"},
     TT "submatrix(f,,cols)", " can be written as ", TT "submatrix(f,cols)", ", or ",
     TT "f_cols", ".",
     EXAMPLE {
	  "submatrix(f,,{0,1})",
	  "f_{0,1}"
	  },
     SeeAlso => {
	  (symbol_,Matrix,List),
	  (symbol^,Matrix,List),
	  (submatrix,Matrix,VisibleList),
	  (symbol_,Matrix,Array),
	  (symbol^,Matrix,Array),
	  },
     }
document {
     Key => (submatrix,Matrix,VisibleList),
     Headline => "select columns",
     Usage => "submatrix(f, cols)",
     Inputs => { "f" => "a map between free modules",
	  "cols" => "a list of integers denoting the choice of columns"},
     Outputs => {Matrix => {"the submatrix of ", TT "f", " corresponding to the columns ",
	        TT "cols", ""}},
     "Yields an r by c matrix, where r is the number of rows of ", TT "f", ", and 
     c is the length of the list of integers ", TT "cols", ".  
     The ", TT "(i,j)", "-th entry of the result is ", TT "f_(i, cols_j)", ".",
     PARA{},
     "The ", TO "list of integers", ", ", TT "cols", " may contain ranges and repetitions, as in ", 
     TT "{3, 5..7, 3:0}",
     PARA{},
     "If the list of column indices is a permutation of 0 .. n-1, where n is
     the number of columns, then the result is the corresponding permutation
     of the columns of f.",
     EXAMPLE {
	  "R = ZZ/101[a .. o];",
      	  "f = genericMatrix(R, a, 3, 5)",
      	  "submatrix(f, {1..3,0})",
	  },
     SeeAlso => {
	  (symbol_,Matrix,List),
	  (symbol^,Matrix,List),
	  (symbol_,Matrix,Array),
	  (symbol^,Matrix,Array)
	  },
     }
document {
     Key => submatrix
     }
document {
     Key => (diff,RingElement,RingElement),
     Headline => "differentiation",
     Usage => "diff(x,f)",
     Inputs => {
	  "x" => "a polynomial",
	  "f" => {"a polynomial in the same ring as ", TT "x",}
	  },
     Outputs => {
	  {"the result of differentiating ", TT "f", " by the ",
	       TO2("differential operator corresponding to a polynomial", 
	       "differential operator"), " corresponding to ", TT "x", "."}
	  },
     "If ", TT "x", " is an indeterminate this is simply the usual differentiation.",
     EXAMPLE {
	  "R = QQ[x,y,z];",
	  "diff(x,x^7 + 4*x^3*y - 3*y)",
	  "diff(x^2+y^2+z^2, y^2*z^2 - x^3 - 1)",
	  },
     "Here is a shortcut that can save some typing.",
     EXAMPLE "diff_x x^6",
     SeeAlso => {
	  contract,
	  jacobian,
	  "differential operator corresponding to a polynomial",
	  "diff and contract"
	  },
     }
document {
     Key => (diff,RingElement,Matrix),
     Headline => "differentiate each entry of a matrix",
     Usage => "diff(x,f)",
     Inputs => {
	  "x" => "a polynomial",
	  "f" => {"a matrix between free modules over the same ring as ", TT "x",}
	  },
     Outputs => {
	  Matrix => {"having the same shape as f, whose (i,j) entry is the 
	       result of differentiating ", TT "f_(i,j)", " by the ",
	       TO2("differential operator corresponding to a polynomial",
	       "differential operator"), " corresponding to ", TT "x", "."}
	  },
     "The shape of the resulting matrix is the same as the shape of f, 
     but the degrees of the source module are different
     in an attempt to ensure that the result is homogeneous.",
     EXAMPLE {
	  "R = QQ[x,y,z];",
	  "f = matrix{{x^2-y*z, x*y*z + z^4}, {x-1, 2*y^2+z^2-1}}",
	  "diff(x,f)",
	  "diff(x^2-y*z,f)"
	  },
     SeeAlso => {
	  contract,
	  jacobian,
	  "differential operator corresponding to a polynomial",
	  "diff and contract"
	  },
     }
document {
     Key => (diff,Matrix,RingElement),
     Headline => "differentiation",
     Usage => "diff(f,g)",
     Inputs => {
	  "f" => "a matrix",
	  "g" => {"a polynomial with the same ring as ", TT "f",}
	  },
     Outputs => {
	  {"the result of differentiating ", TT "g", " by the ",
	       TO2("differential operator corresponding to a polynomial", 
	       "differential operator"), " corresponding to each entry of ", TT "f", "."}
	  },
     "The shape of the resulting matrix is the same as the shape of f, 
     but the degrees of the source module are different
     in an attempt to ensure that the result is homogeneous.",
     EXAMPLE {
	  "R = QQ[x,y,z,q];",
	  "f = vars R",
	  "diff(f, (x+y-z)^2)",
	  "f2 = genericMatrix(R,2,2)",
	  "diff(f2, (x+y-z)^2)"
	  },
     SeeAlso => {
	  contract,
	  jacobian,
	  "differential operator corresponding to a polynomial",
	  "diff and contract"
	  },
     }
document {
     Key => {(diff,Matrix,Matrix),(diff, Matrix, Vector),(diff, RingElement, Vector),(diff, Vector, Matrix),(diff, Vector, RingElement),(diff, Vector, Vector)},
     Headline => "differentiate a matrix by a matrix",
     Usage => "diff(m,n)",
     Inputs => {
	  "m" => {"a map ", TT "m : F <--- P", " between free modules of ranks f and p."},
	  "n" => {"a map ", TT "n : G <--- Q", " between free modules of ranks g and q."}
	  },
     Outputs => {
	  Matrix => {"with the shape ", TT "h : dual F ** G <--- dual P ** Q", ", whose entry in the slot ", TT {"h", SUB "g*i+j,q*k+l"}, "
	       is the result of differentiating ", TT { "n", SUB "j,l" }, " by the ",
	       TO2("differential operator corresponding to a polynomial", "differential operator"), " corresponding to  ", TT {"m", SUB "i,k", "."
		    }
	       }
	  },
     "The arguments ", TT "m", " and ", TT "n", " may also be vectors or ring elements.",
     TEST ///
	  R = ZZ[x]
	  m = random(R^2,R^{-1,-2,-3,-4,-5})
	  F = target m
	  f = rank F
	  P = source m
	  p = rank P
	  n = random(R^3,R^{-6,-7,-8,-9})
	  G = target n
	  g = rank G
	  Q = source n
	  q = rank Q
	  h = diff(m,n)
	  assert( source h === dual P ** Q )
	  assert( target h === dual F ** G )
	  scan(f, i -> scan(g, j -> scan(p, k -> scan(q, l -> assert( h_(g*i+j,q*k+l) === diff(m_(i,k),n_(j,l)))))))
	  ///,
     EXAMPLE {
	  "R = QQ[a,b,c][x,y,z]",
	  "m = transpose vars R",
	  "n = matrix{{x^2-a*y^3, x^3-z^2*y, x*y-b, x*z-c}}",
	  "diff(m,n)"
	  },
     SeeAlso => {
	  diff',
	  contract,
	  "differential operator corresponding to a polynomial",
	  "diff and contract"
	  }
     }
document {
     Key => (diff,ProjectiveHilbertPolynomial,ZZ),
     TT "diff(P,i)", " -- compute the i-th difference polynomial"
     }
document {
     Key => (diff, ProjectiveHilbertPolynomial),
     TT "diff P", " -- compute the difference polynomial."
     }
document {
     Key => diff,
     Headline => "differentiate or take difference",
     Usage => "diff(f,g) or diff(P) or diff(P,i)",
     "This function has two different uses.  The most common use is for differentiation:
     differentiate the second input by the first.",
     PARA{},
     "The second use, less common but sometimes useful, is to compute the difference
     polynomial of a Hilbert polynomial.",
     PARA{},
     "The arguments can also be ring elements or vectors.",
     EXAMPLE lines ///
     	  R = ZZ[x,y,z]
	  f = vars R ** vars R
	  diff(transpose vars R, f)
	  diff(x, f)
	  diff(y, f)
	  diff(z, f)
     ///,
     SeeAlso => {
	  "differential operator corresponding to a polynomial",
	  "diff and contract",
	  diff',
	  contract,
	  jacobian,
	  hilbertPolynomial
	  },
     Subnodes => {
	  "differentiation",
	  TO (diff,RingElement,RingElement),
	  TO (diff,RingElement,Matrix),
	  TO (diff,Matrix,RingElement),
	  TO (diff,Matrix,Matrix),
	  "difference operator for Hilbert polynomials",
	  TO (diff,ProjectiveHilbertPolynomial),
	  TO (diff,ProjectiveHilbertPolynomial,ZZ)
	  }
     }
document {
     Key => contract,
     Headline => "contract one matrix by another",
     SeeAlso => {"diff and contract",contract'}
     }

document {
     Key => {(contract,Matrix,Matrix),(contract,RingElement,RingElement), (contract,Vector,RingElement),
	  (contract,RingElement,Vector), (contract,Vector,Vector), (contract,Matrix,RingElement),
       	  (contract,RingElement,Matrix), (contract,Vector,Matrix), (contract,Matrix,Vector),
	  (contract,Number,RingElement), (contract,RingElement,Number), (contract,Number,Number), 
	  (contract,Number,Vector), (contract,Vector,Number), (contract,Number,Matrix),
     	  (contract,Matrix,Number)},
     Headline => "contract a matrix by a matrix",
     Usage => "h = contract(m,n)",
     Inputs => {
	  "m" => {"a map ", TT "m : F <--- P", " between free modules of ranks f and p."},
	  "n" => {"a map ", TT "n : G <--- Q", " between free modules of ranks g and q."}
	  },
     Outputs => {
	  "h" => {"the contraction of ", TT "n", " by ", TT "m", ", a matrix with the shape ", TT "h : dual F ** G <--- dual P ** Q", ", 
	       whose entry in the slot ", TT {"h", SUB "g*i+j,q*k+l"}, " is the result of contracting
	        ", TT { "n", SUB "j,l" }, ", by ", TT {"m", SUB "i,k"}
		}
	   },
     "The arguments can also be ring elements or vectors.",
     EXAMPLE lines ///
     	  R = ZZ[x,y,z]
	  f = vars R ** vars R
	  contract(transpose vars R, f)
	  contract(x, f)
	  contract(y, f)
	  contract(z, f)
     ///,
     TEST ///
	  R = ZZ[x]
	  m = random(R^2,R^{-1,-2,-3,-4,-5})
	  F = target m
	  f = rank F
	  P = source m
	  p = rank P
	  n = random(R^3,R^{-6,-7,-8,-9})
	  G = target n
	  g = rank G
	  Q = source n
	  q = rank Q
	  h = contract(m,n)
	  assert( source h === dual P ** Q )
	  assert( target h === dual F ** G )
	  scan(f, i -> scan(g, j -> scan(p, k -> scan(q, l -> assert( h_(g*i+j,q*k+l) === contract(m_(i,k),n_(j,l)))))))
	  ///,
     PARA{},
     "This function is identical to ", TO (diff,Matrix,Matrix), ", except that 
     the multiplication by integers that occurs during differentiation is
     omitted.",
     PARA{},
     SeeAlso => {contract', "diff and contract"}
     }

document { Key => {(contract', Matrix, Matrix),contract'},
     Headline => "contract a matrix by a matrix, the dual notion",
     Usage => "h = contract'(m,n)",
     Inputs => {
	  "m" => {"a map ", TT "m : F <--- P", " between free modules of ranks f and p."},
	  "n" => {"a map ", TT "n : G <--- Q", " between free modules of ranks g and q."}
	  },
     Outputs => {
	  "h" => {"a matrix with the shape ", TT "h : F ** dual G <--- P ** dual Q", ", whose entry in the slot ", TT {"h", SUB "g*i+j,q*k+l"}, "
	       is the result of contracting ", TT { "m", SUB "i,k" }, ", by ", TT {"n", SUB "j,l", "."}}},
     TEST ///
	  R = ZZ[x]
	  m = random(R^2,R^{-6,-7,-8,-9})
	  F = target m
	  f = rank F
	  P = source m
	  p = rank P
	  n = random(R^3,R^{-1,-2,-3,-4,-5})
	  G = target n
	  g = rank G
	  Q = source n
	  q = rank Q
	  h = contract'(m,n)
	  assert( source h === P ** dual Q )
	  assert( target h === F ** dual G )
	  scan(f, i -> scan(g, j -> scan(p, k -> scan(q, l -> assert( h_(g*i+j,q*k+l) === contract(n_(j,l),m_(i,k)))))))
	  ///,
     PARA{},
     "This function is identical to ", TO (diff',Matrix,Matrix), ", except that 
     the multiplication by integers that occurs during differentiation is
     omitted.",
     PARA{},
     SeeAlso => {contract,"diff and contract"}
     }

document { Key => {(diff', Matrix, Matrix),diff'},
     Headline => "differentiate a matrix by a matrix, the dual notion",
     Usage => "h = diff'(m,n)",
     Inputs => {
	  "m" => {"a map ", TT "m : F <--- P", " between free modules of ranks f and p."},
	  "n" => {"a map ", TT "n : G <--- Q", " between free modules of ranks g and q."}
	  },
     Outputs => {
	  "h" => {"a matrix with the shape ", TT "h : F ** dual G <--- P ** dual Q", ", whose entry in the slot ", TT {"h", SUB "g*i+j,q*k+l"}, "
	       is the result of differentiating ", TT {"n", SUB "j,l"}, ", by ", TT { "m", SUB "i,k" }}},
     TEST ///
	  R = ZZ[x]
	  m = random(R^2,R^{-6,-7,-8,-9})
	  F = target m
	  f = rank F
	  P = source m
	  p = rank P
	  n = random(R^3,R^{-1,-2,-3,-4,-5})
	  G = target n
	  g = rank G
	  Q = source n
	  q = rank Q
	  h = diff'(m,n)
	  assert( source h === P ** dual Q )
	  assert( target h === F ** dual G )
	  scan(f, i -> scan(g, j -> scan(p, k -> scan(q, l -> assert( h_(g*i+j,q*k+l) === diff(n_(j,l),m_(i,k)))))))
	  ///,
     SeeAlso => {diff,"diff and contract"}
     }


TEST "
R = ZZ/101[a..d]
I = monomialCurveIdeal(R,{1,3,4})
A = R/I
jacobian A
singA = minors(codim ideal presentation A, jacobian A)
generators gb singA
"
document {
     Key => jacobian,
     Headline => "the Jacobian matrix of partial derivatives",
     SeeAlso => {
	 "diff",
	 "contract"
	  }
     }
document {
     Key => (jacobian,Matrix),
     Headline => "the matrix of partial derivatives of polynomials in a matrix",
     Usage => "jacobian f",
     Inputs => {"f" => " with one row"},
     Outputs => {Matrix => {"the Jacobian matrix of partial derivatives of 
	           the polynomial entries of ", TT "f"}},
     "If ", TT "f", " is a 1 by ", TT "m", " matrix over a polynomial ring ",
     TT "R", " with ", TT "n"," indeterminates,
     then the resulting matrix of partial derivatives has dimensions ",TT "n"," by ",TT "m",", 
     and the ", TT "(i,j)", " entry is the partial derivative of the ", TT "j", "-th entry of
     ", TT "f", " by the ", TT "i", "-th indeterminate of the ring.",
     PARA{},
     "If the ring of ", TT "f", " is a quotient polynomial ring ", TT "S/J", ",
     	  then only the derivatives of the given entries of ", TT "f", " are
     	  computed and NOT the derivatives of elements of ", TT "J", ".",
     	  EXAMPLE {
	       "R = QQ[x,y,z];",
      	       "f = matrix{{y^2-x*(x-1)*(x-13)}}",
      	       "jacobian f",
	       },
	  "If the ring of ", TT "f", " is a polynomial ring over a polynomial ring,
	  then indeterminates in the coefficient ring are treated as constants.",
     	  EXAMPLE {
	       "R = ZZ[a,b,c][x,y,z]",
	       "jacobian matrix{{a*x+b*y^2+c*z^3, a*x*y+b*x*z}}"
	       }
     }
document {
     Key => {(jacobian,Ideal),(jacobian, MonomialIdeal)},
     Headline => "the Jacobian matrix of the generators of an ideal",
     Usage => "jacobian I",
     Inputs => {"I" => " in a polynomial ring"},
     Outputs => {Matrix => {"the Jacobian matrix of partial derivatives of 
	           the generators of ", TT "I"}},
     "This is identical to ", TT "jacobian generators I", ".  See ", TO (jacobian,Matrix), 
     " for more information.",
     	  EXAMPLE {
	       "R = QQ[x,y,z];",
      	       "I = ideal(y^2-x*(x-1)*(x-13))",
      	       "jacobian I",
	       },
	  "If the ring of ", TT "I", " is a polynomial ring over a polynomial ring,
	  then indeterminates in the coefficient ring are treated as constants.",
     	  EXAMPLE {
	       "R = ZZ[a,b,c][x,y,z]",
	       "jacobian ideal(a*y*z+b*x*z+c*x*y)"
	       }
     }
document {
     Key => (jacobian,Ring),
     Headline => "the Jacobian matrix of the polynomials defining a quotient ring",
     Usage => "jacobian R",
     Inputs => {"R" => " a quotient of a polynomial ring"},
     Outputs => {Matrix => {"the Jacobian matrix of partial derivatives of 
	           the presentation matrix of ", TT "R"}},
     "This is identical to ", TT "jacobian presentation R", ", except
     that the resulting matrix is over the ring ", TT "R", ".  See ", TO (jacobian,Matrix), 
     " for more information.",
     	  EXAMPLE {
	       "R = QQ[x,y,z]/(y^2-x^3-x^7);",
      	       "jacobian R",
	       },
	  "If the ring ", TT "R", " is a (quotient of a) polynomial ring over a polynomial ring,
	  then the top set of indeterminates is used, on the top set of quotients:",
     	  EXAMPLE {
	       "A = ZZ[a,b,c]/(a^2+b^2+c^2);",
	       "R = A[x,y,z]/(a*x+b*y+c*z-1)",
	       "jacobian R"
	       }
     }
document {
     Key => (leadTerm, RingElement),
     Headline => "get the greatest term",
     Usage => "leadTerm f",
     Inputs => {"f" => "in a polynomial ring"},
     Outputs => { RingElement => {"the lead term of ", TT "f", ""}},
     "Each polynomial ring comes equipped with a ", TO2("monomial orders", "monomial ordering"),
     " and this routine
     returns the lead (greatest) monomial and its coefficient.  
     Recall that the default monomial order is
     the ", TO "graded reverse lexicographic order", ".",
     EXAMPLE {
	  "R = QQ[a..d];",
	  "leadTerm (3*b*c^2-d^3-1)",
	  "S = QQ[a..d, MonomialOrder => Lex]",
	  "leadTerm (3*b*c^2-d^3-1)"
	  },
     "Coefficients are included in the result:",
     EXAMPLE {
	  "R = ZZ[a..d][x,y,z];",
	  "leadTerm((a+b)*y^2 + (b+c)*x*z)"
	  },
     SeeAlso => {"leadCoefficient", "leadMonomial", "leadComponent"}
     }
document {
     Key => {(leadTerm, Matrix),(leadTerm, GroebnerBasis),(leadTerm, Vector)},
     Headline => "get the greatest term of each column",
     Usage => "leadTerm f",
     Inputs => {"f" => "in a polynomial ring"},
     Outputs => { Matrix => {"the lead term matrix of ", TT "f", ""}},
     "In Macaulay2, each free module over a polynomial ring comes equipped with a ", 
     TO2("monomial orders", "monomial order"),
     " and this routine
     returns the matrix whose ", TT "i", "-th column is the lead term of the ", 
     TT "i", " th column of ", TT "f", ".",
     EXAMPLE lines ///
	  R = QQ[a..d];
	  f = matrix{{0,a^2-b*c},{c,d}}
	  leadTerm f
	  ///,
     "Coefficients are included in the result:",
     EXAMPLE {
	  "R = ZZ[a..d][x,y,z];",
	  "f = matrix{{0,(a+b)*x^2},{c*x, (b+c)*y}}",
	  "leadTerm f"
	  },
     "The argument ", TT "f", " can also be ", ofClass GroebnerBasis, ", in which case the lead term matrix of the generating matrix of ", TT "f", " is returned.",
     SeeAlso => {"leadCoefficient", "leadMonomial", "leadComponent"}
     }
document {
     Key => (leadTerm, Ideal),
     Headline => "get the ideal of greatest terms",
     Usage => "leadTerm I",
     Inputs => {"I"},
     Outputs => {{"The ideal of all possible lead terms of ", TT "I"}},
     "Compute a ", TO2("Groebner bases", "Groebner basis"), 
     " and return the ideal generated by the lead terms of the Groebner 
     basis elements.",
     EXAMPLE {
	  "R = QQ[a..d];",
	  "I = ideal(a*b-c*d, a*c-b*d)",
	  "leadTerm I"
	  },
     EXAMPLE {
	  "R = ZZ[a..d][x,y,z];",
	  "I = ideal(a*x-b*y, x^3, y^3, z^3)",
	  "leadTerm I"
	  },
     SeeAlso => {"Groebner bases"}
     }

document {
     Key => (leadTerm, ZZ, RingElement),
     Headline => "get the lead polynomials using part of the monomial order",
     Usage => "leadTerm(n,f)",
     Inputs => {"n", "f" => "in a polynomial ring" },
     Outputs => { RingElement => {"the lead term of ", TT "f", " using the first ", TT "n", " parts of the monomial order"}},
     "Returns the sum of the terms of ", TT "f", " which are greatest using the      first ", TT "n", " parts of
     the monomial order in the ring of ", TT "f", ".  See ", TO "parts of monomial orders", " for an explanation.",
     PARA{},
     "In the following example, the lead terms using the first part refers to all the
     monomials which have the lead monomial in the indeterminates a and b.  This has a
     effect similar to selecting leadTerm in the ring ", TT "QQ[c,d][a,b]", ".",
     EXAMPLE lines ///
	  R = QQ[a..d, MonomialOrder => ProductOrder{2,2}];
	  leadTerm(1, (c+d)*a^3 - c^100*a - 1)
	  ///,
     SeeAlso => {selectInSubring}
     }

document {
     Key => (leadTerm, ZZ, Matrix),
     Headline => "get the matrix of lead polynomials of each column",
     Usage => "leadTerm(n,f)",
     Inputs => {"n", "f" => "in a polynomial ring"},
     Outputs => { Matrix => {"the lead term matrix of ", TT "f", " using the first ", 
	       TT "n", " parts of the monomial order"}},
     "Returns the matrix whose ", TT "i", "-th column is the lead term of the ", 
     TT "i", "-th column of ", TT "f", ", using the first ", TT "n", " parts 
     of the monomial order.  ",
     "See ", TO "parts of monomial orders", " for an explanation.",
     EXAMPLE {
	  "R = QQ[x,y,z,a..d,MonomialOrder=>ProductOrder{3,4}];",
	  "f = matrix{{0,x^2*(a+b)}, {a*x+2*b*y, y^2*(c+d)}}",
	  "leadTerm(1,f)"
	  },
     SeeAlso => { "selectInSubring" }
     }
document {
     Key => (leadTerm, ZZ, Ideal),
     Headline => "get the ideal of lead polynomials",
     Usage => "leadTerm(n,I)",
     Inputs => {"n", "I"},
     Outputs => {{"The ideal of all possible lead polynomials of ", TT "I", 
	       " using the first ", TT "n", " parts of the monomial order"}},
     "Compute a ", TO2("Groebner bases", "Groebner basis"), 
     " and return the ideal generated by the lead terms of the Groebner 
     basis elements using the first n . See ", TO "parts of monomial orders", " for an explanation.",
     EXAMPLE {
	  "R = QQ[a..d,MonomialOrder=>ProductOrder{1,3}];",
	  "I = ideal(a*b-c*d, a*c-b*d)",
	  "leadTerm(1,I)"
	  },
     SeeAlso => {"Groebner bases"}
     }
document {
     Key => leadTerm,
     Headline => "get the greatest term",
     "Every polynomial ring in Macaulay 2 comes equipped with a monomial ordering.
     For ring elements and matrices, this function returns the greatest term in this order.",
     PARA{},
     "For an ideal, a Groebner basis is first computed, and the ideal of lead terms is
     returned.",
     PARA{},
     "If an initial integer ", TT "n", " is specified, then the returned value contains the sum
     of all of the terms with the greatest value on the first ", TT "n", " ",
     TO2 ("parts of a monomial order", "parts of the monomial order"), "."
     }
document {
     Key => {(borel, Matrix),borel,(borel, MonomialIdeal)},
     Headline => "make a Borel fixed submodule",
     TT "borel m", " -- make a Borel fixed submodule",
     PARA{},
     "Yields the matrix with the same target as the matrix ", TT "m", ", whose columns
     generate the smallest Borel fixed submodule containing the lead monomials
     of the columns of ", TT "m", ".  If ", TT "m", " is a monomial ideal, then the minimal Borel
     fixed monomial ideal containing it is returned.",
     PARA{},
     "For example, if R = ZZ/101[a..f], then",
     EXAMPLE {
	  "R = ZZ/101[a..e]",
	  "borel matrix {{a*d*e, b^2}}"
	  }
     }
document {
     Key => {(inducedMap, Module, Module),(inducedMap, ChainComplex, ChainComplex)},
     Headline => "compute the map induced by the identity",
     Usage => "inducedMap(M,N)",
     Inputs => { "M", "N" },
     Outputs => {
	  {"the homomorphism ", TT "M <-- N", " induced by the identity."}
	  },
     "The modules ", TT "M", " and ", TT "N", " must both be ", TO "subquotient modules", " of 
     the same ambient free module ", TT "F", ".
     If ", TT "M = M1/M2", " and ", TT "N = N1/N2", ", where ", TT "M1", ", 
     ", TT "M2", ", ", TT "N1", ", ", TT "N2", " are all submodules of ", TT "F", ", then
     return the map induced by ", TT "F --> F", ". If the optional argument ", TT "Verify", 
     " is given, check that the result defines a well defined homomorphism.",
     PARA{},
     "In this example, we make the inclusion map between two submodules of ", TT "R^3", 
     ".  M is defined by two elements and N is generated by one element in M",
     EXAMPLE {
	  "R = ZZ/32003[x,y,z];",
          "P = R^3;",
	  "M = image(x*P_{1}+y*P_{2} | z*P_{0})",
	  "N = image(x^4*P_{1} + x^3*y*P_{2} + x*y*z*P_{0})",
	  "h = inducedMap(M,N)",
	  "source h == N",
	  "target h == M",
	  "ambient M == ambient N"
	  },
     SeeAlso => {inducesWellDefinedMap, subquotient}
     }
document {
     Key => {(inducedMap, Module, Module, Matrix),(inducedMap, Module, Nothing, Matrix),(inducedMap, Nothing, Module, Matrix),(inducedMap, Nothing, Nothing, Matrix)},
     Headline => "compute the induced map",
     Usage => "inducedMap(M,N)",
     Inputs => { "M", "N", "f" => {"a homomorphism ", TT "P <-- Q"}
	  },
     Outputs => {
	  {"the homomorphism ", TT "M <-- N", " induced by ", TT "f", "."}
	  },
     "The modules ", TT "M", " and ", TT "N", " must both be ", TO "subquotient modules", " where
     M and P have the same ambient module, and N and Q have the same ambient module.
     If the optional argument ", TT "Verify", 
     " is given, check that the result defines a well defined homomorphism.",
     PARA{},
     "In this example, the module K2 is mapped via g into K1, and we construct the
     induced map from K2 to K1.",
     EXAMPLE {
	  "R = ZZ/32003[x,y,z]",
	  "g1 = matrix{{x,y,z}}",
	  "g2 = matrix{{x^2,y^2,z^2}}",
	  "K1 = ker g1",
	  "K2 = ker g2",
	  "f = map(ambient K1, ambient K2, {{x,0,0},{0,y,0},{0,0,z}})",
	  "h = inducedMap(K1,K2,f)"
	  },
     "If we omit the first argument, then it is understood to be the target of f, and
     if we omit the second argument, it is understood to be the source of f.",
     EXAMPLE {
	  "h1 = inducedMap(target f,K2,f)",
	  "h2 = inducedMap(,K2,f)",
	  "h1 == h2"
	  },
     "In this example, we cannot omit the second argument, since in that case the resulting 
     object is not a homomorphism.",
     SeeAlso => {inducesWellDefinedMap, subquotient}
     }
document {
     Key => inducedMap,
     Headline => "compute an induced map",
     SeeAlso => "inducesWellDefinedMap"
     }
document {
     Key => [inducedMap,Degree],
     Headline => "specify the degree of a map",
     TT "Degree => n", " -- an option to ", TO "inducedMap", " that provides the
     degree of the map produced."
     }
document {
     Key => Verify,
     Headline => "verify that a map is well-defined",
     TT "Verify", " -- an option that can be used to request verification
     that a map is well defined.",
     PARA{},
     UL {
	  TO [inducedMap,Verify]
	  }
     }
document {
     Key => [inducedMap,Verify],
     TT "Verify => true", " -- an option for ", TO "inducedMap", " which
     requests verification that the induced map produced is well defined."
     }
document {
     Key => {inducesWellDefinedMap,(inducesWellDefinedMap, Module, Module, Matrix),
	  (inducesWellDefinedMap, Module, Nothing, Matrix),(inducesWellDefinedMap, Nothing, Module, Matrix),
	  (inducesWellDefinedMap, Nothing, Nothing, Matrix)},
     Headline => "whether a map is well defined",
     TT "inducesWellDefinedMap(M,N,f)", " -- tells whether the matrix ", TT "f", " would
     induce a well defined map from ", TT "N", " to ", TT "M", ".",
     SeeAlso => "inducedMap"
     }

document {
     Key => Degree,
     TT "Degree => d", " -- an optional argument to ", TO "matrix", " that
     specifies that the degree of the map created should be ", TT "d", ".",
     PARA{},
     "The degree may be an integer or a list of integers (multidegree).  The
     length of the list should be the same as the length of a degree for the
     ring, see ", TO "degreeLength", ".",
     PARA{},
     EXAMPLE {
	  "R = ZZ/101[x]",
      	  "p = map(R^1, R^1, {{x^4}})",
      	  "isHomogeneous p",
      	  "q = map(R^1, R^1, {{x^4}}, Degree => 4)",
      	  "isHomogeneous q",
	  },
     SeeAlso => {"map", "matrix", [inducedMap,Degree]}
     }
document {
     Key => id,
     Headline => "identity map",
     TT "id_M", " -- the identity homomorphism from ", TT "M", " to ", TT "M", "."
     }
document {
     Key => (reshape,Module,Module,Matrix),
     Headline => "reshape a matrix",
     Usage => "reshape(F,G,f)",
     Inputs => {
	  "F" => "a free module",
	  "G" => "a free module",
	  "f"
	  },
     Outputs => {
	  { " ", TT "F <-- G", " obtained from f by 
     	       taking elements from the first column of ", TT "f", ", 
	       then the second, and
     	       so on, filling them into the result column by column."
	       }
	  },
     "Currently, it is assumed
     that ", TT "f", " and the result both have the same 
     number of entries.  The resulting map is always of degree zero.",
     EXAMPLE {
	  "f = matrix{{1,3,5,7,9,11},{2,4,6,8,10,12}}",
	  "reshape(ZZ^3,ZZ^4,f)"
	  }
     }
TEST "
R=ZZ/101[a..d]
f = matrix {{a}}
assert( isHomogeneous f )
g = reshape(R^1, R^{-1}, f)
assert isHomogeneous g
"
document {
     Key => (adjoint1,Matrix,Module,Module),
     Headline => "an adjoint map",
     Usage => "adjoint1(f,G,H)",
     Inputs => {
	  "f" => {"a homomorphism ", TT "F --> G ** H", " between free modules"},
	  "G" => "a free module",
	  "H" => "a free module"
	  },
     Outputs => {
	  {"the adjoint homomorphism ", TT "F ** (dual G) --> H"}
	  },
     "All modules should be free modules over the same base ring, and the rank of the
     target of ", TT "f", " should be the product of the ranks of ", TT "G", " and ", 
     TT "H", ".  Recall that ", 
     TT "**", " refers to the tensor product of modules, and that ", TT "dual G", " is 
     a free module with the same rank as ", TT "G", ".",
     PARA{},
     "No computation is required.  The resulting matrix has the same entries as ", 
     TT "f", ", but in a different layout.",
     PARA{},
     "If ", TT "f", " is homogeneous, and ", TT "target f == G ** H", ",including 
     the grading, then the resulting matrix will be homogeneous.",
     PARA{},
     EXAMPLE {
	  "R = QQ[x_1 .. x_12];",
	  "f = genericMatrix(R,6,2)",
	  "g = adjoint1(f,R^2,R^3)",
	  "isHomogeneous g"
	  },
     SeeAlso => {adjoint, flip, reshape, (symbol**,Module,Module), dual}
     }
document {
     Key => (adjoint,Matrix,Module,Module),
     Headline => "an adjoint map",
     Usage => "adjoint(f,G,H)",
     Inputs => {
	  "f" => {"a homomorphism ", TT "F ** G --> H", " between free modules"},
	  "F" => "a free module",
	  "G" => "a free module"
	  },
     Outputs => {
	  {"the adjoint homomorphism ", TT "F --> (dual G) ** H"}
	  },
     "All modules should be free modules over the same base ring, and the rank of the
     source of ", TT "f", " should be the product of the ranks of ", TT "F", " and ", 
     TT "G", ".  Recall that ", 
     TT "**", " refers to the tensor product of modules, and that ", TT "dual G", " is 
     a free module with the same rank as ", TT "G", ".",
     PARA{},
     "No computation is required.  The resulting matrix has the same entries as ", 
     TT "f", ", but in a different layout.",
     PARA{},
     "If ", TT "f", " is homogeneous, and ", TT "source f == F ** G", 
     ", including the grading, then 
     the resulting matrix will be homogeneous.",
     PARA{},
     EXAMPLE {
	  "R = QQ[x_1 .. x_12];",
	  "f = genericMatrix(R,2,6)",
	  "g = adjoint(f,R^2,R^{-1,-1,-1})",
	  "isHomogeneous g"
	  },
     SeeAlso => {adjoint1, flip, reshape, (symbol**,Module,Module), dual}
     }
document {
     Key => {(flip,Module,Module),flip},
     Headline => "matrix of commutativity of tensor product",
     Usage => "flip(F,G)",
     Inputs => {"F", "G"},
     Outputs => {{"the matrix representing the natural isomorphism ", TT "G ** F <-- F ** G"}},
     EXAMPLE lines ///
     	  R = QQ[x,y];
	  F = R^{1,2,3}
	  G = R^{10,20,30}
	  f = flip(F,G)
	  isHomogeneous f
	  target f
	  source f
	  target f === G**F
	  source f === F**G
	  u = x * F_0
	  v = y * G_1
	  u ** v
	  v ** u
	  f * (u ** v)
	  f * (u ** v) === v ** u
     ///}
document {
     Key => (symbol **, Matrix, Matrix),
     Headline => "tensor product of matrices",
     TT "f ** g", " -- computes the tensor product of two matrices.",
     PARA{},
     SeeAlso => "Matrix"
     }

TEST "
ZZ[t]
assert (matrix {{t}} ** matrix {{t}} == matrix{{t^2}})
"
document {
     Key => symbol compactMatrixForm,
     Headline => "global flag for compact printing",
	Usage => "compactMatrixForm = x",
	Consequences => {"changes the display of matrices"},
     TT "compactMatrixForm", " is a global flag which specifies whether to display
     matrices in compact form.",
     PARA{},
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
TEST "
R = ZZ/101[x,y,z]
I = ideal(x,y)
assert( 1 == dim I )
assert( 2 == codim I )
"
document {
     Key => {(module, Ideal),(module, MonomialIdeal)},
     Headline => "turn an ideal into a module",
     TT "module I", " -- produce the submodule of ", TT "R^1", " corresponding to an
     ideal ", TT "I", " in a ring ", TT "R", "."
     }
document {
     Key => SubringLimit,
     Headline => "stop after finding enough elements of a subring",
     TT "SubringLimit", " -- an option for  ", TO "kernel", " and ", TO "gb", "
     which can stop the computation after a certain number of basis elements in
     a subring have been found.",
     SeeAlso => "Groebner bases"
     }
document {
     Key => [kernel,SubringLimit],
     TT "SubringLimit => n", " -- an option for ", TO "kernel", " which
     causes the computation of the kernel of a ring map to stop after ", TT "n", "
     elements have been discovered."
     }
document {
     Key => (dual, Matrix),
     Headline => "dual of a map",
     TT "dual f", " -- the dual (transpose) of a homomorphism."
     }
document {
     Key => singularLocus,
     Headline => "singular locus",
     TT "singularLocus R", " -- produce the singular locus of a ring,
     which is assumed to be integral and defined by a homogeneous ideal.",
     PARA{},
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
document {
     Key => (symbol ^,Matrix,Array),
     Headline => "select rows of blocks",
     TT "f^[i,j,k]", " -- extract some rows of blocks from a matrix ", TT "f", ".",
     PARA{},
     "The target of ", TT "f", " should be a direct sum, and the result is obtained by
     composition with the projection onto the sum of the components numbered
     ", TT "i, j, k", ".  Free modules are regarded as direct sums.",
     PARA{},
     EXAMPLE {
	  "f = map(ZZ^2 ++ ZZ^2, ZZ^2, {{1,2},{3,4},{5,6},{7,8}})",
      	  "f^[0]",
      	  "f^[1]",
      	  "f^[1,0]",
	  },
     SeeAlso => {submatrix, (symbol ^,Module,Array), (symbol _,Matrix,Array)}
     }
document {
     Key => (symbol _, Matrix, Array),
     Headline => "select columns of blocks",
     TT "f_[i,j,k]", " -- extract some columns of blocks from a matrix ", TT "f", ".",
     PARA{},
     "The source of ", TT "f", " should be a direct sum, and the result is obtained by
     composition with the inclusion into the sum of the components numbered
     ", TT "i, j, k", ".  Free modules are regarded as direct sums.",
     PARA{},
     EXAMPLE {
	  "f = map(ZZ^2 ++ ZZ^2, ZZ^2, {{1,2},{3,4},{5,6},{7,8}})",
      	  "f^[0]",
      	  "f^[1]",
      	  "f^[1,0]",
	  },
     SeeAlso => {submatrix, (symbol _,Module,Array), (symbol ^,Matrix,Array)}
     }
document {
     Key => {isSurjective,(isSurjective, Matrix)},
     Headline => "whether a map is surjective",
     SeeAlso => "isInjective"
     }
TEST "
R = ZZ/101[a]
assert isInjective R^2_{0}
assert not isInjective R^2_{0,0}
assert isSurjective R^2_{0,0,1}
assert not isSurjective R^2_{1}
"
document {
     Key => {(content, RingElement),content},
     Headline => "the content of a polynomial",
     TT "content f", " -- returns the content of a matrix or polynomial.",
     PARA{},
     "The content is the ideal in the base ring generated by the coefficients.",
     EXAMPLE lines ///
     	  R = ZZ[x]
	  content(4*x + 6*x^5)
	  generator oo
     ///
     }
document {
     Key => QuotientRing,
     Headline => "the class of all quotient rings"
     }
document {
     Key => {isQuotientOf,(isQuotientOf, QuotientRing, Ring),(isQuotientOf, Ring, Ring)},
     Headline => "whether one thing is a quotient of another"
     }

document {
     Key => (symbol /, RingElement, RingElement),
     Headline => "fraction",
     Usage => "f/g",
     Inputs => { "f", "g" },
     Outputs => { RingElement => "the fraction f/g" },
     "If either f or g is in a base ring of the other, then that one is promoted 
     so that both are elements in the same ring R.",
     PARA{},
     "The fraction will be an element of the fraction field, frac R, of R.  
     If R is already a field, then this means that the fraction will be an element 
     of R.",
     EXAMPLE lines ///
      	   4/2
	   ///,
     EXAMPLE lines ///
	   R = GF(9,Variable=>a);
	   (a/a^3) * a^2 == 1
	   ///,
     EXAMPLE lines ///
     	   S = ZZ[a,b]
	   (a^6-b^6)/(a^9-b^9)
	   ///,
     "If the ring contains zero divisors, the fraction field is not defined.
     Macaulay2 will not inform you of this right away.  However, if computation
     finds a zero-divisor, an error message is generated.",
     EXAMPLE lines ///
     	  A = ZZ/101[a,b]/(a*b)
	  (a+b)/(a-b)
	  f = a/b
	  ///,
     "At this point, if one types ", TT "f^2", ", then Macaulay2 would give an error
     saying that a zero divisor was found in the denominator.",
     SeeAlso => {symbol //}
     }

document {
     Key => {(symbol /, Ring, Ideal),
	  (symbol /, Ring, Module),
	  (symbol /, Ring, RingElement),
	  (symbol /, Ring, MonomialIdeal),
	  (symbol /, Ring, List),
	  (symbol /, Ring, Sequence),
	  (symbol /, Ring, ZZ)
	  },
     Headline => "make a quotient ring",
     Usage => "S = R/I",
     Inputs => {
	  "R",
	  "I" => Nothing => {
	       { ofClass Ideal, " or element of ", TT "R", 
		    "or ", ofClass List, " or ", ofClass Sequence, " of elements of ", TT "R"}}
	  },
     Outputs => {
	  "S" => {"the quotient ring ", TT "R/I"}
	  },
     "If ", TT "I", " is a ring element of ", TT "R", " or ", TT "ZZ", 
     ", or a list or sequence of such elements, then ", 
     TT "I", " is understood to be the 
     ideal generated by these elements.  If ", 
     TT "I", " is a module, then it must be a submodule 
     of a free module of rank 1.",
     EXAMPLE lines ///
     	  ZZ[x]/367236427846278621
	  ///,
     EXAMPLE lines ///
     	  A = QQ[u,v];
	  I = ideal random(A^1, A^{-2,-2,-2})
	  B = A/I;
	  use A;
	  C = A/(u^2-v^2,u*v);
	  ///,
     EXAMPLE lines ///	  
	  D = GF(9,Variable=>a)[x,y]/(y^2 - x*(x-1)*(x-a))
	  ambient D
     	  ///,
     "The names of the variables are assigned values in the new quotient ring
     (by automatically running ", TT "use R", ") when the new ring is assigned
     to a global variable.",
     PARA{},
     "Warning: quotient rings are bulky objects, because they contain 
     a Groebner basis for their ideals, so only quotients of ", TO "ZZ", " 
     are remembered forever.  Typically the ring created by ", TT "R/I", " 
     will be a brand new ring, and its elements will be incompatible with 
     the elements of previously created quotient rings for the same ideal.",
     EXAMPLE {
	  "ZZ/2 === ZZ/(4,6)",
      	  "R = ZZ/101[t]",
      	  "R/t === R/t",
	  }
     }

document {
     Key => symmetricPower,
     Headline => "symmetric power" }
document {
     Key => (symmetricPower,ZZ,Matrix),
     Usage => "symmetricPower(i,f)",
     Inputs => {
	  "i",
	  "f",
	  },
     Outputs => {
	  { "the ", TT "i", "-th symmetric power of ", TT "f"}
	  },
     PARA { "Note: in the current implementation, ", TT "f", " should have just one row." }
     }
document {
     Key => (exteriorPower,ZZ,Matrix),
     Headline => "exterior power of a matrix",
     Usage => "exteriorPower(i,f)\nexteriorPower_i f",
     Inputs => { "i", "f" },
     Outputs => {
	  { "the ", TT "i", "-th exterior power of ", TT "f", "."}
	  },
     EXAMPLE {
	  "R = ZZ/2[x,y];",
	  "f = random(R^3,R^{3:-1})",
	  "exteriorPower_2 f"
	  },
     "The matrix may be a more general homomorphism of modules.  For example,",
     EXAMPLE {
	  "g = map(coker matrix {{x^2},{x*y},{y^2}}, R^3, id_(R^3))",
	  "g2 = exteriorPower(2,g)",
	  "target g2"
	  },
	SeeAlso => {(exteriorPower,ZZ,Module)}
     }
document {
     Key => (exteriorPower,ZZ,Module),
     Headline => "exterior power of a module",
     Usage => "exteriorPower(i,M)\nexteriorPower_i M",
     Inputs => { "i", "M" },
     Outputs => {
		{"the ", TT "i", "-th exterior power of ", TT "M", "."}
	  },
     EXAMPLE {
	  "M = ZZ^5",
	  "exteriorPower(3,M)"
	  },
	"When ", TT "i", " is ", TT "1", ", then the result is equal to ", TT "M",
     ".  When ", TT "M", " is not a free module, then the generators used for the result
     will be wedges of the generators of ", TT "M", ".  In other words, the modules
     ", TT "cover exteriorPower(i,M)", " and ", TT "exteriorPower(i,cover M)", " 
     will be equal.",
     SeeAlso => {(exteriorPower,ZZ,Matrix)}
     }
document {
     Key => MinorsComputation,
     Headline => "the class of all minors computations",
     TT "MinorsComputation", " -- a type of self initializing list used
     internally by ", TO "minors", "."
     }
document {
     Key => wedgeProduct,
     Headline => "the exterior multiplication map",
     TT "wedgeProduct(p,q,M)", " -- returns the matrix which represents the
     multiplication map from ", TT "exteriorPower(p,M) ** exteriorPower(q,M)", "
     to ", TT "exteriorPower(p+q,M)", ".",
     PARA{},
     "Here ", TT "M", " is free module."
     }
document {
     Key => exteriorPower,
     Headline => "exterior power",
     SeeAlso => {"minors", "det", "wedgeProduct"}
     }
TEST ///
    R = ZZ[x,y,z]
    modules = {
	 image matrix {{x^2,x,y}},
	 coker matrix {{x^2,y^2,0},{0,y,z}},
	 R^{-1,-2,-3},
	 image matrix {{x,y}} ++ coker matrix {{y,z}}
	 }
    scan(modules, M -> assert( cover exteriorPower(2,M) == exteriorPower(2,cover M) ))
///
document {
     Key => trace,
     Headline => "trace of a matrix",
     TT "trace f", " -- returns the trace of the matrix f.",
     PARA{},
     EXAMPLE {
	  "R = ZZ/101[a..d]",
      	  "p = matrix {{a,b},{c,d}}",
      	  "trace p"
	  },
     }
document {
     Key => Limit,
     Headline => "specify how many to compute",
     TT "Limit => n", " -- an optional argument for ",
     TO "minors", " specifying that the computation should stop 
     after ", TT "n", " more elements are computed."
     }
document {
     Key => {fittingIdeal,(fittingIdeal, ZZ, Module)},
     Headline => "Fitting ideal of a module",
     TT "fittingIdeal(i,M)", " -- the i-th Fitting ideal of the module M",
     PARA{},
     EXAMPLE {
	  "R = ZZ/101[x];",
      	  "k = coker vars R",
      	  "M = R^3 ++ k^5;",
      	  "fittingIdeal(3,M)",
      	  "fittingIdeal(8,M)"
	  },
     }
TEST "
R = ZZ/101[x];
k = coker vars R;
M = R^3 ++ k^5;
assert( fittingIdeal(0,M) == ideal 0_R )
assert( fittingIdeal(1,M) == ideal 0_R )
assert( fittingIdeal(2,M) == ideal 0_R )
assert( fittingIdeal(3,M) == ideal x^5 )
assert( fittingIdeal(4,M) == ideal x^4 )
assert( fittingIdeal(5,M) == ideal x^3 )
assert( fittingIdeal(6,M) == ideal x^2 )
assert( fittingIdeal(7,M) == ideal x )
assert( fittingIdeal(8,M) == ideal 1_R )
assert( fittingIdeal(9,M) == ideal 1_R )
"

document {
     Key => (symbol +, Module, Module),
     Headline => "sum of submodules",
     TT "M + N", " -- the sum of two submodules.",
     PARA{},
     "The two modules should be submodules of the same module."
     }
document {
     Key => (symbol **, Module, Module),
     Headline => "tensor product of modules",
     TT "M ** N", " -- produce the tensor product of two modules.",
     PARA{},
     "Since M and N may be provided as submodules or subquotient modules, it
     may be necessary to replace them by quotient modules in the course of the
     computation, but the generators provided in the resulting tensor product 
     will correspond to the tensor products of the generators, i.e., the modules
     ", TT "cover M ** cover N", " and ", TT "cover(M ** N)", " are equal.
     This makes it easier to make ", TT "M ** N", " into a functor."
     -- i.e., we don't use 'prune'!
     }
TEST ///
    R = ZZ[x,y,z]
    modules = {
	 image matrix {{x^2,x,y}},
	 coker matrix {{x^2,y^2,0},{0,y,z}},
	 R^{-1,-2,-3},
	 image matrix {{x,y}} ++ coker matrix {{y,z}}
	 }
    table(modules, modules, (P,Q) -> assert(cover P ** cover Q == cover (P ** Q)));
///
document {
     Key => (symbol **, Matrix, Module),
     Headline => "tensor product",
     TT "f ** N", " -- tensor product of a matrix ", TT "f", " and a module ", TT "N", ".",
     PARA{},
     "This is the same as tensoring ", TT "f", " with the identity map of ", TT "N", ".",
     PARA{},
     "When ", TT "N", " is a free module of rank 1 the net effect of the
     operation is to shift the degrees of ", TT "f", ".",
     EXAMPLE {
	  "R = ZZ/101[t]",
      	  "f = matrix {{t}}",
      	  "degrees source f",
      	  "degrees source (f ** R^{-3})",
	  },
     SeeAlso => {"Matrix", "Module"}
     }
document {
     Key => (symbol **, Module, Ring),
     Headline => "tensor product",
     TT "M ** R", " -- form the tensor product of a module ", TT "M", " with a ring ", TT "R", ".",
     PARA{},
     "The ring of ", TT "M", " should be a base ring of ", TT "R", ".",
     EXAMPLE {
	  "R = ZZ/101[x,y];",
      	  "M = coker vars R",
      	  "M ** R[t]"
	  },
     }
document {
     Key => (symbol **, Matrix, Ring),
     Headline => "tensor product",
     TT "f ** R", " -- form the tensor product of a module map ", TT "f", " with 
     a ring ", TT "R", ".",
     PARA{},
     "The ring of ", TT "f", " should be a base ring of ", TT "R", ".  The degree 
     of the map is preserved.",
     EXAMPLE {
	  "R = ZZ[a..c];",
	  "S = R/(a+b+c);",
      	  "f = vars R",
	  "f ** S",
	  },
     }
document {
     Key => Order,
     Headline => "specify the order of a Hilbert series required",
     TT "Order", " -- an optional argument used with ", TO "hilbertSeries", "
     to specify the order of the series requested."
     }
document {
     Key => Projective,
     Headline => "whether to produce a projective Hilbert polynomial",
     TT "Projective", " -- an optional argument used with ", TO "hilbertPolynnomial", 
     " to specify the way the Hilbert Polynomial is expressed."
     }
document {
     Key => ProjectiveHilbertPolynomial,
     Headline => "the class of all Hilbert polynomials",
     "For convenience, these polynomials are expressed in terms of the Hilbert 
     polynomials of projective space.",
     PARA{},
     "The functions ", TO "degree", " and ", TO "dim", " are designed so they
     correspond the degree and dimension of the algebraic variety that may have
     been used to produce the Hilbert polynomial.",
     EXAMPLE {
	  "Z = Proj(QQ[x_0..x_12]/(x_0^3+x_12^3))",
	  "hilbertPolynomial Z"
	  }
     }
document {
     Key => (symbol SPACE, ProjectiveHilbertPolynomial, ZZ),
     Headline => "value of polynomial",
     TT "P i", " -- the value of a projective Hilbert polynomial ", TT "P", " at 
     an integer ", TT "i", ".",
     PARA{},
     EXAMPLE {
	  "P = projectiveHilbertPolynomial 2",
      	  "apply(0 .. 12, i -> P i)",
	  },
     SeeAlso => ProjectiveHilbertPolynomial
     }
document {
     Key => {projectiveHilbertPolynomial,(projectiveHilbertPolynomial, ZZ),(projectiveHilbertPolynomial, ZZ, ZZ)},
     Headline => "Hilbert polynomial of projective space",
     TT "projectiveHilbertPolynomial n", " -- produces the projective
     Hilbert polynomial corresponding to projective space of dimension n.",
     BR{},
     TT "projectiveHilbertPolynomial(n,d)", " -- produces the projective
     Hilbert polynomial corresponding to the graded ring of projective space
     of dimension n, but with its generator in degree -d.",
     PARA{},
     SeeAlso => "ProjectiveHilbertPolynomial"
     }
TEST "
scan(3, n -> scan(-3 .. 3, d -> (
	       h := projectiveHilbertPolynomial(n,d);
	       scan(3, i -> assert( h i === binomial(n+d+i,n) )))))
"
document {
     Key => dual,
     Headline => "dual module or map",
     TT "dual M", " -- the dual.",
     PARA{},
     "For details, see one of the following.",
     UL {
	  TO (dual,ChainComplex),
	  TO (dual,Matrix),
	  TO (dual,Module)
	  }
     }
TEST "
r = ZZ/101[a,b]
assert ( 2 * degree (a * b^2) === {6} )
M = cokernel matrix (r,{{1}})
assert ( isFreeModule prune M )
"
TEST "
GF(8,Variable => x)
assert ( det matrix{{x,1},{x^2,x^3}} == x^4 - x^2 )
"
TEST "
R = ZZ/101[a..f]
M = cokernel matrix (R, {{1},{-1}})
N = prune M
p = N.cache.pruningMap
assert( source p == N )
assert( target p == M )
assert( prune kernel p == 0 )
assert( prune cokernel p == 0 )
assert isIsomorphism p
assert isIsomorphism p^-1
assert ( p * p^-1 == id_M )
assert ( p^-1 * p == id_N )
"
document {
     Key => (dual, Module),
     Headline => "dual module",
     TT "dual M", " -- the dual of a module."
     }
document {
     Key => (dual, CoherentSheaf),
     Headline => "dual coherent sheaf",
     TT "dual M", " -- the dual of a coherent sheaf."
     }
document {
     Key => {homomorphism,(homomorphism, Matrix)},
     Headline => "get the homomorphism from element of Hom",
     Usage => "homomorphism f",
     Inputs => {
	  "f" => {"of the form Hom(M,N) <-- R^1, where Hom(M,N) has been
	  previously computed, and R is the ring of f, M and N"},
	  },
     Outputs => {
	  {"M <-- N, corresponding to the element f"}
	  },
     "When ", TT "H := Hom(M,N)", " is computed, enough information is stored in ", 
     TT "H.cache.Hom", " to compute this correspondence.",
     EXAMPLE {
	  "R = QQ[x,y,z]/(y^2-x^3)",
	  "H = Hom(ideal(x,y), R^1)",
	  "g = homomorphism H_{1}"
	  },
     "The homomorphism g takes x to y and y to x2.  The source and target are
     what they should be.",
     EXAMPLE {
	  "source g",
	  "target g"
	  },
     SeeAlso => Hom
     }
TEST ///
S = ZZ/101[a..d]
I = monomialCurveIdeal(S, {1,3,4})
R = S/I
use R
J = module ideal(a,d)
K = module ideal(b^2,c^2)
JK = Hom(J,K)
F = JK_{0}
F1 = homomorphism F
source F1
target F1
ker F1
prune coker F1
///
-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/m2 "
-- End:
