--		Copyright 1993-1999,2004 by Daniel R. Grayson
InfiniteNumber = new Type of BasicList
InfiniteNumber.synonym = "infinite number"
infinity = new InfiniteNumber from {1}
neginfinity := new InfiniteNumber from {-1}
- InfiniteNumber := x -> if x === infinity then neginfinity else infinity
PrintNames#infinity = "infinity"
PrintNames#(-infinity) = "-infinity"
toString InfiniteNumber := net InfiniteNumber := x -> PrintNames#x

IndeterminateNumber = new Type of BasicList
IndeterminateNumber.synonym = "indeterminate number"
indeterminate = new IndeterminateNumber from {}
PrintNames#indeterminate = "indeterminate"
toString IndeterminateNumber := net IndeterminateNumber := x -> "indeterminate"

InfiniteNumber ? InfiniteNumber := (x,y) -> x#0 ? y#0
InfiniteNumber + InfiniteNumber := (x,y) -> if x === y then x else indeterminate
InfiniteNumber - InfiniteNumber := (x,y) -> if x =!= y then x else indeterminate
InfiniteNumber * InfiniteNumber := (x,y) -> if x === y then infinity else neginfinity
InfiniteNumber / InfiniteNumber := (x,y) -> indeterminate
InfiniteNumber .. InfiniteNumber := (i,j) -> if i < j then error "infinite range specified" else ()
InfiniteNumber == InfiniteNumber := (x,y) -> x === y

InfiniteNumber .. ZZ := (i,n) -> if i < n then error "infinite range specified" else ()
ZZ .. InfiniteNumber := (n,i) -> if n < i then error "infinite range specified" else ()
InfiniteNumber + ZZ := (i,j) -> i
ZZ + InfiniteNumber := (i,j) -> j
InfiniteNumber - ZZ := (i,j) -> i
ZZ - InfiniteNumber := (i,j) -> -j
InfiniteNumber * ZZ := (i,j) -> if j > 0 then i else if j < 0 then -i else indeterminate
ZZ * InfiniteNumber := (j,i) -> if j > 0 then i else if j < 0 then -i else indeterminate
InfiniteNumber == ZZ := (x,y) -> false
ZZ == InfiniteNumber := (x,y) -> false
ZZ ? InfiniteNumber := (x,y) -> if y === infinity then symbol < else symbol >
InfiniteNumber ? ZZ := (x,y) -> if x === infinity then symbol > else symbol <

texMath InfiniteNumber := i -> if i === infinity then "\\infty" else "{-\\infty}"
mathML InfiniteNumber := i -> if i === infinity then "<mrow><mo>-</mo><mi>&infin;</mi></mrow>" else "<mi>&infin;</mi>"

max Sequence := max List := x -> (
     m := neginfinity;
     scan(x, n -> if n > m then m = n);
     m)
min Sequence := min List := x -> (
     m := infinity;
     scan(x, n -> if m > n then m = n);
     m)

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/m2 "
-- End:
