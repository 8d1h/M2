--		Copyright 1993-1999 by Daniel R. Grayson

-- flag symbol sequence

<< Thing := x -> stdio << x
File << Net    := 
File << String := 
File << Symbol := File => printString	   		      -- provisional
File << Thing  := File => (x,y) -> printString(x,string y)     -- provisional

if class Manipulator =!= Symbol then error ///attempted to load "setup.m2" a second time///

Symbols = new MutableHashTable
Function.GlobalAssignHook = (X,x) -> (
     if not Symbols#?x then Symbols#x = X;
     )
Function.GlobalReleaseHook = (X,x) -> (
     -- error concatenate("warning: ", X, " redefined");	    -- provisional, see definition below
     if Symbols#x === X then remove(Symbols,x);
     )

Manipulator = new Type of BasicList
Manipulator.synonym = "manipulator"
new Manipulator from Function := Manipulator => (Manipulator,f) -> new Manipulator from {f}
Manipulator.name = "Manipulator"
Manipulator Database := Manipulator File := (m,o) -> m#0 o

Manipulator.GlobalAssignHook = (X,x) -> if not Symbols#?x then Symbols#x = X
Manipulator.GlobalReleaseHook = (X,x) -> if Symbols#x === X then remove(Symbols,x)

Manipulator Nothing := (m,null) -> null
File << Manipulator := File => (o,m) -> m#0 o
List << Manipulator := File => (o,m) -> (scan(o, o -> m#0 o); o)
Nothing << Manipulator := (null,m) -> null

oldclose := close
erase symbol close
close = new Manipulator from oldclose

oldcloseIn := closeIn
erase symbol closeIn
closeIn = new Manipulator from oldcloseIn

oldcloseOut := closeOut
erase symbol closeOut
closeOut = new Manipulator from oldcloseOut

oldflush := flush
erase symbol flush
flush = new Manipulator from oldflush

oldendl := endl
erase symbol endl
endl = new Manipulator from oldendl

notify := false						    -- can change this for debugging
if notify then stderr << "--loading setup.m2" << endl

if class path =!= List then path = { }
savepath := path
path = join({ currentFileDirectory }, path)

pathSeparator = "/"

isAbsolutePath := (
     if version#"operating system" === "Windows-95-98-NT"
     then filename -> substring(filename,1,1) === ":"
     else filename -> pathSeparator === substring(filename,0,#pathSeparator)
     )

if class phase === Symbol then phase = 0

erase symbol "--newline--"

protect AfterEval
protect AfterPrint
protect BeforePrint

rot := x -> (
     symbol oooo <- ooo;			  -- avoid GlobalAssignHook with <-
     symbol ooo <- oo;
     symbol oo <- x;
     )

applyMethod := (m,x) -> if x === null then x else (
     method := lookup(m,class x);
     if method === null then x else method x
     )

outputSymbols = new MutableHashTable

outputLabel := ""

commonProcessing := x -> (
     outputLabel = concatenate("o",string lineNumber());
     x = applyMethod(AfterEval,x);
     if x =!= null then (
     	  s := getGlobalSymbol outputLabel;
     	  outputSymbols#s = true;
     	  s <- x;
	  );
     rot x;
     x
     )

Thing.Print = x -> (
     x = commonProcessing x;
     y := applyMethod(BeforePrint,x);
     if y =!= null then (
	  << endl;			  -- double space
	  << outputLabel << " = " << net y << endl;
	  );
     applyMethod(AfterPrint,x);
     )

Thing.NoPrint = x -> (
     x = commonProcessing x;
     applyMethod(AfterNoPrint,x);
     )

String | String := String => concatenate
String | ZZ := String => (s,i) -> concatenate(s,string i)
ZZ | String := String => (i,s) -> concatenate(string i,s)

loaded := new MutableHashTable
unmarkAllLoadedFiles = () -> loaded = new MutableHashTable  -- symbol will be erased in debugging.m2

markLoaded := (filename,origfilename) -> ( 
     loaded#origfilename = true; 
     if notify then (
	  filename = minimizeFilename filename;
	  -- stderr << "--loaded " << filename << endl	    -- debugging
	  );
     )

isSpecial := filename -> filename#0 === "$" or filename#0 === "!"

unique := x -> (
     seen := new MutableHashTable;
     select(x, i -> if seen#?i then false else seen#i = true))

tryload := (filename,load) -> (
     if notify then << "--loading " << filename << endl;
     if isAbsolutePath filename or isSpecial filename then (
	  -- stderr << "trying to load " << filename << endl;		    -- debugging
	  if load filename then (
	       markLoaded(filename,filename);
	       true)
	  else false)
     else (
          if class path =!= List then error "expected 'path' to be a list (of strings)";
          {} =!= select(1,
	       unique apply(prepend(currentFileDirectory, path), minimizeFilename),
	       dir -> (
		    if class dir =!= String 
		    then error "member of 'path' not a string";
		    fullfilename := dir | filename;
		    -- stderr << "trying to load " << fullfilename << endl;		    -- debugging
		    result := load fullfilename;
		    if result then markLoaded(fullfilename,filename);
		    result))))

oldLoad := load
erase symbol load
load = (filename) -> (
     if not tryload(filename,oldLoad) then error ("can't open file ", filename)
     )

oldinput := input
erase symbol input
input = (filename) -> (
     oldnotify := notify;
     notify = false;
     if not tryload(filename,oldinput) then error ("can't open file ", filename);
     notify = oldnotify;
     )

needs = s -> if not loaded#?s then load s

writableGlobals = new MutableHashTable
scan((
	  symbol oooo,
	  symbol ooo,
	  symbol oo,
	  symbol path,
	  symbol phase,
	  symbol currentDirectory,
	  symbol htmlDirectory,
	  symbol buildPackage,
	  symbol buildDirectory,
	  symbol documentationPath,			    -- being removed...
	  symbol DocDatabase,
	  symbol currentFileName,
	  symbol compactMatrixForm,
	  symbol TeXmacsMode
	  ), x -> writableGlobals#x = true)

startFunctions := {}

addStartFunction = g -> (
     startFunctions = append(startFunctions,g);
     g)
runStartFunctions = () -> scan(startFunctions, f -> f())
OLDENGINE = getenv("OLDENGINE") == "TRUE"
lastSystemSymbol = null

addStartFunction( () -> (
	  scanPairs(symbolTable(), (name,sym) -> if not writableGlobals#?sym then protect sym)
	  ))

load "loads.m2"

path = savepath
notify = true
lastSystemSymbol = local privateSymbol
if OLDENGINE then (
     erase symbol ZZZ;
     erase symbol NewMonomialOrder;
     erase symbol Component;
     erase symbol GroupLex;
     erase symbol GroupRevLex;
     erase symbol MonomialOrdering;
     erase symbol NCLex;
     erase symbol newDegreesMonoid;
     erase symbol newDegreesRing;
     erase symbol newEngine;
     erase symbol monomialOrdering;
     remove(ZZ,newDegreesRing);
     remove(Sequence,newDegreesRing);
     remove(ZZ,newDegreesMonoid);
     remove(Sequence,newDegreesMonoid);
     erase symbol clone;
     remove(Sequence,clone);
     )
erase symbol OLDENGINE
erase symbol outputSymbols
erase symbol lastSystemSymbol

Function.GlobalReleaseHook = (X,x) -> (
     stderr << "warning: " << toString X << " redefined" << endl;
     if Symbols#x === X then remove(Symbols,x);
     )

-- the last functions restarted
addStartFunction(
     () -> (
	  if not member("-q",commandLine)
	  then (
	       tryload("init.m2",oldLoad)
	       or
	       getenv "HOME" =!= "" and tryload(concatenate(getenv "HOME", "/init.m2"),oldLoad)
	       or
	       getenv "HOME" =!= "" and tryload(concatenate(getenv "HOME", "/.init.m2"),oldLoad)
	       )
	  )
     )

addStartFunction(
     () -> (
	  TeXmacsMode = member("--texmacs",commandLine);
	  if TeXmacsMode then (
	       << TeXmacsBegin << "verbatim:" << " Macaulay 2 starting up " << endl << TeXmacsEnd << flush;
	       );
	  )
     )
