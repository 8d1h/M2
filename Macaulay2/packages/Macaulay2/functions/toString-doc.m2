--- status: DRAFT
--- author(s): MES
--- notes: 

undocumented {
    (toString, FunctionApplication),
    (toString, SchurRing),
    (toString, Sequence),
    (toString, Array),
    (toString, Power),
    (toString, QQ),
    (toString, Subscript),
    (toString, SparseMonomialVectorExpression),
    (toString, Package),
    (toString, CC),
    (toString, Superscript),
    (toString, Expression),
    (toString, Resolution),
    (toString, MatrixExpression),
    (toString, RowExpression),
    (toString, PolynomialRing),
    (toString, Command),
    (toString, Table),
    (toString, Adjacent),
    (toString, Holder),
    (toString, QuotientRing),
    (toString, FilePosition),
    (toString, Matrix),
    (toString, GeneralOrderedMonoid),
    (toString, Minus),
    (toString, MutableMatrix),
    (toString, Vector),
    (toString, Equation),
    (toString, InfiniteNumber),
    (toString, IndeterminateNumber),
    (toString, Bag),
    (toString, Manipulator),
    (toString, Tally),
    (toString, Set),
    (toString, ScriptedFunctor),
    (toString, DocumentTag),
    (toString, Ideal),
    (toString, Sum),
    (toString, RingElement),
    (toString, RingMap),
    (toString, EngineRing),
    (toString, IndexedVariable),
    (toString, Product),
    (toString, Module),
    (toString, GaloisField),
    (toString, GroebnerBasis),
    (toString, Thing),
    (toString, HashTable),
    (toString, NonAssociativeProduct),
    (toString, MutableHashTable),
    (toString, Type),
    (toString, BasicList),
    (toString, MutableList),
    (toString, Option),
    (toString, Function),
    (toString, Symbol),
    (toString, BinaryOperation),
    (toString, Hypertext),
    (toString, FractionField),
    (toString, Net),
    (toString, String),
    (toString, SparseVectorExpression),
    (toString, Dictionary),
    (toString, hilbertFunctionRing)
    }

document { 
     Key => toString,
     Headline => "convert to a string",
     Usage => "toString x",
     Inputs => {
	  "x" => "any Macaulay 2 object"
	  },
     Outputs => {
	  String => {"a string representation of ", TT "x"}
	  },
     "Sometimes the string representation is just the name.
     See also ", TO "toExternalString", " which will try to convert ", TT "x", "
     to a string which can be read back into the program later.",
     EXAMPLE {
	  "toString {1,4,a,f,212312,2.123243242}"
	  },
     "If a ring has a global name, then toString returns this name.",
     EXAMPLE {
	  "R = QQ[x_1..x_5];",
	  "toString R",
	  "toExternalString R",
	  "toString(QQ[a])"
	  },
     "Matrices and ring elements are linearized",
     EXAMPLE {
	  "toString (x_1^3-3/4*x_5*x_3)",
	  "toString vars R",
	  "toExternalString vars R"
	  },
     SeeAlso => {toExternalString, value}
     }

