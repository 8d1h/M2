newPackage(
	"SimpleDoc",
    	Version => "0.1", 
    	Date => "June 28, 2008",
	AuxiliaryFiles=>true,
    	Authors => {{Name => "Mike Stillman", 
		  Email => "math@math.cornell.edu", 
		  HomePage => "http://www.math.cornell.edu/~mike/"}},
    	Headline => "a simple documentation function",
    	DebuggingMode => true
    	)

export {doc}

doc = method()
doc String := (s) -> document toDoc s

splitByIndent = (text, indents) -> (
     m := min indents;
     keypos := positions(indents, x -> x === m);
     keypos = append(keypos,#text);
     for i from 0 to #keypos-2 list (keypos#i,keypos#(i+1)-1)
     )

indentationLevel = (s) -> (
     lev := 0;
     for i from 0 to #s-1 do (
	  if s#i === " " then lev = lev+1
	  else if s#i === "\t" then lev = 8*((lev+8)//8)
	  else return (lev, replace("[[:space:]]+$","",substring(i, s)))
	  );
     (infinity, "")
     )

singleString = (key, text) -> (
     if #text =!= 1 then 
       error("expected single indented line after "|toString key);
     key => text#0)

markup2 = (text, indents) -> (
     s := concatenate between(" ",text);
     sp := separateRegexp(///(^|[^\])(@)///, 2, s);
     sp = apply(sp, s -> replace(///\\@///,"@",s));
     if not odd(#sp) then error "unmatched @";
     for i from 0 to #sp-1 list
	  if even i then TEX sp#i else value sp#i
     )

markup = (text, indents) -> (
     text = prepend("",text);
     indents = prepend(infinity,indents);
     indents = apply(indents, n -> if n === infinity then -1 else n);
     splits := splitByIndent(text, indents);
     apply(splits, (i,j) -> PARA markup2(text_{i+1..j},indents_{i+1..j})))
     
items = (text, indents) -> (
     apply(splitByIndent(text, indents), (i,j) -> (
	       s := text#i;
	       ps := separateRegexp("[[:space:]]*:[[:space:]]*", s);
	       if #ps =!= 2 then error("first line should contain a colon: ",s);
	       result := if i === j then "" else markup2(text_{i+1..j}, indents_{i+1..j});
	       if ps#1 != "" then result = value ps#1 => result;
	       if ps#0 != "" then result = ps#0 => result;
	       result
	       ))
     )

DescriptionFcns = new HashTable from {
     "Example" => (text,indents) -> EXAMPLE text,
     "Text" => markup
     }

applySplit = (fcns, text, indents) ->
     apply(splitByIndent(text,indents), (i,j) -> (
	       key := text#i;
	       if not fcns#?key then error("unrecognized keyword: ",format key);
	       fcns#key(text_{i+1..j}, indents_{i+1..j})))

description = (text, indents) -> toSequence applySplit(DescriptionFcns, text, indents)

KeyFcns = new HashTable from {
     "Key" => (text, indents) -> Key => apply(text,value),
     "SeeAlso" => (text, indents) -> SeeAlso => apply(text,value),
     "Usage" => (text, indents) -> singleString(Usage, text),
     "Headline" => (text, indents) -> singleString(Headline, text),
     "Description" => (text, indents) -> description(text,indents),
     "Caveat" => (text, indents) -> Caveat => {markup(text,indents)},
     "Consequences" => (text, indents) -> Consequences => {markup(text,indents)},
     "Inputs" => (text, indents) -> Inputs => items(text, indents),
     "Outputs" => (text, indents) -> Outputs => items(text, indents)
     }

toDoc = (text) -> (
     -- perform translations to 'document' format
     -- text is a string
     text = lines text;
     t := apply(text, indentationLevel);
     text = apply(t, last);
     indents := apply(t, first);
     splice applySplit(KeyFcns, text, indents)
     )

beginDocumentation()
document { 
	Key => SimpleDoc,
	Headline => "simpler documentation for functions and methods",
	EM "SimpleDoc", " contains a function to simplify writing documentation for functions "
	}

doc get (currentFileDirectory | "SimpleDoc/doc.txt")

end
restart
loadPackage "SimpleDoc"
installPackage SimpleDoc
viewHelp doc
debug SimpleDoc
flup = method()
flup ZZ := (n) -> -n
D = toDoc get "doc.eg"
document D
help flup
