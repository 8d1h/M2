--		Copyright 1993-1998 by Daniel R. Grayson

document { "free modules",
     "This node has not been written yet."
     }

document { "making modules from matrices",
     "This node has not been written yet."
     }

document { "manipulating modules",
	  -- document the way to get maps between a module M and its
	  -- version as a cokernel in the overview
     "This node has not been written yet."
     }

document { "maps between modules",
     	  -- (R^5)_{0}
     "This node has not been written yet."
     }

document { "bases of parts of modules",
     "This node has not been written yet."
     }

document { "free resolutions of modules",
     "This node has not been written yet."
     }

document { "making chain complexes by hand",
     "This node has not been written yet."
     }

document { "extracting information from chain complexes",
     "This node has not been written yet."
     }

document { "manipulating chain complexes",
     "This node has not been written yet."
     }

document { "maps between chain complexes",
     "This node has not been written yet."
     }

document { "coherent sheaves",
     "This node has not been written yet."
     }

document { "language and programming overview",
     "In this section we give a comprehensive overview of the user
     language and the main programming features of Macaulay 2.",
     PARA,
     MENU {
     	  (
	       "variables and symbols",
	       MENU {
     	       	    TO "valid names",
		    TO "assigning values",
		    TO "local variables in a file",
		    TO "viewing the symbols defined so far",
		    TO "subscripted variables",
		    TO "numbered variables",
		    }
	       ),
	  (
	       "overview of functions",
	       MENU {
		    TO "using functions",
		    TO "making functions",
		    TO "local variables in a function",
		    TO "making functions with a variable number of arguments",
		    TO "using functions with optional arguments",
		    TO "making new functions with optional arguments",
		    }
	       ),
	  (
	       "basic types",
	       MENU {
		    TO "strings",
		    TO "nets",
		    TO "lists",
		    TO "sequences",
		    TO "hash tables",
		    }
	       ),
	  (
	       "control structures",
	       MENU {
		    TO "loops",
		    TO "mapping over lists",
		    TO "mapping over hash tables",
		    TO "conditional execution",
		    TO "error handling",
		    }
	       ),
	  (
	       "input and output",
	       MENU {
		    TO "printing to the screen",
		    TO "reading files",
		    TO "getting input from the user",
		    TO "creating and writing files",
		    TO "two dimensional formatting",
		    TO "communicating with programs",
		    TO "using sockets",
		    }
	       ),
	  (
	       "interfacing with the system",
	       MENU {
		    TO "running programs",
		    }
	       ),
	  (
	       "classes and types",
	       MENU {
		    TO "what a class is",
		    TO "installing methods",
		    TO "inheritance from parents",
		    TO "making new types",
		    (
			 "method functions",
			 MENU {
			      TO "making a new method function",
			      TO "method functions with a variable number of arguments",
			      TO "method functions with optional arguments",
			      }
			 ),
		    },
	       ),
	  }
     }

document { "valid names",
     "Valid names for symbols may be constructed using letters, digits, and
     the apostrophe, and should not begin with a digit.",
     EXAMPLE {
	  "x",
	  "q0r55",
	  "f'"
	  },
     "Some symbols have preassigned meanings and values.  For example, symbols
     consisting of the letter ", TT "o", " followed by a number are used 
     to store output values.",
     EXAMPLE {
	  "o2",
	  },
     "Other symbols refer to functions built in to Macaulay 2 which provide
     much of its functionality, as we will learn."
     }

document { "assigning values",
     "Use an equal sign to assign values to variables.",
     EXAMPLE {
	  "x",
	  "x = \"abcde\"",
	  "x"
	  },
     "Before assignment, any reference to a variable provides the symbol
     with that name.  After assignment, the assigned value is provided.
     The variable created is global, in the sense that any code placed
     elsewhere which contains a reference to a variable called ", TT "x", "
     will refer to the one we just set.",
     }

document { "local variables in a file",
     "There is a way to construct variables which can be used within a given
     source file, and are invisible to code placed in other files.  We use
     ", TO ":=", " for this.  Assume the code below is placed in a file, and
     that the file is loaded with the ", TO "load", " command.",
     EXAMPLE {
	  "ff := 5",
	  "ff"
	  },
     "The variable above is a local one.  Its value is not available to code
     in other files.",
     PARA,
     "Assume the code above is entered directly by the user into Macaulay 2.  Then
     the variable is still a local one and is not available to code previously loaded
     or to functions previously defined, but it will be available to code 
     loaded subsequently.  We illustrate this below with the variable ", TT "jj", ".",
     PARA,
     EXAMPLE {
	  "hh = () -> jj",
	  "hh()",
	  "jj = 444",
	  "hh()",
	  "jj := 555",
	  "hh()",
	  "jj"
	  }
     }

document { "viewing the symbols defined so far",
     "After using Macaulay 2 for a while, you may have stored data in
     several variables.  The system also stores output values for you
     in output variables.  You may wish to free the memory space occupied
     by that data, or you may simply wish to remind yourself where you
     stored a previously computed value.",
     PARA,
     "We may use the command ", TO "listUserSymbols", " to obtain a list of the user's
     symbols encountered so far.",
     EXAMPLE {
	  "ff = 20:4; hh = true; kk",
	  "listUserSymbols"
	  },
     "The symbols are listed in chronological order, and the type of value stored
     under it is displayed.",
     PARA,
     "We can clear the output symbols with ", TO "clearOutput", ".",
     EXAMPLE {
     	  "clearOutput",
	  "listUserSymbols"
	  },
     "We can clear all the symbols with ", TO "clearAll", ".",
     EXAMPLE {
     	  "clearAll",
	  "listUserSymbols"
	  },
     }

document { "subscripted variables",
     "It is common in mathematics to use subscripted variables.  We use the underscore
     to represent subscripts.  If we haven't assigned a value to ", TT "x", "
     we may simply start using it as a subscripted variable.  The subscripts can be
     anything.",
     EXAMPLE {
	  "x",
	  "x_4",
	  "x_(2,3)",
	  },
     "The ", TO "..", " operator knows what to do with subscripted variables.",
     EXAMPLE {
	  "x_10 .. x_20",
	  "x_(1,1) .. x_(2,3)",
	  },
     "Values can be assigned to these variables with ", TO "#", ".",
     EXAMPLE {
	  "x#10 = 555;",
	  "x_10",
	  },
     "Be careful not to assign a value to ", TT "x", " itself if you wish to continue
     using it as a subscripted variable.",
     SEEALSO {"IndexedVariable","IndexedVariableTable"}
     }

document { "using functions",
     "There are many functions in Macaulay 2 that do various things.  You can
     get a brief indication of what a function does by typing its name.",
     EXAMPLE "sin",
     "In this case, we see that the function ", TO "sin", " takes a single argument
     ", TT "x", ".  We apply a function to its argument by typing them in adjacent
     positions.  It is possible but not necessary to place parentheses around
     the argument.",
     EXAMPLE {
	  "sin 1.2",
	  "sin(1.2)",
	  "sin(1.0+0.2)",
	  },
     "In parsing the operator ", TO "^", " takes precedence over adjacency, so the
     function is applied after the power is computed in the following code.  This
     may not be what you expect.",
     EXAMPLE "print(10 + 1)^2",
     "Some functions take more than one argument, and the arguments are separated
     by a comma, and then parentheses are needed.",
     EXAMPLE {
	  "append",
	  "append({a,b,c},d)"
	  },
     "Some functions take a variable number of arguments.",
     EXAMPLE {
	  "join",
	  "join({a,b},{c,d},{e,f},{g,h,i})"
	  },
     "Functions, like anything else, can be assigned to variables.  You may do this
     to provide handy private abbreviations.",
     EXAMPLE {
	  "ap = append;",
	  "ap({a,b,c},d)"
	  },
     }

document { "making functions",
     "The operator ", TO "->", " is used to make new functions.  On its left
     we provide the names of the parameters to the function, and to the 
     right we provide the body of the function, an expression involving
     those parameters whose value is to be computed when the function 
     is applied.  Let's illustrate this by makint a function for squaring 
     numbers and calling it ", TT "sq", ".",
     EXAMPLE {
	  "sq = i -> i^2",
	  "sq 10",
	  "sq(5+5)",
	  },
     "When the function is evaluated, the argument is evaluated and assigned
     temporarily as the value of the parameter ", TT "i", ".  In the example
     above, ", TT "i", " was assigned the value ", TT "10", ", and then the 
     body of the function was evaluated, yielding ", TT "100", ".",
     PARA,
     "Here is how we make a function with more than one argument.",
     EXAMPLE {
	  "tm = (i,j) -> i*j",
	  "tm(5,7)",
	  },
     "Functions can be used without assigning them to variables.",
     EXAMPLE {
	  "(i -> i^2) 7",
	  },
     "Functions can even create new functions and return them.",
     EXAMPLE {
	  "g = i -> j -> i+j",
	  "h = g 7",
	  "h 100",
	  },
     "What happened here is that when ", TT "g 7", " was evaluated, the value ", TT "7", "
     was assigned to ", TT "i", " and the body of ", TT "g", " was evaluated, producing
     the function ", TT "j -> i+j", " which was then assigned to ", TT "h", ".  When the
     expression ", TT "h 100", " was evaluated, the value ", TT "100", " was assigned to
     ", TT "j", " and the body of ", TT "h", ", which is ", TT "i+j", ", was evaluated,
     yielding ", TT "107", ".  As long as the function ", TT "h", " is reachable, the 
     memory location where the value of ", TT "i", " is stored will be reserved, and kept
     distinct from other uses of the same code.  This means we can reuse ", TT "g", " without
     fear, as we demonstrate in the following code.",
     EXAMPLE {
	  "k = g 37",
	  "{h 100, k 100}"
	  }
     }

document { "making functions with a variable number of arguments",
     "It is easy to write a function with a variable number of arguments.
     Define the function with just one parameter, with no parentheses around
     it.  If the function is called with several arguments, the value of the
     single parameter will be a sequence containing the several arguments;
     if the function is called with one argument, the value of the parameter
     will be that single argument.",
     EXAMPLE {
	  "f = x -> {class x, if class x === Sequence then #x};",
	  "f()",
	  "f(3)",
	  "f(3,4)",
	  "f(3,4,5)",
	  },
     "We could use the function ", TO "sequence", " to bring the case where there
     is just one argument into line with the others.  It will enclose anything
     that is not a sequence in a sequence of length one.",
     EXAMPLE {
	  "f = x -> (
     x = sequence x;
     {class x, #x});",
	  "f()",
	  "f(3)",
	  "f(3,4)",
	  "f(3,4,5)",
	  },
     "As an aside, we reveal that there is a way to define a function of one argument
     which will signal an error if it's given more than one argument: put
     parentheses around the single parameter in the definition of the function.
     As a side effect it can be used to extract the single element from a
     singleton sequence.",
     EXAMPLE {
	  "((x) -> x) 3",
	  "singleton 3",
	  "((x) -> x) oo",
	  }
     }

document { "using functions with optional arguments",
     "Some functions accept optional arguments.  Each of these optional arguments
     has a name.  For example, one of the optional arguments for ", TO "gb", "
     is named ", TO "DegreeLimit", "; it can be used to specify that the computation
     should stop after a certain degree has been reached.  Values for optional
     arguments are specified by providing additional arguments of the form ", TT "B=>v", "
     where ", TT "B", " is the name of the optional argument, and ", TT "v", " is
     the value provided for it.",
     EXAMPLE {
     	  "R = ZZ/101[x,y,z,w];",
     	  "gb ideal(x*y-z^2,y^2-w^2)",
	  "gb(ideal(x*y-z^2,y^2-w^2),DegreeLimit => 2)",
	  },
     "The names and default values of the optional arguments for a function can
     be obtained with ", TO "options", ", as follows.",
     EXAMPLE {
	  "o = options res"
	  },
     "The value returned is a type of hash table, and can be used to obtain particular
     default values.",
     EXAMPLE "o.SortStrategy",
     "The entry ", TT "DegreeLimit => 2", " is called an option.  Internally it is
     represented as a type of list of length 2.",
     EXAMPLE {
	  "DegreeLimit => 2",
	  "peek oo"
	  },
     }

document { "making new functions with optional arguments",
     "Let's consider an example where we wish to construct a linear function of ", TT "x", " 
     called ", TT "f", ", with the slope and y-intercept of the graph being optional
     arguments of ", TT "f", ".  We use the ", TT "@", " operator to attach the default
     values to our function, coded in a special way.",
     EXAMPLE {
	  "f = {Slope => 1, Intercept => 1} @ 
    (opts -> x -> x * opts.Slope + opts.Intercept)",
	  "f 5",
	  "f(5,Slope => 100)",
	  "f(5,Slope => 100, Intercept => 1000)",
	  },
     "In the example the function body is the code ", TT "x * opts.Slope + opts.Intercept", ".
     When it is evaluated, a hash table is assigned to ", TT "opts", "; its
     keys are the names of the optional arguments, and the values
     are the corresponding current values, obtained either from the default values 
     specified in the definition of ", TT "f", ", or from the options specified at 
     the time ", TT "f", " is called.",
     PARA,
     "In the example above, the inner function has just one argument, ", TT "x", ",
     but handling multiple arguments is just as easy.  Here is an example with two
     arguments.",
     EXAMPLE {
	  "f = {a => 1000} @ (o -> (x,y) -> x * o.a + y);",
	  "f(3,7)",
	  "f(5,11,a=>10^20)",
	  },
     }

document { "replacements for commands and scripts from Macaulay",
     "This node has not been written yet."
     }

document { "conditional execution",
     "The basic way to control the execution of code is with the ", TO "if", "
     expression.  Such an expression typically has the form ", TT "if X then Y else Z", "
     and is evaluated as follows.  First ", TT "X", " is evaluated.  If the result is ", TT "true", ",
     then the value of ", TT "Y", " is provided, and if the result is ", TT "false", ", then the value of ", TT "Z", "
     is provided.  An error is signalled if the value of ", TT "X", " is anything but ", TT "true", " or
     ", TT "false", ".",
     EXAMPLE {
	  ///(-4 .. 4) / 
     (i -> if i < 0 then "neg" 
	  else if i == 0 then "zer" 
	  else "pos")///
	  },
     "The else clause may be omitted from an ", TT "if", " expression.  In that case, 
     if value of the predicate ", TT "X", " is false, then ", TT "null", " is provided 
     as the value of the ", TT "if", " expression.",
     EXAMPLE {
	  ///(-4 .. 4) / 
     (i -> if i < 0 then "neg" 
	  else if i == 0 then "zer")///
	  },
     "There is a variety of predicate functions (such as ", TT "<", ") which yield
     ", TT "true", " or ", TT "false", " and can be used as the predicate in 
     an ", TT "if", " expression. Here is a partial list of such functions 
     and operators: ",
     TO "==", ", ",
     TO "!=", ", ",
     TO "===", ", ",
     TO "=!=", ", ",
     TO "<", ", ",
     TO ">", ", ",
     TO "<=", ", ",
     TO ">=", ", ",
     TO ".?", ", ",
     TO "#?", ", ",
     TO "member", ", ",
     TO "mutable", ", ",
     TO "isAffineRing", ", ",
     TO "isBorel", ", ",
     TO "isCommutative", ", ",
     TO "isDirectSum", ", ",
     TO "isField", ", ",
     TO "isFreeModule", ", ",
     TO "isHomogeneous", ", ",
     TO "isIdeal", ", ",
     TO "isInjective", ", ",
     TO "isIsomorphism", ", ",
     TO "isModule", ", ",
     TO "isPolynomialRing", ", ",
     TO "isPrime", ", ",
     TO "isPrimitive", ", ",
     TO "isQuotientModule", ", ",
     TO "isQuotientOf", ", ",
     TO "isQuotientRing", ", ",
     TO "isRing", ", ",
     TO "isSubmodule", ", ",
     TO "isSubset", ", ",
     TO "isSurjective", ", ",
     TO "isTable", ", ",
     TO "isUnit", ", ",
     TO "isWellDefined", ".  Results of these tests may be combined with 
     ", TT "not", ", ", TT "and", ", and ", TT "or", "."
     }

document { "loops",
     "An expression of the form ", TT "while X do Y", " operates by evaluating
     ", TT "X", " repeatedly.  Each time the value of ", TT "X", " is true, ", TT "Y", " is evaluated once.
     When finally the value of ", TT "X", " is false then ", TT "null", " is returned as the value
     of the ", TT "while", " expression.",
     EXAMPLE {
	  "i = 0;",
	  ///while i < 20 do (<< " " << i; i = i + 1); << endl///
	  },
     "In the example above, ", TT "X", " is the predicate ", TT "i < 20", " and ", TT "Y", " is
     the code ", TT ///(<< " " << i; i = i + 1)///, ".  Notice the use of the
     semicolon within Y which separates two expression.",
     PARA,
     "The semicolon can also be used with the predicate ", TT "X", " to do other things
     before the test is performed.  This works because the value of an expression
     of the form ", TT "(A;B;C;D;E)", " is obtained by evaluating each of the
     parts, and providing the value of the last part (in this case, ", TT "E", "),
     as the value of the whole expression.  Thus, if the value of E is always
     true or false, the expression ", TT "(A;B;C;D;E)", " can be used as
     the predicate ", TT "X", ".  We illustrate this in the following example.",
     EXAMPLE {
	  "i = 0;",
	  ///while (<< " " << i; i < 20) do i = i+1; << endl///
	  },
     "As a further indication of the power of this construction, consider
     an expression of the following form.", 
     PRE "     while (A; not B) and (C; not D) do (E; F)",
     "It is the Macaulay 2 equivalent of C code that looks like this:",
     PRE "     while (TRUE) { A; if (B) break; C; if (D) break; E; F; }",
     }

document { "numbered variables",
     "One way to get many variables suitable for use as indeterminates in
     a polynomial ring is with the function ", TO "vars", ".  It converts 
     a list or sequence of integers into symbols.  It prefers to hand out
     symbols whose name consists of a single letter, but there are only 52 
     such symbols, so it also uses symbols such as ", TT "x55", " 
     and ", TT "X44", ".",
     EXAMPLE {
	  "vars (0 .. 9,40,100,-100)"
	  },
     "These variables can be used to make polynomial rings.",
     EXAMPLE {
	  "ZZ[vars(0 .. 10)]"
	  }
     }

document { "local variables in a function",
     "A local variable in a function is one which is not visible to
     code in other locations.  Correct use of local variables is
     important, for data stored in global variables will stay around
     forever, needlessly occupying valuable memory space.  For recursive
     functions especially, it is important to use local variables so that
     one invocation of the function doesn't interfere with another.",
     PARA,
     "The simplest way to create a local variable in a function is with
     the assignment operator ", TO ":=", ".  The expression ", TT "X := Y", "
     means that the value of ", TT "Y", " will be assigned to a newly created local
     variable whose name is ", TT "X", ".  Once ", TT "X", " has been created, new values can
     be assigned to it with expressions like ", TT "X = Z", ".",
     EXAMPLE {
	  "i = 22;",
	  ///f = () -> (i := 0; while i<9 do (<< i << " "; i=i+1); <<endl;)///,
	  "f()",
	  "i"
	  },
     "In the example above, we see that the function ", TT "f", " does 
     its work with a local variable ", TT "i", " which is unrelated to the global 
     variable ", TT "i", " introduced on the first line.",
     PARA,
     "In the next example, we show that the local variables in two
     invocations of a function don't interfere with each other.  We
     write a function f which returns a newly created counting function.  
     The counting function simply returns the number of times it has 
     been called.",
     EXAMPLE {
	  "f = () -> (i := 0; () -> i = i+1)",
	  },
     "Let's use ", TT "f", " to create counting functions and show that they operate
     independently.",
     EXAMPLE {
	  "p = f()",
	  "q = f()",
	  "p(),p(),p(),p(),q(),p(),p(),q(),p(),p()"
	  }
     }

document { "strings",
     "A string is a sequence of characters.  These strings can
     be manipulated in various ways to produce printed output.
     One enters a string by surrounding them with quotation marks.",
     EXAMPLE {
	  ///"abcdefghij"///,
	  },
     "Strings may contain newline characters.",
     EXAMPLE ///"abcde
fghij"///,
     "Strings, like anything else, can be assigned to variables.",
     EXAMPLE ///x = "abcdefghij"///,
     "There are escape sequences which make it possible to
     enter special characters:",  PRE 
"      \\n             newline
      \\f             form feed
      \\r             return
      \\\\             \\ 
      \\\"             \"
      \\t             tab
      \\xxx           ascii character with octal value xxx",
     EXAMPLE ///y = "abc\101\102\n\tstu"///,
     "We can use ", TO "peek", " to see what characters are in the string.",
     EXAMPLE "peek y",
     "Another way to enter special characters into strings is to use ", TO "///", "
     as the string delimiter.",
     EXAMPLE ("///" | ///a \ n = "c"/// | "///"),
     "The function ", TO "ascii", " converts strings to lists of
     ascii character code, and back again.",
     EXAMPLE {
      	  "ascii y",
      	  "ascii oo",
	  },
     "We may use the operator ", TO "|", " to concatenate strings.",
     EXAMPLE "x|x|x",
     "The operator ", TO "#", " computes the length of a string.",
     EXAMPLE "#x",
     "We may also use the operator ", TO "#", " to extract single characters from
     a string.  Warning: we number the characters starting with 0.",
     EXAMPLE "x#5",
     "The function ", TO "substring", " will extract portions of a string
     for us.",
     EXAMPLE {
	  "substring(x,5)",
	  "substring(x,5,2)",
	  },
     }

document { "nets",
     "A net is a rectangular two-dimensional array of characters, together
     with an imaginary horizontal baseline that allows nets to be assembled
     easily into lines of text.  A string is regarded as a net with one row.",
     PARA,
     "Nets are used extensively for such things as formatting polynomials for
     display on ascii terminals.  Use ", TO "net", " to obtain such nets directly.",
     EXAMPLE {
	  "R = ZZ[x,y];",
	  "(x+y)^2",
	  "n = net oo",
	  },
     "We may use ", TO "peek", " to clarify the extent of a net.",
     EXAMPLE "peek n",
     "One way to create nets directly is with the operator ", TT "||", ", 
     which concatenates strings or nets vertically.",
     EXAMPLE ///x = "a" || "bb" || "ccc"///,
     "We may use the operator ", TO "^", " to raise or lower a net with 
     respect to its baseline.  Look carefully to see how the baseline has
     moved - it is aligned with the equal sign.",
     EXAMPLE "x^2",
     "Nets may appear in lists, and elsewhere.",
     EXAMPLE {
	  "{x,x^1,x^2}",
	  },
     "Nets and strings can be concatenated horizontally with the operator ", TO "|", ".",
     EXAMPLE ///x^2 | "-------" | x///,
     "Each net has a width, depth, and height.  The width is the number
     of characters in each row.  The depth is the number of rows below
     the baseline, and the height is the number of rows above the baseline.
     The depth and the height can be negative.",
     EXAMPLE "width x, height x, depth x",
     "We may extract the rows of a net as strings with ", TO "netRows", ".",
     EXAMPLE {
	  "netRows x",
	  "peek oo"
	  }
     }

document { "lists",
     "A list is a handy way to store a series of things.  We create one
     by separating the elements of the series by commas and surrounding 
     the series with braces.",
     EXAMPLE "x = {a,b,c,d,e}",
     "We retrieve the length of a list with the operator ", TO "#", ".",
     EXAMPLE "#x",
     "We use it also to obtain a particular element.  Warning: we number
     the elements starting with 0.",
     EXAMPLE "x#2",
     "The functions ", TO "first", " and ", TO "last", " retrieve the
     first and last elements of a list.",
     EXAMPLE "first x, last x",
     "Omitting an element of a list causes the symbol ", TO "null", " to 
     be inserted in its place.",
     EXAMPLE {
	  "g = {3,4,,5}",
	  "peek g",
	  },
     "Lists can be used as vectors, provided their elements are the sorts of
     things that can be added and mutliplied.",
     EXAMPLE "10000*{3,4,5} + {1,2,3}",     
     "If the elements of a list are themselves lists, we say that we have
     a nested list.",
     EXAMPLE {
	  "y = {{a,b,c},{d,{e,f}}}",
	  "#y"
	  },
     "One level of nesting may be eliminated with ", TO "flatten", ".",
     EXAMPLE "flatten y",
     "A table is a list whose elements are lists all of the same length.  
     The inner lists are regarded as rows when the table is displayed as a
     two-dimensional array with ", TO "MatrixExpression", ".",
     EXAMPLE {
	  "z = {{a,1},{b,2},{c,3}}",
	  "isTable z",
      	  "MatrixExpression z",
	  },
     "Various other functions for manipulating lists include ",
     TO (quote |, List, List), ", ",
     TO "append", ", ",
     TO "between", ", ",
     TO "delete", ", ",
     TO "drop", ", ",
     TO "join", ", ",
     TO "mingle", ", ",
     TO "pack", ", ",
     TO "prepend", ", ",
     TO "reverse", ", ",
     TO "rsort", ", ",
     TO "sort", ", ",
     TO "take", ", and ",
     TO "unique", ".",
     }

document { "sequences",
     "A sequence is like a list, except that parentheses are used
     instead of braces to create them and to print them.  Sequences
     are implemented in a more efficient way than lists, since a sequence is 
     created every time a function is called with more than one argument.  
     Another difference is that new types of list can be created by the user, 
     but not new types of sequence.",
     EXAMPLE "x = (a,b,c,d,e)",
     "It is a bit harder to create a sequence of length 1, since no comma
     would be involved, and parentheses are also used for simple grouping
     of algebraic expressions.",
     EXAMPLE "(a)",
     "We provide the function ", TO "singleton", ", which can be used to 
     create a sequence of length 1.  Its name appears when a sequence 
     of length 1 is displayed.",
     EXAMPLE {
	  "singleton a",
	  },
     "Most of the functions that apply to lists also work with sequences.  We
     give just one example.",
     EXAMPLE "append(x,f)",
     "The operator ", TO "..", " can be used to create sequences of numbers,
     sequences of subscripted variables, or sequences of those particular 
     symbols that are known to ", TO "vars", ", and so on.",
     EXAMPLE {
	  "-3 .. 3",
	  "y_1 .. y_10",
	  "a .. p",
	  "(1,1) .. (2,3)",
	  "{a,1} .. {c,2}",
	  },
     "The operator ", TO (quote :, ZZ, Thing), " can be used to create sequences
     by replicating something a certain number of times.",
     EXAMPLE "12:a",
     "Notice what happens when we try to construct a list using ", TO "..", " 
     or ", TO ":", ".",
     EXAMPLE {
	  "z = {3 .. 6, 9, 3:12}",
	  },
     "The result above is a list of length 3 some of whose elements are sequences.
     This may be a problem if the user intended to produce the list 
     ", TT "{3, 4, 5, 6, 9, 12, 12, 12}", ".  The function ", TO "splice", " can
     be used to flatten out one level of nesting - think of it as removing those
     pairs of parentheses which are one level in.",
     EXAMPLE "splice z",
     "The difference between ", TO "splice", " and ", TO "flatten", " is that
     ", TO "flatten", " removes pairs of braces.",
     PARA,
     "The functions ", TO "toList", " and ", TO "toSequence", " are provided
     for converting between lists to sequences.",
     EXAMPLE {
	  "toList x",
	  "toSequence oo",
	  },
     "Other functions for dealing especially with sequences
     include ", TO "sequence", " and ", TO "deepSplice", "."
     }

document { "hash tables",
     "A hash table is a data structure that can implement a function
     whose domain is a finite set.  An element of the domain is called
     a key.  The hash table stores the key-value pairs in such a way
     that when presented with a key, the corresponding value can be
     quickly recovered.",
     PARA,
     "A dictionary could be implemented as a hash table: the keys would
     be the words in the language, and the values could be the definitions
     of the words.",
     PARA,
     "A phone book could also be implemented as a hash table: the keys would
     be the names of the subscribers, and the values could be the corresponding
     phone numbers.  (We exclude the possibility of two subscribers with
     the same name.)",
     PARA,
     "As an example we implement a phone book.",
     EXAMPLE {
	  ///book = new HashTable from {
     "Joe" => "344-5567",
     "Sarah" => "567-4223",
     "John" => "322-1456"}///,
     	  },
     "We use the operator ", TO "#", " to obtain values from the phone book.",
     EXAMPLE ///book#"Sarah"///,
     "The operator ", TO "#?", " can be used to tell us whether a given key
     has an entry in the hash table.",
     EXAMPLE ///book#?"Mary"///,
     "We have implemented the notion of set via hash tables in which every value
     is the number 1.",
     EXAMPLE {
	  "x = set {a,b,c,r,t}",
	  "peek x",
	  "x#?a",
	  "x#?4",
	  },
     "There is a type of hash table that is mutable, i.e., a hash table
     whose entries can be changed.  They are changed with assignment 
     statements of the form ", TT "x#key=value", ".",
     EXAMPLE {
	  ///x = new MutableHashTable;///,
	  ///x#"Joe" = "344-5567";///,
	  ///x#3 = {a,b,c};///,
	  ///x#{1,2} = 44;///,
	  ///x#3///,
	  ///x#?4///,
	  },
     "When a mutable hash table is printed, its contents are not displayed.  
     This prevents infinite loops in printing routines.",
     EXAMPLE "x",
     "Use ", TO "peek", " to see the contents of a mutable hash table.",
     EXAMPLE "peek x",
     "A variant of ", TO "#", " is ", TO ".", ".  It takes only global symbols
     as keys, and ignores their values.",
     EXAMPLE {
	  "p=4;",
	  "x.p = 444;",
	  "x.p",
	  "x#?4",
	  },
     "Other functions for manipulating hash tables include ",
     TO "apply", ", ",
     TO "applyKeys", ", ",
     TO "applyPairs", ", ",
     TO "browse", ", ",
     TO "combine", ", ",
     TO "copy", ", ",
     TO "hashTable", ", ",
     TO "keys", ", ",
     TO "merge", ", ",
     TO "mutable", ", ",
     TO "new", ", ",
     TO "pairs", ", ",
     TO "remove", ", ",
     TO "scanKeys", ", ",
     TO "scanPairs", ", ",
     TO "select", ", and ",
     TO "values", ".",
     PARA,
     "For details of the mechanism underlying hash tables, see ", TO "hashing", ".",
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
     This provides another argument in favor of taking the second approach listed
     above.",
     SEEALSO "HashTable"
     }

document { "making new types",
     "This node has not been written yet."
     }

document { "mapping over lists",
     "This node has not been written yet."
     -- scan, apply, accumulate, any, all, fold, ...
     }

document { "error handling",
     "This node has not been written yet."
     }

document { "communicating with programs",
     "This node has not been written yet."
     }

document { "making a new method function",
     "This node has not been written yet."
     }

document { "what a class is",
     "This node has not been written yet."
     }

document { "installing methods",
     "This node has not been written yet."
     }

document { "method functions with a variable number of arguments",
     "This node has not been written yet."
     }

document { "mapping over hash tables",
     "This node has not been written yet."
     }

document { "creating and writing files",
     "This node has not been written yet."
     }

document { "inheritance from parents",
     "This node has not been written yet."
     }

document { "printing to the screen",
     "This node has not been written yet."
     }

document { "two dimensional formatting",
     "This node has not been written yet."
     }

document { "running programs",
     "This node has not been written yet."
     }

document { "using sockets",
     "This node has not been written yet."
     }

document { "reading files",
     "This node has not been written yet."
     }

document { (quote @, List, Function),
     "This node has not been written yet."
     }

document { "getting input from the user",
     "This node has not been written yet."
     }

document { "method functions with optional arguments",
     "This node has not been written yet."
     }

document { (quote @, OptionTable, Function),
     "This node has not been written yet."
     }
