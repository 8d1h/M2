<< "-- beginning computation " << get "!date"
<< "-- " << first lines get "!uname -a" << endl
<< "-- Macaulay2 " << version#"VERSION"
<< ", compiled with " << version#"compiler"
<< endl

rr = ZZ/101[a..Z, MonomialSize => 16];
ti = first timing (re = res coker genericMatrix(rr,a,3,9))

vv = apply(8,i->rank re_i)
assert( vv == {3, 9, 126, 378, 504, 360, 135, 21} )

<< "-- res39: " <<  toString ti << " seconds" << endl

SS = ZZ/101[a..t, MonomialSize => 16]
MM = SS^1/Grassmannian(2,5,SS)
ti = first timing (re = res MM)
vv = apply(11,i->rank re_i)
assert( vv == {1, 35, 140, 301, 735, 1080, 735, 301, 140, 35, 1} )

<< "-- resG25: " <<  toString ti << " seconds" << endl


-- Results:

-- beginning computation Mon Dec 23 00:06:16 CST 2002
-- Linux u126.math.uiuc.edu 2.4.18-18.7.xsmp #1 SMP Wed Nov 13 19:01:42 EST 2002 i686 unknown
--    Dell_dualX/2600 
-- Macaulay2 0.9, compiled with gcc 3.0
-- res39: 0.285138 seconds
-- resG25: 4.98438 seconds
--loaded benchmark.m2 from /home/17/dan/tmp/M2-linux/Macaulay2-0.9/lib/Macaulay2-0.9/packages/benchmark.m2

-- beginning computation Mon Dec 31 19:22:33 CST 2001
-- Linux capybara 2.4.18 #25 Sun Jul 28 15:59:31
-- Macaulay2 0.9.2, compiled with gcc 2.95
-- res39: 0.38 seconds
-- resG25: 6.05 seconds

-- beginning computation Thu Oct 17 00:26:02 CEST 2002
-- Linux abuch.imf.au.dk 2.4.9-34smp #1 SMP Sat Jun 1 05:54:57 EDT 2002 i686 unknown
-- Macaulay2 0.9.2, compiled with gcc 2.96
-- res39: 0.47 seconds
-- resG25: 7.82 seconds

-- beginning computation Sat May 25 17:27:49 CDT 2002
-- Linux lisboa.ks.uiuc.edu 2.4.16 #9 Tue Feb 19 14:11:28 CST 2002 i686 unknown
-- model name      : Intel(R) Pentium(R) 4 CPU 1700MHz
-- Macaulay2 0.9, compiled with gcc 3.0
-- res39: 0.44 seconds
-- resG25: 8.43 seconds

-- FreeBSD euclid.math.purdue.edu 4.5-RELEASE FreeBSD i386
-- Macaulay2 0.9.2, compiled with gcc 2.95
-- res39: 0.523437 seconds
-- resG25: 8.14062 seconds

-- Linux hn03 2.4.9-31pctr #1 SMP Thu May 9 13:22:43 CDT 2002 i686 unknown
-- Macaulay2 0.9.2, compiled with gcc 3.0
-- res39: 0.66 seconds
-- resG25: 10.23 seconds

-- OSF1 cosimo.medicis.polytechnique.fr V4.0 1229 alpha
-- 0.683216 seconds, Macaulay2 0.8.57, compiled with gcc 2.95

-- OSF1 agnesi.matematik.su.se V4.0 1091 alpha
-- 0.708576 seconds, Macaulay2 0.8.57, compiled with gcc 2.95

-- OSF1 despina.ks.uiuc.edu V4.0 1229 alpha
-- 0.75152 seconds, Macaulay2 0.8.52

-- CYGWIN_NT-5.0 NIOBIUM 1.3.2(0.39/3/2) 2001-05-20 23:28 i686 unknown (1 Ghz pentium III)
-- Macaulay2 0.9, compiled with gcc 2.95
-- res39: 0.802 seconds
-- resG25: 10.936 seconds

-- Linux rhenium 2.2.16 #24 Sat Jun 10 15:07:27 CDT 2000 i686 unknown
-- Macaulay2 0.8.61, compiled with gcc 2.95
-- res39: 1.12 seconds
-- resG25: 18.45 seconds

-- Linux noether.matematik.su.se 2.1.121 #3 Wed Sep 16 10:05:16 CEST 1998 alpha unknown (600 mHz)
-- 1.20106 seconds, 0.8.46

-- SunOS sg0.math.cornell.edu 5.7 Generic_106541-08 sun4u sparc SUNW,Ultra-Enterprise
-- Macaulay2 0.8.60, compiled with gcc 2.95
-- res39: 1.37 seconds
-- resG25: 18.29 seconds

-- Linux localhost.localdomain 2.2.1 #101 Fri Feb 5 16:17:12 EST 1999 ppc unknown
-- (250 MHz Macintosh Powerbook G3)
-- 1.67 seconds, Macaulay 2 version 0.8.52

-- beginning computation Thu Aug  9 18:07:41 CDT 2001
-- Linux rhenium 2.4.6 #61 Fri Jul 13 09:17:38 CDT 2001 i686 unknown
-- Macaulay2 0.9, compiled with gcc 2.95
-- res39: 1.71 seconds
-- resG25: 25. seconds

-- beginning computation Sun Sep  9 19:33:49 CDT 2001
-- Linux rhenium 2.4.9 #67 Mon Sep 3 11:10:40 CDT 2001 i686 unknown
-- Macaulay2 0.9, compiled with gcc 3.0.1  (faster than 3.0 below)
-- res39: 1.71 seconds
-- resG25: 27.27 seconds

-- Linux rhenium 2.4.4 #55 Tue Jun 26 13:44:25 CDT 2001 i686 unknown
-- Macaulay2 0.9, compiled with gcc 3.0
-- res39: 1.93 seconds
-- resG25: 28.47 seconds

-- Linux hypatia.matematik.su.se 2.0.34 #2 Thu May 7 10:48:04 EDT 1998 alpha unknown
-- 2.01366 seconds, Macaulay2 0.8.52a, compiled with gcc 2.90 -- with DEBUG on!

-- SunOS orion.math.uiuc.edu 5.5.1 Generic_103640-26 sun4u sparc SUNW,Ultra-4
-- 2.14 seconds, Macaulay2 0.8.53, compiled with gcc 2.8

-- Linux yttrium 2.2.6 #82 Sun Apr 18 15:06:16 CDT 1999 i686 unknown
-- e-machine: Cyrix M II - 333 MMX
-- 2.45 seconds, Macaulay2 0.8.53, compiled with gcc 2.91

-- SunOS andy 5.5.1 Generic_103640-29 sun4u sparc SUNW,Ultra-2
-- Macaulay2 0.8.60, compiled with gcc 2.95
-- res39: 2.7 seconds
-- resG25: 37.77 seconds

-- Linux geometry 2.3.18 #2 Thu Sep 16 17:50:47 CDT 1999 i586 unknown
-- 3.46 seconds, Macaulay2 0.8.55, compiled with gcc 2.95

-- Linux geometry 2.1.121 #33 SMP Tue Sep 15 21:44:25 CDT 1998 i586
-- 4.01 seconds, Macaulay 2 version 0.8.47, compiled with gcc

-- Linux geometry 2.2.0-pre4 #65 Mon Jan 4 20:14:06 CST 1999 i586 unknown
-- 4.17 seconds, Macaulay 2 version 0.8.50, compiled with gcc 2.8.1

----- with SHAREDLIBS, including interpeter but not engine:
-- Linux geometry 2.2.0-pre4 #65 Mon Jan 4 20:14:06 CST 1999 i586 unknown
-- 4.27 seconds, Macaulay 2 version 0.8.50

-- Linux geometry 2.2.2 #77 Wed Feb 24 10:40:05 EST 1999 i586 unknown
-- 4.31 seconds, Macaulay2 0.8.53, compiled with gcc 2.91, statically linked

-- CYGWIN_NT-4.0 GEOMETRY 20.1 (0.3/1/1) 1998-12-3 20:39:18 i586 unknown
-- 4.327 seconds, Macaulay 2 version 0.8.52
-- gcc version egcs-2.91.60 19981201 (egcs-1.1.1 release)

-- Linux geometry 2.2.2 #77 Wed Feb 24 10:40:05 EST 1999 i586 unknown
-- 4.36 seconds, Macaulay2 0.8.53, compiled with gcc 2.8, dynamically linked

-- Linux geometry 2.2.2 #77 Wed Feb 24 10:40:05 EST 1999 i586 unknown
-- 4.38 seconds, Macaulay2 0.8.53, compiled with gcc 2.91

----- with SHAREDLIBS, including engine and interpeter:
-- Linux geometry 2.2.0-pre4 #65 Mon Jan 4 20:14:06 CST 1999 i586 unknown
-- 4.81 seconds, Macaulay 2 version 0.8.50

-- IRIX illi 5.3 12201932 IP22 mips
-- 	5.49 seconds		0.8.10

-- with SHAREDLIBS and DEBUG and egcs compiler
-- Linux geometry 2.2.2 #77 Wed Feb 24 10:40:05 EST 1999 i586 unknown
-- 5.65 seconds, Macaulay2 0.8.52, compiled with gcc 2.91

-- HP-UX ux1 B.10.10 U 9000/819 65611361 unlimited-user license
-- 	6.26 seconds

-- NeXTstep mms-hal 3.2 2 i586
-- 	6.74973 seconds

-- SunOS saturn.math.uiuc.edu 5.5.1 Generic sun4m sparc SUNW,SPARCstation-5
-- 7.71 seconds, Macaulay 2 version 0.8.41

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
