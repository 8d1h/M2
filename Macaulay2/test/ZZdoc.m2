--		Copyright 1995 by Daniel R. Grayson

-- this file has an unusual name so it will be done last.

setrecursionlimit 1000

path = {"."}

haderror := false

warning := (sym,msg) -> (
     haderror = true;
     r := try locate sym else null;
     if r === null then (
	  stderr << "error: " << msg << endl;
	  )
     else ((filename,row1,row2) -> (
			   if version#"operating system" === "Windows NT"
			   then stderr << filename << "(" << row1 << ") : " << msg << endl
     	       else stderr << filename << ":" << row1 << ": " << msg << endl;
	       )) r)

tab := symbolTable()
currentPage := null
verify := method(SingleArgumentDispatch=>true)
local Reach
reach := method(SingleArgumentDispatch=>true)
DocumentationMissing := new MutableHashTable
reachable = new MutableHashTable
verify Thing := x -> null
verify Sequence := verify MarkUpList := x -> scan(x,verify)
reach Thing := x -> null
reach Sequence := reach MarkUpList := x -> scan(x,reach)

DocumentationProvided := set apply(topicList(), getDocumentationTag)

verify TO := x -> (
     s := getDocumentationTag x#0;
     if not DocumentationProvided#?s and not DocumentationMissing#?s 
     then DocumentationMissing#s = currentPage;
     )

reach TO := x -> (
     s := getDocumentationTag x#0;
     if not reachable#?s or not reachable#s
     then (
	  reachable#s = true;
	  reach doc s;
	  ))

scan(keys DocumentationProvided,
     s -> (
	  reachable#s = false;
	  d := doc s;
	  currentPage = s;
	  verify d;
	  ))
reachable#(getDocumentationTag "Macaulay 2") = true

assert( class doc "Macaulay 2" === SEQ )

topName = "Macaulay 2"
reach doc topName
scan(sort pairs DocumentationMissing,
     (s,w) -> warning(
	  if tab#?s then tab#s,
	  concatenate(
	       "documentation for '",toString s,"' missing, needed for '",toString w,"'"
	       )))

unreachable := applyPairs(
     new HashTable from reachable,
     (k,v) -> if not v then (k,true))
scan(sort keys unreachable,
     s -> warning(
	  if tab#?s then tab#s,
	  "documentation for '"|toString s|"' not reachable"))

DocumentationNotNeeded = new MutableHashTable
DocumentationNotNeeded#(quote
     ) = true
DocumentationNotNeeded#(quote[) = true
DocumentationNotNeeded#(quote{) = true
DocumentationNotNeeded#(quote() = true

scan(sort pairs tab, (n,s) -> (
     tag := getDocumentationTag s;
     if not DocumentationProvided#?tag and not DocumentationNotNeeded#?tag
     then warning(s,"no documentation for symbol '"|n|"'")))

-- symbols which have been seen only once and are not protected
unset := sort select (values tab, s -> 
     class s === Symbol
     and lookupCount s === 1
     and mutable s
     and string s =!= "\n"
     )
scan(unset, s -> warning(s,"symbol '"|name s|"' seen only once"))

if haderror then exit 1
