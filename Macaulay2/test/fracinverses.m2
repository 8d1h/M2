if getenv "USER" == "dan" then exit 0

R = ZZ[t,u,Inverses => true]

-- the following fractions are in the fraction field of R

(1 - t^4) / (1 - t^2)
(1 + t^4) / (1 - t^2)
(1 - t^-4) / (1 - t^-2)
(1 + t^-4) / (1 - t^-2)
(1 - t^-4 * u^-4) / (1 - t^-2 * u^-2)
(1 + t + t^-4 * u^-4) / (1 - t^-2 * u^-2)

-- those all worked, so why not the next one?

(t^11*u^9+3*t^10*u^8+3*t^9*u^7+t^8*u^6+t^8*u+5*t^7*u+3*t^7+9*t^6*u+7*t^6-2*t^6*u^(-1)+11*t^5-10*t^5*u^(-1)-6*t^5*u^(-2)-18*t^4*u^(-1)-23*t^4*u^(-2)+t^4*u^(-3)-22*t^3*u^(-2)-6*t^3*u^(-3)+3*t^3*u^(-4)+9*t^2*u^(-3)-5*t^3*u^(-5)+25*t^2*u^(-4)+11*t*u^(-4)-7*t^2*u^(-6)+22*t*u^(-5)-t^2*u^(-8)+10*t*u^(-7)-9*u^(-6)-3*t*u^(-9)+14*u^(-8)-11*t^(-1)*u^(-7)+2*u^(-10)-5*t^(-1)*u^(-9)+6*t^(-1)*u^(-11)-7*t^(-2)*u^(-10)-t^(-2)*u^(-12)-3*t^(-3)*u^(-13)) / (1-t^(-2)*u^(-2))

-- the results are different over QQ - we get a segmentation fault early

R = QQ[t,u,Inverses => true]

-- the following fractions are in the fraction field of R

(1 - t^4) / (1 - t^2)
(1 + t^4) / (1 - t^2)
(1 - t^-4) / (1 - t^-2)
(1 + t^-4) / (1 - t^-2)
(1 - t^-4 * u^-4) / (1 - t^-2 * u^-2)
(1 + t + t^-4 * u^-4) / (1 - t^-2 * u^-2)

-- those all worked, so why not the next one?

(t^11*u^9+3*t^10*u^8+3*t^9*u^7+t^8*u^6+t^8*u+5*t^7*u+3*t^7+9*t^6*u+7*t^6-2*t^6*u^(-1)+11*t^5-10*t^5*u^(-1)-6*t^5*u^(-2)-18*t^4*u^(-1)-23*t^4*u^(-2)+t^4*u^(-3)-22*t^3*u^(-2)-6*t^3*u^(-3)+3*t^3*u^(-4)+9*t^2*u^(-3)-5*t^3*u^(-5)+25*t^2*u^(-4)+11*t*u^(-4)-7*t^2*u^(-6)+22*t*u^(-5)-t^2*u^(-8)+10*t*u^(-7)-9*u^(-6)-3*t*u^(-9)+14*u^(-8)-11*t^(-1)*u^(-7)+2*u^(-10)-5*t^(-1)*u^(-9)+6*t^(-1)*u^(-11)-7*t^(-2)*u^(-10)-t^(-2)*u^(-12)-3*t^(-3)*u^(-13)) / (1-t^(-2)*u^(-2))
