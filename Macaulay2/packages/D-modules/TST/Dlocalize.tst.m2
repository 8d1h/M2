clearAll();
path = join(path, {"../"});
load "Dloadfile.m2";

------------------------- EXAMPLES for Dlocalization --------------------------------

-- Example 1: Boundary cases 
W = QQ[x,dx,WeylAlgebra=>{x=>dx}];
M = cokernel matrix{{dx}};
assert(Dlocalize(M, 0_W) == 0);
assert(Dlocalize(M, 0_W, Strategy => Oaku) != 0);
assert(Dlocalize(M, 1_W) == M);
assert(Dlocalize(M, 1_W, Strategy => Oaku) == M);

-- simplest localization
assert(target DlocalizeMap(M, x) == Dlocalize(M,x))
assert(target DlocalizeMap(M, x, Strategy => Oaku) ==
     Dlocalize(M, x, Strategy => Oaku))

-- Pure torsion module
M = cokernel matrix{{x}};
assert(Dlocalize(M, x) == W^0);
assert(DlocalizeMap(M, x) == 0);
assert(Dlocalize(M, x, Strategy => Oaku) == M)
assert(DlocalizeMap(M, x, Strategy => Oaku) == map(M))

-- Already localized
M = cokernel matrix{{x*dx+3/2}};
assert(Dlocalize(M, x) == cokernel matrix{{x*dx+3/2+2}});
assert(Dlocalize(M, x, Strategy => Oaku) == M);
assert(DlocalizeMap(M, x, Strategy => Oaku) == map(M));

-- Example 2: from Coutinho "Primer..."
n = 4;
W = QQ[u_1..u_n, Du_1..Du_n, WeylAlgebra => 
     apply(toList(1..n), i -> u_i => Du_i)];
M = W^1/ideal(Du_1..Du_n);
f = sum(toList(1..n), i -> u_i^2);
assert(Dlocalize(M, f) == Dlocalize(M, f, Strategy => Oaku));
assert(DlocalizeMap(M, f) == DlocalizeMap(M, f, Strategy => Oaku));
