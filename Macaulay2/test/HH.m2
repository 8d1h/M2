stderr << currentFileName << ": test deferred" << endl
exit 0

-- errorDepth 0
R = QQ[x]
f = map(R^1,R^1)
assert(
     try (
     	  HH_f(f); -- we need to make this not work, eventually (low priority)
     	  false					    -- we got no error message, sigh
	  )
     else true
     )

-- Local Variables:
-- compile-command: "make HH.okay"
-- End:
