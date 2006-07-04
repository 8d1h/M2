--- status: Draft
--- author(s): Giulio 
--- notes: 

document { 
     Key => {topComponents},
     Headline => "compute top dimensional component",
     "The method used is that of Eisenbud-Huneke-Vasconcelos, in their 1993 Inventiones Mathematicae paper.",
     PARA{},
     "If M is a module in a polynomial ring R, then the implementations of 
     ", TO "topComponents", " and ", TO "removeLowestDimension", " are based on 
     the following observations:",
     UL {
	  TEX ///$codim Ext^d(M,R) \ge d$ for all d///,
	  TEX ///If $P$ is an associated prime of $M$ of codimension $d := codim P > codim M$,
	  then $codim Ext^d(M,R) = d$ and the annihilator of $Ext^d(M,R)$ is contained
	  in $P$///,
	  TEX ///If $codim Ext^d(M,R) = d$, then there really is an associated prime 
	  of codimension $d$.///,
	  TEX ///If $M$ is $R/I$, then $topComponents(I) = ann Ext^c(R/I,R)$, where $c = codim I$///
	  },
    SeeAlso => {"removeLowestDimension", "saturate", "quotient", "radical", "component example"},
    }

document { 
     Key => (topComponents,Ideal),
     Usage => "topComponents I",
     Inputs => {"I"
	  },
     Outputs => {
	  "I" => Ideal => {"which is the intersection of the primary components of " 
	       ,TT "I", " having the greatest Krull dimension" }
	  },
    "The method used is that of Eisenbud-Huneke-Vasconcelos. ", 
    "For a brief description see: ",TO "topComponents",".", 
    
     EXAMPLE {
	  "R=ZZ/32003[a..c];",
	  "I=intersect(ideal(a,b),ideal(b,c),ideal(c,a),ideal(a^2,b^3,c^4));",
	  "topComponents I" 
	  },
     SeeAlso => {(topComponents, Module),"removeLowestDimension", "saturate", "quotient", "radical", "component example"}
     },

document { 
     Key => (topComponents,Module),
     Usage => "topComponents M",
     Inputs => {
	  "M"
	  },
     Outputs => {
	  "N" => Module => {" which is the intersection of the 
	       primary components of ", TT "M", 
	       " having gretest Krull dimension"} 
	  },
    "The method used is that of Eisenbud-Huneke-Vasconcelos. ", 
    "For a brief description see: ",TO "topComponents",".", 
     
     SeeAlso => {(topComponents,Ideal),"removeLowestDimension", "saturate", "quotient", "radical","component example"}
     }



 -- doc1.m2:71:     Key => topicList,
 -- doc1.m2:82:     Key => topics,
 -- doc10.m2:77:     Key => [resolution,StopBeforeComputation],
 -- doc10.m2:368:     Key => topComponents,
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
 -- overview4.m2:339:     Key => "topComponents",




