R = ZZ[x,y]
i = ideal(6*x^3, 9*x*y, 8*y^2)
j1 = ideal(-3, x^2)
j2 = ideal(4*y)
j = j1 + j2
k = intersect(i:j1,i:j2)
m = i:j
assert( k == m )