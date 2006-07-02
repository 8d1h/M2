newPackage(
     "PrimaryDecomposition",
     Headline => "functions for primary decomposition (pre-loaded)"
     )
export {
     EHV,					    -- cryptic
     Hybrid,
     GTZ,
     SY,
     binomialCD,
     extract,
     findNonMember,
     flattener,
     localize,
     minSat,
     primaryComponent,
     quotMin,
     radicalContainment
     }


--     EHVprimaryDecomposition,			    -- cryptic
--     HprimaryDecomposition,
--     Hybrid,
--     primdecComputation,
--     minSatPPD,
--     sortByDegree

load "PrimaryDecomposition/GTZ.m2"
load "PrimaryDecomposition/Shimoyama-Yokoyama.m2"
load "PrimaryDecomposition/Eisenbud-Huneke-Vasconcelos.m2"

binomialCD = (I) -> error "Binomial strategy not implemented yet"

Hybrid = new SelfInitializingType of BasicList

primaryDecomposition Ideal := List => o -> (I) -> (
     -- Determine the strategy to use.
     opt := SY;
     if o.Strategy =!= null then (
	  opt = o.Strategy;
	  if opt === Monomial and not isMonomialIdeal I
	  then error "cannot use 'Monomial' strategy on non monomial ideal";
	  )
     else (
	  -- if we have a monomial ideal: use Monomial
	  if isMonomialIdeal I then 
	     opt = Monomial;
	  );
     -- Now call the correct algorithm
     if opt === Monomial then (
	  C := primaryDecomposition monomialIdeal I;
	  I.cache#"Assassinator" = apply(C, I -> ideal radical I);
	  C/ideal
	  )
     else if opt === Binomial then binomialCD I
     else if opt === EHV then EHVprimaryDecomposition I
     else if opt === SY then SYprimaryDecomposition I
     else if class opt === Hybrid then (
	  if #opt =!= 2 then error "the Hybrid strategy requires 2 arguments";
	  assStrategy := opt#0;
	  localizeStrategy := opt#1;
	  HprimaryDecomposition ( I, assStrategy, localizeStrategy )
	  )
     )

beginDocumentation()

document {
     Key => PrimaryDecomposition,
     "This package provides computations with components
     of ideals, including minimal and associated primes, radicals, and
     primary decompositions of ideals.",
     Subnodes => {
	  TO (associatedPrimes, Ideal),
	  TO [associatedPrimes,Strategy],
	  TO (localize,Ideal,Ideal),
	  TO [localize,Strategy],
	  TO (primaryComponent, Ideal, Ideal),
	  TO [primaryComponent,Strategy],
	  TO [primaryComponent,Increment],
	  TO (primaryDecomposition, Ideal),
	  TO [primaryDecomposition,Strategy]
	  }
     }

load "PrimaryDecomposition/doc.m2"

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/packages PrimaryDecomposition.installed"
-- End:
