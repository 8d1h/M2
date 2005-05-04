--- status: Draft
--- author(s): M2Fest 2005 -- Irena
--- notes: 

document { 
     Key => {frac, (frac,Ring), (frac,FractionField), (frac,EngineRing)},
     Headline => "construct a fraction field",
     TT "frac R", " -- construct the fraction field of the integral domain ",
	 TT "R", ".",
     EXAMPLE {
	  "F = frac ZZ",
	  "F = frac (ZZ[a,b])",
	  },
     "After invoking the ", TT "frac", " command, ",
	 "the elements of the ring are treated as elements ",
	 "of the fraction field:",
     EXAMPLE {
	      "R = ZZ/101[x,y]",
	      "f = x^2*y - y^3",
	      "K = frac R",
	      "f = x^2*y - y^3",
      	  "1/x + 1/y + 1/2"
	  },
     Usage => "frac R",
     Inputs => {
	  "R" => Ring => "an integral domain"
	  },
     Outputs => {
	  FractionField => {"the field of fractions of ", TT "R"}
	  },
	 "Another way to obtain ", TT "frac R", " is with ",
	 TT "x", TO "/", TT "y", " where ",
	 TT "x, y", " are elements of ", TT "R", ":",
     EXAMPLE {
	  "a/b^2",
	  },
     "One can form resolutions and Groebner bases of ideals in polynomial
	 rings over fraction fields, as in the following example.",
     EXAMPLE {
	      "S = K[u,v]",
		  "I = ideal(u^3 + v^3, u^2*v, u^4)",
		  "gens gb I",
		  "Ires = res I",
		  "Ires.dd_2"
	 },
	 "To compute a blowup of an ideal ", TT "I", " in ", TT "R",
	 ", compute the kernel of a map of a new polynomial ring
	 into a fraction field of ", TT "R", ", as shown below.",
     EXAMPLE {
		  "A = ZZ/101[a,b,c];",
	      "f = map(K, A, {x^3/y^4, x^2/y^2, (x^2+y^2)/y^4})",
		  "kernel f",
	 },
     Consequences => {
	  },     
     "The symbol ", TT "frac", " is also used as a key under which is stored 
     the fraction field of a ring.",
     Caveat => {"The input ring should be an integral domain.",
	 	  PARA,
	      "Currently, for ", TT "S", " as above, one cannot define ",
		  TT "frac S", " or fractions ", TT "u/v", 
		  ".  One can get around that by defining ",
		  TT "B = ZZ/101[x,y,u,v]", " and identify ",
		  TT "frac S", " with ", TT "frac B", "."
     },
     SeeAlso => {}
     }
 -- doc6.m2:163:     Key => fraction,
 -- doc6.m2:181:     Key => frac,
 -- normal_doc.m2:100:     Key => (ICfractions,Ring),
 -- overviewC.m2:876:     Key => "fraction fields",
