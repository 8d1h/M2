	d=3
	kk= ZZ/32003
	S = kk[x,y,z]
	f = ideal (x^d)
	R = S/f
	-- make a general eff cartier of degree 3
	-- supported at x=y=0
	use R
	p = x*(x^d)
	P=homogenize(p-y, z)
	D0 = ideal(P)
	D = saturate(D0,z)
	--gets error message

-----------------------------------------------------------------------------

-- a problem with matrices formed from lists of vectors in a subquotient module

R = QQ[x..z]
m = ideal vars R
M = m/m^2
N = saturate 0_M
