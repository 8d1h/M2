-- startup.m2

-- this file gets incorporated into the executable file bin/Macaulay2 as the string 'startupString'

--		Copyright 1993-2003 by Daniel R. Grayson

firstTime := not Array.?name

-- here we put local variables that might be used by the global definitions below
match := X -> 0 < #(matches X);
oldstring := string; string := if class oldstring === Function then oldstring else toString
--

if firstTime then (
     -- all global definitions go here, because after loaddata is run, we'll come through here again
     -- with all these already done and global variables set to read-only
     Array.name = "Array";
     BasicList.name = "BasicList";
     BigReal.name = "BigReal";
     Boolean.name = "Boolean";
     CacheTable.name = "CacheTable";
     Database.name = "Database";
     File.name = "File";
     Function.name = "Function";
     HashTable.name = "HashTable";
     List.name = "List";
     MutableHashTable.name = "MutableHashTable";
     MutableList.name = "MutableList";
     Net.name = "Net";
     Nothing.name = "Nothing";
     Option.name = "Option";
     QQ.name = "QQ";
     RR.name = "RR";
     Ring.name = "Ring";
     Sequence.name = "Sequence";
     String.name = "String";
     Symbol.name = "Symbol";
     SymbolTable.name = "SymbolTable";
     Thing.name = "Thing";
     Time.name = "Time";
     Type.name = "Type";
     VisibleList.name = "VisibleList";
     ZZ.name = "ZZ";
     erase symbol Error;

     normalPrompts = () -> (
	  ZZ.InputPrompt = lineno -> simpleFlush ( << newline << "i" << lineno << " : " );
	  ZZ.InputContinuationPrompt = lineno -> (
	       scan(4 + #(string lineno), c -> << " ");
	       simpleFlush stdio;
	       );
	  ZZ.OutputPrompt = lineno -> simpleFlush ( << "o" << lineno << " : " << newline );
	  currentPrompts = normalPrompts;
	  );
     examplePrompts = () -> (
	  normalPrompts();
	  ZZ.InputPrompt = lineno -> simpleFlush ( << "\1i" << lineno << " : " );
	  currentPrompts = examplePrompts;
	  );
     noPrompts = () -> (
	  ZZ.InputPrompt = ZZ.InputContinuationPrompt = ZZ.OutputPrompt = lineno -> null;
	  currentPrompts = noPrompts;
	  );

     startFunctions := {};
     addStartFunction = f -> ( startFunctions = append(startFunctions,f); f);
     runStartFunctions = () -> scan(startFunctions, f -> f());

     endFunctions := {};
     addEndFunction = f -> ( endFunctions = append(endFunctions,f); f);
     runEndFunctions = () -> scan(endFunctions, f -> f());
     exit = ret -> ( runEndFunctions(); simpleExit ret );
     erase symbol simpleExit;

     File << Thing  := File => (x,y) -> printString(x,string y);
     File << Net := File << Symbol := File << String := printString;
     << Thing := x -> stdio << x;
     String | String := String => concatenate;

     if String #? (String => concatenate) then error "internal error: 1";

     Function _ Thing := Function => (f,x) -> y -> f splice (x,y);
     String | String := String => concatenate;
     String | ZZ := String => (s,i) -> concatenate(s,string i);
     ZZ | String := String => (i,s) -> concatenate(string i,s);

     Thing.NoPrint = x -> null;
     Thing.Print = x -> simpleFlush (
	  << newline << "o" << lineNumber() << " = ";
	  try << x;
	  << newline);

     first = x -> x#0;
     last = x -> x#-1;
     isAbsoluteExecPath = filename -> match("/", filename);
     isAbsolutePath = filename -> (
	  match(
	       (
		    if version#"operating system" === "Windows-95-98-NT" then "^(.:|/)"
		    else "^/"
		    ),
	       filename));
     sourceHomeDirectory = null; -- home directory of Macaulay 2
     buildHomeDirectory  = null; -- parent of the directory of the executable described in command line argument 0
     )

loadFile := if class load === Function then load else simpleLoad
matchpart := (regex,i,s) -> substring_((matches(regex, s))#i) s
notdir := s -> matchpart("[^/]*$",0,s)
dir := s -> (
     m := matches(".*/",s);
     if 0 == #m then "./" else substring_(m#0) s)
preload := true
noloaddata := false
nobanner := false;
nosetup := false
interpreter := topLevel

getRealPath := fn -> (
     -- look at realpath(3), which does even more
     -- how standard is it?
     while (s := readlink fn) =!= null do fn = if isAbsolutePath s then s else minimizeFilename(fn|"/../"|s);
     fn)

exe := (
     processExe := "/proc/" | string processID() | "/exe";  -- this is a reliable way to get the executable in linux
     if fileExists processExe then getRealPath processExe
     else (
	  e := commandLine#0;
	  if not isAbsoluteExecPath e then (
	       -- the only other choice is to search the path, but we don't do it the same way execvp does, too bad.
	       PATH := separate(":",if "" =!= getenv "PATH" then getenv "PATH" else ".:/bin:/usr/bin");
	       PATH = apply(PATH, x -> if x === "" then "." else x);
	       scan(PATH, p -> if fileExists (p|"/"|e) then (e = p|"/"|e; break));
	       )
	  )
     )
 

     -- search the PATH for our executable file and use getRealPath to locate our source files and use srcdir to locate more source files

buildHomeDirectory = minimizeFilename(dir exe|"../");

if fileExists (buildHomeDirectory|"m2/setup.m2"       ) then sourceHomeDirectory = buildHomeDirectory else
if fileExists (buildHomeDirectory|"srcdir/m2/setup.m2") then sourceHomeDirectory = getRealPath(buildHomeDirectory|"srcdir")|"/"

silence := arg -> null
notyeterr := arg -> error("command line option ", arg, " not re-implemented yet")
notyet := arg -> if preload then (
     << "warning: command line option " << arg << " not re-implemented yet" << newline; simpleFlush stdio;
     )
obsolete := arg -> error ("warning: command line option ", arg, " is obsolete")
progname := notdir commandLine#0
usage := arg -> (
     << "usage:"             << newline
     << "    " << progname << " [option ...] [file ...]" << newline
     << "options:"  << newline
     << "    --help             print brief help message and exit" << newline
     << "    --example-prompts  examples prompt mode" << newline
     << "    --no-loaddata      don't try to load the dumpdata file" << newline
     << "    --no-prompts       print no input prompts" << newline;
     << "    --no-setup         don't try to load setup.m2" << newline
     << "    --silent           no startup banner" << newline
     << "    --stop             exit on error" << newline
     << "    --texmacs          TeXmacs session mode" << newline
     << "    --version          print version number and exit" << newline
     << "    -q                 don't load user's init.m2 file" << newline
     << "    -e...              evaluate expression '...'" << newline
     << "    -E...              evaluate expression '...' before initialization" << newline
     << "environment:"       << newline
     << "    M2ARCH             a hint to find the dumpdata file as" << newline
     << "                       bin/../libexec/Macaulay2-$M2ARCH-data, where bin is the" << newline
     << "                       directory containing the Macaulay2 executable" << newline
     ;exit 0)

action := hashTable {
     "--help" => usage,
     "-h" => usage,
     "--" => obsolete,
     "-mpwprompt" => notyeterr,
     "-q" => silence,					    -- implemented in setup.m2
     "--silent" => arg -> nobanner = true,
     "-silent" => obsolete,
     "-tty" => notyet,
     "-n" => obsolete, "--no-prompts" => arg -> noPrompts(),
     "-x" => obsolete, "--example-prompts" => arg -> examplePrompts(),
     "-s" => obsolete, "--stop" => arg -> stopIfError true,
     "--no-loaddata" => arg -> noloaddata = true,
     "--no-setup" => arg -> nosetup = true,
     "--texmacs" => arg -> (
	  interpreter = topLevelTexmacs;
	  << TeXmacsBegin << "verbatim:" << " Macaulay 2 starting up " << endl << TeXmacsEnd;
	  simpleFlush stdout;
	  ),
     "--version" => arg -> ( << version#"VERSION" << newline; exit 0; )
     };

setDefaultValues := () -> (
     normalPrompts();
     stopIfError false;
     errorDepth loadDepth();
     )

processCommandLineOptions := () -> (			    -- two passes
     argno := 1;
     while argno < #commandLine do (
	  arg := commandLine#argno;
	  if action#?arg then action#arg arg
	  else if match("^-E",arg) then value substring(2,arg)
	  else if match("^-e",arg) then (
	       if preload then break;
	       value substring(2,arg))
	  else if match("^-" ,arg) then error("unrecognized command line option: ", arg)
	  else (
	       if preload then break;
	       loadFile arg);
	  argno = argno+1;
	  );
     )

---------------------------------

if firstTime then processCommandLineOptions()
preload = false

if firstTime and not nobanner then (
     stderr
     << "Macaulay 2, version " << version#"VERSION" << newline
     << "--Copyright 1993-2003, D. R. Grayson and M. E. Stillman" << newline
     << "--Singular-Factory " << version#"factory version" << ", copyright 1993-2001, G.-M. Greuel, et al." << newline
     << "--Singular-Libfac " << version#"libfac version" << ", copyright 1996-2001, M. Messollen" << newline
     << "--NTL Library " << version#"ntl version" << ", copyright, Victor Shoup" << newline;
     simpleFlush stderr
     )

if firstTime and not noloaddata and version#"dumpdata" then (
     -- try to load dumped data
     arch := if getenv "M2ARCH" =!= "" then getenv "M2ARCH" else version#"architecture";
     datafile := minimizeFilename concatenate(buildHomeDirectory, "/cache/Macaulay2-",arch, "-data");
     if fileExists datafile then
     try (
	  stderr << "--loading cached memory data from " << datafile << newline; simpleFlush stderr;
	  loaddata datafile
	  ) else (
	  stderr << "warning: failed to load data from " << datafile << newline; simpleFlush stdio;
	  )
     )

path = {}
if sourceHomeDirectory  =!= null                then path = append(path, sourceHomeDirectory|"m2/");
if buildHomeDirectory   =!= sourceHomeDirectory then path = append(path, buildHomeDirectory |"m2/");
path = select(path, fileExists);

-- this might have to be fixed later to get the caches for the packages directory
documentationPath = apply(path, d -> minimizeFilename(d|"/cache/doc/"))
    documentationPath = select(documentationPath, fileExists)

if firstTime and not nosetup then (
     -- try to load setup.m2
     if sourceHomeDirectory === null then error "can't find file setup.m2";
     loadFile minimizeFilename(sourceHomeDirectory | "/m2/setup.m2")
     )

setDefaultValues()
runStartFunctions()
processCommandLineOptions()
interpreter()
