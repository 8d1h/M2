--		Copyright 1994 by Daniel R. Grayson
-- this file is loaded early so put the documentation in doc.m2

-----------------------------------------------------------------------------
htmlLiteralTable := new MutableHashTable
scan(characters ascii(0 .. 255), c -> htmlLiteralTable#c = c)
htmlLiteralTable#"\"" = "&quot;"
htmlLiteralTable#"<" = "&lt;"
htmlLiteralTable#"&" = "&amp;"
htmlLiteralTable#">" = "&gt;"
htmlLiteral := s -> concatenate apply(characters s, c -> htmlLiteralTable#c)

htmlExtraLiteralTable := new MutableHashTable
scan(characters ascii(0 .. 255), c -> htmlExtraLiteralTable#c = c)
htmlExtraLiteralTable#"\"" = "&quot;"
htmlExtraLiteralTable#" " = "&nbsp;"
htmlExtraLiteralTable#"&" = "&amp;"
htmlExtraLiteralTable#"<" = "&lt;"
htmlExtraLiteralTable#">" = "&gt;"
htmlExtraLiteral := s -> concatenate apply(characters s, c -> htmlExtraLiteralTable#c)
-----------------------------------------------------------------------------
ttLiteralTable := new MutableHashTable
scan(0 .. 255, 
     c -> ttLiteralTable#(ascii{c}) = concatenate(///{\char ///, string c, "}"))
scan(characters ascii(32 .. 126), c -> ttLiteralTable#c = c)
scan(characters "\\{}$&#^_%~", 
     c -> ttLiteralTable#c = concatenate("{\\char ", string (ascii c)#0, "}"))
scan(characters "$%&#_", c -> ttLiteralTable#c = concatenate("\\",c))

cmrLiteralTable := copy ttLiteralTable

ttBreak :=
///
\leavevmode\hss\endgraf
///

(
if #newline === 1 
then ttLiteralTable#newline = ttBreak 
else if #newline === 2 then (
     ttLiteralTable#(newline#0) = "";
     ttLiteralTable#(newline#1) = ttBreak;
     )
)

ttLiteralTable#" " = ///\ ///
ttLiteralTable#"\t" = "\t"
ttLiteralTable#"`" = "{`}"     -- break ligatures ?` and !` in font \tt
                               -- see page 381 of TeX Book
ttLiteral := s -> concatenate apply(characters s, c -> ttLiteralTable#c)
-----------------------------------------------------------------------------
cmrLiteralTable#"\n" = "\n"
cmrLiteralTable#"\r" = "\r"
cmrLiteralTable#"\t" = "\t"
cmrLiteralTable#"\\" = "{\\tt \\char`\\\\}"
cmrLiteralTable# "<" = "{\\tt \\char`\\<}"
cmrLiteralTable# ">" = "{\\tt \\char`\\>}"
cmrLiteralTable# "|" = "{\\tt \\char`\\|}"
cmrLiteralTable# "{" = "{\\tt \\char`\\{}"
cmrLiteralTable# "}" = "{\\tt \\char`\\}}"
cmrLiteral := s -> concatenate apply(characters s, c -> cmrLiteralTable#c)
-----------------------------------------------------------------------------

html = x -> (
     -- this file is loaded before methods.m2
     f := lookup(html,class x);
     if f === null then error (
	  "no method for 'html' applied to item of class ", name class x
	  );
     f x)

tex = x -> (
     -- this file is loaded before methods.m2
     f := lookup(tex,class x);
     if f === null then error (
	  "no method for 'tex' applied to item of class ", name class x
	  );
     f x)

text = x -> (
     -- this file is loaded before methods.m2
     f := lookup(text,class x);
     if f === null then error (
	  "no method for 'text' applied to item of class ", name class x
	  );
     f x)

html String := htmlLiteral
tex String := cmrLiteral
text String := identity

html List := x -> concatenate("{", between(",", apply(x,html)), "}")
text List := x -> concatenate("{", between(",", apply(x,text)), "}")
tex  List := x -> concatenate("\\{", between(",", apply(x,tex)), "\\}")

text Sequence := x -> concatenate("(", between(",", apply(x,text)), ")")
html Sequence := x -> concatenate("(", between(",", apply(x,html)), ")")
tex  Sequence := x -> concatenate("(", between(",", apply(x,tex)), ")")

tex Nothing := html Nothing := text Nothing := x -> ""

tex Boolean := tex Symbol :=
text Symbol := text Boolean := 
html Symbol := html Boolean := string

linkFilenameTable := new MutableHashTable
linkFilenameCounter := 0
linkFilenameKeys = () -> keys linkFilenameTable
linkFilename = s -> (
     if linkFilenameTable#?s 
     then linkFilenameTable#s
     else (
	  n := string linkFilenameCounter;
	  linkFilenameTable#s = n;
	  linkFilenameCounter = linkFilenameCounter + 1;
	  n)
     ) | ".html"

HtmlList = new Type of BasicList
html HtmlList := x -> concatenate apply(x,html)
text HtmlList := x -> concatenate apply(x,text)
tex HtmlList := x -> concatenate apply(x,tex)

lookupi := x -> (
     r := lookup x;
     if r === null then error "encountered null or missing value";
     r)

ListHead = new Type of Type
ListHead List := (h,y) -> new h from y
ListHead Thing := (h,y) -> new h from {y}

GlobalAssignHook ListHead := globalAssignFunction

newListHead := (x) -> (
     on := "<" | x | ">";
     off := "</" | x | ">";
     T := new ListHead of HtmlList;
     html T := t -> concatenate(on, apply(t,html), off);
     T )

BrHead = newListHead "BrHead"
BrHead.name = "BrHead"
html BrHead := x -> newline | "<BR>" | newline
text BrHead := x -> newline
tex  BrHead := x -> ///
\hfil\break
///
name BrHead := x -> "BR"
BR          = BrHead {}

NoindentHead = newListHead "NoindentHead"
NoindentHead.name = "NoindentHead"
html NoindentHead := x -> ""
tex  NoindentHead := x -> ///
\noindent\ignorespaces
///
text NoindentHead := x -> ""
name NoindentHead := x -> "NOINDENT"
NOINDENT          = NoindentHead {}

HrHead = newListHead "HrHead"
HrHead.name = "HrHead"
html HrHead := x -> newline | "<HR>" | newline

text HrHead := x -> concatenate(
     newline,
     "-----------------------------------------------------------------------------",
     newline)

tex  HrHead := x -> ///
\hfill\break
\line{\leaders\hrule\hfill}
///
name HrHead := x -> "HR"
HR          = HrHead {}

ParaHead = newListHead "ParaHead"
ParaHead.name = "ParaHead"
html ParaHead := x -> newline | "<P>" | newline
text ParaHead := x -> concatenate(newline,newline)
tex  ParaHead := x -> concatenate(newline,newline)
name ParaHead := x -> "PARA"
PARA          = ParaHead {}

EXAMPLE    = newListHead "EXAMPLE"
text EXAMPLE := x -> concatenate apply(toList x,i -> text PRE i)
html EXAMPLE := x -> concatenate html TABLE apply(toList x, x -> {PRE x})

TABLE      = newListHead "TABLE"
text TABLE := x -> (
     -- not good yet
     concatenate apply(toList x, row -> (row/text, newline))
     )
tex TABLE := x -> concatenate applyTable(x,tex)
html TABLE := x -> concatenate(
     newline,
     "<P>",
     "<CENTER>",
     "<TABLE cellspacing='0' cellpadding='12' border='4' bgcolor='#80ffff' width='100%'>",
     newline,
     apply(x, row -> ( 
	       "  <TR>",
	       newline,
	       apply(row, item -> ("    <TD NOWRAP>", html item, "</TD>",newline)),
	       "  </TR>",
	       newline)),
     "</TABLE>",
     "</CENTER>",
     "</P>"
     )			 

PRE        = newListHead "PRE"
text PRE   := x -> concatenate(
     newline,
     demark(newline,
	  apply(lines concatenate x, s -> concatenate("     ",s))),
     newline
     )
html PRE   := x -> concatenate( 
     "<PRE>", 
     html demark(newline,
	  apply(lines concatenate x, s -> concatenate("     ",s))),
     "</PRE>"
     )
shorten := s -> (
     while #s > 0 and s#-1 == "" do s = drop(s,-1);
     while #s > 0 and s#0 == "" do s = drop(s,1);
     s)
tex PRE := x -> concatenate (
     ///\par
\vskip 4 pt
{%
     \tt
     \baselineskip=9.5pt
///,
     between(newline, 
	  shorten lines concatenate x
	  / (line ->
	       if #line <= 81 then line
	       else concatenate(substring(line,0,71), " ..."))
	  / ttLiteral
	  / (line -> if line === "" then ///\penalty-500/// else line)
	  / (line -> (line,///\leavevmode\hss\endgraf///))
	  ),
     ///
     }
\par
\noindent
///
     )

TITLE      = newListHead "TITLE"
HEAD       = newListHead "HEAD"
BODY       = newListHead "BODY"
html BODY := x -> concatenate(
     "<BODY BACKGROUND='recbg.jpg'>",
     -- "<BODY bgcolor='#e4e4ff'>",
     newline,
     toList x / html,
     newline,
     "</BODY>",
     newline
     )

IMG	   = newListHead "IMG"
html IMG  := x -> "<IMG src=\"" | x#0 | "\">"
text IMG  := x -> ""
tex  IMG  := x -> ""

HTML       = newListHead "HTML"
H1         = newListHead "H1"
H2         = newListHead "H2"
H3         = newListHead "H3"
H4         = newListHead "H4"
H5         = newListHead "H5"
H6         = newListHead "H6"
LISTING    = newListHead "LISTING"
html LISTING := t -> "<LISTING>" | concatenate toSequence t | "</LISTING>";
XMP        = newListHead "XMP"
BLOCKQUOTE = newListHead "BLOCKQUOTE"
VAR        = newListHead "VAR"
DFN        = newListHead "DFN"
STRONG     = newListHead "STRONG"
SAMP       = newListHead "SAMP"
KBD        = newListHead "KBD"

ITALIC     = newListHead "I"; ITALIC.name = "ITALIC"
tex ITALIC := x -> concatenate("{\\sl ",apply(x,tex),"}")
html ITALIC := x -> concatenate("<I>",apply(x,html),"</I>")

UNDERLINE  = newListHead "U"; UNDERLINE.name = "UNDERLINE"

TEX	   = newListHead "TEX"
tex TEX   := identity

SEQ	   = newListHead "SEQ"
tex SEQ   := x -> concatenate(apply(x, tex))
text SEQ   := x -> concatenate(apply(x, text))
html SEQ   := x -> concatenate(apply(x, html))

TT         = newListHead "TT"
tex TT := x -> concatenate(///{\tt {}///, ttLiteral x#0, "}")
text TT := x -> concatenate("'", x#0, "'")

EM         = newListHead "EM"
CITE       = newListHead "CITE"
BOLD       = newListHead "B"; BOLD.name = "BOLD"

CODE       = newListHead "CODE"
html CODE   := x -> concatenate( 
     "<CODE>", 
     demark( ("<BR>",newline), apply(lines concatenate x, htmlExtraLiteral) ),
     "</CODE>"
     )

hypertex = true

HREF       = newListHead "HREF"
html HREF := x -> (
     "<A HREF=\"" | x#0 | "\">" | html x#-1 | "</A>"
     )
text HREF := x -> "\"" | x#-1 | "\""
tex HREF := x -> (
     if hypertex 
     then concatenate(
	  ///\special{html:<A href="///, ttLiteral x#0, ///">}///,
	  tex x#-1,
	  ///\special{html:</A>}///
	  )
     else (
	  if #x == 2
	  then concatenate(tex x#1, " (the URL is ", tex TT x#0, ")")
	  else tex TT x#0
	  )
     )

SHIELD     = newListHead "SHIELD"
html SHIELD := x -> concatenate apply(x,html)
text SHIELD := x -> concatenate apply(x,text)

MENU       = newListHead "MENU"
html MENU := x -> concatenate (
     "<MENU>", newline,
     apply(x, s -> if s =!= null then ("<LI>", html s, newline)),
     "</MENU>", newline, 
     "<P>", newline)

text MENU := x -> concatenate(
     newline,
     apply(x, s -> if s =!= null then ("    ", text s, newline))
     )

tex MENU := x -> concatenate(
     ///
\begingroup\parindent=40pt
///,
     apply(x, x -> if x =!= null then ( ///\item {$\bullet$}///, tex x, newline)),
     "\\endgroup", newline, newline)

UL         = newListHead "UL"
html UL   := x -> concatenate(
     "<UL>", newline,
     apply(x, s -> ("<LI>", html s, newline)),
     "</UL>", newline, 
     "<P>", newline)

text UL   := x -> concatenate(
     newline,
     apply(x, s -> ("    ", text s, newline)))

OL         = newListHead "OL"
html OL   := x -> concatenate(
     "<OL>", newline,
     apply(x,s -> ("<LI>", html s, newline)),
     "</OL>", newline, 
     "<P>", newline
     )
text OL   := x -> concatenate(
     newline,
     apply(x,s -> ("    ", text s, newline)))

NL         = newListHead "NL"
html NL   := x -> concatenate(
     "<NL>", newline,
     apply(x, s -> ("<LI>", html s, newline)),
     "</NL>", newline, 
     "<P>", newline)
text NL   := x -> concatenate(
     newline,
     apply(x,s -> ("    ",text s, newline)))

DL 	   = newListHead "DL"
html DL   := x -> (
     "<DL>" 
     | concatenate apply(x, p -> (
	       if class p === List or class p === Sequence then (
		    if # p === 2 then "<DT>" | html p#0 | "<DD>" | html p#1
		    else if # p === 1 then "<DT>" | html p#0
		    else error "expected a list of length 1 or 2"
		    )
	       else "<DT>" | html p
	       ))
     | "</DL>")	  
text DL   := x -> concatenate(
     newline, 
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
	       else ("    ", 
		    text p#0, 
		    newline, 
		    newline)
	       )),
     newline,
     newline)

TO         = newListHead "TO"
ff := {"\"","\""}

text TO   := x -> concatenate ( 
     "'", formatDocumentTag x#0, "'",
     drop(toList x, 1)
     )

html TO   := x -> concatenate (
     "<A HREF=\"", linkFilename getDocumentationTag x#0, "\">", html formatDocumentTag x#0, "</A>", 
     drop(toList x,1)
     )

tex TO := x -> tex TT formatDocumentTag x#0

html Function := x -> name x

