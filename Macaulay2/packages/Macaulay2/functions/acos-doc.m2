--- status: DRAFT
--- author(s): L. Gold
--- notes: 

document { 
     Key => {acos,(acos,ZZ), (acos,RR)},
     Headline => "compute the arccosine", 
     Usage => "acos x",
     Inputs => { 
	  "x" => RR => ""
	  },
     Outputs => { 
	  RR => { "the arccosine of ", TT "x"} 
	  },
     EXAMPLE {
	  "acos .5"
	  }
     }     
