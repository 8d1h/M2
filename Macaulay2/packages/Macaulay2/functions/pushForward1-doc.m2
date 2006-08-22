--- status: Draft
--- author(s): MES, taken from stuff before
--- notes: 

document { 
     Key => {(pushForward1,RingMap,Module), pushForward1},
     Headline => "the main computational component of pushForward",
     Usage => "pushForward1(F,M)",
     Inputs => {
	  "F" => "a ring map F : R --> S",
	  "M" => "an S-module"
	  },
     Outputs => {
	  {"the presentation matrix of the R-submodule of M generated
	  by the given (S-module) generators of M."}
	  },
     PARA{},
     "Warning: this function may be removed, and its function incorporated into
     that of ", TO "image", " and ", TO "prune", ".",
     PARA{},
     "This is a very basic operation, and is used by several other functions.  See,
     for example, ", TO "pushForward", ".  Therefore we intend to eliminate it,
     and merge its function into ", TO "image", " after introducing
     generalized module homomorphisms which map an R-module to an S-module.",
     PARA{},
     "As an example, the following fragment computes the ideal of the
     rational normal curve. This could also be done using ", TO "monomialCurveIdeal", ".",
     EXAMPLE lines ///
	  R = ZZ/101[a..d];
      	  S = ZZ/101[s,t];
      	  F = map(S,R,matrix{{s^4, s^3*t, s*t^3, t^4}})
      	  pushForward1(F,S^1)
	  ///,
     PARA{},
     "The following code performs the Groebner computation using a product order 
     rather than the default elimination order.",
     EXAMPLE lines ///
      	  F = map(S,R,matrix{{s^4, s^3*t, s*t^3, t^4}})     
          time pushForward1(F,S^1,MonomialOrder=>ProductOrder)
	  ///,
     PARA{},
     "The computation is stashed inside the ring map, until the computation has
     finished completely.  This means that you may interrupt this command, and 
     later restart it. You may alo obtain partial results, as follows.",
     EXAMPLE lines ///
	  F = map(S,R,matrix{{s^4, s^3*t, s*t^3, t^4}})
      	  pushForward1(F,S^1,DegreeLimit=>8)
	  ///,
     "After interrupting a computation (using control-C), you may view the
     equations so far obtained by using the ", TT "StopBeforeComputation", " option to prevent any
     further work from being done.",
     EXAMPLE "pushForward1(F,S^1,StopBeforeComputation => true)",
     "The type ", TO "PushforwardComputation", " is used internally by our current implementation.",
     SUBSECTION "Further examples",
     Caveat => {},
     SeeAlso => {pushForward, Elimination}
     }

TEST ///
-- Sheaves on P1 x P1
R = ZZ/32003[a..d];
S = ZZ/32003[z_(1,1)..z_(2,2)]
F = map(R,S,matrix"a,b" ** matrix"c,d")
I = ideal(a,c)
J = ideal(a,b)
K = ideal"ac2+bd2"
-- the ideal of a point:
pushForward1(F,comodule I)
-- the ideal of the empty set:
pushForward1(F,comodule J)
-- the ideal of the twisted cubic:
pushForward1(F,comodule K)
res coker oo

-- Yau's example projected to P2xP3
a = symbol a
b = symbol b
R = ZZ/32003[a_0..a_3,b_0..b_3]
-- The ideal of the product of two cubic surfaces, cut by a hyperplane
I = ideal"a[0]3+a[1]3+a[2]3+a[3]3,
          b[0]3+b[1]3+b[2]3+b[3]3,
	  a[0]b[0]+a[1]b[1]+a[2]b[2]+a[3]b[3]"
codim I
degree I

S = ZZ/32003[a_0..a_2,b_0..b_3]
f = map(R,S)
N = ideal pushForward1(f,comodule I)
codim N
degree N
betti N

-- A hard example
R = ZZ/32003[a..e];
I = ideal"a5+b5+c5+d5+e5-5abcde,
         ea3b+ab3c+bc3d+cd3e+de3a,
	 e2ab2+a2bc2+b2cd2+c2de2+d2ea2"
codim I
degree I
S = ZZ/32003[a..d];
use R
F = map(R,S,{a+b,2*a+c,3*a+d,4*a+e})
time pushForward1(F,comodule I)
///
end
document { 
     Key => [pushForward1, DegreeLimit],
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
document { 
     Key => [pushForward1, PairLimit],
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
document { 
     Key => [pushForward1, BasisElementLimit],
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
document { 
     Key => [pushForward1, StopWithMinimalGenerators],
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
document { 
     Key => [pushForward1, UseHilbertFunction],
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
document { 
     Key => [pushForward1, MonomialOrder],
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
document { 
     Key => [pushForward1, Strategy],
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
document { 
     Key => [pushForward1, StopBeforeComputation],
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
 -- doc8.m2:1676:     Key => [pushForward1,StopBeforeComputation],
 -- doc8.m2:1686:     Key => [pushForward1,DegreeLimit],
 -- doc8.m2:1703:     Key => pushForward1,
 -- doc8.m2:1745:     Key => [pushForward1,StopWithMinimalGenerators],
 -- doc8.m2:1757:     Key => [pushForward1,PairLimit],
 -- doc8.m2:1765:     Key => [pushForward1,MonomialOrder],
 -- doc8.m2:1781:     Key => [pushForward1,UseHilbertFunction],
 -- doc8.m2:1791:     Key => [pushForward1,Strategy],
