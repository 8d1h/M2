--		Copyright 1996 by Daniel R. Grayson

toString = method(SingleArgumentDispatch => true)
toString String := identity
toString Thing := name

document { quote toString,
     TT "toString x", " -- converts ", TT "x", " to a string using ", TT "name", ", unless
     ", TT "x", " is already a string, in which case ", TT "x", " is returned."
     }

net Option := z -> net expression z

Net | Net := horizontalJoin
Net || Net := verticalJoin
String ^ ZZ := (s,i) -> raise(horizontalJoin s,i)
Net ^ ZZ := raise; erase quote raise
String ^ Sequence := (s,p) -> ((height,depth) -> (verticalJoin apply(height+depth,i->s))^(height-1))(p)

net Net := identity
---- this old routine draws a box around a net
--net Net := x -> ( 
--     s := concatenate("+", width x : "-", "+");
--     n := height x + depth x;
--     if n === 0 then (
--     	  (s || x || s) ^ (height x)
--	  )
--     else (
--     	  t := (verticalJoin (n : "|")) ^ (height x - 1);
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
     if x.?name 
     then string x.name
     else horizontalJoin flatten ( 
     	  net class x,
	  "{", 
	  -- the first line prints the parts vertically, second: horizontally
 	  verticalJoin sort apply(pairs x,(k,v) -> horizontalJoin(net k, " => ", net v)),
	  -- between(", ", apply(pairs x,(k,v) -> net k | "=>" | net v)), 
	  "}" 
     	  )
     )
net MutableHashTable := x -> (
     if x.?name 
     then string x.name
     else horizontalJoin ( net class x, "{...}" )
     )

tex Net := n -> concatenate(
     ///\vtop{///,
	  newline,
	  apply(netRows n, x -> (///\hbox{///, tex TT x, ///}///, newline)),
	  ///}///,
     newline
     )
     