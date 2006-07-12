--		Copyright 1993-2002 by Daniel R. Grayson


QQ.RawRing = rawQQ()
QQ.isBasic = true
-- from raw QQ to toplevel QQ
--MES removed --new QQ from RawRingElement := (QQ,x) -> rawToInteger rawNumerator x / rawToInteger rawDenominator x
new QQ from RawRingElement := (QQ,x) -> rawToRational x
-- from toplevel QQ to raw QQ
raw QQ := x -> rawFraction(
     QQ.RawRing,
     rawFromNumber(rawZZ(), numerator x),
     rawFromNumber(rawZZ(), denominator x))

ZZ.frac = QQ
QQ#1 = 1/1
QQ#0 = 0/1
QQ.char = 0
QQ.isField = true
toString QQ := x -> toString numerator x | "/" | toString denominator x
QQ.baseRings = {ZZ}
QQ.mathML = "<mi>&Qopf;</mi>"
QQ.frac = QQ

QQ.random = () -> (random 21 - 10) / (random 9 + 1)
expression QQ := r -> (
     n := numerator r;
     d := denominator r;
     if n < 0 
     then -((expression (-n))/(expression d))
     else (expression n)/(expression d)
     )
net QQ := r -> net expression r
QQ.InverseMethod = x -> 1/x
QQ.dim = 0
QQ == ZZ := (r,i) -> r == i/1
ZZ == QQ := (i,r) -> r == i/1

QQ.Engine = true
assert (hash ZZ < hash QQ)

lift(QQ,ZZ) := (r,o) -> if denominator r === 1 then numerator r else error "rational number is not an integer"
liftable'(QQ,ZZ) := (r,o) -> denominator r === 1
lift(QQ,QQ) := promote(QQ,QQ) := (r,QQ) -> r
liftable'(QQ,QQ) := (QQ,QQ) -> true

QQ.degreeLength = 0
isUnit Number := x -> x != 0

isConstant QQ := i -> true

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/m2 "
-- End:
