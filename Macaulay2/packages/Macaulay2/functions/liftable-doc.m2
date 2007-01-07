--- status: DRAFT
--- author(s): MES
--- notes: 

undocumented {(liftable, Number, Number), (liftable, Number, RingElement), 
     (liftable, RingElement, Number), (liftable, RingElement, RingElement),
     (liftable, QQ, QQ), (liftable, QQ, ZZ)}

document { 
     Key => {liftable},
     Headline => "whether a ring element can be lifted to another ring",
     Usage => "liftable(f,R)",
     Inputs => {
	  "f" => RingElement,
	  "R" => Ring
	  },
     Outputs => {
	  Boolean => "whether f can be lifted to the ring R"
	  },
     "The ring ", TT "R", " should be one of the base rings associated with the
     ring of ", TT "f", ".",
     EXAMPLE lines ///
	  R = ZZ[x]
	  liftable ((x-1)*(x+1)-x^2, ZZ)
	  ///,
     EXAMPLE lines ///
     	  liftable(.342,RR)
     	  liftable(3/4,ZZ)
	  liftable((3/4)*4,ZZ)
          ///,
     SeeAlso => {lift, baseRings}
     }

