--		Copyright 2007 by Daniel R. Grayson

tab := new HashTable from {
     symbol ZZ => "<mi>\u2124</mi>",
     symbol QQ => "<mi>\u211a</mi>",
     symbol CC => "<mi>\u2102</mi>"
     }
mathML = method(Dispatch => Thing, TypicalValue => String)
mathML String := x -> concatenate("<mtext>",htmlLiteral x,"</mtext>")
mathML Nothing := texMath Nothing := tex Nothing := html Nothing := x -> ""
mathML Symbol := x -> if tab#?x then tab#x else concatenate("<mi>",toString x,"</mi>")
mathML InfiniteNumber := i -> if i === infinity then "<mrow><mi>&infin;</mi></mrow>" else "<mo>-</mo><mi>&infin;</mi>"
mathML Array := s -> concatenate ( "<mrow><mo>[</mo><mrow>", between("<mo>,</mo>",mathML \ toList s), "</mrow><mo>]</mo></mrow>" )
mathML Sequence := s -> concatenate ( "<mrow><mo>(</mo><mrow>", between("<mo>,</mo>",mathML \ toList s), "</mrow><mo>)</mo></mrow>" )
mathML List := s -> concatenate ( "<mrow><mo>{</mo><mrow>", between("<mo>,</mo>",mathML \ toList s), "</mrow><mo>}</mo></mrow>" )
mathML Holder := v -> mathML v#0
mathML Adjacent := x -> concatenate("<mrow>",mathML x#0,  mathML x#1, "</mrow>")
mathML Adjacent :=
mathML FunctionApplication := m -> (
     p := precedence m;
     fun := m#0;
     mfun := mathML fun;
     args := m#1;
     margs := mathML args;
     if precedence args >= p
     then if precedence fun > p
     then (
	  if class mfun === Net and mfun#?0 and width mfun > width mfun#0
	  then concatenate (mfun, margs)
	  else concatenate (mfun, " ", margs)
	  )
     else concatenate (bigParenthesize mfun, margs)
     else if precedence fun > p
     then concatenate (mfun, bigParenthesize margs)
     else concatenate (bigParenthesize mfun, bigParenthesize margs)
     )
mtable := x -> concatenate(
     "<mtable align=\"baseline1\">", newline,
     apply(x, row -> ( "<mtr>", apply(row, e -> ("<mtd>",e,"</mtd>",newline)), "</mtr>", newline ) ),
     "</mtable>", newline )
tableML := x -> mtable applyTable(x,mathML)
mathML MatrixExpression := x -> concatenate( "<mrow><mo>(</mo>", tableML x, "<mo>)</mo></mrow>", newline )
mathML Minus := v -> concatenate( "<mo>-</mo>", mathML v#0)
mathML Divide := x -> concatenate("<mfrac>", mathML x#0, mathML x#1, "</mfrac>")
mathML OneExpression := x -> "<mn>1</mn>"
mathML ZeroExpression := x -> "<mn>0</mn>"
mathML Sum := v -> (
     n := # v;
     if n === 0 then "<mn>0</mn>"
     else if n === 1 then mathML v#0
     else (
	  p := precedence v;
	  seps := newClass(MutableList, apply(n+1, i->"<mo>+</mo>"));
	  seps#0 = "";
	  seps#n = "";
	  v = apply(n, i -> (
		    if class v#i === Minus 
		    then (
			 seps#i = "<mo>-</mo>"; 
			 v#i#0)
		    else v#i));
	  concatenate (
	       "<mrow>", 
	       mingle(seps, 
	       	    apply(n, i -> 
		    	 if precedence v#i <= p 
		    	 then ("<mrow><mo>(</mo>", mathML v#i, "<mo>)</mo></mrow>")
		    	 else mathML v#i),
		    n:newline),
	       "</mrow>",newline)))
mathML Product := v -> (
     n := # v;
     if n === 0 then "<mn>1</mn>"
     else if n === 1 then mathML v#0
     else (
     	  p := precedence v;
	  seps := newClass(MutableList, (n+1) : "<mo>*</mo>");
	  if n>1 and isNumber v#0 and startsWithVariable v#1 then seps#1 = "<mo></mo>";
     	  boxes := apply(#v,
	       i -> (
		    term := v#i;
		    nterm := mathML term;
	       	    if precedence term <= p then (
			 seps#i = seps#(i+1) = "<mo></mo>";
			 nterm = ("<mrow><mo>(</mo>", nterm, "<mo>)</mo></mrow>");
			 );
		    if class term === Power
		    and not (term#1 === 1 or term#1 === ONE)
		    or class term === Subscript then (
			 seps#(i+1) = "<mo></mo>";
			 );
	       	    nterm));
     	  seps#0 = seps#n = "";
	  concatenate ("<mrow>", mingle (seps, boxes), "</mrow>")
	  )
     )
mathMLparen = s -> concatenate("<mrow><mo>(</mo>",s,"<mo>)</mo></mrow>")
mathML Boolean := i -> if i then "<mi>true</mi>" else "<mi>false</mi>"
mathML Subscript := v -> concatenate("<msub>",mathML v#0,mathML v#1,"</msub>")
mathML Superscript := 
mathML Power := v -> (
     if v#1 === 1 then mathML v#0
     else (
	  p := precedence v;
	  x := mathML v#0;
	  y := mathML v#1;
	  if precedence v#0 <  p then x = mathMLparen x;
	  concatenate("<msup>",x,y,"</msup>")))
mathML ZZ := i -> concatenate("<mn>",toString i, "</mn>")
mathML RR := i -> concatenate("<mn>",toString i, "</mn>")
mathML QQ := i -> concatenate( "<mfrac>",mathML numerator i, mathML denominator i, "</mfrac>" )
mathML Thing := x -> (
     -- maybe "expression" should not just put unknown things in a holder ...
     -- anyway, we have to break the loop somehow here
     if ReverseDictionary#?x then mathML return mathML ReverseDictionary#x;
     y := expression x;
     if instance(y,Holder) and y#0 === x then mathML toString x else mathML y)
mathML Expression := x -> error("mathML conversion for expression class ", toString class x, " not implemented yet")

mathML LITERAL := x -> concatenate x

doublerightarrow := "<mo>\u21d2</mo>"
mathML Option := s -> concatenate("<mrow>",mathML s#0, doublerightarrow, mathML s#1, "</mrow>")

-- mathML HashTable := s -> mtable applyPairs(s, (k,v) -> ())

leftarrow := "<mo>&larr;</mo>"
mathML ChainComplex := C -> (
     complete C;
     s := sort spots C;
     if #s === 0 then mathML "0"
     else mtable transpose between({leftarrow,"",""}, toList apply(s#0 .. s#-1,i -> {mathML C_i,"",mathML i})))

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/m2 "
-- End:
