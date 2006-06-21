-- [ 1509468 ] Computation Hang-up and Strange Behavior of Units
--   (?)
-- Submitted By:
-- Frank Moore - fmoore 	Date Submitted:
-- 2006-06-20 17:37
-- Last Updated By:
-- fmoore - Attachment added


Q = ZZ/32003[a,b,c,d]
J1 = ideal {a^3,b^3,c^3,d^3}
J2 = ideal {a^4,b,c,d}
J3 = ideal {a,b^4,c,d}
I = intersect(J1,J2,J3)
--- define quotient ring over Q
use Q
S = Q/(I+ideal{b^3})
res coker vars S
--- define quotient ring over Q another way
use Q
S = Q/ideal {a^4,a^3*b,a^3*c,a^3*d,b^3,c^3,d^3}
res coker vars S
--- define intermediate ring R and then define S as a quotient ring of R
--- hangs up on res coker vars S
R = Q/I
K = ideal {b^3}
S = R/K
gbTrace = 3
res coker vars S

--- other problem
R = ZZ/101[x,y,z,w]/ideal{x*y-z*w}
--- returns 2(incorrect)
(2_R)^(-1)
--- returns -50 (correct)
lift(1_R/2_R,R)

--- Thanks!
