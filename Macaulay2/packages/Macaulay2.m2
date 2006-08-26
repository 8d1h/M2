newPackage ("Macaulay2",
     InfoDirSection => "Macaulay 2 and its packages", 
     Headline => "Macaulay 2 documentation", 
     Authors => {
	  {Name => "Daniel R. Grayson", Email => "dan@math.uiuc.edu", HomePage => "http://www.math.uiuc.edu/~dan/"},
	  {Name => "Michael E. Stillman", Email => "mike@math.cornell.edu", HomePage => "http://www.math.cornell.edu/People/Faculty/stillman.html"}
	  },
     HomePage => "http://www.math.uiuc.edu/Macaulay2/",
     Version => version#"VERSION")

beginDocumentation()

load "Macaulay2/loads.m2"

if keys Macaulay2#"private dictionary" =!= {} 
then error splice("Macaulay2 documentation: global symbols inadvertently defined: ", 
     toSequence between_", " apply(values Macaulay2#"private dictionary", s -> (
	       p := locate s;
	       toString s | " [" | p#0 | ":" | toString p#1 | "]"
	       )))

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/packages "
-- End:
