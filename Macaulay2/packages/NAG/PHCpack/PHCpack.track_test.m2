restart
loadPackage ("NAG", FileName=>"../../NAG.m2", 
     Configuration=>{"PHCpack"=>"../phc"})
debug NAG; DBG = 2; printingPrecision = 20; 
removeFile "PHCstart"; removeFile "PHCtarget"; removeFile "PHCoutput"; 
removeFile "PHCstartsols"; removeFile "PHCtargetsols"; removeFile "PHCbat"; 

R = CC[x,y];
S = {x*(x-1)*y,x*(x-1),(x-y)*(x+y+1)};
solsS = {{0,0},{1,1},{1,-1},{2,-2}}
T = {x*(x-1)*y,x*(x-1),y-(x+1)^2};
track(S,T,solsS, gamma=>0.6+0.8*ii,Software=>PHCpack)

 