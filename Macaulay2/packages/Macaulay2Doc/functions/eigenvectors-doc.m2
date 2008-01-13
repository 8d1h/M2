--- status: TODO
--- author(s): 
--- notes: 

document { 
     Key => {eigenvectors, (eigenvectors,Matrix), (eigenvectors,MutableMatrix)},
     Headline => "find eigenvectors of a matrix over RR or CC",
     Usage => "(eigvals, eigvecs) = eigenvectors M",
     Inputs => {
	  "M" => Matrix => {"or a ", TO MutableMatrix, " over ", TO RR, " or ", TO CC, ", which is
	       a square n by n matrix"}
	  },
     Outputs => {
	  "eigvals" => Matrix => {" or a ", TO MutableMatrix, "(of the same find as ", TT "M", "),
	       a n by 1 matrix of the eigenvalues of M"},
	  "eigvecs" => Matrix => {" or a ", TO MutableMatrix, "(of the same find as ", TT "M", "),
	       whose columns are a basis of the corresponding eigenvectors of M"}
	  },
     "The resulting matrix is over CC, and contains the eigenvectors of ", TT "M", ".  The lapack
     library is used to compute eigenvectors of real and complex matrices.",
     PARA{},
     "Recall that if ", TT "v", " is a non-zero vector such that ",, TT "Mv = av", 
     ", for a scalar a, then
     ", TT "v", " is called an eigenvector corresponding to the eigenvalue ", TT "a", ".",
     EXAMPLE {
	  "M = matrix{{1.0, 2.0}, {5.0, 7.0}}",
	  "eigenvectors M"
	  },
     "If the matrix is symmetric (over RR) or Hermitian (over CC),
     this information should be provided as an optional argument ",
     TT "Hermitian=>true", ".  In this case,
     the resulting matrix of eigenvalues (and eigenvectors, if ", TT "M", " is over ", 
     TT "RR", ") is defined over ", TT "RR", ", not ", TT "CC", ".",
     EXAMPLE {
	  "M = matrix{{1.0, 2.0}, {2.0, 1.0}}",
	  "eigenvectors(M, Hermitian=>true)"
	  },
     "If the matrix you wish to use is defined over ", TT "ZZ", " or ", TT "QQ", ", then first move it to ", TT "RR", ".",
     EXAMPLE {
	  "M = matrix(QQ,{{1,2/17},{2,1}})",
	  "M = substitute(M,RR)",
	  "eigenvectors M"
	  },
     Caveat => {"The eigenvectors are approximate."},
     SeeAlso => {eigenvalues, SVD, substitute}
     }
document { 
     Key => [eigenvectors, Hermitian],
     Headline => "Hermitian=>true means assume the matrix is symmetric or Hermitian",
     Usage => "eigenvectors(M, Hermitian=>true)",
     Inputs => {
	  },
     Consequences => {
	  "The resulting matrix of eigenvalues is defined over RR, not CC, and, if the 
	  original matrix is defined over RR, the matrix of eigenvalues is too."
	  },     
     EXAMPLE {
	  },
     Caveat => {"The internal routine uses a different algorithm, only considering the
	  upper triangular elements.  So if the matrix is not symmetric or Hermitian,
	  the routine will give incorrect results."},
     SeeAlso => {eigenvectors}
     }
TEST ///
M = matrix{{1.0,1.0},{0.0,1.0}}
eigenvalues M
eigenvectors M

M = matrix{{1.0, 2.0}, {2.0, 1.0}}
eigenvectors(M, Hermitian=>true)

M = matrix{{1.0, 2.0}, {5.0, 7.0}}
(eigvals, eigvecs) = eigenvectors M
(M * eigvecs)_{0}
matrix{{eigvals_(0,0)}} ** eigvecs_{0}


m = map(CC^10, CC^10, (i,j) -> i^2 + j^3*ii)
eigenvectors m
m = map(CC^10, CC^10, (i,j) -> (i+1)^(j+1))
eigenvectors m
m = map(RR^10, RR^10, (i,j) -> (i+1)^(j+1))
eigenvectors m
///
