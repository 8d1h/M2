
restart
R=ZZ/2[a1,a2,a3,a4,b1,b2,b3,b4,c1,c2,c3,c4,d1,d2,d3,d4,e1,e2,e3,e4,f1,f2,f3,f4,g1,g2,g3,g4,h1,h2,h3,h4,i1,i2,i3,i4,j1,j2,j3,j4,k1,k2,k3,k4,l1,l2,l3,l4,m1,m2,m3,m4,n1,n2,n3,n4,o1,o2,o3,o4,p1,p2,p3,p4, MonomialOrder=>Lex];
FP =  apply( gens R, i -> i*(i-1));
--FP are the field polynomials
RQ = R/ideal FP
I= ideal {a1+a2+a3+a4-1, b1+b2+b3+b4-1, c1+c2+c3+c4-1, d1+d2+d3+d4-1, e1+e2+e3+e4-1, f1+f2+f3+f4-1, g1+g2+g3+g4-1, h1+h2+h3+h4-1, i1+i2+i3+i4-1, j1+j2+j3+j4-1, k1+k2+k3+k4-1, l1+l2+l3+l4-1, m1+m2+m3+m4-1, n1+n2+n3+n4-1, o1+o2+o3+o4-1, p1+p2+p3+p4-1, a1*b1+a2*b2+a3*b3+a4*b4, a1*c1+a2*c2+a3*c3+a4*c4, a1*d1+a2*d2+a3*d3+a4*d4, a1*e1+a2*e2+a3*e3+a4*e4, a1*f1+a2*f2+a3*f3+a4*f4, a1*i1+a2*i2+a3*i3+a4*i4, a1*m1+a2*m2+a3*m3+a4*m4, b1*c1+b2*c2+b3*c3+b4*c4, b1*d1+b2*d2+b3*d3+b4*d4, b1*e1+b2*e2+b3*e3+b4*e4, b1*f1+b2*f2+b3*f3+b4*f4, b1*j1+b2*j2+b3*j3+b4*j4, b1*n1+b2*n2+b3*n3+b4*n4, c1*d1+c2*d2+c3*d3+c4*d4, c1*g1+c2*g2+c3*g3+c4*g4, c1*h1+c2*h2+c3*h3+c4*h4, c1*k1+c2*k2+c3*k3+c4*k4, c1*o1+c2*o2+c3*o3+c4*o4, d1*g1+d2*g2+d3*g3+d4*g4, d1*h1+d2*h2+d3*h3+d4*h4, d1*l1+d2*l2+d3*l3+d4*l4, d1*p1+d2*p2+d3*p3+d4*p4, e1*f1+e2*f2+e3*f3+e4*f4, e1*g1+e2*g2+e3*g3+e4*g4, e1*h1+e2*h2+e3*h3+e4*h4, e1*i1+e2*i2+e3*i3+e4*i4, e1*m1+e2*m2+e3*m3+e4*m4, f1*g1+f2*g2+f3*g3+f4*g4, f1*h1+f2*h2+f3*h3+f4*h4, f1*j1+f2*j2+f3*j3+f4*j4, f1*n1+f2*n2+f3*n3+f4*n4, g1*h1+g2*h2+g3*h3+g4*h4, g1*k1+g2*k2+g3*k3+g4*k4, g1*o1+g2*o2+g3*o3+g4*o4, h1*l1+h2*l2+h3*l3+h4*l4, h1*p1+h2*p2+h3*p3+h4*p4, i1*j1+i2*j2+i3*j3+i4*j4, i1*k1+i2*k2+i3*k3+i4*k4, i1*l1+i2*l2+i3*l3+i4*l4, i1*m1+i2*m2+i3*m3+i4*m4, i1*n1+i2*n2+i3*n3+i4*n4, j1*k1+j2*k2+j3*k3+j4*k4, j1*l1+j2*l2+j3*l3+j4*l4, j1*m1+j2*m2+j3*m3+j4*m4, j1*n1+j2*n2+j3*n3+j4*n4, k1*l1+k2*l2+k3*l3+k4*l4, k1*o1+k2*o2+k3*o3+k4*o4, k1*p1+k2*p2+k3*p3+k4*p4, l1*o1+l2*o2+l3*o3+l4*o4, l1*p1+l2*p2+l3*p3+l4*p4, m1*n1+m2*n2+m3*n3+m4*n4, m1*o1+m2*o2+m3*o3+m4*o4, m1*p1+m2*p2+m3*p3+m4*p4, n1*o1+n2*o2+n3*o3+n4*o4, n1*p1+n2*p2+n3*p3+n4*p4, o1*p1+o2*p2+o3*p3+o4*p4}
--K1 is the set of Shidoku Polynomials (not quite right for Shidoku, but gives the right answer most of the time! I still need to modify it for ZZ/2 computations.)
K2 = ideal {d1, d2, d3, d4-1, e1, e2, e3, e4-1, g1, g2-1, g3, g4, j1, j2, j3-1, j4, l1-1, l2, l3, l4, m1-1, m2, m3, m4}
--K2 = ideal {d1, d2-1, d3, d4, e1, e2, e3, e4-1, j1, j2, j3-1, j4, m1-1, m2, m3, m4}
--K2 is the set of initial clues.  This should be a fast computation
time gens gb (K1+K2) -- used 0.024064 seconds
time gens gb (K1) -- used seconds
time C = gens gb I;
time B = gbBoolean I;
assert( gens B - C == 0 )
