--		Copyright 1994 by Daniel R. Grayson

subsets(ZZ,ZZ) := (n,j) -> (
     subsetn := (n,j) -> (
	  if n<j then {}
	  else if n===j then {toList (0 .. n-1)}
	  else if j===0 then {{}}
	  else join(subsetn(n-1,j), apply(subsetn(n-1,j-1),s->append(s,n-1))));
     subsetn = memoize subsetn;
     result := subsetn(n,j);
     subsetn = null;
     result)

subsets(List,ZZ) := (s,j) -> apply(subsets(#s,j),v->apply(v,i->s#i))
subsets(Sequence,ZZ) := (s,j) -> subsets(toList s,j)
subsets(Set,ZZ) := (s,j) -> apply(subsets(toList s, j), set)

subsets Set := x -> set subsets toList x
subsets List := x -> (
     if #x === 0 then {x}
     else (
	  a := x#-1;
	  x = drop(x,-1);
	  s := subsets x;
	  join(s,apply(s,y->append(y,a)))))

partitions(ZZ,ZZ) := memoize (
     (n,k) -> (
     	  if k > n then k=n;
     	  if n <= 0 then {{}} 
     	  else if k === 0 then {} 
     	  else if k === 1 then {apply(n,i->1)} 
     	  else join( 
	       apply(partitions(n-k,k),i -> prepend(k,i)), 
	       partitions(n,k-1))))

partitions ZZ := (n) -> partitions(n,n)
