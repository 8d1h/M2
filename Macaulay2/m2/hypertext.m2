--		Copyright 1993-2004 by Daniel R. Grayson

-----------------------------------------------------------------------------
-- sublists, might be worthy making public
-----------------------------------------------------------------------------
sublists := (x,f,g,h) -> (
     -- x is a list with elements i
     -- apply g to those i for which f i is true
     -- apply h to the sublists, possibly empty, including those at the beginning and end, of elements between the ones for which f i is true
     -- return the results in the same order
     p := positions(x, f);
     mingle(
	  apply( prepend(-1,p), append(p,#x), (i,j) -> h take(x,{i+1,j-1})),
	  apply( p, i -> g x#i)))

-----------------------------------------------------------------------------
-- html output
-----------------------------------------------------------------------------

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
texExtraLiteral := s -> demark(ENDLINE,
     apply(lines s, l -> apply(characters l, c -> texExtraLiteralTable#c))
     )
-----------------------------------------------------------------------------
-- the default case
defop := (joiner,op) -> x -> joiner apply(x,op)
info MarkUpList := defop(horizontalJoin,info)
net MarkUpList := defop(horizontalJoin,net)
html MarkUpList := defop(concatenate,html)
tex MarkUpList := defop(concatenate,tex)
texMath MarkUpList := defop(concatenate,texMath)
mathML MarkUpList := defop(concatenate,mathML)

info TITLE := net TITLE := x -> ""

Hop := (op,filler) -> x -> ( 
     r := horizontalJoin apply(x,op);
     if width r === 1 then r = horizontalJoin(r," ");
     r || concatenate( width r : filler ) )
net  HEADER1 := Hop(net,"*")
net  HEADER2 := Hop(net,"=")
net  HEADER3 := Hop(net,"-")
info HEADER1 := Hop(info,"*")
info HEADER2 := Hop(info,"=")
info HEADER3 := Hop(info,"-")

html String := htmlLiteral
mathML String := x -> concatenate("<mtext>",htmlLiteral x,"</mtext>")
tex String := texLiteral
texMath String := s -> (
     if #s === 1 then s
     else concatenate("\\text{", texLiteral s, "}")
     )
info String := identity

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

mathML Nothing := texMath Nothing := tex Nothing := html Nothing := x -> ""

specials := new HashTable from {
     symbol ii => "&ii;"
     }

mathML Symbol := x -> concatenate("<mi>",if specials#?x then specials#x else toString x,"</mi>")

tex Function := x -> "--Function--"

tex Boolean := tex Symbol := 
html Symbol := html Boolean := toString

texMath Function := texMath Boolean := x -> "\\text{" | tex x | "}"

vert := (op,post) -> x -> net new ParagraphList from post select(
     sublists(
	  toList x,
	  i -> instance(i,MarkUpListParagraph),
	  op,
	  i -> horizontalJoin(op \ i)),
     n -> width n > 0)
net SEQ := net PARA := net Hypertext := vert(net,x -> between("",x)) -- doublespacing
info SEQ := info PARA := info Hypertext := vert(info,x -> between("",x))
net SEQ1 := vert(net,identity)				    -- singlespacing
info SEQ1 := vert(info,identity)

html BR := x -> ///
<BR>
///
tex  BR := x -> ///
\hfil\break
///

html NOINDENT := x -> ""
tex  NOINDENT := x -> ///
\noindent\ignorespaces
///

html BIG := x -> concatenate( 				    -- not right any more -- no size option to font -- no font tag -- use css
     "<b>", apply(x, html), "</b>"
     )

html HEAD := x -> concatenate(newline, 
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
tex  HR := x -> ///
\hfill\break
\hbox to\hsize{\leaders\hrule\hfill}
///

html Hypertext := x -> concatenate("<P>",apply(x,html))

html PARA := x -> (
     if #x === 0 then "\n<P>\n"
     else concatenate("\n<P>", apply(x,html),"<P>\n")
     )

tex PARA := x -> concatenate(///
\par
///,
     apply(x,tex))

html ExampleTABLE := x -> concatenate(
     newline,
     "<p><table class=\"examples\" cellspacing='0' cellpadding='12' border='4' width='100%'>",
     newline,
     apply(x, 
	  item -> (
	       "  <tr>", newline,
	       "    <td>", html item#1, "</td>", newline,
	       "  </tr>", newline
	       )
	  ),
     "</table></p><p>"
     )			 
html EXAMPLE := x -> concatenate html ExampleTABLE apply(#x, i -> {x#i, CODE concatenate("i",toString (i+1)," : ",x#i)})

truncateString := s -> if width s <= printWidth then s else concatenate(substring(s,0,printWidth-1),"$")
truncateNet := n -> if width n <= printWidth then n else stack(apply(unstack n,truncateString))

info ExampleTABLE := net ExampleTABLE := x -> (
     p := "    ";
     printWidth = printWidth - #p -2;
     r := p | boxList apply(toList x, y -> truncateNet net y#1);
     printWidth = printWidth + #p + 2;
     r)
info EXAMPLE := net EXAMPLE := x -> net ExampleTABLE apply(#x, i -> {x#i, CODE concatenate("i",toString (i+1)," : ",x#i)})

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

info TABLE := x -> boxTable applyTable(toList x,info)
net TABLE := x -> boxTable applyTable(toList x,net)
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


info PRE := net PRE := x -> net concatenate x
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

info TT := net TT := x -> horizontalJoin splice ("'", net  \ toSequence x, "'")

htmlDefaults = new MutableHashTable from {
     -- "BODY" => "bgcolor='#e4e4ff'"
     "BODY" => ""
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
html SEQ := x -> concatenate(apply(toList x, html))

-- these seem questionable:
tex Sequence := tex List := tex Array := x -> concatenate("$",texMath x,"$")
html Sequence := x -> concatenate("(", between(",", apply(x,html)), ")")
html List := x -> concatenate("{", between(",", apply(x,html)), "}")

info CODE := net CODE := x -> stack lines concatenate x
html CODE   := x -> concatenate( 
     "<tt>", 
     demark( ("<br>",newline), apply(lines concatenate x, htmlExtraLiteral) ),
     "</tt>"
     )

html ANCHOR := x -> (
     "\n<a name=\"" | x#0 | "\">" | html x#-1 | "</a>"
     )
info ANCHOR := net ANCHOR := x -> net last x
tex ANCHOR := x -> (
     concatenate(
	  ///\special{html:<A name="///, texLiteral x#0, ///">}///,
	  tex x#-1,
	  ///\special{html:</A>}///
	  )
     )

html TEX := x -> x#0

commentize := s -> if s =!= null then concatenate(" -- ",s)

addHeadlines := x -> apply(x, i -> if instance(i,TO) then SEQ{ i, commentize headline i#0 } else i)

addHeadlines1 := x -> apply(x, i -> if instance(i,TO) then SEQ{ "help ", i, commentize headline i#0 } else i)

info HR := net HR := x -> "-----------------------------------------------------------------------------"

ULop := op -> x -> (
     s := "  * ";
     printWidth = printWidth - #s;
     r := stack apply(toList x, i -> s | op i);
     printWidth = printWidth + #s;
     r)
info UL := info OL := info DL := ULop info
net UL := net OL := net DL := ULop net

* String := x -> help x					    -- so the user can cut paste the menu line to get help!

NLop := op -> x -> stack apply(#x, i -> toString (i+1) | " : " | wrap(printWidth - 10, op x#i))
net NL := NLop net
info NL := NLop info

tex UL := x -> concatenate(
     ///\begin{itemize}///, newline,
     apply(addHeadlines x, x -> if x =!= null then ( ///\item ///, tex x, newline)),
     ///\end{itemize}///, newline)

html UL := x -> concatenate (
     newline,
     "<ul>", newline,
     apply(addHeadlines x, s -> if s =!= null then ("<li>", html s, "</li>", newline)),
     "</ul>", newline)

html OL   := x -> concatenate( "<ol>", newline, apply(x,s -> ("<li>", html s, "</li>", newline)), "</ol>", newline )
html NL   := x -> concatenate( "<nl>", newline, apply(x,s -> ("<li>", html s, "</li>", newline)), "</nl>", newline)
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

texMath SUP := x -> concatenate( "^{", apply(x, tex), "}" )
texMath SUB := x -> concatenate( "_{", apply(x, tex), "}" )

opSU := (op,n) -> x -> (horizontalJoin apply(x, op))^n
net SUP := opSU(net,1)
info SUP := opSU(info,1)
net SUB := opSU(net,-1)
info SUB := opSU(info,-1)

tex TO := x -> (
     tag := x#0;
     tex SEQ {
     	  TT DocumentTag.FormattedKey tag,
     	  " [", LITERAL { 
	       "\ref{", 
	       -- need something here
	       "}" },
	  "]"
	  }
     )

net TO  := x -> concatenate( "\"",     DocumentTag.FormattedKey x#0, "\"", if x#?1 then x#1)
net TO2 := x -> x#1

-- node names in info files are delimited by commas and parentheses somehow...
infoLiteral := new MutableHashTable
scan(characters ascii(0 .. 255), c -> infoLiteral#c = c)
infoLiteral#"(" = "_lp"
infoLiteral#"_" = "_us"
infoLiteral#")" = "_rp"
infoLiteral#"," = "_cm"
infoLiteral#"*" = "_st"
infoTagConvert = memoize(n -> if n === " " then "_sp" else concatenate apply(characters n, c -> infoLiteral#c));

info TO := x -> (
     fkey := DocumentTag.FormattedKey x#0;
     concatenate(fkey, if x#?1 then x#1, " (*Note ", infoTagConvert fkey, "::)"))
info TO2:= x -> (
     fkey := DocumentTag.FormattedKey x#0;
     concatenate( x#1, " (*Note ", infoTagConvert fkey, "::)"))

info IMG := net IMG := tex IMG  := x -> ""
info HREF := net HREF := x -> net last x

toh := op -> x -> op SEQ{ new TO from x, commentize headline x#0 }
net TOH :=  toh net
html TOH :=  toh html
tex TOH :=  toh tex
info TOH :=  toh info

tex LITERAL := html LITERAL := x -> concatenate x
html EmptyMarkUpType := html MarkUpType := X -> html X{}
html ITALIC := t -> concatenate("<I>", apply(t,html), "</I>")
html UNDERLINE := t -> concatenate("<U>", apply(t,html), "</U>")
html BOLD := t -> concatenate("<B>", apply(t,html), "</B>")
html TEX := x -> x#0	    -- should do something else!

tex BASE := net BASE := x -> ""

html Option := x -> toString x

info BIG := net BIG := x -> net x#0

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

redoSECTION := x -> SEQ { HEADER2 take(toList x,1), SEQ drop(toList x,1) }
html SECTION := html @@ redoSECTION
net SECTION := net @@ redoSECTION
info SECTION := info @@ redoSECTION
tex SECTION := tex @@ redoSECTION

redoTOC := x -> (
     x = toList x;
     if not all(apply(x,class), i -> i === SECTION)
     then error "expected a list of SECTIONs";
     title := i -> x#i#0;
     tag := i -> "sec:" | toString i;
     SEQ {
	  SECTION {
	       "Sections:",
	       UL for i from 0 to #x-1 list HREF { "#" | tag i, title i }
	       },
	  SEQ for i from 0 to #x-1 list SEQ { newline, ANCHOR { tag i, ""} , x#i } } )
html TOC := html @@ redoTOC
net TOC := net @@ redoTOC
info TOC := info @@ redoTOC
tex TOC := tex @@ redoTOC

redoMENU := r -> SEQ prepend(
     PARA BOLD "Menu",
     sublists(toList r, 
	  x -> not ( class x === TO ),
	  x -> PARA{x},
	  v -> UL apply(v, i -> TOH i#0 )))
net MENU := x -> net redoMENU x
html MENU := x -> html redoMENU x

info MENU := r -> stack join(
     {"* Menu:",""},
     sublists(toList r, 
	  x -> not ( class x === TO ),
	  x -> stack("",x),			    -- we can assume x is a String
	  v -> stack apply(v, i -> (
		    t := concatenate("* ", DocumentTag.FormattedKey i#0,"::");
		    h := headline i#0;
		    if h === null then t else concatenate(t,30-#t:" ","  ",h)))))

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/m2 "
-- End:
