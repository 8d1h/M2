k=GF(5,2,Variable=>a)
R1=k[s,t]
R2 = k[x,y,z,w]
assert( substitute(a*x-1,{x=>a}) == a^2 - 1 )
f = map(R1,R2,{s^4,s^3*t-a*t^2*s^2,s*t^3,t^4})
ker f
P0 = hilbertPolynomial (R2/(x,y,z))
P1 = hilbertPolynomial (R2/(x,y))
assert ( hilbertPolynomial coker gens ker f == 4 * P1 - 3 * P0 )
-- Local Variables:
-- compile-command: "make galois.okay "
-- End:
