-- -*- coding: utf-8 -*-
newPackage(
	"BitwiseRepresentationPolynomials",
    	Version => "0.1", 
    	Date => "January 10, 2010",
    	Authors => {
	     {Name => "Beth, Franzi, Samuel", Email => ""}
	     },
    	HomePage => "http://",
    	Headline => "Computation for polynomials in ZZ/2 using binary representation",
      AuxiliaryFiles => false, -- set to true if package comes with auxiliary files
    	DebuggingMode => true		 -- set to true only during development
    	)

-- Any symbols or functions that the user is to have access to
-- must be placed in one of the following two lists
export {brpOR,
        isDivisible, 
        Brp, 
        convert, 
        removeDups, 
        divide, 
        lcmBrps, 
        isRelativelyPrime,
        leading}
        
exportMutable {}

Brp = new Type of List 

-- Convert regular polynomial into its binary representation
convert = method()
convert (RingElement) := Brp => f -> new Brp from rsort exponents f
convert (Brp, Ring ) := RingElement => (l, R) -> sum (#l, i -> R_(l#i) )
 

-- Addition: concatenate and eliminate double monomials 
Brp + Brp := Brp => (a,b) -> removeDups (a|b)

-- Multiplication of polynomial with monomial: bitwise OR
Brp * Brp := Brp => (a, m) ->  
  removeDups new Brp from rsort apply (#a, i  -> brpOR( a#i, m))

-- return the leading term of a polynomials, for now we are restricted to lex
leading = method()
leading (Brp) := Brp => p -> (
  p = rsort p;
  new Brp from {first p}
)


-- remove duplicate monomials ( because = 0 )
removeDups = method() 
removeDups (Brp) := Brp => p -> new Brp from rsort keys select(tally p, odd)

-- bitwise OR for 2 monomials
brpOR = method()
brpOR (Brp, Brp) := Brp => (a,b) -> 
  apply (#a, i -> max (a#i, b#0#i) )
brpOR (List, Brp) := Brp => (a,b) -> 
  apply (#a, i -> max (a#i, b#0#i) )

--  is monomial a divisible by monomial b
isDivisible = method()
isDivisible (Brp, Brp) := Boolean => (a,b) ->
  min flatten (a - b) > -1
  

-- check if two monomials are relatively prime
-- do a bitwise AND and check that they are all 0
isRelativelyPrime = method()
isRelativelyPrime (Brp, Brp) := Boolean => (f,g) -> (
  ret = true;
  scan( first f, first g, (i,j) -> (if min(i,j) == 1 then ( ret = false; break)));
  ret
)

-- divide monomial a by monomial b
divide = method()
divide (Brp, Brp) := Brp => (a,b) -> (
  assert isDivisible( a,b );
  new Brp from {first (a-b)} 
)
  
-- calculate least common multiple of two monomials
lcmBrps = method()
lcmBrps (Brp, Brp) := Brp => (a,b) -> new Brp from {apply( first a, first b, (i,j) -> max(i,j) )}

doc /// 
Key 
  BitwiseRepresentationPolynomials
  (Brp)
Headline 
 Binary representation of polynomials in ZZ/2
///

doc ///
Key 
  (divide,Brp,Brp)
  divide
Headline
 divide monomial a by monomial b
Usage
  c=divide(a,b)
Inputs 
  a:Brp
    a monomial 
  b:Brp
    a monomial that divides a
Outputs
  d:Brp
    a divided by b
Consequences
Description
  Text
  Example
    R = ZZ[x,y,z];
    a = convert(x*y);
    b = convert(x);
    convert(divide(a,b),R)
///

doc ///
Key 
  (isDivisible,Brp,Brp)
  isDivisible
Headline
  Check if a is divisible by m
Usage
  p + m
///

doc ///
Key 
  (brpOR,Brp,Brp)
  (brpOR,List,Brp)
  brpOR
Headline
  bitwiseOR for two monomials
///

doc ///
Key 
  (lcmBrps,Brp,Brp)
  lcmBrps
///

doc ///
Key 
  (convert,Brp,Ring)
  convert
Headline
  convert a Brp into its symbolic representation 
///

doc ///
Key 
  (symbol*,Brp,Brp)
Headline
  multiply a polynomial by a monomial  
///

doc ///
Key 
  (symbol+,Brp, Brp) 
Headline
  add 2 Brps
Usage
  c=a+b 
Inputs 
  a:Brp
    a polynomial 
  b:Brp
    a polynomial
Outputs
  c:Brp
    sum of a and b
///

-- -- TODO complete documentation

TEST ///

  R = ZZ/2[x,y,z]
  firstpoly = new Brp from { {1,1,0}, {1,0,0}}
  secondpoly = new Brp from {{1,0,0}}
  thirdpoly = new Brp from {{0,1,0}, {1,1,1}}
  zeropoly = new Brp from {}
  monoA= new Brp from {{1,0,1}}
  monoB= new Brp from {{1,0,0}}
  monoC= new Brp from {{0,1,0}}
 
  assert (lcmBrps( monoA, monoB) == new Brp from {{1,0,1}})
  assert (lcmBrps( monoC, monoB) == new Brp from {{1,1,0}})

  assert ( monoB + zeropoly == new Brp from {{1, 0, 0}}) 
  assert ( zeropoly *monoB == new Brp from {} )

  assert ( isDivisible(monoA, monoB) == true )
  assert isDivisible(monoA, monoB) 
  assert ( isDivisible(monoA, monoC) == false)
  divide(monoA, monoB) 
  assert( divide(monoA, monoB) == new Brp from {{0,0,1}})
  
  assert ( convert(x*y*z + x*z) === new Brp from rsort {{1,1,1}, {1,0,1}})
  assert ( convert(convert(x*y*z + x*z),R) === x*y*z + x*z )
  assert ( convert(convert(x*y+x*y), R) == 0)
  assert (convert (firstpoly, R) == x*y + x)
  assert (convert( convert (firstpoly, R) ) == firstpoly )

  assert ( firstpoly * secondpoly == new Brp from rsort {{1, 0, 0}, {1, 1, 0}})
  assert ( firstpoly * secondpoly === new Brp from rsort {{1, 0, 0}, {1, 1, 0}})
  assert ( thirdpoly * secondpoly === new Brp from rsort {{1, 1, 0}, {1, 1, 1}} )
  assert ( firstpoly + secondpoly == new Brp from {{1, 1, 0}} )
  assert ( firstpoly + secondpoly + thirdpoly == new Brp from rsort {{0, 1, 0}, { 1, 1, 0}, {1,1,1}} )
  assert ( (firstpoly + secondpoly) + thirdpoly == new Brp from rsort {{0, 1, 0}, { 1, 1, 0}, {1,1,1}} )

  assert ( (firstpoly + thirdpoly) * secondpoly == new Brp from rsort {{1, 0, 0}, {1,1,1}} )
  assert ( firstpoly * secondpoly * secondpoly == new Brp from rsort {{1, 1, 0}, {1, 0, 0}} )

  assert ( (new List from (firstpoly * secondpoly)) == rsort {{1, 1, 0}, {1, 0, 0}})

  assert(leading (convert( x*y)) == convert(x*y))
  assert(leading (convert( x + x*y )) == convert(x*y))
  assert(leading (convert( x + y*z )) == convert(x))
  assert(leading (convert( x*y*z + y*z )) == convert(x*y*z))
  assert(leading (convert( y*z*x + y*z )) == convert(x*y*z))

  assert( isRelativelyPrime(convert (x*y*z), convert( x) ) == false )

  assert (isRelativelyPrime( monoA, monoB) == false )
  assert isRelativelyPrime( monoC, monoB)

--  assert (false) -- I have this in to be sure that the tests are run
///

end


-- Here place M2 code that you find useful while developing this
-- package.  None of it will be executed when the file is loaded,
-- because loading stops when the symbol "end" is encountered.

restart
uninstallPackage "BitwiseRepresentationPolynomials"
installPackage("BitwiseRepresentationPolynomials", RemakeAllDocumentation=>true)
check BitwiseRepresentationPolynomials
