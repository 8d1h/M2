rr = ZZ/101[a..Z];
cc = timing res coker genericMatrix(rr,a,3,9)
ti = cc#0
re = cc#1
vv = apply(8,i->rank re_i)
assert( vv == {3, 9, 126, 378, 504, 360, 135, 21} )

<< "-- " << first lines get "!uname -a" << endl
<< "-- " <<  string ti << " seconds, Macaulay 2 version " << version#"VERSION" << endl

-- Results:

-- Linux noether.matematik.su.se 2.1.121 #3 Wed Sep 16 10:05:16 CEST 1998 alpha unknown (600 mHz)
-- 1.20106 seconds, 0.8.46

-- Linux geometry 2.1.121 #33 SMP Tue Sep 15 21:44:25 CDT 1998 i586
-- 4.01 seconds, Macaulay 2 version 0.8.47
-- Linux geometry 2.2.0-pre4 #65 Mon Jan 4 20:14:06 CST 1999 i586 unknown
-- 4.17 seconds, Macaulay 2 version 0.8.50

-- IRIX illi 5.3 12201932 IP22 mips
-- 	5.49 seconds		0.8.10

-- HP-UX ux1 B.10.10 U 9000/819 65611361 unlimited-user license
-- 	6.26 seconds

-- NeXTstep mms-hal 3.2 2 i586
-- 	6.74973 seconds

-- SunOS venus.math.uiuc.edu 5.5.1 Generic sun4m sparc SUNW,SPARCstation-5
--         7.51 seconds		0.8.46

-- SunOS orion.math.uiuc.edu 5.5 Generic sun4d sparc SUNW,SPARCserver-1000
-- 	8.41 seconds		0.8.46

-- SunOS kilburn 4.1.4 2 sun4m
-- Macaulay 2 version 0.8.46
-- 10.17 seconds

-- HP-UX skolem A.09.05 A 9000/750 2013387634 two-user license
-- 	10.25 seconds

-- Linux homotopy 2.0.14, NEC Versa E, i486 laptop, DX4/100, 25 mhz
-- 	Macaulay 2, version 0.8.26
--      	22.04 seconds
