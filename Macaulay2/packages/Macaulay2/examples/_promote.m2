R = QQ[a..d]; f = a^2;
S = R/(a^2-b-1);
promote(2/3,S)
F = map(R,QQ);  F(2/3)
promote(f,S)
G = map(S,R); G(f)
use R;
m = gens ideal(a^2,a^3,a^4)
G m
m ** S
ideal promote(m, S)
