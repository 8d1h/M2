--		Copyright 1993-2001 by Daniel R. Grayson

-- this file should be mentioned *last* in dumpseq

recursionLimit = 300

addStartFunction(() -> path = unique apply( path, minimizeFilename))
addEndFunction(() -> scan(openFiles(), f -> if isOutputFile f then flush f))
addEndFunction(() -> path = {})

lastLN := 0
lastWI := 0
promptWidth = () -> (
     if lineNumber === lastLN then lastWI
     else (
	  lastLN = lineNumber;
	  lastWI = max \\ width \ lines ZZ.InputPrompt lineNumber))

wr := (sep,x) -> wrap(printWidth - promptWidth(), sep, net x)
Tally.Wrap = RawMatrix.Wrap = Matrix.Wrap = Ideal.Wrap = RingElement.Wrap = VisibleList.Wrap = Sequence.Wrap = x -> wr("-",x)
String.Wrap = x -> ( x = net x; if height x + depth x <= 3 then wr("",x) else x )
Net.Wrap = x -> if height x + depth x <= 3 then wr("-",x) else x

addStartFunction( 
     () -> (
	  if class value getGlobalSymbol "User" =!= Package then (
     	       dismiss "User";
	       newPackage("User", DebuggingMode => true);
	       );
	  needsPackage \ Macaulay2Core#"pre-installed packages";
	  << "with packages: " << wrap concatenate between_", " sort Macaulay2Core#"pre-installed packages" << endl;
	  )
     )

addStartFunction( () -> if sourceHomeDirectory =!= null then Macaulay2Core#"source directory" = sourceHomeDirectory|"m2/" )

addStartFunction( () -> if not noinitfile and prefixDirectory =!= null then makePackageIndex() )

unexportedSymbols = () -> hashTable apply(pairs Macaulay2Core#"private dictionary", (n,s) -> if not Macaulay2Core.Dictionary#?n then (s => class value s => value s))

scan(values Macaulay2Core#"private dictionary" - set values Macaulay2Core.Dictionary,
     s -> if mutable s and value s === s then stderr << "--warning: mutable unexported unset symbol in Macaulay2Core: " << s << endl)

-- make sure this is after all public global symbols are defined or erased
endPackage "Macaulay2Core"
-- after this point, private global symbols, such as noinitfile, are no longer visible

load "installedpackages.m2"

scan(Macaulay2Core#"pre-installed packages",	-- initialized in the file installedpackages.m2, which is made from the file installedpackages
     pkg -> loadPackage(pkg, DebuggingMode => not stopIfError))

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/m2 "
-- End:
