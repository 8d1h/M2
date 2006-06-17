--		Copyright 2006 by Daniel R. Grayson

document {
     Key => cacheValue,
     Headline => "cache values of functions in their arguments",
     Usage => "((cacheValue KEY) f) x",
     Inputs => {
	  "KEY",
	  "f" => Function,
	  "x" => {"an argument for ", TT "f", " that has ", ofClass CacheTable, " stored in it under ", TT "x.cache"}
	  },
     Outputs => {
	  { TT "f x", " is returned, but the value is saved in ", TT "x.cache#KEY", " and not recomputed later" }
	  },
     EXAMPLE {
	  "x = new HashTable from { val => 1000, cache => new CacheTable }",
	  ///g = (t -> (print "hi there"; t.val^4))///,
	  ///f = (cacheValue VALUE) g///,
	  "f x",
	  "f x",
	  "peek'_2 x"
	  },
     SourceCode => { cacheValue },
     SeeAlso => { stashValue }
     }

document {
     Key => stashValue,
     Headline => "stash values of functions in their arguments",
     Usage => "((stashValue KEY) f) x",
     Inputs => {
	  "KEY",
	  "f" => Function,
	  "x" => MutableHashTable => { "an argument for ", TT "f" }
	  },
     Outputs => {
	  { TT "f x", " is returned, but the value is saved in ", TT "x#KEY", " and not recomputed later" }
	  },
     EXAMPLE {
	  "x = new MutableHashTable from { val => 1000 }",
	  ///g = (t -> (print "hi there"; t.val^4))///,
	  ///f = (stashValue VALUE) g///,
	  "f x",
	  "f x",
	  "peek x"
	  },
     SourceCode => { stashValue },
     SeeAlso => { cacheValue }
     }

undocumented (addHook,MutableHashTable,Thing,Function)
document {
     Key => { (addHook,HashTable,Thing,Function), addHook },
     Headline => "add a hook function to an object for later processing",
     Usage => "addHook(obj,key,hook)",
     Inputs => { "obj", "key", "hook" },
     Consequences => {
	  { "the function ", TT "hook", " is added to the list (possibly absent) of hooks stored in ", TT "obj#key", " or ", TT "obj.cache#key" }
	  },
     SourceCode => {(addHook,HashTable,Thing,Function), (addHook,MutableHashTable,Thing,Function)},
     SeeAlso => { runHooks, removeHook }
     }
undocumented (removeHook,MutableHashTable,Thing,Function)
document {
     Key => { (removeHook,HashTable,Thing,Function), removeHook },
     Headline => "remove a hook function from an object",
     Usage => "removeHook(obj,key,hook)",
     Inputs => { "obj", "key", "hook" },
     Consequences => {
	  { "the function ", TT "hook", " is removed from the list of hooks stored in ", TT "obj#key", " or ", TT "obj.cache#key" }
	  },
     SourceCode => {(removeHook,HashTable,Thing,Function), (removeHook,MutableHashTable,Thing,Function)},
     SeeAlso => { runHooks, removeHook }
     }
undocumented (runHooks,MutableHashTable,Thing,Thing)
document {
     Key => { (runHooks,HashTable,Thing,Thing), runHooks },
     Headline => "run the hook functions stored in an object",
     Usage => "runHooks(obj,key,arg)",
     Inputs => { "obj", "key", "arg" },
     Consequences => {
	  { "each function ", TT "hook", " in list of hooks stored in ", TT "obj#key", " or ", TT "obj.cache#key", " is
	       called with ", TT "arg", " as its argument or sequence of arguments" }
	  },
     SourceCode => { (runHooks,HashTable,Thing,Thing), (runHooks,MutableHashTable,Thing,Thing) },
     SeeAlso => { addHook, removeHook }
     }
undocumented (generateAssertions, List)
document { Key => {generateAssertions,(generateAssertions, String)},
     Headline => "generate assert statements from experimental input",
     Usage => "generateAssertions x",
     Inputs => { "x" => { "a string whose non-comment non-blank lines are Macaulay 2 expressions to be evaluated" } },
     Outputs => { { "a net whose lines are assert statements that assert that the expressions evaluate to the expected value, just computed" }},
     EXAMPLE {
	  "generateAssertions ///
2+2
2^20
///",
     	  ///value \ unstack oo///
	  }
     }
document { Key => unsequence,
     Headline => "extract the single element from a sequence of length 1",
     Usage => "unsequence x",
     Inputs => { "x" => Thing },
     Outputs => { { TT "x#0", ", if ", TT "x", " is a sequence of length 1, otherwise ", TT "x", "" } },
     EXAMPLE { "unsequence (2:a)", "unsequence (1:a)", "unsequence (0:a)" },
     SeeAlso => sequence}

document { Key => {permutations, (permutations, ZZ), (permutations, VisibleList)},
     Headline => "produce all permutations of a list",
     Usage => "permutations x",
     Inputs => { "x" => { ofClass {VisibleList, ZZ} } },
     Outputs => { { "a list of all the permutations of the visible list ", TT "x", ", or, if ", TT "x", " is an integer, of the list of
	       integers from 0 through ", TT "n-1" 
	       } },
     EXAMPLE {
	  "permutations {a,b,c,d}",
	  "permutations 3"
	  }
     }

document { Key => separateRegexp, Headline => "separate a string into pieces, with separators determined by a regular expression" }
document { Key => (separateRegexp, String, String),
     Usage => "separateRegexp(sep,str)",
     Inputs => { "sep" => "a regular expression" , "str" => "a string to be separated" },
     Outputs => { { "a list of substrings consecutively extracted from ", TT "str", ", with separators recognized by ", TT "sep" } },
     EXAMPLE { ///separateRegexp("-", "asdf-qwer-dfadf")/// }}
document { Key => (separateRegexp, String, ZZ, String),
     Usage => "separateRegexp(sep,n,str)",
     Inputs => { "sep" => "a regular expression" , "n", "str" => "a string to be separated" },
     Outputs => { { "a list of substrings consecutively extracted from ", TT "str", ", with separators recognized by the ", TT "n", "-th parenthesized subexpression of", TT "sep" } },
     EXAMPLE { ///separateRegexp("f(-)", 1, "asdf-qwer-dfadf")/// }}
document { Key => tutorial, Headline => "convert documentation from tutorial format",
     Usage => "tutorial x",
     Inputs => { "x" => String => "documentation in tutorial format" },
     Outputs => {{ "documentation in hypertext format" }},
     PARA { "Some of the Macaulay2 documentation is written in this format." },
     EXAMPLE {
	  "///-- We can compute $(x+y)^3$ as follows.
R = QQ[x,y]
(x+y)^3
///",
     	  "tutorial oo",
	  "peek oo"
	  }}
document { Key => {preimage,(preimage, RingMap, Ideal)},
     Headline => "preimage of an ideal under a ring map",   -- hopefully more general later
     Usage => "preimage(f,I)",
     Inputs => { "I" => { "an ideal in the target ring of ", TT "f" }, "f" },
     Outputs => { { "the preimage of ", TT "I", " under the map ", TT "f" } },
     EXAMPLE lines /// 
	  R = QQ[x,y,z]
	  S = QQ[t,u]
	  f = map(R,S,{x*y,y*z})
	  preimage_f ideal(x^2,y^2)
     	  ///
     }
document { Key => symbol applicationDirectorySuffix,
     Headline => "suffix that determines the user's application directory",
     Usage => "applicationDirectorySuffix = s",
     Inputs => { "s" => String => { "a relative path, which will be appended to the user's home directory to determine the user's application directory" } },
     SeeAlso => applicationDirectory,
     PARA {
	  "The value of ", TT "applicationDirectorySuffix", " may also be a function of no arguments, in which case its value is used as the path.
	  The initial value of ", TT "applicationDirectorySuffix", " is a function whose value depends on the operating system and its conventions."
	  },
     EXAMPLE lines ///
     	  applicationDirectorySuffix()
	  applicationDirectory()
	  applicationDirectorySuffix = "local/Mac2"
	  applicationDirectory()
     	  ///,	  
     SourceCode => applicationDirectorySuffix,
     Consequences => { { "the value of the function ", TT "applicationDirectory", " will use the new value of ", TT "applicationDirectorySuffix" }}}
document { Key => {applicationDirectory, "application directory"},
     Headline => "the path to the user's application directory",
     Usage => "applicationDirectory()",
     Outputs => { String => "the path to the user's application directory" },
     SourceCode => applicationDirectory,
     PARA { "The function ", TO "installPackage", ", by default, installs packages under the application directory.  At program startup,
	  unless the ", TT "-q", " option is provided on the command line, an entry will be added to the ", TO "path", " so
	  packages can be loaded from there by ", TO "loadPackage", " and ", TO "needsPackage", ".  Moreover, the ", TO "initialization file", ", if found there, will be run."
	  },
     PARA { "The function ", TO "applicationDirectorySuffix", " determines the value of ", TT "applicationDirectory", ", and can be modified by the user." },
     EXAMPLE "applicationDirectory()",
     SeeAlso => applicationDirectorySuffix}
document { Key => round,
     Headline => "round a number to the nearest integer",
     Usage => "round x",
     Inputs => { "x" => "a number" },
     Outputs => {{ "the integer nearest to ", TT "x" }},
     SourceCode => round,
     EXAMPLE lines ///
     	  round(-2.3)
	  round(2/3)
	  ///,
     SeeAlso => { floor, ceiling }
     }
document { Key => symbol currentLineNumber,
     Headline => "current line number of the current input file",
     Usage => "currentLineNumber()",
     Outputs => { ZZ => "the current line number of the current input file" },
     EXAMPLE "currentLineNumber()",
     SeeAlso => "currentFileName" }
document { Key => symbol currentFileDirectory,
     Headline => "the directory containing the current input file",
     Usage => "currentFileDirectory",
     Outputs => { String => "the directory containing the current input file" },
     EXAMPLE "currentFileDirectory",
     SeeAlso => "currentFileName" }
document { Key => symbol currentFileName,
     Headline => "the current source file",
     Usage => "currentFileName",
     Outputs => { String => "the name of the current source file" },
     EXAMPLE "currentFileName",
     SeeAlso => "currentLineNumber" }
document { Key => {URL,(NewFromMethod, URL, String)},
     Headline => "a type representing a URL",
     Usage => "URL h",
     Inputs => { "h" => String => "a URL" },
     Outputs => {{ "an object of type ", TT "URL" }},
     PARA {
	  "The function ", TO "show", " knows how display entities of various types, including URLs."
	  }}
document { Key => {show, (show, TEX), (show, URL)},
     Headline => "display various TeX, hypertext, or a URL, in an external application",
     Usage => "show x",
     Inputs => { "x" => { "an object of type ", TT "TEX", ", or ", TT "URL" }},
     Consequences => {{ "an external viewer, such as a web browser, is started to view the object ", TT "x" }},
     SeeAlso => { showTex, showHtml }}
document { Key => {(irreducibleDecomposition,MonomialIdeal),irreducibleDecomposition},
     Headline => "express a monomial ideal as an intersection of irreducible monomial ideals",
     Usage => "irreducibleDecomposition I",
     Inputs => { "I" },
     EXAMPLE lines ///
        QQ[x..z];
        I = monomialIdeal (x*y^3, x*y^2*z)
	w = irreducibleDecomposition I
	assert( I == intersect w )
     ///,
     Outputs => {{ "a list of irreducible monomial ideals whose intersection is ", TT "I" }}}
undocumented {(isConstant, ZZ),(isConstant, QQ),(isConstant, RRR),(isConstant, RR),(isConstant, CC)}
document { Key => {isConstant,(isConstant, RingElement)},
     Headline => "whether a ring element is constant",
     Usage => "isConstant f",
     Inputs => { "f" },
     Outputs => { { "whether f is constant, i.e., is in the coefficient ring" } },
     EXAMPLE lines ///
     	  isConstant 3
	  QQ[a,b][x,y];
	  isConstant (x+a-x)
	  isConstant x
	  ///,
     SeeAlso => coefficientRing,
     SourceCode => (isConstant,RingElement)
     }
document { Key => {[newPackage,Version],Version},
     Headline => "specify the version number when creating a new package",
     Usage => "newPackage(..., Version => num)",
     Inputs => { "num" => String => "the version number of the new package" },
     Consequences => {{ "the version number will be stored under the key ", TO "Version", " in the resulting package" }},
     EXAMPLE "(options Macaulay2Core).Version"}
document { Key => currentTime,
     Headline => "get the current time",
     Usage => "currentTime()",
     Outputs => {ZZ => "the current time, in seconds since 00:00:00 1970-01-01 UTC, the beginning of the epoch" },
     EXAMPLE "currentTime()",
     PARA { "We can compute, roughly, how many years ago the epoch began as follows." },
     EXAMPLE "currentTime() /( (365 + 97./400) * 24 * 60 * 60 )",
     PARA { "We can also compute how many months account for the fractional part of that number." },
     EXAMPLE "12 * (oo - floor oo)",
     PARA { "Compare that to the current date, available from a standard Unix command." },
     EXAMPLE ///run "date"///
     }
document { Key => Partition, 
     Headline => "a type of list representing a partition of a natural number",
     SeeAlso => { partitions, (conjugate,Partition) } }
document { Key => partitions, Headline => "list the partitions of an integer" }
document { Key => (partitions, ZZ, ZZ),
     Usage => "partitions(n,k)",
     Inputs => { "n", "k" },
     Outputs => {{"a list of the partitions of the integer ", TT "n", " as a sum of terms each of which does not exceed ", TT "k"}},
     PARA { "Each partition is a basic list of type ", TO "Partition", "." },
     SeeAlso => {Partition, (partitions, ZZ)},
     EXAMPLE "partitions(4,2)"}
document { Key => (partitions, ZZ),
     Usage => "partitions n",
     Inputs => { "n" },
     Outputs => {{"a list of the partitions of the integer ", TT "n"}},
     PARA { "Each partition is a basic list of type ", TO "Partition", "." },
     SeeAlso => {Partition,(partitions, ZZ, ZZ)},
     EXAMPLE "partitions 4"}
document { Key => UpdateOnly, Headline => "only copies of newer files should replace files" }
document { Key => [copyDirectory, UpdateOnly],
     Usage => "copyDirectory(..., UpdateOnly => true)",
     Consequences => {{ "during the indicated copy operation, newer files will not be replaced by copies of older ones" }}}
document { Key => Verbose, Headline => "request verbose feedback" }
document { Key => [symlinkDirectory, Verbose],
     Usage => "symlinkDirectory(..., Verbose => ...)",
     Consequences => {{ "during the file operation, details of the operations performed will be displayed" }}}
document { Key => [copyDirectory, Verbose],
     Usage => "copyDirectory(..., Verbose => ...)",
     Consequences => {{ "during the file operation, details of the operations performed will be displayed" }}}
document { Key => [moveFile, Verbose],
     Usage => "moveFile(..., Verbose => ...)",
     Consequences => {{ "during the file operation, details of the operations performed will be displayed" }}}
document { Key => PrimaryTag, Headline => "for internal use only: a symbol used in storing documentation" }
document { Key => LoadDocumentation, Headline => "when loading a package, load the documentation, too" }
document { Key => [loadPackage, LoadDocumentation],
     Usage => "loadPackage(..., LoadDocumentation => ...)",
     SeeAlso => beginDocumentation,
     Consequences => {{ "when the package is loaded, the documentation is loaded, too" }}}
document { Key => [needsPackage, LoadDocumentation],
     Usage => "needsPackage(..., LoadDocumentation => ...)",
     SeeAlso => beginDocumentation,
     Consequences => {{ "when the package is loaded, the documentation is loaded, too" }}}
document { Key => ofClass, 
     Headline => "English phrases for types",
     Usage => "ofClass T",
     Inputs => { "T" => Nothing => {ofClass{Type,ImmutableType,List}, " of types"} },
     Outputs => { Sequence => { "an English phrase in hypertext, using a synonym for each type, together with appropriate indefinite articles, and, if
	       a list is presented, the word ", EM "or", " as a conjunction at the end" }},
     PARA { "When viewed in html, words in the phrase hot link(s) to the documentation node(s) for the class(es)." },
     EXAMPLE lines ///
     	  ofClass class 3
	  peek oo
     	  ofClass Ring
     	  SPAN ofClass {HashTable, ProjectiveVariety}
	  document { Key => foo, "We may need ", ofClass ZZ, " and ", ofClass HashTable, "." }
	  help foo
     ///}
document { Key => inverse, Headline => "compute the inverse" }
document { Key => (inverse, Matrix),
     Usage => "inverse f",
     Inputs => { "f" },
     Outputs => {{ "the inverse of ", TT "f" }},
     SourceCode => (inverse, Matrix)}
document { Key => functionBody,
     Headline => "get the body of a function",
     Usage => "functionBody f",
     Inputs => { "f" => Function },
     Outputs => { FunctionBody => { "the body of the function ", TT "f" }},
     PARA { "The body of ", TT "f", " is essentially just the source code of ", TT "f", ", with no frames providing bindings for
	  the local variables in scopes enclosing the scope of ", TT "f", ".  Function bodies cannot act as functions, but they can be tested for
	  equality (", TO "===", "), and they can be used as keys in hash tables."
	  },
     EXAMPLE lines ///
     	  f = a -> b -> a+b+a*b
	  functionBody f 1
	  f 1 === f 2
	  functionBody f 1 === functionBody f 2
     ///,
     SeeAlso => FunctionBody }
document { Key => FunctionBody,
     Headline => "the class of function bodies",
     SeeAlso => functionBody }
document { Key => {[newPackage, Authors], Authors},
     Usage => "newPackage(..., Authors => au)",
     Headline => "provide contact information for the authors of a package",
     Inputs => { "au" => List => { "a list of lists, each of which describes one of the authors" } },
     Consequences => { { "the authors will be stored in the newly created package" } },
     PARA { "Each elemnt of ", TT "au", " should be a list of options of the form ", TT "key => val", ",
	  where ", TT "key", " is ", TT "Name", ", ", TT "Email", ", or ", TT "HomePage", ", and
	  ", TT "val", " is a string containing the corresponding information."
	  },
     EXAMPLE "Macaulay2Core.Options.Authors"
     }
document { Key => Name,
     "This symbol is used as a key when providing information about the authors of a package to the ", TO "newPackage", " command.
     See ", TO [newPackage, Authors], "." }
document { Key => Email,
     "This symbol is used as a key when providing information about the authors of a package to the ", TO "newPackage", " command.
     See ", TO [newPackage, Authors], "." }
document { Key => HomePage,
     "This symbol is used as a key when providing information about the authors of a package to the ", TO "newPackage", " command.
     See ", TO [newPackage, Authors], "." }
document { Key => fileLength,
     Headline => "the length of a file",
     Usage => "fileLength f",
     Inputs => { "f" => { ofClass {String, File} }},
     Outputs => { ZZ => { "the length of the file ", TT "f", " or the file whose name is ", TT "f" }},
     PARA { "The length of an open output file is determined from the internal count of the number of bytes written so far." },
     SeeAlso => {fileTime},
     EXAMPLE lines ///
     	  f = temporaryFileName() << "hi there"
	  fileLength f
	  close f
	  filename = toString f
	  fileLength filename
	  get filename
	  length oo
	  removeFile filename
     ///
     }
document { Key => "loadedFiles",
     SeeAlso => {"load", "filesLoaded"},
     PARA { "After each source file is successfully loaded, the full path to the file is stored in the hash table ", TO "loadedFiles", ".  It is stored as the
	  value, with the corresponding key being a small integer, consecutively assigned, starting at 0."
	  },
     EXAMPLE "peek loadedFiles"}


undocumented {
     (validate, TO),(validate, String),(validate, MarkUpTypeWithOptions, Set, BasicList),(validate, Type, Set, BasicList),(validate, TOH),(validate, Option),(validate, TO2),
     (validate, COMMENT),(validate, CDATA),(validate, TEX)
     }
document { Key => {(validate, MarkUpList),validate},
     Usage => "validate x",
     Inputs => { "x" => { TO "hypertext" } },
     Consequences => { { "The hypertext is checked for validity, to ensure that the HTML code returned by ", TT "html x", " is valid." }},
     PARA {
	  "This function is somewhat provisional.  In particular, it is hard to check everything, because our hypertext format includes
	  some entities of class ", TO "IntermediateMarkUpType", " that don't correspond directly to HTML.  Either those will have to be
	  eliminated, or a more-final type of hypertext, convertible immediately to HTML, will have to be developed."
	  }
     }

document { Key => IntermediateMarkUpType,
     Headline => "the class of intermediate mark-up types",
     "An intermediate mark-up type is one that needs further processing to put it into final form.  A good example of one is ", TO "TOH", ", which
     represents a link to a documentation node, together with the headline of that node, which may not have been created yet at the time
     the ", TT "TOH", " link is encountered.  Another good example is ", TO "HREF", ", which creates a link using the HTML ", TT "A", " element:
     when the link is created, the relative path to the target page depends on the path to the page incorporating the link!"
     }

document { Key => VerticalList,
     Headline => "a type of visible self-initializing list that prints vertically",
     Usage => "VerticalList x",
     Inputs => { "x" => List },
     EXAMPLE lines ///
         apropos "res"
	 stack o1
	 v = VerticalList o1
	 ///
    }

document { Key => ForestNode,
     Headline => "a type of basic list used to represent a forest, i.e., a list of rooted trees",
     "This type is sort of experimental, and is used mainly internally in assembling the table of contents for the documentation of a package.",
     SeeAlso => {TreeNode}
     }
document { Key => TreeNode,
     Headline => "a type of basic list used to represent a rooted tree",
     "This type is sort of experimental, and is used mainly internally in assembling the table of contents for the documentation of a package.",
     SeeAlso => {ForestNode}
     }

document { Key => FunctionClosure,
     Headline => "the class of all function closures",
     "Functions created by the operator ", TO "->", " are function closures.",
     EXAMPLE "class (x->x)"
     }
document { Key => CompiledFunction,
     Headline => "the class of all compiled functions",
     "Compiled functions in Macaulay2 are written in a special purpose language, translated to C during compilation and not available to general users.",
     EXAMPLE "class sin"
     }
document { Key => CompiledFunctionClosure,
     Headline => "the class of all compiled function closures",
     "Some compiled functions return compiled function closures as values.",
     EXAMPLE lines ///
	  class depth
	  f = method()
	  class f
     ///
     }
TEST ///
assert ( class (x->x) === FunctionClosure )
assert ( class sin === CompiledFunction )
assert ( class depth === CompiledFunctionClosure )
///

document { Key => Heft, 
     Headline => "adjust the degrees of ring elements internally",
     "A symbol used as an option with some functions.  It denotes a way of internally adjusting the multi-degrees of elements of polynomials
     by attaching a prefix to each multi-degree that is computed as the dot product with a fixed vector of integers.",
     SeeAlso => { Adjust, Repair }
     }

scan((
	  FollowLinks,Hilbert,UserMode,RerunExamples,MakeDocumentation,IgnoreExampleErrors,IgnoreDocumentationErrors,MakeInfo,Options,InstallPrefix,PackagePrefix,Exclude,Encapsulate
	  ),
     s -> document { Key => s, "A symbol used as an option with some functions." })

document { Key => LowerBound,
     Headline => "the class of lower bound objects",
     "This is a type of list that represents a lower bound.  The single element of the list is an integer, and the object represents the condititon
     that some other integer, such as the index in a direct sum, should be at least as large.",
     EXAMPLE {
	  "LowerBound {4}",
	  ">= 4",
	  "> 4"
	  }}

document { Key => {NetFile,(symbol <<, NetFile, String),(symbol <<, NetFile, Net),(symbol " ",Manipulator,NetFile),(symbol <<,NetFile,Manipulator)},
     Headline => "the class of all net files",
     "This class is experimental.  Net files are intended to supplant output files eventually.  Whereas a file is a stream of bytes,
     or in some non-unix operating systems, a sequence of lines each of which is a sequence of bytes, a net file is a sequence of lines, each of which is
     a net.  Each output line is assembled by joining nets one by one.",
     EXAMPLE lines ///
     	  f = newNetFile()
     	  f << "aabbcc" << endl
	  f << "aa" << "bb"^1 << "cc"^-1 << endl
	  f << "aa" << "bb"^1 << "cc"^-1 << endl
     	  getNetFile f
	  peek oo
     	  class \ ooo
     ///
     }
document { Key => getNetFile,
     Headline => "get the sequence of completed lines (nets) from a net file",
     Usage => "getNetFile n",
     Inputs => { "n" => NetFile },
     "This function is experimental."
     }
document { Key => newNetFile,
     Headline => "create a new net file",
     Usage => "newNetFile()",
     Outputs => { NetFile },
     "This function is experimental."
     }
document { Key => OutputDictionary,
     Headline => "the dictionary for output values",
     "The symbols ", TT "o1", ", ", TT "o2", ", ", TT "o3", ", etc., are used to store the output values arising from interaction with the user,
     one line at a time.  The dictionary ", TT "OutputDictionary", " is the dictionary in which those symbols reside.",
     EXAMPLE lines ///
     	  2+2
	  "asdf" | "qwer"
	  value \ values OutputDictionary
	  dictionaryPath
	  peek OutputDictionary
     ///,
     SeeAlso => { "dictionaryPath" }
     }
document { Key => PackageDictionary,
     Headline => "the dictionary for names of packages",
     SeeAlso => { "dictionaryPath" },
     "This dictionary is used just for names of packages.",
     EXAMPLE lines ///
         dictionaryPath
	 values PackageDictionary
     ///
     }
document { Key => Pseudocode,
     Headline => "the class of pseudocodes",
     "The Macaulay 2 interpreter compiles its language into pseudocode, which is evaluated later, step by step.  At each
     step, the evaluator is considering a pseudocode item.  These pseudocode items are normally not available to the user, but
     the interanl function ", TO "disassemble", " can display their contents, the function ", TO "pseudocode", " can convert
     a function closure to pseudocode, the function ", TO "value", " can evaluate it (bindings of values to local symbols
     are enclosed with the pseudocode), the operator ", TO "===", " can be used for equality testing, 
     and when the debugger is activated after an error, the variable ", TO "errorCode", " contains the pseudcode step whose execution produced the error.",
     }
document { Key => pseudocode,
     Headline => "produce the pseudocode for a function",
     Usage => "pseudocode f",
     Inputs => { "f" => FunctionClosure },
     Outputs => { Pseudocode => { "the pseudocode of the function ", TT "f"} },
     SeeAlso => { disassemble },
     EXAMPLE lines ///
     	  pseudocode resolution
          disassemble oo
     ///
     }
document { Key => disassemble,
     Headline => "disassemble pseudocode or a function",
     Usage => "disassemble c",
     Inputs => { "c" => Pseudocode },
     Outputs => { String => {"the disassembled form of ", TT "c"} },
     SeeAlso => { pseudocode },
     EXAMPLE lines ///
     	  pseudocode resolution
          disassemble oo
     ///
     }
document { Key => "errorCode",
     Headline => "the pseudocode that produced an error",
     Usage => "errorCode",
     Outputs => { Pseudocode => { "the pseudocode that produced an error, or ", TO "null", ", if none" } },
     "Use ", TO "value", " to evaluate the code again, for debugging purposes."
     }
document { Key => (value, Pseudocode),
     Headline => "execute pseudocode",
     Usage => "value p",
     Inputs => { "p" },
     Outputs => {{ "the value returned by evaluation of ", TT "p" }},
     SeeAlso => { "errorCode", pseudocode }
     }
document { Key => PrintNames,
     Headline => "table of printed forms of objects",
     "This table is intended mainly for internal use.  Whether the table gets consulted upon conversion to a net or string depends
     on the type of thing being converted, and is a little haphazard.  Nevertheless, it is a useful mechanism for arranging for
     things to print in an understandable form.  We may eliminate it in a future version.",
     EXAMPLE "hashTable apply(pairs PrintNames, (k,v) -> (v,class k))",
     SeeAlso => { ReverseDictionary }
     }
document { Key => ReverseDictionary,
     SeeAlso => { PrintNames, globalAssignment },
     Headline => "table of symbols where various types of objects are stored",
     "If a type of object has been registered with ", TO "globalAssignment", ", and then an object of that type is assigned to a global
     symbol, then the symbol is stored in the hash table ReverseDictionary using the object as the key.  This allows the object to print
     out with the same name as the symbol.",
     EXAMPLE lines ///
     	  ZZ[x..y]
	  o1
	  R = o1
	  o1
	  o1^6
	  ReverseDictionary#o1
     ///,
     SourceCode => { (GlobalAssignHook,PolynomialRing), (net, PolynomialRing) }
     }
document { Key => SheafOfRings,
     SeeAlso => { Variety, OO },
     Headline => "the class of sheaves of rings",
     EXAMPLE lines ///
     	  X = Proj(QQ[x..z])
	  OO_X
	  OO_X^6
     ///
     }
document { Key => (module, SheafOfRings),
     SeeAlso => { Variety, OO },
     Usage => "module F",
     Inputs => { "F" },
     Outputs => { { "the module corresponding to ", TT "F" }},
     EXAMPLE lines ///
     	  R = QQ[x..z]
     	  X = Proj R
	  OO_X^6
	  module oo
     ///
     }
document { Key => "when",
     Headline => "a keyword",
     "A keyword used in ", TO "for", " loops."
     }
document { Key => zero,
     Headline => "whether something is zero",
     SourceCode => zero,
     Usage => "zero x",
     Inputs => { "x" },
     Outputs => { { "whether ", TT "x", " is equal to 0" }}}
document { Key => "homeDirectory",
     Headline => "the home directory of the user",
     Usage => "homeDirectory",
     Outputs => { String => "the home directory of the user" },
     EXAMPLE "homeDirectory"
     }
document { Key => "backtrace",
     Headline => "whether a backtrace is displayed following an error message",
     Usage => "backtrace = false",
     Consequences => { "a backtrace will not displayed following an error message" }
     }
document { Key => "backupFileRegexp",
     Headline => "a regular expression for recognizing names of backup files",
     "This regular expression is used by ", TO "copyDirectory", " and ", TO "symlinkDirectory", ": they will ignore backup files when copying all the files in
     a directory, and just copy the other ones.",
     Caveat => "Perhaps, instead of this being a global variable, there should be a way
     to change the default values for optional arguments to functions.  We may change this."
     }
document { Key => "buildHomeDirectory",
     SeeAlso => { "sourceHomeDirectory", "prefixDirectory" },
     Headline => "the directory where the Macaulay 2 program is being built",
     "When Macaulay 2 is built, i.e., is compiled, the directory tree containing the compiled (object) files may be different from the directory
     tree containing the source code.  The build home directory is the directory in that tree named ", TT "Macaulay2", " and containing subdirectories called
     ", TT "c", ", ", TT "d", ", ", TT "e", ", and ", TT "dumpdata", ".  Knowing that directory allows Macaulay2 to construct a suitable initial value for
     the ", TO "path", " that allows all the source code files to be found at startup time.  If building is not in progress, the value of this variable
     will be ", TO "null", "."
     }
document { Key => "sourceHomeDirectory",
     SeeAlso => { "buildHomeDirectory", "prefixDirectory" },
     Headline => "the directory where the source code is while Macaulay 2 is being built",
     "When Macaulay 2 is built, i.e., is compiled, the directory tree containing the compiled (object) files may be different from the directory
     tree containing the source code.  The source home directory is the directory in that tree named ", TT "Macaulay2", " and containing subdirectories called
     ", TT "c", ", ", TT "d", ", ", TT "e", ", and ", TT "dumpdata", ".  Knowing that directory allows Macaulay2 to construct a suitable initial value for
     the ", TO "path", " that allows all the source code files to be found at startup time.  If building is not in progress, the value of this variable
     will be ", TO "null", "."
     }
document { Key => "prefixDirectory",
     Headline => "the prefix directory",
     SeeAlso => { "sourceHomeDirectory", "buildHomeDirectory" },
     PARA {
	 "When Macaulay 2 is successfully installed, its files are installed in a directory tree whose layout, relative to the root, is determined
	 by the hash table ", TO "LAYOUT", ".  When M2 starts up, it detects whether it is running in such a layout, and sets ", TO "prefixDirectory", "
	 to the root of that directory tree."
	 },
     PARA {
	  "The prefix directory can be set at an early stage when ", TT "M2", " starts up with the ", TT "--prefix", " command line option."
	  }
     }
document { Key => getGlobalSymbol,
     Headline => "create a global symbol in a global dictionary",
     Usage => "getGlobalSymbol(dict,nam)",
     Inputs => { "dict" => GlobalDictionary, "nam" => String },
     Outputs => { { "a new global symbol whose name is the string ", TT "nam" }},
     Consequences => {{ "the new symbol is stored under the name ", TT "nam", " in the dictionary ", TT "dict" }},
     EXAMPLE lines ///
     	  d = new Dictionary
	  sym = getGlobalSymbol(d,"foo")
	  d
	  peek d
	  d#"foo" === sym
	  d#"asfd" = sym
	  peek d
     ///
     }     
document { Key => Bag,
     Headline => "the class of all bags",
     PARA "A bag can be used for enclosing something in a container to prevent it from being printed, in normal circumstances.
     Any mutable list can be used for this purpose, but bags are designated for this purpose.",
     SeeAlso => {unbag}
     }
undocumented {(unbag,Sequence)}
document { Key => {(unbag, Bag), unbag},
     Usage => "unbag y",
     Inputs => { "y" },
     Outputs => { { "the contents of ", TT "y" }},
     EXAMPLE lines ///
     	  x = 100!
	  y = new Bag from {x}
	  unbag y
     ///
     }
document { Key => {undocumented,(undocumented, Thing), (undocumented, List)},
     Usage => "undocumented key",
     Inputs => { "key" => { "a documentation key, or a list of keys" }},
     Consequences => { { "the documentation key(s) are designated as keys not needing documentation, thus avoiding warning messages when a package is installed" }},
     SeeAlso => { installPackage, "documentation keys" },
     EXAMPLE lines ///
     	  f = method()
	  f List := x -> 1
	  f VisibleList := x -> 2
	  f BasicList := x -> 3
	  undocumented { f, (f,List) }
     ///,
     }
document { Key => "documentation keys",
     PARA {"The Macaulay 2 documentation is linked together by cross-references from one documentation node to another.  Each node is identified by a
     	  string, which is the title of the node.  Some nodes, such as this one, have titles that are simply invented by the author.  Others have titles
     	  that are manufactured in a certain way from the aspect of the program being documented, for the sake of uniformity."
	  },
     PARA {"For example, the title of the node describing resolutions of modules is ", TT format "resolution Module", ".  The corresponding key is
     	  ", TT "(resolution, Module)", ", and it is the job of the function ", TO "makeDocumentTag", " to convert keys to titles."
	  },
     PARA "Here is a list of the various types of documentation keys.",
     UL {
	  LI { TT format "a string" },
	  LI { TT "s", "a symbol" },
	  LI { TT "(f,X)", "a method function or unary operator ", TT "f", " that accepts an argument of type ", TT "X" },
	  LI { TT "(f,X,Y)", "a method function or binary operator ", TT "f", " that accepts 2 arguments, of types ", TT "X", " and ", TT "Y" },
	  LI { TT "(f,X,Y,Z)", "a method function ", TT "f", " that accepts 3 arguments, of types ", TT "X", ", ", TT "Y", " and ", TT "Z" },
	  LI { TT "(f,X,Y,Z,T)", "a method function ", TT "f", " that accepts 4 arguments, of types ", TT "X", ", ", TT "Y", ", ", TT "Z", " and ", TT "T" },
	  LI { TT "[f,A]", "a function ", TT "f", " with an optional named ", TT "A" },
     	  LI { TT "(NewOfFromMethod,X,Y,Z)", "the method for ", TT "new X of Y from Z" },
     	  LI { TT "(NewOfMethod,X,Y)", "the method for ", TT "new X of Y" },
     	  LI { TT "(NewFromMethod,X,Z)", "the method for ", TT "new X from Z" },
     	  LI { TT "(NewMethod,X)", "the method for ", TT "new X" },
     	  LI { TT "((symbol ++, symbol =), X,Y)", "the method for assignment ", TT "X ++ Y = ..." },
	  LI { TT "(homology,X)", "the method for ", TT "HH X" },
	  LI { TT "(homology,ZZ,X)", "the method for ", TT "HH_ZZ X" },
	  LI { TT "(cohomology,ZZ,X)", "the method for ", TT "HH^ZZ X" },
	  LI { TT "(homology,ZZ,X,Y)", "the method for ", TT "HH_ZZ (X,Y)" },
	  LI { TT "(cohomology,ZZ,X,Y)", "the method for ", TT "HH^ZZ (X,Y)" },
	  LI { TT "(E,ZZ,X)", "the method for ", TT "E_ZZ X", " or ", TT "E^ZZ X", ", where ", TT "E", " is a scripted functor" },
	  LI { TT "(E,ZZ,X,Y)", "the method for ", TT "E_ZZ (X,Y)", " or ", TT "E^ZZ (X,Y)", ", where ", TT "E", " is a scripted functor" }
	  },
     EXAMPLE lines ///
     	  makeDocumentTag "some title"
	  makeDocumentTag (symbol +, ZZ, ZZ)
	  makeDocumentTag ((symbol +, symbol =), ZZ, ZZ)
     	  makeDocumentTag (Tor,ZZ,Module,Module)
     ///
     }

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/m2 "
-- End:
