--		Copyright 1995 by Daniel R. Grayson

-- this file has an unusual name so it will be done last.

end

if class documentation "Macaulay 2" =!= SEQ then (
     stderr
     << ///Can't get started on checking documentation, top node missing, key: "Macaulay 2".///
     << endl;
     if class documentation "\"Macaulay 2\"" === SEQ then (
     	  stderr << ///Hmm, the quoted key "Macaulay 2" is there!/// << endl;
	  );
     error "top documentation node missing"
     )

setrecursionlimit 4000

path = {"."}

haderror := false

warning := (sym,msg) -> (
     haderror = true;
     r := locate sym;
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

DocumentationProvided := set topicList()

verify TO := verify TOH := x -> (
     s := formatDocumentTag x#0;
     if not DocumentationProvided#?s and not DocumentationMissing#?s 
     then DocumentationMissing#s = currentPage;
     )

reach TO := reach TOH := x -> (
     s := formatDocumentTag x#0;
     if not reachable#?s or not reachable#s
     then (
	  reachable#s = true;
	  reach documentation s;
	  ))

scan(keys DocumentationProvided,
     s -> (
	  reachable#s = false;
	  d := documentation s;
	  currentPage = s;
	  verify d;
	  ))
reachable#"Macaulay 2" = true

assert( class documentation "Macaulay 2" === SEQ )

topName = "Macaulay 2"
reach documentation topName
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
DocumentationNotNeeded#(symbol
     ) = true
DocumentationNotNeeded#(symbol[) = true
DocumentationNotNeeded#(symbol{) = true
DocumentationNotNeeded#(symbol() = true

scan(sort pairs tab, (n,s) -> (
     tag := toString s;
     if not DocumentationProvided#?tag and not DocumentationNotNeeded#?tag
     then warning(s,"no documentation for symbol '"|n|"'")))

-- symbols which have been seen only once and are not protected
unset := sort select (values tab, s -> 
     class s === Symbol
     and lookupCount s === 1
     and mutable s
     and toString s =!= "\n"
     )
scan(unset, s -> warning(s,"symbol '"|toString s|"' seen only once"))

if haderror then exit 1
-- Local Variables:
-- compile-command: "make ZZdoc.okay"
-- End:
