-- Copyright 1999-2002 by Anton Leykin and Harrison Tsai

/// *** DOCUMENT PATTERN ***
document { (functionName, Type, Type),
     Headline => "very short description",
     Usage => {
	  TT "functionName(Type,Type)", " -- do this and that "
	  },
     OldSynopsis => {
     	  "A = functionName(B,C)",
	  "B" => {"parameter description"},
	  "C" => {"parameter description"},
	  "A" => {"output description"}
	  },
     "...MAIN TEXT: DEFINITION, REFERENCES,..."
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"Line 1",
	"Line 2",
	"..."
	},
     CAVEAT {
	  "Small things that are wrong and/or peculiar"
	  },
     SEEALSO { "..." }
     }
///

INSERTUSAGE := l->{ --!!! until "Usage =>" doesn't work
     {BOLD "Usage: ", PARA, l, PARA} 
     }
needs "Dmodules/Dloadfile.m2";
document { "D-modules Package",
     Headline => "algorithms for D-modules",
     INSERTUSAGE {
	  "Load the package by typing: ", 
	  TT ///load "D-modules.m2"///, 
	  "."
	  },
     OldSynopsis => {
	  "Provides a collection of algorithms for D-modules"
	  },     
     FileName => "index",
     PARA,
     HEADER3 "How to make Weyl algebras:",
     UL{TO {"WeylAlgebra", " -- 
	       The class of Weyl algebras"}},
     
     PARA,
     HEADER3 "Basic commands:",
     UL{
	  TO {"gbw", " -- Groebner bases with respect to weight vectors"},
	  TO {"inw", " -- initial ideals with respect to weight vectors"},
	  TO {"Fourier", " -- Fourier transform"},
	  TO {"Dtransposition", " -- standard transposition"},
	  TO {"makeCyclic", " -- cyclic presentation"},
	  TO {"makeWeylAlgebra", 
	       " -- Weyl algebra associated to a polynomial ring"}
	  },
     
     PARA,
     HEADER3 "Some examples of D-modules:",
     UL{TO {"gkz", " -- Gelfand-Kapranov-Zelevinsky hypergeometric system"},
	  TO {"AppellF1", " -- Appell F1 system"},
	  TO {"PolyAnn", " -- annihilator of a polynomial"},
	  TO {"RatAnn", " -- annihilator of a rational function"}},
     PARA,
     HEADER3 "Basic invariants of D-modules:",
     UL{TO {"Ddim", " -- dimension"}, 
	  TO {"Drank"," -- holonomic rank"}, 
	  TO {"charIdeal", " -- characteristic ideal"},
	  TO {"singLocus", " -- singular locus"}},

     PARA,
     HEADER3 "B-functions:",
     UL {
	  TO {"bFunction", " -- b-function"}, 
	  TO {"globalBFunction", " -- global b-function"},
	  TO {"globalB", " -- global b-function and b-operator"},
	  TO {"globalBoperator", " -- global b-operator"},
	  TO {"paramBpoly", " -- Bernstein-Sato polynomials of a
	       polynomial with parametric coefficients"},
	  TO {"factorBFunction", " -- factors a univariate polynomial"},
	  TO {"getIntRoots", " -- gets integer roots of a b-function"},
	  {TO {"AnnFs"},  " -- annihilator ideal of ", EM "f", SUP "s" },
	  TO {"AnnIFs", " -- annihilator ideal  of ", EM "f", SUP "s", 
	       " for an arbitrary D-module"}
	  },
     PARA,
     HEADER3 "Resolutions and Functors:",
     UL{TO {"Dresolution", " -- resolutions"}, 
	  TO {"Dlocalize", " -- localization"}, 
     	  TO {"WeylClosure", " -- Weyl closure"},
	  TO {"Ddual", " -- holonomic dual"}, 
	  TO {"Drestriction", " -- derived restriction"},
	  TO {"Dintegration", " -- derived integration"},
	  TO {"DHom", " -- homomorphisms between holonomic D-modules"},
	  TO {"DExt", " -- Ext between holonomic D-modules"},
	  TO {"PolyExt", 
	       " -- Ext between a holonomic D-module and a polynomial ring"},
	  TO {"RatExt", 
	       " -- rational Ext"}
	  },     
     PARA,
     HEADER3 "Applications:",
     UL{
	  TO {"localCohom", "-- local cohomology"},
	  TO {"deRham", " -- deRham cohomology"},
	  TO {"PolySols", " -- polynomial solutions of finite rank systems"},
	  TO {"RatSols", " -- rational solutions of finite rank systems"},
	  TO {"diffOps", " -- differential operators on affine varieties"}
	  },
     PARA,
     HEADER3 "Programming aids:",
     UL{TO {"createDpairs", " -- tags coordinate and derivation variables"},
	  TO {"Dtrace", " -- toggles verbose comments"},
	  TO {"setHomSwitch", " -- toggles use of homogeneous Weyl algebra"}},
     PARA
     }
-----------------------------------------------
document { (ExternalProduct),
     Headline => "external product of modules or complexes"
     }
document { (ExternalProduct=>TwistMap),
     Headline => "indicates whether TwistMap should be computed"
     }
document { (TwistMap),
     Headline => "indicates whether TwistMap should be computed"
     }

document { (twistMap),
     Headline => "a key attached by ExternalProduct",
     "see ", TO "ExternalProduct"
     }
document { (twistInvMap),
     Headline => "a key attached by ExternalProduct",
     "see ", TO "ExternalProduct"
     }
document { (projMap1),
     Headline => "a key attached by ExternalProduct",
     "see ", TO "ExternalProduct"
     }
document { (projMap2),
     Headline => "a key attached by ExternalProduct",
     "see ", TO "ExternalProduct"
     }

document { (bFunction),
     UL {
	  {TO (bFunction, Ideal,List), " - for an ideal"},
	  {TO (bFunction, Module,List,List), " - for a module"}  
	  }
     }

document { (bFunction => Strategy),
     Headline => "specify strategy for computing b-function",
     UL { 
	  {BOLD "IntRing", " -- the simplest algorithm available. 
     	       The idea is to compute ", EM "in", SUB "(-w,w)", EM "(I) ", "
     	       intersect it with ", 
	       EM {"k[t", SUB "1", ",...,t", SUB "n", "]"}, 
	       "(", EM {"t", SUB "i", " = x", SUB "i", "D", SUB "i"}, ")",
     	       "Call the ideal obtained ", EM "J", ". 
	       Finally ", 
	       EM {"J + (t", SUB "1", 
		    " + ... + t", SUB "n", "- s) \\cap k[s]"},
	       " is generated by the b-function that we are looking for."
	       },
	  {BOLD "TryGeneric", " -- checks whether the ideal is generic 
	       and if that is the case uses Alg.5.1.5 
	       in Saito-Sturmfels-Takayama (1999) otherwise is eqivalent 
	       to ", TT "NonGeneric",
     	       },
	  {BOLD "NonGeneric", 
	       " -- uses 5.1.6 in Saito-Sturmfels-Takayama (1999)"
	       },
	  {"Default:", BOLD "IntRing"}
	  }
     }
document { (NonGeneric),
     Headline => "a strategy option for b-functions",
     "see ", TO "bFunction"
     }
document { (TryGeneric),
     Headline => "a strategy option for b-functions",
     "see ", TO "bFunction"
     }
document { (IntRing),
     Headline => "a strategy option for b-functions",
     "see ", TO "bFunction"
     }
document { (bFunction, Ideal, List),
     Headline => "b-function of an ideal",
     INSERTUSAGE {
	  TT "bFunction(I,w)", " -- find the b-function of ", EM "I", 
	  " with respect to weight vector ", EM "w"
	  },
     OldSynopsis => {
     	  "b = bFunction(I,w)",
	  "I" => {"a holonomic ideal in the Weyl algebra ", 
	       EM {"A", SUB "n", "(K)"}, "."},
	  "w" => {"a list of integer weights corresponding 
	       to the differential variables in the Weyl algebra."},
	  "b" => {"a polynomial ", EM "b(s)", " which is the b-function of ", 
	       EM "I", " with respect to ", EM "w"}
	  },
     "Use ", TO "setHomSwitch", "(true) to force all the subroutines 
     to use homogenized ", TO "WeylAlgebra",
     PARA,  
     BOLD "Definition. ", "The b-function ", EM "b(s)", 
     " is defined as the monic generator  
     of the intersection of ", 
     EM {"in", SUB "(-w,w)", "(I)"}, " and ", 
     EM "K[s]",
     ", where ", 
     EM {"s = [w", SUB "1", "t", SUB "1", " + ... + w", 
	  SUB "n", "t", SUB "n", "]"}, 
     " (here ", EM {"t", SUB "i", " = x", SUB "i", "D", SUB "i"}, ").", 
     EXAMPLE {
	"needs \"D-modules.m2\"",
	  "R = QQ[x_1,x_2,D_1,D_2,WeylAlgebra=>{x_1=>D_1,x_2=>D_2}]",
     	  "I = ideal(x_1, D_2-1)",
     	  "bFunction(I,{1, 0})",
     	  },
     CAVEAT {
	  "The ring of I should not have any parameters: 
     	  it should be a pure Weyl algebra. Similarly, this ring 
	  should not be a homogeneous ", TO "WeylAlgebra"
	  },
     SEEALSO { "globalBFunction", "factorBFunction" }
     }

document { (bFunction, Module, List, List),
     Headline => "b-function of a holonomic D-module",
     INSERTUSAGE {
	  TT "bFunction(M,w,m)", " -- find the b-function of ", EM "M", 
	  " with respect to weight vector ", EM "w", " and shift vector ", 
	  EM "m"
	  },
     OldSynopsis => {
	  "b = bFunction(M,w,m)",
	  "M" => {"a holonomic module over a Weyl algebra ", 
	       EM {"A", SUB "n", "(K)"}},
	  "w" => {"a list of integer weights corresponding 
	       to the differential variables in the Weyl algebra"},
	  "m" => {"a list of integers, each of which is 
	       the shift for the corresponding component"},
	  "b" => {"a polynomial ", EM "b(s)", " which is the b-function of ", 
	       	EM "M", " with respect to ", EM "w", 
	       	" and ", EM "m"}
	  },
     PARA,
     "The algorithm represents ", EM "M", " as ", EM "F/N", 
     " where ", EM "F", " is free and ", 
     EM "N", " is a submodule of ", EM "F", ". 
     Then it computes b-functions ", EM {"b", SUB "i", "(s)"}, 
     " for ", EM {"N \\cap F", SUB "i"}, " (i-th component of ", EM "F", 
     ") and outputs ",
     EM {"lcm{ b", SUB "i", "(s-m", SUB "i",") }"},
     PARA,
     EXAMPLE{
	"needs \"D-modules.m2\"",
	  "R = QQ[x, dx, WeylAlgebra => {x=>dx}]",
	  "M = cokernel matrix {{x^2, 0, 0}, {0, dx^3, 0}, {0, 0, x^3}}",
	  "factorBFunction bFunction(M, {1}, {0,0,0})",
	  "factorBFunction bFunction(M, {1}, {1,2,3})"
     	  },
     CAVEAT => {
	  "The Weyl algebra should not have any parameters. 
     	  Similarly, it should not be a homogeneous Weyl algebra"
	  },
     SEEALSO => { "globalBFunction", "factorBFunction" }
     }


document { (globalBFunction => Strategy),
     Headline => "specify strategy for computing global b-function",
     SHIELD UL { 
	  {BOLD "IntRing, TryGeneric, NonGeneric", 
	       " -- passed to ", TO "bFunction",  ", see ", 
	       TO (bFunction => Strategy) },
	  {BOLD "ViaAnnFs", " -- computes ", 
	       EM "J(s)=Ann(f", SUP "s", EM ")", " and then intersects ", 
	       EM "J(s)+D[s]f}", " with ", EM "K[s]"},
	  {BOLD "ReducedB", " -- computes ", EM "b(s)/(s+1)", 
	       " by taking the intersection of ",
	       EM "J(s)+D[s](f,df/dx1,...,df/dxn)", " with ", EM "K[s]",
	       ", then multiplies by ", EM "s+1", "."},
	  {"Default: ", BOLD "ReducedB"}
	  }
     }

document { (ViaAnnFs),
     Headline => "a strategy option for global b-functions",
     "see ", TO "globalBFunction"
     }
document { (ReducedB),
     Headline => "a strategy option for global b-functions",
     "see ", TO "globalBFunction"
     }

document {  (globalBFunction),
     Headline => {"global b-function (else known as 
	  the Bernstein-Sato polynomial)"},
     INSERTUSAGE {
	  TT "globalBFunction f", " -- find the global b-function of ", TT "f"
	  },
     OldSynopsis => {
     	  "b = globalBFunction(f)",
	  "f" => {"a polynomial in a Weyl algebra 
	       (should not contain differential variables)"},
	  "b" => {"the b-function ", EM "b(s)",  " in ", EM "Q[s]"}
	  },
     PARA,
     BOLD "Definition. ", "Let ", 
     EM "D = A_{2n}(K) = K<x_1,...,x_n,d_1,...,d_n>", 
     " be a Weyl algebra. 
     The Bernstein-Sato polynomial of a polynomial f is defined 
     to be the monic generator of the ideal of all polynomials ", 
     EM "b(s)", " in ", EM "K[s]", " such that
     ", EM " b(s) f^s = Q(s,x,d) f^{s+1}", " where ", EM "Q", 
     " lives in ", EM "D[s].",
     PARA,
     BOLD "Algorithm. ", 
     "Let ", 
     EM "I_f = D<t,dt>*<t-f, d_1+df/dx_1*dt, ..., d_n+df/dx_n*dt> ",
     "Let ", EM "B(s) = bFunction(I, {1, 0, ..., 0})", 
     " where 1 in the weight that corresponds to ", EM "dt. ", 
     "Then the global b-function is ", EM "b_f = B(-s-1)",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	  "R = QQ[x, dx, WeylAlgebra => {x=>dx}]",
     	  "f = x^10",
    	  "globalBFunction f"
     	  },
     CAVEAT => {
	  "The Weyl algebra should not have any parameters. 
     	  Similarly, it should not be a homogeneous Weyl algebra"
	  },
     SEEALSO => { "bFunction", "factorBFunction" }
     }
               
document { (factorBFunction--!!!, RingElement
	  ),
     Headline => "factor b-function",
     INSERTUSAGE {
	  TT "factorBFunction b", " -- factor polynomial ", TT "b"
	  },
     OldSynopsis => {
     	  "f = bFunction b",
	  "b" => {"a polynomial obtained via one of the b-function routines"},
	  "f" => {"the factorization of ", TT "b"}
	  },
     PARA,
     BOLD "Fact. ", "The roots of any b-function are rational.",
     EXAMPLE {
  	"needs \"D-modules.m2\"",
	"R = QQ[x, dx, WeylAlgebra => {x=>dx}]",
     	  "f = x^10",
     	  "b = globalBFunction f",
     	  "factorBFunction b"
     	  },
     CAVEAT {
	  "f should be an output of one of the b-function routines"
     	  },
     SEEALSO { 
	  "bFunction",
	  "globalBFunction"
	  }
     }  

document { (getIntRoots--, RingElement
	  ),
     Headline => "get integer roots of a b-function"
     }

document { (globalB), 
     Headline => "compute global b-function and b-operator 
          for a D-module and a polynomial",
     INSERTUSAGE {
	  TT "globalB(I,f)", " -- find global b-function and b-operator 
          for a D-module and a polynomial"
	  },
     OldSynopsis => {
	  "H = globalB(I,f)", 
	  "I" => {"a holonomic ideal"},
	  "f" => {"a polynomial in a Weyl algebra 
	       (should not contain differential variables)"},
	  "H" => {"a hashtable containing the fields ",  
	       TT "Bpolynomial", " and ", TT "Boperator"}
	  },
     PARA,
     "The algorithm used here is a modification of the original
     algorithm of Oaku for computing Bernstein-Sato polynomials",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	  "R = QQ[x, dx, WeylAlgebra => {x=>dx}]",
     	  "f = x^7",
     	  "b = globalB(ideal dx, f)",
     	  "factorBFunction b.Bpolynomial" 
     	  },
     SEEALSO { "bFunction", "globalBFunction", "factorBFunction" }
     }  
document { (Boperator),
     Headline => "a key attached by globalB and Dlocalize",
     SEEALSO { "globalB", "Dlocalize" }
     }
document { (Bpolynomial),
     Headline => "a key attached by globalB",
     "see ", TO "globalB"
     }
document { (globalBoperator),
     Headline => "compute a b-operator of a polynomial",
     SEEALSO{"globalB"}
     } 

document { (AnnFs--, RingElement
	  ),
     Headline => "annihilator of f^s",
     INSERTUSAGE {
	  TT "AnnFs(f)", " -- find the annihilator ideal of ", 
	  EM {"f", SUP "s"}, " in the ring ", EM {"A", SUB "n", "[s]"}
	  },
     OldSynopsis => {
	  "I = AnnFs(f)",
	  "f" => { 
	       "a polynomial in a Weyl algebra ", EM {"A", SUB "n"},  
	       " (should contain no differential variables)" 
	       },
	  "I" => {"an ideal of ", EM {"A", SUB "n", "[s]"}}
	  },
     "The annihilator ideal is needed to compute a D-module 
     representation of the localization of ", 
     EM {"k[x", SUB "1", ",...,x", SUB "n", "]"}, " at ", EM "f", ".",
     EXAMPLE {
	"needs \"D-modules.m2\"",
     	  "R = QQ[x_1..x_4, z, d_1..d_4, Dz, ", 
	  "       WeylAlgebra => (toList(1..4)/(i -> (x_i=>d_i)) | {z=>Dz})]",
     	  "f = x_1 + x_2 * z + x_3 * z^2 + x_4 * z^3",
     	  "AnnFs f"
     	  },
     CAVEAT {"
	  The ring of f should not have any parameters, 
     	  i.e. it should be a pure Weyl algebra. 
	  Also this ring should not be a homogeneous Weyl algebra."},
     SEEALSO {"AnnIFs", "WeylAlgebra"}
     }  

document { (AnnIFs--, Ideal, RingElement
	  ), 
     Headline => "the annihilator ideal for an arbitrary D-module", 
     INSERTUSAGE {
	  TT "AnnIFs(f)", " -- find the annihilator ideal of ", 
	  EM {"f", SUP "s", " \\otimes 1", SUB {"A", SUB "n", "/I"}}, 
	  " in the ring ", EM {"A", SUB "n", "[s]"}
	  },
     OldSynopsis => {
	  "J = AnnIFs(I,f)",
	  "I" => {
	       "represents a holonomic D-module ", 
	       EM {"A", SUB "n", "/I"}
	       },
	  "f" => {"an element of Weyl algebra", EM {"A", SUB "n"}},
	  "J" => {"the annihilating ideal"}
	  },
     EXAMPLE {
	"needs \"D-modules.m2\"",
	  "W = QQ[x,dx, WeylAlgebra=>{x=>dx}]",
	  "AnnIFs (ideal dx, x^2)"
	  }, 
     CAVEAT => {"
     	  Caveats and known problems: The ring of f should not have any 
	  parameters: it should be a pure Weyl algebra. Similarly, 
	  this ring should not be a homogeneous Weyl algebra."
     	  },
     SEEALSO => {"AnnFs", "WeylAlgebra"}
     }  

document { (Dtrace--, ZZ
	  ),
     Headline => "set the depth of comments made by D-module routines",
     OldSynopsis => {
	  "o = Dtrace n",
	  "n" => { "new level" },
	  "o" => { "old level" }
	  },
     SEEALSO {"getDtrace"}
     }  
document { getDtrace,
     Headline => "(internal) -- get the INFOLEVEL switch",
     SEEALSO {"Dtrace"}
     }  

document { (setHomSwitch--, Boolean
	  ),
     Headline => "toggles use of homogeneous Weyl algebra",
     INSERTUSAGE {"sets the switch that determines whether homogenized 
	  ", TO "WeylAlgebra", 
	  " is used in certain D-module algorithms"},
     OldSynopsis => {
	  "o = setHomSwitch n",
	  "n" => { "new value" },
	  "o" => { "old value" }
	  },
     SEEALSO {"getHomSwitch"}
     }  

document { getHomSwitch,
     Headline => "(internal) -- get the HOMOGENIZATION switch",
     SEEALSO {"setHomSwitch"}
     }  

document { (localCohom => Strategy),
     Headline => "specify strategy for local cohomology",
     "This option together with ", TO "LocStrategy", " determines a strategy for ", 
     TT "localCohom(...Ideal...)", " and ", TT "localCohom(...Ideal, Module...)", ".",
     UL { 
	  {BOLD "Walther", " -- the algorithm of U. Walther that uses Cech complex."},
	  {BOLD "LocStrategy => null", 
	       " -- used only for ", TT "localCohom(...Ideal...)", 
	       ", localizations are done by straitforward computation of 
	       annihilators and b-polynomials as described in [1]."},
	  {BOLD "LocStrategy => OaTaWa", 
	       " -- localizations are done following Oaku-Takayama-Walther method."},
	  {BOLD "LocStrategy => Oaku", 
	       " -- localizations are done following Oaku's algorithm."},
	  {BOLD "OaTa", " -- restriction algorithm is used, 
	       which is due to T. Oaku and N. Takayama [2]"}   
	  },
          --CAVEAT {"When WaltherOTW strategy is used the error 'Bad luck!' 
          --may appear. This means your are not a lucky individual...
	  --The glitch is due to the fact that the localizations are iterated 
	  --for this particular strategy; it was resolved for WaltherOaku, 
	  --a strategy that considers everyone lucky."
	  --},
     "For detailed description of the algorithms see",
     UL {
	  {BOLD "[1]", "U. Walther, ", 
	       EM "Algorithmic computation of local cohomology 
	       modules and the local cohomological dimension of algebraic 
	       varieties (JPAA (139), 1999.)"
	       },
	  {BOLD "[2]", "Oaku, Takayama", 
	       EM "Algorithms for D-modules..."
	       }
	  }    	      
     } 
document { (Walther),
     Headline => "an option for localCohom=>Strategy",
     "see ", TO "localCohom"
     } 
document { (OaTa),
     Headline => "an option for localCohom=>Strategy",
     "see ", TO "localCohom"
     } 
document { (LocStrategy) }
document { (localCohom => LocStrategy),
     Headline => "specify localization strategy for local cohomology",
     "See ", TO (localCohom => Strategy)
     }
document { (OaTaWa),
     Headline => "an option for localCohom => LocStrategy",
     SEEALSO "localCohom"
     }
document { (localCohom),
     Headline => "local cohomology",
     "Local cohomology of a polynomial ring:",
     UL {
	  {TO (localCohom, Ideal)},
	  {TO (localCohom, List, Ideal)},
	  {TO (localCohom, ZZ, Ideal)}
	  },
     "Local cohomology of a holonomic module:",
     UL {
	  {TO (localCohom, Ideal, Module)},
	  {TO (localCohom, ZZ, Ideal, Module)},
	  {TO (localCohom, List, Ideal, Module)}
	  } 
     }
document { (localCohom, Ideal),
     Headline => "local cohomology of a polynomial ring",
     INSERTUSAGE {
	  TT "localCohom I", " -- find local cohomology ", 
	  EM {"H", SUB "I", "(R)"}, " where ", EM "I", 
	  " is an ideal of ", EM "R", ", which is a ring of polynomials" 
	  },
     OldSynopsis => { 
	  "H = localCohom I", 
	  "I" => {
	       "an ideal of ", 
	       EM {"R = k[x", SUB "1", ",...,x", SUB "n", "]"}
	       },
	  "H" => {
	       "each entry of ", TT "H", " has an integer key and 
	       contains the cohomology module in the corresponding degree."
	       }
	  },
     EXAMPLE {
	"needs \"D-modules.m2\"",
	  "W = QQ[X, dX, Y, dY, Z, dZ, WeylAlgebra=>{X=>dX, Y=>dY, Z=>dZ}]",
     	  "I = ideal (X*(Y-Z), X*Y*Z)",
     	  "h = localCohom I",
     	  "pruneLocalCohom h"
	  },
     CAVEAT {"The modules returned are not simplified, 
     	  use ", TO "pruneLocalCohom", "."}
     }  

document { (localCohom, List, Ideal),
     Headline => "local cohomology of a polynomial ring",
     INSERTUSAGE {
	  TT "localCohom(l,I)",
	  " -- compute the local cohomology in the degrees specified by ", EM "l"
	  },
     "See ", TO "localCohom Ideal", " for the full description.",
     EXAMPLE { 
	"needs \"D-modules.m2\"",
	  "W = QQ[X, dX, Y, dY, Z, dZ, WeylAlgebra=>{X=>dX, Y=>dY, Z=>dZ}]",
     	  "I = ideal (X*(Y-Z), X*Y*Z)",
     	  "h = localCohom({1,2}, I)",
     	  "pruneLocalCohom h"
	  }
     }

document { (localCohom, ZZ, Ideal),
     Headline => "local cohomology of a polynomial ring",
     INSERTUSAGE {
	  TT "localCohom(d,I)",
	  " -- compute the local cohomology in degree ", EM "d"
	  },
     "See ", TO "localCohom Ideal", " for the full description.",
     EXAMPLE { 
	"needs \"D-modules.m2\"",
	  "W = QQ[X, dX, Y, dY, Z, dZ, WeylAlgebra=>{X=>dX, Y=>dY, Z=>dZ}]",
     	  "I = ideal (X*(Y-Z), X*Y*Z)",
	  "h = localCohom (2,I)",
     	  "pruneLocalCohom h"
	  }
     }

document { (localCohom, Ideal, Module),
     Headline => "local cohomology of a D-module",
     INSERTUSAGE {
	  TT "localCohom(I,M)", " -- find local cohomology ", 
	  EM {"H", SUB "I", "(M)"}, " where ", EM "I", 
	  " is an ideal in a polynomial ring and ", EM "M", " is a D-module"
	  },
     OldSynopsis => { 
	  "H = localCohom(I,M)", 
	  "I" => {
	       "an ideal of ", 
	       EM {"R = k[x", SUB "1", ",...,x", SUB "n", "]"}
	       },
	  "M" => {
	       "a holonomic module over Weyl algebra ", 
	       EM{"A", SUB "n", "(k)"}
	       },
	  "H" => {
	       "each entry of ", TT "H", " has an integer key and 
	       contains the cohomology module in the corresponding degree."
	       }
	  },
     EXAMPLE {
	"needs \"D-modules.m2\"",
	  "W = QQ[X, dX, Y, dY, Z, dZ, WeylAlgebra=>{X=>dX, Y=>dY, Z=>dZ}]",
     	  "I = ideal (X*(Y-Z), X*Y*Z)",
     	  "h = localCohom(I, W^1 / ideal{dX,dY,dZ})",
     	  "pruneLocalCohom h"
	  },
     CAVEAT {"The modules returned are not simplified, 
     	  use ", TO "pruneLocalCohom", "."}
     }

document { (localCohom, ZZ, Ideal, Module),
     Headline => "local cohomology of a D-module",
     INSERTUSAGE {
	  TT "localCohom(d,I,M)", " -- find local cohomology ", 
	  EM {"H", SUB "I", "(M)"}, " in degree ", EM "d", ", where ", EM "I", 
	  " is an ideal in a polynomial ring and ", EM "M", " is a D-module"
	  },     
     "See ", TO "localCohom(Ideal,Module)", " for the full description.",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	  "W = QQ[X, dX, Y, dY, Z, dZ, WeylAlgebra=>{X=>dX, Y=>dY, Z=>dZ}]",
     	  "I = ideal (X*(Y-Z), X*Y*Z)",
	  "h = localCohom(2, I, W^1 / ideal{dX,dY,dZ})",
	  "pruneLocalCohom h"
	  }
     }

document { (localCohom, List, Ideal, Module),
     Headline => "local cohomology of a D-module",
     INSERTUSAGE {
	  TT "localCohom(l,I,M)", " -- find local cohomology ", 
	  EM {"H", SUB "I", "(M)"}, " in degrees listed in ", EM "l", 
	  ", where ", EM "I", 
	  " is an ideal in a polynomial ring and ", EM "M", " is a D-module"
	  },     
     "See ", TO "localCohom(Ideal,Module)", " for the full description.",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	  "W = QQ[X, dX, Y, dY, Z, dZ, WeylAlgebra=>{X=>dX, Y=>dY, Z=>dZ}]",
     	  "I = ideal (X*(Y-Z), X*Y*Z)",
	  "h = localCohom({1,2}, I, W^1 / ideal{dX,dY,dZ})",
	  "pruneLocalCohom h"
	  }
     }

document { (pruneLocalCohom),
     Headline => "prunes local cohomology modules",
     SEEALSO {"localCohom"} 
     }
document { (paramBpoly=>GroundField),
     Headline => "characteristic for modular computation"
     }
document {(GroundField)}
document { (paramBpoly),
     Headline => "compute the list of all possible Bernstein-Sato polynomials 
     for a polynomial with parametric coefficients",
     OldSynopsis => { 
	  "L = paramBpoly(f,filename)", 	  
     	  "f" => {
	       "a polynomial in Weyl algebra ", EM "A_n(Q)"
	       },
	  "filename" => {"the base name for the output files"},
	  "L" => {"Bernstein-Sato polynomials"}
	  },
     "Also the file <filename.tex> that contains the list of 
     the BS-polynomials and the corresponding constructible sets.",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	  "A =  (QQ [a,b,c]) [x, y, Dx, Dy, WeylAlgebra => {x=>Dx, y=>Dy}]",
     	  "paramBpoly(a*x^2 + b*x*y + c*y^2, \"quadratic\")"
	  },
     CAVEAT {
	  "A finite field should be used in place of ", EM "Q", 
	  " in order to speed up computations. This routine works only
	  on relatively small examples."
	  }
     }  

document { (makeCyclic),
     Headline => "finds a cyclic generator of a D-module",
     OldSynopsis => {
     	  "H = makeCyclic M", 
	  "M" => {
	       "a map such that ", TT "coker M", " is a 
	       holonomic D-module"
	       },
	  "H" => {TT "H.Generator", " is a cyclic generator
	       and ", TT "H.AnnG", " is the annihilator ideal 
	       of this generator"} 
	  },
     "It is proven that every holonomic module is cyclic and 
     there is an algorithm for computing a cyclic generator.",
     EXAMPLE{
	"needs \"D-modules.m2\"",
	  "W = QQ[x, dx, WeylAlgebra => {x=>dx}]",
	  "M = matrix {{dx,0,0},{0,dx,0},{0,0,dx}} -- coker M = QQ[x]^3", 
	  "h = makeCyclic M"
	  },
     CAVEAT {"The module ", EM "M", " must be holonomic."},
     SEEALSO {"isHolonomic"}
     }  
document {(Generator),
     Headline => "a key created by makeCyclic",
     "See ", TO "makeCyclic", "."
     }
document {(AnnG),
     Headline => "a key created by makeCyclic",
     "See ", TO "makeCyclic", "."
     }

document {(isHolonomic),
     Headline => "determines whether a D-module (or ideal in Weyl algebra) is holonomic"
     } 
document {(DHom=>Strategy),
	  "Option is passed to Dresolution. See ",
	  TO (Dresolution=>Strategy)
}
document { (DHom),
     Headline=>"D-homomorphisms between holonomic D-modules",
     INSERTUSAGE {
     TT "DHom (M, N)", " -- computes a basis of
     D-homomorphisms between holonomic D-modules M and N.",
     BR, NOINDENT,
     TT "DHom (I, J)", " -- computes a basis of
     D-homomorphisms between D/I and D/J."
     },
     "The set of D-homomorphisms between two holonomic modules ", EM "M",
     " and ", EM "N",
     " is a finite-dimensional vector space over the ground field.
     Since a homomorphism is defined by where it sends a set of generators,
     the output of this command is a list of matrices whose columns
     correspond to the images of the generators of ", EM "M", ".  Here
     the generators of ", EM "M", " are determined from its presentation
     by generators and relations.",

     PARA,
     "The algorithm used appears in the paper 'Computing homomorphisms
     between holonomic D-modules' by Tsai-Walther(2000).
     The method is to combine isomorphisms of Bjork and Kashiwara with
     the restriction algorithm.",

     PARA,
     "A simple example:",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"W = QQ[x, D, WeylAlgebra=>{x=>D}]",
     	"M = W^1/ideal(D-1)",
     	"N = W^1/ideal((D-1)^2)",
     	"DHom(M,N)"
	},
     PARA,
     CAVEAT {"Input modules ", EM "M", ", ", EM "N", ", ", 
	  EM "D/I", " and ", EM "D/J",
	  " should be holonomic."},
     SEEALSO {"DExt", "Drestriction"}
     }

document {(DExt=>Strategy),
	  "Option is passed to Dresolution. See ",
	  TO (Dresolution=>Strategy)
}
document {(DExt=>Special)}
document {(Special),
     SEEALSO "DExt"}
document {(None),
     Headline => "an option for DExt=>Special",
     SEEALSO "DExt"
     }
document {(DExt=>Output)}
document {(Output)}
document {(DExt=>Info)}
document {(Info)}
document { (DExt),
     Headline => "dimensions of Ext groups between holonomic modules",
     INSERTUSAGE {
     TT "DExt (M, N)", " -- 
     computes the dimensions of the Ext groups between
     holonomic M and holonomic N.",
     BR, NOINDENT,
     TT "DExt (I, J)", " -- 
     computes the dimensions of the Ext groups between
     holonomic D/I and holonomic D/J."
     },

     "The ", TT "Ext", " groups between D-modules ", EM "M"," and ",EM "N",
     " are the derived functors of ", TT "Hom", ", and are finite-dimensional
     vector spaces over the ground field when", EM "M", " and N are holonomic.",
     PARA,
     "The algorithm used appears in the paper 'Polynomial and
     rational solutions of holonomic systems' by Oaku-Takayama-Tsai (2000).
     The method is to combine isomorphisms of Bjork and Kashiwara with
     the restriction algorithm.",
     PARA,
     "A simple example:",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"W = QQ[x, D, WeylAlgebra=>{x=>D}]",
     	"M = W^1/ideal(x*(D-1))",
     	"N = W^1/ideal((D-1)^2)",
     	"DExt(M,N)"
	},
     PARA,
     CAVEAT{"Input modules M, N, D/I, or D/J should be holonomic.",
	  "Does not yet compute explicit reprentations of Ext groups
	  such as Yoneda representation."},

     SEEALSO {"DHom", "Drestriction"}
     }

document { (PolySols=>Alg),
     Headline => "algorithm for finding polynomial solutions",
     UL {
	  {BOLD "GD", " -- uses Groebner deformations"},
	  {BOLD "Duality", " -- uses homological duality"}
	  }     
     }
document { (Alg) }
document { (GD),
     Headline => "an option for PolySols=>Alg",
     SEEALSO "PolySols" 
     }
document { (Duality),
     Headline => "an option for PolySols=>Alg",
     SEEALSO "PolySols" 
     }
document { (PolySols),
     Headline => "polynomial solutions of a holonomic system",
     INSERTUSAGE {
     TT "PolySols I", " -- computes a basis of the polynomial solutions
     of a holonomic ideal I",
     BR, NOINDENT,
     TT "PolySols M", " -- computes a basis of D-homomorphisms
     between a holonomic module M and the polynomial ring",
     BR, NOINDENT,
     TT "PolySols (I, w)", " -- computes a basis of polynomial solutions
     of I using the weight vector w for Groebner deformations",
     BR, NOINDENT,
     TT "PolySols (M, w)", " -- computes a basis of D-homomorhpisms between
     M and the polynomial ring using w for Groebner deformations"
     },

     "The polynomial solutions of a holonomic system form a
     finite-dimensional vector space.
     There are two algorithms implemented to get these solutions.
     The first algorithm is based on Groebner deformations and
     works for ideals ", EM "I", " of PDE's -- see the paper 'Polynomial
     and rational solutions of a holonomic system' by 
     Oaku-Takayama-Tsai (2000).  The second algorithm is based
     on homological algebra -- see the paper 'Computing
     homomorphims between holonomic D-modules' by Tsai-Walther (2000).",

     PARA,
     "A simple example:",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"W = QQ[x, D, WeylAlgebra=>{x=>D}]",
     	"I = ideal(D^2, (x-1)*D-1)",
     	"PolySols I"
	},
     PARA,
     SEEALSO {"RatSols", "Dintegration"}
     },

document {(PolyExt=>Strategy),
	  "Option is passed to Dresolution. See ",
	  TO (Dresolution=>Strategy)
}
document { (PolyExt),
     Headline => "dimensions of Ext groups between 
     a holonomic module and a polynomial ring",
     INSERTUSAGE {
     TT "PolyExt M", " -- 
     computes the dimensions of the Ext groups between
     holonomic M and the polynomial ring.",
     BR, NOINDENT,
     TT "PolyExt I", " -- 
     computes the dimensions of the Ext groups between
     holonomic D/I and the polynomial ring."
     },

     "The ", TT "Ext", " groups between a D-module ", EM "M", 
     " and the polynomial ring are the derived functors of ", TT "Hom", 
     ", and are finite-dimensional vector spaces over the ground field when ",
     EM "M", " is holonomic.",
     PARA,
     "The algorithm used appears in the paper 'Polynomial and
     rational solutions of holonomic systems' by Oaku-Takayama-Tsai (2000).
     The method is to combine isomorphisms of Bjork and Kashiwara with
     the restriction algorithm.",
     PARA,
     "A simple example:",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"W = QQ[x, D, WeylAlgebra=>{x=>D}]",
     	"M = W^1/ideal(x^2*D^2)",
     	"PolyExt(M)"},
     PARA,
     CAVEAT{"Does not yet compute explicit representations of
	  Ext groups such as Yoneda representation."},
     SEEALSO {"PolySols", "RatExt", "DExt", "Dintegration"}
     }

document { (RatSols),
     Headline => "rational solutions of a holonomic system",
     INSERTUSAGE {
     TT "RatSols I", " -- computes a basis of the rational solutions
     of a holonomic ideal I",
     BR, NOINDENT,
     TT "RatSols (I, f)", " -- computes a basis of rational solutions to I
     with poles along f",
     BR, NOINDENT,
     TT "RatSols (I, f, w)", " -- computes a basis of rational solutions
     to I with poles along f
     using the weight vector w for Groebner deformations",
     BR, NOINDENT,
     TT "PolySols (I, ff, w)", " -- computes a basis of rational sollutions
     with poles along the polynomials in the list ff 
     using w for Groebner deformations"
     },

     "The rational solutions of a holonomic system form a
     finite-dimensional vector space.
     The only possibilities for the poles of a rational solution
     are the codimension one components of the singular locus.
     An algorithm to compute rational solutions 
     is based on Groebner deformations and
     works for ideals ", EM "I", " of PDE's -- see the paper 'Polynomial
     and rational solutions of a holonomic system' by 
     Oaku-Takayama-Tsai (2000).",
     
     PARA,
     "A simple example:",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"W = QQ[x, D, WeylAlgebra=>{x=>D}]",
     	"I = ideal((x+1)*D+5)",
     	"RatSols I"
	},
     PARA,
     CAVEAT{"The most efficient method to find rational solutions is
	  to find the singular locus, then try to find its irreducible
	  factors.  With these, call RatSols(I, ff, w), where w
	  should be generic enough so that the PolySols routine
	  will not complain of a non-generic weight vector."},
     
     SEEALSO {"PolySols", "RatExt", "DHom"} 
     },

document {(RatExt=>Strategy),
	  "Option is passed to Dresolution. See ",
	  TO (Dresolution=>Strategy)
}
document { (RatExt),
     Headline => 
     "dim Ext(holonomic D-module, polynomial ring localized at the sigular locus)",
     INSERTUSAGE {
     TT "RatExt M", "-- 
     computes the dimensions of the Ext groups between
     holonomic M and the polynomial ring localized at 
     the singular locus of M.",
     BR, NOINDENT,
     TT "RatExt I", "-- 
     computes the dimensions of the Ext groups between
     D/I and the polynomial ring localized at 
     the singular locus of D/I.",
     BR, NOINDENT,
     TT "RatExt (M, f)", "-- 
     computes the dimensions of the Ext groups between
     M and the polynomial ring localized at f.",
     BR, NOINDENT,
     TT "RatExt (I, f)", "-- 
     computes the dimensions of the Ext groups between
     D/I and the polynomial ring localized at f."
     },

     "The Ext groups between M and N
     are the derived functors of Hom, and are finite-dimensional
     vector spaces over the ground field when M and N are holonomic.",
     PARA,
     "The algorithm used appears in the paper 'Polynomial and
     rational solutions of holonomic systems' by Oaku-Takayama-Tsai (2000).
     The method is to combine isomorphisms of Bjork and Kashiwara with
     the restriction algorithm.",
     PARA,
     "A simple example:",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"W = QQ[x, D, WeylAlgebra=>{x=>D}]",
     	"M = W^1/ideal(x*D+5)",
     	"RatExt(M)"},
     PARA,
     CAVEAT{"Input modules M or D/I should be holonomic."},

     SEEALSO {"Dresolution", "Dintegration"}
     }

document { WeylAlgebra,
     TT "WeylAlgebra", " --
     name for an optional argument for a monoid that
     specifies that a PolynomialRing created from it will
     be a Weyl Algebra.",

     PARA,
     "The n-th Weyl algebra is the associative ring on 2n variables,
     e.g. K<x_1..x_n, D_1..D_n>, where all the variables commute except
     for (D_i x_i = x_i D_i + 1).  It can be viewed as the ring
     of algebraic differential operators on affine space K^n.",

     PARA,
     "A simple example:",
     EXAMPLE {
	"W = QQ[x,y,Dx,Dy, WeylAlgebra => {x=>Dx,y=>Dy}]",
     	"x*Dx", 
     	"Dx*x"},     
     PARA,
     "Caveats and known problems:",
     UL{"The variables can be called by any name, but for each
	  pair such as x => Dx, the commutative variable (in this case x)
	  must be listed before the derivation variable (in this case Dx)"}
     }

document { (createDpairs),
     Headline => "sorts out the variables in Weyl algebra",
     INSERTUSAGE {
     TT "createDpairs W", " -- 
     attaches to a Weyl algebra W a pair of keys to help distinguish the
     coordinate variables from the derivation variables."
     },

     "Since the Weyl algebra has commutation rules, this routine
     attaches to the Weyl algebra two keys to organize the
     variables.  The first key 'dpairVars' contains 3 lists: a list of the coordinate
     variables, a list of the derivative variables, and a list
     of the central variables.  The second key 'dpairInds' also contains 3 lists
     of the corresponding indices to 'dpairVars'.",

     PARA,
     "A simple example:",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"W = QQ[x,y,Dx,Dy, WeylAlgebra => {x=>Dx,y=>Dy}]",
     	"createDpairs W", 
     	"W.dpairVars",
     	"W.dpairInds"
	},
     PARA,
     SEEALSO {"WeylAlgebra"}
     },

document { (dpairInds),
     Headline => "a key attached by createDpairs",
     "see ", TO "createDpairs"
     }
document { (dpairVars),
     Headline => "a key attached by createDpairs",
     "see ", TO "createDpairs"
     }

document { (Fourier),
     Headline => "Fourier transform for Weyl algebra",
     INSERTUSAGE {
     TT "Fourier L", " -- computes the Fourier transform of a ring element L",
     BR, NOINDENT,
     TT "Fourier I", " -- computes the Fourier transform of an ideal I",
     BR, NOINDENT,
     TT "Fourier M", " -- computes the Fourier transform of a matrix M"
     },

     "The Fourier transform is the automorphism of the Weyl algebra
     which sends ", EM {"x",SUB "i"}, " to ", EM {"D", SUB "i"}, " 
     and ", EM  {"D", SUB "i"}, " to ", EM {"-x",SUB "i"}, ".",
     PARA,
     "A simple example:",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"W = QQ[x,y,Dx,Dy, WeylAlgebra => {x=>Dx,y=>Dy}]",
     	"L = x^2*Dy + y*Dy^2 + 3*Dx^5*Dy",       
     	"Fourier L"
	},
     SEEALSO {"WeylAlgebra"}
     },

document { (Dtransposition),
     Headline => "standard transposition for Weyl algebra",
     INSERTUSAGE {
     TT "Dtransposition L", " -- computes the standard transposition of a ring element L",
     BR, NOINDENT,
     TT "Dtransposition I", " -- computes the standard transposition of an ideal I", 
     BR, NOINDENT,
     TT "Dtransposition m", " -- computes the standard transposition of a matrix L",
     BR, NOINDENT,
     TT "Dtransposition C", " -- computes the standard transposition of a chain complex C"
     },

     "The standard transposition is the involution of the Weyl algebra
     which sends ", EM {"x", SUP "a","d", SUP "b"}, " to ", 
     EM {"(-d)", SUP "b", "x", SUP "a"}, ".
     It provides the equivalence in the Weyl algebra between left
     and right D-modules.",
     PARA,
     "A simple example:",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"W = QQ[x,y,Dx,Dy, WeylAlgebra => {x=>Dx,y=>Dy}]",
     	"L = x^2*Dy + y*Dy^2 + 3*Dx^5*Dy",       
     	"Dtransposition L"
	},
     PARA,
     CAVEAT{"The standard transposition of a left ideal should be a right
	  ideal, however M2 currently doesn't support right modules.
	  Thus the output is left ideal generated by the transposition
	  of the previous generators."},
     SEEALSO {"WeylAlgebra"}
     },

document { (singLocus),
     Headline => "singular locus of a D-module",
     INSERTUSAGE {
     TT "singLocus M", " -- 
     computes the singular locus of a D-module M",
     BR, NOINDENT,
     TT "singLocus M", " -- 
     computes the singular locus of the quotient module D/I"
     },

     "The singular locus of the system of PDE's given by ", EM "I",
     " generalizes the notion of singular point of an ODE.
     Geometrically, the singular locus of a D-module ", EM "M", 
     " equals the projection
     of the characteristic variety of ", EM "M", " minus the zero section
     of the cotangent bundle to the base affine space ", BOLD "C", SUP EM "n", ".",
     PARA,
     "For details of the algorithm for computing singular locus 
     see the book 'Groebner deformations
     of hypergeometric differential equations' by 
     Saito-Sturmfels-Takayama (1999).",
     PARA,
     "A simple example:",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"W = QQ[x,y,Dx,Dy, WeylAlgebra => {x=>Dx,y=>Dy}]",
     	"I = ideal (x*Dx+2*y*Dy-3, Dx^2-Dy)", 
     	"singLocus I"
	},
     PARA,
     SEEALSO {"charIdeal", "Drank", "Ddim"}
     },

document { (charIdeal),
     Headline => "characteristic ideal of a D-module",
     INSERTUSAGE {
     TT "charIdeal M", " -- 
     computes the characteristic ideal of a D-module M",
     BR, NOINDENT,
     TT "charIdeal I", " -- 
     computes the characteristic ideal of the quotiet module D/I"
     },

     "The characteristic ideal of ", EM "M", " is the annihilator of ",
     EM "gr(M)", " under a good filtration with respect to the order
     filtration. If ", EM "D", " is the Weyl
     algebra ", BOLD "C", TT "<", EM "x_1,....,x_n,d_1,...,d_n", TT ">", 
     ", then the order filtration
     corresponds to the weight vector (0,...,0,1...,1).
     The characteristic ideal
     lives in the associated graded ring of ", EM "D", " with respect to
     the order filtration, and this is a commutative polynomial ring ",
     BOLD "C", TT "[", EM "x_1,....,x_n,xi_1,...,xi_n", TT "]", 
     " -- here the ", EM "xi", "'s are the symbols of the ", EM "d", "'s. 
     The zero locus of the characteristic
     ideal is equal to the characteristic variety of ", EM "D/I", ", which
     is an invariant of a D-module.",
     PARA,
     "The algorithm to compute the characteristic ideal consists of computing
     the initial ideal of I with respect to the weight vector
     (0,...,0,1...,1).  See the book 'Groebner deformations
     of hypergeometric differential equations' by 
     Saito-Sturmfels-Takayama (1999) for more details.",
     PARA,
     "A simple example:",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"W = QQ[x,y,Dx,Dy, WeylAlgebra => {x=>Dx,y=>Dy}]",
     	"I = ideal (x*Dx+2*y*Dy-3, Dx^2-Dy)", 
     	"charIdeal I"
	},

     SEEALSO {"Ddim", "singLocus", "Drank"}
     },

document { (Drank),
     Headline => "rank of a D-module",
     INSERTUSAGE {
     TT "Drank M", "-- calculates the rank of a D-module M",
     BR, NOINDENT,
     TT "Drank I", "-- calculates the rank of the quotient module D/I"
     },

     "The rank of a D-module ", EM "M = D^r/N", " provides analytic information
     about the system of PDE's given by ", EM "N", ". In particular, a theorem of 
     Cauchy states that the dimension of holomorphic solutions to ", EM "N", " in a
     neighborhood of a nonsinugular point is equal to the rank.",
     PARA,
     "The rank of a D-module is defined algebraically as follows. 
     Let ", EM "D", " denote the Weyl algebra ", 
     BOLD "C", TT "<", EM "x_1,....,x_n,d_1,...,d_n", TT ">",
     " and let ", EM "R", " denote the ring of differential operators ",
     BOLD "C", TT "(", EM "x_1,...,x_n", TT ")",TT "<", EM "d_1,...,d_n", TT ">",
     " with rational function coefficients.
     Then the rank of ", EM "M = D^r/N", " is equal to the dimension of ", 
     EM "R^r/RN"," as a vector space over ", BOLD "C", "(", EM "x_1,...,x_n", ").",
     PARA,
     "See the book 'Groebner deformations of hypergeometric differential equations' by 
     Saito-Sturmfels-Takayama (1999) for more details of the algorithm.",
     PARA,
     "A simple example:",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"W = QQ[x,y,Dx,Dy, WeylAlgebra => {x=>Dx,y=>Dy}]",
     	"I = ideal (x*Dx+2*y*Dy-3, Dx^2-Dy)", 
     	"Drank I"
	},
     PARA,
     SEEALSO {"charIdeal", "singLocus", "Ddim"}
     },

document { (Ddim),
     Headline => "dimension of a D-module", 
     INSERTUSAGE {
     TT "Ddim M", " -- calculate the dimension of a D-module M ",
     BR, NOINDENT, 
     TT "Ddim I", " -- calculate the dimension of the quotient D/I"
     },
     PARA,
     "The dimension of ", EM "M", " is equal to the dimension of
     the associated graded module with respect to the Bernstein 
     filtration. A module is holonomic if it has dimension n
     where ", EM "D = ", 
     BOLD "C", "<", EM {"x", SUB "1",",...,x", SUB "n",
	  ",d", SUB "1", ",...,d", SUB "n"}, ">",
     PARA,
     "A simple example:",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"W = QQ[x,y,Dx,Dy, WeylAlgebra => {x=>Dx,y=>Dy}]",
     	"I = ideal (x*Dx+2*y*Dy-3, Dx^2-Dy)", 
     	"Ddim I"
	},
     SEEALSO {"charIdeal", "Drank", "singLocus"}
     },

document { (makeWeylAlgebra),
     Headline => "Weyl algebra corresponding to a polynomial ring",
     INSERTUSAGE {
     TT "makeWeylAlgebra R", " -- 
     makes the Weyl algebra corresponding to a commutative polynomial
     ring R."
     },
     "Given a polynomial ring ", EM "R", " with variables ", EM "x_1,..,x_n", 
     ", this routine returns a Weyl algebra with variables ", EM "x_1,..,x_n",
     " and ", EM "dx_1,..,dx_n", ".", 
     PARA,
     "A simple example:",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"R = QQ[x,y,z]",
     	"W = makeWeylAlgebra R"
	},
     PARA,
     "Abbreviations :",
     UL{"makeWA"},
     CAVEAT{"The polynomial ring R must be commutative."},
     SEEALSO {"WeylAlgebra"}
     }

document { (Ddual),
     Headline => "holonomic dual of a D-module",
     INSERTUSAGE {
     TT "Ddual M", " -- 
     computes the holonomic dual of a D-module M",
     BR, NOINDENT,
     TT "Ddual I", " -- 
     computes the holonomic dual of the quotient module D/I"
     },

     "If M is a holonomic left D-module, then ", 
     BOLD "Ext", SUP "n", SUB "D", "(", EM "M,D", ")", 
     " is a holonomic right D-module.  The holonomic dual is defined to be the left
     module associated to ",
     BOLD "Ext", SUP "n", SUB "D", "(", EM "M,D", ")", 
     ".  The dual is obtained by
     computing a free resolution of ", EM "M", ", dualizing, and applying
     the standard transposition to the ", EM "n", "th homology.",
     PARA,
     "A simple example:",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"I = AppellF1({1,0,-3,2})",
     	"Ddual I"
	},
     PARA,
     CAVEAT{"The input module ", EM "M", " should be holonomic.  The user should
	  check this manually with the script ", TT "Ddim", "."},
     SEEALSO {"Ddim", "Dtransposition"}
     }

document { (Dlocalize=>Strategy),
     Headline=>"strategy for computing a localization of a D-module",
     UL{
	  {BOLD "Oaku", " -- use the Oaku algorithm"},
	  {BOLD "OTW", " -- use the Oaku-Takayama-Walther algorithm"}
	  }
     }
document { (Oaku),
     Headline => "an option for Dlocalize=>Strategy",
     "see ", TO "Dlocalize"
     } 
document { (OTW),
     Headline => "an option for Dlocalize=>Strategy",
     "see ", TO "Dlocalize"
     } 

document { (Dlocalize),
     Headline => "localization of a D-module",
     INSERTUSAGE {
     TT "Dlocalize (M, f)", " -- 
     compute the localization of the D-module M with respect to the
     polynomial f",
     BR, NOINDENT,
     TT "Dlocalize (I, f)", " -- 
     compute the localization of the quotient module D/I with respect to the
     polynomial f",
     PARA,
     TT "DlocalizeMap (M, f)", " -- 
     compute the localization map M --> M[1/f]",
     BR, NOINDENT,
     TT "DlocalizeMap (M, f)", " -- 
     compute the localization map (D/I) --> (D/I)[1/f]",
     PARA,
     TT "DlocalizeAll (M, f)", " -- 
     compute the localization of M with respect to f and
     some auxilary information",
     BR, NOINDENT,
     TT "DlocalizeAll (M, f)", " -- 
     compute the localization of D/I with respect to f and some
     auxilary information"
     },

     "One of the nice things about D-modules is that if a finitely
     generated D-module is specializable along ", EM "f", ", then it's localization 
     with respect to ", EM "f", " is also finitely generated.  For instance,
     this is true for all holonomic D-modules.",
     
     PARA,
     "There are two different algorithms for localization implemented.  
     The first appears in the
     paper 'A localization algorithm for D-modules' by Oaku-Takayama-Walther
     (1999).  The second is due to Oaku and appears in the paper
     'Algorithmic computation of local cohomology modules and the
     cohomological dimension of algebraic varieties' by Walther(1999)",

     PARA,
     "A simple example:",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"W = QQ[x,y,Dx,Dy, WeylAlgebra => {x=>Dx,y=>Dy}]",
     	"M = W^1/(ideal(x*Dx+1, Dy))", 
     	"f = x^2-y^3",
     	"Mf = Dlocalize(M, f)"
	},
     PARA,
     "Other names :",
     UL{"Dlocalization"},
     
     SEEALSO {"AnnFs", "Dintegration"}
     }
document { (Dlocalization),
     "See ", TO "Dlocalize", "."
     }
document { (DlocalizationAll),
     "See ", TO "Dlocalize", "."
     }
document { (DlocalizeMap),
     "See ", TO "Dlocalize", "."
     }
document { (LocModule),
     Headline => "a key created by Dlocalize",
     "See ", TO "Dlocalize", "."
     }
document { (GeneratorPower),
     Headline => "a key created by Dlocalize",
     "See ", TO "Dlocalize", "."
     }
document { (LocMap),
     Headline => "a key created by Dlocalize",
     "See ", TO "Dlocalize", "."
     }
document { (annFS),
     Headline => "a key created by Dlocalize",
     "See ", TO "Dlocalize", "."
     }
document { (DlocalizeAll),
     "See ", TO "Dlocalize", "."
     }
document { (IntegrateBfunction),
     Headline => "a key created by Dlocalize",
     "See ", TO "Dlocalize", "."
     }
document { (Bfunction),
     Headline => "a key created by Dlocalize",
     "See ", TO "Dlocalize", "."
     }
document { (DlocalizationMap),
     "See ", TO "Dlocalize", "."
     }


document { (Dresolution=>Strategy),
     Headline => "strategy for computing a resolution of a D-module",
     UL { 
	  {BOLD "Schreyer", 
	       " -- uses Schreyer method in homogeneous Weyl algebra"},
	  {BOLD "Vhomogenize", " -- uses V-homogenization method of Oaku"}
     }
}
document { (Schreyer),
     Headline => "strategy for computing a resolution of a D-module"
     }
document { (Vhomogenize),
     Headline => "strategy for computing a resolution of a D-module"
     }

document { (Dresolution),
     Headline => "resolution of a D-module",
     INSERTUSAGE {TT "Dresolution (M)", " -- 
     computes a Schreyer resolution of the D-module M",
     BR, NOINDENT, TT "Dresolution (I, w)", " -- 
     computes a Schreyer resolution of the quotient module D/I",

     PARA,
     TT "Dresolution (M, w)", "-- 
     computes a resolution of M adapted to a weight vector w
     of the form (-u,u)",
     BR, NOINDENT, TT "Dresolution (I, w)", "-- 
     computes a resolution of D/I adapted to a weight vector w
     of the form (-u,u)"
     },

     "This routine computes various resolutions of a D-module.
     If no weight vector is specified, then the command
     produces a resolution by using the Schreyer order implemented
     in the engine.  If a weight vector ", EM "w", " of the form ", EM "(-u,u)", 
     " is specified, then the command produces a resolution with shifts
     which is adapted to the weight vector ", EM "w", ".  
     These ", EM "w", "-adapted resolutions are compatible
     with b-functions and used in the restriction algorithm.
     For ordinary resolutions, the user may use the command ", TT "resolution", ".
     Note that the notion of a minimal resolution is well-defined only in case 
     of homogenized Weyl algebra.",

     PARA,
     "There are two strategies for constructing
     w-adapted resolutions.   The first strategy is to construct
     a Schreyer resolution in the homogenized Weyl algebra
     and then dehomogenize.  The second strategy is to homogenize
     with respect to the weight vector.
     These strategies are described in the paper
     'Algorithims for D-modules'
     by Oaku-Takayama(1999).",

     PARA,
     "A simple example:",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"R = QQ[x_1,x_2,D_1,D_2,WeylAlgebra=>{x_1=>D_1,x_2=>D_2}]",
     	"I = ideal(x_1*D_1+3*x_2*D_2-1, D_1^3-D_2)", 
     	"Dresolution(I,{-1,-1,1,1})"
	},
     PARA,
     "Abbreviations :",
     UL{"Dres"},

     SEEALSO {"gbw", "Drestriction"}
     }
document { (Dres),
     Headline => "abbreviation for Dresolution",
     SEEALSO{"Dresolution"}
     }	

document {(Drestriction=>Strategy),
	  "Option is passed to Dresolution. See ",
	  TO (Dresolution=>Strategy)
	  }
document { (Drestriction),
     Headline => "restriction modules of a D-module",
     INSERTUSAGE {TT "Drestriction (M, w)", " -- 
     computes derived restriction modules of M with respect
     to the weight vector w",
     BR, NOINDENT,
     TT "Drestriction (I, w)", " -- 
     computes derived restriction modules of D/I with respect
     to the weight vector w",
     BR, NOINDENT,
     TT "Drestriction (i, M, w)", " -- 
     computes i-th derived restriction module of M with respect
     to the weight vector w",
     BR, NOINDENT,
     TT "Drestriction (i, I, w)", " -- 
     computes i-th derived restriction module of D/I with respect
     to the weight vector w",
     PARA,
     TT "DrestrictionClasses (M, w)", " -- 
     computes explicit cohomology classes of a
     derived restriction complex of M",
     BR, NOINDENT,
     TT "DrestrictionClasses (I, w)", " -- 
     computes explicit cohomology classes of a
     derived restriction complex of D/I",
     BR, NOINDENT,
     TT "DrestrictionClasses (i, M, w)", " -- 
     computes i-th explicit cohomology classes of
     a derived restriction complex of M",
     BR, NOINDENT,
     TT "DrestrictionClasses (i, I, w)", " -- 
     computes i-th explicit cohomology classes of
     a derived restriction complex of D/I",
     PARA,
     TT "DrestrictionComplex (M, w)", " -- 
     computes derived restriction complex of M with respect
     to the weight vector w",
     BR, NOINDENT,
     TT "DrestrictionComplex (D/I, w)", " -- 
     computes derived restriction complex of D/I with respect
     to the weight vector w",
     PARA,
     TT "DrestrictionAll (M, w)", " -- 
     computes derived restriction of M and outputs various
     information",
     BR, NOINDENT,
     TT "DrestrictionAll (I, w)", " -- 
     computes derived restriction of D/I and outputs various
     information"
     },
     
     "The derived restriction modules of a D-module M are
     the derived inverse images in the sense of algebraic
     geometry but in the category of D-modules. 
     This routine computes restrictions to coordinate subspaces,
     where the subspace is determined
     by the strictly positive entries of the weight vector", EM "w", ",
     e.g. ", EM "{x_i = 0 : w_i > 0}", " if ", 
     EM "D = ", BOLD "C", EM "<x_1,...,x_n,d_1,...,d_n>", ".
     The input weight vector should be a list of ", EM "n", " numbers
     to induce the weight ", EM "(-w,w)", " on ", EM "D", ".",

     PARA,
     "The algorithm used appears in the paper 'Algorithims for D-modules'
     by Oaku-Takayama(1999).  The method is to compute an adapted resolution
     with respect to the weight vector w and use the b-function with respect
     to w to truncate the resolution.",

     PARA,
     "A simple example:",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"R = QQ[x_1,x_2,D_1,D_2,WeylAlgebra=>{x_1=>D_1,x_2=>D_2}]",
     	"I = ideal(x_1, D_2-1)", 
     	"Drestriction(I,{1,0})"
	},
     PARA,
     CAVEAT{"The module ", EM "M", " should be specializable to the subspace.
	  This is true for holonomic modules.",
	  "The weight vector ", EM "w", " should be a list of ", EM "n",
	  " numbers if ", EM "M", 
	  " is a module over the ", EM "n", "th Weyl algebra."},
     PARA,
     "Abbreviations :",
     UL{"Drestrict"},
     
     SEEALSO {"Dresolution", "Dintegration"}
     }
document { (Drestrict),
     Headline => "abbreviation for Drestrict",
     SEEALSO{"Drestriction"}
     }	
document { (DrestrictionClasses),
     SEEALSO{"Drestriction"}
     }
document { (DrestrictClasses),
     SEEALSO{"Drestriction"}
     }
document { (DrestrictIdeal),
     SEEALSO{"Drestriction"}
     }
document { (DrestrictAll),
     SEEALSO{"Drestriction"}
     }
document { (DrestrictionComplex),
     SEEALSO{"Drestriction"}
     }
document { (DrestrictionAll),
     SEEALSO{"Drestriction"}
     }
document { (DrestrictionIdeal),
     SEEALSO{"Drestriction"}
     }
document { (DrestrictComplex),
     SEEALSO{"Drestriction"}
     }

document { (HomologyModules),
     Headline => "a key in a hashtable; an option of DExt",
     SEEALSO {"Drestriction", "Dintegration", "DExt" }
     }
document { (GenCycles),
     Headline => "a key in the hashtable created by Drestriction/Dintegration",
     SEEALSO {"Drestriction", "Dintegration" }
     }
document { (Exponents),
     Headline => "a key in the hashtable created by Drestriction/Dintegration",
     SEEALSO {"Drestriction", "Dintegration" }
     }
document { (Cycles),
     Headline => "a key in the hashtable created by Drestriction/Dintegration",
     SEEALSO {"Drestriction", "Dintegration" }
     }
document { (Boundaries),
     Headline => "a key in the hashtable created by Drestriction/Dintegration",
     SEEALSO {"Drestriction", "Dintegration" }
     }
document { (VResolution),
     Headline => "a key in the hashtable created by Drestriction/Dintegration",
     SEEALSO {"Drestriction", "Dintegration" }
     }
document { (Explicit),
     Headline => "a key in the hashtable created by Drestriction/Dintegration",
     SEEALSO {"Drestriction", "Dintegration" }
     }

document { (IntegrateComplex),
     Headline => "a key in the hashtable created by Dintegration",
     SEEALSO {"Dintegration" }
     }

document {(Dintegration=>Strategy),
	  "Option is passed to Dresolution. See ",
	  TO (Dresolution=>Strategy)
}
document { (Dintegration),
     Headline => "integration modules of a D-module",
     INSERTUSAGE {
     TT "Dintegration (M, w)", " -- 
     computes derived integration modules of M with respect
     to the weight vector w",
     BR, NOINDENT,
     TT "Dintegration (I, w)", " -- 
     computes derived integration modules of D/I with respect
     to the weight vector w",
     BR, NOINDENT,
     TT "Dintegration (i, M, w)", " -- 
     computes i-th derived integration module of M with respect
     to the weight vector w",
     BR, NOINDENT,
     TT "Dintegration (i, I, w)", " -- 
     computes i-th derived integration module of D/I with respect
     to the weight vector w",
     PARA,
     TT "DintegrationClasses (M, w)", " -- 
     computes explicit cohomology classes of a
     derived integration complex of M",
     BR, NOINDENT,
     TT "DintegrationClasses (I, w)", " -- 
     computes explicit cohomology classes of a
     derived integration complex of D/I",
     BR, NOINDENT,
     TT "DintegrationClasses (i, M, w)", " -- 
     computes i-th explicit cohomology classes of
     a derived integration complex of M",
     BR, NOINDENT,
     TT "DintegrationClasses (i, I, w)", " -- 
     computes i-th explicit cohomology classes of
     a derived integration complex of D/I",
     PARA,
     TT "DintegrationComplex (M, w)", " -- 
     computes derived integration complex of M with respect
     to the weight vector w",
     BR, NOINDENT,
     TT "DintegrationComplex (D/I, w)", " -- 
     computes derived integration complex of D/I with respect
     to the weight vector w",
     PARA,
     TT "DintegrationAll (M, w)", " -- 
     computes derived integration of M and outputs various
     information",
     BR, NOINDENT,
     TT "DintegrationAll (I, w)", " -- 
     computes derived integration of D/I and outputs various
     information"
     },

     "The derived integration modules of a D-module ", EM "M", " are
     the derived direct images in the category of D-modules. 
     This routine computes integration for projection to 
     coordinate subspaces, where the subspace is determined
     by the strictly positive entries of the weight vector ", EM "w", ",
     e.g. ", EM "{x_i = 0 : w_i > 0}", " if ", 
     EM "D = ", BOLD "C", EM "<x_1,...,x_n,d_1,...,d_n>", ".
     The input weight vector should be a list of ", EM "n", " numbers	    
     to induce the weight ", EM "(-w,w)", " on ", EM "D", ".",

     PARA,
     "The algorithm used appears in the paper 'Algorithims for D-modules'
     by Oaku-Takayama(1999).  The method is to take the Fourier transform
     of M, then compute the derived restriction, then inverse
     Fourier transform back.",

     PARA,
     "A simple example:",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"R = QQ[x_1,x_2,D_1,D_2,WeylAlgebra=>{x_1=>D_1,x_2=>D_2}]",
    	"I = ideal(x_1, D_2-1)", 
     	"Dintegration(I,{1,0})"
	},
     PARA,
     CAVEAT{"The module M should be specializable to the subspace.
	  This is true for holonomic modules.",
	  "The weight vector w should be a list of n numbers if M
	  is a module over the nth Weyl algebra."},
     PARA,
     "Abbreviations :",
     UL{"Dintegrate"},
     
     SEEALSO{"Drestriction"}
     }
document { (Dintegrate),
     Headline => "abbreviation for Dintegration",
     SEEALSO{"Dintegration"}
     }	
document { (DintegrateIdeal),
     SEEALSO{"Dintegration"}
     }	
document { (DintegrationIdeal),
     SEEALSO{"Dintegration"}
     }	
document { (DintegrationComplex),
     SEEALSO{"Dintegration"}
     }	
document { (DintegrateClasses),
     SEEALSO{"Dintegration"}
     }
document { (DintegrateComplex),
     SEEALSO{"Dintegration"}
     }
document { (DintegrationClasses),
     SEEALSO{"Dintegration"}
     }
document { (DintegrateAll),
     SEEALSO{"Dintegration"}
     }
document { (DintegrationAll),
     SEEALSO{"Dintegration"}
     }

document { (gkz=>Vars) }
document { (Vars) }
document { (Local),
     Headline => "a choice for option Vars" 
     }
document { (Global),
     Headline => "a choice for option Vars" 
     }
document { (gkz),
     Headline => "GKZ A-hypergeometric ideal",
     INSERTUSAGE {
     TT "gkz (A,b)", " -- 
     computes the Gel'fand-Kapranov-Zelevinsky hypergeometric ideal
     associated to the matrix A and parameter b",
     BR, NOINDENT,
     TT "gkz (A)", " -- 
     computes parametric Gel'fand-Kapranov-Zelevinsky hypergeometric ideal
     associated to the matrix A"
     },

     "The GKZ hypergeometric system of PDE's associated to a (d x n)
     integer matrix A consists of the toric ideal I_A in the polynomial
     subring C[d_1,...,d_n] and Euler relations given by the entries
     of the vector (A theta - b), where theta is the vector
     (theta_1,...,theta_n)^t, and theta_i = x_i d_i.
     See the book 'Groebner deformations of hypergeometric differential 
     equations' by Saito-Sturmfels-Takayama (1999) for more details.",

     PARA,
     "A simple example:",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"A = matrix{{1,1,1},{0,1,2}}",
     	"b = {3,4}", 
     	"I = gkz (A,b)"
	},

     CAVEAT{"gkz always returns a different ring and will use variables
	  x_1,...,x_n, D_1,...D_n."},

     SEEALSO {"AppellF1"}
     },

document { (AppellF1),
     Headline => "Appell F1 system of PDE's",
     INSERTUSAGE {
     TT "AppellF1 {a0,a1,a2,a3}", " -- 
     compute the Appell F1 system of PDE's associated to the
     parameters a0, a1, a2, and a3."
     },

     "A simple example:",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"w = {1,4/5,-2,3/2}",
     	"I = AppellF1(w)"
	},
     PARA,
     CAVEAT{"AppellF1 always returns a different ring and will
	  use variables x and y. Input should be a List of 4
	  numbers."},

     SEEALSO {"gkz"}
     }

document { (PolyAnn),
     Headline => "annihilator of a polynomial in Weyl algebra",
     INSERTUSAGE {
     TT "PolyAnn f", " -- 
     compute the annihilator ideal in the Weyl algebra of the polynomial f"
     },

     "A simple example:",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"W = QQ[x,y,Dx,Dy, WeylAlgebra => {x=>Dx, y=>Dy}]",
     	"f = x^2-y^3",
     	"I = PolyAnn f"
	},
     PARA,
     CAVEAT{"The input f should be an element of a Weyl algebra,
	  and not an element of a commutative polynomial ring.
	  However, f should only involve commutative variables."},

     SEEALSO {"RatAnn"}
     }

document { (RatAnn),
     Headline => "annihilator of a rational function in Weyl algebra",
     INSERTUSAGE {
     TT "RatAnn f", " -- 
     compute the annihilator ideal in the Weyl algebra of the rational
     function 1/f",
     BR, NOINDENT,
     TT "RatAnn (g,f)", " -- 
     compute the annihilator ideal in the Weyl algebra of the rational
     function g/f"
     },

     "A simple example:",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"W = QQ[x,y,Dx,Dy, WeylAlgebra => {x=>Dx, y=>Dy}]",
     	"f = x^2-y^3",
     	"g = 2*x*y",
     	"I = RatAnn (g,f)"
	},
     PARA,
     CAVEAT{"The inputs f and g should be elements of a Weyl algebra,
	  and not elements of a commutative polynomial ring.
	  However, f and g should only use the commutative variables."},

     SEEALSO {"PolyAnn"}
     }
document { (WeylClosure),
     Headline => "Weyl closure of an ideal",
     INSERTUSAGE {
     TT "WeylClosure I", " -- computes the Weyl closure of a finite rank
     ideal I",
     BR, NOINDENT,
     TT "WeylClosure (I, f)", " -- 
     compute the partial Weyl closure of a finite rank ideal I with
     respect to f"
     },

     "Let R = K(x_1..x_n)<d_1..d_n> denote the ring of differential
     operators with rational function coefficients. The Weyl closure
     of an ideal I in D, is the intersection of the extended ideal RI
     with D.  It consists of all operators which vanish on the common
     holomorphic solutions of I, and is thus analogous to the radical
     operation on a commutative ideal.",
     
     PARA,
     "The partial Weyl closure of I with respect to a polynomial f
     is the intersection of the extended ideal D[f^{-1}]I with D.",

     PARA,
     "The Weyl closure is computed by localizing D/I with respect to
     a polynomial f vanishing on the singular locus, and computing
     the kernel of the map D --> D/I --> (D/I)[f^{-1}].",
     
     PARA,
     "A simple example:",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"W = QQ[x,Dx, WeylAlgebra => {x=>Dx}]",
     	"I = ideal(x*Dx-2)",
     	"WeylClosure I"
	},
     PARA,
     CAVEAT{"The ideal I should be finite rank, which can be tested
	  manually by Drank.", "The Weyl closure of non-finite rank
	  ideals or arbitrary submodules has not been implemented."},
	  
     SEEALSO {"Dlocalize", "singLocus", "Drank"}
     }
document {(deRham=>Strategy),
	  "Option is passed to Dresolution. See ",
	  TO (Dresolution=>Strategy)
}
document { (deRham),
     Headline => "deRham cohomology groups",
     INSERTUSAGE {
     TT "deRham f", "-- 
     computes the deRham cohomology groups of the complement of the
     hypersurface {f = 0} ",
     BR, NOINDENT,
     TT "deRham (i, f)", "-- 
     computes i-th deRham cohomology group of the complement of the
     hypersurface {f = 0} ",
     BR, NOINDENT,
     TT "deRhamAll f", "-- 
     returns explicit cohomology classes in the deRham complex and
     supplementary information"
     },
	  
     PARA,
     "The algorithm used appears in the paper 'An algorithm for deRham 
     cohomology groups of the complement of an affine variety via D-module
     computation' by Oaku-Takayama(1999).  
     The method is to compute the localization of the polynomial ring 
     by f, then compute the derived integration of the localization.
     The routine deRhamAll can be used to compute cup product structures
     as in the paper 'The cup product structure for complements
     of affine varities' by Walther(2000).",

     PARA,
     "A simple example:",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"R = QQ[x,y]",
     	"f = x^2-y^3", 
     	"deRham(f)"
	},
     SEEALSO {"Dlocalization", "Dintegration"}
     }
document { (deRhamAll),
     "see ", TO "deRham"
     }
document { (TransferCycles),
     Headline => "a key in the hashtable created by deRham",
     SEEALSO "deRham"
     }
document { (CohomologyGroups),
     Headline => "a key in the hashtable created by deRham",
     SEEALSO "deRham"
     }
document { (PreCycles),
     Headline => "a key in the hashtable created by deRham",
     SEEALSO "deRham"
     }
document { (OmegaRes),
     Headline => "a key in the hashtable created by deRham",
     SEEALSO "deRham"
     }

document { (diffOps),
     Headline => "differential operators of specified order 
     for a quotient polynomial ring",
     INSERTUSAGE {
     TT "diffOps (I, k)", " -- 
     compute differential operators of order less than or equal to k 
     of the quotient ring R/I",
     BR, NOINDENT,
     TT "diffOps (f, k)", " -- 
     compute differential operators of order less than or equal to k 
     of the quotient ring R/(f)"
     },

     "Given an ideal I of a polynomial ring R, the set of
     differential operators of the quotient ring R/I having order 
     less than or equal to k forms a finitely generated module over R/I.  
     This routine returns a generating set.",
     
     PARA,
     "The output is in the form of a hash table.
     The key 'BasisElts' is a row vector of basic differential operators.
     The key 'PolyGens' is a matrix over R whose column vectors represent 
     differential operators of R/I in the following way.  For each column
     vector, consider its image in R/I, then take its dot product with
     the 'BasisElts' row vector.  This gives a differential operator, and
     the set of these operators generates the differential operators of
     R/I of order k or less as an (R/I)-module.",

     PARA,
     "A simple example:",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"R = QQ[x,y,z]",
     	"I = ideal(x^2-y*z)", 
     	"diffOps(I, 3)"
	},
     PARA,
     SEEALSO {"putWeylAlgebra"}

     },

document { (PolyGens),
     Headline => "a key of the hashtable generated by diffOps",
     SEEALSO "diffOps"
     }
document { (BasisElts),
     Headline => "a key of the hashtable generated by diffOps",
     SEEALSO "diffOps"
     }

document { (putWeylAlgebra),
     Headline => "the output of diffOps => elements of Weyl algebra",
     INSERTUSAGE {
     TT "putWeylAlgebra m", " -- 
     given the output m of diffOps, represents
     the differential operators as elements of a Weyl algebra."
     },

     PARA,
     "If I is an ideal of the polynomial ring R and m is the output of 
     diffOps(I, k), then this routine returns elements of the Weyl
     algebra W corresponding to R whose images in W/IW are an
     R/I-generating set for the order k or less differential operators.",

     PARA,
     "A simple example:",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"R = QQ[x,y,z]",
     	"I = ideal(x^2-y*z)", 
     	"m = diffOps(I, 3)",
     	"putWeylAlgebra m"
	},
     PARA,
     SEEALSO {"diffOps"}

     }

document { (inw),
     Headline => "initial form/ideal w.r.t. a weight",
     INSERTUSAGE {
     TT "inw (L, w)", " -- 
     computes the initial form of an element L
     with respect to a weight vector w.",
     BR, NOINDENT,
     TT "inw (I, w)", " -- 
     computes the initial ideal of an ideal I
     with respect to a weight vector w.",
     BR, NOINDENT,
     TT "inw (m, w)", " -- 
     computes the initial matrix of a matrix m
     with respect to a weight vector w."
     },

     "This routine computes the initial ideal of a left ideal ", EM "I",  
     " of the Weyl algebra with respect to a weight vector ", EM "w = (u,v)",
     " where ", EM "u+v >= 0", ".
     In the case where u+v > 0, then the ideal lives in the 
     associated graded ring which is a commutative ring.  In the case
     where u+v = 0, then the ideal lives in the associated graded
     ring which is again the Weyl algebra.  In the general case ", 
     EM "u+v >= 0",
     " the associated graded ring is somewhere between.  There are
     two strategies to compute the initial ideal.  One is to homogenize
     to an ideal of the homogeneous Weyl algebra.  The other is
     to homogenize with respect to the weight vector ", EM "w", 
     ".",

     PARA,
     "A simple example:",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"W = QQ[x,y,Dx,Dy, WeylAlgebra => {x=>Dx,y=>Dy}]",
     	"I = ideal (x*Dx+2*y*Dy-3, Dx^2-Dy)", 
     	"inw(I, {1,3,3,-1})",
     	"inw(I, {-1,-3,1,3})"
	},
     PARA,
     CAVEAT{"The weight vector ", EM "w = (u,v)", " must have ", 
	  EM "u+v>=0", "."},
     SEEALSO {"gbw", "setHomSwitch"}
     },

document { (gbw),
     Headline => "Groebner basis w.r.t. a weight",
     INSERTUSAGE {
     TT "gbw (I, w)", " -- 
     computes a Groebner basis of an ideal with respect
     to a weight vector w.",
     BR, NOINDENT, 
     TT "gbw (m, w)", " -- 
     computes a Groebner basis of a matrix with respect
     to a weight vector w."
     },

     "This routine computes a Groebner basis of a left ideal ", EM "I",  
     " of the Weyl algebra with respect to a weight vector ", EM "w = (u,v)",
     " where either ", EM "u+v > 0", " or ", EM "u+v = 0", 
     ".  In the case where ", EM "u+v > 0",
     " the ordinary Buchberger algorithm works for any term order
     refining the weight order. In the case
     where ", EM "u+v = 0", " the Buchberger algorithm needs to be adapted to
     guarantee termination.  There are two strategies to do this.  
     One is to homogenize
     to an ideal of the homogeneous Weyl algebra.  The other is
     to homogenize with respect to the weight vector ", EM "w", ".",
     PARA,
     "A simple example:",
     EXAMPLE {
	"needs \"D-modules.m2\"",
	"W = QQ[x,y,Dx,Dy, WeylAlgebra => {x=>Dx,y=>Dy}]",
     	"I = ideal (x*Dx+2*y*Dy-3, Dx^2-Dy)", 
     	"gbw(I, {1,3,3,-1})",
     	"gbw(I, {-1,-3,1,3})"
	},
     PARA,
     CAVEAT{"The weight vector ", EM "w = (u,v)", " must have ", 
	  EM "u+v>=0", "."},
     SEEALSO {"inw", "setHomSwitch"}
     }

document { (pInfo),
     Headline => "prints tracing info",
     "Prints tracing information according to the level set by ", 
	TT "Dtrace", ".",
     SEEALSO { "Dtrace" }
     }
----------------------------------------------------------------------------
-- (better docs needed)
----------------------------------------------------------------------------
document { (SparseMutableMatrix),
     Headline => "sparse matrix"
     }
document { (sparseMutableMatrix),
     Headline => "make sparse matrix"
     }
document { (newSparseMatrix),
     Headline => "a way to grab sparse matrix from engine"
     }
document { (reduceCompress),
     Headline => "simplify sparse matrix"
     }
document { (getEntry),
     Headline => "get a sparse matrix entry"
     }
document { (iden),
     Headline => "identity sparse matrix"
     }
document { (sparsemat),
     Headline => "create a sparse matrix"
     }
document { (numcols),
     Headline => "number of columns of a sparse matrix"
     }
document { (numrows),
     Headline => "number of rows of a sparse matrix"
     }
document { (setEntry),
     Headline => "set a sparse matrix entry"
     }
document { (reducePivots),
     Headline => "reduce pivots in a sparse matrix"
     }
document { (Dprune),
     Headline => "prunes a matrix over a Weyl algebra"
     }
document { (Dprune2),
     Headline => "prunes a matrix over a Weyl algebra (phased out)"
     }
document { (Dprune=>optGB),
     Headline => "indicates whether Grobner basis should be computed"
     }
document { (optGB),
     Headline => "indicates whether Grobner basis should be computed"
     }
document { (FourierInverse),
     Headline => "Inverse Fourier map (D-modules)",
     " see ", TO "Fourier" 
     }
