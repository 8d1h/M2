--- status: DRAFT
--- author(s): L. Gold
--- notes: working on this

document { 
     Key => hilbertPolynomial,
     Headline => "compute the Hilbert polynomial",
     "The Hilbert polynomial is written in the variable T",
     SeeAlso => "ProjectiveHilbertPolynomial"
     }
document { 
     Key => (hilbertPolynomial,Ring),
     Headline => "compute the Hilbert polynomial of the ring",
     Usage => "hilbertPolynomial R",
     Inputs => { 
	  "R" => Ring => ""
	  },
     Outputs => {
	  "the Hilbert polynomial" 
	  },
     EXAMPLE {
	  }
     }
document { 
     Key => {(hilbertPolynomial,Module),(hilbertPolynomial,CoherentSheaf)},
     Headline => "compute the Hilbert polynomial of the module",
     Usage => "hilbertPolynomial M",
     Inputs => {
	  },
     Outputs => {
	  ProjectiveHilbertPolynomial => ""
	  },
     Consequences => {
	  },     
     EXAMPLE {
	  },
     Caveat => {},
     SeeAlso => {}
     }
document { 
     Key => (hilbertPolynomial,Ideal),
     Headline => "compute the Hilbert polynomial of the quotient of
     the ambient ring by the ideal",
     Usage => "hilbertPolynomial I",
     Inputs => {
	  },
     Outputs => {
	  ProjectiveHilbertPolynomial => ""
	  },
     Consequences => {
	  },     
     EXAMPLE {
	  },
     Caveat => {},
     SeeAlso => {}
     }
document { 
     Key => (hilbertPolynomial,ProjectiveVariety),
     Headline => "compute the Hilbert polynomialo of the projective variety",
     Usage => "hilbertPolynomial V",
     Inputs => {
	  "V" => ProjectiveVariety => ""
	  },
     Outputs => {
	  ProjectiveHilbertPolynomial => ""
	  },
     EXAMPLE {
	  }
     }

document { 
     Key => [hilbertPolynomial, Projective],
     Headline => "choose how to display the Hilbert polynomial",
     Usage => "hilbertPolynomial(...,Projective => b",
     Inputs => {
	  "b" => Boolean => "either true or false"
	  },
     TT "Projective => true", " is an option to ", TO "hilbertPolynomial", 
     " which specifies that the Hilbert
     polynomial produced should be expressed in terms of the Hilbert
     polynomials of projective spaces.  This is the default.",
     PARA,
     TT "Projective => false", " -- an option to ", TO "hilbertPolynomial",
      " which specifies that the Hilbert
     polynomial produced should be expressed as a polynomial in the
     degree.",
     EXAMPLE {
	  "R = ZZ/101[a..d]",
      	  "S = image map(R, R, {a^4, a^3*b, a*b^3, b^4})",
      	  "presentation S",
      	  "h = hilbertPolynomial S",
	  },
     "The rational quartic curve in P^3 is therefore 'like' 4 copies
     of P^1, with three points missing.  One can see this by noticing
     that there is a deformation of the rational quartic to the union
     of 4 lines, or 'sticks', which intersect in three successive points.",
     PARA,
     "These Hilbert polynomials can serve as Hilbert functions, too.",
     EXAMPLE {
	  "h 3",
      	  "basis(3,S)",
      	  "rank source basis(3,S)",
	  },
     "Note that the Hilbert polynomial of P^i is z |--> binomial(z +
     i, i).",
     SeeAlso => "ProjectiveHilbertPolynomial"
     }

TEST "
scan(3, n -> (
     R = ZZ/101[x_0 .. x_n];
     scan(-2 .. 2, d -> (
	  M = R^{-d};
	  h = hilbertPolynomial M;
	  scan(d .. d + 4, e -> assert(numgens source basis(e,M) == h e))))))
"
TEST "
scan(3, n -> (
     R = ZZ/101[x_0 .. x_n];
     scan(-2 .. 2, d -> (
	  M = R^{-d};
	  h = hilbertPolynomial (M, Projective => false);
	  i = (ring h)_0;
	  scan(d .. d + 4, e -> (
		    r = numgens source basis(e,M);
		    s = substitute(h, { i => e/1 });
	       	    assert( r == s)))))))
"
