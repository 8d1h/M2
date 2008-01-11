-- rings considered here: ZZ, QQ, RR_nn, CC_nn

assert( toRR 1 === 1. )
assert( toRR (1/10) === .1 )

assert( 1. === 1. )
assert( 1. =!= .1 )
assert( 1p111 =!= 1p110 )
assert( realPart toCC 1. === 1. )
assert( imaginaryPart toCC 1. === 0. )

assert try (lift(1.3,ZZ); false) else true
assert not liftable(1.3,ZZ)
assert liftable(1.,ZZ)
assert (lift(1.,ZZ) === 1)

ring 4.
RR _ (precision 4.)
assert(oo===ooo)

ring (4.*ii)
CC _ (precision 4.)
assert(oo===ooo)

defaultPrecision = 100

assert(precision 1. == 100)
ring (4.*ii)
CC _ (precision 4.)
assert(oo===ooo)

M = matrix{{1.3,2.4567}}
assert (ring M === ring 1.3)

assert( 1_(RR_44) == 1 )
assert( precision 1_(RR_44) == 44 )
assert( 1_RR == 1 )
assert( precision 1_RR == defaultPrecision )

assert( 1_(CC_44) == 1 )
assert( precision 1_(CC_44) == 44 )
assert( 1_CC == 1 )
assert( precision 1_CC == defaultPrecision )

assert( ii_(CC_44) == ii )
assert( precision ii_(CC_44) == 44 )
assert( ii_CC == ii )
assert( precision ii_CC == defaultPrecision )

assert( promote(1.,RR_222) === 1p222 )

assert( promote(1,RR) === 1. )
assert( promote(1,RR_222) === 1p222 )
assert( promote(1/1,RR) === 1. )
assert( promote(1/1,RR_222) === 1p222 )

assert( promote(1,CC) == 1 )
assert( promote(1,CC) == 1. )
assert( promote(1,CC) === 1.+0*ii )
assert( promote(1,CC) === toCC 1 )
assert( promote(1,CC_222) == 1p222+0*ii )
assert( promote(1,CC_222) =!= 1p222+0*ii )
assert( promote(1,CC_222) === toCC 1p222 )
assert( promote(1/1,CC) == 1 )
assert( promote(1/1,CC) == 1. )
assert( promote(1/1,CC) === 1.+0*ii )
assert( promote(1/1,CC_222) === toCC 1p222 )
assert( promote(1.,CC) == 1 )
assert( promote(1.,CC) == 1. )
assert( promote(1.,CC) === 1.+0*ii )
assert( promote(1.,CC_222) === toCC 1p222 )
assert( promote(1.,CC_222) === toCC 1p222 )
assert( not liftable(1*ii,RR) )
assert( liftable(0*ii,RR) )
assert( lift(3.5,QQ) === 7/2 )
assert( lift(3.5+0*ii,QQ) === 7/2 )
assert( numeric 1 === 1. )
assert( numeric {1} === {1.} )
assert( numeric ii === 0.+ii )
assert( numeric_44 1 === 1p44 )
assert( numeric_44 {1} === {1p44} )
assert( numeric_44 ii === 0p44+ii )

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/packages/Macaulay2/test numbers.out"
-- End:
