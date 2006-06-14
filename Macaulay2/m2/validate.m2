--		Copyright 2006 by Daniel R. Grayson

noqname := p -> (
     if instance(p,IntermediateMarkUpType)
     then stderr << "--warning: " << format toString p << " is an intermediate mark-up type with no qname" << endl
     else stderr << "--warning: " << format toString p << " is a type with no qname" << endl;
     )

validate2 = method()					    -- check extra requirements, such as having at least one element, and the order of the elements
validate2 MarkUpList := x -> null
validate2 HTML := x -> (
     if not x#?0 or not class x#0 === HEAD then stderr << "--warning: first element of HTML must be HEAD" << endl;
     if not x#?1 or not class x#1 === BODY then stderr << "--warning: second element of HTML must be BODY" << endl;
     if #x != 2 then stderr << "--warning: HTML should have 2 elements" << endl);
validate2 HEAD := x -> (
     c := tally (class \ toList x);
     if c_TITLE == 0 then stderr << "--warning: HEAD should have a TITLE element" << endl;
     if c_TITLE > 1 then stderr << "--warning: HEAD should have at most one TITLE element" << endl;
     if c_BASE > 1 then stderr << "--warning: HEAD should have at most one BASE element" << endl;
     )
validate2 TR := 
validate2 UL := 
validate2 BLOCKQUOTE := x -> if #x === 0 then stderr << "--warning: " << class x << " should contain at least one element" << endl
validate2 LATER := x -> validate2 x#0()

validate = method()
validate String := x -> (
     if match("<",x) then stderr << "--warning: string contains tag start character '<' : \"" << x << "\"" << endl;
     )

validate Option :=					    -- could check each part is a string!
validate TO :=
validate TOH :=
validate TO2 := x -> scan(drop(x,1),validate)
validate COMMENT := x -> (
     if match("--",concatenate x) then stderr << "--warning: encountered \"--\" within COMMENT" << endl;
     if match("-$",concatenate x) then stderr << "--warning: COMMENT ends with \"-\"" << endl;
     )
validate CDATA := x -> (
     if match("]]>",concatenate x) then stderr << "--warning: encountered \"]]>\" within CDATA" << endl;
     )
validate MarkUpList := x -> (
     p := class x;
     if p.?qname then (
	  n := p.qname;
	  if validContent#?n then validate(p,validContent#n,x)
	  else stderr << "--internal error: valid content for qname " << format n << " not recorded yet" << endl;
	  scan(x,validate))
     else noqname p;
     validate2 x;
     )
chk := (valid,p,c) -> (
     if not c.?qname then noqname c
     else if not valid#?(c.qname)
     then stderr << "--warning: element of type " << format toString p << " can't contain an element of type " << format toString c << endl
     )
validate(Type, Set, BasicList) := (p,valid,x) -> ( scan(x, e -> chk(valid,p,class e)); null )
validate(MarkUpTypeWithOptions, Set, BasicList) := (p,valid,x) -> ( scan(x, e -> if class e =!= Option then chk(valid,p,class e)); null )

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/m2 "
-- End:
