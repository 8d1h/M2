--		Copyright 1994 by Daniel R. Grayson

document { quote length,
     TT "length C", " -- returns the length of a graded module or a chain
     complex.",
     PARA,
     MENU {
	  TO (length,ChainComplex)
	  }
     }

document { quote sendgg,
     TT "sendgg s", " -- uses ", TO "sendToEngine", " to send the  string ", TT "s", " 
     of data and commands to the engine.  The first byte of the result is examined 
     for an error indication, and then an error is raised or the remainder of the 
     string is returned.",
     PARA,
     SEEALSO "engine communication protocol"
     }

document { quote parent,
     TT "parent X", " -- yields the parent P of X.",
     PARA,
     "Methods for the ", TO {"instance", "s"}, " of X which are not found
     in X itself are sought in P, and its parent, and so on.",
     PARA,
     "The mathematical notion of a set z and a subset y can modeled
     in this way, with z being the parent of y.",
     PARA,
     "Things which don't have instances have the empty class, called
     ", TO "Nothing", " as their parent.",
     PARA,
     "The of Thing is Thing itself (reflecting the fact that there can
     be no larger class).",
     SEEALSO "classes"
     }

document { quote Array,
     TT "Array", " -- the class of all arrays.",
     PARA,
     "See ", TO "lists, arrays, and sequences", "."
     }

document { quote Sequence,
     TT "Sequence", " -- the class of sequences.",
     PARA,
     "A sequence is distinguished from a list by its surrounding
     parentheses.",
     PARA,
     SEEALSO "lists, arrays, and sequences"
     }

document { quote List,
     TT "List", " -- the class of all lists.",
     PARA,
     "Some operations on lists.",
     MENU {
	  TO (quote +,List,List)
	  },
     SEEALSO "lists, arrays, and sequences"
     }

document { quote Type,
     TT "Type", " -- the class of all types.",
     PARA, 
     "A type is a hash table intended to contain methods for 
     its instances.",
     PARA,
     SEEALSO {"parent",  "class", "using methods"}
     }

document { "enclosed",
     TT "enclosed", " -- a term used in the documentation to describe an expression
     whose hash code distinguishes it from all other enclosed
     expressions.  Enclosed expressions include Objects or Lists 
     which are mutable, and Symbols.  Unenclosed expressions
     have hash codes which are computed from the contents of the
     expression, so it may happen that the hash codes are the same
     when the contents are different, or the contents are the same
     and the expressions are different.",
     PARA,
     SEEALSO "hashing"
     }

document { quote Print,
     TT "Print", " -- a method applied at top level to print the result, 
     ", TT "r", " of an evaluation.",
     PARA,
     "The code for the default Print method will apply the ", TO "AfterEval", "
     method to ", TT "r", " if there one, and replace ", TT "r", " by the result.  
     Then it applies ", TO "BeforePrint", " method, if there is one,
     to ", TT "r", ", and prints its result instead.  The actual printing
     will be done with ", TO "<<", ".  It will then apply the appropriate
     ", TO "AfterPrint", " method to ", TT "r", ", which is normally used to 
     provide auxiliary information to the user about the result.",
     SEEALSO "NoPrint"
     }

document { quote NoPrint,
     TT "NoPrint", " -- a method applied at top level to a result suppression of
     whose printing has been indicated by a semicolon.",
     PARA,
     "The code for the default NoPrint method will apply the ", TO "AfterEval", "
     method to ", TT "r", " if there one, and replace ", TT "r", " by the result.  
     It will then apply the appropriate ", TO "AfterNoPrint", " method to
     ", TT "r", ", which is normally used to provide auxiliary information to 
     the user about the result.",
     SEEALSO "Print"
     }

document { quote BeforePrint,
     TT "BeforePrint", " -- a method applied at top level to the result of an evaluation,
     whose result supplants the original for printing.",
     SEEALSO "Print"
     }

document { quote AfterEval,
     TT "AfterEval", " -- a method applied at top level to the result of an evaluatino,
     whose result replaces the original for storing in the output variable and for
     printing.",
     SEEALSO "Print"
     }

document { quote AfterPrint,
     TT "AfterPrint", " -- a method applied at top level to the result of an evalution
     after printing.",
     SEEALSO "Print"
     }

document { quote AfterNoPrint,
     TT "AfterNoPrint", " -- a method applied at top level to the result of an 
     evalution when printing of the result has been suppressed by a semicolon.",
     SEEALSO "Print"
     }

document { quote name,
     TT "name x", " -- convert x to a string",
     PARA,
     "It converts an expression x to a string which contains a visible
     representation of x, unless x is already a string, in which case it
     escapes the control characters within the string and encloses it in
     quotation marks.  The value of ", TT "name x", " is used when printing
     out ", TT "x", ".  If ", TT "x", " is an hash table and ", TT "x.name",
     " has a value, this value is returned.  But if the value of ", TT
     "x.name", " is a string or net, then it is returned.  If x.name has no
     value and (class x)#name has a value, it is assumed to be a function and
     is applied to x in order to produce the name. Otherwise, the name
     provided is a suitable visible representation of the expression.",
     PARA,
     NOINDENT,
     TT "x.name = \"x\"", " -- sets the name of ", TT "x", " to ", TT "\"x\"", ".",
     PARA,
     SEEALSO{ "describe"}
     }

document { quote setrecursionlimit,
     TT "setrecursionlimit n", " -- sets the recursion limit to n.",
     PARA,
     " It returns the old value.  The recursion limit governs the nesting level
     permissible for calls to functions."
     }

document { quote commandLine,
     TT "commandLine", " -- a constant whose value is the list of arguments 
     passed to the interpreter, including argument 0, the name of the program.",
     }

document { quote environment,
     TT "environment", " -- a constant whose value is the list containing the
     environment strings for the process."
     }

document { quote Function,
     TT "Function", " -- the class of all functions.",
     PARA,
     SEEALSO "functions"
     }

document { quote "->",
     TT "x -> e    ", " -- denotes a function.  When the function is called, the initial 
     	      value of the variable x is the argument if there is just one, or
	      else is the sequence of arguments.",
     PARA,
     "(x) -> e   -- denotes a function of one argument.  When the function is 
     applied to an expression w three things may happen:",
     UL {
     	  "if w is not a sequence, then the initial value of x is w;",
     	  "if w is a sequence of length one, then the initial value
     	  of x is the unique element of w; or",
     	  "if w is a sequence of length other than one, then it
     	  is an error."
	  },
     "(x,y) -> e -- denotes a function of two arguments.",
     PARA,
     "Similarly for more arguments.",
     PARA,
     "These operations create what is usually called a ", ITALIC "closure", ",
     which signifies that the function remembers the values of local
     variables in effect at the time of its creation, can change
     those values, and share the changes with other functions created
     at the same time.",
     PARA,
     EXAMPLE "f = x -> 2*x+1",
     PARA,
     "The class of all functions is ", TO "Function", "."
     }

document { quote path,
     TT "path", " -- a list of strings containing names of directories in which\n", 
     TO "load", " and ", TO "input", " should seek files."
     }

document { quote HashTable,
     TT "HashTable", " -- the class of all hash tables.",
     PARA,
     "A hash table consists of: a class type, a parent type, and a
     set of key-value pairs.  The keys and values can be anything.
     The access functions below accept a key and return the
     corresponding value.  For details of the mechanism
     underlying this, see ", TO "hashing", ".",
     PARA,
     "One important feature of hash tables that when the keys
     are consecutive integers starting at 0, the keys are scanned
     in the natural order.",
     PARA,
     "There is a subclass of HashTable called ", TO "MutableHashTable", "
     which consists of those hash tables whose entries can be changed.",
     PARA,
     "Access functions:",
     MENU {
 	  TO quote #,
 	  TO quote .,
 	  TO "pairs",
 	  TO "keys",
 	  TO "values"
 	  },
     "Query functions:",
     MENU {
 	  TO quote #?,
 	  TO quote .?,
	  TO "mutable"
 	  },
     "Structural functions:",
     MENU {
 	  TO "copy",
	  TO "remove"
 	  },
     "Other functions:",
     MENU {
 	  TO "applyKeys",
 	  TO "applyPairs",
 	  TO "combine",
	  TO "hashTable",
 	  TO "merge",
     	  TO "new",
	  TO (NewFromMethod, HashTable, List),
	  TO "scanKeys",
 	  TO "scanPairs",
	  TO "select"
 	  },
     "Examining hash tables:",
     MENU {
	  TO "browse",
	  TO "peek"
	  },
     "Types of hash tables:",
     MENU {
	  TO "MutableHashTable",
	  TO Set,
	  TO Tally
	  }
     }

document { quote maxPosition,
     TT "maxPosition x", " -- yields the position of the largest element in the list.",
     PARA,
     "If it occurs more than once, then the first occurrence
     is used.  If x has length zero an error results."
     }

document { quote minPosition,
     TT "minPosition x", " -- yields the position of the smallest element in the list.",
     PARA,
     "If it occurs more than once, then the first occurrence
     is used.  If x has length zero an error results."
     }

document { quote keys,
     TT "keys t", " -- yields a list of the keys occurring in the hash table t.",
     PARA,
     EXAMPLE "keys version"
     }

document { quote values,
     TT "values t", " -- yields a list of the values occurring in the hash table t."
     }

document { quote splice,
     TT "splice v", " -- yields a new list v where any members of v which are sequences
     are replaced by their elements.",
     PARA,
     "Works also for sequences, and leaves other expressions unchanged.
     Copying the list v is always done when v is mutable.
     Certain functions always splice their arguments or their argument
     lists for the sake of convenience.",
     EXAMPLE {
	  "splice ((a,b),c,(d,(e,f)))",
      	  "splice [(a,b),c,(d,(e,f))]",
	  },
     SEEALSO "deepSplice"
     }

document { quote deepSplice,
     TT "deepSplice v", " -- yields a new list v where any members of v 
     which are sequences are replaced by their elements, and so on.",
     PARA,
     "Works also for sequences, and leaves other expressions unchanged.
     Copying the list v is always done when v is mutable.",
     EXAMPLE "deepSplice { (a,b,(c,d,(e,f))), g, h }",
     SEEALSO "splice"
     }

document { quote seq,
     TT "seq x", " -- encloses x in a sequence of length 1, even if x is already a 
     sequence.  This is needed because the convention about commas can
     produce only sequences of length 2 and greater, and the convention about 
     empty pairs of parentheses can produce only sequences of length zero.",
     PARA,
     SEEALSO{ "sequence", "lists, arrays, and sequences"}
     }

document { quote ",",
     TT "x,y,...,z", " -- produces a sequence.",
     PARA,
     SEEALSO "lists, arrays, and sequences"
     }

document { quote apply,
     TT "apply(v,f)", " -- applies the function ", TT "f", " to each element of the 
     list ", TT "v", ", returning the list of results. If ", TT "v", " is 
     a sequence, then a sequence is returned.",
     PARA,
     EXAMPLE {
	  "apply(1 .. 5, i->i^2)",
      	  "apply({1,3,5,7}, i->i^2)",
	  },
     PARA,
     NOINDENT,
     TT "apply(v,w,f)", " -- produces, from lists or 
     sequences ", TT "v", " and ", TT "w", ",
     a list ", TT "z", " in which the i-th element ", TT "w_i", " is obtained
     by evaluating ", TT "f(v_i,w_i)", ".  If ", TT "v", " and ", TT "w", " are
     lists of the same class, then the result is also of
     that class.  If ", TT "v", " and ", TT "w", " are sequences, then so
     is the result.",
     PARA,
     EXAMPLE {
	  "apply(1 .. 5, a .. e, identity)",
      	  "apply({1,3,5,7}, i->i^2)",
	  },
     PARA,
     NOINDENT,
     TT "apply(n,f)", " -- equivalent to apply(list (0 .. n-1),f), for an integer n.",
     PARA,
     SEEALSO{ "scan", "select",  "any",  "all", "member"},
     PARA,
     NOINDENT,
     TT "apply(x,f)", " -- produces a new hash table ", TT "y", " from
     an hash table ", TT "x", " by applying the function
     ", TT "f", " to each of the values of ", TT "x", ".  This means that
     if ", TT "x#k === v", " then ", TT "y#k === f(v)", ".",
     SEEALSO {(quote /,List, Function), (quote \, Function, List)}
     }

document { quote scan,
     TT "scan(v,f)", " -- applies the function ", TT "f", " to each element of the 
     list ", TT "v", ".  The function values are discarded.",
     PARA,
     EXAMPLE "scan({a,4,\"George\",2^100}, print)",
     NOINDENT,
     TT "scan(n,f)", " -- equivalent to scan(0 .. n-1, f), for an integer n.",
     EXAMPLE "scan(3,print)",
     SEEALSO { "select", "any", "all", "member"}
     }

document { quote scanPairs,
     TT "scanPairs(x,f)", " -- applies the function ", TT "f", " to each
     pair ", TT "(k,v)", " where ", TT "k", " is a key in the hash 
     table ", TT "x", " and ", TT "v", " is the corresponding 
     value ", TT "x#k", ".",
     PARA,
     "This function requires an immutable hash table.  To scan the pairs in
     a mutable hash table, use ", TT "scan(pairs x, f)", ".",
     PARA,
     SEEALSO "scan"
     }

document { quote select,
     TT "select(v,f)", " -- select elements of the list or hash table
     ", TT "v", " which yield ", TT "true", " when the function 
     ", TT "f", " is applied.",
     BR,NOINDENT,
     TT "select(n,v,f)", " -- select at most ", TT "n", " elements of the
     list or hash table ", TT "v", " which yield ", TT "true", " when
     the function ", TT "f", " is applied.",
     PARA,
     "For a list, the order of the elements in the result will be the
     same as in the original list ", TT "v", ".",
     PARA,
     "For a hash table, the function is applied to each value.  This may
     change, for perhaps it should be applied to the key/value pair.  The
     hash table should be immutable: to scan the values in a mutable hash
     table, use ", TT "scan(values x, f)", ".",
     PARA,
     EXAMPLE {
	  "select({1,2,3,4,5}, odd)",
      	  "select(2,{1,2,3,4,5}, odd)",
	  },
     PARA,
     SEEALSO{ "scan", "apply", "any", "all", "member", "mutable"}
     }

--document { quote find,
--     TT "find(x,f)", " -- applies the function ", TT "f", " to each element
--     of ", TT "x", ", returning the result not equal to ", TT "null", ".
--     If no result is non-null, then it returns null."
--     }

document { quote any,
     TT "any(v,f)", " -- yields the value true or false depending on 
     whether any element ", TT "v#i", " of ", TT "v", " yields the value true 
     when the predicate ", TT "f", " is applied.",
     PARA,
     "Works when v is a list, sequence, or hash table, but when v is an
     hash table, f is applied to each pair (k,x) consisting of a key k
     and a value x from v.",
     PARA,
     SEEALSO{ "scan", "apply", "select", "all", "member"}
     }

document { quote describe,
     TT "describe x", " -- prints the real name of ", TT "x", ", bypassing the
     feature which causes certian types of things to acquire the names of
     global variables to which they ar assigned.",
     PARA,
     EXAMPLE {
	  "R = ZZ/101[a,b,c,d];",
      	  "R",
      	  "describe R",
	  },
     PARA,
     SEEALSO "name"
     }

document { quote input,
     TT "input \"f\"", " -- reads and executes the commands found in the 
     file named f, echoing the input, printing the values, and incrementing
     the line number.",
     PARA,
     "The file is sought along the ", TO "path", ", unless the name of the
     file begins with '/' or './' or '../' .",
     PARA,
     SEEALSO{ "path", "needs", "load"}
     }

document { quote load,
     TT "load \"f\"", " -- reads and executes Macaulay 2 expressions found
     in the file named ", TT "f", ".",
     PARA,
     "The file is sought along the ", TO "path", ", unless the name of the
     file begins with the character(s) in ", TO "pathSeparator", ".  The
     file is read without echoing the input, printing the values, or
     incrementing the line number.",
     PARA,
     SEEALSO{ "path", "needs", "input"}
     }

document { quote needs,
     TT "needs \"f\"", " -- loads the file named ", TT "f", " if it hasn't 
     been loaded yet.",
     PARA,
     SEEALSO "load"
     }

document { quote plus,
     TT "plus(x,y,...)", " -- yields the sum of its arguments.",
     PARA,
     "If the arguments are strings, they are concatenated.  If there
     are no arguments, the answer is the integer 0."
     }

document { quote times,
     TT "times(x,y,...)", " -- yields the product of its arguments.",
     PARA,
     "If there are no arguments, the value is the integer 1."
     }

document { quote power,
     TT "power(x,n)", " -- yields the n-th power of ", TT "x", ".",
     PARA,
     SEEALSO "^"
     }

document { quote difference, 
     TT "difference(x,y)", " -- returns ", TT "x-y", "." 
     }

document { quote minus,
     TT "minus(x)   ", " -- yields ", TT "-x", ".",
     PARA,
     "minus(x,y)  -- yields x-y, but see also ", TO "difference", "."
     }

document { quote append,
     TT "append(v,x)", " -- yields the list obtained by appending ", TT "x", " to the 
     list ", TT "v", ".  Similarly if ", TT "v", " is a sequence.",
     PARA,
     EXAMPLE "append( {a,b,c}, x )",
     PARA,
     SEEALSO{ "prepend", "join"}
     }

document { quote prepend,
     TT "prepend(x,v)", " -- yields the list obtained by prepending x to the 
     list ", TT "v", ".  Similarly if ", TT "v", " is a sequence.",
     PARA,
     EXAMPLE "prepend( x, {a,b,c} )",
     PARA,
     SEEALSO{ "append", "join"}
     }

document { "--",
     TT "--", " introduces a comment in the text of a program.  The comment runs from
     the double hyphen to the end of the line."
     }

document { quote ascii,
     TT "ascii s", " -- convert a string to a list of ascii codes.", BR,
     NOINDENT,
     TT "ascii v", " -- convert a list of ascii codes to a string.",
     PARA,
     EXAMPLE {///ascii "abcdef"///, ///ascii oo///},
     SEEALSO{ "String" }
     }

document { quote transnet,
     TT "transnet v", " -- takes a list ", TT "v", " of integers, and assembles the bytes of the
     integers, four at a time, in network order (high order byte
     first), into a string.",
     BR,
     BR,
     NOINDENT,
     TT "transnet s", " -- takes a string ", TT "s", " whose length is a multiple 
     of 4, and assembles its bytes four at a time into integers, returning the list 
     of assembled integers.",
     PARA,
     EXAMPLE { "transnet {1,2,3}", "transnet oo"},
     SEEALSO{ "String" }
     }

document { quote " ",
     TT "f x", " -- yields the result of applying the function f to x.",
     PARA,
     "The user may install ", TO {"binary method", "s"}, " for this operator 
     with code such as ",
     PRE "         X Y := (x,y) -> ...",
     "where ", TT "X", " is the class of ", TT "x", " and ", TT "Y", " is the
     class of ", TT "y", "."
     }

document { quote *,
     TT "x * y", " -- yields the product of x and y.",
     BR,NOINDENT,
     TT "* x", " -- unary operator available to the user.",
     PARA,
     "The user may install ", TO {"binary method", "s"}, " for this operator with code
     such as ",
     PRE "         X * Y := (x,y) -> ...",
     "where ", TT "X", " is the class of ", TT "x", " and ", TT "Y", " is the
     class of ", TT "y", ".",
     PARA,
     "A unary method for this operator may be installed with code such as ", 
     PRE "          * X := x -> ... ",
     "Here are some of the methods installed.",
     MENU {
	  TO (quote *, Set, Set)
	  },
     SEEALSO{ "times", "product" }
     }

document { quote &,
     TT "x & y", " -- a binary operator.",
     PARA,
     "The user may install ", TO {"binary method", "s"}, " for this operator 
     with code such as ",
     PRE "         X & Y := (x,y) -> ...",
     "where ", TT "X", " is the class of ", TT "x", " and ", TT "Y", " is the
     class of ", TT "y", ".",
     PARA,
     "See also:",
     MENU {
	  TO (quote &,ZZ,ZZ)
	  }
     }

ZZ & ZZ := lookup(quote &, ZZ, ZZ)
document { (quote &, ZZ, ZZ),
     TT "m & n", " -- produce an integer obtained from the bits of the 
     integers ", TT "m", " and ", TT "n", " by logical 'and'."
     }

document { quote &&,
     TT "x && y", " -- a binary operator.",
     PARA,
     "The user may install ", TO {"binary method", "s"}, " for this operator 
     with code such as ",
     PRE "         X && Y := (x,y) -> ...",
     "where ", TT "X", " is the class of ", TT "x", " and ", TT "Y", " is the
     class of ", TT "y", "."
     }

-- document { quote ::,
--      TT "x :: y", " -- a binary operator.",
--      PARA,
--      "The user may install ", TO {"binary method", "s"}, " for this operator 
--      with code such as ",
--      PRE "         X :: Y := (x,y) -> ...",
--      "where ", TT "X", " is the class of ", TT "x", " and ", TT "Y", " is the
--      class of ", TT "y", "."
--      }

document { quote ^^,
     TT "x ^^ y", " -- a binary operator.",
     PARA,
     "The user may install ", TO {"binary method", "s"}, " for this operator 
     with code such as ",
     PRE "         X ^^ Y := (x,y) -> ...",
     "where ", TT "X", " is the class of ", TT "x", " and ", TT "Y", " is the
     class of ", TT "y", "."
     }

document { quote +,
     TT "x + y", " -- a binary operator used for addition in many situations
     and union of sets.",
     PARA,
     "The user may install ", TO {"binary method", "s"}, " for this operator 
     with code such as ",
     PRE "         X + Y := (x,y) -> ...",
     "where ", TT "X", " is the class of ", TT "x", " and ", TT "Y", " is the
     class of ", TT "y", ".",
     PARA,
     MENU {
	  TO (quote +, Set, Set)
	  },
     SEEALSO{ "plus", "sum" }
     }

document { (quote +, Set, Set),
     TT "s + t", " -- union of two sets",
     PARA,
     SEEALSO "+"
     }

document { quote -,
     TT "x - y", " -- a binary operator used for subtraction in many situations
     and set difference.",
     BR,NOINDENT,
     TT "- y", "   -- a unary operator used for negation.",
     PARA,
     "The user may install ", TO {"binary method", "s"}, " for this operator 
     with code such as ",
     PRE "         X - Y := (x,y) -> ...",
     "where ", TT "X", " is the class of ", TT "x", " and ", TT "Y", " is the
     class of ", TT "y", ".",
     PARA,
     "The user may install a method for this unary operator with code
     such as ",
     PRE "          - Y := y -> ...",
     "where ", TT "Y", " is the class of ", TT "y", ".",
     SEEALSO{ "difference", "minus" }
     }

document { quote /,
     TT "x / y", " -- a binary operator.",
     PARA,
     "The user may install ", TO {"binary method", "s"}, " for this operator 
     with code such as ",
     PRE "         X / Y := (x,y) -> ...",
     "where ", TT "X", " is the class of ", TT "x", " and ", TT "Y", " is the
     class of ", TT "y", ".",
     MENU {
	  TO (quote /, Ring, Ideal),
	  TO (quote /, Module, Module),
	  TO (quote /, Module, Ideal),
	  TO (quote /, Ideal, Ideal),
	  TO (quote /, List, Function)
	  }
     }

document { quote %,
     TT "x % y", " -- a binary operator used for remainder and reduction.",
     PARA,
     "The user may install ", TO {"binary method", "s"}, " for this operator 
     with code such as ",
     PRE "         X % Y := (x,y) -> ...",
     "where ", TT "X", " is the class of ", TT "x", " and ", TT "Y", " is the
     class of ", TT "y", "."
     }

document { quote //,
     TT "x // y", " -- a binary operator used for quotients (with a possible
     remainder).",
     PARA,
     "The user may install ", TO {"binary method", "s"}, " for this operator 
     with code such as ",
     PRE "         X // Y := (x,y) -> ...",
     "where ", TT "X", " is the class of ", TT "x", " and ", TT "Y", " is the
     class of ", TT "y", "."
     }

document { quote ^,
     TT "x ^ y", " -- a binary operator used for powers and raising nets.",
     PARA,
     "The user may install ", TO {"binary method", "s"}, " for this operator 
     with code such as ",
     PRE "         X ^ Y := (x,y) -> ...",
     "where ", TT "X", " is the class of ", TT "x", " and ", TT "Y", " is the
     class of ", TT "y", ".",
     PARA,
     "Here are some methods for computing powers:",
     MENU {
	  TO "SimplePowerMethod",
	  TO "BinaryPowerMethod"
	  },
     PARA,
     "If n is 0, then the unit element ", TT "(class x)#1", " is returned.
     If n is negative, then the method named ", TO "InverseMethod", "
     will be called."
     }

Thing /^ ZZ := (x,n) -> x^n/n!
document { quote /^,
     TT "x/^  y", " -- a binary operator, used for divided powers.",
     PARA,
     "The user may install ", TO {"binary method", "s"}, " for this operator 
     with code such as ",
     PRE "         X /^ Y := (x,y) -> ...",
     "where ", TT "X", " is the class of ", TT "x", " and ", TT "Y", " is the
     class of ", TT "y", ".",
     MENU {
	  TO (quote /^, Thing, ZZ)
	  }
     }

document { (quote /^, Thing, ZZ),
     TT "x /^ n", " -- computes the n-th divided power of x.",
     PARA,
     "This is implemented naively as ", TT "x^n/n!", ".",
     PARA,
     EXAMPLE {
	  "ZZ/101[x];",
      	  "x/^3"
	  },
     }

document { quote substring,
     TT "substring(s,i,n)", " -- yields the substring of the string s starting at 
     position i with length n.",
     PARA,
     "substring(s,i)   -- yields the substring of s starting at position i and
     continuing to the end of s.",
     PARA,
     "Positions are numbered starting at 0.",
     PARA,
     "Requests for character positions out of bounds are 
     silently ignored.",
     PARA,
     SEEALSO{ "String" }
     }

document { quote reverse,
     TT "reverse v", " -- yields a list containing the elements of the list v in reverse 
     order."
     }

document { quote read,
     TT "read f", "  -- yields a string obtained by reading bytes from the input file
     ", TT "f", ".",BR,
     NOINDENT, 
     TT "read ()", " -- reads from stdin, getting input from the user.",BR,
     NOINDENT, 
     TT "read s", "  -- reads from stdin, getting input from the user, prompting
     with the string s.",BR,
     PARA,
     "Input files are buffered, so the current contents of the buffer are returned
     if the buffer is not empty, otherwise reading from the file is attempted first.",
     SEEALSO {"get", "File"}
     }

document { quote get,
     TT "get \"f\"", " -- yields a string containing the contents of the file whose name
     is f.",
     PARA,
     NOINDENT,
     TT "get \"!f\"", " -- yields a string containing the output from the shell
     command \"f\".",
     PARA,
     NOINDENT,
     TT "get \"$hostname:service\"", " -- yields a string containing the
     input from the socket obtained by connecting to the specified host at
     the port appropriate for the specified service.  Warning: if the process
     providing the service expects interaction, it will not get it, and this
     command will hang.  This feature is not available on Sun computers,
     because Sun doesn't provide static versions of crucial libraries dealing
     with network communications.",
     PARA,
     NOINDENT,
     TT "get f", " -- yields a string containing the rest of the input from the 
     file f.",
     PARA,
     EXAMPLE {
	  ///"junk" << "hi there" << endl << close///,
      	  ///get "junk"///,
      	  ///get "!date"///,
	  },
     if version#"operating system" =!= "SunOS"
     and version#"operating system" =!= "CYGWIN32-NT"
     and version#"operating system" =!= "CYGWIN32-95"
     then EXAMPLE ///get "$localhost:daytime"///,
     SEEALSO{ "File", "String", "read" }
     }

document { quote lines,
     TT "lines s", " -- yields an array of strings obtained from the
     string ", TT "s", " by breaking it at newline or return characters.",
     BR,NOINDENT,
     TT "lines(s,nl)", " -- yields an array of strings obtained from the 
     string ", TT "s", " by breaking it at the newline characters
     specified by the string ", TT "nl", ".",
     PARA,
     "The form ", TT "lines s", " is designed to break lines correctly
     when the file follows the Unix, MS-DOS, or Macintosh convention and
     contains no extraneous isolated newline or return characters.  In
     other words, it will break a line at \"\\r\\n\", \"\\n\", or \"\\r\".",
     PARA,
     "The string ", TT "nl", " should be a string of length 1 or 2.",
     SEEALSO "newline"
     }

document { quote !,
     "n ! -- computes n factorial, 1*2*3*...*n."
     }

document { quote "not",
     TT "not x", " -- yields the negation of x, which must be true or false.",
     SEEALSO{ "and", "or" }
     }

document { quote |,
     TT "x | y", " -- a binary operator.",
     PARA,
     "The user may install ", TO {"binary method", "s"}, " for this operator 
     with code such as ",
     PRE "         X | Y := (x,y) -> ...",
     "where ", TT "X", " is the class of ", TT "x", " and ", TT "Y", " is the
     class of ", TT "y", ".",
     PARA,
     MENU {
	  TO {(quote |, List, List), " -- join two lists"},
	  TO {(quote |, String, String), " -- concatenate two strings or nets horizontally"},
	  TO {(quote |, ZZ, ZZ), " -- logical OR of two integers"},
	  TO {(quote |, Matrix, Matrix), " -- join two matrices horizontally"}
	  },
     SEEALSO "||"
     }
document { (quote |, List, List),
     TT "v|w", " -- join two lists.", 
     PARA,
     EXAMPLE "{1,2,3}|{4,5,6}",
     SEEALSO "|"
     }
document { (quote |, String, String),
     TT "s|t", " -- concatenates strings or nets horizontally.", 
     PARA,
     "The result is a string if the arguments are all strings, otherwise it
     is a net.  The baselines of the nets are aligned.",
     EXAMPLE {
	  ///"abc" | "def"///,
      	  ///x = "abc" || "ABC"///,
      	  ///x|"x"|x///,
	  },
     PARA,
     "If one of the two arguments is an integer, it is converted to a string first.",
     EXAMPLE ///"t = " | 333///,      
     SEEALSO {"|", "horizontalJoin", "Net"}
     }
document { (quote |, ZZ, ZZ),
     TT "m|n", " -- produce an integer obtained from the bits of the 
     integers ", TT "m", " and ", TT "n", " by logical 'or'.",
     PARA,
     EXAMPLE "5 | 12",
     SEEALSO "|"
     }
document { (quote |, Matrix, Matrix),
     TT "f|g", " -- concatenate matrices horizontally.",
     PARA,
     "It is assumed that ", TT "f", " and ", TT "g", " both have the same target.",
     EXAMPLE {
	  "R = ZZ/101[x,y,z]",
      	  "f = matrix {{x,0,0},{0,y,0},{0,0,z}}",
      	  "f|f|f",
	  },
     "If one of the arguments is ring element or an integer, then it
     will be multiplied by a suitable identity matrix.",
     PARA,
     EXAMPLE "2|f|3",
     SEEALSO {"|", (quote ||, Matrix, Matrix)}
     }

document { quote ||,
     TT "x || y", " -- a binary operator.",
     PARA,
     "The user may install ", TO {"binary method", "s"}, " for this operator 
     with code such as ",
     PRE "         X || Y := (x,y) -> ...",
     "where ", TT "X", " is the class of ", TT "x", " and ", TT "Y", " is the
     class of ", TT "y", ".",
     PARA,
     MENU {
	  TO (quote ||, Net, Net),
	  TO (quote ||, Matrix, Matrix)
	  }
     }

document { (quote ||, Net, Net),
     TT "m||n", " -- joins nets or strings by concatenating
     them vertically.  The baseline of the result is the baseline of the
     first one.",
     PARA,
     "In this example, we build a large net with arrows to indicate
     the location of the baseline.",
     EXAMPLE {
	  ///x = "x" | "3"^1///,
      	  ///"<--- " | ( x || "" || x ) | " --->"///,
	  },
     SEEALSO {"||", "|", "Net", "verticalJoin"}
     }
document { (quote ||, Matrix, Matrix),
     TT "f||g", " -- yields the matrix obtained from matrices ", TT "f", " and ", TT "g", " by
     concatenating the columns.",
     PARA,
     EXAMPLE {
	  "R = ZZ[a..h];",
      	  "p = matrix {{a,b},{c,d}}",
      	  "q = matrix {{e,f},{g,h}}",
      	  "p || q",
	  },
     "If one of the arguments is ring element or an integer, then it
     will be multiplied by a suitable identity matrix.",
     EXAMPLE "p || 33",
     PARA,
     SEEALSO{"||", (quote ||, Matrix, Matrix)}
     }

document { quote "===",
     TT "x === y", " -- returns true or false depending on whether the 
     expressions x and y are strictly equal.",
     PARA,
     "Strictly equal expressions have the same type, so ", TT "0===0.", " and
     ", TT "0===0/1", " are false; the three types involved here are ", TO
     "ZZ", ", ", TO "RR", ", and ", TO "QQ", ".",
     PARA,
     "If x and y are ", TO "mutable", " then they are strictly equal only
     if they are identical (i.e., at the same address in memory).  For
     details about why strict equality cannot depend on the contents of
     mutable hash tables, see ", TO "hashing", ".  On the other hand, if x
     and y are non-mutable, then they are strictly equal if and only if
     their contents are equal.",
     PARA,
     SEEALSO{ "==",  "=!=" }
     }

document { quote "=!=",
     TT "x =!= y", " -- returns true or false depending on whether the expressions
     x and y are strictly unequal.",
     PARA,
     "See ", TO "===", " for details."
     }

document { quote ==,
     TT "x == y", " -- a binary operator for testing mathematical equality.",
     PARA,
     "The user may install ", TO {"binary method", "s"}, " for this operator 
     with code such as ",
     PRE "         X == Y := (x,y) -> ...",
     "where ", TT "X", " is the class of ", TT "x", " and ", TT "Y", " is the
     class of ", TT "y", ".",
     PARA,
     "A test for mathematical equality will typically involve doing a computation
     to see whether two representations of the same mathematical object are being
     compared.  For example, an ideal in a ring is represented by giving its
     generators, and checking whether two sets of generators produce the same
     ideal involves a computation with Groebner bases.",
     PARA,
     "It may happen that for certain types of objects, there is no method installed
     for testing mathematical equality, in which case an error will be given.  If
     you wanted to test strict equality, use the operator ", TO "===", " or 
     ", TO "=!=", ".",
     PARA,
     SEEALSO{ "!=" }
     }

document { quote !=,
     TT "x != y", " -- the negation of ", TT "x == y", ".",
     PARA,
     SEEALSO{ "==" }
     }

document { quote **, 
     TT "x ** y", " -- a binary operator used for tensor product and
     cartesian product.",
     PARA,
     "The user may install ", TO {"binary method", "s"}, " for this operator 
     with code such as ",
     PRE "         X ** Y := (x,y) -> ...",
     "where ", TT "X", " is the class of ", TT "x", " and ", TT "Y", " is the
     class of ", TT "y", "."
     }

document { (quote **, Set, Set),
     TT "X ** Y", " -- form the Cartesian product of two sets.",
     PARA,
     "Its elements are the sequences (x,y), where x is an element
     of X, and y is an element of Y.",
     PARA,
     EXAMPLE "set {1,2} ** set {a,b,c}",
     PARA,
     "See also ", TO "**", " and ", TO "Set", "."
     }

document { quote set,
     TT "set v", " -- yields the set whose elements are the members of the list v.",
     PARA,
     "See also ", TO "Set", "."
     }

document { quote random,
     TT "random n", " -- for n an integer, yields a random integer in the range 0 .. n-1.",
     BR,
     NOINDENT, 
     TT "random x", " -- for real x, yields a random real number in the range 0 .. x.",
     BR,
     NOINDENT, 
     TT "random R", " -- yields a random element of the ring R.",
     BR,
     NOINDENT, 
     TT "random(n,R)", " -- yields a random homogeneous element of degree n 
     in the ring R, where n is an integer or a list of integers.",
     BR,
     NOINDENT, 
     TT "random(F,G)", " -- yields a random graded, degree 0, map from the free
     module G to the free module F.",
     PARA,
     "Warning: doesn't correctly handle the case when n an integer is larger
     than 2^31-1.",
     EXAMPLE {
	  "tally apply(100, i -> random 10)",
	  },
     EXAMPLE {
	  "R = ZZ/101[t];",
      	  "sum(7,i->random 101 * t^i)",
	  },
     EXAMPLE {
	  "R = ZZ/101[x,y];",
      	  "random(R^{1,2,3},R^{1,2,3})"
	  },
     }

document { quote true,
     PARA,
     "true -- a value indicating truth.",
     SEEALSO{"false", "Boolean"}
     }

document { quote false,
     PARA,
     "false -- a value indicating falsity.",
     SEEALSO{"true", "Boolean"}
     }

document { quote "timing",
     TT "timing e", " -- evaluates e and returns a list of type ", TO "Time", "
     of the form ", TT "{t,v}", ", where ", TT "t", " is the number of seconds
     of cpu timing used, and ", TT "v", " is the value of the the expression.",
     PARA,
     "The default method for printing such timing results is to display the
     timing separately in a comment below the computed value.",
     EXAMPLE {
	  "timing 3^30",
      	  "peek oo",
	  },
     SEEALSO "Time"
     }

document { quote "time",
     TT "time e", " -- evaluates e, prints the amount of cpu time
     used, and returns the value of e.",
     PARA,
     EXAMPLE "time 3^30",
     SEEALSO "timing"
     }

document { quote Time,
     TT "Time", " -- is the class of all timing results.  Each timing result
     is a ", TO "BasicList", " of the form ", TT "{t,v}", ", where ", TT "t", " 
     is the number of seconds of cpu time used, and ", TT "v", " is the value 
     of the the expression.",
     SEEALSO "timing"
     }

document { quote null,
     TT "null", " -- a symbol that represents the presence of nothing.",
     PARA,
     "When it is the value of an expression entered into the interpreter, the
     output line doesn't appear.  Empty spots in a list are represented by
     it.",
     PARA,
     "It is the only member of the class ", TO "Nothing", ".",
     PARA,
     EXAMPLE {
	  "x = {2,3,,4}",
      	  "x#2",
      	  "name x#2",
	  },
     SEEALSO { "Nothing" }
     }

document { quote "then",
     TT "then", " -- a keyword used with ", TO "if", "."
     }

document { quote "else",
     TT "else", " -- a keyword used with ", TO "if", "."
     }

document { quote "if",
     TT "if p then x else y", " -- computes ", TT "p", ", which must yield the value ", TO "true", " 
     or ", TO "false", ".  If true, then the value of ", TT "x", " is provided,
     else the value of ", TT "y", " is provided.",
     PARA,
     TT "if p then x", " --  computes ", TT "p", ", which must yield the value ", TO "true", " 
     or ", TO "false", ".  If true, then the value of ", TT "x", " is provided,
     else the symbol ", TO "null", " is provided.",
     PARA,
     SEEALSO {"then", "else"}
     }

document { quote "while",
     TT "while p do x", " -- repeatedly evaluates x as long as the value of p remains 
     ", TO "true", ".",
     PARA,
     "This construction is more powerful than might appear at first glance, 
     even though there is no explicit construction in the language that allows one to
     break out of a loop, because ", TT "p", " may be a conjunction of several
     compound statements.  For example, the expression",
     PRE "     while (a(); not b()) and (c(); not d()) do e()",
     "might be used to replace C code that looks like this:",
     PRE "     while (TRUE) { a(); if (b()) break; c(); if (d()) break; e(); }",
     SEEALSO "do"
     }

document { quote "do",
     TT "do", " -- a keyword used with ", TO "while", "."
     }

document { quote "try",
     TT "try x else y ", " -- returns the value of x unless an error or
     ", TO "alarm", " occurs during the evaluation of x, in which case it 
     returns the value of y.", BR, NOINDENT,
     TT "try x ", " -- returns the value of x unless an error or
     ", TO "alarm", " occurs during the evaluation of x, in which case it 
     returns ", TO "null", ".",
     PARA,
     "The behavior of interrupts (other than alarms) is unaffected.",
     EXAMPLE "apply(-3..3,i->try 1/i else infinity)",
     PARA,
     "We will change the behavior of this function soon so that it will be
     possible to catch errors of a particular type.  Meanwhile, users are
     recommended to use this function sparingly, if at all."
     }

document { quote openFiles,
     TT "openFiles()", " -- produces a list of all currently open files.",
     PARA,
     "See also ", TO "File", "."
     }

document { quote stdin,
     TT "stdin", " -- the standard input file.",
     PARA,
     "Use this file to get input from the terminal.",
     PARA,
     "See also ", TO "File", "."
     }

document { quote stdout,
     TT "stdout", " -- the standard output file.",
     PARA,
     "Use this file to display information on the user's screen.",
     PARA,
     "See also ", TO "File", "."
     }

document { quote stderr,
     TT "stderr", " -- the standard error output file.",
     PARA,
     "Use this file to display error messages on the user's screen.",
     PARA,
     "See also ", TO "File", "."
     }

document { quote openIn,
     TT "openIn \"fff\"", "  -- opens an input file whose filename is fff.",
     BR,BR,NOINDENT,
     TT "openIn \"!cmd\"", " -- opens an input file which corresponds to a pipe 
     receiving the output from the shell command ", TT "cmd", ".",
     BR,BR,NOINDENT,
     TT "openIn \"$hostname:service\"", " -- opens a socket and returns a file which
     can be used both for input and output.",
     PARA,
     "The class of all files is ", TO "File", ".",
     PARA,
     EXAMPLE {
	  ///"junk" << "abcdefghijk" << endl << close///,
	  ///f = openIn "junk"///,
	  ///read f///,
	  ///close f///,
	  },
     PARA,
     "In order to open a socket successfully, there must be a process
     accepting connections for the desired service on the specified host.
     This feature is not available on Sun computers, because Sun doesn't
     provide static versions of crucial libraries dealing with network
     communications, or the static version doesn't provide network name
     service for looking up hostnames.",
     if version#"operating system" =!= "SunOS"
     and version#"operating system" =!= "CYGWIN32-NT"
     and version#"operating system" =!= "CYGWIN32-95"
     then EXAMPLE ///get "$localhost:daytime"///,
     SEEALSO "File"
     }

document { quote openOut,
     TT "openOut \"fff\"", "  -- opens an output file whose filename is fff.",
     PARA,
     TT "openOut \"!cmd\"", " -- opens an output file which corresponds to a pipe 
     providing the output to the shell command ", TT "cmd", ".",
     PARA,
     "See also ", TO "File", "."
     }

document { quote protect,
     TT "protect s", " -- Protects the symbol s from having its value changed.",
     PARA,
     "There is no unprotect function, because we want to allow the compiler
     to take advantage of the unchangeability.",
     PARA,
     "The documentation function ", TO "document", " protects the symbols
     it documents."
     }

document { quote <<,
     TT "x << y", " -- a binary or unary operator used for file output.",
     PARA,
     "The user may install ", TO {"binary method", "s"}, " for this operator 
     with code such as ",
     PRE "         X << Y := (x,y) -> ...",
     "where ", TT "X", " is the class of ", TT "x", " and ", TT "Y", " is the
     class of ", TT "y", ".",
     MENU {
	  TO (quote <<,File,Thing),
	  TO (quote <<,Nothing,Thing),
	  TO (quote <<,Thing),
	  TO (quote <<, String, Thing)
	  }
     }

document { (quote <<,ZZ, ZZ),
     TT "i << j", " -- shifts the bits in the integer i leftward j places.",
     PARA,
     EXAMPLE "2 << 5",
     SEEALSO ">>"
     }

document { (quote >>, ZZ, ZZ),
     TT "i >> j", " -- shifts the bits in the integer i rightward j places.",
     PARA,
     EXAMPLE "256 >> 5",
     SEEALSO "<<"
     }

document { (quote <<, String, Thing),
     TT "\"name\" << x", " -- prints the expression x on the output file
     named \"name\".",
     PARA,
     "Returns the newly created ", TO "File", " associated to the given name.
     Parsing associates leftward, so that several expressions may be displayed 
     with something like ", TT "\"name\"<<x<<y<<z", ".  It will often be convenient 
     to let the last output operation close the file, as illustrated below.",
     PARA,
     EXAMPLE {
	  "\"foo\" << 2^30 << endl << close",
      	  "get \"foo\""
	  }
     }

document { (quote <<, Thing),
     TT "<< x", " -- prints the expression x on the standard output file ", 
     TO "stdout", ".",
     PARA,
     EXAMPLE "<< \"abcdefghij\" << endl",
     SEEALSO {"<<"}
     }

document { quote >>,
     TT "i >> j", " -- shifts the bits in the integer i rightward j places."
     }

document { quote :,
     TT "x : y", " -- a binary operator.",
     PARA,
     "The user may install ", TO {"binary method", "s"}, " for this operator 
     with code such as ",
     PRE "         X : Y := (x,y) -> ...",
     "where ", TT "X", " is the class of ", TT "x", " and ", TT "Y", " is the
     class of ", TT "y", ".",
     PARA,
     MENU {
	  }
     }

document { (quote :, ZZ, Thing),
     TT "n : x", " -- repetition n times of x",
     PARA,
     "If ", TT "n", " is an integer and ", TT "x", " is anything, return a
     sequence consisting of ", TT "x", " repeated ", TT "n", " times.  A negative 
     value for ", TT "n", " will silently be treated as zero.",
     PARA,
     "Warning: such sequences do not get automatically spliced into lists
     containing them.",
     PARA,
     EXAMPLE "{5:a,10:b}"
     }

document { quote getc,
     TT "getc f", " -- obtains one byte from the input file f and provides it as a 
     string of length 1.  On end of file an empty string of is returned.",
     PARA,
     "See also ", TO "File", ".",
     PARA,
     "Bug: the name is cryptic and should be changed."
     }

document { quote <,
     TT "x < y", " -- yields ", TO "true", " or ", TO "false", 
     " depending on whether x < y.",
     PARA,
     "Calls upon ", TO "?", " to perform the comparison, if necessary."
     }

document { quote <=,
     TT "x <= y", " -- yields ", TO "true", " or ", 
     TO "false", " depending on whether x <= y.",
     PARA,
     "Calls upon ", TO "?", " to perform the comparison, if necessary."
     }

document { quote >,
     TT "x > y", " -- yields ", TO "true", " or ", 
     TO "false", " depending on whether x > y.",
     PARA,
     "Calls upon ", TO "?", " to perform the comparison, if necessary."
     }

document { quote >=,
     TT "x >= y", " -- yields ", 
     TO "true", " or ", 
     TO "false", " depending on whether x >= y.",
     PARA,
     "Calls upon ", TO "?", " to perform the comparison, if necessary."
     }

protect incomparable
document { quote incomparable,
     TT "incomparable", " -- a symbol which may be returned by ", TO "?", "
     when the two things being compared are incomparable."
     }

document { quote ?,
     TT "x ? y", " -- compares x and y, returning ", TT "quote <", ", ",
     TT "quote >", ", ", TT "quote ==", ", or ", TO "incomparable", ".",
     PARA,
     "The user may install ", TO {"binary method", "s"}, " for this operator with code
     such as ",
     PRE "         X ? Y := (x,y) -> ...",
     "where ", TT "X", " is the class of ", TT "x", " and ", TT "Y", " is the
     class of ", TT "y", ".",
     EXAMPLE {
	  "3 ? 4",
      	  "\"book\" ? \"boolean\"",
      	  "3 ? 3.",
      	  "3 ? \"a\"",
	  },
     "It would be nice to implement an operator like this one for everything
     in such a way that the set of all things in the language would be
     totally ordered, so that it could be used in the implementation of
     efficient hash tables, but we haven't done this.  The methods which have
     been installed for this operator are fairly primitive, and in the end
     often amount to simply comparing hash codes."  
     }

document { quote ;,
     TT "(e;f;...;g;h)", " -- the semicolon can be used for evaluating a sequence of 
     expressions.  The value of the sequence is the value of its
     last expression, unless it is omitted, in which case the value
     is ", TO "null", ".",
     EXAMPLE {
	  "(3;4;5)",
      	  "(3;4;5;)"
	  }
     }

document { quote <-,
     TT "x <- y    ", " -- assigns the value of y to x, but x is evaluated, too.",
     PARA,
     "If the value of x is a symbol, then the value of y is assigned as the
     value of that symbol.  If the value of x is a hash table, then the value 
     of y must be one, too, and the contents of y bodily replace the contents
     of x.  If the value of x is a list, then the value of y must be a list, 
     and the contents of y replace the contents of x.",
     PARA,
     "Warning: if y is a class with instances, these instances
     will NOT become instances of x.  If instances of x are 
     created later, then they will not be compatible with the
     instances of y.  One should try to avoid using ", TO "<-", " in this
     case.",
     PARA,
     "The value of the expression x <- y is x, with its new contents.",
     PARA,
     "See also ", TO "=", "."
     }

document { quote =,
     TT "x = e", "      -- assigns the value e to the variable x.",
     PARA,
     NOINDENT,
     TT "x#i = e", "    -- assigns the value e to the i-th member of the array x.  Here
     i must be a nonnegative integer.",
     PARA,
     NOINDENT,
     TT "x#k = e", "    -- assigns the value e to the key k in the hash table
     x.  Here k can be any expression.",
     SEEALSO {"HashTable", ":=", "GlobalReleaseHook", "GlobalAssignHook"}
     }


document { quote :=,
     TT "x := e", " -- assign the value e to the new local variable x",
     BR,NOINDENT,
     TT "f X := (x) -> ( ... )", " -- install a method for the method function
     ", TT "f", " acting on an argument of class ", TT "X", ".",
     BR,NOINDENT,
     TT "X * Y := (x,y) -> ( ... )", " -- install a method for the operator
     ", TT "*", " applied to arguments of classes ", TT "X", " and ", TT "Y", ".
     Many other operators are allowed: see ", TO "operators", ".",
     PARA,
     "This operator is slightly schizophrenic in its function, as the installation
     of a method has global effect if the classes involved are globally known,
     as is typically the case, whereas the assignment of a value to a local
     variable is never globally known."
     }

document { quote abs,
     TT "abs x", " -- computes the absolute value of x." }
document { quote sin,
     TT "sin x", " -- computes the sine of x." }
document { quote cos,
     TT "cos x", " -- computes the cosine of x." }
document { quote tan,
     TT "tan x", " -- computes the tangent of x." }
document { quote asin,
     TT "asin x", " -- computes the arcsine of x."}
document { quote acos,
     TT "acos x", " -- computes the arccosine of x."}
document { quote atan,
     TT "atan x", " -- computes the arctangent of x.",
     BR,NOINDENT,
     TT "atan(x,y)", " -- computes the angle formed with the 
     x-axis by the ray from the origin {0,0} to the point {x,y}."
     }
document { quote sinh,
     TT "sinh x", " -- computes the hyperbolic sine of x."}
document { quote cosh,
     TT "cosh x", " -- computes the hyperbolic cosine of x."}
document { quote tanh,
     TT "tanh x", " -- computes the hyperbolic tangent of x."}
document { quote exp,
     TT "exp x", " -- computes the exponential of x."}
document { quote log,
     TT "log x", " -- computes the logarithm of x."}
document { quote sqrt,
     TT "sqrt x", " -- provides the square root of the number x."}
document { quote floor,
     TT "floor x", " -- provides the largest integer less than or equal to the number x"
     }

document { quote run,
     TT "run s", " -- runs the command string s by passing it to the operating system.",
     PARA,
     "The return value is the exit status of the command."
     }

document { quote wait,
     TT "wait i", " -- wait for the completion of child process with process id
     ", TT "i", "."
     }

document { quote value,
     TT "value s", " -- provides the value of the symbol ", TT "s", ".",
     PARA,
     "The expression ", TT "s", " is evaluated, so this is different from simply typing ", TT "s", ".",
     PARA,
     EXAMPLE {
	  "t = 11",
      	  "x = quote t",
      	  "x",
      	  "value x"
	  }
     }

document { quote "global",
     TT "global s", " -- provides the global symbol s, even if s currently has 
     a value.",
     PARA,
     EXAMPLE {
	  "num",
      	  "num = 5",
      	  "num",
      	  "global num",
	  },
     SEEALSO {"local", "quote"}
     }

document { quote erase,
     TT "erase s", " -- removes the global symbol ", TT "s", " from the
     symbol table."
     }

document { quote "local",
     TT "local s", " -- provides the local symbol ", TT "s", ", creating
     a new symbol if necessary.  The initial value of a local
     symbol is ", TT "null", ".",
     EXAMPLE {
	  "f = () -> ZZ[local t]",
      	  "f()",
      	  "t",
	  },
     SEEALSO {"global", "quote"}
     }

document { quote quote,
     TT "quote s", " -- provides the symbol s, even if s currently has a value.",
     PARA,
     EXAMPLE {
	  "num",
      	  "num = 5",
      	  "num",
      	  "quote num",
	  },
     PARA,
     "If ", TT "s", " is an operator, then the corresponding symbol is provided.  This
     symbol is used by the interpreter in constructing keys for methods
     associated to the symbol.",
     EXAMPLE "quote +",
     SEEALSO {"local", "global"}
     }

document { quote gcd,
     TT "gcd(x,y)", " -- yields the greatest common divisor of x and y.",
     SEEALSO "gcdCoefficients"
     }

document { quote concatenate,
     TT "concatenate(s,t,...,u)", " -- yields the concatenation of the strings s,t,...,u.",
     PARA,
     "The arguments may also be lists or sequences of strings and symbols, in
     which case they are concatenated recursively.  Additionally,
     an integer may be used to represent a number of spaces.",
     PARA,
     EXAMPLE "concatenate {\"a\",(\"s\",3,\"d\"),\"f\"}",
     SEEALSO { "String"} 
     }

document { quote error,
     TT "error s", " -- causes an error message s to be displayed.",
     PARA,
     "The error message s (which should be a string) is printed.
     Execution of the code is interrupted, and control is returned
     to top level.",
     PARA,
     "Eventually we will have a means of ensuring that the line 
     number printed out with the error message will have more 
     significance, but currently it is the location in the code of 
     the error expression itself."
     }

document { quote characters,
     TT "characters s", " -- produces a list of the characters in the string s.",
     PARA,
     "The characters are represented by strings of length 1.",
     PARA,
     EXAMPLE "characters \"asdf\"",
     PARA,
     "See also ", TO "String", "."
     }

document { quote getenv,
     TT "getenv s", " -- yields the value associated with the string s in the environment."
     }

document { quote currentDirectory,
     TT "currentDirectory()", " -- returns the name of the current directory."
     }

document { quote ~,
     TT "~ x", " -- unary operator available to the user.  A method may
     be installed with code such as ", 
     PRE "          ~ X := x -> ... ",
     }

document { quote copy,
     TT "copy x", " -- yields a copy of x.",
     PARA,
     "If x is an hash table, array, list or sequence, then the elements are 
     placed into a new copy. If x is a hash table, the copy is mutable if 
     and only if x is.",
     PARA,
     "See also ", TO "newClass", "."
     }

document { quote mergePairs,
     TT "mergePairs(x,y,f)", " -- merges sorted lists of pairs.",
     PARA,
     "It merges x and y, which should be lists of pairs (k,v) arranged in
     increasing order according to the key k.  The result will be a list of
     pairs, also arranged in increasing order, each of which is either from x
     or from y, or in the case where a key k occurs in both, with say (k,v)
     in x and (k,w) in y, then the result will contain the pair (k,f(v,w)).
     Thus the function f is used for combining the values when the keys
     collide.  The class of the result is taken to be the minimal common
     ancestor of the class of x and the class of y.",
     PARA,
     SEEALSO { "merge" }
     }

document { quote merge,
     TT "merge(x,y,g)", " -- merges hash tables x and y using the function
     g to combine the values when the keys collide.",
     PARA,
     "If x and y have the same class and parent, then so will the result.
     The merged hash table has as its keys the keys occuring in the
     arguments.  When a key occurs in both arguments, the corresponding
     values are combined using the function g, which should be a
     function of two arguments.",
     PARA,
     "This function is useful for multiplying monomials or adding polynomials.",
     PARA,
     "See also ", TO "combine", "."
     }

document { quote combine,
     TT "combine(x,y,f,g,h)", " -- yields the result of combining hash tables
     x and y, using f to combine keys, g for values, and h for collisions.",
     PARA,
     "The objects are assumed to have the same class, and the result will
     have the class of one of them.  The combined object will contain f(p,q)
     => g(b,c) when x : p => b and y : q => c, and the function h is used to
     combine values when key collisions occur in the result, as with ", TO "merge", ".
     The function h should be a function of two arguments; it
     may assume that its first argument will be the value accumulated so far,
     and its second argument will be the result g(b,c) from a single pair of
     values.  Normally h will be an associative and commutative function.",
     PARA,
     "The result is mutable if and only if x or y is.",
     PARA,
     "This function can be used for multiplying polynomials,
     where it will look something like this: ", TT "combine(x, y, monomialTimes, coeffTimes, coeffPlus)", "."
     }

document { quote ancestor,
     TT "ancestor(x,y)", " -- tells whether y is an ancestor of x.",
     PARA,
     "The ancestors of x are x, parent x, parent parent x, and so on.",
     PARA,
     "See also ", TO "classes", "."
     }

document { quote unique,
     TT "unique v", " -- yields the elements of the list v, without duplicates.",
     PARA,
     "The order of elements is not necessarily maintained.",
     PARA,
     "See also ", TO "Set", " and ", TO "set", "."
     }

document { quote Ring,
     TT "Ring", " -- the class of all rings.",
     PARA,
     "A ring is a set together with operations +, -, * and elements 0, 1 
     satisfying the usual rules.  In this system, it is also understood to 
     be a ZZ-algebra, which means that the operations where one argument is 
     an integer are also provided.",
     PARA,
     "Here are some classes of rings.",
     MENU {
	  TO "Field",
	  TO "FractionField",
	  TO "GaloisField",
	  TO "PolynomialRing",
	  TO "ProductRing",
	  TO "QuotientRing",
	  TO "SchurRing"
	  },
     "Here are some particular rings:",
     MENU {
	  TO "ZZ",
	  TO "QQ"
	  },
     "Tests:",
     MENU {
	  TO "isAffineRing",
	  TO "isCommutative",
	  TO "isField",
	  TO "isPolynomialRing",
	  TO "isQuotientOf",
	  TO "isQuotientRing",
	  TO "isRing"
	  },
     "Here are some functions:",
     MENU {
	  {TO (quote _, ZZ, Ring), " -- get integer elements of a ring."},
	  (TO (quote _,Ring,ZZ), " -- get a generator of a ring."),
	  (TO (quote _,Ring,String), " -- getting generators by name"),
	  (TO (quote _,Ring,List), " -- getting monomials with given exponents"),
	  TO "char",
	  TO "coefficientRing",
	  TO "lift",
	  TO "map",
	  TO "promote",
	  TO "ring"
	  },
     "Ways to create new rings:",
     MENU {
	  (TO (quote **,Ring,Ring), " -- tensor product of rings"),
	  (TO (quote " ", Ring, OrderedMonoid), " -- monoid ring"),
	  (TO "symmetricAlgebra", " -- symmetric algebra")
	  },
     "Here are some keys used in rings:",
     MENU {
	  TO "baseRings",
	  TO "Engine",
	  TO "modulus"
	  }
     }

document { (quote _, ZZ, Ring),
     TT "1_R", " -- provides the unit element of a ring R.",
     BR, NOINDENT,
     TT "0_R", " -- provides the zero element of a ring R."
     }


document { quote SymbolTable,
     TT "SymbolTable", " -- the class of all symbol tables.",
     PARA,
     "In a symbol table, each key is string containing the name of 
     a symbol, and the corresponding value is the symbol itself.",
     PARA,
     SEEALSO "Symbol"
     }

document { quote symbolTable,
     TT "symbolTable()", " -- constructs an hash table containing the 
     global symbol table.",
     PARA,
     "Each key is a string containing the name of a symbol, and the 
     corresponding value is the symbol itself.",
     PARA,
     "See also ", TO "SymbolTable", "."
     }

document { quote applyPairs,
     TT "applyPairs(x,f)", " -- applies f to each pair (k,v) in the 
     hash table x to produce a new hash table.",
     PARA,
     "It produces a new hash table y from a hash table x by applying
     the function f to the pair (k,v) for each key k, where v is the value
     stored in x as x#k.  Thus f should be a function of two variables
     which returns either a pair (kk,vv) which is placed into y, or
     it returns ", TT "null", ", which signifies that no action
     be performed.",
     PARA,
     "See also ", TO "apply", " and ", TO "scanPairs", "."
     }

document { quote applyKeys,
     TT "applyKeys(x,f)", " -- applies f to each key k in the hash table x to 
     produce a new hash table.",
     PARA,
     "Thus f should be a function of one variables k which returns a new key 
     kk for the value v in y.  If kk is null, the result is not stored in y.",
     PARA,
     "See also ", TO "apply", "."
     }

document { quote use,
     TT "use S", " -- installs certain defaults associated with S.",
     PARA,
     "This will install functions or methods which make the use 
     of S the default in certain contexts.  For example, if ", TT "S", " is
     a polynomial ring on the variable ", TT "x", ", then it will set the
     value of the symbol ", TT "x", " to be the corresponding element of
     the ring ", TT "S", ".",
     PARA,
     "Here is another example.  If S is a monoid ring, then the product of an
     element of the base ring of S and an element of the base monoid of S
     will be taken to be an element of S, provided ", TT "use S", " has been
     executed.",
     PARA,
     "The return value is S.",
     PARA,
     "When a ring is assigned to a global variable, this function is
     automatically called for it.",
     SEEALSO "GlobalAssignHook"
     }

document { "reading the documentation",
     "The documentation for Macaulay 2 is available in several formats.
     The directory ", TT "Macaulay2/html", " contains the documentation in html
     form, suitable for viewing with a web browser such as Netscape, and this
     is the best way to view it.",
     PARA,
     "The directory ", TT "Macaulay2/book", " contains the code for producing
     the documentation in TeX form, which can be printed or viewed with
     ", TT "xdvi", ".  A hyperTeX form of the book is also makeable there
     which can be viewed with ", TT "xhdvi", ", the most recent version of
     which is available (May, 1995) at ",
     PARA,
     HREF "ftp://ftp.duke.edu/tex-archive/support/hypertex/hypertex/index.html",
     PARA,
     " in the file ",
     PARA,
     HREF "ftp://ftp.duke.edu/tex-archive/support/hypertex/hypertex/xhdvi_0.8a.tar.gz",
     PARA,
     " with needed WWW library routines at ",
     PARA,
     HREF "http://publish.aps.org/eprint/reports/hypertex/WWWLibrary.tar.Z",
     PARA,
     "Finally, all the documentation can be viewed within the program in
     text form using ", TO "help", "."
     }

document { "Macaulay 2",
     IMG "9planets.gif", PARA,
     "Macaulay 2 is a software system devoted to supporting research in 
     algebraic geometry and commutative algebra.",
     MENU {
	  {
	       H2 "User's Guide",
	       "Here are the basic concepts needed to use Macaulay 2 effectively.",
	       MENU {
		    TO "acknowledgements",
		    TO "copyright and license",
		    TO "how to get this program",
		    TO "reading the documentation",
		    TO "getting started",
		    TO "mathematical overview",
		    TO "programming overview",
		    TO "translating programs from Macaulay",
		    TO "plans for the future",
		    TO "the authors",
		    }
	       },
	  {
	       H2 "Mathematical Vignettes",
	       "In this section we present some tutorials which aim to introduce
	       the user to some mathematical ways of using Macaulay 2.  The tutorials
	       are relatively independent of each other, and each one introduces the use
	       of some features of Macaulay 2 in a slow and leisurely way, assuming the
	       reader is already familiar with the mathematical concepts involved.  
	       ", SHIELD TO "David Eisenbud", " joins us as a co-author of these tutorials.",
	       MENU {
		    TO "Elementary uses of Groebner bases",
		    TO "Canonical Embeddings of Plane Curves and Gonality",
		    TO "Fano varieties",
		    TO "Divisors",
		    TO "Homological Algebra 2",
		    }
	       },
     	  { 
	       H2 "Reference Manual",
	       "This section is intended to offer detailed documentation on
	       every aspect of the system of interest to users.",
	       MENU {
		    TO "invoking the program",
		    TO "classes",
		    TO "operators",
		    TO "Thing", 
		    TO "programming",
		    TO "mathematics", 
		    TO "executing other programs",
		    TO "debugging",
		    TO "system",
	       	    TO "help functions",
		    TO "syntax",
		    TO "obsolete functions and symbols",
		    },
     	       },
	  {
	       H2 "Developer's Corner",
	       MENU {
	       	    TO "engine",
		    TO "internals",
	       	    }
	       },
	  }
     }

document { "internals",
     "Here are some functions and classes that are intended for internal use 
     by the developers only.",
     MENU {
	  TO "formatDocumentTag",
	  }
     }

load "tutorials.m2"

document { "acknowledgements",
     "We thank the National Science Foundation for generous funding since
     1993 for this project, Gert-Martin Greuel and Ruediger Stobbe for the
     incorporation of their ", TO "Factory library", ", Michael Messollen for
     the incorporation of his ", TO "Factorization and characteristic sets library", ",
     and David Eisenbud, Wolfram Decker and Sorin Popescu for
     early support, encouragement and suggestions.  We also acknowledge an
     intellectual debt to David Bayer, who, with Michael Stillman,
     wrote Macaulay, a specialized computer algebra system for algebraic
     geometry and the predecessor of this program."
     }

document { "plans for the future",
     "We welcome advice and comments from users about possible improvements
     to Macaulay 2.  Hopefully we have settled upon most of the main points
     of program design, such as the names of functions already constructed,
     but new features can still be added.",
     PARA,
     "Here are some of the things we plan to work on:",
     MENU {
	  "A way to keep global symbols in separate packages from colliding",
	  "Better control of global and local symbols",
	  "Improved documentation",
	  "The ability to trap errors by type",
	  "Ensure that all routines handle inhomogeneous modules."
	  },
     "Here are some known problems.",
     MENU {
	  SHIELD ("The ", TO "DegreeLimit", " option doesn't work with ", TO "saturate", "
	  or ", TO "quotient", ".  This will be fixed soon."),
	  SHIELD ("There is an upper bound on the size of an exponent in a polynomial, and
	  overflow can occur silently, producing incorrect results.  The size of
	  the upper bound is affected by the option ", TO "MonomialSize", ".")
	  }
     }

document { "copyright and license",
     "Macaulay 2, its object code and source code, and its documentation,
     are copyright by Daniel R. Grayson and Michael E. Stillman.  We 
     permit you to make copies under the following conditions.",
     PARA,
     -- this paragraph has to be duplicated in licenses/README
     "Provided you are a person (and not a corporate entity), you may make as
     many copies of Macaulay 2 as you like for your personal non-commercial
     use.  You may install copies of Macaulay 2 on computers owned by
     Universities, Colleges, High Schools, and other schools in such a way
     that students and staff of those institutions may use it.  You may
     modify and distribute the source code in the Macaulay 2 language we
     provide you, but you must retain our copyright notices and mark modified
     source code so others will know that it's been modified.  You may print
     out the manual and make copies of it for your personal use.",
     PARA,
     "If your intended use of Macaulay 2 is not covered by the license above,
     please contact us so we can work something out.  Notice that in the
     license above we have not granted you permission to make copies of
     Macaulay 2 to be sold, distributed on media which are sold, or
     distributed along with software which is sold.  We have not granted you
     permission to make derivative works, or to distribute them.  If you
     encounter a copy which appears not to conform to the terms of the
     license above, we would like to hear about it.",
     PARA,
     "Various libraries have been compiled into Macaulay 2.",
     MENU {
	  SHIELD TO "Factory library",
	  SHIELD TO "Factorization and characteristic sets library",
	  SHIELD TO "MP: Multi Protocol",
	  SHIELD TO "GNU MP",
	  SHIELD TO "GC garbage collector"
	  }
     }

document { "GC garbage collector",
     "Macaulay 2 uses the garbage collector 'GC' written by Hans-J. Boehm
     and Alan J. Demers.  The copyright is contained in its README file
     which we provide in the file ", TT "Macaulay2/licenses/gc.lic", ".",
     SEEALSO "collectGarbage"
     }

document { "Factory library",
     "With the kind permission of the authors of Singular, G.-M. Greuel,
     G. Pfister, H. Schoenemann and R. Stobbe, University of Kaiserslautern,
     Macaulay 2 incorporates 'Factory', a Singular library of polynomial
     routines which provides for factorization of polynomials. That library
     is copyright 1996 by Gert-Martin Greuel and Ruediger Stobbe.  We provide
     a copy of the license in the file ", TT "Macaulay2/licenses/factory.lic", ".",
     SEEALSO {"factor", "gcd"}
     }

document { "Factorization and characteristic sets library",
     "With the kind permission of the author, Michael Messollen, University
     of Saarbruecken, Macaulay 2 incorporates a library of routines which
     provides factorization of multivariate polynomials over finite fields
     and computation of the minimal associated primes of ideals via
     characteristic sets.  That library is copyright 1996 by Michael
     Messollen.  We provide a copy of the license in the file
     ", TT "Macaulay2/licenses/libfac.lic", ".",
     SEEALSO {"factor", "gcd", "decompose", "irreducibleCharacteristicSeries"}
     }

document { "GNU MP",
     "The GNU MP library provides routines for arbitrary precision
     integer and floating point arithmetic.  Version 2.0 of the library
     is provided to us under the GNU LIBRARY GENERAL PUBLIC LICENSE,
     a copy of which is provided to you as part of the Macaulay 2
     package in the file ", TT "Macaulay2/licenses/gnulib.lic", ".  
     Macaulay 2 contains no derivative of GNU MP, and works with it by 
     being linked with it, and hence the Macaulay2 executable is covered 
     by section 6 of the GNU license.  We fulfill the terms of its license 
     by offering you the source code of the program, available at our
     web site and our anonymous ftp site.",
     SEEALSO "how to get this program"
     }

document { "operators",
     "Here is a list of unary and binary operators in the language.  Many
     of them can have methods installed for handling arguments of specific
     types.",
     MENU {
          (TO quote " ", " -- function application"),
          (TO ",", " -- separates elements of lists or sequences"),
          (TO ";", " -- statement separator"),
          (TO "=", " -- assignment"),
          (TO "<-", " -- assignment with left hand side evaluated"),
          (TO ":=", " -- assignment of method or new local variable"),
          (TO "==", " -- equal"),
          (TO "!=", " -- not equal"),
          (TO "===", " -- strictly equal"),
          (TO "=!=", " -- strictly not equal"),
          (TO "<", " -- less than"),
          (TO "<=", " -- less than or equal"),
          (TO "=>", " -- option"),
          (TO ">", " -- greater than"),
          (TO ">=", " -- greater than or equal"),
          (TO "?", " -- comparison"),
	  (TO "or", " -- or"),
	  (TO "and", " -- and"),
          (TO "not", " -- negation"),
          (TO "..", " -- sequence builder"),
          (TO "+", " -- addition"),
          (TO "-", " -- subtraction"),
          (TO "*", " -- multiplication"),
          (TO "/", " -- division"),
          (TO "//", " -- quotient"),
          (TO "%", " -- remainder"),
          (TO "^", " -- power"),
          (TO "/^", " -- divided power"),
          (TO "!", " -- factorial"),
          (TO "++", " -- direct sum"),
          (TO "**", " -- tensor product"),
          (TO "<<", " -- file output, bit shifting"),
          (TO ">>", " -- bit shifting"),
          (TO "_", " -- subscripting"),
          (TO ".", " -- hash table access or assignment"),
          (TO ".?", " -- test for hash table access"),
          (TO "#", " -- hash table access; length of a list, sequence or hash table"),
          (TO "#?", " -- test for hash table access"),
          (TO "|", " -- horizontal concatenation of strings or matrices"),
          (TO "||", " -- vertical concatentation of strings or matrices"),
          (TO "&", " -- bit-wise and"),
          (TO ":", " -- ideal quotient, repetitions"),
          (TO quote "\\", " -- applying a function to elements of a list"),
          (TO "/", " -- applying a function to elements of a list"),
          (TO "@", " -- "),
          (TO "@@", " -- composing functions"),
          -- (TO "::", " -- "),
          (TO "&&", " -- "),
          (TO "^^", " -- "),
          (TO "~", " -- ")
     	  }
     }

document { quote =>,
     TT "x => y", " -- a binary operator.",
     PARA,
     "The user may install ", TO {"binary method", "s"}, " for this operator 
     with code such as ",
     PRE "         X => Y := (x,y) -> ...",
     "where ", TT "X", " is the class of ", TT "x", " and ", TT "Y", " is the
     class of ", TT "y", ".",
     MENU {
	  TO (quote =>, Thing, Thing)
	  }
     }

document { "invoking the program",
     TT "M2", " -- starts the program.",
     PARA,
     TT "M2 file1 file2 ... ", " -- starts the program, reading and 
     executing the specified files.",
     PARA,
     "These are the options that can also be provided on the command
     line.",
     MENU {
	  {TT "--", "       -- ignore previous arguments after reloading data"},
	  {TT "-e x", "     -- evaluates the expression x"},
	  {TT "-h", "       -- displays the usage message"},
	  {TT "-n", "       -- print no input prompts"},
	  {TT "-q", "       -- suppresses loading of init file 'init.m2'"},
	  {TT "-s", "       -- stops execution if an error occurs"},
	  {TT "-silent", "  -- don't print the startup banner"},
	  {TT "-tty", "     -- assume stdin is a tty"},
	  {TT "-x", "       -- special mode for running examples"},
	  },
     TT "M2", " is actually a shell script which calls the executable file
     with appropriate arguments for loading the Macaulay 2 code previously
     compiled.",
     SEEALSO "initialization file"
     }

document { "the authors",
     "The authors of Macaulay 2 and the bulk of this manual:",
     MENU {
	  TO "Daniel R. Grayson",
	  TO "Michael E. Stillman"
	  },
     "Our co-author for the tutorials:",
     MENU {
	  TO "David Eisenbud",
	  }
     }

document { "David Eisenbud",
     "David Eisenbud ", TT "<de@cs.brandeis.edu>", ".",
     PARA,
     "In this spot will go a brief biography of David Eisenbud, a
     commutative algebraist and algebraic geometer at Brandeis University."
     }

document { "Daniel R. Grayson",
     "Daniel R. Grayson ", TT " <dan@math.uiuc.edu>", ".",
     PARA,
     "Daniel Grayson received his PhD in Mathematics from MIT in 1976, taught
     at Columbia from 1976 to 1981, and came to the University of Illinois at
     Urbana-Champaign in 1981, where he is a Professor.  His mathematical
     research concerns algebraic K-theory, but he has always been intrigued
     by computers.  In 1986 he joined with Stephen Wolfram and six other
     co-authors to write ", ITALIC "Mathematica", " which in the years since
     its introduction in 1988 has become the pre-eminent system for
     mathematics on the computer.",
     PARA,
     IMG "Grayson2.jpg"
     }

document { "Michael E. Stillman",
     "Michael E. Stillman ", TT "<mike@math.cornell.edu>", ".",
     PARA,
     "Michael E. Stillman received his PhD in Mathematics from Harvard in 1983,
     taught at University of Chicago 1983-85, was at Brandeis and then MIT 1985-87,
     and then came to Cornell University.  His mathematical research concerns
     computational algebraic geometry and algebraic geometry.  He started writing
     syzygy programs as an undergraduate at the University of Illinois, and from
     1983 to 1992 with David Bayer he wrote Macaulay, a specialized computer
     algebra system for algebraic geometry and the predecessor of this program."
     }

document { "how to get this program",
     "The program is available over the web at the Macaulay 2 home page",
     PARA, 
     HREF {"http://www.math.uiuc.edu/Macaulay2"}, 
     PARA, 
     "or by ftp to the host ", TT "ftp.math.uiuc.edu", " with user name ", TT "Macaulay2", " 
     and password ", TT "Macaulay2", ".  There you will find the documentation, both in
     readable form and available for downloading, the source code, ready for compiling
     on the machine of your choice, and various precompiled versions, ready to run."
     }

document { "syntax",
     "A newline ends a statement if it can, otherwise it acts like any
     white space.",
     EXAMPLE "2+\n3+\n4",
     PARA,
     "Parsing is determined by a triple of numbers attached to each token.
     The following table (produced by ", TO "seeParsing", "), displays each
     of these numbers.",
     EXAMPLE "seeParsing()",
     "Here is the way these numbers work.  The parser maintains a number
     which we will call the current parsing level, or simply, the level.
     The parser builds up an expression until it encounters an input token
     whose precedence is less than or equal to the current level.  The
     tokens preceding the offending token are bundled into an expression
     appropriately and incorporated into the containing expression.",
     PARA,
     "When an operator or token is encountered, its scope serves as the
     level for parsing the subsequent expression, unless the current level
     is higher, in which case it is used.",
     PARA,
     "Consider a binary operator such as * .  The relationship between
     its scope and its precedence turns out to determine whether a*b*c
     is parsed as (a*b)*c or as a*(b*c).  When the parser encounters
     the second *, the current parsing level is equal to the scope of
     the first *.  If the scope is less than the precedence, then
     the second * becomes part of the right hand operand of the
     first *, and the expression is parsed as a*(b*c).  Otherwise, the
     expression is parsed as (a*b)*c.",
     PARA,
     "For unary operators, the strength is used instead of the scope to reset
     the current level.  The reason for having both numbers is that some
     operators can be either unary or binary, depending on the context.
     A good example is ", TO "#", " which binds as tightly as ", TO ".", "
     when used as an infix operator, and binds as loosely as adjacency or
     function application when used as a prefix operator.",
     PARA,
     "To handle expressions like 'b c d', where there are no tokens present
     which can serve as a binary multiplication operator, after parsing b,
     the level will be set to 1 less than the precedence of an identifier,
     so that 'b c d' will be parsed as 'b (c d)'.",
     PARA,
     "The exclamation point is allowed as a unary operator either to the
     right or to the left of its operand.  The other unary operators occur
     to the left of their operands.",
     PARA,
     "Three operators are treated specially, in that the empty expression
     is allowed to the right of them.  These are newline, comma, and semicolon."
     }

document { "programming",
     "Here are some useful programming constructs for controlling the flow 
     of execution.",
     MENU {
	  (TO "apply", "  -- loop over a list, keeping results"),
	  (TO "if", "     -- condition testing"),
	  (TO "scan", "   -- loop over a list"),
	  (TO "while", "  -- loop control"),
	  (TO ";", "      -- statement separator")
	  },
     "Controlling the scope of variables:",
     MENU {
	  (TO ":=", "        -- assignment to and declaring a new local variable"),
	  (TO "global", "    -- using global symbols which have values"),
	  (TO "local", "     -- declaring new local symbols"),
	  (TO "quote", "     -- using symbols which have values")
	  },
     "Miscellaneous items:",
     MENU {
	  (TO "--", "                -- introducing comments"),
	  (TO "addEndFunction", "    -- do something upon exiting"),
	  (TO "addStartFunction", "  -- do something after loading dumped data"),
	  (TO "clearAll", "          -- release some memory"),
	  (TO "Command", "           -- top level commands"),
     	  (TO "erase", "             -- remove a symbol"),
	  (TO "evaluate", "          -- evaluate a string"),
	  (TO "memoize", "           -- memoizing functions"),
	  (TO "using methods", "     -- using methods"),
	  (TO "notImplemented", "    -- 'not implemented yet' error message"),
	  (TO "processArgs", "       -- process optional arguments to functions"),
	  (TO "protect", "           -- protecting the value of a symbol"),
	  (TO "setrecursionlimit", " -- limits on recursion depth"),
	  SHIELD {
	       (TO "syntax", "            -- the syntax of the language")
	       },
	  (TO "value", "             -- getting values of symbols")
	  },
     "For internal use only:",
     MENU {
	  (TO "lineNumber", "        -- the current line number"),
	  (TO "lookupCount", "       -- how many times a symbol has been seen"),
	  (TO "phase", "             -- internal variable for compilation"),
--	  (TO "readExamples", "      -- used to control compilation"),
	  (TO "runStartFunctions", " -- run the start functions")
--	  (TO "writeExamples", "     -- used to control compilation")
	  }
     }

-- document { quote readExamples,
--      TT "readExamples", " -- a variable used to control the compilation
--      of the interpreted code of the system.",
--      PARA,
--      SEEALSO "writeExamples"
--      }

-- document { quote writeExamples,
--      TT "writeExamples", " -- a variable used to control the compilation
--      of the interpreted code of the system.",
--      PARA,
--      SEEALSO "readExamples"
--      }

document { quote "shield",
     TT "shield x", " -- executes the expression x, temporarily
     ignoring interrupts."
     }

document { quote phase,
     TT "phase", " -- an internal variable indicating which phase of compilation we
     are in.",
     PARA,
     "The value 0 indicates that we are running as an interpreter, as usual.
     The value 1 indicates that we are loading setup.m2 and will dump data
     afterward.  The value 2 indicates that we are loading setup.m2, creating a
     preliminary version of the help file whose name is
     Macaulay2.pre, and creating example input files.  The value 3 indicates 
     that we are running an example input file, and referring to Macaulay2.pre.
     The value 4 indicates that we are loading setup.m2, reading the
     example output files, and creating the final version of the help file,
     called Macaulay2.doc.  The value 5 indicates that we are running the
     interpreter as usual, but reading the example output files when
     ", TO "document", " is used."
     }

document { quote lineNumber,
     TT "lineNumber()", " -- returns the current line number."
     }

document { quote backtrace,
     TT "backtrace()", " -- after an error, returns a list representing the
     steps in the computation that led to the error.",
     PARA,
     "The elements in the list are expressions that can be examined, or
     reevaluated with ", TO "expand", ", or are references to positions in the 
     source code.",
     PARA,
     "Bug: some of the expressions are reconstructed from the local variables
     of the function returning an error, so the parameters passed to the
     routine may have been replaced by new values.",
     SEEALSO {"Expression", "Position"}
     }

document { quote Position,
     TT "Position", " -- a type of list designed to represent a position
     in a file.",
     PARA,
     "It's implemented as a list whose three elements are the file name,
     the line number, and the column number."
     }

document { "debugging",
     "Here are some debugging tools.",
     MENU {
	  (TO "assert", "           -- insist on something"),
	  (TO "backtrace", "        -- trace the evaluation chain after an error"),
	  (TO "benchmark", "        -- benchmark some code"),
	  (TO "browse", "           -- examine a list or hash table"),
	  (TO "code", "             -- display source code for a function"),
	  (TO "edit", "             -- edit source code for a function"),
	  (TO "error", "            -- signalling an error"),
	  (TO "errorDepth", "       -- set the error depth"),
	  (TO "examine", "          -- examine socpes bound in a closure"),
	  (TO "flag", "             -- flag each use of a symbol"),
	  (TO "frame", "            -- get frame for a function closure"),
	  (TO "listUserSymbols", "  -- display global variables defined by user"),
     	  (TO "locate", "           -- locate the source code of a function"),
	  (TO "methods", "          -- find methods installed for a function"),
	  (TO "on", "               -- trace entry into a function"),
	  (TO "peek", "             -- print contents of something"),
	  (TO "profile", "          -- record run times for functions"),
	  (TO "shield", "           -- shield interpreted code from interrupts"),
	  (TO "try", "              -- catching errors"),
	  (TO "userSymbols", "      -- list global variables defined by user")
	  },
     "These functions are for debugging the kernel interpreter itself, and
     are not intended for users.",
     MENU {
	  (TO "buckets", "   -- display contents of buckets in a hash table"),
	  TO "seeParsing"
	  }
     }

document { quote flag,
     TT "flag x", " -- arranges for each subsequent reference to a
     symbol x to be flagged with a warning message."
     }

document { quote frame,
     TT "frame f", " -- provides the frame of values for local variables
     bound up in a function closure.",
     PARA,
     "This routine is provisional."
     }

document { quote examine,
     TT "examine ()", " -- list the sequence numbers for the scopes corresponding
     to the frames currently in use.", BR,NOINDENT, 
     TT "examine f", " -- display internal information about an interpreted 
     function ", TT "f", ".",BR,NOINDENT, 
     TT "examine x", " -- display internal information about a symbol ", TT "x", ".",
     PARA,
     "This function is intended for debugging the interpreter itself.",
     SEEALSO "debugging"
     }

document { quote seeParsing,
     TT "seeParsing()", " -- print the syntax table which governs parsing
     precedence."
     }

document { "subclass",
     "We say that a class X is a subclass of a class P if P is X, or
     P is the ", TO "parent", " of X, or P is the parent of the parent
     of X, and so on.  See also ", TO "classes", "."
     }

document { "classes",
     "Every thing ", TT "x", " belongs to a ", ITALIC "class", " ", TT "X", " -- a
     hash table that indicates in a weak sort of way what type of thing ", TT "x", "
     is.  We may also say that ", TT "x", " is an ", TO "instance", " 
     of ", TT "X", ".  The mathematical notion of a set ", TT "X", " and an
     element ", TT "x", " of ", TT "X", " can be 
     modeled this way.  The class of ", TT "x", " can be obtained with the function
     ", TO "class", ".",
     PARA,
     "Every thing ", TT "X", " also has a ", ITALIC "parent", " ", TT "P", ", which 
     indicates a larger class to which every instance ", TT "x", " of ", TT "X", " belongs.  We 
     also say that
     ", TT "X", " is a ", TO "subclass", " of P.  For example, the mathematical
     notion of a module P and a submodule ", TT "X", " may be modelled this way.
     The parent of ", TT "x", " can be obtained with the function ", TO "parent", ".",
     EXAMPLE {
	  "parent 2",
      	  "parent parent 2",
      	  "class 2",
      	  "parent class 2",
      	  "class class 2",
      	  "parent class class 2",
	  },
     PARA,
     "The classes and parents provide a uniform way for operations on
     things to locate the appropriate functions needed to perform them.
     Please see ", TO "using methods", " and ", TO "binary method", " now for a 
     brief discussion.",
     PARA,
     "For more details, see one of the topics below.",
     MENU {
	  TO "newClass",
	  TO "new",
	  TO "ancestor",
	  TO "instance"
	  },
     "For related topics, see one of the following.",
     MENU {
	  TO "use",
	  TO "uniform",
	  TO "Thing",
	  TO "Nothing",
	  TO "Type",
	  TO "MutableList",
	  TO "MutableHashTable",
	  TO "MutableHashTable",
	  TO "SelfInitializingType"
	  }
     }

document { quote instance,
     TT "instance(x,X)", " -- tells whether ", TT "x", " is an instance
     of the type ", TT "X", ".",
     PARA,
     "We say that x is an instance of X if X is the class of x, or a parent
     of the class of x, or a grandparent, and so on.",
     PARA,
     "See also ", TO "classes", ", ", TO "class", ", ", TO "parent", "."
     }

document { "mathematics",
     "Here we document the mathematical objects which form the heart of 
     the system.",
     MENU{
	  TO "combinatorial functions",
     	  TO "Set",
	  TO "Monoid",
	  TO "Ring",
	  TO "Ideal",
	  TO "Module",
	  TO "ModuleMap",
	  TO "Matrix",
	  TO "GradedModule",
	  TO "ChainComplex",
	  TO "GroebnerBasis",
	  TO "MonomialIdeal"
	  }
     }

document { "system",
     "Loading files:",
     MENU {
	  TO "autoload",
	  TO "initialization file",
	  TO "input",
	  TO "load",
	  TO "needs"
	  },
     "Dumping and restoring the state of the system:",
     MENU {
	  TO "dumpdata",
	  TO "loaddata",
	  TO "reloaded",
	  TO "restart",
	  TO "addStartFunction"
	  },
     "Interface to the operating system:",
     MENU{
	  TO "top level loop",
	  TO "alarm",
	  TO "currentDirectory",
	  TO "exec",
	  TO "exit",
	  TO "fork",
	  TO "getenv",
	  TO "processID",
	  TO "path",
	  TO "pathSeparator",
	  TO "quit",
	  TO "run",
	  TO "sleep",
	  TO "time",
	  TO "timing",
	  TO "tmpname",
	  TO "wait"
	  },
     "Variables with information about the state of the current process:",
     MENU {
	  TO "commandLine",
	  TO "environment",
	  TO "version"
	  },
     "Miscellaneous commands:",
     MENU {
	  TO "getWWW"
	  },
     "Dealing with the garbage collector:",
     MENU {
	  TO "collectGarbage"
	  }
     }

document { quote pathSeparator,
     TT "pathSeparator", " -- the character used under the current operating
     system to separate the component directory names in a file path.",
     PARA,
     "Under unix it is ", TT ///"/"///, ", and on a Macintosh it is
     ", TT ///":"///, "."
     }

document { quote alarm,
     TT "alarm n", " -- arrange for an interrupt to occur in ", TT "n", "
     seconds, cancelling any previously set alarm.",
     PARA,
     "If ", TT "n", " is zero, then no alarm is scheduled, and any
     previously scheduled alarm is cancelled.",
     PARA,
     "The value returned is the number of seconds  remaining  until  any
     previously  scheduled  alarm  was  due to be delivered, or
     zero if there was no previously scheduled alarm.",
     PARA,
     "This command could be used in concert with ", TO "try", " in order
     to abandon a computation that is taking too long.",
     PARA,
     "This command may interfere with ", TO "time", " on some systems,
     causing it to provide incorrect answers."
     }

document { "initialization file",
     "The file ", TT "init.m2", " is loaded automatically when the
     program is started.",
     PARA,
     "The file is sought in each of the directories of the ", TO "path", ",
     and also in the home directory of the user.",
     SEEALSO "load"
     }

document { quote Field,
     TT "Field", " -- the class of all fields.",
     PARA,
     "Some fields:",
     MENU {
	  TO "QQ",
	  TO "RR",
	  TO "CC"
	  },
     "Functions for creating fields:",
     MENU {
	  TO "frac",
	  TO "GF"
	  },
     "Functions that can be applied to fields and rings:",
     MENU {
	  TO "char",
	  TO "isField"
	  },
     EXAMPLE "isField (ZZ/101)",
     SEEALSO "coefficientRing"
     }

document { quote char,
     TT "char F", " -- returns the characteristic of the ring F.",
     PARA,
     "The key ", TO "char", " is used to store the characteristic
     in F after it has been computed."
     }

document { quote basictype,
     TT "basictype x", " -- yields a symbol representing the basic type of x.",
     PARA,
     "Every thing has basic type which tells what sort of thing it
     really is, internally.  It is not possible for the user to create 
     new basic types.",
     PARA,
     "The parent of a basic type is ", TO "Thing", ", and this property
     characterizes the basic types.",
     PARA,
     EXAMPLE "select(values symbolTable(), i -> parent value i === Thing)",
     SEEALSO "Thing"
     }

document { quote ++,
     TT "M ++ N", " -- direct sum for modules, matrices, or chain complexes and
     disjoint union for sets.",
     PARA,
     "The user may install ", TO {"binary method", "s"}, " for this operator with code
     such as ",
     PRE "         X ++ Y := (x,y) -> ...",
     "where ", TT "X", " is the class of ", TT "x", " and ", TT "Y", " is the
     class of ", TT "y", ".",
     PARA,
     MENU {
	  TO (quote ++,ChainComplex,ChainComplex),
	  TO (quote ++,Module,Module),
	  TO (quote ++, Set, Set)
	  },
     SEEALSO {"classes", "directSum"}
     }

document { quote @@,
     TT "f @@ g", " -- a binary operator used for composition of functions.",
     PARA,
     "If f and g are homomorphisms of modules, then f @@ g yields their
     composite as a homomorphism.",
     PARA,
     "The user may install other ", TO {"binary method", "s"}, " for this 
     operator with code such as ",
     PRE "         X @@ Y := (x,y) -> ...",
     "where ", TT "X", " is the class of ", TT "x", " and ", TT "Y", " is the
     class of ", TT "y", "."
     }

document { quote @,
     TT "x @ y", " -- a binary operator.",
     PARA,
     "This operator is right associative.",
     PARA,
     "The user may install ", TO {"binary method", "s"}, " for this operator 
     with code such as ",
     PRE "         X @ Y := (x,y) -> ...",
     "where ", TT "X", " is the class of ", TT "x", " and ", TT "Y", " is the
     class of ", TT "y", ".",
     }

document { quote \,
     TT ///x \ y///, " -- a binary operator used for function application.",
     PARA,
     "This operator is right associative.",
     PARA,
     "The user may install ", TO {"binary method", "s"}, " for this operator 
     with code such as ",
     PRE ///         X \ Y := (x,y) -> ...///,
     "where ", TT "X", " is the class of ", TT "x", " and ", TT "Y", " is the
     class of ", TT "y", "."
     }

document { (quote /, List, Function),
     TT "w / f", " -- apply the function ", TT "f", " to each member of the 
     list or sequence ", TT "w"," returning a list or sequence containing the 
     results.  The same as ", TT "apply(w,f)", ".",
     PARA,
     "This operator is left associative, which means that ", TT "w / f / g", "
     is interpreted as meaning ", TT "(w / f) / g", ".",
     EXAMPLE "{1,2,3} / (i -> i+1) / (j -> j^2)",
     SEEALSO {"apply", (quote \,Function, List)}
     }

document { (quote \,Function, List),
     TT ///f \ w///, " -- apply the function ", TT "f", " to each member of the 
     list or sequence ", TT "w"," returning a list or sequence containing the 
     results.  The same as ", TT "apply(w,f)", ".",
     PARA,
     "This operator is right associative, which means that ", TT ///g \ f \ w///, "
     is interpreted as meaning ", TT ///g \ (f \ w)///, ".",
     EXAMPLE ///(j -> j^2) \ (i -> i+1) \ {1,2,3}///,
     "The precendence is lower than that of ", TT "@@", ".  Hence, the following 
     two examples yield the same result.",
     EXAMPLE {
	  ///sin \ sin \ {1,2,3}///,
      	  ///sin @@ sin \ {1,2,3}///,
	  },
     SEEALSO {"apply", "@@", (quote /,List, Function)}
     }

document { quote String,
     TT "String", " -- the class of all strings.",
     PARA,
     "A string is thing which contains a sequence of characters (bytes).
     A string is normally entered as a sequence of characters surrounded 
     by double quotation marks.",
     PARA,
     EXAMPLE "\"abcd\"",
     PARA,
     "Newline characters can be included.  There are escape sequences which
     make it possible to enter special characters:",  PRE 
"        \\n             newline
        \\f             form feed
        \\r             return
        \\\\             \\ 
        \\\"             \"
        \\t             tab
        \\xxx           ascii character with octal value xxx",
     EXAMPLE {
	  "\"abc\\001\\002\\n\\f\\t\"",
      	  "ascii oo",
	  },
     PARA,
     "For an alternate method of entering strings which does not involve
     any escape sequences, see ", TO "///", ".",
     PARA,
     "Operations on strings:",
     MENU {
	  (TO "String # ZZ", " -- getting a character from a string"),
	  (TO quote #, " -- length of a string"),
 	  (TO (quote |, String, String), "        -- concatenation"),
 	  (TO "ascii", " -- ASCII conversion"),
 	  (TO "substring", " -- substring extraction"),
 	  (TO "concatenate", " -- concatenation"),
 	  (TO "characters", " -- extraction of characters"),
 	  (TO "transnet", "   -- convert integers into network order"),
	  (TO "match", "      -- match patterns")
 	  },
     SEEALSO "Net"
     }

document { "///",
     TT "/// a string ///", " -- a string.",
     PARA,
     "This method for entering a string involves no escape characters, so
     it can be used for easily inserting large chunks of text into a string
     without treating the characters ", TT "\\", " and ", TT "\"", " specially.",
     EXAMPLE {
	  "/// \\ \" ///",
      	  "ascii oo",
	  },
     SEEALSO "String"
     }

document { quote Net,
     TT "Net", " -- the class of all nets.",
     PARA,
     "A net is a generalization of a string which is designed to facilitate
     two-dimensional printing on ascii terminals.  It consists of a rectangular
     array of characters subdivided horizontally by an imaginary baseline.",
     PARA,
     "Operations on nets also accept strings by interpreting a string as a rectangle
     of height one with the baseline just below it.",
     PARA,
     "Multiple nets per line can be sent to an output file with ", TO "<<", "
     but care must be taken to use ", TO "endl", " to end lines, for nets with
     new line characters embedded in them will be displayed in an unexpected way.",
     PARA,
     "Warning: if so many characters are written to a file that an internal buffer
     is filled before the line ends or first net is seen, then the buffer will be 
     flushed, and writing a net subsequently will produce an unexpected result.",
     PARA,
     "Operations on nets:",
     MENU {
	  TO "horizontalJoin",
	  TO (quote |, String, String),
	  TO "verticalJoin",
	  TO (quote ||, Net, Net),
	  TO "width",
	  TO "height",
	  TO "depth",
	  TO (quote ^,Net, ZZ)
	  },
     "Formatting expressions:",
     MENU {
	  TO "net"
	  },
     SEEALSO "String"
     }

document { quote net,
     TT "net x", " -- format ", TT "x", " for printing.",
     PARA,
     "This function is the primary function called upon by ", TO "<<", " to
     format expressions for printing.  The default method provided by the
     system is to convert ", TT "x", " to an ", TO "Expression", " with 
     ", TO "expression", " and then to convert that to a net.",
     PARA,
     "A new method for formatting expressions of class ", TT "X", " may be
     installed by the user with code of the form ", TT "net X := x -> ...", ".
     The function provided by the user should return a net or a string.",
     PARA,
     "A string is formatted by wrapping it in quotation marks and converting
     nonprinting characters to escape sequences.  A net is formatted for printing
     by enclosing it in a box.",
     EXAMPLE {
	  "\"a string\"",
      	  "net \"a string\"",
	  },
     EXAMPLE {
	  "ZZ[x];",
      	  "x^2",
      	  "net x^2",
	  },
     EXAMPLE "code(net,List)",
     PARA,
     SEEALSO {"Net", "expression", "Expression", "Net"}
     }

document { quote horizontalJoin,
     TT "horizontalJoin(m,n,...)", " -- joins nets or strings by concatenating
     them horizontally.  The baselines in each of the nets are aligned
     appropriately.",
     PARA,
     "Nested sequences among the arguments are first spliced together.",
     PARA,
     "If there are no arguments, then the net returned has zero height and
     zero depth.  This might be unexpected.",
     SEEALSO {"Net", (quote |, String, String)}
     }

document { quote verticalJoin,
     TT "verticalJoin(m,n,...)", " -- joins nets or strings by concatenating
     them vertically.  The baseline in the result is the baseline of the
     first one.",
     PARA,
     "Nested sequences among the arguments are first spliced together.",
     PARA,
     "If there are no arguments, then the net returned has zero height and
     zero depth.  This might be unexpected.",
     SEEALSO {"Net", (quote ||, Net, Net)}
     }

document { (quote ^, Net, ZZ),
     TT "n^i", " -- elevates a net or string ", TT "n", " by raising its
     characters by ", TT "i", " rows.",
     PARA,
     "The number ", TT "i", " may be negative, in which case the net is
     lowered.",
     PARA,
     "If ", TT "n", " is a string, then ", TT "n^0", " is an easy way to convert
     it to a net."
     }

document { quote width,
     TT "width f", " -- determines the width of the terminal associated to an
     output file ", TT "f", ", if any.", BR,NOINDENT, 
     TT "width n", " -- the width of a net ", TT "n", ".",
     SEEALSO {"Net", "File"}
     }

document { quote height,
     TT "height n", " -- the height of a net ", TT "n", ".",
     PARA,
     "The height of a net is the number of rows of characters it has above
     the baseline.  It may be a negative number, but the depth plus the 
     height is always the total number of rows, which is not negative.",
     SEEALSO {"Net", "depth"}
     }

document { quote depth,
     TT "depth n", " -- the depth of a net ", TT "n", ".",
     PARA,
     "The depth of a net is the number of rows of characters it has below
     the baseline.  It may be a negative number, but the depth plus the 
     height is always the total number of rows, which is not negative.",
     SEEALSO {"Net", "height"}
     }

document { "String # ZZ",
     TT "s#i", " -- produce the i-th character from a string s.",
     PARA,
     "If i is negative and the length of the string is n, then
     the (n-i)-th character is provided.",
     PARA,
     SEEALSO "String"
     }

document { quote class,
     TT "class x", " -- yields the class of x.",
     PARA,
     SEEALSO "classes"
     }

document { "assignment",
     MENU {
     	  (TO "=", "   -- assignment"),
     	  (TO ":=", "  -- assignment to a new local variable, or 
	       installation of a method"),
     	  (TO "<-", "  -- assignment via overlay")
	  }
     }

document { "comparison",
     MENU {
	  (TO "===", "        -- strict equality"),
	  (TO "=!=", "        -- strict inequality"),
	  (TO "==", "         -- equality"),
	  (TO "!=", "         -- inequality"),
	  (TO "<", "          -- less than"),
	  (TO "<=", "         -- less than or equal"),
	  (TO ">", "          -- greater than"),
	  (TO ">=", "         -- greater than or equal"),
	  (TO "?", "          -- comparison")
	  }
     }

document { "combinatorial functions",
     MENU {
	  (TO "random", "               -- random real number or integer"),
	  (TO "binomial", "             -- binomial coefficients"),
	  (TO "subsets", "              -- subsets"),
	  (TO "tally", "                -- tally occurrences in a list"),
	  (TO "partitions", "           -- partitions of an integer")
	  }
     }

document { quote hash,
     TT "hash x", " -- returns the hash code of x.",
     PARA,
     "The hash code of x is an integer produced in a deterministic way
     from x, and perhaps from the hash codes of the contents of x.
     See ", TO "hashing", " for a discussion of the requirements that
     the hash codes used here are designed to satisfy."
     }

document { "hashing",
     "A hash table contains a set of key-value pairs.  The access
     functions for hash tables accept a key and retrieve the
     corresponding value.  Here are the details, together with a
     discussion of how we designed the hash table system seen in
     Macaulay 2.",
     PARA,
     "The keys and values are stored in the hash table.  The hash table consists
     of a certain number of ", ITALIC "buckets", ", each of which can hold an
     arbitrary number of key-value pairs.  The number of buckets is chosen
     to be large enough that typically one may expect each bucket to hold fewer than
     three key-value pairs.  The key is used  as follows to determine in which
     bucket the key-value pair is to be stored.  The function ", TO "hash", " 
     is applied to the key to produce in a deterministic way an integer called
     the hash-code, and the remainder of the hash-code upon division by the
     number of buckets tells which bucket will be used.",
     PARA,
     "It is ", BOLD "essential", " that the
     hash code of a key never change, for otherwise the next 
     attempt to find the key in the hash table have an unpredictable 
     result - the new hash code of the key may or may not lead to 
     the same bucket, and the value may or may not be located.",
     PARA,
     "Some hash tables and lists are ", TO "mutable", ", i.e., their 
     contents can be altered by assignment statements.  As explained
     above, the hash code of a mutable thing is not permitted to
     change when the contents of the thing change.  Hence, the 
     algorithm for computing the hash code may not refer to the
     contents of a mutable thing.",
     PARA,
     "The strong comparison operator ", TO "===", " is provided to 
     parrot the equality testing that occurs implicitly when 
     accessing a key in a hash table.  The fundamental requirement for this
     strong comparison operator is that things with different hash codes must also
     turn out to be different when tested with this comparison operator.",
     PARA,
     "Here we come to a question of design.  As discussed above, we must assign
     hash codes to mutable things in such a way that the hash codes don't depend
     on their contents.  We can do this in various ways.",
     MENU {
	  {
     	       "One way to assign hash codes to mutable things is to give 
     	       the same hash code, say 1000000, to every mutable thing.  We
	       could then implement a strong comparison operator for mutable
	       things which would proceed by examining the contents of the
	       things, so that two mutable things would be equal if and only
	       if their contents were equal.  A
	       disadvantage of this approach would be that a hash table in
	       which many mutable things appear as keys would have all of those
	       key-value pairs appearing in the same bucket, so that access
	       to this hashtable would be slow.  (Each bucket is implemented
	       as a linear list, and searching a long linear list is slow.)"
	       },
	  {
     	       "Another way to assign hash codes to mutable things is to
     	       give different hash codes to each mutable thing; for example, the 
	       first mutable thing could receive hash code 1000000, the second
	       could receive the hash code 1000001, and so on.  (Another
     	       choice for such a hash code is the 
     	       address in memory of the thing.  But this address can change
     	       depending on environmental factors not under the control of the
     	       interpreter, and thus lead to unpredictable behavior.)
	       A disadvantage
	       of this approach is that the strong comparison operator could not
	       examine the contents of mutable objects!  (Remember that
	       if the hash codes are different, the strong comparison must declare
	       the things to be different, too.)  The offsetting advantage is
	       that a hash table in which many mutable things appear as keys would
	       typically have the key-value pairs distributed among the buckets,
	       so that access to this hashtable would be fast."
	       }
	  },
     PARA,
     "In Macaulay 2, we chose the second approach listed above; we expect to
     have many mutable things appearing as keys in hash tables, and we need
     the speed.  A counter
     with initial value 1000000 is incremented each time a mutable thing is
     created, and its value is taken as the hash code of the thing and stored
     within it.  The strong comparison test cannot depend on the contents of
     mutable things, and thus we may call such things ", TO "enclosed", ".
     For mutable things, the test for equality must be the same as equality
     of the hash codes.",
     PARA,
     "It is essential to have some hash tables for which equality amounts
     to equality of the contents.  This cannot be achieved for mutable
     hash tables, but we do achieve it for non-mutable hash tables -- the
     hash code is computed directly from the contents
     of the thing in a deterministic way.  This allows us to
     implement the notion of polynomial, say, as a hash table -- the 
     keys can be the monomials (necessarily non-mutable) and the 
     values can be the coefficients.  The notion of monomial can be
     implemented as a hash table where the keys are the variables and the
     values are the corresponding exponents.",
     PARA,
     "One further comforting remark: the routines that compute hash 
     codes or strong equality do not get into infinite loops, despite 
     the existence of circular structures: any circular structure 
     must come into being by means of changing something, and
     so the circular loop in the structure necessarily involves a 
     mutable thing, whose contents are not examined by the routines.
     This is another argument in favor of taking the second approach listed
     above.",
     SEEALSO "HashTable"
     }

document { quote remove,
     TT "remove(x,k)", " -- removes the entry stored in the hash table ", TT "x", "
     under the key ", TT "k", ".",
     PARA,
     SEEALSO "HashTable"
     }

document { "top level loop",
     "The top level evaluation loop of the interpreter contains hooks so the user can
     control how printing of the results of evaluation is done.  If the result is 
     ", TO "null", " then nothing is printed.  Otherwise, the appropriate method
     associated with the symbol ", TO "Print", " is applied to perform the printing,
     unless the printing is to be suppressed, as indicated by a semicolon at the end
     of the statement, in which case the ", TO "NoPrint", " method is applied.",
     MENU {
	  TO "Print",
	  TO "NoPrint"
	  }
     }

document { "lists, arrays, and sequences",
     "A sequence is created by separating expressions by commas (see ", TO ",", ").
     The class of all sequences is ", TO "Sequence", ".",
     PARA,
     EXAMPLE "t = (3,4,5)",
     "The length can be obtained with the prefix operator ", TO "#", ".",
     EXAMPLE "# t",
     PARA,
     "Sequences of length zero and one cannot be created with commas,
     so there are special constructions for them.  Use ", TO "seq", " to
     create a sequence of length one, and ", TO "()", " to create a sequence
     of length zero.",
     PARA,
     EXAMPLE {
	  "u = ()",
      	  "# u",
	  },
     EXAMPLE {
	  "v = seq 45",
      	  "# v",
	  },
     PARA,
     "A list is created by surrounding a sequence with braces.
     Use ", TO "{}", " to create a list of length zero.
     The class of all lists is ", TO "List", ".",
     EXAMPLE {
	  "w = {3,4,5}",
      	  "# w",
      	  "# {}",
	  },
     PARA,
     "The elements of a list can be lists or sequences.",
     EXAMPLE {
	  "x = {(3,4,5)}",
      	  "# x",
      	  "y = {(3,4,5),7}",
      	  "# y",
	  },
     PARA,
     "Lists can be used as vectors.",
     EXAMPLE "10000*{3,4,5} + {1,2,3}",     
     "A table is a list whose elemensts are lists all of the same length.  
     The inner lists are regarded as rows when the table is displayed as a
     two-dimensional array.",
     PARA,
     EXAMPLE {
	  "z = {{a,1},{b,2},{c,3}}",
      	  "new MatrixExpression from z",
	  },
     PARA,
     "An array is created by surrounding a sequence with brackets.
     Use ", TO "[]", " to create a list of length zero.
     Arrays and lists are a type of basic list, which means that the class
     ", TO "Array", " of all arrays and the class ", TO "List", " of all 
     lists have a class called ", TO "BasicList", " as parent.",
     EXAMPLE {
	  "f = {3,4,5}",
      	  "class f",
      	  "parent class f",
      	  "f = [3,4,5]",
      	  "class f",
      	  "parent class f",
	  },
     "Omitting an element of a sequence, list, or array, causes the
     symbol ", TO "null", " to be inserted in its place.",
     PARA,
     EXAMPLE "g = (3,4,,5)",
     PARA,
     "Sequences are used for calling functions with multiple arguments.
     One calls a function with the notation ", TT "f(x,y,z)", "; here you may 
     think of ", TT "x", ", ", TT "y", ", and ", TT "z", " as three arguments to ", TT "f", ", or you may 
     regard the sequence ", TT "(x,y,z)", " as a single argument of ", TT "f", ".
     For the former, the function ", TT "f", " will be of the following form.",
     PRE "          (a,b,c) -> ...",
     "For the latter, one takes f of the following form.",
     PRE "                t -> ...",
     "Types of list:",
     MENU {
	  TO "Array",
	  TO "BasicList",
	  TO "List",
	  TO "MutableList"
	  },
     "Creating new lists or sequences:",
     MENU {
	  TO "..",
	  TO (quote :, ZZ, Thing),	  -- was ":"
	  TO "toList",
	  TO "newClass",
	  TO "seq",
	  TO "sequence"
	  },
     "Selecting elements of lists:",
     MENU {
	  TO (quote _, List, ZZ),
	  TO quote #,
	  TO "first",
	  TO "last"
	  },
     "Manipulating lists:",
     MENU {
	  TO "accumulate",
 	  TO "append",
	  TO "between",
	  TO "copy",
	  TO "deepSplice",
	  TO "delete",
	  TO "drop",
     	  TO "join",
	  TO "mingle",
 	  (TO "pack", "       -- pack a list into a table"),
	  TO "prepend",
	  TO "reverse",
	  TO "rsort",
	  TO "sort",
	  TO "splice",
	  TO "take",
	  TO "unique",
	  TO "toSequence"
	  },
     "Examining lists:",
     MENU {
	  TO "all",
	  TO "any",
	  {TO quote #, " -- length of a list"},
	  TO "max",
	  TO "maxPosition",
	  TO "member",
	  TO "min",
	  TO "minPosition",
	  TO "position",
	  TO "same"
	  },
     "Combining lists:",
     MENU {
	  TO "demark",
	  TO "fold",
	  TO "mergePairs"
	  },
     "Mapping functions:",
     MENU {
	  (TO "apply", "      -- apply function to entries in list or hash table"),
 	  (TO "applyTable", " -- apply a function to entries in a table"),
	  TO "number",
	  TO "product",
	  TO "scan",
	  TO "select",
 	  (TO "subtable", "   -- extract a subtable"),
	  TO "sum",
 	  (TO "table", "      -- make a table")
	  }
     }

document { quote BasicList,
     TT "BasicList", " -- the class of all things represented internally as a
     list.  A list is a sequence of expressions indexed by integers
     0, 1, ..., N-1, where N is the length of the sequence.",
     PARA,
     "The reason for distinguishing ", TO "List", " from ", TO "BasicList", "
     is so lists can be treated as vectors, without everything else
     implemented as a basic list inheriting that behavior.",
     PARA,
     SEEALSO {"List", "lists, arrays, and sequences"}
     }

document { quote toSequence,
     TT "toSequence x", " -- yields the elements of a list x as a sequence.",
     PARA,
     "If x is a sequence, then x is returned.",
     PARA,
     EXAMPLE {
	  "toSequence {1,2,3}",
      	  "toSequence (1,2,3)"
	  },
     }

document { quote Boolean,
     TT "Boolean", " -- the class whose two members are ", TO "true", " and
     ", TO "false", ".",
     PARA,
     "Predicate functions return these as values, and the logical connectives 
     expect to receive them as arguments.",
     PARA,
     EXAMPLE "3 == 4",
     PARA,
     "Boolean constants:",
     MENU {
	  TO "false",
	  TO "true"
	  },
     PARA,
     "Functions dealing with truth values.",
     MENU {
	  (TO "not", "     -- negation"),
	  (TO "and", "     -- conjunction"),
	  (TO "or", "      -- disjunction"),
	  (TO "if", "      -- condition testing"),
	  (TO "select", "  -- selection of elements"),
	  (TO "while", "   -- loop control")
	  }
     }

document { "numbers",
     "There are four types of numbers:",
     MENU {
	  (TO "CC", " -- the class of complex numbers."),
	  (TO "QQ", " -- the class of rational numbers."),
	  (TO "RR", " -- the class of real numbers."),
	  (TO "ZZ", " -- the class of integers.")
	  },
     "Operations on numbers:",
     MENU {
	  TO "arithmetic functions",
	  TO "integrate",
	  TO "transcendental functions"
	  },
     "Standard predefined numbers:",
     MENU {
          (TO "pi", " -- pi."),
          (TO "ii", " -- the square root of -1.")
	  },
     "Some other quantities which are not quite numbers:",
     MENU {
	  TO "infinity",
	  TO "-infinity",
	  TO "indeterminate"
	  }
     }

document { quote Symbol,
     TT "Symbol", " -- denotes the class of all symbols.",
     PARA,
     "Symbols are entered as an alphabetic character followed by a
     sequence of alphanumeric characters; case is significant.
     The single quote character ' is regarded as alphabetic, so that
     symbols such as ", TT "x'", " may be used.",
     PARA,
     "Symbols are used as names for values to be preserved, as indeterminates
     in polynomial rings, and as keys in hash tables.  They may have
     global scope, meaning they are visible from every line of code,
     or local scope, with visibility restricted to a single file or
     function body.",
     PARA,
     EXAMPLE "ab12345cde",
     PARA,
     SEEALSO {"symbolTable", "local", "global", "quote", ":="}
     }

document { quote File,
     TT "File", " -- the class of all files.",
     PARA,
     "Files may be input files, output files, pipes, or sockets.
     The class of all files is ", TO "File", ".",
     PARA,
     "Some standard files, already open:",
     MENU {
          (TO "stdin", "    -- standard input file"),
          (TO "stdout", "   -- standard output file"),
          (TO "stderr", "   -- standard error output file")
	  },
     "Ways to create new files:",
     MENU {
          (TO "openIn", "   -- open an input file"),
          (TO "openOut", "  -- open an output file")
	  },
     "Input operations:",
     MENU {
          (TO "getc", "     -- get one character from a file"),
          (TO "get", "      -- get contents of a file"),
	  (TO "read", "     -- get some bytes from a file")
	  },
     "Further processing for data obtained from a file:",
     MENU {
          (TO "lines", "    -- split a string into lines")
	  },
     "Output operations:",
     MENU {
          (TO "<<", "         -- print to file"),
	  (TO "endl", "       -- end a line"),
          (TO "flush", "      -- flush a file"),
	  -- (TO "netscape", "   -- call netscape to display an expression"),
	  (TO "printString", "  -- print a generalized string"),
          (TO "print", "      -- print an expression on a line"),
	  (TO "TeX", "        -- call TeX to display an expression")
	  },
     "Preparing expressions for output:",
     MENU {
          TO "columnate",
	  TO "expression",
	  TO "format",
          TO "name",
          {TO "null", "     -- a symbol which doesn't print"},
          TO "pad",
          TO "string",
	  TO "tex",
	  TO "toString"
	  },
     "Destroying files:",
     MENU {
          {TO "close", "    -- close a file"}
	  },
     "Information about files",
     MENU { 
	  {TO "width", "    -- width of a terminal"},
          {TO "openFiles", "-- list open files"}
	  },
     }

document { quote printString,
     TT "printString(o,s)", " -- send the string ", TT "s", " to the output file ", TT "o", ".",
     PARA,
     "The argument ", TT "s", " may also be a sequence or list, in which case
     its elements are printed.  If an integer is encountered, then
     it specifies a number of spaces to be printed.  If a symbol
     or indeterminate is encountered, its name is printed.  If ", TT "null", "
     is encountered, nothing is printed.",
     PARA,
     EXAMPLE ///printString(stdout, (a,10,"b",20,c))///
     }

document { "help functions",
     "Online Macaulay 2 documentation is stored in ", TO "hypertext", "
     form.",
     PARA,
     NOINDENT,
     "Functions for accessing the documentation:",
     MENU {
	  TO "apropos",
	  TO "doc",
	  TO "examples",
	  TO "help", 
	  TO "topicList", 
	  TO "topics"
	  },
     "How to write documentation yourself:",
     MENU {
	  TO "document",
	  TO "hypertext",
	  TO "html",
	  TO "text"
	  },
     "Some internals:",
     MENU {
	  TO "Documentation",
	  TO "phase",
	  },
     SEEALSO "reading the documentation"
     }

document { "arithmetic functions",
     "These arithmetic functions act on numbers, but some of them
     are also act on more abstract entities, such as polynomials.",
     MENU {
	  (TO "+", "          -- addition"),
	  (TO "plus", "       -- addition"),
	  (TO "-", "          -- subtraction and minus"),
	  (TO "minus", "      -- minus"),
	  (TO "difference", " -- subtraction"),
          (TO "*", "          -- multiplication"),
          (TO "times", "      -- multiplication"),
          (TO "/", "          -- division"),
          (TO "//", "         -- quotient"),
          (TO "%", "          -- remainder"),
	  (TO "mod", "        -- reduction modulo n"),
          (TO "^", "          -- power"),
          (TO "power", "      -- power"),
          (TO "!", "          -- factorial"),
          (TO "xor", "        -- bitwise EXCLUSIVE OR of two integers"),
          (TO "&", "          -- bitwise AND of two integers"),
          (TO "|", "          -- bitwise OR of two integers"),
          (TO "<<", "         -- shift bits"),
          (TO ">>", "         -- shift bits"),
          (TO "gcd", "        -- greatest common divisor"),
          (TO "odd", "        -- predicate for odd integers"),
          (TO "even", "       -- predicate for even integers"),
          (TO "floor", "      -- floor"),
	  (TO "isPrime", "    -- primality test"),
	  (TO "factor", "     -- factor"),
          (TO "Numeric", "    -- numeric conversion")
	  }
     }

document { "transcendental functions",
     MENU {
	  (TO "abs", "   -- absolute value"),
	  (TO "sin", "   -- sine"),
	  (TO "cos", "   -- cosine"),
	  (TO "tan", "   -- tangent"),
	  (TO "asin", "  -- arcsine"),
	  (TO "acos", "  -- arccosine"),
	  (TO "atan", "  -- arctangent"),
	  (TO "sinh", "  -- hyperbolic sine"),
	  (TO "cosh", "  -- hyperbolic cosine"),
	  (TO "tanh", "  -- hyperbolic tangent"),
	  (TO "exp", "   -- exponential"),
	  (TO "log", "   -- logarithm"),
	  (TO "sqrt", "  -- square root")
	  }
     }

document { quote mutable,
     TT "mutable x", " -- returns true or false, depending on whether x is mutable.",
     PARA,
     "If x is a hash table, list, or database, then it's mutable if its contents
     can be destructively altered.",
     PARA,
     "If x is a symbol, then it's mutable if a value can be assigned to
     it. (See ", TO "protect", ".)",
     PARA,
     "If x is anything else, then it isn't mutable.",
     PARA,
     "The contents of a mutable hash table do not participate in strong comparison
     with ", TO "===", " or in ", TO "hashing", ".",
     SEEALSO {"MutableList", "MutableHashTable"}
     }

document { "()",
     TT "()", " -- represents a sequence of length zero.",
     PARA,
     "See also ", TO "lists, arrays, and sequences", "."
     }

document { "[]",
     TT "[]", " -- used for constructing arrays.",
     PARA,
     "See ", TO "lists, arrays, and sequences", "."
     }

document { "{}",
     TT "{}", " -- used for constructing lists.",
     PARA,
     "See ", TO "lists, arrays, and sequences", "."
     }

oldexit := exit
erase quote exit
exit = method(SingleArgumentDispatch => true)
exit ZZ := i -> oldexit i
exit Sequence := () -> oldexit 0
exit = new Command from exit
quit = new Command from (() -> oldexit 0)

document { quote exit,
     TT "exit n", " -- terminates the program and returns n as return code.",BR,
     NOINDENT, 
     TT "exit", " -- terminates the program and returns 0 as return code.",
     PARA,
     "Files are flushed and closed.  Another way to exit is to type the end of
     file character, which is typically set to Control-D in unix systems, and is
     Control-Z under MS-DOS.",
     SEEALSO "quit"
     }

document { quote quit,
     TT "quit", " -- terminates the program and returns 0 as return code.",
     PARA,
     "Files are flushed and closed.  Another way to exit is to type the end of
     file character, which is typically set to Control-D in unix systems, and is
     Control-Z under MS-DOS.",
     SEEALSO "exit"
     }

document { quote fork,
     TT "fork()", " -- forks the process, returning the process id of the child
     in the parent, and returning 0 in the child."
     }

document { quote sleep,
     TT "sleep n", " -- sleeps for n seconds."
     }

document { quote processID,
     TT "processID()", " -- returns the process id of the current Macaulay 2 process."
     }

document { quote string,
     TT "string x", " -- convert x to a string unless it is one already.",
     PARA,
     "Not intended for general use, as it is primitive, and doesn't display
     contents or names, for example.  Use ", TO "name", " instead."
     }

document { quote BinaryPowerMethod,
     TT "BinaryPowerMethod(x,n)", " -- computes x^n using successive squaring",
     PARA,
     "The technique depends in a standard way on the binary expansion of n,
     hence the name.",
     PARA,
     SEEALSO "SimplePowerMethod"
     }

document { quote SimplePowerMethod,
     TT "SimplePowerMethod(x,n)", " -- computes x^n using repeated multiplication",
     PARA,
     SEEALSO "BinaryPowerMethod"
     }

document { quote dumpdata,
     TT "dumpdata s", " -- dump all data segments for the current process to 
     the file whose name is stored in the string s.",
     PARA,
     "This effectively saves the entire state of the system, except that the
     input buffer for the file ", TO "stdin", " appears to have been emptied,
     and care is taken so that the environment and the command line arguments
     maintain their new values when the data is reloaded later with 
     ", TO "loaddata", "."
     }
document { quote loaddata,
     TT "loaddata s", " -- load all data segments for the current process from 
     the file whose name is stored in the string s.  The file must have been
     created with ", TO "dumpdata", " and the same version of Macaulay 2.",
     PARA,
     "The file should have been created with ", TO "dumpdata", ".  Everything will
     be returned to its former state except:",
     MENU {
	  {TO "reloaded", ", which counts how many times data has been 
	       dumped and restored."},
	  {TO "environment", ", which now reflects the current environment."},
	  {TO "commandLine", ", which now reflects the current command line."},
	  "Whether the standard input is echoed and prompts to the 
	  standard output are properly flushed, which depends on whether 
	  the standard input is a terminal."
	  },
     "After the data segments have been reloaded, the command line arguments
     will be dealt with in the usual way, except that only the arguments
     after the i-th '--' and before the i+1-st '--' (if any) will be considered,
     where i is the current value of ", TO "reloaded", ".",
     SEEALSO {"listUserSymbols"}
     }
     
document { quote reloaded,
     TT "reloaded", " -- a constant whose value is the number of 
     times ", TO "loaddata", " has been executed by the current process.  Since
     loaddata completely resets the state of the system, something like this
     is needed."
     }

document { quote buckets,
     TT "buckets x", " -- returns a list of the buckets used internally in an 
     hash table x.",
     PARA,
     "Each bucket is represented as a list of key/value pairs."
     }

document { quote ggPush,
     TT "ggPush h", " -- provides a string which when sent to the engine will
     cause it to push the object ", TT "h", " onto the engine's stack.",
     PARA,
     "This command is intended for internal use only.",
     PARA,
     "Warning: in an expression of the form ", TT "ggPush f()", " where ", TT "f", "
     is a function that returns an object with a handle, there is no pointer to
     the object retained in the string provided, so the garbage collector may
     cause the object and its handle to be freed before the arrival of the
     command!  The solution is to store the result in a local variable until
     the command has been sent."
     }

document { quote identity,
     TT "identity x", " -- returns x.",
     PARA,
     "This is the identity function."
     }

document { quote modulus,
     TT "modulus", " -- a key used in quotient rings of the form ZZ/n to store 
     the number n.",
     PARA,
     "This may go away when more general quotient rings are working."
     }

if class XCreateWindow === Function then (
document { quote XCreateWindow,
     TT "XCreateWindow(pid,x,y,a,b,w,n)", " -- makes a new window.",
     PARA,
     "Here pid is the id of the parent window, x and y are the coordinates
     of the upper left corner of the window, a and b are the width and
     height, w is the width of the border, and n is the name of the window."
     }
) else erase quote XCreateWindow

if class XDefaultRootWindow === Function then (
document { quote XDefaultRootWindow,
     TT "XDefaultRootWindow()", " -- returns the id of the root window."
     }
) else erase quote XDefaultRootWindow

document { quote format,
     TT "format s", " -- prepare a string s for output by converting nonprintable
     characters to printable ones, or to escape sequences."
     }


document { quote generatorSymbols,
     TT "generatorSymbols", " -- a key used in a ", TO "Monoid", " under which is stored a list
     of the symbols used as generators for the monoid."
     }

document { quote match,
     TT "match(s,p)", " -- whether the string s matches the pattern p.",
     PARA,
     "The pattern p may contain '*'s, which serve as wild card characters.
     This is provisional - eventually it will provide regular expression
     matching."
     }

document { quote gg,
     TT "gg x", " -- converts an integer, handle, or list of integers to the format
     required for communication with the engine.",
     PARA,
     "See also ", TO "engine communication protocol", "."
     }

document { quote pairs,
     TT "pairs x", " -- makes a list of all key/value pairs (k,v) in
     a hash table x.",
     PARA,
     EXAMPLE "scan(pairs Nothing, print)"
     }

document { quote sequence,
     TT "sequence v", " -- returns v if v is a sequence, otherwise makes
     a sequence of length one containing v.",
     PARA,
     EXAMPLE {
	  "sequence 4",
      	  "sequence {4,5}",
      	  "sequence (4,5)",
	  },
     PARA,
     "See also ", TO "seq", " and ", TO "lists, arrays, and sequences", "."
     }

document { quote xor,
     TT "xor(i,j)", " -- produces the bitwise logical exclusive-or of
     the integers i and j.",
     PARA,
     EXAMPLE "xor(10,12)"
     }

document { quote mingle,
     TT "mingle {v,w,...}", " -- produces a new list from the lists or
     sequences v,w,... by taking the first element from each, then the second, 
     and so on.",
     PARA,
     TT "mingle (v,w,...)", " -- does the same.",
     PARA,
     "When one of the lists is exhausted, it is ignored.",
     PARA,
     EXAMPLE {
	  "mingle({1,2,3,4},{a},{F,F,F,F,F,F,F,F,F,F})",
      	  "concatenate mingle( apply(5,name) , apply(4,i->\",\") )",
      	  "pack(mingle {{1,2,3},{4,5,6}}, 2)"
	  }
     }

document { quote SelfInitializingType,
     TT "SelfInitializingType", " -- the class of all self initializing types.",
     PARA,
     "A self initializing type X will produce an instance of X from
     initial data v with the expression 'X v'.",
     PARA,
     EXAMPLE {
	  "X = new SelfInitializingType of BasicList",
      	  "x = X {1,2,3}",
      	  "class x",
	  },
     PARA,
     TO "Command", " is an example of a self initializing type."
     }

document { quote Manipulator,
     TT "Manipulator", " -- the class of all file manipulators.",
     PARA,
     "A ", TT "Manipulator", " is a type of list which, when put out to
     a file with ", TO "<<", " causes a particular function to be applied
     to the file.",
     PARA,
     "Examples:",
     MENU { 
	  TO "endl",
	  TO "flush",
	  TO "close"
	  }
     }

document { quote close,
     TT "f << close", " -- closes the file f.",
     BR,
     "close f -- closes the file f.",
     PARA,
     "In the case of an output file, any buffered output is first
     written to the file, and the return value is an integer,
     normally 0, or -1 on error, or the return status of the child
     process in case the the file was a pipe.",
     PARA,
     SEEALSO {"File", "Manipulator"}
     }

document { quote flush,
     TT "f << flush", " -- writes out any buffered output for the output file f.",
     PARA,
     SEEALSO {"File", "Manipulator"}
     }

document { quote endl,
     TT "f << endl", " -- ends the line currently being put out to the
     file ", TT "f", ".",
     PARA,
     "It is an essential portable programming practice to use ", TT "endl", "
     always, for writing newline characters (see ", TO "newline", ") to a
     file will not terminate a line containing nets properly,
     and it will not flush the output buffer.",
     PARA,
     SEEALSO {"File", "Manipulator", "Net"}
     }

document { quote newline,
     TT "newline", " -- a string containing the character or sequence of
     characters which represents the end of a line.  To end an output line,
     you should use ", TO "endl", " instead, because there is more to 
     ending an output line than emitting the characters in ", TT "newline", ",
     especially when nets are being used.",
     PARA,
     "This string depends on what your operating system is: on Unix systems
     it is the ascii character 10; on Macintoshes it is the ascii character
     13, and under MS-DOS and Windows 95 it is a string of length 2 containing
     ascii characters 13 and 10.",
     PARA,
     "Try to avoid confusing the newline string described here with the
     ASCII character called ", TT "newline", ".  That character can be
     incorporated into a string with the escape sequence ", TT "\\n", ",
     and it always has ASCII code 10.",
     EXAMPLE ///ascii "\n"///,
     SEEALSO "Net"
     }

document { quote linkFilename,
     TT "linkFilename s", " -- convert a string s into a string which can be
     used as a file name to contain HTML about the topic referred
     to by s.",
     PARA,
     "The value returned is a sequence number, and hence may not be
     the same in subsequent sessions.  Hence this is mainly useful
     for creating html for all the online documentation, and the general 
     user will not find it useful.",
     PARA,
     SEEALSO "linkFilenameKeys"
     }

document { quote linkFilenameKeys,
     TT "linkFilenameKeys()", " -- returns a list of the strings which
     have been given to ", TO "linkFilename", ".",
     PARA,
     "This function is intended mainly for internal use in generating
     the documentation for Macaulay 2."
     }

document { quote collectGarbage,
     TT "collectGarbage()", " -- attempt a garbage collection.",
     PARA,
     SEEALSO "GC garbage collector"
     }

document { "apply(Set,Function)",
     TT "apply(x,f)", " -- apply a function ", TT "f", " to each element of a
     ", TO "Set", " ", TT "x", ", producing a new set.",
     PARA,
     EXAMPLE {
	  "x = set {1,2,3}",
      	  "apply(x,x -> x^2)"
	  }
     }

document { quote lookupCount,
     TT "lookupCount s", " -- the number of times the symbol s has been
     encountered in source code presented to the interpreter."
     }

document { quote version,
     TT "version", " -- a hash table describing this version of the program.",
     PARA,
     EXAMPLE "version"
     }

document { quote Database,
     TT "Database", " -- the class of all database files.",
     PARA,
     EXAMPLE {
	  ///filename = tmpname "test.dbm"///,
      	  ///x = openDatabaseOut filename///,
      	  ///x#"first" = "hi there"///,
      	  ///x#"first"///,
      	  ///x#"second" = "ho there"///,
      	  ///scanKeys(x,print)///,
      	  ///close x///,
      	  ///run ("rm -f " | filename)///,
	  },
     "Functions:",
     MENU {
	  {TO "openDatabase", "    -- open a database file"},
	  {TO "openDatabaseOut", " -- open a database file for writing"},
	  {TO "close", "           -- close a database file"},
	  {TO quote #, " -- fetch or store in a database file"},
	  {TO quote #?, " -- query a database file"},
	  {TO "firstkey", "        -- get the first key"},
	  {TO "mutable", "         -- whether changes can be made"},
	  {TO "nextkey", "         -- get the next key"},
	  {TO "reorganize", "      -- compactify a database file"},
	  {TO "scanKeys", "        -- apply a function to each key"}
	  }
     }

document { quote reorganize,
     TT "reorganize x", " -- reorganize the database file x, compactifying it.",
     PARA,
     SEEALSO "Database"
     }

document { quote openDatabase,
     TT "openDatabase s", " -- open a database file corresponding to the file
     whose name is contained in the string s.",
     PARA,
     SEEALSO "Database"
     }

document { quote openDatabaseOut,
     TT "openDatabaseOut s", " -- open a database file corresponding to the file
     whose name is contained in the string s, and allow changes to be made
     to it.",
     PARA,
     SEEALSO "Database"
     }

document { quote firstkey,
     TT "firstkey f", " -- return the first key available in the database
     file f.",
     PARA,
     "Returns ", TT "null", " if none.",
     PARA,
     SEEALSO "Database"
     }

document { quote nextkey,
     TT "nextkey f", " -- return the next key available in the database
     file f.",
     PARA,
     "Returns ", TT "null", " if none.",
     PARA,
     SEEALSO "Database"
     }

document { quote evaluate,
     TT "evaluate s", " -- treating the contents of the string s as code in the
     Macaulay 2 language, parse it in its own scope, evaluate it and return
     the value.",
     PARA,
     EXAMPLE {
	  "evaluate \"2+2\"",
      	  "evaluate \"a :=2\"",
      	  "a"
	  }
     }

document { quote addStartFunction,
     TT "addStartFunction (() -> ...)", " -- record a function for later 
     execution, when the program is restarted after loading dumped data."
     }

document { quote addEndFunction,
     TT "addEndFunction (() -> ...)", " -- record a function for later 
     execution, when the program is exited."
     }

document { quote runStartFunctions,
     TT "runStartFunctions()", " -- call all the functions previously recorded
     by ", TO "addStartFunction", " passing () as argument sequence."
     }

document { "emacs",
     "The best way to edit Macaulay 2 code or to run Macaulay 2 is with GNU 
     emacs, a versatile text editor written by Richard Stallman which
     runs well under most UNIX systems.  Its
     web page is ", HREF "http://www.gnu.org/software/emacs/emacs.html", "
     and the software can be obtained from one of the ftp sites listed
     at ", HREF "http://www.gnu.org/order/ftp.html", "; the primary ftp
     site is ", HREF "ftp://ftp.gnu.org/pub/gnu", ".",
     PARA,
     "There is a version of emacs for Windows NT and Windows 95 called ", TT "NTemacs", ".
     See ", HREF "http://www.cs.washington.edu/homes/voelker/ntemacs.html", " for
     details about how to get it, as well as information about how to swap your
     caps lock and control keys.",
     PARA,
     MENU {
	  TO "running Macaulay 2 in emacs",
	  TO "editing Macaulay 2 code with emacs",
	  },
     }

document { "running Macaulay 2 in emacs",
-- don't indent
"Because some answers can be very wide, it is a good idea to run Macaulay 2
in a window which does not wrap output lines and allows the
user to scroll horizontally to see the rest of the output.  We
provide a package for ", TO "emacs", " which implements this, in
", TT "emacs/M2.el", ".  It also provides for dynamic completion
of symbols in the language.",
PARA,
"There is an ASCII version of this section of the documentation distributed
in the file ", TT "emacs/emacs.hlp", ".  It might be useful for you to visit
that file with emacs now, thereby avoiding having to cut and paste bits of
text into emacs buffers for the deomonstrations below.",
PARA,
"If you are a newcomer to emacs, start up emacs with the command 
", TT "emacs", " and then start up the emacs tutorial with the keystrokes 
", TT "C-H t", ".  (The notation ", TT "C-H", " indicates that you should type 
", TT "Control-H", ", by holding down the control key, 
and pressing ", TT "H", ".)  The emacs tutorial will introduce you to the
basic keystrokes useful with emacs.  After running through that you will want
to examine the online emacs manual which can be read with ", TT "info", "
mode; you may enter or re-enter that mode with the keystrokes ", TT "C-H i", ".  
You may also want to purchase (or print out) the emacs manual.  It is cheap,
comprehensive and informative.  Once you have spent an hour with the emacs
tutorial and manual, come back and continue from this point.",
PARA,
"Edit your ", TT ".emacs", " initialization file, located in your home directory,
creating one if necessary.  (Under Windows, this file is called ", TT "_emacs", ".)
Insert into it the following lines of emacs-lisp code.",
PARA,
CODE ///(setq auto-mode-alist (append auto-mode-alist '(("\\.m2$" . M2-mode))))
(autoload 'M2-mode "M2-mode.el" "Macaulay 2 editing mode" t)
(global-set-key "\^Cm" 'M2) (global-set-key [ f12 ] 'M2)
(global-set-key "\^Cm" 'M2) (global-set-key [ SunF37 ] 'M2)
(autoload 'M2 "M2.el" "Run Macaulay 2 in a buffer." t)
(setq load-path (cons "/usr/local/Macaulay2/emacs" load-path))
(make-variable-buffer-local 'transient-mark-mode)
(add-hook 'M2-mode-hook '(lambda () (setq transient-mark-mode t)))
(add-hook 'comint-M2-hook '(lambda () (setq transient-mark-mode t)))///,
PARA,
"The first two lines cause emacs to enter a special mode for editing Macaulay 2
code whenever a file whose name has the form ", TT "*.m2", " is encountered.  
The next three lines provide a special mode for running Macaulay 2 in an emacs buffer.
The sixth line tells emacs where to find the emacs-lisp files provided in the
Macaulay 2 emacs directory - you must edit the string in that line to
indicate the correct path on your system to the Macaulay 2 emacs directory.
The files needed from that directory are ", TT "M2-mode.el", ",
", TT "M2-symbols.el", ", and ", TT "M2.el", ".  The seventh line sets
the variable ", TT "transient-mark-mode", " so that it can
have a different value in each buffer.  The eighth and ninth lines set
hooks so that ", TT "transient-mark-mode", " will be set to ", TT "t", " 
in M2 buffers.  The effect of this is that the mark is only active occasionally,
and then emacs functions which act on a region of text will refuse to proceed 
unless the mark is active.  The ", TT "set-mark", " function or the
", TT "exchange-point-and-mark", " function will activate the mark, and it
will remain active until some change occurs to the buffer.  The only reason
we recommend the use of this mode is so the same key can be used to evaluate 
a line or a region of code, depending on whether the region is active.",
PARA,
"Exit and restart emacs with your new initialization file.  
If you are reading this file with emacs, then use the keystrokes
", TT "C-x 2", " to divide the buffer containing this file into two windows.
Then press the ", TT "F12", " function key to start up 
Macaulay 2 in a buffer named ", TT "*M2*", ".",
PARA,
"If this doesn't start up Macaulay 2, one reason may be that your function
keys are not operable.  In that case press ", TT "C-C m", " instead.  (The 
notation ", TT "C-C", " is standard emacs notation for Control-C.)  Another
reason may be that you have not installed Macaulay 2 properly - the executables
should be on your path.",
PARA,
"You may use ", TT "C-x o", " freely to switch from one window to the other.
Verify that Macaulay 2 is running by entering a command such as ", TT "2+2", ".  
Now paste the following text into a buffer, unless you have the ASCII
version of this documentation in an emacs buffer already, position
the cursor on the first line of code, and press the ", TT "F11", " function 
key (or ", TT "C-C s", ") repeatedly to present each line to Macaulay 2.",
PARA,
CODE ///i1 = R = ZZ/101[x,y,z]
i2 = f = symmetricPower(2,vars R)
i3 = M = cokernel f
i4 = C = resolution M
i5 = betti C///,
PARA,
"Notice that the input prompts are not submitted to Macaulay 2.",
PARA,
"Here is a way to conduct a demo of Macaulay 2 in which the code to be
submitted is not visible on the screen.  Paste the following text into
an emacs buffer.",
PARA,
CODE ///20!
4 + 5 2^20
-- that's all folks!///,
PARA,
"Press ", TT "M-F11", " with your cursor in this buffer to designate it as
the source for the Macaulay 2 commands.  (The notation ", TT "M-F11", " means 
that while holding the ", TT "Meta", " key down, you should press the ", TT "F11", " 
key.  The Meta key is the Alt key on some keyboards, or it can be simulated by 
pressing Escape (just once) and following that with the key you wanted to press 
while the meta key was held down.)  Then position your cursor (and thus the 
emacs point) within the line containing ", TT "20!", ".  Now press ", TT "M-F12", "
to open up a new frame called ", TT "DEMO", " for the ", TT "*M2*", " window with
a large font suitable for use with a projector, and with your cursor in that
frame, press ", TT "F11", " a few times to conduct the demo.  (If the font or frame is the
wrong size, you may have to create a copy of the file ", TT "M2.el", "
with a version of the function ", TT "M2-demo", " modified to fit your screen.)",
PARA,
"One press of ", TT "F11", " brings the next line of code forward into the
", TT "*M2*", " buffer, and the next press executes it.  Use ", TT "C-x 5 0", " 
when you want the demo frame to go away.",
PARA,
"There is a way to send a region of text to Macaulay 2: simply select a region
of text, making sure the mark is active (as described above) and press ", TT "F11", ".
Try that on the list below; put it into an emacs buffer, move your cursor to the 
start of the list, press ", TT "M-C-@", " or ", TT "M-C-space", " to mark the list, 
and then press ", TT "F11", " to send it to Macaulay 2.  (The notation ", TT "M-C-@", " 
means: while holding down the Meta key and the Control key press the ", TT "@", " key, 
for which you'll also need the shift key.)",
PARA,
CODE ///{a,b,c,d,e,f,
g,h,i,j,k,l,
m,n}///,
PARA,
"We have developed a system for incorporating Macaulay 2 interactions into TeX
files.  Here is an example of how that looks.  Paste the following text
into an emacs buffer.",
PARA,
CODE ///The answer, 4, is displayed after the output label ``{\tt o1\ =}''.
Multiplication is indicated with the traditional {\tt *}.
<<<1*2*3*4>>>
Powers are obtained as follows.
<<<2^100>>>///,
PARA,
"The bits in brackets can be submitted to Macaulay 2 easily.  Position your
cursor at the top of the buffer and press ", TT "F10.", "  The cursor will move 
just past the first ", TT "<<<", ", and the emacs mark will be positioned just 
before the ", TT ">>>", ".  Thus ", TT "1*2*3*4", " is the region, and it will
even be highlighted if you have set the emacs variable ", TT "transient-mark-mode", "
to ", TT "t", " for this buffer.  Pressing ", TT "F11", " will send ", TT "1*2*3*4", " 
to Macaulay 2 for execution: try it now.  A sequence of such Macaulay 2 commands 
can be executed by alternately pressing ", TT "F10", " and ", TT "F11", ".  You may
also use ", TT "M-F10", " to move backward to the previous bracketed expression.",
PARA,
"Now let's see how we can handle wide and tall Macaulay 2 output.  Execute the
following line of code.",
PARA,
CODE ///random(R^20,R^{6:-2})///,
PARA,
"Notice that the long lines in the Macaulay 2 window, instead of being wrapped
around to the next line, simply disappear off the right side of the screen,
as indicated by the dollar signs in the rightmost column.  Switch to the
other window and practice scrolling up and down with ", TT "M-v", " and ", TT "C-v", ", 
and scrolling left and right with the function key ", TT "F3", " (or ", TT "C-C <", ") 
and the function key ", TT "F4", " (or ", TT "C-C >", ").  Notice how the use of
", TT "C-E", " to go to the end of the line
sends the cursor to the dollar sign at the right hand side of the screen;
that's where the cursor will appear whenever you go to a position off the
screen to the right.  Then use the ", TT "F2", " function key (or ", TT "C-C .", ") to 
scroll the text so the cursor appears at the center of the screen.  Use ", TT "C-A", " to 
move to the beginning of the line and then the ", TT "F2", " function key 
(or ", TT "C-C .", ") to bring the left margin back into view.",
PARA,
"You may use the ", TT "F5", " function key or (or ", TT "C-C ?", ") to 
toggle whether long lines are truncated or wrapped; initially they are truncated.",
PARA,
"Now go to the very end of the ", TT "*M2*", " buffer with ", TT "M->", " and 
experiment with keyword completion.  Type ", TT "reso", " and then press the 
", TT "TAB", " key.  Notice how the word is completed to ", TT "resolution", "
for you.  Delete the word with ", TT "M-DEL", ", type ", TT "res", "
and then press the ", TT "TAB", " key.  The possible completions are displayed 
in a window.  Switch to it with the ", TT "F8", " key, move to the desired 
completion, select it with the ", TT "RETURN", " key, and then return to the 
", TT "*M2*", " buffer with ", TT "C-X o", ".  Alternatively, if you have a
mouse, use the middle button to select the desired completion.",
PARA,
"Experiment with command line history in the ", TT "*M2*", " buffer.  Position 
your cursor at the end of the buffer, and then use ", TT "M-p", " and ", TT "M-n", " 
to move to the previous and next line of input remembered in the history.  When you 
get to one you'd like to run again, simply press return to do so.  Or edit it
slightly to change it before pressing return."
}

document { "editing Macaulay 2 code with emacs",
-- don't indent
"In this section we learn how to use emacs to edit Macaulay 2 code.  Assuming you
have set up your emacs init file as described in ", TO "running Macaulay 2 in emacs", "
when you visit a file whose name ends with ", TT ".m2", " 
you will see on the mode line the name ", TT "Macaulay 2", " in
parentheses, indicating that the file is being edited in Macaulay 2 mode.  (Make
sure that the file ", TT "emacs/M2-mode.el", " is on your ", TT "load-path", ".)",
PARA,
"To see how electric parentheses, electric semicolons, and indentation work,
move to a blank line of this file and type the following text.",
PARA,
CODE ///f = () -> (
     a := 4;
     b := {6,7};
     a+b)///,
PARA,
"Observe carefully how matching left parentheses are indicated briefly when a
right parenthesis is typed.",
PARA,
"Now position your cursor in between the 6 and 7.  Notice how
pressing ", TT "M-C-u", " moves you up out of the list to its left.  Do it 
again.  Experiment with ", TT "M-C-f", " and ", TT "M-C-b", " to move forward
and back over complete parenthesized
expressions.  (In the emacs manual a complete parenthesized expression is
referred to as an sexp, which is an abbreviation for S-expression.)  Try out
", TT "C-U 2 M-C-@", " as a way of marking the next two complete parenthesized
expression, and see how to use ", TT "C-W", " to kill them and ", TT "C-Y", " to yank 
them back.  Experiment with ", TT "M-C-K", " to kill the next complete parenthesized 
expression.",
PARA,
"Position your cursor on the 4 and observe how ", TT "M-;", " will start a comment 
for you with two hyphens, and position the cursor at the point where commentary
may be entered.",
PARA,
"Type ", TT "res", " somewhere and then press ", TT "C-C TAB", " to bring up the
possible completions of the word to documented Macaulay 2 symbols.",
PARA,
"Finally, notice how ", TT "C-H m", " will display the keystrokes peculiar to 
the mode in a help window."
}

document { quote oo,
     TT "oo", " -- denotes the value of the expression on the previous output
     line.",
     SEEALSO { "oo", "ooo", "oooo" }
     }

document { quote ooo,
     TT "ooo", " -- denotes the value of the expression on the output line
     two lines above.",
     SEEALSO { "oo", "oooo" }
     }

document { quote oooo,
     TT "oooo", " -- denotes the value of the expression on the output line
     three lines above.",
     SEEALSO { "oo", "ooo" }
     }

document { quote InverseMethod,
     TT "InverseMethod", " -- a key used under which is stored a method
     for computing multiplicative inverses.",
     PARA,
     "Internal routines for computing powers call upon that method when
     the exponent is negative."
     }

document { quote or,
     TT "t or u", " -- returns true if ", TT "t", " is true or ", TT "u", "
     is true.",
     PARA,
     "If ", TT "t", " is true, then the code in ", TT "u", " is not evaluated.",
     SEEALSO{ "and", "not" }
     }

document { quote and,
     TT "t and u", " -- returns true if ", TT "t", " is true and ", TT "u", "
     is true.",
     PARA,
     "If ", TT "t", " is false, then the code in ", TT "u", " is not evaluated.",
     SEEALSO{ "or", "not" }
     }

document { quote locate,
     TT "locate f", " -- for an interpreted function ", TT "f", " 
     returns a sequence ", TT "(n,i,j)", " describing the location of
     the source code.  The name of the source file is ", TT "n", " and
     the code is occupies lines ", TT "i", " through ", TT "j", "."
     }

document { quote MutableHashTable,
     TT "MutableHashTable", " -- the class of all mutable hash tables.",
     PARA,
     "A mutable hash table is a type of hash table whose entries can be changed.",
     PARA,
     "Normally the entries in a mutable hash table are not printed, to prevent
     infinite loops in the printing routines.  To print them out, use 
     ", TO "peek", ".",
     EXAMPLE {
	  "x = new MutableHashTable",
      	  "scan(0 .. 30, i -> x#i = i^2)",
      	  "x # 20",
      	  "x #? 40",
	  },
     SEEALSO "HashTable"
     }

document { quote map,
     TT "map(Y,X,d)", " -- constructs a map to Y from X defined by data d.",
     PARA,
     "This is intended to be a general mechanism for constructing maps
     (homomorphisms) between objects in various categories.",
     PARA,
     "Installed methods:",
     MENU {
	  (TO "making ring maps"),
	  (TO "making module maps")
	  }
     }
document { quote precedence,
     TT "precedence x", " -- returns the parsing precedence of x for use in
     the printing routines.",
     PARA,
     SEEALSO {"Expression", "net", "name"}
     }

document { quote hashTable,
     TT "hashTable v", " -- produce a hash table from a list v of key-value
     pairs.",
     PARA,
     "The pairs may be of the form ", TT "a=>b", ", ", TT "{a,b}", ",
     or ", TT "(a,b)", ".",
     PARA,
     EXAMPLE {
	  "x = hashTable {a=>b, c=>d}",
      	  "x#a"
	  },
     }

document { quote toList,
     TT "toList x", " -- yields a list of the elements in a list, sequence,
     or set ", TT "x", ".",
     PARA,
     "This is a good way to convert a list of some type to a list of type
     ", TO "List", ".",
     EXAMPLE {
	  "x = set {a,b,c,d}",
      	  "toList x"
	  },
     }

document { quote hypertex,
     "hypertex", " -- a variable which indicates whether the function 
     ", TO "tex", " should incorporate hypertext links into its output.",
     PARA,
     "The convention adopted by ", TT "xhdvi", " is the one used.",
     EXAMPLE {
	  ///n = HREF {"http://www.uiuc.edu","UIUC"};///,
      	  ///<< tex n;///,
      	  ///hypertex = false;///,
      	  ///<< tex n;///
	  }
     }

document { quote saturate,
    TT "saturate(I,J,options)", " -- computes the saturation
    (I : J^*) of I w.r.t. J.  If J is not given, the ideal J
    is taken to be the ideal generated by the variables of 
    the ring R of I.",
    BR,NOINDENT,
    TT "saturate(Ideal)",
    BR,NOINDENT,
    TT "saturate(Ideal,Ideal)",
    BR,NOINDENT,
    TT "saturate(Ideal,RingElement)",
    BR,NOINDENT,
    TT "saturate(Module)",
    BR,NOINDENT,
    TT "saturate(Module,Ideal)",
    BR,NOINDENT,
    TT "saturate(Module,RingElement)",
    BR,NOINDENT,
    TT "saturate(Vector)",
    PARA,
    "If I is either an ideal or a submodule of a module M,
    the saturation (I : J^*) is defined to be the set of elements
    f in the ring (first case) or in M (second case) such that
    J^N * f is contained in I, for some N large enough.",
    PARA,
    "For example, one way to homogenize an ideal is to
    homogenize the generators and then saturate with respect to
    the homogenizing variable.",
    EXAMPLE {
	 "R = ZZ/32003[a..d];",
     	 "I = ideal(a^3-b, a^4-c)",
     	 "Ih = homogenize(I,d)",
     	 "saturate(Ih,d)",
	 },
    "We can use this command to remove graded submodules of 
    finite length.",
    EXAMPLE {
	 "m = ideal vars R",
     	 "M = R^1 / (a * m^2)",
     	 "M / saturate 0_M",
	 },
    "Allowable options include:",
    MENU {
        TO (saturate => DegreeLimit),
	TO (saturate => Strategy),
	TO (saturate => MinimalGenerators)
        },
    PARA,
    "The computation is currently not stored anywhere: this means
    that the computation cannot be continued after an interrupt.
    This will be changed in a later version."
    }

document { saturate => Strategy,
     "The strategy option value should be one of the following:",
    MENU {
        (TO "Linear", "      -- use the reverse lex order"),
	(TO "Iterate", "     -- use successive ideal quotients (the default)"),
	(TO "Bayer", "       -- use the method in Bayer's thesis"),
	(TO "Elimination", " -- compute the saturation ", TT "(I:f)", " by eliminating ", TT "z", " from ", TT "(I,f*z-1)", "")
        },
     }


document { saturate => DegreeLimit,
     TT "DegreeLimit => n", " -- keyword for an optional argument used with
     ", TO "saturate", " which specifies that the computation should halt after dealing 
     with degree n."
     }

document { quote profile,
     TT "f = profile f", " -- replace a global function f by a profiled version.",
     PARA,
     "The new function is the same as the old one, except that when
     the new function is run, it will record the number of times it
     is called and the total execution time.  Use ", TO "profileSummary", "
     to display the data recorded so far."
     }

document { quote profileSummary,
     TT "profileSummary", " -- a command which will display the data
     accumulated by running functions produced with ", TO "profile", "."
     }

document { quote globalAssignFunction,
     TT "globalAssignFunction", " -- the standard function which can be used
     as a method for ", TO GlobalAssignHook, " so that certain types of
     mutable hash tables ", TT "X", ", when assigned to a global variable, will acquire
     the name of the global variable as their name.  The companion function
     ", TO "globalReleaseFunction", " is used to release the name when the
     global variable gets reassigned.",
     PARA,
     "The current way this function works is by storing the string used for
     printing under ", TT "X.name", " and storing the global variable under
     ", TT "X.symbol", ".",
     PARA,
     "Another thing done by this function is to apply ", TO use, " to the thing.
     This is used for polynomial rings to assign values to the symbols representing
     the variables (indeterminates) in the ring.",
     PARA,
     EXAMPLE {
	  "X = new Type of MutableHashTable",
      	  "x = new X",
      	  "GlobalAssignHook X := globalAssignFunction",
      	  "GlobalReleaseHook X := globalReleaseFunction",
      	  "x' = new X",
      	  "t = {x,x'}",
      	  "x = x' = 44",
      	  "t",
      	  "code globalAssignFunction",
	  },
     SEEALSO { "name", "symbol", "SelfInitializingType" }
     }

document { quote globalReleaseFunction,
     TT "globalReleaseFunction", " -- the standard function which can be used as
     a method for ", TO GlobalReleaseHook, " so that certain types of things, which
     have acquired as their name the name of a global variable to which they have
     been assigned, will lose that name when a different value is assigned to
     the variable.",
     PARA,
     SEEALSO "globalAssignFunction"
     }

document { "MP: Multi Protocol",
     "Macaulay 2 incorporates code from the MP (Multi Protocol) subroutine
     library written by S. Gray, N. Kajler, and P. Wang.  The license is
     contained in its README file, part of which we provide in the file
     ", TT "Macaulay2/licenses/mp.lic", ".",
     PARA,
     "The implementation is only experimental at this stage.",
     PARA,
     MENU {
	  TO "PutAnnotationPacket",
	  TO "PutCommonMetaOperatorPacket",
	  TO "PutCommonMetaTypePacket",
	  TO "PutCommonOperatorPacket",
	  TO "PutOperatorPacket",
	  TO "WritePacket",
	  TO "closeLink",
	  TO "openLink",
	  TO "writeMessage",
	  TO "writePacket",
	  TO "writeRawPacket",
	  }
     }

document { quote PutAnnotationPacket,
     TT "PutAnnotationPacket", " -- a function used for our experimental implementation of
     MP (Multi Protocol).",
     PARA,
     SEEALSO "MP: Multi Protocol"
     }
document { quote PutCommonMetaOperatorPacket,
     TT "PutCommonMetaOperatorPacket", " -- a function used for our experimental implementation of
     MP (Multi Protocol).",
     PARA,
     SEEALSO "MP: Multi Protocol"
     }
document { quote PutCommonMetaTypePacket,
     TT "PutCommonMetaTypePacket", " -- a function used for our experimental implementation of
     MP (Multi Protocol).",
     PARA,
     SEEALSO "MP: Multi Protocol"
     }
document { quote PutCommonOperatorPacket,
     TT "PutCommonOperatorPacket", " -- a function used for our experimental implementation of
     MP (Multi Protocol).",
     PARA,
     SEEALSO "MP: Multi Protocol"
     }
document { quote PutOperatorPacket,
     TT "PutOperatorPacket", " -- a function used for our experimental implementation of
     MP (Multi Protocol).",
     PARA,
     SEEALSO "MP: Multi Protocol"
     }
document { quote WritePacket,
     TT "WritePacket", " -- a function used for our experimental implementation of
     MP (Multi Protocol).",
     PARA,
     SEEALSO "MP: Multi Protocol"
     }
document { quote closeLink,
     TT "closeLink", " -- a function used for our experimental implementation of
     MP (Multi Protocol).",
     PARA,
     SEEALSO "MP: Multi Protocol"
     }
document { quote openLink,
     TT "openLink", " -- a function used for our experimental implementation of
     MP (Multi Protocol).",
     PARA,
     SEEALSO "MP: Multi Protocol"
     }
document { quote writeMessage,
     TT "writeMessage", " -- a function used for our experimental implementation of
     MP (Multi Protocol).",
     PARA,
     SEEALSO "MP: Multi Protocol"
     }
document { quote writePacket,
     TT "writePacket", " -- a function used for our experimental implementation of
     MP (Multi Protocol).",
     PARA,
     SEEALSO "MP: Multi Protocol"
     }
document { quote writeRawPacket,
     TT "writeRawPacket", " -- a function used for our experimental implementation of
     MP (Multi Protocol).",
     PARA,
     SEEALSO "MP: Multi Protocol"
     }

document { quote symbol,
     TT "symbol", " -- a symbol used as a key in a hash table under which to store
     the variable to which the hash table has been assigned as value.",
     PARA,
     "This is intended mainly for internal use.",
     PARA,
     SEEALSO "globalAssignFunction"
     }

document { "programming overview",
     }

-- these files are made at compile time
load "gbdoc.m2"
load "gbfunctions.m2"

