restart
loadPackage "PowerSeries"

ZZ[x]

-- We can create a series from a rational function:
series(1/(1-x), Degree =>10) --(series, RingElement)

-- We can create a series using a generating function:
series(x,i->i^2) --(series, RingElement, Function) 

-- We can create a series given a function that computes successive polynomial approximations:
f = i -> sum(i,j-> j*(x)^j)
series(f) --(series, Function) 

-- We can create a series by manually typing in some terms of it:
series(20,1+x+x^2+x^3+x^10) --(series, ZZ, RingElement) 



-- We can create a series to any given precision using the "Degree" option:
series(1/(1-x),Degree=>8) --(series, RingElement)

-- The key is that series created in most ways can have their precision increased or decreased at will:
setDegree(10,s1)
setDegree(2,s5)

-- and old precision calculations are cached when precision is artificially decreased:
peek s6

-- Series can be added, multiplied, subtracted, and negated:
S = s1 + s2
-S

prod = S*S
prod = setDegree(12,prod)
prod = setDegree(1,prod)
peek prod

-- Precision does reasonable things on addition:
s1
prod
s1+prod
peek oo


-- We can create a series from a rational function:
s = series(1/(1-x), Degree =>10) --(series, RingElement)
s.polynomial
s#polynomial
s#"polynomial"
s#symbol polynomial
keys s
s#((keys s)_3)
