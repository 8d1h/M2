--		Copyright 1994-2002 by Daniel R. Grayson

debugDoc = () -> commandInterpreter local symbol

maximumCodeWidth := 120

DocDatabase = null

local exampleBaseFilename
local exampleOutputFilename
local currentNodeName

docFilename := () -> null

addStartFunction( 
     () -> (
	  fn := docFilename();
	  if fn =!= null then DocDatabase = try openDatabase fn else (
	       stderr << "warning: couldn't open help file " << docFilename() << endl;
	       new HashTable)))

-- Documentation = new MutableHashTable

duplicateDocWarning := () -> (
     error ("warning: documentation already provided for '", currentNodeName, "'");
     -- stderr << concatenate ("warning: documentation already provided for '", currentNodeName, "'") << newline << flush;
     )

-----------------------------------------------------------------------------
-- unformatting document tags
-----------------------------------------------------------------------------
-- we need to be able to do this only for the document tags we have shown to the user in formatted form 
unformatTag := new MutableHashTable
record      := f -> x -> (
     val := f x; 
     if val =!= x then unformatTag#val = x; 
     val)
-----------------------------------------------------------------------------
-- getting database records
-----------------------------------------------------------------------------
getRecord := key -> scan(packages,
     pkg -> (
	  d := pkg#"documentation";
	  if d#?key then break d#key))
-----------------------------------------------------------------------------
-- normalizing document tags
-----------------------------------------------------------------------------
   -- The normalized form for simple objects will be the symbol whose value is the object
   -- (We don't document objects that are not stored in global variables.)
   -- This allows us to write documentation links like
   --                TO "sin" 
   -- or
   --	             TO sin
   -- or
   --	             TO symbol sin
   -- and have them all get recorded the same way
normalizeDocumentTag           = method(SingleArgumentDispatch => true)
normalizeDocumentTag   String := s -> if isGlobalSymbol s then getGlobalSymbol s else s
normalizeDocumentTag   Symbol := identity
normalizeDocumentTag Sequence := identity
normalizeDocumentTag   Option := identity
normalizeDocumentTag  Nothing := x -> symbol null
normalizeDocumentTag    Thing := x -> (
     t := reverseDictionary x;
     if t === null then error "encountered unidentifiable document tag";
     t)

isDocumentableThing = x -> null =!= package x		    -- maybe not quite right

isDocumentableTag          = method(SingleArgumentDispatch => true)
isDocumentableTag   Symbol := s -> null =!= package s
isDocumentableTag   String := s -> true
isDocumentableTag Sequence := s -> all(s, isDocumentableThing)
isDocumentableTag   Option := s -> all(toList s, isDocumentableThing)
isDocumentableTag    Thing := s -> false

packageTag          = method(SingleArgumentDispatch => true)
packageTag   Symbol := s -> if class value s === Package and toString value s === toString s then value s else package s
packageTag   String := s -> currentPackage
packageTag  Package := identity
packageTag Sequence := s -> youngest \\ package \ s
packageTag   Option := s -> package youngest toSequence s
packageTag    Thing := s -> error "can't determine package for documentation tag of unknown type"

-----------------------------------------------------------------------------
-- formatting document tags
-----------------------------------------------------------------------------
   -- The formatted form should be a human-readable string, and different normalized tags should yield different formatted tags.
Strings := hashTable { Sequence => "(...)", List => "{...}", Array => "[...]" }
toStr := s -> if Strings#?s then Strings#s else toString s
formatDocumentTag           = method(SingleArgumentDispatch => true)
	  
alphabet := set characters "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'"

formatDocumentTag Thing    := toString
formatDocumentTag String   := s -> s

after := (w,s) -> mingle(w,#w:s)
formatDocumentTag Option   := record(
     s -> concatenate (
	  if class s#0 === Sequence 
	  then (
	       if class s#0#0 === Symbol
	       then ( "(", formatDocumentTag s#0, ", ", toString s#1, " => ...)" )
	       else ( toString s#0#0, "(", after(toString \ drop(s#0,1), ", "), " ", toString s#1, " => ...)" )
	       )
	  else ( toString s#0, "(..., ", toString s#1, " => ...)" )
	  )
     )

fSeqInitialize := (toString,toStr) -> new HashTable from {
     (4,NewOfFromMethod) => s -> ("new ", toString s#1, " of ", toString s#2, " from ", toStr s#3),
     (4,cohomology,ZZ  ) => s -> ("HH_", toStr s#1, "^", toStr s#2, " ", toStr s#3),
     (4,homology,ZZ    ) => s -> ("HH^", toStr s#1, "_", toStr s#2, " ", toStr s#3),
     (3,NewFromMethod  ) => s -> ("new ", toString s#1, " from ", toStr s#2),
     (3,NewOfMethod    ) => s -> ("new ", toString s#1, " of ", toString s#2),
     (3,symbol " "     ) => s -> (toStr s#1, " ", toStr s#2),
     (3,homology,ZZ    ) => s -> ("HH_", toStr s#1, " ", toStr s#2),
     (3,cohomology,ZZ  ) => s -> ("HH^", toStr s#1, " ", toStr s#2),
     (2,homology       ) => s -> ("HH ", toStr s#1),
     (2,cohomology     ) => s -> ("HH ", toStr s#1),
     (2,NewMethod      ) => s -> ("new ", toString s#1),
     (2,symbol ~       ) => s -> (toStr s#1, " ", toStr s#0), -- postfix operator
     (2,symbol !       ) => s -> (toStr s#1, " ", toStr s#0), -- postfix operator
     (3,class,Symbol   ) => s -> (toStr s#1, " ", toString s#0, " ", toStr s#2),-- infix operator
     (2,class,Symbol   ) => s -> (toString s#0, " ", toStr s#1),-- prefix operator
     (2,class,ScriptedFunctor,ZZ) => s -> (
	  hh := s#0;
	  if hh.?subscript and hh.?superscript then toString s
	  else if hh.?subscript   then (toString s#0, " _ ", toStr s#1)
	  else if hh.?superscript then (toString s#0, " ^ ", toStr s#1)
	  else (toString s#0, " ", toStr s#1)),
     (3,class,ScriptedFunctor,ZZ) => s -> (
	  if s#0 .? subscript
	  then (toString s#0, "_", toStr s#1, "(", toStr s#2, ")")
	  else (toString s#0, "^", toStr s#1, "(", toStr s#2, ")")),
     (4,class,ScriptedFunctor,ZZ) => s -> (
	  if s#0 .? subscript
	  then (toString s#0, "_", toStr s#1, "(", toStr s#2, ",", toStr s#3, ")")
	  else (toString s#0, "^", toStr s#1, "(", toStr s#2, ",", toStr s#3, ")")),
     4 => s -> (toString s#0, "(", toStr s#1, ",", toStr s#2, ",", toStr s#3, ")"),
     3 => s -> (toString s#0, "(", toStr s#1, ",", toStr s#2, ")"),
     2 => s -> (toString s#0, " ", toStr s#1)
     }

fSeq := null
formatDocumentTag Sequence := record(
     s -> (
	  if fSeq === null then (
	       fSeq = fSeqInitialize(toString,toStr);
	       );
	  concatenate (
	       if #s == 0                             then toString
	       else if fSeq#?(#s,s#0)                 then fSeq#(#s,s#0)
	       else if #s >= 1 and fSeq#?(#s,s#0,s#1) then fSeq#(#s,s#0,s#1)
	       else if #s >= 1 and fSeq#?(#s, class, class s#0, s#1) 
	       					      then fSeq#(#s, class, class s#0, s#1)
	       else if fSeq#?(#s, class, class s#0)   then fSeq#(#s, class, class s#0)
	       else if fSeq#?#s                       then fSeq#(#s)
						      else toString) s))

fSeqTO := null
formatDocumentTagTO := method(SingleArgumentDispatch => true)
formatDocumentTagTO Thing := x -> TT formatDocumentTag x
formatDocumentTagTO Option := x -> (
     if #x === 2 and getRecord toString x#1 =!= null 
     then SEQ { toString x#0, "(..., ", TO x#1, " => ...)", headline x#1 }
     else TT formatDocumentTag x
     )
formatDocumentTagTO Sequence := (
     s -> SEQ (
	  if fSeqTO === null then (
	       fSeqTO = fSeqInitialize(i -> TO i, i -> TO i);
	       );
	  (
	       if #s == 0                               then toString
	       else if fSeqTO#?(#s,s#0)                 then fSeqTO#(#s,s#0)
	       else if #s >= 1 and fSeqTO#?(#s,s#0,s#1) then fSeqTO#(#s,s#0,s#1)
	       else if #s >= 1 and fSeqTO#?(#s, class, class s#0, s#1) 
	       					        then fSeqTO#(#s, class, class s#0, s#1)
	       else if fSeqTO#?(#s, class, class s#0)   then fSeqTO#(#s, class, class s#0)
	       else if fSeqTO#?#s                       then fSeqTO#(#s)
						        else toString) s))

-----------------------------------------------------------------------------
-- verifying the keys
-----------------------------------------------------------------------------
verifyTag := method(SingleArgumentDispatch => true)
verifyTag Thing    := s -> null
verifyTag Sequence := s -> (
     if class lookup s =!= Function then (
	  -- error("documentation provided for '", formatDocumentTag s, "' but no method installed");
	  stderr << "warning: documentation provided for '" << formatDocumentTag s << "' but no method installed" << endl ;
     ))
verifyTag Option   := s -> (
     fn := s#0;
     opt := s#1;
     if not (options fn)#?opt then error("expected ", toString opt, " to be an option of ", toString fn))

-----------------------------------------------------------------------------
-- installing the documentation
-----------------------------------------------------------------------------

Nothing << Thing := (x,y) -> null			    -- turning off the output is easy to do
DocumentableValueType := set { 
     Boolean, 
     HashTable, 
     Function, 
     BasicList, 
     Nothing,
     File
     }
UndocumentableValue := hashTable { symbol environment => true, symbol commandLine => true }
documentableValue := key -> (
     class key === Symbol and value key =!= key
     and not UndocumentableValue#?key and DocumentableValueType#?(basictype value key))

---- how could this have worked (so soon)?
-- scan(flatten(pairs \ globalDictionaries), (name,sym) -> if documentableValue sym then Symbols#(value sym) = sym)

fixup := method(SingleArgumentDispatch => true)
fixup Nothing    := z -> z				    -- null
fixup String     := z -> z				    -- "..."
fixup List       := z -> SEQ apply(z, fixup)		    -- {...} becomes SEQ{...}
fixup Sequence   := z -> SEQ toList apply(z, fixup)	    -- (...) becomes SEQ{...}
fixup MarkUpList := z -> apply(z,fixup)			    -- recursion
fixup Option     := z -> z#0 => fixup z#1		    -- Headline => "...", Usage => "..."
fixup TO         := z -> z				    -- TO{x}
fixup TOH        := z -> z				    -- TOH{x}
fixup MarkUpType := z -> z{}				    -- convert PARA to PARA{}
fixup Thing      := z -> error("unrecognizable item inside documentation: ", toString z)

file := null

-----------------------------------------------------------------------------
-- process examples
-----------------------------------------------------------------------------

extractExamplesLoop            := method(SingleArgumentDispatch => true)
extractExamplesLoop Thing      := x -> {}
extractExamplesLoop EXAMPLE    := toList
extractExamplesLoop MarkUpList := x -> join apply(toSequence x, extractExamplesLoop)

extractExamples := (docBody) -> (
     examples := extractExamplesLoop docBody;
     if #examples > 0 then currentPackage#"example inputs"#currentNodeName = examples;
     docBody)

M2outputRE := "(\n\n)i+[1-9][0-9]* : "
M2outputREindex := 1
separateM2output = method()
separateM2output String := r -> (
     while r#?0 and r#0 == "\n" do r = substring(1,r);
     while r#?-1 and r#-1 == "\n" do r = substring(0,#r-1,r);
     separateRegexp(M2outputRE,M2outputREindex,r))

getFileName := body -> (
     x := select(1, body, i -> class i === Option and #i === 2 and first i === FileName);
     if #x > 0 then x#0#1 else null
     )

makeFileName := (key,filename,pkg) -> (			 -- may return 'null'
     if pkg#"package prefix" =!= null 
     then pkg#"package prefix" | LAYOUT#"packageexamples" pkg.name | if filename =!= null then filename else toFilename key
     )

exampleResultsFound := false
exampleResults := {}
exampleCounter := 0
checkForExampleOutputFile := (node,pkg) -> (
     exampleCounter = 0;
     exampleResults = {};
     exampleResultsFound = false;
     exampleOutputFilename = null;
     if debugLevel > 0 then stderr << "exampleBaseFilename = " << exampleBaseFilename << endl;
     if exampleBaseFilename =!= null then (
	  exampleOutputFilename = exampleBaseFilename | ".out";
	  if debugLevel > 0 then (
	       stderr << "checking for example results in file '" << exampleOutputFilename << "' : " << (if fileExists exampleOutputFilename then "it exists" else "it doesn't exist") << endl;
	       );
	  if fileExists exampleOutputFilename then (
	       -- read, separate, and store example results
	       exampleResults = pkg#"example results"#node = drop(separateM2output get exampleOutputFilename,-1);
	       if debugLevel > 0 then stderr << "node " << node << " : " << boxNets \\ net \ exampleResults << endl;
	       exampleResultsFound = true)))
processExample := x -> (
     a :=
     if exampleResultsFound and exampleResults#?exampleCounter
     then {x, CODE exampleResults#exampleCounter}
     else (
	  if exampleResultsFound and #exampleResults === exampleCounter then (
	       stderr << "warning : example results file " << exampleOutputFilename << " terminates prematurely" << endl;
	       );
	  {x, CODE concatenate("i", toString (exampleCounter+1), " : ",x)}
	  );
     exampleCounter = exampleCounter + 1;
     a)
processExamplesLoop := s -> (
     if class s === EXAMPLE then SEQ{
	  PARA{},
	  ExampleTABLE apply(select(toList s, i -> i =!= null), processExample),
	  PARA{}}
     else if class s === Sequence or instance(s,MarkUpList)
     then apply(s,processExamplesLoop)
     else s)
processExamples := (key,docBody) -> (
     currentNodeName = formatDocumentTag key;
     pkg := packageTag key;
     if pkg === null then error ("can't determine the correct package for documentation key ", currentNodeName);
     exampleBaseFilename = makeFileName(currentNodeName,getFileName docBody,pkg);
     checkForExampleOutputFile(currentNodeName,pkg);
     processExamplesLoop docBody)

-----------------------------------------------------------------------------
-- 'document' function
-----------------------------------------------------------------------------

document = method()
document List := z -> (
     if #z === 0 then error "expected a nonempty list";
     key := normalizeDocumentTag z#0;
     pkg := packageTag key;
     if pkg =!= currentPackage then error("documentation for \"",key,"\" belongs in package ",pkg," but current package is ",currentPackage);
     verifyTag key;
     body := drop(z,1);
     if not isDocumentableTag key then error("undocumentable item encountered");
     currentNodeName = formatDocumentTag key;
     exampleBaseFilename = makeFileName(currentNodeName,getFileName body,currentPackage);
     d := currentPackage#"documentation";
     if d#?currentNodeName then duplicateDocWarning();
     d#currentNodeName = toExternalString extractExamples fixup body;
     currentNodeName = null;
     )

-----------------------------------------------------------------------------
-- getting help from the documentation
-----------------------------------------------------------------------------

topicList = () -> sort join(
     if DocDatabase === null then {} else value \ keys DocDatabase
     )

getExampleInputs := method(SingleArgumentDispatch => true)
getExampleInputs Thing        := t -> {}
getExampleInputs ExampleTABLE := t -> apply(toList t, first)
getExampleInputs MarkUpList   := t -> join apply(toSequence t, getExampleInputs)

examples = x -> getExampleInputs documentation x
printExamples = f -> scan(examples f, i -> << i << endl)

topics = Command (
     () -> (
	  wid := if width stdio == 0 then 79 else width stdio - 1;
	  << columnate( topicList(), wid) << endl;
	  )
     )

apropos = (pattern) -> sort select(flatten \\ keys \ globalDictionaries, i -> match(toString pattern,i))
-----------------------------------------------------------------------------
-- more general methods
-----------------------------------------------------------------------------
lookupQ := s -> (youngest s)#?s
nextMoreGeneral2 := (f,A) -> (
     A' := A;
     l := false;
     while not l and A' =!= Thing do (
	  A' = parent A';
	  l = lookupQ(f,A');
	  );
     if l then (f,A'))
nextMoreGeneral3 := (f,A,B) -> (
     A' := A;
     B' := B;
     l := false;
     while not l and (A',B') =!= (Thing,Thing) do (
	  if B' =!= Thing then B' = parent B' else (
	       B' = B;
	       A' = parent A');
	  l = lookupQ(f,A',B'););
     if l then (f,A',B'))
nextMoreGeneral4 := (f,A,B,C) -> (
     A' := A;
     B' := B;
     C' := C;
     l := false;
     while not l and (A',B',C') =!= (Thing,Thing,Thing) do (
	  if C' =!= Thing then C' = parent C'
	  else (
	       C' = C;
	       if B' =!= Thing then B' = parent B'
	       else (
		    B' = B;
		    A' = parent A'));
	  l = lookupQ(f,A',B',C');
	  );
     if l then (f,A',B',C'))
nextMoreGeneral := s -> (
     if class s === Sequence then (
     	  if #s === 2 then nextMoreGeneral2 s else
     	  if #s === 3 then nextMoreGeneral3 s else
     	  if #s === 4 then nextMoreGeneral4 s)
     else if class s === Option and #s === 2 then s#1
     )

-----------------------------------------------------------------------------
-- getting database records
-----------------------------------------------------------------------------

getOption := (s,tag) -> (
     if class s === SEQ then (
     	  x := select(1, toList s, i -> class i === Option and #i === 2 and first i === tag);
     	  if #x > 0 then x#0#1 else null)
     else null
     )

getDoc := key -> value getRecord formatDocumentTag key
if debugLevel > 10 then getDoc = on (getDoc, Name => "getDoc")
 
getDocBody := key -> (
     a := getDoc key;
     if a =!= null then processExamples(key, select(a, s -> class s =!= Option)))

getHeadline := key -> (
     d := getOption(getDoc key, Headline);
     if d =!= null then SEQ join( {"  --  ", SEQ d} )
     )

getUsage := key -> (
     x := getOption(getDoc key, Usage);
     if x =!= null then SEQ x)

getSynopsis := key -> getOption(getDoc key, Synopsis)

evenMoreGeneral := key -> (
     t := nextMoreGeneral key;
     if t === null and class key === Sequence then key#0 else t)
headline = memoize (
     key -> (
	  while ( d := getHeadline key ) === null and ( key = evenMoreGeneral key ) =!= null do null;
	  d))

moreGeneral := s -> (
     n := nextMoreGeneral s;
     if n =!= null then SEQ { "Next more general method: ", TO n, headline n, PARA{} }
     )

-----------------------------------------------------------------------------

optTO := i -> if getDoc i =!= null then SEQ{ TO i, headline i } else formatDocumentTagTO i

smenu := s -> MENU (optTO \ last \ sort apply(s , i -> {formatDocumentTag i, i}) )
 menu := s -> MENU (optTO \ s)

ancestors1 := X -> if X === Thing then {Thing} else prepend(X, ancestors1 parent X)
ancestors := X -> if X === Thing then {} else ancestors1(parent X)

vowels := set characters "aeiouAEIOU"
indefinite := s -> concatenate(if vowels#?(s#0) and not match("^one ",s) then "an " else "a ", s)
synonym = X -> if X.?synonym then X.synonym else "object of class " | toString X

synonymAndClass := X -> (
     if X.?synonym
     then SEQ {indefinite X.synonym, " (of class ", TO X, ")"}
     else SEQ {"an object of class ", TO X}
     )     

justClass := X -> SEQ {"an instance of class ", TO X}

usage := s -> (
     o := getDocBody s;
     if o =!= null then SEQ {o, PARA{}}
     )

title := s -> SEQ { CENTER { BIG formatDocumentTag s, headline s }, PARA{} }

inlineMenu := x -> between(", ", TO \ x)

type := S -> (
     s := value S;
     X := class s;
     SEQ {
	  SEQ {
	       "The ",
	       if X.?synonym then X.synonym else "object",
	       " \"", toString S, "\" is a member of the class ", TO class s, ".\n"
	       },
	  if instance(s,Type) then (
	       SEQ {
		    if s.?synonym then SEQ {
			 "Each object of class ", toString s, " is called ", indefinite s.synonym, ".\n"
			 },
		    if parent s =!= Thing then SEQ {
			 "Each ", synonym s, " is also a member of class ", TO parent s, ".",
			 PARA{},
			 "More general types (whose methods may also apply) :",
			 SHIELD MENU (
			      Y := parent s;
			      while Y =!= Thing list TO toString Y do Y = parent Y
			      )
			 }
		    }
	       ),
	  PARA{}
	  }
     )

optargs := method(SingleArgumentDispatch => true)

optargs Thing := x -> null
     
optargs Function := f -> (
     o := options f;
     if o =!= null then SEQ {
	  NOINDENT{},
	  "Optional arguments :", newline,
	  SHIELD smenu apply(keys o, t -> f => t)})

optargs Sequence := s -> (
     o := options s;
     if o =!= null then SEQ {
	  NOINDENT{},
	  "Optional arguments :", newline,
	  SHIELD smenu apply(keys o, t -> s => t)}
     else optargs s#0)

synopsis := method(SingleArgumentDispatch => true)
synopsis Thing := f -> (
     SYN := getSynopsis f;
     if SYN =!= null then (
	  t := i -> if SYN#?(i+1) then (
	       if class SYN#i === Option 
	       then SEQ { TT SYN#i#0, if SYN#i#1 =!= null then SEQ {": ", SEQ SYN#i#1} }
	       else SEQ SYN#i
	       );
	  SEQ {
	       BOLD "Synopsis:",
	       SHIELD MENU {
		    if SYN#?0 then SEQ { "Usage: ", TT SYN#0},
		    if SYN#?1 then SEQ { "Input:", MENU { t 1, t 2, t 3 } },
		    if SYN#?1 and SYN#-1 =!= null then SEQ { "Output:", MENU { t(-1) } }
		    }
	       }
	  )
     )

typicalValue := k -> (
     if typicalValues#?k then typicalValues#k 
     else if class k === Sequence and typicalValues#?(k#0) then typicalValues#(k#0)
     else Thing
     )

synopsis Sequence := s -> (
     t := typicalValue s;
     desc1 := desc2 := desc3 := descv := ".";
     retv := arg1 := arg2 := arg3 := null;
     SYN := getSynopsis s;
     d := x -> if x === null then "." else SEQ { ": ", SEQ x };
     if SYN =!= null then (
	  if SYN#?1 and s#?1 then (
	       if class SYN#1 === Option then (arg1 = TT SYN#1#0; desc1 = d SYN#1#1;)
	       else desc1 = d SYN#1;
	  if SYN#?2 and s#?2 then (
	       if class SYN#2 === Option then (arg2 = TT SYN#2#0; desc2 = d SYN#2#1;)
	       else desc2 = d SYN#2);
	  if SYN#?3 and s#?3 then (
	       if class SYN#3 === Option then (arg3 = TT SYN#3#0; desc3 = d SYN#3#1;)
	       else desc3 = d SYN#3);
     	  if SYN#?-1 then (
	       if class SYN#-1 === Option then (retv = TT SYN#-1#0; descv = d SYN#-1#1;)
	       else descv = d SYN#-1);
	       );
	  );
     SEQ {
	  BOLD "Synopsis:",
	  SHIELD MENU {
	       if SYN#?0 then SEQ{ "Usage: ", TT SYN#0},
	       SEQ { if class s#0 === Function then "Function: " else "Operator: ", TO s#0, headline s#0 },
	       SEQ { "Input:",
		    MENU {
			 if arg1 === null
			 then SEQ {justClass s#1, desc1 }
			 else SEQ {arg1, ", ", justClass s#1, desc1 }, 
			 if #s > 2 then
			 if arg2 === null
			 then SEQ {justClass s#2, desc2 } 
			 else SEQ {arg2, ", ", justClass s#2, desc2 }, 
			 if #s > 3 then
			 if arg3 === null
			 then SEQ {justClass s#3, desc3 }
			 else SEQ {arg3, ", ", justClass s#3, desc3 }
			 }
		    },
	       if t =!= Thing or retv =!= null or descv =!= "." 
	       then SEQ {
	       	    "Output:",
	       	    MENU {
		    	 if retv === null
		    	 then SEQ {justClass t, descv}
		    	 else SEQ {retv, ", ", justClass t  , descv}
		    	 }
		    },
	       optargs s,
	       moreGeneral s
     	       }
	  }
     )

documentableMethods := s -> select(methods s, isDocumentableTag)

fmeth := f -> (
     b := documentableMethods f;
     if methodFunctionOptions#?f and not methodFunctionOptions#f.SingleArgumentDispatch
     then b = select(b, x -> x =!= (f,Sequence));
     if #b > 0 then SEQ {
	  NOINDENT{},
	  "Ways to use ", TT toString f," :", newline, 
	  SHIELD smenu b
	  } )

noBriefDocThings := hashTable { symbol <  => true, symbol >  => true, symbol == => true }
noBriefDocClasses := hashTable { String => true, Option => true, Sequence => true }
briefDocumentation = x -> (
     if noBriefDocClasses#?(class x) or noBriefDocThings#?x or not isDocumentableThing x then return null;
     r := getUsage x;
     if r =!= null then << endl << text r << endl
     else (
	  r = synopsis x;
	  if r =!= null then << endl << text r << endl
	  else (
	       if headline x =!= null then << endl << headline x << endl;
	       if class x === Function then (
		    s := fmeth x;
		    if s =!= null then << endl << text s << endl;))))

documentation = method(SingleArgumentDispatch => true)
documentation String := s -> (
     if unformatTag#?s then documentation unformatTag#s 
     else if isGlobalSymbol s then (
	  t := getGlobalSymbol s;
	  documentation t
	  )
     else SEQ { title s, getDocBody s }
     )

-- documentation Thing := s -> (
--      scan(packages, pkg -> (
-- 	       d := pkg#"reverse dictionary";
-- 	       if d#?s then break documentation d#s;
-- 	       )))

binary := set binaryOperators; erase symbol binaryOperators
prefix := set prefixOperators; erase symbol prefixOperators
postfix := set postfixOperators; erase symbol postfixOperators
other := set otherOperators; erase symbol otherOperators
operatorSet = binary + prefix + postfix + other
op := s -> if operatorSet#?s then (
     ss := toString s;
     SEQ {
	  if binary#?s then SEQ {
	       NOINDENT{}, 
	       "This operator may be used as a binary operator in an expression \n",
	       "like ", TT ("x "|ss|" y"), ".  The user may install ", TO {"binary methods"}, " \n",
	       "for handling such expressions with code such as ",
	       if ss == " "
	       then PRE ("         X Y := (x,y) -> ...")
	       else PRE ("         X "|ss|" Y := (x,y) -> ..."), 
	       NOINDENT{},
	       "where ", TT "X", " is the class of ", TT "x", " and ", TT "Y", " is the \n",
	       "class of ", TT "y", ".", PARA{}
	       },
	  if prefix#?s then SEQ {
	       NOINDENT{}, 
	       "This operator may be used as a prefix unary operator in an expression \n",
	       "like ", TT (ss|" y"), ".  The user may install a method for handling \n",
	       "such expressions with code such as \n",
	       PRE ("           "|ss|" Y := (y) -> ..."),
	       NOINDENT{},
	       "where ", TT "Y", " is the class of ", TT "y", ".", PARA{}
	       },
	  if postfix#?s then SEQ {
	       NOINDENT{}, 
	       "This operator may be used as a postfix unary operator in an expression \n",
	       "like ", TT ("x "|ss), ".  The user may install a method for handling \n",
	       "such expressions with code such as \n",
	       PRE ("         X "|ss|"   := (x,y) -> ..."),
	       NOINDENT{}, "where ", TT "X", " is the class of ", TT "x", ".", PARA{}
	       },
	  }
     )

optionFor := s -> unique select( value \ flatten(values \ globalDictionaries), f -> class f === Function and (options f)#?s) -- this is slow!

ret := k -> (
     t := typicalValue k;
     if t =!= Thing then SEQ {"Class of returned value: ", TO t, headline t, PARA{}}
     )
seecode := x -> (
     f := lookup x;
     n := code f;
     if n =!= null 
     and height n + depth n <= 10 and width n <= maximumCodeWidth
     then SEQ { "Code:", PRE concatenate between(newline,unstack n) }
     )

documentationValue := method()
documentationValue(Symbol,Function) := (s,f) -> SEQ { ret f, fmeth f, optargs f, seecode f }
documentationValue(Symbol,Type) := (s,X) -> (
     syms := flatten(values \ globalDictionaries);
     a := apply(select(pairs typicalValues, (key,Y) -> Y===X and isDocumentableTag key), (key,Y) -> key);
     b := toString \ select(syms, y -> instance(value y, Type) and parent value y === X);
     c := select(documentableMethods X, key -> not typicalValues#?key or typicalValues#key =!= X);
     e := toString \ select(syms, y -> not mutable y and class value y === X);
     SEQ {
	  if #b > 0 then SEQ {
	       "Types of ", if X.?synonym then X.synonym else toString X, " :", PARA{},
	       smenu b, PARA{}},
	  if #a > 0 then SEQ {
	       "Functions and methods returning ",
	       indefinite synonym X, " :", PARA{},
	       SHIELD smenu a, PARA{}
	       },
	  if #c > 0 then SEQ {"Methods for using ", indefinite synonym X, " :", PARA{}, 
	       SHIELD smenu c, PARA{}},
	  if #e > 0 then SEQ {"Fixed objects of class ", toString X, " :", PARA{}, 
	       SHIELD smenu e, PARA{}},
	  })
documentationValue(Symbol,HashTable) := (s,x) -> (
     c := documentableMethods x;
     SEQ {
	  if #c > 0 then SEQ {"Functions installed in ", toString x, " :", PARA{}, 
	       SHIELD smenu c, PARA{}},
	  })
documentationValue(Symbol,Thing) := (s,x) -> SEQ { }

documentation Symbol := S -> (
     a := apply(select(optionFor S,f -> isDocumentableTag f), f -> f => S);
     b := documentableMethods S;
     SEQ {
	  title S, 
	  synopsis S,
	  usage S,
	  op S,
	  if #a > 0 then SEQ {"Functions with optional argument named ", toExternalString S, " :", PARA{}, SHIELD smenu a, PARA{}},
	  if #b > 0 then SEQ {"Methods for ", toExternalString S, " :", PARA{}, SHIELD smenu b, PARA{}},
     	  documentationValue(S,value S),
	  type S
     	  }
     )

documentation Option := v -> (
     (fn, opt) -> (
	  if not (options fn)#?opt then error ("function ", fn, " does not accept option key ", opt);
	  default := (options fn)#opt;
	  SEQ { 
	       title v,
	       synopsis v,
	       usage v,
	       BOLD "See also:",
	       SHIELD MENU {
		    SEQ{ "Default value: ", if hasDocumentation default then TOH default else TT default },
		    SEQ{ if class fn === Sequence then "Method: " else "Function: ", TOH fn },
		    SEQ{ "Option name: ", TOH opt }
		    }
	       }
	  )
     ) toSequence v

documentation Sequence := s -> (
     if null === lookup s then error("expected ", toString s, " to be a method");
     SEQ {
	  title s, 
	  synopsis s,
	  usage s,
	  seecode s
	  }
     )

documentation Thing := x -> (
     s := reverseDictionary x;
     if s =!= null then documentation s else SEQ{ " -- undocumented -- "}
     )

hasDocumentation = x -> (
     fkey := formatDocumentTag x;
     p := select(packages, P -> P#"documentation"#?fkey);
     0 < #p)

hr1 := newline | "-----------------------------------------------------------------------------" | newline
hr := v -> concatenate mingle(#v + 1 : hr1 , v)

help = method(SingleArgumentDispatch => true)
help List := v -> hr apply(v, help)
help Thing := s -> (
     "Documentation for " | toExternalString formatDocumentTag s | " :" |newline| text documentation s
     )

-----------------------------------------------------------------------------
-- helper functions useable in documentation
-----------------------------------------------------------------------------

numtests := 0

TEST = method()
TEST String := s -> (
     x := currentPackage#"test inputs";
     x# #x = s;
     )
TEST List := y -> TEST \ y

SEEALSO = v -> (
     if class v =!= List then v = {v};
     if #v > 0 then SEQ { PARA{}, BOLD "See also:", SHIELD MENU (TO \ v) })

CAVEAT = v -> SEQ { PARA{}, BOLD "Caveat:", SHIELD MENU { SEQ v } }

-----------------------------------------------------------------------------
-- html output
-----------------------------------------------------------------------------
-- move this into another file after the merge

htmlLiteralTable := new MutableHashTable
scan(characters ascii(0 .. 255), c -> htmlLiteralTable#c = c)
htmlLiteralTable#"\"" = "&quot;"
htmlLiteralTable#"<" = "&lt;"
htmlLiteralTable#"&" = "&amp;"
htmlLiteralTable#">" = "&gt;"
htmlLiteral = s -> concatenate apply(characters s, c -> htmlLiteralTable#c)

htmlExtraLiteralTable := copy htmlLiteralTable
htmlExtraLiteralTable#" " = "&nbsp;"
htmlExtraLiteral = s -> concatenate apply(characters s, c -> htmlExtraLiteralTable#c)
-----------------------------------------------------------------------------
texLiteralTable := new MutableHashTable
    scan(0 .. 255, c -> texLiteralTable#(ascii{c}) = concatenate(///{\char ///, toString c, "}"))
    scan(characters ascii(32 .. 126), c -> texLiteralTable#c = c)
    scan(characters "\\{}$&#^_%~|<>", c -> texLiteralTable#c = concatenate("{\\char ", toString (ascii c)#0, "}"))
    texLiteralTable#"\n" = "\n"
    texLiteralTable#"\r" = "\r"
    texLiteralTable#"\t" = "\t"
    texLiteralTable#"`" = "{`}"     -- break ligatures ?` and !` in font \tt
				   -- see page 381 of TeX Book
texLiteral := s -> concatenate apply(characters s, c -> texLiteralTable#c)

HALFLINE := ///\vskip 4.75pt
///
ENDLINE := ///\leavevmode\hss\endgraf
///
VERBATIM := ///\begingroup\baselineskip=9.5pt\tt\parskip=0pt
///
ENDVERBATIM := ///\endgroup{}///

texExtraLiteralTable := copy texLiteralTable
texExtraLiteralTable#" " = "\\ "
texExtraLiteral := s -> concatenate between(ENDLINE,
     apply(lines s, l -> apply(characters l, c -> texExtraLiteralTable#c))
     )
-----------------------------------------------------------------------------

html String := htmlLiteral
mathML String := x -> concatenate("<mtext>",htmlLiteral x,"</mtext>")
tex String := texLiteral
texMath String := s -> (
     if #s === 1 then s
     else concatenate("\\text{", texLiteral s, "}")
     )
text String := identity

text Thing := toString

texMath List := x -> concatenate("\\{", between(",", apply(x,texMath)), "\\}")
texMath Array := x -> concatenate("[", between(",", apply(x,texMath)), "]")
texMath Sequence := x -> concatenate("(", between(",", apply(x,texMath)), ")")

texMath HashTable := x -> if x.?texMath then x.texMath else texMath expression x

tex HashTable := x -> (
     if x.?tex then x.tex 
     else if x.?texMath then concatenate("$",x.texMath,"$")
     else if x.?name then x.name
     else tex expression x
     )

mathML Nothing := texMath Nothing := tex Nothing := html Nothing := text Nothing := x -> ""

specials := new HashTable from {
     symbol ii => "&ii;"
     }

mathML Symbol := x -> concatenate("<mi>",if specials#?x then specials#x else toString x,"</mi>")

tex Function := x -> "--Function--"

tex Boolean := tex Symbol := 
text Symbol := text Boolean := 
html Symbol := html Boolean := toString

texMath Function := texMath Boolean := x -> "\\text{" | tex x | "}"

html MarkUpList := x -> concatenate apply(x,html)
text MarkUpList := x -> concatenate apply(x,text)
tex MarkUpList := x -> concatenate apply(x,tex)
net MarkUpList := x -> peek x
texMath MarkUpList := x -> concatenate apply(x,texMath)
mathML MarkUpList := x -> concatenate apply(x,mathML)

--html MarkUpType := H -> html H{}
--text MarkUpType := H -> text H{}
--tex MarkUpType := H -> tex H{}
--net MarkUpType := H -> net H{}
--texMath MarkUpType := H -> tex H{}

html BR := x -> ///
<BR>
///
text BR := x -> ///
///
tex  BR := x -> ///
\hfil\break
///

html NOINDENT := x -> ""
net NOINDENT := x -> ""
text NOINDENT := x -> ""
tex  NOINDENT := x -> ///
\noindent\ignorespaces
///

html BIG := x -> concatenate( "<b><font size=4>", apply(x, html), "</font></b>" )

html HEAD := html CENTER := 
x -> concatenate(newline, 
     "<", toString class x, ">", newline,
     apply(x, html), newline,
     "</", toString class x, ">", newline
     )

html TITLE := 
x -> concatenate(newline, 
     "<", toString class x, ">", apply(x, html), "</", toString class x, ">", newline
     )

html HR := x -> ///
<hr>
///
text HR := x -> ///
-----------------------------------------------------------------------------
///
tex  HR := x -> ///
\hfill\break
\hbox to\hsize{\leaders\hrule\hfill}
///

html PARA := x -> (
     if #x === 0 
     then ///
<P>
///
     else concatenate(///
<P>
///,
          apply(x,html),
          ///
</P>
///
          )
     )

tex PARA := x -> concatenate(///
\par
///,
     apply(x,tex))


trimline := x -> selectRegexp ( "^ *(.*[^ ]|) *$",1, x)

text PARA := x -> toString (
     x = toList x;
     x = flatten apply(x, s -> if class s === String then trimline \ lines s else s);
     x = prepend("    ",x);
     x = net \ x;
     x = select(x, n -> width n > 0);
     x = horizontalJoin between(" ",x);
     wrap("",x)) | newline

text EXAMPLE := x -> concatenate apply(#x, i -> text PRE concatenate("i",toString (i+1)," : ",x#i))
html EXAMPLE := x -> concatenate html ExampleTABLE apply(#x, i -> {x#i, CODE concatenate("i",toString (i+1)," : ",x#i)})

text TABLE := x -> concatenate(newline, newline, apply(x, row -> (row/text, newline))) -- not good yet
text ExampleTABLE := x -> "\n" | toString (boxNets apply(toList x, y -> text y#1)) | "\n\n"
net ExampleTABLE := x -> "    " | stack between("",apply(toList x, y -> "" | net y#1 || ""))

tex TABLE := x -> concatenate applyTable(x,tex)
texMath TABLE := x -> concatenate (
     ///
\matrix{
///,
     apply(x,
	  row -> (
	       apply(row,item -> (texMath item, "&")),
	       ///\cr
///
	       )
	  ),
     ///}
///
     )

tex ExampleTABLE := x -> concatenate apply(x,y -> tex y#1)

html TABLE := x -> concatenate(
     newline,
     "<table>",
     newline,
     apply(x, row -> ( 
	       "  <tr>",
	       newline,
	       apply(row, item -> ("    <td align=center>", html item, "</td>",newline)),
	       "  </tr>",
	       newline)),
     "</table>",
     newline
     )			 

html ExampleTABLE := x -> concatenate(
     newline,
     "<p>",
     "<center>",
     "<table cellspacing='0' cellpadding='12' border='4' bgcolor='#80ffff' width='100%'>",
     newline,
     apply(x, 
	  item -> (
	       "  <tr>", newline,
	       "    <td nowrap>", html item#1, "</td>", newline,
	       "  </tr>", newline
	       )
	  ),
     "</table>",
     "</center>",
     "</p>"
     )			 

net PRE := x -> net concatenate x
text PRE   := x -> concatenate(
     newline,
     demark(newline,
	  apply(lines concatenate x, s -> concatenate("     ",s))),
     newline
     )
html PRE   := x -> concatenate( 
     "<pre>", 
     html demark(newline,
	  apply(lines concatenate x, s -> concatenate("     ",s))),
     "</pre>"
     )

shorten := s -> (
     while #s > 0 and s#-1 == "" do s = drop(s,-1);
     while #s > 0 and s#0 == "" do s = drop(s,1);
     s)

verbatim := x -> concatenate ( VERBATIM, texExtraLiteral concatenate x, ENDVERBATIM )

tex TT := texMath TT := verbatim
tex CODE :=
tex PRE := x -> concatenate ( VERBATIM,
     ///\penalty-200
///,
     HALFLINE,
     shorten lines concatenate x
     / (line ->
	  if #line <= maximumCodeWidth then line
	  else concatenate(substring(0,maximumCodeWidth,line), " ..."))
     / texExtraLiteral
     / (line -> if line === "" then ///\penalty-170/// else line)
     / (line -> (line, ENDLINE)),
     ENDVERBATIM,
     HALFLINE,
     ///\penalty-200\par{}
///
     )

text TT    := x -> concatenate   ("'", text \ toList x, "'")
net TT     := x -> horizontalJoin splice ("'", net  \ toSequence x, "'")


htmlDefaults = new MutableHashTable from {
     "BODY" => "bgcolor='#e4e4ff'"
     }

html BODY := x -> concatenate(
     "<body ", htmlDefaults#"BODY", ">", newline,
     apply(x, html), newline,
     "</body>", newline
     )

html LISTING := t -> "<listing>" | concatenate toSequence t | "</listing>";

texMath STRONG := tex STRONG := x -> concatenate("{\\bf ",apply(x,tex),"}")

texMath ITALIC := tex ITALIC := x -> concatenate("{\\sl ",apply(x,tex),"}")
html ITALIC := x -> concatenate("<I>",apply(x,html),"</I>")

texMath TEX := tex TEX := x -> concatenate toList x

texMath SEQ := tex SEQ := x -> concatenate(apply(toList x, tex))
text SEQ := x -> (
     x = toList x;
     P := PARA{};
     p := positions(x, i -> i === P);
     p = apply(prepend(-1,p),append(p,#x),identity);
     p = select(p, (i,j) -> i+1 < j);
     x = apply(p, (i,j) -> text \ take(x, {i+1,j-1}));
     x = flatten between(P,x);
     concatenate \\ text \ x
     )
html SEQ := x -> concatenate(apply(toList x, html))
net SEQ := x -> (
     x = toList x;
     p := join({-1},positions(x,i -> class i === PARA or class i === BR),{#x});
     stack apply(#p - 1, 
	  i -> horizontalJoin apply(take(x,{p#i+1, p#(i+1)-1}), net)
	  )
     )

tex Sequence := tex List := tex Array := x -> concatenate("$",texMath x,"$")

text Sequence := x -> concatenate("(", between(",", apply(x,text)), ")")
text List := x -> concatenate("{", between(",", apply(x,text)), "}")

html Sequence := x -> concatenate("(", between(",", apply(x,html)), ")")
html List := x -> concatenate("{", between(",", apply(x,html)), "}")

net CODE := x -> stack lines concatenate x

html CODE   := x -> concatenate( 
     "<code>", 
     demark( ("<br>",newline), apply(lines concatenate x, htmlExtraLiteral) ),
     "</code>"
     )


html ANCHOR := x -> (
     "<a name=\"" | x#0 | "\">" | html x#-1 | "</a>"
     )
text ANCHOR := x -> "\"" | x#-1 | "\""
tex ANCHOR := x -> (
     concatenate(
	  ///\special{html:<A name="///, texLiteral x#0, ///">}///,
	  tex x#-1,
	  ///\special{html:</A>}///
	  )
     )

html SHIELD := x -> concatenate apply(x,html)
text SHIELD := x -> concatenate apply(x,text)
net SHIELD := x -> horizontalJoin apply(x,net)

html TEX := x -> x#0

addHeadlines := x -> apply(x, i -> if instance(i,TO) then SEQ{ i, headline i#0 } else i)

html MENU := x -> concatenate (
     newline,
     "<p>", newline,
     "<menu>", newline,
     apply(addHeadlines x, s -> if s =!= null then ("<li>", html s, "</li>", newline)),
     "</menu>", newline, 
     "</p>", newline)

addHeadlines1 := x -> apply(x, i -> if instance(i,TO) then SEQ{ "help ", i, headline i#0 } else i)

text MENU := x -> concatenate(
     newline,
     apply(addHeadlines1 x, s -> if s =!= null then ("    ", text s, newline))
     )

net MENU := x -> "    " | stack apply(toList addHeadlines x, net)

tex MENU := x -> concatenate(
     ///\begin{itemize}///, newline,
     apply(addHeadlines x, x -> if x =!= null then ( ///\item ///, tex x, newline)),
     ///\end{itemize}///, newline)

html UL   := x -> concatenate(
     "<p>", newline,
     "<ul>", newline,
     apply(x, s -> ("<li>", html s, "</li>", newline)),
     "</ul>", newline, 
     "</p>", newline)

text UL   := x -> concatenate(
     newline,
     apply(x, s -> ("    ", text s, newline)))

html OL   := x -> concatenate(
     "<p>", newline,
     "<ol>", newline,
     apply(x,s -> ("<li>", html s, "</li>", newline)),
     "</ol>", newline, 
     "</p>", newline
     )
text OL   := x -> concatenate(
     newline,
     apply(x,s -> ("    ", text s, newline)))

html NL   := x -> concatenate(
     "<p>", newline,
     "<nl>", newline,
     apply(x, s -> ("<li>", html s, newline)),
     "</nl>", newline, 
     "</p>", newline)
text NL   := x -> concatenate(
     newline,
     apply(x,s -> ("    ",text s, newline)))

html DL   := x -> (
     "<dl>" 
     | concatenate apply(x, p -> (
	       if class p === List or class p === Sequence then (
		    if # p === 2 then "<dt>" | html p#0 | "<dd>" | html p#1
		    else if # p === 1 then "<dt>" | html p#0
		    else error "expected a list of length 1 or 2"
		    )
	       else "<dt>" | html p
	       ))
     | "</dl>")	  
text DL   := x -> concatenate(
     newline,
     apply(x, p -> (
	       if class p === List or class p === Sequence then (
		    if # p === 2 
		    then (
			 "    ", text p#0, newline,
			 "    ", text p#1,
			 newline,
			 newline)
		    else if # p === 1 
		    then ("    ", 
			 text p#0, 
			 newline, 
			 newline)
		    else error "expected a list of length 1 or 2"
		    )
	       else ("    ", text p, newline)
	       )),
     newline)

texMath SUP := x -> concatenate( "^{", apply(x, tex), "}" )
texMath SUB := x -> concatenate( "_{", apply(x, tex), "}" )

text SUP := x -> "^" | text x#0
text SUB := x -> "_" | text x#0

net  TO := text TO := x -> concatenate ( "\"", formatDocumentTag x#0, "\"", drop(toList x, 1) )
tex  TO := x -> (
     key := x#0;
     node := formatDocumentTag key;
     tex SEQ {
     	  TT formatDocumentTag x#0,
     	  " [", LITERAL { ///\ref{///, 
		    -- rewrite this later:
		    -- cacheFileName(documentationPath, node),
		    ///}/// },
	  "]"
	  }
     )

             toh := op -> x -> op SEQ{ new TO from x, headline x#0 }
            htoh := op -> x -> op SEQ{ new TO from x, headline x#0 }
net  TOH :=  toh net
text TOH := htoh text
html TOH :=  toh html
tex  TOH :=  toh tex

tex LITERAL := html LITERAL := x -> concatenate x
html EmptyMarkUpType := html MarkUpType := X -> html X{}
html ITALIC := htmlMarkUpType "I"
html UNDERLINE := htmlMarkUpType "U"
html TEX := x -> x#0	    -- should do something else!
html BOLD := htmlMarkUpType "B"

tex BASE := text BASE := net BASE := x -> ""

html Option := x -> toString x
text Option := x -> toString x

net BIG := x -> net x#0
net CENTER := x -> net x#0

tex HEADER1 := x -> concatenate (
     ///\medskip\noindent\begingroup\font\headerFontOne=cmbx12 scaled \magstep 1\headerFontOne%
///,
     apply(toList x, tex),
     ///\endgroup\par\smallskip%
///
     )
tex HEADER2 := x -> concatenate (
     ///\medskip\noindent\begingroup\font\headerFontTwo=cmbx12 scaled \magstep 1\headerFontTwo%
///,
     apply(toList x, tex),
     ///\endgroup\par\smallskip%
///
     )
tex HEADER3 := x -> concatenate (
     ///\medskip\noindent\begingroup\font\headerFontThree=cmbx12\headerFontThree%
///,
     apply(toList x, tex),
     ///\endgroup\par\smallskip%
///
     )
tex HEADER4 := x -> concatenate (
     ///\medskip\noindent\begingroup\font\headerFontFour=cmbx12\headerFontFour%
///,
     apply(toList x, tex),
     ///\endgroup\par\smallskip%
///
     )
tex HEADER5 := x -> concatenate (
     ///\medskip\noindent\begingroup\font\headerFontFive=cmbx10\headerFontFive%
///,
     apply(toList x, tex),
     ///\endgroup\par\smallskip%
///
     )
tex HEADER6 := x -> concatenate (
     ///\medskip\noindent\begingroup\font\headerFontSix=cmbx10\headerFontSix%
///,
     apply(toList x, tex),
     ///\endgroup\par\smallskip%
///
     )

html HEADER1 := x -> concatenate (
     ///
<H1>///,
     apply(toList x, html),
     ///</H1>
///
     )

html HEADER2 := x -> concatenate (
     ///
<H2>///,
     apply(toList x, html),
     ///</H2>
///
     )

html HEADER3 := x -> concatenate (
     ///
<H3>///,
     apply(toList x, html),
     ///</H3>
///
     )

html HEADER4 := x -> concatenate (
     ///
<H4>///,
     apply(toList x, html),
     ///</H4>
///
     )

html HEADER5 := x -> concatenate (
     ///
<H5>///,
     apply(toList x, html),
     ///</H5>
///
     )

html HEADER6 := x -> concatenate (
     ///
<H6>///,
     apply(toList x, html),
     ///</H6>
///
     )

SECTION = new MarkUpType
html SECTION := x -> html SEQ {
     HEADER2 take(toList x,1),
     SEQ drop(toList x,1)
     }
tex SECTION := x -> tex SEQ {
     HEADER2 take(toList x,1),
     SEQ drop(toList x,1)
     }

TOC = new MarkUpType
html TOC := x -> (
     x = toList x;
     if not all(apply(x,class), i -> i === SECTION)
     then error "expected a list of SECTIONs";
     title := i -> x#i#0;
     tag := i -> "sec:" | toString i;
     html SEQ {
	  SECTION {
	       "Sections:",
	       MENU for i from 0 to #x-1 list HREF { "#" | tag i, title i }
	       },
	  SEQ for i from 0 to #x-1 list SEQ { newline, ANCHOR { tag i, ""} , x#i }
	  }
     )

-----------------------------------------------------------------------------

dummyDoc := x -> document {
     if value x =!= x and (
	  class value x === Function
	  or class value x === ScriptedFunctor
	  or instance(value x, Type)
	  )
     then value x
     else x,
     Headline => "undocumented symbol", "No documentation provided yet."}

undocErr := x -> (
     pos := locate x;
     pos = if pos === null then "error: " else pos#0 | ":" | toString pos#1 | ": ";
     stderr << pos << x;
     stderr << " undocumented " << synonym class value x;
     stderr << endl;
     )

undocumentedSymbols = () -> select(
     flatten(values \ globalDictionaries), 
     x -> (
	  if (
	       -- x =!= value x and        -- ignore symbols with no value assigned
	       not DocDatabase#?(toString x)
	       ) 
     	  then (
	       undocErr x;
	       dummyDoc x;
	       true)))

-----------------------------------------------------------------------------

new TO from List := (TO,x) -> (
     verifyTag first x;
     x)
new IMG from List := (IMG,x) -> (
     url := first x;
     --   It's hard to know where the html file will go, and if the path to image is relative
     --   then we can't check it.
     -- if not isAbsolute url and not fileExists url then error ("file ", url, " does not exist");
     x)

erase symbol htmlMarkUpType

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/m2 "
-- End:
