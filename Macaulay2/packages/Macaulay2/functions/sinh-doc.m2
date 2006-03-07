--- status: DRAFT
--- author(s): L. Gold
--- notes: include example?

document { 
     Key => {sinh,(sinh,ZZ),(sinh,RR)},
     Headline => "compute the hyperbolic sine",
     Usage => "sinh x",
     Inputs => {
	  "x" => RR => null 
	  },
     Outputs => {
	  RR => { "the hyperbolic sine of ", TT "x" } 
     }
--     EXAMPLE {
--	  }
} 
