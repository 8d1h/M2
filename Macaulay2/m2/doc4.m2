--		Copyright 1993-1998 by Daniel R. Grayson

document { exit,
     TT "exit n", " -- terminates the program and returns ", TT "n", " as return code.",
     BR,
     NOINDENT, 
     TT "exit", " -- terminates the program and returns 0 as return code.",
     PARA,
     "Files are flushed and closed.  Another way to exit is to type the end of
     file character, which is typically set to Control-D in unix systems, and is
     Control-Z under MS-DOS.",
     SEEALSO "quit"
     }

document { quit,
     TT "quit", " -- terminates the program and returns 0 as return code.",
     PARA,
     "Files are flushed and closed.  Another way to exit is to type the end of
     file character, which is typically set to Control-D in unix systems, and is
     Control-Z under MS-DOS.",
     SEEALSO "exit"
     }

document { fork,
     TT "fork()", " -- forks the process, returning the process id of the child
     in the parent, and returning 0 in the child."
     }

document { sleep,
     TT "sleep n", " -- sleeps for ", TT "n", " seconds."
     }

document { processID,
     TT "processID()", " -- returns the process id of the current Macaulay 2 process."
     }

document { BinaryPowerMethod,
     TT "BinaryPowerMethod(x,n)", " -- computes ", TT "x^n", " using successive squaring",
     PARA,
     "The technique depends in a standard way on the binary expansion of ", TT "n", ",
     hence the name.",
     PARA,
     SEEALSO "SimplePowerMethod"
     }

document { SimplePowerMethod,
     TT "SimplePowerMethod(x,n)", " -- computes x^n using repeated multiplication",
     PARA,
     SEEALSO "BinaryPowerMethod"
     }

document { dumpdata,
     TT "dumpdata s", " -- dump all data segments for the current process to 
     the file whose name is stored in the string ", TT "s", ".",
     PARA,
     "This effectively saves the entire state of the system, except that the
     input buffer for the file ", TO "stdio", " appears to have been emptied,
     and care is taken so that the environment and the command line arguments
     maintain their new values when the data is reloaded later with 
     ", TO "loaddata", "."
     }

document { loaddata,
     TT "loaddata s", " -- load all data segments for the current process from 
     the file whose name is stored in the string ", TT "s", ".  The file must have been
     created with ", TO "dumpdata", " and the same version of Macaulay 2.",
     PARA,
     "The file should have been created with ", TO "dumpdata", ".  Everything will
     be returned to its former state except:",
     SHIELD MENU {
	  TO "reloaded",
	  TO "environment",
	  TO "commandLine",
	  "whether the standard input is echoed and prompts to the 
	  standard output are properly flushed, which depends on whether 
	  the standard input is a terminal."
	  },
     "After the data segments have been reloaded, the command line arguments
     will be dealt with in the usual way, except that only the arguments
     after the i-th '--' and before the i+1-st '--' (if any) will be considered,
     where ", TT "i", " is the current value of ", TO "reloaded", ".",
     SEEALSO {"listUserSymbols"}
     }

document { symbol "reloaded",
     HEADLINE "count of how many times data has been dumped and restored",
     TT "reloaded", " -- a constant whose value is the number of 
     times ", TO "loaddata", " has been executed by the current process.  Since
     loaddata completely resets the state of the system, something like this
     is needed."
     }

document { buckets,
     TT "buckets x", " -- returns a list of the buckets used internally in an 
     hash table ", TT "x", ".",
     PARA,
     "Each bucket is represented as a list of key/value pairs."
     }

document { ggPush,
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

document { identity,
     TT "identity x", " -- returns x.",
     PARA,
     "This is the identity function."
     }

document { modulus,
     TT "modulus", " -- a key used in quotient rings of the form ZZ/n to store 
     the number n.",
     PARA,
     "This may go away when more general quotient rings are working."
     }

if class XCreateWindow === Function then (
document { XCreateWindow,
     TT "XCreateWindow(pid,x,y,a,b,w,n)", " -- makes a new window.",
     PARA,
     "Here ", TT "pid", " is the id of the parent window, ", TT "x", " 
     and ", TT "y", " are the coordinates of the upper left corner of the 
     window, ", TT "a", " and ", TT "b", " are the width and
     height, ", TT "w", " is the width of the border, and ", TT "n", " is the name of the window."
     }
) else erase symbol XCreateWindow

if class XDefaultRootWindow === Function then (
document { XDefaultRootWindow,
     TT "XDefaultRootWindow()", " -- returns the id of the root window."
     }
) else erase symbol XDefaultRootWindow

document { format,
     TT "format s", " -- prepare a string s for output by converting nonprintable
     characters to printable ones, or to escape sequences."
     }

document { generatorSymbols,
     TT "generatorSymbols", " -- a key used in a ", TO "Monoid", " under
     which is stored a list of the symbols used as generators for the monoid."
     }

document { generatorExpressions,
     TT "generatorSymbols", " -- a key used in a ", TO "Monoid", " under which is stored a list
     of the symbols used as generators for the monoid."
     }

document { match, HEADLINE "whether a string matches a pattern",
     TT "match(s,p)", " -- whether the string s matches the pattern ", TT "p", ".",
     PARA,
     "The pattern p may contain '*'s, which serve as wild card characters.
     This is provisional - eventually it will provide regular expression
     matching."
     }

document { gg,
     TT "gg x", " -- converts an integer, handle, or list of integers to the format
     required for communication with the engine.",
     PARA,
     SEEALSO "engine communication protocol"
     }

document { pairs,
     TT "pairs x", " -- makes a list of all key/value pairs ", TT "(k,v)", " in
     a hash table ", TT "x", ".",
     PARA,
     EXAMPLE {
	  "x = new HashTable from {a => 1, b => 2, c => 3}",
	  "pairs x",
	  }
     }

document { sequence,
     TT "sequence v", " -- returns ", TT "v", " if ", TT "v", " is a sequence, otherwise makes
     a sequence of length one containing ", TT "v", ".",
     PARA,
     EXAMPLE {
	  "sequence 4",
      	  "sequence {4,5}",
      	  "sequence (4,5)",
	  },
     PARA,
     SEEALSO { "singleton", "sequences" }
     }

document { xor,
     TT "xor(i,j)", " -- produces the bitwise logical exclusive-or of
     the integers ", TT "i", " and ", TT "j", ".",
     PARA,
     EXAMPLE "xor(10,12)"
     }

document { mingle,
     TT "mingle {v,w,...}", " -- produces a new list from the lists or
     sequences v,w,... by taking the first element from each, then the second, 
     and so on.",
     BR, NOINDENT,
     TT "mingle (v,w,...)", " -- does the same.",
     PARA,
     "After one of the lists is exhausted, it is silently ignored.",
     EXAMPLE {
	  "mingle({1,2,3,4},{a},{F,F,F,F,F,F,F,F,F,F})",
      	  ///concatenate mingle( {"a","b","c"} , {",",","} )///,
	  },
     "It is easy to transpose a nested list (thinking of it as a matrix)
     using ", TO "mingle", " and ", TO "pack", ".",
     EXAMPLE {
      	  "pack(2, mingle {{1,2,3,4},{5,6,7,8}})"
	  }
     }

document { SelfInitializingType,
     HEADLINE "the class of all self initializing types",
     "A self initializing type ", TT "X", " will produce an instance of X from
     initial data ", TT "v", " with the expression ", TT "X v", ".",
     PARA,
     EXAMPLE {
	  "X = new SelfInitializingType of BasicList",
      	  "x = X {1,2,3}",
      	  "class x",
	  },
     PARA,
     TO "Command", " is an example of a self initializing type.",
     SEEALSO {"HeaderType", "WrapperType"}
     }

document { Manipulator, HEADLINE "the class of all file manipulators",
     "A file manipulator is a type of list which, when put out to
     a file with ", TO "<<", " causes a chosen function to be applied
     to the file.",
     }

document { close,
     TT "f << close", " -- closes the file ", TT "f", ".",
     BR, NOINDENT,
     TT "close f", " -- closes the file ", TT "f", ".",
     PARA,
     "In the case of an output file, any buffered output is first
     written to the file, and the return value is an integer,
     normally 0, or -1 on error, or the return status of the child
     process in case the the file was a pipe.",
     PARA,
     "If the file was open for both input and output, both directions
     are closed.",
     PARA,
     "If the file is a pipe to another process, i.e., the filename
     began with the character ", TT "!", ", we will wait for the
     process to terminate.  If you don't want to wait for the process
     to terminate, open the file with ", TO "openInOut", ", and if
     necessary, use ", TO "closeIn", " to close it, to indicate that
     it has received all its input.",
     PARA,
     "If the file is ", TT "stdio", " then it is left open, and
     no error is signaled."
     }

document { kill,
     TT "kill f", " -- kill the process associated with the file ", TT "f", "."
     }

document { closeIn,
     TT "f << closeIn", " -- closes the input file ", TT "f", ".",
     BR, NOINDENT,
     TT "closeIn f", " -- closes the input file ", TT "f", ".",
     PARA,
     "If the file was open for both input and output, it remains
     open for output."
     }

document { closeOut,
     TT "f << closeOut", " -- closes the output file ", TT "f", ".",
     BR, NOINDENT,
     TT "closeOut f", " -- closes the output file ", TT "f", ".",
     PARA,
     "Any buffered output is first written to the file,
     and the return value is an integer, normally 0, or -1
     on error, or the return status of the child process
     in case the the file was a pipe.",
     PARA,
     "If the file was open for both input and output, it remains
     open for input."
     }

document { flush,
     TT "f << flush", " -- writes out any buffered output for the output file f.",
     }

document { endl,
     TT "f << endl", " -- ends the line currently being put out to the
     file ", TT "f", ".",
     PARA,
     "It is an essential portable programming practice to use ", TT "endl", "
     always, for writing newline characters (see ", TO "newline", ") to a
     file will not terminate a line containing nets properly,
     and it will not flush the output buffer."
     }

document { symbol "newline",
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

document { collectGarbage,
     TT "collectGarbage()", " -- attempt a garbage collection.",
     PARA,
     SEEALSO "GC garbage collector"
     }

document { gcDump,
     TT "gcDump()", " -- produces a dump of the status of the garbage collector.",
     PARA,
     "Users will normally not want to use this function.  It calls the 
     function ", TT "GC_dump", " in the garbage collector, and the output can
     be used to debug problems with memory allocation.",
     PARA,
     SEEALSO "GC garbage collector"
     }

document { lookupCount,
     TT "lookupCount s", " -- the number of times the symbol ", TT "s", " has been
     encountered in source code presented to the interpreter."
     }

document { symbol "version",
     TT "version", " -- a hash table describing this version of the program.",
     PARA,
     EXAMPLE "version"
     }

document { Database,
     HEADLINE "the class of all database files",
     "A database file is just like a hash table, except both the keys and
     values have to be strings.",
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
     SEEALSO {"HashTable", "String"}
     }

document { reorganize, HEADLINE "reorganize a database file",
     TT "reorganize x", " -- reorganize the database ", TT "file", " x, compactifying it.",
     PARA,
     SEEALSO "Database"
     }

document { openDatabase, HEADLINE "open a database file",
     TT "openDatabase \"filename\"", " -- open a database file with the given
     file name."
     }

document { openDatabaseOut, HEADLINE "open a database file for writing",
     TT "openDatabaseOut \"filename\"", " -- open a database file with the given
     file name, and allow changes to be made to it."
     }

document { firstkey, HEADLINE "get the first key",
     TT "firstkey f", " -- return the first key available in the database
     file ", TT "f", ".",
     PARA,
     "Returns ", TT "null", " if none.",
     PARA,
     SEEALSO "Database"
     }

document { nextkey,
     TT "nextkey f", " -- return the next key available in the database
     file f.",
     PARA,
     "Returns ", TT "null", " if none.",
     PARA,
     SEEALSO "Database"
     }

document { addStartFunction,
     TT "addStartFunction (() -> ...)", " -- record a function for later 
     execution, when the program is restarted after loading dumped data.",
     PARA,
     SEEALSO "runStartFunctions"
     }

document { addEndFunction,
     TT "addEndFunction (() -> ...)", " -- record a function for later 
     execution, when the program is exited.",
     PARA,
     "Warning: in the current implementation, the function will be run
     only if the program is explicitly exited with ", TO "exit", ", and not
     if it encounters end of file.",
     PARA,
     SEEALSO "runEndFunctions"
     }

document { runStartFunctions,
     TT "runStartFunctions()", " -- call all the functions previously recorded
     by ", TO "addStartFunction", ".",
     PARA,
     "This function is intended for internal use only.",
     PARA,
     "The funuctions are called with no arguments."
     }

document { runEndFunctions,
     TT "runEndFunctions()", " -- call all the functions previously recorded
     by ", TO "addEndFunction", ".",
     PARA,
     "This function is intended for internal use only.",
     PARA,
     "The funuctions are called with no arguments."
     }

document { symbol "oo",
     TT "oo", " -- denotes the value of the expression on the previous output
     line.",
     SEEALSO { "oo", "ooo", "oooo" }
     }

document { symbol "ooo",
     TT "ooo", " -- denotes the value of the expression on the output line
     two lines above.",
     SEEALSO { "oo", "oooo" }
     }

document { symbol "oooo",
     TT "oooo", " -- denotes the value of the expression on the output line
     three lines above.",
     SEEALSO { "oo", "ooo" }
     }

document { InverseMethod,
     TT "InverseMethod", " -- a key used under which is stored a method
     for computing multiplicative inverses.",
     PARA,
     "Internal routines for computing powers call upon that method when
     the exponent is negative."
     }

document { "or",
     HEADLINE "disjunction",
     TT "t or u", " -- returns true if ", TT "t", " is true or ", TT "u", "
     is true.",
     PARA,
     "If ", TT "t", " is true, then the code in ", TT "u", " is not evaluated.",
     SEEALSO{ "and", "not" }
     }

document { "and",
     HEADLINE "conjunction",
     TT "t and u", " -- returns true if ", TT "t", " is true and ", TT "u", "
     is true.",
     PARA,
     "If ", TT "t", " is false, then the code in ", TT "u", " is not evaluated.",
     SEEALSO{ "or", "not" }
     }

document { locate, HEADLINE "locate source code",
     TT "locate f", " -- for a symbol interpreted function ", TT "f", " 
     returns a sequence ", TT "(n,i,j)", " describing the location of
     the definition in the source code.  The name of the source file 
     is ", TT "n", " and the code is occupies lines ", TT "i", " through
     ", TT "j", ". If the ", TT "f", " is compiled, then the location 
     is not available, and ", TO "null", " is returned.",
     PARA,
     "If ", TT "f", " is a sequence, then ", TO "lookup", " is applied
     first, and then the location of the resulting function is provided.",
     PARA,
     "If ", TT "f", " is ", TO "null", ", then ", TO "null", " is returned."
     }

document { MutableHashTable,
     HEADLINE "the class of all mutable hash tables",
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

document { map,
     TT "map(Y,X,d)", " -- constructs a map to ", TT "Y", " from ", TT "X", " defined by data ", TT "d", ".",
     PARA,
     "This is intended to be a general mechanism for constructing maps
     (homomorphisms) between objects in various categories."
     }
document { precedence,
     TT "precedence x", " -- returns the parsing precedence of ", TT "x", " for use in
     the printing routines.",
     PARA,
     SEEALSO {"Expression", "net", "toString"}
     }

document { hashTable,
     TT "hashTable v", " -- produce a hash table from a list ", TT "v", " of key-value
     pairs.",
     PARA,
     "The pairs may be of the form ", TT "a=>b", ", ", TT "{a,b}", ",
     or ", TT "(a,b)", ".",
     PARA,
     "Missing entries in the list, represented by ", TO "null", ", will be silently
     ignored.",
     PARA,
     EXAMPLE {
	  "x = hashTable {a=>b, c=>d, }",
      	  "x#a"
	  },
     }

document { (toList, HashTable),
     HEADLINE "convert to list",
     TT "toList x", " -- provides a list of keys in the hash table ", TT "x", ".",
     PARA,
     "For a set, which is implemented as a hash table where only the keys are
     important, this is a reasonable operation.  See also, ", TO "keys", ",
     which does the same thing.",
     EXAMPLE {
	  "x = hashTable { a=>1, b=>2}",
	  "toList x"
	  }
     }

document { (toList, BasicList),
     HEADLINE "list of elements",
     TT "toList x", " -- provides a list of elements in the basic list ", TT "x", ".",
     PARA,
     "This is a good way to convert a list of some other type to a list of type
     ", TO "List", ".",
     EXAMPLE {
	  "toList [a,b,c]"
	  } 
     }

document { (toList, Set),
     HEADLINE "list of elements",
     TT "toList x", " -- provides a list of element in the set ", TT "x", ".",
     EXAMPLE {
	  "x = set {a,b,c}",
	  "toList x"
	  }
     }

document { toList, HEADLINE "list of elements" }

document { saturate,
     HEADLINE "saturation of ideal or submodule",
     TT "saturate(I,J,options)", " -- computes the saturation ", TT "(I : J^*)", " 
     of I with respect to ", TT "J", ".  If ", TT "J", " is not given, the 
     ideal ", TT "J", " is taken to be the ideal generated by the variables of 
     the ring ", TT "R", " of ", TT "I", ".",
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
     PARA,
     "The computation is currently not stored anywhere: this means
     that the computation cannot be continued after an interrupt.
     This will be changed in a later version."
     }

document { saturate => Strategy,
     "The strategy option value should be one of the following:",
    SHIELD MENU {
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

document { profile,
     TT "f = profile f", " -- replace a global function f by a profiled version.",
     PARA,
     "The new function is the same as the old one, except that when
     the new function is run, it will record the number of times it
     is called and the total execution time.  Use ", TO "profileSummary", "
     to display the data recorded so far."
     }

document { profileSummary,
     TT "profileSummary", " -- a command which will display the data
     accumulated by running functions produced with ", TO "profile", "."
     }

document { name,
     TT "name", " -- a key under which string giving the preferred name
     of a hash table can be stored.",
     PARA,
     "The system takes care of storing names under this key for the
     major algebraic types, so the user usually doesn't have to bother.",
     EXAMPLE {
	  ///x = new MutableHashTable///,
	  ///x.name = "x"///,
	  ///x///,
	  },
     PARA,
     "A obsolete function called ", TO "name", " has been replaced by
     ", TO "toExternalString", " and ", TO "toString", ".",
     SEEALSO{ "describe"}
     }

document { globalAssignFunction,
     TT "globalAssignFunction", " -- the standard function which can be used
     as a method for ", TO GlobalAssignHook, " so that certain types of
     mutable hash tables ", TT "X", ", when assigned to a global variable, will acquire
     the name of the global variable as their name.  The companion function
     ", TO "globalReleaseFunction", " is used to release the name when the
     global variable gets reassigned.",
     PARA,
     "The current way this function works is by storing the string used for
     printing under ", TT "X.name", " and storing the global variable under
     ", TT "X.Symbol", ".",
     PARA,
     "Another thing done by this function is to apply ", TO use, " to the thing.
     This is used for polynomial rings to assign values to the symbols representing
     the variables (indeterminates) in the ring.",
     PARA,
     EXAMPLE {
	  "X = new Type of MutableHashTable",
      	  "x = new X",
      	  "X.GlobalAssignHook = globalAssignFunction",
      	  "X.GlobalReleaseHook = globalReleaseFunction",
      	  "x' = new X",
      	  "t = {x,x'}",
      	  "x = x' = 44",
      	  "t",
      	  "code globalAssignFunction",
	  },
     SEEALSO { "name", "symbol", "SelfInitializingType" }
     }

document { globalReleaseFunction,
     TT "globalReleaseFunction", " -- the standard function which can be used as
     a method for ", TO GlobalReleaseHook, " so that certain types of things, which
     have acquired as their name the name of a global variable to which they have
     been assigned, will lose that name when a different value is assigned to
     the variable.",
     PARA,
     SEEALSO "globalAssignFunction"
     }

document { Entity,
     HEADLINE "special typsettable objects",
     "Entities are special typsettable objects which have different realizations
     in various typesetting systems.",
     PARA,
     "An example of an entity is ", TO "DownArrow", ", a downward pointing arrow.",
     EXAMPLE {
	  "DownArrow",
	  "peek2(DownArrow,2)",
	  "html DownArrow",
	  }
     }

document { netRows, HEADLINE "list of rows of a net",
     TT "netRows x", " -- produces a list of strings, each containing the
     characters in one row of the ", TT "Net", " ", TT "x", ".",
     PARA,
     "The orginal net, adjusted so its height is 1, may be recovered
     with ", TO "stack", ". The individual strings will have 
     all trailing spaces removed, unless this would make all of them 
     narrower than the original net, in which case the first string
     retains its trailing spaces."
     }

document { symbol ##, HEADLINE "uncurry a function",
     TT "f ## (a,b)", "     -- computes ", TT "((f a) b)", ".",
     BR, NOINDENT,
     TT "f ## (a,b,c)", "   -- computes ", TT "(((f a) b) c)", ".",
     BR, NOINDENT,
     TT "f ## (a,b,c,d)", " -- computes ", TT "((((f a) b) c) d)", ".",
     BR, NOINDENT,
     "... and so on.",
     EXAMPLE {
	  "f = a -> b -> c -> [a,b,c]",
	  "f ## (1,2,3)"
	  }
     }

-- these files are made at compile time
load "gbdoc.m2"
load "gbfunctions.m2"

