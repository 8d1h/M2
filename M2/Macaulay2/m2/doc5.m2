--		Copyright 1993-2002 by Daniel R. Grayson

document { override,
     Headline => "override default values for optional arguments",
     TT "override(defaults,args)", " -- overrides default values for
     optional arguments present in the argument sequence ", TT "args", ".",
     PARA,
     "The argument ", TT "defaults", " should be an immutable hash table (
     usually of type ", TO "OptionTable", "), and ", TT "args", " should be
     a sequence of arguments, some of which are optional arguments of
     the form ", TT "x => v", ".  Each such optional argument
     is removed from ", TT "args", ", and the value in ", TT "defaults", "
     corresponding to the key ", TT "x", " is replaced by ", TT "v", ".
     The value returned is the modified pair ", TT "(defaults, args)", ".",
     PARA,
     "This function is intended for internal use only, and is used in the processing
     of optional arguments for method functions which accept them.",
     EXAMPLE {
	  "defs = new HashTable from { a => 1, b => 2 };",
	  "override(defs, (4,b=>6,5))"
	  }
     }

document { userSymbols,
     Headline => "a list of the user's symbols",
     TT "userSymbols ()", " -- provides a list of symbols defined by
     the user.",
     BR,
     NOINDENT, TT "userSymbols X", " -- limits the list to those symbols whose
     values are instances of the class X.",
     PARA,
     "Protected symbols are excluded from the list.",
     SEEALSO "listUserSymbols"
     }


document { listUserSymbols,
     Headline => "display the user's symbols",
     TT "listUserSymbols", " -- a command which returns a display of the variables 
     defined by the user, along with their types.",
     BR,
     NOINDENT, TT "listUserSymbols X", " -- limits the list to those variables whose
     values are instances of X.",
     PARA,
     "This function is useful after using ", TO "loaddata", " to restore 
     a previous session.",
     SEEALSO {"userSymbols"}
     }

document { clearOutput,
     Headline => "forget output values",
     TT "clearOutput", " -- a command which attempts to release memory by 
     clearing the values retained by the output line symbols.",
     PARA,
     SEEALSO { "clearAll" }
     }

document { clearAll,
     Headline => "forget everything",
     TT "clearAll", " -- a command which attempts to release memory by clearing 
     the values retained by the output line symbols and all the user symbols.",
     PARA,
     SEEALSO {"userSymbols", "clearOutput"}
     }

document { ConversionFormat,
     Headline => "convert to engine format",
     TT "ConversionFormat", " -- a method consulted to provide an engine conversion
     format.",
     SEEALSO {"convert", "pop"}
     }

document { convert,
     Headline => "convert to engine format",
     TT "convert (fmt,str)", " -- converts a string ", TT "str", " containing data 
     transmitted from the engine in the ", TO "engine communication protocol", ".
     The argument ", TT "fmt", " is a recursive description of the format to
     be used for the conversion.",
     PARA,
     "The method named ", TO "ConversionFormat", " is used to provide
     a conversion format",
     PARA,
     "A format of the form", PRE "          singleton f",
     "specifies that a sequence has been transmitted, each element of
     which should be converted with the format ", TT "f", ".  
     See ", TO "transmitting a sequence", ".",
     PARA,
     "A format of the form", PRE "          (g,x,y,z,...)",
     "where ", TT "g", " is a function, specifies that consecutive items are to
     be converted with the formats x,y,z,..., and the results of conversion
     are to be passed as arguments to the functin ", TT "g", " for processing.",
     PARA,
     "A format of the form", PRE "          (n,x,y,z,...)",
     "where ", TT "n", " is an integer, specifies that consecutive items are to
     be converted wtih the formats x,y,z,..., a total of n times.  The
     results are to be placed in a sequence.",
     PARA,
     "A format consisting of the symbol ", TO "ConvertInteger", "specifies
     that an integer has been transmitted.  See ",
     TO "transmitting an integer", ".",
     PARA,
     "Functions which assemble formats.",
     MENU {
	  TO "ConvertApply",
	  TO "ConvertFixedRepeat",
	  TO "ConvertJoin",
	  TO "ConvertList",
	  TO "ConvertMissing",
	  TO "ConvertRepeat"
	  },
     PARA,
     "A format is usually stored under the key ", TO "ConvertToExpression", "
     in the apprpriate class.",
     PARA,
     SEEALSO {"pop"}
     }

document { ConvertToExpression,
     Headline => "specify mehtod for converting to engine format",
     TT "ConvertToExpression", " -- a key for classes under which a
     conversion format is stored.",
     PARA,
     "See ", TO "convert", "."
     }

document { pop,
     Headline => "pop a value from the engine's stack",
     TT "pop", " -- used as a key.  If ", TT "X", " is a class,
     then ", TT "X.pop", " will contain a routine which uses
     ", TO "convert", " to pop the top item off the engine's stack
     and return it.",
     SEEALSO "engine communication protocol"
     }

document { ConvertInteger,
     Headline => "convert an integer from engine format",
     "A format item for communication with the engine that corresponds to
     an integer.  See ", TO "transmitting an integer", "."
     }

document { ConvertApply,
     Headline => "apply a function after specified engine format conversions",
     TT "ConvertApply(f,T1,...,Tm)", " -- a format item for communication with
     the engine that specifies that format items ", TT "T1", ", ..., ", TT "Tm", " should be 
     applied to the bytes received from the engine, and then the function
     ", TT "f", " should be applied to the sequence of results.",
     PARA,
     "See ", TO "convert", "."
     }

document { ConvertList,
     Headline => "convert a sequence of items from engine format",
     TT "ConvertList T", " -- a format item for converting data received from the
     ", TO "engine", ", which specifies that format item ", TT "T", " be applied to each
     element in the array, returning the results as a list.",
     PARA,
     "See ", TO "convert", "."
     }

document { ConvertRepeat,
     Headline => "convert a sequence of items from engine format",
     TT "ConvertRepeat T", " -- a format item for converting data received from the
     ", TO "engine", ", which specifies that format item ", TT "T", " be applied to each
     element in the array, returning the results as a sequence.",
     PARA,
     "See ", TO "convert", "."
     }

document { ConvertFixedRepeat,
     Headline => "convert a fixed length sequence of items from engine format",
     TT "ConvertFixedRepeat(n,T1,...,Tm)", " -- a format item for converting data
     from the engine that specifies that the format items ", TT "T1", ",...,", TT "Tm", " be applied
     to the incoming data a total of ", TT "n", " times.",
     PARA,
     "See ", TO "convert", "."
     }

document { ConvertJoin,
     Headline => "convert several items from engine format",
     TT "ConvertJoin(T1,...,Tm)", " -- a format item for converting data
     from the engine that specifies that format items ", TT "T1", ",...,", TT "Tm", " be applied
     to the data received, and the sequence of results returned.",
     PARA,
     "If there is just one format item ", TT "T1", ", then its result is returned.",
     PARA,
     "See ", TO "convert", "."
     }

document { sendToEngine,
     Headline => "send a command string to the engine",
     TT "sendToEngine s", " -- sends the string ", TT "s", " to the engine and returns the result.",
     PARA,
     "See also ", TO "engine communication protocol", "."
     }

document { ConvertMissing,
     Headline => "a missing engine conversion format item",
     TT "ConvertMissing", " -- a format item for converting data from the engine
     which specifies that the class for which this item has been installed
     has no conversion format specified, presumably because it corresponds
     to a type which the engine doesn't support.",
     PARA,
     "See ", TO "convert", "."
     }

TEST "
     f = (x) -> assert( x == convert(ConvertInteger,gg x) )
     scan(100, i -> (
	       f(2^i);
	       f(2^i-1);
	       f(2^i+1);
	       f(-2^i);
	       f(-2^i+1);
	       ))

     f = x -> assert( x == convert(ConvertRepeat ConvertInteger,gg x) )
     g = i -> f(i .. i+20)
     g(-10)
     g(10)
     g(100)
     g(1000)
     g(1000000)
     g(1000000000000000)
     g(10000000000000000000000000000000000000000000000000)
     "

document { exec,
     Headline => "execute another program",
     TT "exec argv", " -- uses the 'exec' operating system call to
     start up another program, replacing the current Macaulay 2 process.
     Here ", TT "argv", " is a string, or a sequence or list of strings
     to be passed as arguments to the new process.  The first string
     is the name of the executable file."
     }

document { restart,
     Headline => "restart Macaulay 2",
     TT "restart", " -- restart Macaulay 2 from the beginning.",
     PARA,
     "Functions previously registered with ", TO "addEndFunction", " will
     be called first."
     }

document { on,
     Headline => "trace a function each time it's run",
     TT "f = on f", " -- replaces the function ", TT "f", " by a version which 
     will print out its arguments and return value each time it's called,
     together with a sequence number so the two reports can be connected.",
     PARA,
     "This function is of only limited utility because it cannot be used
     with write-protected system functions.",
     PARA,
     "The reason we write ", TT "f = on f", " and not something like
     ", TT "f = on(x -> ...)", " is so the function handed to ", TO "on", "
     will know its name.  The name will appear in the display."
     }

document { assert,
     Headline => "assert something is true",
     TT "assert x", " -- prints an error message if x isn't true."
     }

document { notImplemented,
     Headline => "print an 'not implemented' error message",
     TT "notImplemented()", " -- print an error message that 
     says \"not implemented yet\"."
     }

document { errorDepth,
     Headline => "set the error printing depth",
     TT "errorDepth i", " -- sets the error depth to i, which should be
     a small integer, returning the old value.",
     PARA,
     "During the backtrace after an error message, a position in interpreted
     code is displayed only if the value of ", TO "reloaded", " was at least
     as large as the error depth is now.  Typically, the error depth is set
     to 1 so that messages from code pre-interpreted and reloaded with 
     ", TO "loaddata", " will not appear in the backtrace."
     }

document { benchmark,
     Headline => "accurate timing of execution",
     TT "benchmark s", " -- produce an accurate timing for the code contained
     in the string ", TT "s", ".  The value returned is the number of seconds.",
     PARA,
     "The snippet of code provided will be run enough times to register
     meaningfully on the clock, and the garbage collector will be called
     beforehand."
     }

document { memoize,
     Headline => "record results of function evaluation for future use",
     TT "memoize f", " -- produces, from a function ", TT "f", ", a new function which
     behaves the same as ", TT "f", ", but remembers previous answers to be provided
     the next time the same arguments are presented.",
     PARA,
     EXAMPLE {
	  "fib = n -> if n <= 1 then 1 else fib(n-1) + fib(n-2)",
      	  "time fib 16",
      	  "fib = memoize fib",
      	  "time fib 16",
      	  "time fib 16",
	  },
     PARA,
     "The function ", TT "memoize", " operates by constructing 
     a ", TO "MutableHashTable", " in which the argument sequences are used
     as keys for accessing the return value of the function.",
     PARA,
     "An optional second argument to memoize provides a list of initial values,
     each of the form ", TT "x => v", ", where ", TT "v", " is the value to
     be provided for the argument ", TT "x", ".",
     PARA,
     "Warning: when the value returned by ", TT "f", " is ", TO "null", ", it will always be 
     recomputed, even if the same arguments are presented.",
     PARA,
     "Warning: the new function created by ", TT "memoize", " will save
     references to all arguments and values it encounters, and this will
     often prevent those arguments and values from being garbage-collected
     as soon as they might have been.  If the arguments are
     implemented as mutable hash tables (modules, matrices and rings are
     implemented this way) then a viable strategy is to stash computed
     results in the arguments themselves.  See also ", TT "CacheTable", "."
     }

TEST "
fib = memoize( n -> if n <= 1 then 1 else fib(n-1) + fib(n-2) )
assert ( fib 10 == 89 )
"

TEST "
a = 0
f = memoize ( x -> ( a = a + 1; true ))
f 1
f 2
f 3
f 1
f 2
f 3
f 1
f 2
f 3
assert( a == 3 )
"

document { (symbol _, Tally, Thing),     
     Headline => "get a count from a tally",
     TT "t_x", " -- returns the number of times ", TT "x", " is counted
     by ", TT "t", ".",
     SEEALSO "Tally"
     }

document { Tally,
     Headline => "the class of all tally results",
     TT "Tally", " -- a class designed to hold tally results, i.e., multisets."
     }

document { (symbol **, Tally, Tally),
     Headline => "Cartesian product of tallies",
     TT "x ** y", " -- produces the Cartesian product of two tallies.",
     PARA,
     "One of the arguments may be a ", TO "Set", ".",
     PARA,
     EXAMPLE {
	  "x = tally {a,a,b}",
      	  "y = tally {1,2,2,2}",
     	  "x ** y",
	  },
     SEEALSO {"Tally", "tally"}
     }

document { (symbol ?, Tally, Tally),
     Headline => "comparison of tallies",
     TT "x ? y", " -- compares two tallies, returning ", TT "symbol <", ", ",
     TT "symbol >", ", ", TT "symbol ==", ", or ", TO "incomparable", ".",
     SEEALSO "Tally"
     }

document { (symbol +, Tally, Tally),
     Headline => "union of tallies",
     TT "x + y", " -- produces the union of two tallies.",
     PARA,
     "One of the arguments may be a ", TO "Set", ".",
     PARA,
     EXAMPLE {
	  "x = tally {a,a,a,b,b,c}",
      	  "y = tally {b,c,c,d,d,d}",
      	  "x + y",
	  },
     SEEALSO {"Tally", "tally"}
     }

document { (symbol -, Tally, Tally),
     Headline => "difference of tallies",
     TT "x - y", " -- produces the difference of two tallies.",
     PARA,
     EXAMPLE "tally {a,a,b,c} - tally {c,d,d}",
     SEEALSO "Tally"
     }

document { tally,
     Headline => "tally the elements of a list",
     TT "tally x", " -- tallies the frequencies of items in a list x.",
     PARA,
     "It produces an hash table (multiset) y which tallies the
     frequencies of occurrences of items in the list x, i.e.,
     y_i is the number of times i appears in x, or is 0 if
     i doesn't appear in the list.",
     PARA,
     EXAMPLE {
	  "y = tally {1,2,3,a,b,1,2,a,1,2,{a,b},{a,b},a}",
      	  "y_{a,b}",
	  },
     PARA,
     SEEALSO "Tally"
     }

TEST ///
assert( toString tally {1,1,1,2,1,3,2} === "new Tally from {1 => 4, 2 => 2, 3 => 1}" )
assert( tally {1,1,1,2,1,3,2} === new Tally from {(1,4),(2,2),(3,1)} )
///

document { Set, 
     Headline => "the class of all sets"
     }

document { (symbol #?, Set, Thing),
     Headline => "test set membership",
     TT "x#?i", " -- tests whether ", TT "i", " is a member of the set ", TT "x", "."
     }

document { (symbol -, Set, Set),
     Headline => "set difference",
     TT "x - y", " -- the difference of two sets.",
     SEEALSO {"Set", "-"}
     }

document { (isSubset,Set,Set), TT "isSubset(X,Y)", " -- tells whether ", TT "X", " is a subset of ", TT "Y", "." }

document { isSubset,
     Headline => "whether something is a subset of another"
     }

document { (symbol ++, Set, Set),
     Headline => "disjoint union of sets",
     EXAMPLE "set {a,b,c} ++ set {b,c,d}"
     }

document { (symbol *, Set, Set),
     Headline => "intersection of sets",
     EXAMPLE "set {1,2,3} * set {2,3,4}"
     }

TEST "
x = set {1,2,3}
y = set {3,4,5}
assert( member(2,x) )
assert( not member(x,x) )
assert( sum y === 12 )
assert( product y === 60 )
assert ( x * y === set {3} )
assert ( x ** y === set {
	  (3, 4), (2, 5), (3, 5), (1, 3), (2, 3), (1, 4), (3, 3), (1, 5), (2, 4)
	  } )
assert ( x - y === set {2, 1} )
assert ( x + y === set {1, 2, 3, 4, 5} )
assert ( toString x === \"set {1, 2, 3}\" )
"

document { look,
     Headline => "look at the engine's stack",
     TT "look()", " -- display item on the top of the engine's stack.",
     PARA,
     "It's a ", TO "Command", " so it may be entered simply
     as ", TT "look", " if it's alone on the command line.",
     PARA,
     "Used mainly for debugging the engine.",
     EXAMPLE {
	  "R = ZZ/101[x,y,z]",
      	  "sendgg ggPush R",
	  "look"
	  }
     }

document { callgg,
     Headline => "call the engine",
     TT "callgg(f,x,y,...)", " -- calls the ", TO "engine", " with engine
     command string f, after pushing engine objects corresponding to
     x, y, ... onto the engine's stack."
     }

document { engineStack,
     Headline => "display the engine's stack",
     TT "engineStack()", " -- returns a net containing a display of the contents
     of the engine's stack.",
     PARA,
     "It's a ", TO "Command", " so it may be entered simply
     as ", TT "engineStack", " if it's alone on the command line.",
     PARA,
     "Used mainly for debugging the engine.",
     EXAMPLE {
	  "ZZ/101[x,y,z]",
      	  "f = matrix {{x,y,z}}",
      	  "sendgg ggPush f",
      	  "engineStack"
	  },
     }

document { engineHeap,
     Headline => "display the engine's heap",
     TT "engineHeap()", " -- display the contents of the engine's heap.",
     PARA,
     "It's a ", TO "Command", " so it may be entered simply
     as ", TT "engineHeap", " if it's alone on the command line.",
     PARA,
     "Used mainly for debugging the engine.",
     EXAMPLE {
	  "ZZ/101[x,y,z];",
      	  "matrix {{x,y,z}}",
      	  "engineHeap"
	  },
     }
     
document { engineMemory,
     Headline => "display engine memory usage",
     TT "engineMemory()", " -- display the memory usage of the engine.",
     PARA,
     "It's a ", TO "Command", " so it may be entered simply
     as ", TT "engineMemory", " if it's alone on the command line.",
     PARA,
     "Used mainly for debugging the engine.",
     EXAMPLE {
	  "ZZ/101[x,y,z];",
      	  "matrix {{x,y,z}}",
      	  "engineMemory"
	  }
     }
document { see,
     Headline => "display engine object",
     TT "see i", " -- return a string which displays the engine object whose handle 
     is the integer i.",
     BR,
     TT "see X", " -- return a string which displays the engine object corresponding 
     to the ring, matrix, module, or ring element X.",
     PARA,
     EXAMPLE {
	  "R = ZZ/101[x,y,z]",
      	  "see R",
      	  "see (x+1)^6",
      	  "see handle (x*y*z)",
      	  "see 0"
	  }
     }

document { eePopInt,
     Headline => "pop integer from engine stack",
     TT "eePopInt()", " -- pop the integer from the top of the engine's stack,
     returning its value.",
     PARA,
     SEEALSO "high level gb engine commands"
     }

document { eePopIntarray,
     Headline => "pop array of integers from engine stack",
     TT "eePopIntarray()", " -- pop the array of integers from the top of the engine's 
     stack, returning its value as a list of integers.",
     PARA,
     SEEALSO "high level gb engine commands"
     }

document { eePopBool,
     Headline => "pop Boolean value from engine stack",
     TT "eePopBool()", " -- pop a boolean value from the top of the engine's stack,
     returning true or false.",
     PARA,
     SEEALSO "high level gb engine commands"
     }

document { eePop,
     Headline => "pop object from engine stack",
     TT "eePop f", " -- take an engine conversion format string and use it
     to convert an object popped from the top of the engine's stack.",
     PARA,
     SEEALSO "high level gb engine commands"
     }

document { eeLift,
     Headline => "call engine to lift a ring element",
     TT "eeLift(f,R)", " -- lift a ring element ", TT "f", " to the
     ring ", TT "R", ".",
     PARA,
     SEEALSO "high level gb engine commands"
     }

document { symbol directSum,
     Headline => "specify method for forming direct sums",
     SEEALSO "directSum"
     }

document { (symbol ^**, Module, ZZ),
     Headline => "tensor power",
     Synopsis => {
	  "N = M^**i",
	  "M" => null,
	  "i" => null,
	  "N" => { "the i-th tensor power of M" }
	  }
     }

document { (symbol ^**, CoherentSheaf, ZZ),
     Headline => "tensor power",
     Synopsis => {
	  "N = M^**i",
	  "M" => null,
	  "i" => null,
	  "N" => { "the i-th tensor power of M" }
	  }
     }    

document { setRandomSeed,
     Headline => "set starting point for random number generator"
     }

document { (setRandomSeed, ZZ),
     Synopsis => {
	  "setRandomSeed i",
	  "i" => null
	  },
     "Sets the random number seed to the low-order 32 bits of the integer ", TT "i", ".
     The sequence of future pseudo-random results is determined by the seed.",
     EXAMPLE {
	  "setRandomSeed 123456",
	  "for i to 10 list random 100",
	  "setRandomSeed 123456",
	  "for i to 10 list random 100"
	  }
     }

document { (setRandomSeed, String),
     Synopsis => {
	  ///setRandomSeed s///,
	  "s" => null
	  },
     "Sets the random number seed to an integer computed from ", TT "s", ".  Every character 
     of the string contributes to the seed, but only 32 bits of data are used.
     The sequence of future pseudo-random results is determined by the seed.",
     EXAMPLE {
	  ///setRandomSeed "thrkwjsxz"///,
	  ///for i to 10 list random 100///,
	  ///setRandomSeed "thrkwjsxz"///,
	  ///for i to 10 list random 100///
	  }
     }

document { truncateOutput,
     Synopsis => {
	  "truncateOutput w",
	  "w" => "the maximum output line width to enforce"
	  },
     "If ", TT "w", " is ", TO "infinity", " then truncation is turned off.",
     PARA,
     "This function works by assigning a value to ", TT "Thing.BeforePrint", ", which
     may conflict with other ", TO "BeforePrint", " methods installed by the user.",
     }
