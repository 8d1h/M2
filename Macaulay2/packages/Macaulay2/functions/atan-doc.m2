--- status: DRAFT
--- author(s): L. Gold
--- notes: 

document { 
     Key => atan,
     Headline => "compute the arctangent",
     Usage => "atan x"
     }
document { 
     Key => (atan,RR,RR),
     Headline => "compute an angle of a certain triangle",
     Usage => "atan(x,y)",
     Inputs => { 
	  "x" => RR => null, 
	  "y" => RR => null
	  },
     Outputs => { 
	 RR => { "the angle (in radians) formed with the x-axis by the ray from the origin to the point ", TT "(x,y)" } 
	  },
     EXAMPLE {
	  "atan(sqrt(3.0)/2,1/2)",
	  "-- Notice this is not quite pi/6, but it is within a reasonable epsilon.",
	  "epsilon = 1.0*(10)^(-15);",	  
	  "abs(atan(sqrt(3.0)/2,1.0/2) - pi/6) < epsilon"
	  }
     }
document { 
     Key => {(atan,RR),(atan,ZZ)},
     Headline => "compute the arctangent of a number ",
     Usage => "atan x",
     Inputs => { 
	  "x" => RR => null 
	  },
     Outputs => {
	  RR => {"the arctangent (in radians) of ", TT "x"} 
	  },
     EXAMPLE {
     	  "atan(1)",
	  "abs(atan(1)) ==  pi/4"
	  }
     }
