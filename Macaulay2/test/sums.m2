errorDepth = 0
V = QQ^2
W = QQ^3
M = V++W
N = (a=>V) ++ (b=>W)
O = (b=>V) ++ (a=>W)
assert( rank M_[0] == 2 )
assert( rank M_[1] == 3 )
assert( rank N_[a] == 2 )
assert( rank N_[b] == 3 )
assert( rank O_[a] == 3 )
assert( rank O_[b] == 2 )
-- Local Variables:
-- compile-command: "make sums.okay"
-- End:
