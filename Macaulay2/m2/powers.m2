--		Copyright 1994 by Daniel R. Grayson

--binomialRow := memoize ( 
--     n -> accumulate((x,j) -> (x * (n-j+1))//j, 1, toList (1 .. n)) 
--     )
--binomial ZZ := n -> binomialRow n
binomial(ZZ,ZZ) := memoize (
     (n,i) -> (
	  if i < 0 then 0
	  else if i === 0 then 1
     	  else if n > 0 then (
     	       if i > n then 0
     	       else binomial(n-1,i) + binomial(n-1,i-1)
	       )
	  else if n === 0 then 0
     	  else (-1)^i * binomial(-n+i-1,i)
	  )
     )

Thing ^ QQ := (x,r) -> (
     if denominator r === 1
     then x^(numerator r)
     else error "expected pair to have a method for '^'"
     )
