-- taken from:
-- Bernd Sturmfels, FOUR COUNTEREXAMPLES IN COMBINATORIAL ALGEBRAIC GEOMETRY.

-- 1
R = QQ[a,b,c,d,e,f]
M = ideal(a*b*c,a*b*f,a*c*e,a*d*e,a*d*f, b*c*d,b*d*e,b*e*f,c*d*f,c*e*f)
assert( regularity module M == 3 )
assert( regularity module M^2 == 7 )

S = ZZ/2[a,b,c,d,e,f]
M = ideal(a*b*c,a*b*f,a*c*e,a*d*e,a*d*f, b*c*d,b*d*e,b*e*f,c*d*f,c*e*f)
assert( regularity module M == 4 )
assert( regularity module M^2 == 7 )

use R
M = ideal(d*e*f,c*e*f,c*d*f,c*d*e,b*e*f,b*c*d,a*c*f,a*d*e)
assert( regularity module M == 3 )
assert( regularity module M^2 == 7 )
-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/test 4a.okay "
-- End:
