--- status: TODO
--- author(s): 
--- notes: 

document {
     -- this is the old version
     Key => cohomology,
     Headline => "general cohomology functor",
     TT "cohomology", " -- a method name available for computing expressions
     of the forms ", TT "HH^i(X)", " and ", TT "HH^i(M,N)", ".",
     PARA,
     "If it is intended that ", TT "i", " be of class ", TO "ZZ", ", ", TT "M", " be of
     class ", TT "A", ", and ", TT "N", " be of 
     class ", TT "B", ", then the method can be installed with ",
     PRE "     cohomology(ZZ, A, B) := opts -> (i,M,N) -> ...",
     SeeAlso => {"homology", "HH", "ScriptedFunctor"}
     }

document { 
     -- this will be the new version
     Key => cohomology,
     Headline => "",
     Usage => "",
     Inputs => {
	  },
     Outputs => {
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
     Key => (cohomology,ZZ,SheafOfRings),
     Headline => "",
     Usage => "",
     Inputs => {
	  },
     Outputs => {
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
     Key => (cohomology,ZZ,Module),
     Headline => "",
     Usage => "",
     Inputs => {
	  },
     Outputs => {
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
     Key => (cohomology,ZZ,SumOfTwists),
     Headline => "",
     Usage => "",
     Inputs => {
	  },
     Outputs => {
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
     Key => (cohomology,ZZ,Sequence),
     Headline => "",
     Usage => "",
     Inputs => {
	  },
     Outputs => {
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
     Key => (cohomology,ZZ,ChainComplex),
     Headline => "",
     Usage => "",
     Inputs => {
	  },
     Outputs => {
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
     Key => (cohomology,ZZ,CoherentSheaf),
     Headline => "",
     Usage => "",
     Inputs => {
	  },
     Outputs => {
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
     Key => [cohomology, Degree],
     Headline => "",
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
 -- doc10.m2:731:     Key => (cohomology, ZZ, Module),
 -- doc10.m2:936:     Key => (cohomology, ZZ, SumOfTwists),
 -- doc10.m2:962:     Key => (cohomology, ZZ, CoherentSheaf),
 -- doc12.m2:1032:     Key => cohomology,
 -- doc9.m2:1573:     Key => (cohomology,ZZ,ChainComplex),
 -- doc9.m2:1590:     Key => (cohomology,ZZ,ChainComplexMap),
