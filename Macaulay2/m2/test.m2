errorDepth 0CO:
l = matrix {CO:{5}}
if instance(ZZZ, Type) then (CO:
    m = matrix {{5_ZZZ}};
    print m;
    ideal 5_ZZZ;
    k = ZZZ/5;
    print k;
    )
o = monomialOrdering(RevLex => 4)
print o
print (o ** o)
M = monoid [x,y,z,t, NewMonomialOrder => RevLex => 4]
print M
print see M
print see M.MonomialOrder
print options M
R = k M
print R
print see R
print ("engine stack: " | engineStack())
f = (1+x+y^3)^3
print leadMonomial f
print baseName t
-- print listForm f
-- print standardForm f

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/m2"
-- End:
