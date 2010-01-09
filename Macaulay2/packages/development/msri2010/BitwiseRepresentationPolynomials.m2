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
export {brpOR,isDivisible, Brp}
exportMutable {}

Brp = new Type of List -- this is not quite right yet

-- Convert regular polynomial into its binary representation
convert := Brp => f -> new Brp from  exponents f

-- Addition: concatenate and eliminate double monomials 
Brp + Brp := Brp => (a,b) -> new Brp from keys select(tally a + tally b, odd)

-- Multiplication of polynomial with monomial: bitwise OR
Brp * Brp := Brp => (a, m) ->  
  new Brp from apply (#a, i  -> brpOR( a#i, m))

-- bitwise OR for 2 monomials
brpOR = method()
brpOR (Brp, Brp) := Brp => (a,b) -> 
  apply (#a, i -> max (a#i, b#0#i) )
brpOR (List, Brp) := Brp => (a,b) -> 
  apply (#a, i -> max (a#i, b#0#i) )

--  is polynomial a divisible by monomial m
-- TODO
isDivisible = method()
isDivisible (Brp, Brp) := Boolean => (a,m) -> false


beginDocumentation()
document { 
	Key => BitwiseRepresentationPolynomials,
	Headline => "Binary representation of polynomials in ZZ/2",
	EM "BitwiseRepresentationPolynomials", " is an package."
	}
document {
-- -- TODO complete documentation
	Key => {isDivisible, (isDivisible,Brp,Brp)},
	Headline => "a silly first function",
	Usage => "isDivisible polynomial monomial",
	}

TEST ///
  firstpoly = new Brp from { {1,1,0}, {1,0,0}}
  secondpoly = new Brp from {{1,0,0}}
  thirdpoly = new Brp from {{1,0,0}, {1,1,1}}

-- -- TODO check the following by hand (work them out on paper)
  assert ( firstpoly * secondpoly == new Brp from {{1, 1, 0}, {1, 0, 0}} )
  assert ( firstpoly * secondpoly === new Brp from {{1, 1, 0}, {1, 0, 0}} )
  assert ( (new List from (firstpoly * secondpoly)) == {{1, 1, 0}, {1, 0, 0}})
  assert (false) -- I have this in to be sure that the tests are run
--  -- TODO make other assertions for the following 
--  firstpoly + secondpoly + thirdpoly
-- firstpoly * secondpoly * thirdpoly + myHash1 
-- myHash = firstpoly + thirdpoly
-- tt = {}
-- tt
-- myHash1 = firstpoly + secondpoly
--  
--  firstpoly + myHash1 
--firstpoly 
--firstpoly + secondpoly 
--myHash1 
///

end


-- Here place M2 code that you find useful while developing this
-- package.  None of it will be executed when the file is loaded,
-- because loading stops when the symbol "end" is encountered.

restart
installPackage "BitwiseRepresentationPolynomials"
installPackage("BitwiseRepresentationPolynomials", RemakeAllDocumentation=>true)
check BitwiseRepresentationPolynomials


-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/packages PACKAGES=PackageTemplate pre-install"
-- End:
