--		Copyright 1996 by Daniel R. Grayson

-----------------------------------------------------------------------------
toString String := identity
toString Symbol := string
toString MutableHashTable := s -> if s.?name and class s.name === String then s.name else concatenate (
     toString class s, if parent s =!= Nothing then (" of ", toString parent s), "{...}"
     )
toString HashTable := s -> if s.?name and class s.name === String then s.name else concatenate (
     "new ", toString class s,
     if parent s =!= Nothing then (" of ", toString parent s),
     " from {",
     if # s > 0
     then demark(", ", apply(pairs s, (k,v) -> toString k | " => " | toString v) )
     else "",
     "}")
toString MutableList := s -> concatenate(toString class s,"{...}")
toString BasicList := s -> concatenate(
     if class s =!= List then toString class s,
     "{", between(", ",apply(toList s,toString)), "}"
     )
toString Array := s -> concatenate ( "[", between(", ",toString \ toList s), "]" )
toString Sequence := s -> (
     if # s === 1 then concatenate("singleton ",toString s#0)
     else concatenate("(",between(",",toString \ s),")")
     )
toString Command  := f -> if Symbols#?f then string Symbols#f else "--Command--"
net Function := toString Function := f -> if Symbols#?f then string Symbols#f else "--Function--"
toExternalString Manipulator := toString Manipulator := f -> if Symbols#?f then string Symbols#f else "--Manipulator--"
toString Thing := string
-----------------------------------------------------------------------------
toExternalString String := format
toExternalString Net := x -> (
     s := concatenate( "stack(", between(",",apply(netRows x, format)), ")" );
     if height x === 1 then s
     else concatenate( "((", s, ")^", string(height x - 1), ")" )
     )
toExternalString MutableHashTable := s -> if s.?name and class s.name === String then s.name else concatenate (
     toExternalString class s,
     if parent s =!= Nothing then (" of ", toExternalString parent s),
     "{...}"
     )
toExternalString HashTable := s -> if s.?name and class s.name === String then s.name else concatenate (
     "new ", toExternalString class s,
     if parent s =!= Nothing then (" of ", toExternalString parent s),
     " from {",
     if # s > 0
     then demark(", ", apply(pairs s, (k,v) -> toExternalString k | " => " | toExternalString v) )
     else "",
     "}")
toExternalString MutableList := s -> concatenate("new ",toExternalString class s, " from {...}")
toExternalString BasicList := s -> concatenate(
     (if class s === List then "{" else ("new ", toExternalString class s," from {")),
     between(", ",apply(toList s,toExternalString)),
     "}" )
toExternalString Array := s -> concatenate ( "[", between(", ",toExternalString \ toList s), "]" )
toExternalString Sequence := s -> (
     if # s === 1 then concatenate("singleton ",toExternalString s#0)
     else concatenate("(",between(",",toExternalString \ s),")")
     )
toExternalString Thing := toString
-----------------------------------------------------------------------------
describe = method()
describe Thing := net
describe MutableHashTable := x -> (
     if x.?name then (
	  n := x.name;
	  remove(x, quote name);
	  d := net x;
	  x.name = n;
	  d)
     else net x
     )

net Manipulator := toString
net Thing := toString
-----------------------------------------------------------------------------
    operators := new MutableHashTable
    alphabet := new MutableHashTable
    scan( characters "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", c -> alphabet#c = true)
    scan( { quote or, quote do, quote else, quote then, quote of, quote shield,
	      quote from, quote and, quote not, quote if, quote try, 
	      quote new, quote while, quote quote, quote global, quote local,
	      quote timing, quote time
	      },
	 i -> operators#i = concatenate("quote ", toString i))
    scan(pairs symbolTable(), (n,s) -> (
	      if not alphabet#?(n#0) then (
		   operators#s = concatenate("quote ",n);
		   )
	      )
	 )
    alphabet = null
    operators#(quote " ") = ///quote " "///

-- toExternalString Symbol := s -> if operators#?s then operators#s else toString s

toExternalString Symbol := s -> (			    -- experimental
     if operators#?s then operators#s
     else if value s =!= s then concatenate("quote ",string s)
     else string s
     )

net Symbol := string
File << Symbol := (o,s) -> o << string s		    -- provisional
File << Thing  := (o,s) -> o << toString s		    -- provisional
-----------------------------------------------------------------------------
net Option := z -> net expression z

Net == Net := (x,y) -> x === y
Net == String := (n,s) -> (
     height n === 1 and depth n === 0 and width n === length s and first netRows n === s
     )
String == Net := (s,n) -> n == s

net String := identity
net RR := net Boolean := net File := net ZZ := net Handle := net Database := string
net Nothing := null -> ""

Net | Net := horizontalJoin
Net || Net := stack
String ^ ZZ := (s,i) -> raise(horizontalJoin s,i)
Net ^ ZZ := raise; erase quote raise
String ^ Sequence := (s,p) -> ((height,depth) -> (stack apply(height+depth,i->s))^(height-1))(p)

net Net := identity
---- this old routine draws a box around a net
--net Net := x -> ( 
--     s := concatenate("+", width x : "-", "+");
--     n := height x + depth x;
--     if n === 0 then (
--     	  (s || x || s) ^ (height x)
--	  )
--     else (
--     	  t := (stack (n : "|")) ^ (height x - 1);
--     	  (s || t | x | t || s) ^ (height x)
--	  )
--     )

comma := ", "

net Sequence := x -> horizontalJoin deepSplice (
     if #x === 0 then "()"
     else if #x === 1 then ("singleton ", net x#0)
     else ("(", toSequence between(comma,apply(x,net)), ")"))

net List := x -> horizontalJoin deepSplice (
     "{",
     toSequence between(comma,apply(x,net)),
     "}")
net Array := x -> horizontalJoin deepSplice (
     "[",
     toSequence between(comma,apply(x,net)),
     "]")
net BasicList := x -> horizontalJoin deepSplice (
      net class x, 
      "{",
      toSequence between(comma,apply(x,net)),
      "}")
net MutableList := x -> horizontalJoin ( net class x, "{...}" )
net HashTable := x -> (
     if x.?name then x.name
     else horizontalJoin flatten ( 
     	  net class x,
	  "{", 
	  -- the first line prints the parts vertically, second: horizontally
 	  stack sort apply(pairs x,(k,v) -> horizontalJoin(net k, " => ", net v)),
	  -- between(", ", apply(pairs x,(k,v) -> net k | "=>" | net v)), 
	  "}" 
     	  )
     )
net MutableHashTable := x -> if x.?name then x.name else horizontalJoin ( net class x, "{...}" )

tex Net := n -> concatenate(
     ///\vtop{///,
	  newline,
	  apply(netRows n, x -> (///\hbox{///, tex TT x, ///}///, newline)),
	  ///}///,
     newline
     )

erase quote string
