-- startup.m2

-- this file gets incorporated into the executable file bin/Macaulay2 as the string 'startupString2'

--		Copyright 1993-2003 by Daniel R. Grayson

errorDepth = 0						    -- without this, we may see no error messages the second time through
debuggingMode = true
stopIfError = false
gotarg := arg -> any(commandLine, s -> s == arg)
if gotarg "--stop" then stopIfError = true

firstTime := class PackageDictionary === Symbol

-- here we put local variables that might be used by the global definitions below
match := X -> null =!= regex X

if regex(".*/","/aa/bb") =!= {(0, 4)}
or regex(".*/","aabb") =!= null
then error "regex regular expression library not working"

if not firstTime then debug value PackageDictionary#"Macaulay2Core"

if firstTime then (
     -- all global definitions go here, because after loaddata is run, we'll come through here again
     -- with all these already done and global variables set to read-only
     filesLoaded = new MutableHashTable;
     loadedFiles = new MutableHashTable;
     notify = false;

     markLoaded = (filename,origfilename,notify) -> ( 
	  filename = minimizeFilename filename;
	  filesLoaded#origfilename = filename; 
	  loadedFiles##loadedFiles = filename; 
	  if notify then stderr << "--loaded " << filename << endl;
	  );

     ReverseDictionary = new MutableHashTable;		    -- values are symbols
     PrintNames = new MutableHashTable;			    -- values are strings
     Thing.AfterEval = identity;
     scan(
	  {symbol Array, symbol BasicList, symbol RRR, symbol CCC,
		symbol Boolean, symbol CacheTable, symbol Pseudocode, symbol Database,
		symbol Dictionary, symbol File, symbol Function, symbol HashTable,
		symbol FunctionClosure, symbol CompiledFunction, symbol CompiledFunctionClosure,
		symbol List, symbol MutableHashTable, symbol MutableList, symbol Net,
		symbol Nothing, symbol Option, symbol QQ, symbol RR, symbol RR, symbol CC,
		symbol Ring, symbol Sequence, symbol String, symbol Symbol, symbol Thing,
		symbol Time, symbol Type, symbol VisibleList, symbol ZZ},
	  s -> ReverseDictionary#(value s) = s		    -- get an early start for debugging
	  );

     slimPrompts = () -> (
	  lastprompt := "";
	  ZZ.InputPrompt = lineno -> concatenate(lastprompt = concatenate(interpreterDepth:"i", toString lineno, ": "));
	  ZZ.InputContinuationPrompt = lineno -> #lastprompt;
	  symbol currentPrompts <- slimPrompts;
	  );
     hush = () -> (
	  Thing.BeforePrint = identity;
	  Thing.Print = identity;
	  Thing.NoPrint = identity;
	  Thing.AfterPrint = identity;
	  Thing.AfterNoPrint = identity;
	  slimPrompts();
	  );
     hush();
     normalPrompts = () -> (
	  lastprompt := "";
	  ZZ.InputPrompt = lineno -> concatenate(newline, lastprompt = concatenate(interpreterDepth:"i", toString lineno, " : "));
	  ZZ.InputContinuationPrompt = lineno -> #lastprompt; -- will print that many blanks, see interp.d
	  symbol currentPrompts <- normalPrompts;	    -- this avoids the warning about redefining a function
	  );
     returnPrompts = () -> (
	  lastprompt := "";
	  ZZ.InputPrompt = lineno -> concatenate(newline, lastprompt = concatenate(interpreterDepth:"i", toString lineno, " : "), newline, #lastprompt);
	  ZZ.InputContinuationPrompt = lineno -> #lastprompt; -- will print that many blanks, see interp.d
	  symbol currentPrompts <- returnPrompts;	    -- this avoids the warning about redefining a function
	  );
     noPrompts = () -> (
	  ZZ.InputPrompt = lineno -> "";
	  ZZ.InputContinuationPrompt = lineno -> "";
	  symbol currentPrompts <- noPrompts;
	  );
     ctrlA := ascii 1;
     examplePrompts = () -> (
	  lastprompt := "";
	  ZZ.InputPrompt = lineno -> concatenate(ctrlA, lastprompt = concatenate(interpreterDepth:"i", toString lineno, " : "));
	  ZZ.InputContinuationPrompt = lineno -> #lastprompt;
	  symbol currentPrompts <- examplePrompts;
	  );

     startFunctions := {};
     addStartFunction = f -> ( startFunctions = append(startFunctions,f); f);
     runStartFunctions = () -> scan(startFunctions, f -> f());

     endFunctions := {};
     addEndFunction = f -> ( endFunctions = append(endFunctions,f); f);
     runEndFunctions = () -> scan(endFunctions, f -> f());

     simpleExit := exit;
     exit = ret -> ( runEndFunctions(); simpleExit ret );

     File << Thing  := File => (x,y) -> printString(x,toString y);
     File << Net := File << Symbol := File << String := printString;
     << Thing := x -> stdio << x;
     String | String := String => concatenate;
     Function _ Thing := Function => (f,x) -> y -> f splice (x,y);
     String | ZZ := String => (s,i) -> concatenate(s,toString i);
     ZZ | String := String => (i,s) -> concatenate(toString i,s);

     new HashTable from List := HashTable => (O,v) -> hashTable v;

     Manipulator = new Type of BasicList;
     Manipulator.synonym = "manipulator";
     new Manipulator from Function := Manipulator => (Manipulator,f) -> new Manipulator from {f};
     Manipulator Database := Manipulator File := Manipulator NetFile := (m,o) -> m#0 o;

     Manipulator Nothing := (m,null) -> null;
     File << Manipulator := File => (o,m) -> m#0 o;
     NetFile << Manipulator := File => (o,m) -> m#0 o;
     List << Manipulator := File => (o,m) -> (scan(o, o -> m#0 o); o);
     Nothing << Manipulator := (null,m) -> null;

     close = new Manipulator from close;
     closeIn = new Manipulator from closeIn;
     closeOut = new Manipulator from closeOut;
     flush = new Manipulator from flush;
     endl = new Manipulator from endl;

     Thing.Print = x ->  (
	  << newline << concatenate(interpreterDepth:"o") << lineNumber << " = ";
	  try << x;
	  << newline << flush;
	  );

     first = x -> x#0;
     last = x -> x#-1;
     lines = x -> (
	  l := separate x;
	  if l#-1 === "" then drop(l,-1) else l);

     isFixedExecPath = filename -> (
	  -- this is the way execvp(3) decides whether to search the path for an executable
	  match("/", filename)
	  );
     isAbsolutePathRegexp := (
	  -- this is the way execvp decides whether to search the path for a Macaulay 2 source file
	  if version#"operating system" === "Windows-95-98-NT" then "^(.:/|/)"
	  else "^/"
	  );
     isAbsolutePath = filename -> match(isAbsolutePathRegexp, filename);
     concatPath = (a,b) -> if isAbsolutePath b then b else a|b;
     copyright = (
	  "Macaulay 2, version " | version#"VERSION" | newline
	  | "--Copyright 1993-2004, D. R. Grayson and M. E. Stillman" | newline
	  | "--Singular-Factory " | version#"factory version" | ", copyright 1993-2001, G.-M. Greuel, et al." | newline
	  | "--Singular-Libfac " | version#"libfac version" | ", copyright 1996-2001, M. Messollen" | newline
	  | "--NTL Library " | version#"ntl version" | ", copyright, Victor Shoup" | newline
     	  | "--GNU MP Library " | version#"gmp version"
	  );

     use = identity;				  -- temporary, until methods.m2
     globalAssignFunction = (X,x) -> (
	  if not ReverseDictionary#?x then ReverseDictionary#x = X;
	  use x;
	  );
     globalReleaseFunction = (X,x) -> if ReverseDictionary#?x and ReverseDictionary#x === X then remove(ReverseDictionary,x);
     globalAssignment = X -> (
	  if instance(X, VisibleList) then apply(X,globalAssignment)
	  else if instance(X,Type) then (
	       X.GlobalAssignHook = globalAssignFunction; 
	       X.GlobalReleaseHook = globalReleaseFunction;
	       )
	  else error "expected a type";
	  );
     globalAssignment {Type,Function};
     applicationDirectorySuffix = () -> (
	  if version#"operating system" === "Darwin" then "Library/Application Support/Macaulay2/" else ".Macaulay2/"
	  );
     applicationDirectory = () -> (
	  if instance(applicationDirectorySuffix, Function)
	  then homeDirectory | applicationDirectorySuffix()
	  else homeDirectory | applicationDirectorySuffix
	  );
     )

sourceHomeDirectory = null				    -- home directory of Macaulay 2
buildHomeDirectory  = null	       -- parent of the directory of the executable described in command line argument 0
prefixDirectory = null					    -- prefix directory, after installation, e.g., "/usr/local/"
packagePath = null
encapDirectory = null	   -- encap directory, after installation, if present, e.g., "/usr/local/encap/Macaulay2-0.9.5/"

fullCopyright := false
matchpart := (pat,i,s) -> substring_((regex(pat, s))#i) s
notdir := s -> matchpart("[^/]*$",0,s)
dir := s -> ( m := regex(".*/",s); if 0 == #m then "./" else substring_(m#0) s)
noloaddata := false
nobanner := false;
nosetup := false
noinitfile := false
interpreter := commandInterpreter

getRealPath := fn -> (					    -- use this later if realpath doesn't work
     local s;
     while ( s = readlink fn; s =!= null ) do fn = if isAbsolutePath s then s else minimizeFilename(fn|"/../"|s);
     fn)

pathsearch := e -> (
     if not isFixedExecPath e then (
	  -- we search the path, but we don't do it the same way execvp does, too bad.
	  PATH := separate(":",if "" =!= getenv "PATH" then getenv "PATH" else ".:/bin:/usr/bin");
	  PATH = apply(PATH, x -> if x === "" then "." else x);
	  scan(PATH, p -> if fileExists (p|"/"|e) then (e = p|"/"|e; break));
	  );
     e)

exe := (
     processExe := "/proc/" | toString processID() | "/exe";  -- this is a reliable way to get the executable in linux
     if fileExists processExe then realpath processExe
     else realpath pathsearch commandLine#0)
bindir := dir exe
bindirsuffix := LAYOUT#"bin";

setPrefixFromBindir := bindir -> if bindir =!= null then (
     if bindirsuffix === substring(bindir,-#bindirsuffix) then (
	  prefixdir := substring(bindir,0,#bindir-#bindirsuffix);
	  if fileExists(prefixdir | LAYOUT#"share") then prefixDirectory = realpath prefixdir | "/"))

if fileExists (bindir | "../c/scc1") then (
     -- we're running from the build directory
     buildHomeDirectory = minimizeFilename(bindir|"../");
     sourceHomeDirectory = (
	  if fileExists (buildHomeDirectory|"m2/setup.m2") then buildHomeDirectory 
	  else (
	       srcdirfile := buildHomeDirectory|"srcdir";
	       if fileExists srcdirfile then (
		    srcdir := minimizeFilename (concatPath(buildHomeDirectory,first lines simpleGet srcdirfile)|"/");
		    if fileExists(srcdir | "m2/setup.m2") then srcdir
		    )));
     ) else setPrefixFromBindir bindir

if prefixDirectory =!= null and fileExists (prefixDirectory | "encapinfo") then (
     -- now get the second to last entry in the chain of symbolic links, which will be in the final prefix directory
     encapDirectory = prefixDirectory;
     prev := null;
     fn := pathsearch commandLine#0;
     local s;
     while ( s = readlink fn; s =!= null ) do (prev = fn; fn = if isAbsolutePath s then s else minimizeFilename(fn|"/../"|s););
     if prev =!= null then setPrefixFromBindir dir prev)

phase := 1

silence := arg -> null
notyeterr := arg -> error("command line option ", arg, " not re-implemented yet")
notyet := arg -> if phase == 1 then (
     << "warning: command line option " << arg << " not re-implemented yet" << newline << flush;
     )
obsolete := arg -> error ("warning: command line option ", arg, " is obsolete")
progname := notdir commandLine#0

usage := arg -> (
     << "usage:"             << newline
     << "    " << progname << " [option ...] [file ...]" << newline
     << "options:"  << newline
     << "    --help             print this brief help message and exit" << newline
     << "    --no-backtrace     print no backtrace after error" << newline
     << "    --copyright        display full copyright messasge" << newline
     << "    --no-debug         do not enter debugger upon error" << newline
     << "    --dumpdata         read source code, dump data if so configured, exit (no init.m2)" << newline
     << "    --fullbacktrace    print full backtrace after error" << newline
     << "    --no-loaddata      don't try to load the dumpdata file" << newline
     << "    --int              don't handle interrupts" << newline -- handled by M2lib.c
     << "    --notify           notify when loading files during initialization" << newline
     << "                       and when evaluating command line arguments" << newline
     << "    --no-prompts       print no input prompts" << newline;
     << "    --no-readline      don't use readline" << newline;
     << "    --no-setup         don't try to load setup.m2" << newline
     << "    --no-personality   don't set the personality and re-exec M2 (linux only)" << newline
     << "    --prefix DIR       set prefixDirectory" << newline
     << "    --print-width n    set printWidth=n (the default is the window width)" << newline
     << "    --silent           no startup banner" << newline
     << "    --stop             exit on error" << newline
     << "    --texmacs          TeXmacs session mode" << newline
     << "    --version          print version number and exit" << newline
     << "    -q                 don't load user's init.m2 file or use packages in home directory" << newline
     << "    -E '...'           evaluate expression '...' before initialization" << newline
     << "    -e '...'           evaluate expression '...' after initialization" << newline
     << "    -x                 example prompts, don't use readline" << newline
     << "environment:"       << newline
     << "    M2ARCH             a hint to find the dumpdata file as" << newline
     << "                       bin/../cache/Macaulay2-$M2ARCH-data, where bin is the" << newline
     << "                       directory containing the Macaulay2 executable" << newline
     << "    EDITOR             default text editor" << newline
     << "    LOADDATA_IGNORE_CHECKSUMS	   (for debugging)" << newline
     ;exit 0)

tryLoad := (ofn,fn) -> if fileExists fn then (
     r := simpleLoad fn;
     markLoaded(fn,ofn,notify);
     true) else false

loadSetup := () -> (
     sourceHomeDirectory =!= null and tryLoad("setup.m2", minimizeFilename(sourceHomeDirectory | "/m2/setup.m2"))
     or
     prefixDirectory =!= null and tryLoad("setup.m2", minimizeFilename(prefixDirectory | LAYOUT#"m2" | "setup.m2"))
     or
     error splice ("can't find file setup.m2\n",
	  "\trunning M2: ",exe,"\n",
	  "\tbindir = ", toString bindir, "\n",
     	  "\tbuildHomeDirectory = ", toString buildHomeDirectory, "\n",
	  "\tsourceHomeDirectory = ", toString sourceHomeDirectory, "\n",
	  "\tprefixDirectory = ", toString prefixDirectory, "\n",
	  if buildHomeDirectory =!= null and fileExists(buildHomeDirectory|"srcdir")
	  then ("\t",buildHomeDirectory|"srcdir", " contains ",first lines get (buildHomeDirectory|"srcdir"),"\n",
	       (
		    fn := buildHomeDirectory|(first lines get (buildHomeDirectory|"srcdir")) | "/m2/setup.m2";
		    "\tfileExists(",fn,") = ",toString fileExists fn,"\n"
		    )
	       )
	  else "",
	  "\tcommandLine#0 = ",commandLine#0
	  )
     )

showMaps := () -> (
     if version#"operating system" === "SunOS" then (
	  stack lines get ("!/usr/bin/pmap "|processID())
	  )
     else if version#"operating system" === "Linux" and fileExists("/proc/"|toString processID()|"/maps") then (
	  stack lines get("/proc/"|toString processID()|"/maps")
	  )
     else "memory maps not available"
     )

dump := () -> (
     if not version#"dumpdata" then error "not configured for dumping data with this version of Macaulay 2";
     arch := if getenv "M2ARCH" =!= "" then getenv "M2ARCH" else version#"architecture";
     fn := (
	  if buildHomeDirectory =!= null then concatenate(buildHomeDirectory , "cache/", "Macaulay2-", arch, "-data") else 
	  if prefixDirectory =!= null then concatenate(prefixDirectory, LAYOUT#"cache", "Macaulay2-", arch, "-data")	  
	  );
     if fn === null then error "can't find cache directory for dumpdata file";
     fntmp := fn | ".tmp";
     fnmaps := fn | ".maps";
     fnmaps << showMaps() << endl << close;
     runEndFunctions();
     collectGarbage();
     interpreterDepth = 0;
     stderr << "--dumping to " << fntmp << endl;
     dumpdata fntmp;
     stderr << "--success" << endl;
     moveFile(fntmp,fn,Verbose=>true);
     exit 0;
     )

argno := 1

action := hashTable {
     "-h" => usage,
     "-mpwprompt" => notyeterr,
     "-n" => obsolete,
     "-q" => arg -> noinitfile = true,
     "-s" => obsolete,
     "-silent" => obsolete,
     "-tty" => notyet,
     "-x" => arg -> examplePrompts(),
     "--" => obsolete,
     "--copyright" => arg -> if phase == 1 then fullCopyright = true,
     "--dumpdata" => arg -> (noinitfile = noloaddata = true; if phase == 3 then dump()),
     "--help" => usage,
     "--int" => arg -> arg,
     "--no-backtrace" => arg -> if phase == 1 then backtrace = false,
     "--no-debug" => arg -> debuggingMode = false,
     "--no-loaddata" => arg -> if phase == 1 then noloaddata = true,
     "--no-personality" => arg -> arg,
     "--no-prompts" => arg -> if phase == 1 then noPrompts(),
     "--no-readline" => arg -> arg,			    -- handled in d/stdio.d
     "--no-setup" => arg -> if phase == 1 then nosetup = true,
     "--notify" => arg -> if phase <= 2 then notify = true,
     "--silent" => arg -> nobanner = true,
     "--stop" => arg -> (if phase == 1 then stopIfError = true; debuggingMode = false;), -- see also M2lib.c and tokens.d
     "--texmacs" => arg -> if phase == 3 then (
	  interpreter = topLevelTexmacs;
	  << TeXmacsBegin << "verbatim:" << " Macaulay 2 starting up " << endl << TeXmacsEnd << flush;
	  ),
     "--version" => arg -> ( << version#"VERSION" << newline; exit 0; )
     };

valueNotify := arg -> (
     if notify then stderr << "--evaluating command line argument " << argno << ": " << format arg << endl;
     value arg)

action2 := hashTable {
     "-E" => arg -> if phase == 2 then valueNotify arg,
     "-e" => arg -> if phase == 3 then valueNotify arg,
     "--print-width" => arg -> if phase == 2 then printWidth = value arg,
     "--prefix" => arg -> if phase == 1 then (
	  if not match("/$",arg) then arg = arg | "/";
	  prefixDirectory = arg;
	  )
     }

processCommandLineOptions := phase0 -> (			    -- 3 passes
     ld := loadDepth;
     loadDepth = loadDepth + 1;
     phase = phase0;
     argno = 1;
     while argno < #commandLine do (
	  arg := commandLine#argno;
	  if action#?arg then action#arg arg
	  else if action2#?arg then (
	       if argno < #commandLine + 1
	       then action2#arg commandLine#(argno = argno + 1)
	       else error("command line option ", arg, " missing argument")
	       )
	  else if match("^-e",arg) and phase == 2 then value substring(2,arg) -- to become obsolete
	  else if arg#0 == "-" then (
	       stderr << "error: unrecognized command line option: " << arg << endl;
	       usage();
	       exit 1;
	       )
	  else if phase == 3 then if instance(load, Function) then load arg else simpleLoad arg;
	  argno = argno+1;
	  );
     loadDepth = ld;
     )

if firstTime then processCommandLineOptions 1

if firstTime and not nobanner then stderr << (if fullCopyright then copyright else first separate copyright) << newline << flush

if firstTime and not noloaddata and version#"dumpdata" then (
     -- try to load dumped data
     arch := if getenv "M2ARCH" =!= "" then getenv "M2ARCH" else version#"architecture";
     datafile := minimizeFilename (
	  if buildHomeDirectory =!= null then concatenate(buildHomeDirectory, "/cache/Macaulay2-", arch, "-data")
	  else if prefixDirectory =!= null then concatenate(prefixDirectory, LAYOUT#"cache", "Macaulay2-", arch, "-data")
	  else concatenate("Macaulay2-", arch, "-data")
	  );
     if fileExists datafile then (
	  if notify then stderr << "--loading cached memory data from " << datafile << newline << flush;
     	  try loaddata datafile;
	  -- stderr << "--warning: can not load data from " << datafile << newline << flush;
	  )
     )

path = {}
scan(commandLine, arg -> if arg === "-q" or arg === "--dumpdata" then noinitfile = true)

homeDirectory = getenv "HOME" | "/"

if not noinitfile then (
     path = join(
	  {applicationDirectory() | "local/" | LAYOUT#"datam2", applicationDirectory() | "code/"},
	  path);
     )

packagePath = { }

if prefixDirectory =!= null then packagePath = prepend(prefixDirectory | LAYOUT#"packages", packagePath)

if not noinitfile then (
     packagePath = prepend(applicationDirectory() | "local/" | LAYOUT#"packages", packagePath);
     )
if sourceHomeDirectory  =!= null
then {
     path = join(path, {sourceHomeDirectory|"m2/",sourceHomeDirectory|"packages/"});
     packagePath = join(packagePath, {sourceHomeDirectory|"packages/"});
     }
if buildHomeDirectory   =!= null then (
     path = join(path, {buildHomeDirectory|"tutorial/final/"});
     if buildHomeDirectory =!= sourceHomeDirectory then path = join(path, {buildHomeDirectory|"m2/"})
     )
if prefixDirectory      =!= null then (
     path = join(path, {prefixDirectory | LAYOUT#"m2", prefixDirectory | LAYOUT#"datam2"});
     )
if sourceHomeDirectory  =!= null then path = join(path, {sourceHomeDirectory|"test/", sourceHomeDirectory|"test/engine/"})
-- path = select(path, fileExists)
if firstTime then normalPrompts()

if firstTime and not nosetup then (
     loadSetup();
     )

if not firstTime then globalDictionaries = delete(Macaulay2Core#"private dictionary", globalDictionaries)

printWidth = width stdio
processCommandLineOptions 2
runStartFunctions()
errorDepth = loadDepth
if not noinitfile then (
     -- the location of init.m2 is documented in the node "initialization file"
     tryLoad ("init.m2", applicationDirectory() | "init.m2");
     tryLoad ("init.m2", "init.m2");
     );
errorDepth = loadDepth+1				    -- anticipate loadDepth being 2 later
processCommandLineOptions 3
interpreterDepth = 0
n := interpreter()					    -- loadDepth is incremented by commandInterpreter
if class n === ZZ and 0 <= n and n < 128 then exit n
if n === null then exit 0
debuggingMode = false
stopIfError = true
stderr << "error: can't interpret return value as an exit code" << endl
exit 1

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/d && make -C $M2BUILDDIR/Macaulay2/m2 "
-- End:
