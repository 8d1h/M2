S = ZZ/32003[a..d]
I = ideal random(S^1, S^{5:-8});
time trim I;
time gens gb I;
time R = S/I
time trim R; -- recomputing the GB FIX
time prune R; -- recomputes GB FIX
time flattenRing R; -- very fast

f = presentation R; -- this seems to come with the GB, that is good
keys f.cache
time gens gb f;

I1 = ideal R; -- this seems to come with the GB, that is good
time gens gb I1; 

J = ideal random(R^1, R^{3:-8});
time B = R/J;
time flattenRing B; -- doesn't seem quite so bad...  Why not? Still, it takes real time

time C = R[x,y]; -- quite ast, so this is possibly OK.
time flattenRing C; -- takes a while: FIX


end

excerpt from email: 3/3/09 to Dan from Mike

David and I are working on improving integral closure, hopefully to a point
where it is actually useful.

In the process, I have run into some inefficiencies in our code involving
quotient rings.  The main problem (I think!) is that we are forgetting groebner
basis information about our quotients. I'm not sure if this is for me or or you
to fix, but probably something that together we can do faster.

Here are some situations that cause problems now:

1. Suppose that B is already a quotient ring S/I, and that we make a new ring C
   = B/J.  Then: 'D = (flattenRing C)_0' seems to be recomputing a Groebner
   basis although the engine knows what it is (I think).  (In the example I
   have just been working on, this recomputation took 161 seconds!)

2. In the situation of (1), 'E = trim D' should just change the presenting
ideal, but the GB itself will not change.  Also, perhaps the engine object
should not change either.  This step cost 321 seconds!

3. Given a quotient ring R = S/I, I should be able to get the GB of I.  Can we
do that easily?

4. minimalPresentation E (this is code I wrote) in the above example took 322
seconds, probably recomputing the GB.

I'll look into these a bit more, but fixing this should improve ALOT of
computations involving towers of rings!


-- Other problems:

a.  minPressy should do almost NOTHING if it detects that nothing has changed.

b. trim QuotientRing: (in matrix2.m2.  Why there???!)

  presentation Ring:  should return a matrix with a GB.  Does it?
  trim Ideal:  if the ideal already has a GB, then trim should use the trim of that!
               then when quotient-ing by this ideal a GB doesnt have to be recomputed.
  R[x]:  if R is a quotient ring, check to make sure that a GB is not recomputed.
