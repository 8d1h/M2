--- status: DRAFT
--- author(s): L. Gold
--- notes: 

document { 
     Key => {cos, (cos,ZZ), (cos,RR)},
     Headline => "compute the cosine",
     Usage => "cos x",
     Inputs => { 
	  "x" => RR => null 
	  },
     Outputs => { 
	  RR => { "the cosine of ", TT "x", "" } 
	  },
     EXAMPLE {
	  "cos 2"
	  }
     }
