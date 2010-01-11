-------------------
-- Package Header
-------------------
needsPackage "Depth";
needsPackage "SimplicialComplexes";
newPackage (
    "SimplicialDecomposability",
    Version => "0.2",
    Date => "xx. January 2010",
    Authors => {{Name => "David W. Cook II", Email => "dcook@ms.uky.edu", HomePage => "http://www.ms.uky.edu/~dcook"}},
    Headline => "Pure k-Decomposability for simplicial complexes.",
    DebuggingMode => true
);
needsPackage "Depth";
needsPackage "SimplicialComplexes";

-------------------
-- Exports
-------------------
export {
    faceDelete,
    iskDecomposable,
    isShellable,
    isShelling,
    isSimplex,
    isVertexDecomposable,
    hVector,
    shellingOrder
};

-------------------
-- Exported Code
-------------------

-- Face Deletion: Remove all faces of a complex containing the given face.
faceDelete = method(TypicalValue => SimplicialComplex);
faceDelete (SimplicialComplex, RingElement) := (S,F) -> (
    simplicialComplex monomialIdeal (ideal S + ideal(F))
);

-- Determines if a pure simplicial complex is k-decomposable.
iskDecomposable = method(TypicalValue => Boolean);
iskDecomposable (SimplicialComplex, ZZ) := (S, k) -> (
    -- any of {non-pure, negatives in hVector} imply not pure k-decomposable
    if not isPure S then return false;
    if any(hVector S, i -> i<0) then return false;

    -- if S is k-decomposable, then S is k+1-decomposable 
    -- S is (dim S)-decomposable if and only if S is shellable (see thm 2.8 is Provan-Billera)
    -- if dim S <= k then return isShellable S;

    -- base case: simplexes are k-decomposable for all nonnegative k
    if isSimplex S then return true;

    -- Find all possible relevant faces:
    L := flatten for i from 0 to k list flatten entries faces(i, S);
    -- Check for happiness.
    for F in L do if iskDecomposable(link(S, F), k) and iskDecomposable(faceDelete(S, F), k) then return true;
    false
);

-- Determines if a pure simplicial complex is shellable.
isShellable = method(TypicalValue => Boolean);
isShellable (SimplicialComplex) := (S) -> (
    shellingOrder(S) != {}
);

-- Determines if a list of equidimensional faces is a shelling.
isShelling = method(TypicalValue => Boolean);
isShelling (List) := (L) -> (
    -- Check for (i) equidimensional, (ii) monomials, (iii) squarefree, and (iv) monic
    if #unique apply(L, degree) > 1 then return false;
    if any(apply(L, size), i->i!=1) then return false;
    if max flatten flatten apply(L, exponents) > 1 then return false;
    if any(flatten flatten apply(L, i->entries (coefficients i)_1), i->i!=1) then return false;
    
    -- Sets with zero or one face are always shellings 
    if #L <= 1 then return true;

    -- prime the loop
    s0 := f0 := ta := null;
    s1 := simplicialComplex take(L, 1);
    di := dim s1;
    f1 := flatten for i from 0 to di list flatten entries faces(i, s1);
    -- for each face in the list
    for i from 2 to #L do (
        -- copy the last step
        s0 = s1;
        f0 = f1;
        -- update the newest
        s1 = simplicialComplex take(L, i);
        f1 = flatten for i from 0 to di list flatten entries faces(i, s1);
        -- find the added faces & count their dimensions (+1)
        ta = tally flatten apply(toList(set f1 - set f0), degree);
        -- make sure the minimal face is unique
        if ta_(min keys ta) != 1 then return false;
    );
    true
);

-- Determines if a simplicial complex is (isomorphic to) a simplex.
isSimplex = method(TypicalValue => Boolean);
isSimplex (SimplicialComplex) := (S) -> (
    #flatten entries facets S <= 1
);

-- Determines if a simplicial complex is (pure) vertex decomposable.
isVertexDecomposable = method(TypicalValue => Boolean);
isVertexDecomposable (SimplicialComplex) := (S) -> (
    iskDecomposable(S, 0)
);

