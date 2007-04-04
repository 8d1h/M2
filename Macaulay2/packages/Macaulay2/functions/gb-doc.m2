--- status: TODO
--- author(s): 
--- notes: 

document { 
     Key => {gb,
	  (gb,Ideal),
	  (gb,Matrix),
	  (gb,Module),
	  [gb,Algorithm],
	  [gb, BasisElementLimit],
	  [gb,ChangeMatrix],
	  [gb,CodimensionLimit],
	  [gb,DegreeLimit],
     	  [gb,GBDegrees],
	  [gb,HardDegreeLimit],
	  [gb,Hilbert],
	  [gb,PairLimit],
	  [gb,StopBeforeComputation],
	  [gb,StopWithMinimalGenerators],
     	  [gb,Strategy],
	  [gb,SubringLimit],
	  [gb,Syzygies],
	  [gb,SyzygyLimit],
	  [gb,SyzygyRows],
	  F4,
	  Faugere,
	  Homogeneous2,
	  Sugarless,
	  LinearAlgebra
	  },
     Headline => "compute a Groebner basis",
     Usage => "gb I",
     Inputs => {
	  "I" => "an ideal, module, or matrix",
	  Algorithm => Symbol => {"possible values: ", TT "Homogeneous", ", ", TT "Inhomogeneous", ", ", TT "Sugarless", ".  Experimental options
	   include ", TT "Homogeneous2", ", ", TT "F4", ", ", TT "Faugere", " and ", TT "LinearAlgebra"},
     	  BasisElementLimit => ZZ => "stop when this number of (nonminimal) Groebner basis elements has been found",
	  ChangeMatrix => Boolean => { 
	       "whether to compute the change of basis matrix from Groebner basis elements to original generators.  Use ", TO "getChangeMatrix", " to recover it."},
	  CodimensionLimit => ZZ => "stop computation once codimension of submodule of lead terms reaches this value (not functional yet)",
	  DegreeLimit => List => "stop after the Groebner basis in this degree has been computed",
	  GBDegrees => List => "a list of positive integer weights, one for each variable in the ring, to be used for
	   organizing the computation by degrees (the 'sugar' ecart vector)",
	  HardDegreeLimit => "throws away all S-pairs of degrees beyond the limit. The computation
	    will be re-initialized if higher degrees are required.",
     	  Hilbert => {"informs Macaulay2 that this is the ", TO poincare, 
	   " polynomial, and can be used to aid in the computation of the Groebner basis (Hilbert driven)"},
	  PairLimit => ZZ => "stop after this number of spairs has been considered",
	  StopBeforeComputation => Boolean => "initializes the Groebner basis engine but return before doing any computation (useful for 
	    using or viewing partially computed Groebner bases)",
	  StopWithMinimalGenerators => Boolean => "stop as soon as the minimal set (or a trimmed set, if not homogeneous or local) of generators is known.  Intended for internal use only",
	  Strategy => {"either ", TT "LongPolynomial", ", ", TT "Sort", ", or a list of these.  ", TT "LongPolynomial", ": use a geobucket data structure while reducing polynomials;
	   ", TT "Sort", ": sort the S-pairs.  Usually S-pairs are processed degree by degree in the order that they were constructed."},
	  SubringLimit => ZZ => "stop after this number of elements of the Groebner basis lie in the first subring",
	  Syzygies => Boolean => "whether to collect syzygies on the original generators during the computation.  Intended for internal use only",
	  SyzygyLimit => ZZ => "stop when this number of non-zero syzygies has been found",
	  SyzygyRows => ZZ => "for each syzygy and change of basis element, keep only this many rows of each syzygy"
	  },
     Outputs => {
	  GroebnerBasis => "a Groebner basis computation object"
	  },
     Consequences => {
	  },
     "See ", TO "Groebner bases", " for more 
     information and examples.",
     PARA{},
     "The returned value is not the Groebner basis itself.  The
     matrix whose columns form a sorted, auto-reduced Groebner
     basis are obtained by applying ", TO generators, " (synonym: ", TT "gens", ")
     to the result of ", TT "gb", ".",
     EXAMPLE {
	  "R = QQ[a..d]",
	  "I = ideal(a^3-b^2*c, b*c^2-c*d^2, c^3)",
	  "G = gens gb I"
	  },
     SeeAlso => {
	  "Groebner bases",
	  (generators,GroebnerBasis),
	  "gbTrace",
	  installHilbertFunction,
	  installGroebner,
	  gbSnapshot,
	  gbRemove
	  }
     }

-- document {
--      Key => [gb,PairLimit], 
--      Headline => "stop when this number of pairs is handled",
--      TT "PairLimit", " -- keyword for an optional argument used with
--      ", TO "gb", " which specifies that the
--      computation should be stopped after a certain number of S-pairs
--      have been reduced.",
--      EXAMPLE {
-- 	  "R = QQ[x,y,z,w]",
--       	  "I = ideal(x*y-z,y^2-w-1,w^4-3)",
--       	  "gb(I, PairLimit => 1)",
--       	  "gb(I, PairLimit => 2)",
--       	  "gb(I, PairLimit => 3)"
-- 	  }
--      }

TEST ///
-- Test of various stopping conditions for GB's
R = ZZ/32003[a..j]
I = ideal random(R^1, R^{-2,-2,-2,-2,-2,-2,-2});
gbTrace=3
--time gens gb I;
I = ideal flatten entries gens I;
G = gb(I, StopBeforeComputation=>true); -- now works
m = gbSnapshot I
assert(m == 0)

I = ideal flatten entries gens I;
mI = mingens I; -- works now
assert(numgens source mI == 7)

I = ideal flatten entries gens I;
mI = trim I; -- It should stop after mingens are known to be computed.
assert(numgens source mI == 7)

I = ideal flatten entries gens I;
G = gb(I, DegreeLimit=>3); -- this one works
assert(numgens source gbSnapshot I == 18)
G = gb(I, DegreeLimit=>4); -- this one works
assert(numgens source gbSnapshot I == 32)
G = gb(I, DegreeLimit=>3); -- this one stops right away, as it should
assert(numgens source gbSnapshot I == 32)
G = gb(I, DegreeLimit=>5);
assert(numgens source gbSnapshot I == 46)

I = ideal flatten entries gens I;
G = gb(I, BasisElementLimit=>3); -- does the first 3, as it should
assert(numgens source gbSnapshot I == 3)
G = gb(I, BasisElementLimit=>7); -- does 4 more.
assert(numgens source gbSnapshot I == 7)

I = ideal flatten entries gens I;
G = gb(I, PairLimit=>23); -- 
assert(numgens source gbSnapshot I == 16) -- ?? is this right??

I = ideal flatten entries gens I;
hf = poincare ideal apply(7, i -> R_i^2)
G = gb(I, Hilbert=>hf); -- this works, it seems
assert(numgens source G == 67)

Rlex = ZZ/32003[a..j,MonomialOrder=>Eliminate 1]
IL = substitute(I,Rlex);
G = gb(IL, SubringLimit=>1, Hilbert=>hf, DegreeLimit=>2); -- SubringLimit now seems OK
G = gb(IL, SubringLimit=>1, Hilbert=>hf, DegreeLimit=>4); 
assert(numgens source selectInSubring(1,gens G) == 1)

///
