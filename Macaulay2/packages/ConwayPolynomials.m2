-- -*- coding: utf-8 -*-
newPackage(
	"ConwayPolynomials",
	AuxiliaryFiles => true,
    	Version => "1.0", 
    	Date => "October 23, 2008",
    	Authors => {
	     {Name => "Daniel R. Grayson", Email => "dan@math.uiuc.edu"}
	     },
    	HomePage => "http://www.math.uiuc.edu/~dan/",
    	Headline => "an optional database of Conway polynomials"
    	)
-- the data comes from http://www.math.rwth-aachen.de:8001/~Frank.Luebeck/data/ConwayPol/
-- the data file is http://www.math.rwth-aachen.de:8001/~Frank.Luebeck/data/ConwayPol/CPimport.txt
-- or http://www.math.rwth-aachen.de:8001/~Frank.Luebeck/data/ConwayPol/CPimport.txt.gz
export conwayPolynomial
fn  := currentFileDirectory | "ConwayPolynomials/ConwayPolynomials.txt"
getCP := memoize(
     () -> (
	  if notify then stderr << "--loading file " << fn << endl;
	  hashTable apply( lines get fn,
	       x -> (
	       	    x = value x;
	       	    ((x#0,x#1),drop(x,2))))))
Ap := memoize(p -> (ZZ/p)(monoid [global a]))
fix := (p,n,co,a) -> a^n + sum(#co, i -> co#i * a^i)
conwayPolynomial = method()
conwayPolynomial(ZZ,ZZ) := (p,n) -> if (getCP())#?(p,n) then fix(p,n,(getCP())#(p,n),(Ap p)_0)
conwayPolynomial ZZ := q -> (
     factors := factor q;
     if #factors =!= 1 or factors#0#0 === -1
     then error "expected a power of a prime";
     conwayPolynomial(factors#0#0,factors#0#1))
addHook(GaloisField,FindOne,(p,n,a) -> if (getCP())#?(p,n) then break fix(p,n,(getCP())#(p,n),a))
isConway := (F) -> (gens ideal ambient F)_(0,0) == sub(conwayPolynomial(F.char,F.degree),ambient ambient F)
map(GaloisField,GaloisField) := RingMap => o -> (K,F) -> (
     p := char F;
     n := K.degree;
     m := F.degree;
     if char K =!= p 
     or n % m != 0
     then error "no map of fields exists";
     if not (isConway F and isConway K) then error "not implemented: maps between non-Conway Galois fields";
     map(K,F,{K_0^((p^n-1)//(p^m-1))}))
beginDocumentation()
document { Key => ConwayPolynomials,
     Headline => "database of Conway polynomials for use with GF",
     PARA {
     	  EM "ConwayPolynomials", " is a package that provides a database of Conway polynomials.
	  A Conway polynomial for a prime p and an exponent n is a particular monic polynomial 
	  whose roots are primitive elements of a finite field with p^n elements.  They can take
	  a very long time to compute, so the package comes with just a publicly available database
	  of Conway polynomials provided by Frank Luebeck."
	  },
     PARA {
	  "After the package is loaded, the function ", TO "GF", " will return Galois
	  fields presented by Conway polynomials, provided they are in the table.  Moreover,
	  ", TO "map", " can be used to produce the canonical maps between Conway Galois fields."
	  },
     EXAMPLE lines ///
     conwayPolynomial 125
     GF 125
     ambient oo
     map(GF 125^2, GF 125)
     isWellDefined oo
     ///
     }
document { 
     Key => {conwayPolynomial, (conwayPolynomial,ZZ,ZZ), (conwayPolynomial,ZZ)},
     Headline => "provide a Conway polynomial",
     SYNOPSIS (
     	  Usage => "conwayPolynomial q",
	  Inputs => {
	       "q" => ZZ => {"a power of a prime number"}
	       },
	  Outputs => {
	       {"a Conway polynomial whose roots generate a field with q elements"}
	       },
	  EXAMPLE lines ///
	  conwayPolynomial 125
	  ///
	  ),
     SYNOPSIS (
     	  Usage => "conwayPolynomial(p,n)",
	  Inputs => {
	       "p" => ZZ => {"a prime number"},
	       "n" => ZZ
	       },
	  Outputs => {
	       {"a Conway polynomial whose roots generate a field with p^n elements"}
	       },
	  EXAMPLE lines ///
	  conwayPolynomial(2,20)
	  ///
	  )
     }
