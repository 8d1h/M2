newPackage("Dmodules", Version => "1.0",
     Headline => "functions for computations with D-modules",
     Authors => {
	  {Name => "Anton Leykin", Email => "leykin@math.uic.edu"},
	  {Name => "Harrison Tsai"}
	  }
     )

load "./Dmodules/Dmodules.m2"

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/packages NAMEOFPACKAGE=Dmodules install-one"
-- End:
