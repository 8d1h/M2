R = ZZ/101[a..d]
I = ideal 0_R
assert ( decompose I == {I} )
assert ( decompose ideal 1_R == {} )
S = R / ((a+b)*(a^2+b))
I = ideal 0_S
assert (
     decompose I == {ideal(a^2+b), ideal(a+b)} 
     or
     decompose I == {ideal(a+b), ideal(a^2+b)} 
     )

A = ZZ/101[a,b,c]
I = ideal (b^2 - 4*a*c)
irreducibleCharacteristicSeries I
decompose I
assert ( decompose I == { I } )

A = QQ[a,b,c]
I = ideal (b^2 - 4*a*c)
decompose I
assert ( decompose I == { I } )
J = a*I
decompose J
assert( 
     decompose J == {ideal a, ideal(b^2-4*a*c)}
     or 
     decompose J == {ideal(b^2-4*a*c), ideal a}
     )


f = 77 * a^5 + 64637 * a^3 + a - 111
g = 77 * a^8 + 646371 * a^3 + a - 111
h = 111/60 * f * g^2
s = factor h
assert( # s == 3 )
assert( value s == h )


h = symbol h

A = ZZ/103[a..e,h]
I = ideal ( a+b+c+d+e, a*b + b*c + c*d + d*e + e*a ,
     a*b*c + b*c*d + c*d*e + d*e*a + e*a*b,
     a*b*c*d + b*c*d*e + c*d*e*a + d*e*a*b + e*a*b*c,
     a*b*c*d*e - h^5
     )
decompose I
assert ( 25 == # decompose I )

A = ZZ/101[a..e,h]
I = ideal ( a+b+c+d+e, a*b + b*c + c*d + d*e + e*a ,
     a*b*c + b*c*d + c*d*e + d*e*a + e*a*b,
     a*b*c*d + b*c*d*e + c*d*e*a + d*e*a*b + e*a*b*c,
     a*b*c*d*e - h^5
     )
decompose I
assert ( 75 == # decompose I )

end

-- we don't have enough time to test this one

A = QQ[a..e]
I = ideal ( a+b+c+d+e, a*b + b*c + c*d + d*e + e*a ,
     a*b*c + b*c*d + c*d*e + d*e*a + e*a*b,
     a*b*c*d + b*c*d*e + c*d*e*a + d*e*a*b + e*a*b*c,
     a*b*c*d*e - 1
     )
decompose I
assert ( 25 == # decompose I )


end

-- this one crashes deep in FACTORY code

A = QQ[a..e,h]
I = ideal ( a+b+c+d+e, a*b + b*c + c*d + d*e + e*a ,
     a*b*c + b*c*d + c*d*e + d*e*a + e*a*b,
     a*b*c*d + b*c*d*e + c*d*e*a + d*e*a*b + e*a*b*c,
     a*b*c*d*e - h^5
     )
decompose I
assert ( 25 == # decompose I )
-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/test decompose.out"
-- End:
