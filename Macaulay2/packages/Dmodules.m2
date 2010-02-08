-- -*- coding: utf-8 -*-
newPackage("Dmodules", 
     Version => "1.3.1.1",
     Date => "02/08/2010",
     Headline => "functions for computations with D-modules",
     HomePage => "http://people.math.gatech.edu/~aleykin3/Dmodules",
     AuxiliaryFiles => true,
     Authors => {
	  {Name => "Anton Leykin", Email => "leykin@gatech.math.edu"},
	  {Name => "Harrison Tsai"}
	  },
     DebuggingMode => true
     )

load "./Dmodules/Dmodules.m2"

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/packages PACKAGES=Dmodules pre-install"
-- End:
