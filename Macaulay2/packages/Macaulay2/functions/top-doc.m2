--- status: Draft
--- author(s): Giulio 
--- notes: 

document { 
     Key => {"top function"},
     Headline => "compute the top dimensional component of a module or of an ideal",
     Usage => "top M",
     Inputs => {
	  "M" => {"an ", TO Ideal, " or a ", TO Module}
	  },
     Outputs => {
	  },
     Consequences => {
	  },     
      
    "The method used is that of
    Eisenbud-Huneke-Vasconcelos, in their 1993 Inventiones Mathematicae
    paper.",PARA,
    "For a brief description see: ",TO "top-method",".",
    
    SeeAlso => {"top Ideal", "top Module","removeLowestDimension", "saturate", "quotient", "radical", "component example"
    },
    }
document { 
     Key => (top,Ideal),
     Headline => "compute the top dimensional component of an ideal",
     Usage => "top I",
     Inputs => {"I" => ""
	  },
     Outputs => {
	  "I" => Ideal => {"which is the intersection of the primary components of " 
	       ,TT "I", " having the greatest Krull dimension" }
	  },
    "The method used is that of Eisenbud-Huneke-Vasconcelos. ", 
    "For a brief description see: ",TO "top-method",".", 
    
     EXAMPLE {
	  "R=ZZ/32003[a..c];",
	  "I=intersect(ideal(a,b),ideal(b,c),ideal(c,a),ideal(a^2,b^3,c^4));",
	  "top I" 
	  },
     SeeAlso => {"top Module","removeLowestDimension", "saturate", "quotient", "radical", "component example"}
     },

document { 
     Key => (top,Module),
     Headline => "compute the top dimensional component of a module",
     Usage => "top M",
     Inputs => {
	  "M" => ""
	  },
     Outputs => {
	  "N" => Module => {" which is the intersection of the 
	       primary components of ", TT "M", 
	       " having gretest Krull dimension"} 
	  },
    "The method used is that of Eisenbud-Huneke-Vasconcelos. ", 
    "For a brief description see: ",TO "top-method",".", 
     
     SeeAlso => {"top Ideal","removeLowestDimension", "saturate", "quotient", 
	  "radical","component example"}
     }



 -- doc1.m2:71:     Key => topicList,
 -- doc1.m2:82:     Key => topics,
 -- doc10.m2:77:     Key => [resolution,StopBeforeComputation],
 -- doc10.m2:368:     Key => top,
 -- doc10.m2:369:     FormattedKey => "top components",                                 -- to avoid it looking like "Top", the top node in an info file
 -- doc10.m2:458:     Key => topCoefficients,
 -- doc8.m2:516:     Key => StopBeforeComputation,
 -- doc8.m2:523:     Key => [gb,StopBeforeComputation],
 -- doc8.m2:652:     Key => StopWithMinimalGenerators,
 -- doc8.m2:668:     Key => [gb,StopWithMinimalGenerators], 
 -- doc8.m2:904:     Key => [syz,StopWithMinimalGenerators],
 -- doc8.m2:973:     Key => [syz,StopBeforeComputation],
 -- doc8.m2:1676:     Key => [pushForward1,StopBeforeComputation],
 -- doc8.m2:1745:     Key => [pushForward1,StopWithMinimalGenerators],
 -- doc9.m2:16:     Key => [pushForward,StopBeforeComputation],
 -- doc9.m2:25:     Key => [pushForward,StopWithMinimalGenerators],
 -- doc9.m2:696:     Key => nullhomotopy,
 -- overview3.m2:634:     Key => "top level loop",
 -- overview4.m2:339:     Key => "top-method",




