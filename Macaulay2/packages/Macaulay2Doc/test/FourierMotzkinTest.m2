--status: Greg Smith is working on this bug report
needsPackage "FourierMotzkin"
M =  matrix{{1,1,1,1,1,1,1,1},{-1,1,-2,2,1,-2,2,-1},{2,2,1,-1,-2,-1,1,-2}}
assert( sort first fourierMotzkin M == sort first fourierMotzkin M_{4..7,0..3} )
