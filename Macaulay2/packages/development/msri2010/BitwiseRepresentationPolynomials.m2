-- -*- coding: utf-8 -*-
newPackage(
	"BitwiseRepresentationPolynomials",
    	Version => "0.1", 
    	Date => "April 28, 2005",
    	Authors => {
	     {Name => "Beth, Franzi, Samuel", Email => ""}
	     },
    	HomePage => "http://",
    	Headline => "Computation for polynomials in ZZ/2 using binary
      representation",
	AuxiliaryFiles => false, -- set to true if package comes with auxiliary files
    	DebuggingMode => true		 -- set to true only during development
    	)

-- Any symbols or functions that the user is to have access to
-- must be placed in one of the following two lists
export {+,*, New}
exportMutable {}

Brp = new Type from List -- this is not quite right yet

-- Convert regular polynomial into its binary representation
convert = method(TypicalValue => Brp)
convert := f -> ( exponents f)

-- Addition: concatenate and eliminate double monomials 
Brp + Brp = method(TypicalValue => Brp)
Brp + Brp := (a,b) ->  a+b 
   
-- Multiplication: bitwise OR
Brp * Brp = method(TypicalValue => Brp)
Brp * Brp := (a,b) ->  a*b 
   


beginDocumentation()
document { 
	Key => BitwiseRepresentationPolynomials,
	Headline => "Binary representation of polynomials in ZZ/2",
	EM "BitwiseRepresentationPolynomials", " is an package."
	}
document {
	Key => {firstFunction, (firstFunction,ZZ)},
	Headline => "a silly first function",
	Usage => "firstFunction n",
	Inputs => {
		"n" => ZZ => {}
		},
	Outputs => {
		String => {}
		},
	"This function is provided by the package ", TO PackageTemplate, ".",
	EXAMPLE {
		"firstFunction 1",
		"firstFunction 0"
		}
	}
document {
	Key => secondFunction,
	Headline => "a silly second function",
	"This function is provided by the package ", TO PackageTemplate, "."
	}
document {
	Key => (secondFunction,ZZ,ZZ),
	Headline => "a silly second function",
	Usage => "secondFunction(m,n)",
	Inputs => {
	     "m" => {},
	     "n" => {}
	     },
	Outputs => {
	     {"The sum of ", TT "m", ", and ", TT "n", 
	     ", and "}
	},
	EXAMPLE {
		"secondFunction(1,3)",
		"secondFunction(23213123,445326264, MyOption=>213)"
		}
	}
document {
     Key => MyOption,
     Headline => "optional argument specifying a level",
     TT "MyOption", " -- an optional argument used to specify a level",
     PARA{},
     "This symbol is provided by the package ", TO PackageTemplate, "."
     }
document {
     Key => [secondFunction,MyOption],
     Headline => "add level to result",
     Usage => "secondFunction(...,MyOption=>n)",
     Inputs => {
	  "n" => ZZ => "the level to use"
	  },
     Consequences => {
	  {"The value ", TT "n", " is added to the result"}
	  },
     "Any more description can go ", BOLD "here", ".",
     EXAMPLE {
	  "secondFunction(4,6,MyOption=>3)"
	  },
     SeeAlso => {
	  "firstFunction"
	  }
     }
TEST ///
  assert(firstFunction 1 === "Hello, World!")
  assert(secondFunction(1,3) === 4)
  assert(secondFunction(1,3,MyOption=>5) === 9)
///
  
       
end

-- Here place M2 code that you find useful while developing this
-- package.  None of it will be executed when the file is loaded,
-- because loading stops when the symbol "end" is encountered.

installPackage "PackageTemplate"
installPackage("PackageTemplate", RemakeAllDocumentation=>true)
check PackageTemplate

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/packages PACKAGES=PackageTemplate pre-install"
-- End:
