--		Copyright 1993-2002 by Daniel R. Grayson

RR.isBasic = true
RR#0 = 0.
RR#1 = 1.
RR.char = 0
RR.InverseMethod = x -> 1/x
RR.degreeLength = 0
RR.isField = true
RR.RawRing = rawRR 10.^-10
RR.frac = RR
RR.baseRings = {}
RR.dim = 0
RR.char = 0
RR.Engine = true
-- new RR := RR -> RR.pop()
degree RR := i -> {}

new RR from RawRingElement := (RR,x) -> rawToReal x

RR == ZZ := (x,y) -> x === y+0.
ZZ == RR := (y,x) -> x === y+0.

RR == QQ := (x,r) -> x === r+0.
QQ == RR := (r,x) -> x === r+0.

isConstant RR := i -> true

RRR.isBasic = true
RRR#0 = 0.
RRR#1 = 1.
RRR.char = 0
RRR.InverseMethod = x -> 1/x
RRR.degreeLength = 0
RRR.isField = true
RRR.RawRing = rawRRR()
RRR.frac = RRR
RRR.baseRings = {}
RRR.dim = 0
RRR.char = 0
RRR.Engine = true
degree RRR := i -> {}
isConstant RRR := i -> true
round = x -> floor(x + 0.5)

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/m2 "
-- End:
