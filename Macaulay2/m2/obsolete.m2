--		Copyright 1997-2002 by Daniel R. Grayson

-- old internal engine routines:
scan({sendgg,ggPush,ConvertJoin,ConvertRepeat,ConvertApply,newHandle},
     s -> s <- X -> error ("'", s, "' has been removed"))

unlist = X -> error "'unlist' has been replaced by toSequence"
elements = X -> error "'elements' has been replace by toList"
evaluate = X -> error "'evaluate' has been replaced by 'value'"
seq = X -> error "'seq' has been replaced by 'singleton'"
verticalJoin = X -> error "'verticalJoin' has been replaced by 'stack'"
netRows = X -> error "netRows' has been replaced by unstack'"
-- name = X -> error "'name' has been replaced by 'toString'"
quote = X -> error "'quote' has been replaced by 'symbol'"
Numeric = X -> error "'Numeric' has been replaced by 'numeric'"
submodule = X -> error "'submodule' has been removed"
stats = X -> error "'stats' has been replaced by 'summary'"
monomialCurve = X -> error "'monomialCurve' has been replaced by 'monomialCurveIdeal'"
assign = X -> error "assign' has been replaced by <-'"

undocumented(map,Module)
map(Module) := Matrix => options -> (M) -> error "method for 'map(Module)' has been removed: use 'map(M,M,1)' instead"
undocumented(map,Ideal)
map(Ideal) := Matrix => options -> (I) -> error "method for 'map(Ideal)' has been removed: use 'map(module I,module I, 1)' instead"
undocumented(map,Ideal,Ideal)
map(Ideal,Ideal) := Matrix => options -> (I,J) -> error "method for 'map(Ideal,Ideal)' has been removed: use 'map(module I,module J)' instead"
undocumented(Module,Matrix)
map(Module,Matrix) := options -> (M,f) -> error "method for 'map(Module,Matrix)' has been replaced: use 'map(M,,f)' instead";
undocumented(Module,ZZ)
map(Module,ZZ) := map(Module,RingElement) := options -> (M,r) -> error "method for 'map(Module,RingElement)' has been removed: use 'map(M,M,r)' instead"

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/m2 "
-- End:
