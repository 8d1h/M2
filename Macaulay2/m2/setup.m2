--		Copyright 1993-2003 by Daniel R. Grayson

if Function.?GlobalAssignHook then error "setup.m2, already loaded"
Function.GlobalAssignHook = (X,x) -> (
     if not Symbols#?x then Symbols#x = X;
     )
Function.GlobalReleaseHook = (X,x) -> (
     -- error concatenate("warning: ", X, " redefined");	    -- provisional, see definition below
     if Symbols#?x and Symbols#x === X then remove(Symbols,x);
     )
addStartFunction(
     () -> (
	  Function.GlobalReleaseHook = (X,x) -> (
	       if not writableGlobals#?X then stderr << "warning: " << toString X << " redefined" << endl;
	       if Symbols#x === X then remove(Symbols,x);
	       );
	  )
     )

---------------------------------

if notify then stderr << "--loading setup.m2" << endl

match := X -> 0 < #(matches X)				    -- defined as a method later

if class phase === Symbol then phase = 0

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

outputLabel := ""

OutputDictionary = newDictionary()

commonProcessing := x -> (
     outputLabel = concatenate(interpreterDepth():"o",toString lineNumber());
     x = applyMethod(AfterEval,x);
     if x =!= null then (
     	  s := getGlobalSymbol(OutputDictionary,outputLabel);
     	  s <- x;
	  );
     rot x;
     x
     )

simpleToString := toString

Thing.Print = x -> (
     x = commonProcessing x;
     y := applyMethod(BeforePrint,x);
     if y =!= null then (
	  << endl;			  -- double space
	  << outputLabel << " = " << (try net y else try toString y else try simpleToString y else "--something--") << endl;
	  );
     applyMethod(AfterPrint,x);
     )

Thing.NoPrint = x -> (
     x = commonProcessing x;
     applyMethod(AfterNoPrint,x);
     )

loaded := new MutableHashTable
unmarkAllLoadedFiles = () -> loaded = new MutableHashTable  -- symbol will be erased in debugging.m2

markLoaded := (filename,origfilename) -> ( 
     loaded#origfilename = true; 
     if notify then (
	  filename = minimizeFilename filename;
	  stderr << "--loaded " << filename << endl
	  );
     )

isSpecial := filename -> filename#0 === "$" or filename#0 === "!"

tryload := (filename,loadfun) -> (
     if isAbsolutePath filename or isSpecial filename then (
	  if not fileExists filename then return false;
	  loadfun filename;
	  markLoaded(filename,filename);
	  true)
     else (
          if class path =!= List then error "expected 'path' to be a list (of strings)";
          {} =!= select(1,
	       if currentFileDirectory == "--startupString--/" then path
	       else prepend(currentFileDirectory, path),
	       dir -> (
		    if class dir =!= String then error "member of 'path' not a string";
		    fullfilename := dir | filename;
		    if not fileExists fullfilename then return false;
		    loadfun fullfilename;
		    markLoaded(fullfilename,filename);
		    true))))

simpleLoad := load
load = (filename) -> (
     if not tryload(filename,simpleLoad) then error ("can't open file ", filename)
     )

simpleInput := input
input = (filename) -> (
     savenotify := notify;
     notify = false;
     if not tryload(filename,simpleInput) then error ("can't open file ", filename);
     notify = savenotify;
     )

setnotify := () -> (
     -- notify = true			-- notify after initialization, commented out
     )
-- erase symbol notify    -- we have to erase this while we have a chance

needs = s -> if not loaded#?s then load s

new HashTable from List := HashTable => (O,v) -> hashTable v

load "loads.m2"
-- don't define any global variables below this point
setnotify()
addStartFunction(
     () -> (
	  errorDepth = loadDepth = loadDepth + 1;
	  if not member("-q",commandLine)
	  then (
	       tryload("init.m2", simpleLoad)
	       or
	       getenv "HOME" =!= "" and (
		    tryload(getenv "HOME" | "/init.m2", simpleLoad)
		    or
		    tryload(getenv "HOME" | "/.init.m2", simpleLoad)))))
newPackage Output
protect symbol Output
newPackage User
protect Macaulay2.Dictionary
