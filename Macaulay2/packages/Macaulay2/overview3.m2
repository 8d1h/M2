--		Copyright 1993-1999 by Daniel R. Grayson


document {
     Key => "COPYING",
     Headline => "the Macaulay 2 license agreement",
     "This is the text of the license agreement under which Macaulay 2 is distributed.",
     PARA,
     if sourceHomeDirectory =!= null then PRE separate("\f",get(sourceHomeDirectory | "COPYING"))
     else if prefixDirectory =!= null then PRE separate("\f",get(prefixDirectory | LAYOUT#"docm2rel" | "COPYING"))
     else (
	  stderr << "warning: can't locate file \"COPYING\"" << endl;
	  SEQ {"See the GNU GENERAL PUBLIC LICENSE, Version 2, June 1991, available at ", HREF "http://www.gnu.org/licenses/gpl.txt", "."}
	  )
     }

document {
     Key => "Copyright and license",
     "Macaulay 2, its object code and source code, and its documentation,
     are copyright by Daniel R. Grayson and Michael E. Stillman.  We permit 
     you to use it under the terms of the GNU General Public License, version
     2, as published by the Free Software Foundation, and as contained in the file ", TT "COPYING", " accompanying the program.",
     Subnodes => {
     	  TOH "COPYING",
      	  "The following free libraries have been compiled into Macaulay 2.",
	  TO "Singular-Factory",
	  TO "Singular-Libfac",
	  TO "GNU MP",
	  TO "GC garbage collector"
	  }
     }

document {
     Key => "GC garbage collector",
     "Macaulay 2 uses the excellent garbage collector GC, version ", version#"gc version", ",
     written by Hans-J. Boehm and Alan J. Demers and generously licensed
     to the public.  It is available at
     ", HREF "http://www.hpl.hp.com/personal/Hans_Boehm/gc/", ".",
     PARA,
     SeeAlso => {"collectGarbage" }
     }

document {
     Key => "Singular-Factory",
     "With the kind permission of the authors of Singular, 
     G.-M. Greuel, R. Stobbe, G. Pfister, H. Schoenemann, and J. Schmidt,
     University of Kaiserslautern, Macaulay 2 incorporates ", TT "Singular-Factory", ",
     version ", version#"factory version", ", a free library of polynomial routines
     that provides for factorization of polynomials.  It is distributed under the
     terms of the GNU General Public License and is available at 
     ", HREF "ftp://www.mathematik.uni-kl.de/pub/Math/Singular/Factory"," and at 
     ", HREF "http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES", ".  It
     is part of ", TT "Singular", ", whose home page is ", HREF "http://www.singular.uni-kl.de/", ".",
     PARA,
     "The following important routines call upon it:",
     UL {
	  TOH "factor",
	  TOH "gcd",
	  TOH "decompose",
	  TOH "irreducibleCharacteristicSeries"
	  }
     }

document {
     Key => "Singular-Libfac",
     "With the kind permission of the author, Michael Messollen, Macaulay 2
     incorporates ", TT "Singular-Libfac", ", version ", version#"libfac version", ",
     a free library of routines, depending on ", TO "Singular-Factory", ", that provides
     factorization of multivariate polynomials over finite fields and computation of the minimal associated primes 
     of ideals via characteristic sets.  It is distributed under the terms of the
     GNU General Public License, and is available at 
     ", HREF "ftp://www.mathematik.uni-kl.de/pub/Math/Singular/Libfac"," and at 
     ", HREF "http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES", ".  It
     is part of ", TT "Singular", ", whose home page is ", HREF "http://www.singular.uni-kl.de/", ".",
     PARA,
     "The following important routines call upon it:",
     UL {
	  TOH "factor",
	  TOH "gcd",
	  TOH "decompose",
	  TOH "irreducibleCharacteristicSeries"
	  }
     }

document {
     Key => "GNU MP",
     "The GNU MP library, gmp, version ", version#"gmp version", " provides
     routines for arbitrary precision integer and floating point arithmetic,
     and is distributed under the terms of the GNU Lesser General Public License.
     It's available at ", HREF "ftp://ftp.gnu.org/gnu/gmp/", " and 
     ", HREF "http://www.swox.com/gmp/", "."
     }

document {
     Key => "operators",
     "Here is a list of unary and binary operators in the language.  Many
     of them can have methods installed for handling arguments of specific
     types.",
     UL {
          SEQ (TO " ", " -- function application"),
          SEQ (TO ",", " -- separates elements of lists or sequences"),
          SEQ (TO ";", " -- statement separator"),
          SEQ (TO "=", " -- assignment"),
          SEQ (TO "<-", " -- assignment with left hand side evaluated"),
	  SEQ (TO "->"),
          SEQ (TO ":=", " -- assignment of method or new local variable"),
          SEQ (TO "==", " -- equal"),
          SEQ (TO "!=", " -- not equal"),
          SEQ (TO "===", " -- strictly equal"),
          SEQ (TO "=!=", " -- strictly not equal"),
          SEQ (TO "<", " -- less than"),
          SEQ (TO "<=", " -- less than or equal"),
          SEQ (TO "=>", " -- option"),
          SEQ (TO ">", " -- greater than"),
          SEQ (TO ">=", " -- greater than or equal"),
          SEQ (TO "?", " -- comparison"),
	  SEQ (TO "or", " -- or"),
	  SEQ (TO "and", " -- and"),
          SEQ (TO "not", " -- negation"),
          SEQ (TO "..", " -- sequence builder"),
          SEQ (TO "+", " -- addition"),
          SEQ (TO "-", " -- subtraction"),
          SEQ (TO "*", " -- multiplication"),
          SEQ (TO "/", " -- division, or applying a function to elements of a list"),
          SEQ (TO "//", " -- quotient"),
          SEQ (TO "\\\\", " -- left quotient"),
          SEQ (TO "%", " -- remainder"),
          SEQ (TO "^", " -- power"),
          SEQ (TO "^**", " -- tensor power"),
          SEQ (TO "!", " -- factorial"),
          SEQ (TO "++", " -- direct sum"),
          SEQ (TO "**", " -- tensor product"),
          SEQ (TO "<<", " -- file output, bit shifting"),
          SEQ (TO ">>", " -- bit shifting and attaching optional inputs to functions"),
          SEQ (TO "_", " -- subscripting"),
          SEQ (TO ".", " -- hash table access or assignment"),
          SEQ (TO ".?", " -- test for hash table access"),
          SEQ (TO "#", " -- hash table access; length of a list, sequence or hash table"),
          SEQ (TO "#?", " -- test for hash table access"),
          SEQ (TO "|", " -- horizontal concatenation of strings or matrices"),
          SEQ (TO "||", " -- vertical concatenation of strings or matrices"),
          SEQ (TO "&", " -- bit-wise and"),
          SEQ (TO ":", " -- ideal quotient, repetitions"),
          SEQ (TO "\\", " -- applying a function to elements of a list"),
          SEQ (TO "@@", " -- composing functions"),
          SEQ (TO "@"),
          SEQ (TO "^^"),
          SEQ (TO "~", " -- making a coherent sheaf"),
          SEQ (TO "in"),
          SEQ (TO "|-"),
          SEQ (TO "<==>"),
          SEQ (TO "===>"),
          SEQ (TO "==>"),
          SEQ (TO "(*)"),
     	  }
     }

document {
     Key => "Acknowledgements",
     "We thank the National Science Foundation for generous funding since
     1993 for this project, Gert-Martin Greuel and Ruediger Stobbe for the
     incorporation of their library ", TO "Singular-Factory", ", Michael Messollen for
     the incorporation of his library ", TO "Singular-Libfac", ",
     and David Eisenbud, Wolfram Decker and Sorin Popescu for
     early support, encouragement and suggestions.  We also acknowledge an
     intellectual debt to Dave Bayer, who, with Michael Stillman,
     wrote Macaulay, a specialized computer algebra system for algebraic
     geometry and the predecessor of this program."
     }

document {
     Key => "preface",
     "Macaulay 2 is a software system devoted to supporting research in 
     algebraic geometry and commutative algebra, developed with funding
     from the National Science Foundation.  We are eager to help new users
     get started with it.",
     Subnodes => {
	  TOH "Copyright and license",
	  TOH "Acknowledgements",
	  TOH "The authors",
	  }
     }

document {
     Key => "LAYOUT",
     Headline => "relative locations of Macaulay 2 files",
     PARA {
	  "The hash table ", TT "LAYOUT", " is a translation table from symbolic names to directory paths,
	  which are to interpreted relative to the path stored in ", TO "prefixDirectory", ".
	  Some of the entries are strings: these provide paths to various types of files associated with
	  the main Macaulay 2 system.  The remaining entries are functions.  These provide paths to various
	  types of files associated with packages, and accept a string containing the name of the package
	  as argument.  Finally, for convenience, many Macaulay 2 files are regarded as being associated
	  with a special package called ", TO "Macaulay2Core", ", and the corresponding documentation files
	  are part of the package ", TT "Macaulay2", "."
     	  },
     EXAMPLE "LAYOUT",
     PARA {
	  "Let's apply the functions above to the name of a fictional package named \"", TT "FOO", "\" to see what paths are returned."
     	  },
     EXAMPLE ///applyValues (LAYOUT, f -> if instance(f,Function) then f "FOO" else f)///
     }

document {
     Key => "mathematical examples",
     "In this section we present some tutorials which aim to introduce
     the user to some mathematical ways of using Macaulay 2.  The tutorials
     are relatively independent of each other, and each one introduces the use
     of some features of Macaulay 2 in a slow and leisurely way, assuming the
     reader is already familiar with the mathematical concepts involved.  
     ", TO "David Eisenbud", " joins us as a co-author of these tutorials.",
     Subnodes => {
	  TO "Tutorial: Elementary uses of Groebner bases",
	  TO "Tutorial: Canonical Embeddings of Plane Curves and Gonality",
	  TO "Tutorial: Fano varieties",
	  TO "Tutorial: Divisors",
	  }
     }

load "Fano.out"
load "canEmbed.out"
load "divisors.out"
load "elementary.out"

document {
     Key => "basic commutative algebra",
     "This section includes tutorials showing how to do
     basic commutative algebra constructions in Macaulay2.
     This section is being written by Mike Stillman, for use
     with his Fall 2005 course: Math 634, Commutative algebra,
     at Cornell University.  This course covers basic commutative
     algebra, at the level of Atiyah-Macdonald, and Greuel-Pfister.",
     PARA,
     "Macaulay2 examples corresponding to the Singular examples in the
     book by Greuel-Pfister may also be found here.",
     Subnodes => {
	  TO "Elementary uses of Groebner bases I.  Math 634 Fall 2005",
	  TO "Modules in Macaulay2, Math 634, Fall 2005",
	  TO "M2SingularBook"
	  }
     }

     
load "elementary1.out"
load "modules.out"
load "M2SingularBook/doc.m2"

document {
     Key =>  "Developer's Corner",
     Subnodes => {
	  TO "engine",
	  }
     }


document { Key => "frequently encountered problems",
     Subnodes => {
	  }
     }

document {
     Key => "specifying typical values",
     "For the purpose of construction good documentation automatically, it
     is useful to specify the type of value typically returned by a function
     or method.  For example, the function ", TO "isModule", " returns a boolean
     value, and this is specified when creating the method function with the
     option ", TO "TypicalValue", " as follows.",
     PRE ///isModule = method(TypicalValue => Boolean)///,
     PARA,
     "Other functions, such as ", TO "prune", ", return values of various types,
     depending on the type of the arguments provided.  To install a
     function ", TT "f", " as the handler for ", TT "prune", " applied to a matrix,
     we would normally use the following statement.",
     PRE ///prune Matrix := f///,
     "To specify that the value typically returned is a matrix (of class ", TT "Matrix", "),
     we replace ", TT "f", " by ", TT "Matrix => f", ", as follows.",
     PRE ///prune Matrix := Matrix => f///,
     "Here is the way our code looks.",
     EXAMPLE "code(prune, Matrix)",
     "The information is stored in the hash table ", TO "typicalValues", ", and can
     be recovered like this.",
     EXAMPLE "typicalValues#(prune,Matrix)",
     PARA,
     "Warning: don't imagine that a definition of the form ",
     PRE "f = t -> (...)",
     "can be replaced with a declaration of the following form.",
     PRE "f = X => t -> (...)",
     "The difference here is that here we are using simple assignment, rather than
     installing a method.  To document the return type is ", TT "X", " in this case, 
     make an entry in ", TT "typicalValues", " directly.",
     PRE "f = t -> (...)\ntypicalValues#f = X"
     }


document {
     Key => "The authors",
     PARA,
     "To communicate with the authors about the program, use this email address:
     ", HREF {"mailto:Macaulay2@math.uiuc.edu", "<Macaulay2@math.uiuc.edu>"}, ".",
     Subnodes => {
     	  "The authors of Macaulay 2 and the bulk of this manual:",
	  TO "Daniel R. Grayson",
	  TO "Michael E. Stillman",
     	  "Our co-author for the tutorials:",
	  TO "David Eisenbud",
	  }
     }

document {
     Key => "David Eisenbud",
     HREF {"http://www.msri.org/people/staff/de/", "David Eisenbud "}, " ",
     HREF {"mailto:de@msri.org", "<de@msri.org>"}, ".",
     PARA,
     "In this spot will go a brief biography of David Eisenbud."
     }

document {
     Key => "Daniel R. Grayson",
     HREF {"http://www.math.uiuc.edu/~dan/", "Daniel R. Grayson"}, " ",
     HREF {"mailto:dan@math.uiuc.edu", "<dan@math.uiuc.edu>"}, ".",
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
     IMG { "../../Images/Grayson2.jpg", "picture of Grayson" }
     }

document {
     Key => "Michael E. Stillman",
     HREF { "http://www.math.cornell.edu/~mike/", "Michael E. Stillman"}, " ",
     HREF {"mailto:mike@math.cornell.edu", "<mike@math.cornell.edu>"}, ".",
     PARA,
     "Michael E. Stillman received his PhD in Mathematics from Harvard in 1983,
     taught at University of Chicago 1983-85, was at Brandeis and then MIT 1985-87,
     and then came to Cornell University.  His mathematical research concerns
     computational algebraic geometry and algebraic geometry.  He started writing
     syzygy programs as an undergraduate at the University of Illinois, and from
     1983 to 1992 with Dave Bayer he wrote Macaulay, a specialized computer
     algebra system for algebraic geometry and the predecessor of this program."
     }

document {
     Key => "Resources required",
     }

document {
     Key => "syntax",
     "A newline ends a statement if it can, otherwise it acts like any
     white space.",
     EXAMPLE "2+\n3+\n4",
     PARA,
     "Parsing is determined by a triple of numbers attached to each token.
     The following table (produced by the command ", TO "seeParsing", "), 
     displays each of these numbers.",
     EXAMPLE "seeParsing()",
     "Here is the way these numbers work.  The parser maintains a number
     which we will call the current parsing level, or simply, the level.
     The parser builds up an expression until it encounters an input token
     whose parsing precedence is less than or equal to the current level.
     The tokens preceding the offending token are bundled into an expression
     appropriately and incorporated into the containing expression.",
     PARA,
     "When an operator or token is encountered, its binding strength serves
     as the level for parsing the subsequent expression, unless the current level
     is higher, in which case it is used.",
     PARA,
     "Consider a binary operator such as ", TT "*", ".  The relationship between
     its binary binding strength and its parsing precedence turns out to determine
     whether ", TT "a*b*c", " is parsed as ", TT "(a*b)*c", " or as ", TT "a*(b*c)", ".
     When the parser encounters the second ", TT "*", ", the current parsing level 
     is equal to the binding strength of the first ", TT "*", ".  If the binding 
     strength is less than the precedence, then the second ", TT "*", " becomes
     part of the right hand operand of the first ", TT "*", ", and the
     expression is parsed as ", TT "a*(b*c)", ".  Otherwise, the expression is
     parsed as ", TT "(a*b)*c", ".",
     PARA,
     "For unary operators, the unary binding strength is used instead of the binary
     binding strength to reset the current level.  The reason for having both numbers 
     is that some operators can be either unary or binary, depending on the context.
     A good example is ", TO "#", " which binds as tightly as ", TO ".", "
     when used as an infix operator, and binds as loosely as adjacency or
     function application when used as a prefix operator.",
     PARA,
     "To handle expressions like ", TT "b c d", ", where there are no tokens present
     which can serve as a binary multiplication operator, after parsing ", TT "b", ",
     the level will be set to 1 less than the precedence of an identifier,
     so that ", TT "b c d", " will be parsed as ", TT "b (c d)", ".",
     PARA,
     "The comma and semicolon get special treatment; the empty expression can
     occur to the right of the comma or semicolon or to the left of the comma."
     }

document {
     Key => "debugging",
     "Macaulay 2 has a debugger.",
	UL{
	TO "using the debugger",
	},
	"Here are some other debugging tools.",
     UL {
	  TO "assert",
	  TO "benchmark",
	  TO "browse",
	  TO "code",
	  TO "currentFileName",
	  TO "edit",
	  TO "error",
	  TO "errorDepth",
	  TO "flag",
	  TO "listUserSymbols",
     	  TO "locate",
	  TO "methods",
	  TO "on",
	  TO "peek",
	  TO "peek'",
	  TO "profile",
	  TO "shield",
	  TO "showStructure",
	  TO "showUserStructure",
	  TO "try",
	  TO "userSymbols"
	  },
     "These functions are for debugging the kernel interpreter itself, and
     are not intended for users.",
     UL {
	  TO "buckets",
	  TO "seeParsing"
	  }
     }

document {
     Key => "system",
     "Loading files:",
     UL {
	  TO "autoload",
	  TO "initialization file",
	  TO "input",
	  TO "load",
	  TO "needs"
	  },
     "Echoing characters:",
     UL {
	  TO "clearEcho",
	  TO "setEcho"
	  },
     "Dumping and restoring the state of the system:",
     UL {
	  TO "dumpdata",
	  TO "loaddata",
	  TO "restart",
	  TO "addStartFunction",
	  TO "addEndFunction"
	  },
     "Interface to the operating system:",
     UL{
	  TO "top level loop",
	  TO "alarm",
	  TO "currentDirectory",
	  TO "exec",
	  TO "exit",
	  TO "fork",
	  TO "getenv",
	  TO "processID",
	  TO "path",
	  TO "quit",
	  TO "run",
	  TO "sleep",
	  TO "time",
	  TO "timing",
	  TO "temporaryFileName",
	  TO "wait"
	  },
     "Variables with information about the state of the current process:",
     UL {
	  TO "commandLine",
	  TO "environment",
	  TO "version"
	  },
     "Miscellaneous commands:",
     UL {
	  TO "getWWW"
	  },
     "Dealing with the garbage collector:",
     UL {
	  TO "collectGarbage",
	  }
     }

document {
     Key => "initialization file",
     "The file ", TT "init.m2", " is loaded automatically when the
     program is started, if it exists.",
     PARA,
     "On most systems the file is sought in the directory ", TT "$HOME/.Macaulay2/", ",
     where ", TT "$HOME", " is replaced by the path to the user's home
     directory.",
     PARA,
     "Under Mac OS X, the file is sought instead in the
     directory ", TT "$HOME/Library/Application Support/Macaulay2/", ".",
     PARA,
     "If the user wants a file called, say, ", TT "start.m2", " in the current
     directory to be loaded automatically when the program is started, then the
     following line of code can be placed in the file ", TT "init.m2", ".",
     PRE {
	  ///if fileExists "start.m2" then load(currentDirectory|"start.m2")///
	  }
     }

document {
     Key => "combinatorial functions",
     UL {
	  TO "random",
	  TO "binomial",
	  TO "subsets",
	  TO "tally",
	  TO "partitions"
	  }
     }

document {
     Key => "top level loop",
     "The top level evaluation loop of the interpreter contains hooks so the user can
     control how printing of the results of evaluation is done.  If the result is 
     ", TO "null", " then nothing is printed.  Otherwise, the appropriate method
     associated with the symbol ", TO "Print", " is applied to perform the printing,
     unless the printing is to be suppressed, as indicated by a semicolon at the end
     of the statement, in which case the ", TO "NoPrint", " method is applied.",
     UL {
	  TO "AfterEval",
	  TO "AfterPrint",
	  TO "AfterNoPrint",
	  TO "NoPrint",
	  TO "Print",
	  }
     }

document {
     Key => "executing other programs",
     "The ", TO "run", " command can be used to execute another program,
     after which control will return to Macaulay 2.",
     PARA,
     "To pass the contents of a string as input to a program or
     command, open an output file with ", TO "openOut", " whose name is
     the character '!' followed by the command, write the data to the 
     resulting file, and then close the file.  The output is displayed 
     on the screen.",
     PARA,
     "If you want to collect the output from a command in a string, use 
     ", TO "get", " with a file name consisting of the character '!' 
     followed by the command."
     }

document {
	Key => "handling hypertext",
     "Output formatting routines:",
     UL {
	  TOH "html",
	  TOH "mathML",
	  TOH "tex",
	  TOH "info",
	  TOH "net"
	  },
	}



-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/m2 "
-- End:
