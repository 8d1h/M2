--		Copyright 1995 by Daniel R. Grayson and Michael Stillman

getIndex := (R,x) -> (
     M := try monoid R else error "expected a polynomial ring or quotient of one";
     if class x =!= R then error "expected an element of the ring";
     x = try baseName x else error "expected a variable of the ring";
     M.index#x)

genericMatrix = (R,first,nrows,ncols) -> (
     first = getIndex(R,first);
     if not instance(nrows,ZZ) or not instance(ncols,ZZ) or nrows < 0 or ncols < 0
     then error "expected nonnegative integers";
     if first + nrows * ncols > numgens R
     then error "not enough variables in this ring";
     matrix table(nrows, ncols, (i,j)->R_(first + i + nrows*j)))

genericSkewMatrix = (R,first,n) -> (
     first = getIndex(R,first);
     vars := new MutableHashTable;
     nextvar := first;
     scan(0..n-1, 
	  i -> scan(i+1..n-1, 
	       j -> (vars#(i,j) = R_nextvar; nextvar = nextvar+1)));
     matrix table(n,n,(i,j) -> 
	  if i>j then - vars#(j,i) 
	  else if i<j then vars#(i,j)
	  else 0_R))

genericSymmetricMatrix = (R,first,n) -> (
     first = getIndex(R,first);
     vars := new MutableHashTable;
     nextvar := first;
     scan(0..n-1, i -> scan(i..n-1, j -> (
		    vars#(i,j) = R_nextvar; 
		    nextvar = nextvar+1)));
     matrix table(n,n, (i,j) -> if i>j then vars#(j,i) else vars#(i,j)))

randommat := (R,r,c) -> (
     if R.?Adjust then c = R.Adjust c;
     sendgg(ggPush R, ggPush r, ggPush c, ggrandom); 
     getMatrix R)

random(List,Ring) := RingElement => (deg,R) -> (
     if #deg =!= degreeLength R
     then error ("expected length of degree vector to be ", degreeLength R);
     if deg === {} then random R
     else (
	  m := basis(deg, R);
	  --p := char R;
	  n := randommat(R,numgens source m,1);
	  --n := matrix table(numgens source m,1, x -> promote(random p,R));
	  (m*n)_(0,0)))

random(ZZ,Ring) := RingElement => (n,R) -> random({n},R)

random(Module, Module) := Matrix => (F,G) -> (
     R := ring F;
     p := char R;
     if p === 0 then p = ZZ;
     if R =!= ring G then error "modules over different rings";
     degreesTable := table(degrees F, degrees G, 
	  (i,j) -> toList apply(j,i,difference));
     degreesTally := tally flatten degreesTable;
     if #degreesTally === 0 then map(F,G,0)
     else if #degreesTally === 1 then (
	  deg := first keys degreesTally;
	  if all(deg,i->i===0) 
	  then (randmat := randommat(R,numgens F, numgens G);
	        map(F,G,randmat))
	       --map(F,G,table(numgens F, numgens G, x -> random p))
	  else (
	       m := basis(deg,R);
	       s := degreesTally#deg;
	       reshape(F,G, 
		    m * randommat(R, numgens source m, s))))
--		    m * map(source m, R^s, 
--			 table(numgens source m, s, x -> random p)))))
     else (
	  randomElement := memoize(
	       deg -> (
		    numused := 0;
		    if deg === 0 then (
			 n := apply(degreesTally#deg, x -> random p);
			 () -> (
			      r := n#numused;
			      numused = numused + 1;
			      r))
		    else (
			 m := basis(deg,R);
			 k := numgens source m;
			 if k === 0
			 then () -> 0_R
			 else (
			      n = first entries (
				   m * matrix (R, table(
					     k, degreesTally#deg, 
					     (i,j)->random p)));
			      () -> (
				   r := n#numused;
				   numused = numused + 1;
				   r)))));
	  map(F, G, applyTable(degreesTable, k -> (randomElement k)()))))

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/m2 "
-- End:
