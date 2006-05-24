--- status: draft
--- author(s): Stillman
--- notes: 


document { 
     Key => {cokernel,
	  (cokernel, ChainComplexMap),
	  (cokernel, Matrix),
	  (cokernel, GradedModuleMap),
	  (cokernel, RingElement)},
     Headline => "cokernel of a map of modules, graded modules, or chaincomplexes",
     Usage => "cokernel f",
     Inputs => {
	  "f : A --> B" => {"a ", 
	       TO2(Matrix, "matrix"),
	       ", a ",
	       TO2(ChainComplexMap, "chain complex map"),
	       ", a ",
	       TO2(RingElement, "ring element"),
	       ", or a ",
	       TO2(GradedModuleMap, "graded module map")}
	  },
     Outputs => {
	  {"The object ", TT "B/(image f)"}
	  },
     PARA{},
     TT "coker", " is a synonym for ", TT "cokernel", ".",
     PARA{},
     "The generators of the cokernel are provided by the generators of the target
     of ", TT "f", ".  In other words, ", TT "cover target f", " and ", TT "cover cokernel f", " are equal.",
     PARA{},
     "An argument f which is a ", TO RingElement, " is interpreted as a one by one matrix.",
     EXAMPLE {
	  "R = ZZ[a..d];",
	  "M = cokernel matrix{{2*a-b,3*c-5*d,a^2-b-3}}"
	  },
     "If ", TT "f", " is a matrix, and the target of ", TT "f", " is a submodule, the resulting module will be a ",
     TO "subquotient", " module.",
     EXAMPLE {
	  "f = map(a*M, M, a^3+a^2*b)",
	  "(target f,source f)",
	  "N = cokernel f",
	  "minimalPresentation N"
	  },
     SeeAlso => {
	  cover,
	  image,
	  kernel,
	  coimage,
	  comodule,
	  minimalPresentation,
	  "matrices to and from modules"}
     }

TEST ///
    R = QQ[x,y,z]
    modules = {
	 image matrix {{x^2,x,y}},
	 coker matrix {{x^2,y^2,0},{0,y,z}},
	 R^{-1,-2,-3},
	 image matrix {{x,y}} ++ coker matrix {{y,z}}
	 }
    scan(modules, M -> assert( cover cokernel M_{1} ==  cover M ) )
///

