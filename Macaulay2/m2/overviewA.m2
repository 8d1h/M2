----------------------------
-- The granddaddy node -----
----------------------------

document { "Mathematical Overview",
     "In this section we give a comprehensive overview of the main 
     mathematical types of Macaulay 2, their construction and most common
     operations. WARNING: this overview is currently under construction.",
     PARA,
     MENU {
	  TO "rings",
	  TO "ideals",
	  TO "matrices",
	  TO "substitution and maps between rings",
	  ("modules",
	       MENU {
		    (TO "modules: part I", " -- getting started"),
		    (TO "modules: part II", " -- homological and multilinear algebra")
		    }
	       ),
	  TO "Groebner bases and related computations",
	  TO "chain complexes",
	  TO "varieties",
	  TO "using external libraries",
	  ("specialized routines",
	       MENU {
		    TO "commutative algebra",
		    TO "algebraic geometry"
		    }
	       )
	  }
     }

----------------------------
-- Top level nodes ---------
----------------------------

document { "rings",
     HEADER2 "An overview",
     "Macaulay 2 differs from computer algebra systems such as maple and
     mathematica, in that rings are first class objects.  This means that
     before making polynomials or matrices, you must create a ring where
     you give the variables that you want, and the kinds of coefficients
     you want (e.g. rational numbers, or integers modulo a prime number).",
     MENU {
	  (TO "basic rings",
	       MENU {
		    TO "finite fields"
		    }
	       ),
	  (TO "polynomial rings",
	       MENU {
		    TO "monomial orderings",
		    TO "quasi- and multi-graded polynomial rings",
		    TO "quotient rings",
		    TO "manipulating polynomials",
		    TO "factoring polynomials"
		    }
	       ),
	  ("fields",
	       MENU {
		    TO "finite fields, part II",
		    TO "fraction fields",
		    TO "finite field extensions"
		    }
	       ),
	  ("other algebras",
	       MENU {
		    TO "exterior algebras",
		    TO "symmetric algebras",
		    TO "tensor products of rings",
		    TO "Weyl algebras",
		    (TO "Schur rings", 
			 " -- monomials represent irreducible representations of GL(n)"),
		    TO "associative algebras"
		    }
	       )
       },
      "For additional common operations and a comprehensive list of all routines
     in Macaulay 2 which return or use rings, see ", TO "Ring", "."
     }

document { "ideals",
     HEADER2 "An overview",     
     "In Macaulay 2, once a ring (see ",TO "rings", 
     ") is defined, ideals are constructed in the usual way
     by giving a set of generators.",
     MENU {
	  TO "creating an ideal",
	  ("conversions",
	       MENU {
		    TO "ideals to and from matrices",
		    SHIELD TO "ideals to and from modules"
		    }
	       ),
	  ("basic operations on ideals",
	       MENU {
		    TO "sums, products, and powers of ideals",
		    TO "equality and containment",
		    TO "extracting generators of an ideal",
		    TO "dimension, codimension, and degree"
		    }
	       ),
	  ("components of ideals",
	       MENU {
		    TO "intersection of ideals",
		    TO "ideal quotients and saturation",
		    TO "radical of an ideal",
		    TO "minimal primes of an ideal",
		    TO "associated primes of an ideal",
		    TO "primary decomposition"
		    }
	       ),
	  (SHIELD TO "Groebner bases and related computations"),
          },
     "For those operations where we consider an ideal as a module, such
     as computing Hilbert functions and polynomials, syzygies, free resolutions, see ",
     TO "modules: part I", ".",
     PARA,
      "For additional common operations and a comprehensive list of all routines
     in Macaulay 2 which return or use ideals, see ", TO "Ideal", "."
     }


document { "matrices",
     HEADER2 "An overview",     
     "In Macaulay 2, each matrix is defined over a ring, (see ", TO "rings", "). 
     Matrices are perhaps the most common data type in Macaulay 2.",
     MENU {
	  ("making matrices", 
	       MENU {
		    TO "input a matrix",
		    TO "random and generic matrices",
		    TO "concatenating matrices"
		    }
	       ),
	  ("operations involving matrices",
	       MENU {
		    TO "simple information about a matrix",
		    TO "basic arithmetic of matrices",
		    TO "kernel, cokernel and image of a matrix",
		    TO "differentiation"
		    }
	       ),
	  ("determinants and related computations",
	       MENU {
		    TO "rank of a matrix",
		    TO "determinants and minors",
		    TO "Pfaffians",
		    TO "exterior power of a matrix"
		    }
	       ),
	  ("display of matrices and saving matrices to a file",
	       MENU {
		    TO "format and display of matrices in Macaulay 2",
		    TO "importing and exporting matrices"
		    }
	       )
	  },
     "For an overview of matrices as homomorphisms between modules, 
     see ", TO "modules: part I", ".  
     For additional common operations and a comprehensive list of all routines
     in Macaulay 2 which return or use matrices, see ", TO "Matrix", "."
     }

document { "substitution and maps between rings",
     HEADER2 "An overview",
     MENU {
	  TO "substitute values for variables",
	  TO "working with multiple rings",
	  ("ring maps",
	       MENU {
		    TO "basic construction, source and target of a ring map",
	       	    TO "evaluation and composition of ring maps",
		    TO "kernel and image of a ring map"
		    }
	       ),
	  },
      "For additional common operations and a comprehensive list of all routines
     in Macaulay 2 which return or use ring maps, see ", TO "RingMap", "."
     }
     
document { "modules: part I",
     HEADER2 "Getting started",
     MENU {
	  ("construction of modules",
	       MENU {
		    TO "free modules",
		    (TO "matrices to and from modules", " (including kernel, cokernel and image)"),
		    TO "ideals to and from modules"
		    }
	       ),
	  (TO "Hilbert functions and free resolutions",
	       MENU {
		    "including degree and betti numbers"
		    }
	       ),
	  (TO "operations on modules",
	       MENU {
		    "including direct sum, tensor products, and annihilators"
		    }
	       ),
	  (TO "homomorphisms (maps) between modules",
	       MENU {
		    "including elements of modules"
		    }
--	       MENU {
--		    TO "constructing maps between modules",
--		    TO "information about a map of modules",
--		    TO "kernel, cokernel and image of a map of modules"
--		    }
	       ),
--	  ("graded modules",
--	       MENU {
--		    TO "degrees of elements and free modules",
--		    TO "degree and multiplicity of a module",
--		    TO "Hilbert functions and polynomials",
--		    TO "homogenization",
--		    TO "truncation and homogeneous components of a graded module"
--		    }
--	       ),
	  (TO "subquotient modules", " -- the way Macaulay 2 represents modules",
	       MENU {
		    "Macaulay 2 has handed you a subquotient module.  What now?"
		    }
--	       MENU {
--		    TO "what is a subquotient module?",
--		    TO "extracting parts of a subquotient module",
--		    TO "quotients of modules"
--		    }
	       )
	  },
     "See ", TO "modules: part II", " for more operations on modules."
     }

document { "modules: part II",
     MENU {
	  ("multilinear algebra",
	       MENU {
		    TO "exterior power of a module",
		    TO "Fitting ideals",
		    TO "adjoints of maps"
		    }
	       ),
	  ("homological algebra",
	       MENU {
		    TO "Hom module",
		    TO "Tor and Ext"
		    },
	       "For more operations in homological algebra, see ", TO "chain complexes", "."
	       )
	  },
      "For additional common operations and a comprehensive list of all routines
     in Macaulay 2 which return or use modules, see ", TO "Module", "."
     }

document { "Groebner bases and related computations",
     HEADER2 "An overview",
     MENU {
	  TO "what is a Groebner basis?",
	  TO "finding a Groebner basis",
	  TO "rings that are available for Groebner basis computations",
	  ("a few applications of Groebner bases",
	       MENU {
		    TO "elimination of variables",
		    TO "Hilbert functions",
		    TO "syzygies",
		    TO "saturation",
		    TO "fibers of maps",
		    TO "solving systems of polynomial equations"
		    }
	       ),
	  TO "fine control of a Groebner basis computation"
	  }
     }

document { "chain complexes",
     HEADER2 "An overview",
     MENU {
	  TO "free resolutions of modules",
	  TO "extracting information from chain complexes",
	  TO "making chain complexes by hand",
	  TO "manipulating chain complexes",
	  TO "maps between chain complexes"
	  },
      "For additional common operations and a comprehensive list of all routines
      in Macaulay 2 which return or use chain complexes or maps between chain complexes, see ", 
      TO "ChainComplex", " and ", TO "ChainComplexMap", ".",
     }

document { "varieties",
     HEADER2 "An overview",
     MENU {
	  TO "algebraic varieties",
	  TO "coherent sheaves",
	  },
     "For details, see ", TO "Variety", ".",
     }

document { "using external libraries",
     MENU {
     	  TO "loading a library",
     	  TO "how to get documentation on a library",
     	  ("available libraries",
	       MENU {
	       	    (TO "blow ups", ""),
	       	    (TO "convex hulls and polar cones", " -- polarCone.m2"),
	       	    (TO "D-modules", " -- D-modules.m2"),
	       	    (TO "elimination theory", " -- eliminate.m2"),
	       	    (TO "graphing curves and surfaces via 'surf'", ""),
	       	    (TO "invariants of finite groups", " -- invariants.m2"),
	       	    (TO "Lenstra-Lenstra-Lovasz (LLL) lattice basis reduction", " -- LLL.m2"),
	       	    (TO "SAGBI bases", " -- sagbi.m2")
	       	    })
	  }
     }

----------------------------
-- Lead nodes --------------
----------------------------

document { "rings that are available for Groebner basis computations",
     "In Macaulay 2, Groebner bases can be computed for ideals and submodules over many
     different rings.",
     MENU {
	  TO "over fields",
          TO "over the ring of integers",
          TO "over polynomial rings over a field",
	  TO "over polynomial rings over the integers",
	  TO "over Weyl algebras",
	  TO "over local rings"
     	  }
    }

-------------------
-- Ring nodes -----
-------------------

-------------------
-- ideal nodes ----
-------------------


-------------------
-- Matrix nodes ---
-------------------


-------------------
-- ring map nodes -
-------------------

-------------------
-- module nodes ---
-------------------


-------------------
-- GB nodes -------
-------------------


-------------------
-- library nodes --
-------------------

document { "loading a library",
     }

document { "how to get documentation on a library",
     }

document { "blow ups",
     }

document { "convex hulls and polar cones",
     }

document { "D-modules",
     }

document { "elimination theory",
     }

document { "graphing curves and surfaces via 'surf'",
     }

document { "invariants of finite groups",
     }

document { "Lenstra-Lenstra-Lovasz (LLL) lattice basis reduction",
     }

document { "SAGBI bases",
     }

-------------------
-- specialized   --
-------------------

document { "commutative algebra",
     TOC {
	  SECTION { "integralClosure",
	       },
	  SECTION { "primaryDecomposition",
	       },
	  SECTION { "symmetricAlgebra",
	       }
	  }
     }

document { "algebraic geometry",
     TOC {
	  SECTION { "cotangentSheaf",
	       }
	  }
     }
