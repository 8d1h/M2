newPackage "SecondPackage"
export secondFunction
needsPackage "FirstPackage"
secondFunction = () -> apply(5, firstFunction)
document {
     Key => SecondPackage,
     Headline => "an example of a package that depends on another",
     "This package depends on ", TO "FirstPackage", " and loads it,
     but the functions of ", TO "FirstPackage", " are not exposed
     to the user."
     }
document {
     Key => secondFunction,
     Headline => "a function that depends on one from another package",
     "Here is an example of its use.  It calls ", TO "firstFunction", " in
     the package ", TO "FirstPackage", " and assembles some of the values 
     into a list.",
     EXAMPLE {
	  "secondFunction()",
	  "code secondFunction",
	  "code firstFunction"
	  }
     }

