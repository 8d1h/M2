--- status: TODO
--- author(s): 
--- notes: 

document { 
     Key => {forceGB, (forceGB,Matrix)},
     Headline => "declare that the columns of a matrix are a Groebner basis",
     Usage => "forceGB f",
     Inputs => {
	  "f" => Matrix => null
	  },
     Outputs => {
	  GroebnerBasis => null
	  },
     "Declares that the columns of the matrix ", TT "f", "
     constitute a Groebner basis, and returns a Groebner basis object
     encapsulating that assertion.",
     PARA,
     "Sometimes one knows that a set of polynomials (or columns of such)
     form a Groebner basis, but ", EM "Macaulay 2", " doesn't.  This is the
     way to inform the system of this fact.",
     EXAMPLE {
	  "gbTrace = 3;",
	  "R = ZZ[x,y,z];",
	  "f = matrix{{x^2-3, y^3-1, z^4-2}};",
	  "g = forceGB f"},
     "This Groebner basis object is stored with the matrix and can be
     obtained as usual:",
     EXAMPLE {
	  "g === gb(f, StopBeforeComputation=>true)"
	  },
     "Requesting a Groebner bsis for ", TT "f", " requires no 
     computation.",
     EXAMPLE {
	  "gens gb f"
	  },
     Caveat => {"If the columns do not form a Groebner basis, 
	  nonsensical answers may result"},
     SeeAlso => {"Groebner bases"}
     }
document { 
     Key => [forceGB, ChangeMatrix],
     Headline => "inform Macaulay2 about the change of basis matrix from GB to generators",
     Usage => "forceGB(...,ChangeMatrix=>m)",
     Inputs => {
	  "m" => Matrix => null
	  },
     Consequences => {
	  "Set the change of basis matrix from the Groebner basis
	  to the original generators"
	  },     
     "The matrix ", TT "m", " should have size a by b, where a is the
     number of columns of the original matrix, and b is the number
     of columns of f.",
     EXAMPLE {
	  "gbTrace = 3",
	  "R = ZZ[x,y,z];",
	  "f = matrix{{x^2-3, y^3-1, z^4-2}};",
	  "g = forceGB(f, ChangeMatrix=>id_(source f));",
	  "x^2*y^3 // g"
	  },
     Caveat => {},
     SeeAlso => {}
     }
document { 
     Key => [forceGB, MinimalMatrix],
     Headline => "inform Macaulay2 about the minimal generator matrix",
     Usage => "",
     Inputs => {
	  },
     Consequences => {
	  },     
     "description",
     EXAMPLE {
	  },
     Caveat => {},
     SeeAlso => {}
     }
document { 
     Key => [forceGB, SyzygyMatrix],
     Headline => "inform Macaulay2 about the syzygy matrix",
     Usage => "forceGB(f,SyzygyMatrix=>z,...)",
     Inputs => {
	  "z" => Matrix => null
	  },
     Consequences => {
	  {"A request for the syzygy matrix of ", 
	  TT "f", " will return ", TT "z"}
	  },
     "In the following example, the only computation being performed
     when asked to compute the ", TO kernel, " or ", TO syz, " of ", 
     TT "f", " is the minimal generator matrix of ", TT "z", ".",
     EXAMPLE {
	  "gbTrace = 3",
	  "R = ZZ[x,y,z];",
	  "f = matrix{{x^2-3, y^3-1, z^4-2}};",
	  "z = koszul(2,f)",
	  "g = forceGB(f, SyzygyMatrix=>z);",
	  "syz g -- no extra computation",
	  "syz f",
	  "kernel f",
	  },
     "If you know that the columns of z already form a set of minimal
     generators, then one may use ", TO forceGB, " once again.",
     Caveat => {"If the columns of ", TT "z", " do not generate the 
	  syzygy module of ", TT "f", ",
	  nonsensical answers may result"},
     SeeAlso => {"Groebner bases"}
     }
