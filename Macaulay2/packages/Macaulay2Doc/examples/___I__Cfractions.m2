R = QQ[x,y,z]/ideal(x^6-z^6-y^2*z^4);
S = ICfractions R
integralClosure(R,Variable => a)