-- Determines the hVector of the Stanley-Reisner ideal of a simplicial complex.
hVector = method(TypicalValue => List);
hVector (SimplicialComplex) := (S) -> (
    flatten entries sub(last coefficients numerator reduceHilbert hilbertSeries ideal S, ZZ)
);

-- Attempts to find a shelling order of a pure simplicial complex.
shellingOrder = method(TypicalValue => List);
shellingOrder (SimplicialComplex) := (S) -> (
    -- any of {non-pure, non-CM, negatives in hVector} imply not pure shellable
    if not isPure S then return {};
    --if not isCM quotient ideal S then return {};  -- good idea, but this is REALLY slow
    if any(hVector S, i -> i<0) then return {};

    -- ULTRA NAIVE: simply look at all facet permutations
    P := permutations first entries facets S;
    o := {};
    for L in P do if isShelling L then ( o = L; break; );
    o
);

-------------------
-- Local-Only Code
-------------------

-------------------
-- Documentation
-------------------
beginDocumentation()
doc ///
    Key
        SimplicialDecomposability
    Headline
        Pure k-Decomposability for simplicial complexes.
    Description
        Text
            Determines pure k-Decomposability (including shellability) for simplicial complexes.
///

doc ///
    Key
        faceDelete
        (faceDelete, SimplicialComplex, RingElement)
    Headline
        computes the face deletion for a simplicial complex
    Usage
        faceDelete(S, F)
    Inputs
        S:SimplicialComplex
        F:RingElement
            a face of {\tt S}
    Outputs
        T:SimplicialComplex
            the simplicial complex of all faces in {\tt S} not containing the face {\tt F}
    Description
        Text
            T = {G in S such that F is not contained in G}
        Example
            R = QQ[a,b,c,d,e];
            S = simplicialComplex {a*b*c*d*e};
            faceDelete(S, a)
            faceDelete(S, a*b*c)
            faceDelete(S, a*b*c*d*e) == boundary S
    SeeAlso
        link
///

doc ///
    Key
        iskDecomposable
        (iskDecomposable, SimplicialComplex, ZZ)
    Headline
        determines if a simplicial complex is (pure) k-decomposable or not
    Usage
        iskDecomposable(S,k)
    Inputs
        S:SimplicialComplex
        k:ZZ
    Outputs
        B:Boolean
            true if and only if {\tt S} is (pure) k-decomposable
    Description
        Text
            This function uses the recursive definition that a simplicial complex is k-decomoosable
            if either it is a simplex or there is a face of dimension at most k such that the face deletion
            and link of the face (from the simplicial complex) are also k-decomposable.

            See section two of J. S. Provan and L. J. Billera, "Decompositions of Simplicial Complexes Related to Diameters of Convex Polyhedra,"
            Mathematics of Operations Research, Vol. 5, No. 4 (Nov., 1980), pp. 576-594.
        Example
            R = QQ[a,b,c,d,e];
            iskDecomposable(simplicialComplex {a*b*c*d*e}, 0)
            iskDecomposable(simplicialComplex {a*b*c,c*d*e,c*d*e}, 2)
    SeeAlso
        isShellable
        isVertexDecomposable
///

doc ///
    Key
        isShellable
        (isShellable, SimplicialComplex)
    Headline
        determines if a simplicial complex is (pure) shellable or not
    Usage
        isShellable S
    Inputs
        S:SimplicialComplex
    Outputs
        B:Boolean
            true if and only if {\tt S} is (pure) shellable
    Description
        Text
            This function simply checks if a (pure) shelling order exists.
        Example
            R = QQ[a,b,c,d,e];
            isShellable simplicialComplex {a*b*c*d*e}
            isShellable simplicialComplex {a*b*c,c*d*e}
            isShellable simplicialComplex {a*b*c,b*c*d,c*d*e}
    SeeAlso
        iskDecomposable
        isShelling
        isVertexDecomposable
        shellingOrder
///

doc ///
    Key
        isShelling
        (isShelling, List)
    Headline
        determines if a list of equidimensional faces is a shelling
    Usage
        isShelling L
    Inputs
        L:List
            a list of equidimensional faces (i.e., squarefree monic monomials)
    Outputs
        B:Boolean
            true if and only if {\tt L} is (pure) shelling
    Description
        Text
            Determines if a list of equidimensional faces is a shelling of the simplicial complex generated by the faces.
        Example
            R = QQ[a,b,c,d,e];
            isShelling {a*b*c, c*d*e}
            isShelling {a*b*c, b*c*d, c*d*e}
    SeeAlso
        isShellable
        shellingOrder
///

doc ///
    Key
        isSimplex
        (isSimplex, SimplicialComplex)
    Headline
        determines if a simplicial complex is simplex
    Usage
        isSimplex S
    Inputs
        S:SimplicialComplex
    Outputs
        B:Boolean
            true if and only if {\tt S} is simplex
    Description
        Example
            R = QQ[a,b,c,d];
            isSimplex simplicialComplex {a*b*c*d}
            isSimplex simplicialComplex {a*b}
            isSimplex simplicialComplex {a*b,c*d}
///

doc ///
    Key
        isVertexDecomposable
        (isVertexDecomposable, SimplicialComplex)
    Headline
        determines if a simplicial complex is (pure) vertex-decomposable or not
    Usage
        isVertexDecomposable S
    Inputs
        S:SimplicialComplex
    Outputs
        B:Boolean
            true if and only if {\tt S} is (pure) vertex-decomposable
    Description
        Text
            Vertex-decomposability is just 0-decomposability.
        Example
            R = QQ[a,b,c,d,e];
            isVertexDecomposable simplicialComplex {a*b*c*d*e}
            isVertexDecomposable boundary simplicialComplex {a*b*c*d*e}
            isVertexDecomposable simplicialComplex {a*b*c,c*d*e,c*d*e}
    SeeAlso
        isShellable
        iskDecomposable
///

doc ///
    Key
        hVector
        (hVector, SimplicialComplex)
    Headline
        determines the h-Vector of a simplicial complex
    Usage
        hVector S
    Inputs
        S:SimplicialComplex
    Outputs
        h:List
            the h-Vector of {\tt S}
    Description
        Example
            R = QQ[a,b,c,d];
            hVector simplicialComplex {a*b*c,d}
    SeeAlso
        fVector
///

doc ///
    Key
        shellingOrder
        (shellingOrder, SimplicialComplex)
    Headline
        finds a shelling of a pure simplicial complex, if one exists
    Usage
        L = shellingOrder S
    Inputs
        S:SimplicialComplex
    Outputs
        L:List
            a (pure) shelling order of the facets of {\tt S}, if one exists
    Description
        Text
            Currently this routine employs the incredibly naive approach of checking all permutations of the facets.
        Example
            R = QQ[a,b,c,d,e];
            shellingOrder simplicialComplex {a*b*c*d*e}
            shellingOrder simplicialComplex {a*b*c, b*c*d, c*d*e}
            shellingOrder simplicialComplex {a*b*c, c*d*e}
    SeeAlso
        isShellable
        isShelling
///

-------------------
-- Tests
-------------------

-- Tests of isSimplex
TEST ///
R = QQ[a..d];
assert(isSimplex simplicialComplex {a*b*c*d});
assert(isSimplex simplicialComplex {a*b*c});
assert(isSimplex simplicialComplex {a*b});
assert(isSimplex simplicialComplex {a});
assert(isSimplex simplicialComplex monomialIdeal {a,b,c,d}); -- empty complex
assert(not isSimplex simplicialComplex {a*b, b*c, c*d});
assert(not isSimplex simplicialComplex {a*b, b*c*d});
assert(not isSimplex simplicialComplex {a*b, c});
assert(not isSimplex simplicialComplex {a, b, c, d});
///

-- Tests of isShelling
TEST ///
R = QQ[a..f];
assert(isShelling {a*b*c});
assert(isShelling {a*b*c, b*c*d});
assert(isShelling {a*b*c, b*c*d, c*d*e});
assert(isShelling {a*b*c, b*c*d, c*d*e, d*e*f});
assert(not isShelling {a*b*c, c*d*e});
assert(not isShelling {a*b*c, d*e*f});
///

-- Tests of isShellable (and hence shellingOrder by invocation)
-- NB: shellingOrder can only be tested this way as a shelling order need not be unique.
TEST ///
R = QQ[a..e];
assert(isShellable simplicialComplex {a*b*c});
assert(isShellable simplicialComplex {a*b*c, b*c*d});
assert(isShellable simplicialComplex {a*b*c, b*c*d, c*d*e});
assert(isShellable simplicialComplex monomialIdeal {a,b,c,d,e}); -- empty complex
assert(not isShellable simplicialComplex {a*b*c, c*d*e});
assert(not isShellable simplicialComplex {a*b*c, b*c*d, e});
///

-- Tests of hVector
TEST ///
R = QQ[a..e];
assert(hVector simplicialComplex {a, b, c, d, e} === {1,4});
assert(hVector simplicialComplex {a*b*c*d*e} === {1});
assert(hVector simplicialComplex {a*b*c, b*c*d, c*d*e} === {1,2});
assert(hVector simplicialComplex {a*b, b*c, c*d, d*e, b*d} === {1,3,1});
assert(hVector simplicialComplex {a*b*c, c*d*e} === {1, 2, -1});
assert(hVector simplicialComplex {a, b*c, d*e} === {1, 3, -2});
///

-- Tests of faceDelete
TEST ///
R = QQ[a..e];
S = simplicialComplex {a*b*c*d*e};
assert(faceDelete(S, a) == simplicialComplex {b*c*d*e});
assert(faceDelete(S, a*b*c) == simplicialComplex {b*c*d*e, a*c*d*e, a*b*d*e});
assert(faceDelete(S, a*b*c*d*e) == boundary S)
///

-- Tests of iskDecomposable (and hence isVertexDecomposable)
TEST ///
R = QQ[a..e];
S = simplicialComplex {a*b*c*d*e};
assert(iskDecomposable(S, 0));
assert(iskDecomposable(S, 1));
assert(iskDecomposable(S, 2));
assert(iskDecomposable(S, 3));
assert(iskDecomposable(S, 4));
assert(iskDecomposable(boundary S, 0)); -- prop 2.2 in Provan-Billera
assert(iskDecomposable(simplicialComplex {a*b*c, b*c*d, c*d*e}, 2));
assert(not iskDecomposable(simplicialComplex {a*b*c, c*d*e}, 2));
///

-- Tests iskDecomposable (a second way)
-- See Example V6F10-{1,6,7} in S. Moriyama and F. Takeuchi, "Incremental construction properties in dimension two:
-- shellability, extendable shellability and vertex decomposability," Volume 263, Issue 1-3 (February 2003), 295-296.
TEST ///
R = QQ[a..f];
S1 = simplicialComplex {a*b*c, a*b*d, a*b*f, a*c*d, a*c*e, b*d*e, b*e*f, c*d*f, c*e*f, d*e*f};
S6 = simplicialComplex {a*b*c, a*b*d, a*b*e, a*c*d, a*c*f, b*d*e, b*e*f, c*d*f, c*e*f, d*e*f};
S7 = simplicialComplex {a*b*c, a*b*e, a*b*f, a*c*d, a*d*e, b*c*d, b*e*f, c*d*f, c*e*f, d*e*f};
assert(not isVertexDecomposable(S1));
assert(iskDecomposable(S1, 1));
assert(not isVertexDecomposable(S6));
assert(iskDecomposable(S6, 1));
assert(not isVertexDecomposable(S7));
assert(iskDecomposable(S7, 1));
///

end
-- Happy Happy Joy Joy!
