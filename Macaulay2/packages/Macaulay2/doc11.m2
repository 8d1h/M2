--		Copyright 1993-2002 by Daniel R. Grayson

-- html.m2 documentation
-- Bart Snapp edited nearly all of these entries.
document {
     Key => MarkUpList, 
     Headline => "the class of mark-up lists used with hypertext",
     PARA,
     "Intended for internal use only."
     }

document {
     Key => MarkUpType,
     Headline => "the class of mark-up types used with hypertext", 
     PARA,
     "Intended for internal use only.",
     SeeAlso => "EmptyMarkUpType"
     }

document {
     Key => EmptyMarkUpType,
     Headline => "the class of empty mark-up types used with hypertext"
     }

--document {
--     Key => PARA,
--     Headline => "paragraph separator",
--	Usage => "PARA x",
--     TT "PARA x", " makes a ", TO "hypertext", " double-spaced paragraph break."
--     }

document {
     Key => PARA1,
     Headline => "a single-spaced paragraph separator",
	Usage => "PARA1 x",
     TT "PARA1 x", " makes a ", TO "hypertext", " single-spaced paragraph break. This is mostly for the documentation formated in info mode.",
	SeeAlso => "PARA"
     }





document {
     Key => BR,
     Headline => "line break",
	Usage => "BR",
     TT "BR{}", " is a ", TO "hypertext", " line break."
     }

document {
     Key => HR,
     Headline => "horizontal rule",
	Usage => "HR",
     TT "HR{}", " a ", TO "hypertext", " horizontal rule."
     }

document {
     Key => html,
     Headline => "convert hypertext to html format",
	Usage => "html x",
	Inputs => {"x" => {}},
	Outputs => {String => {}},
     TT "html x", " converts ", TT "x", " from ", TO "hypertext", " to html format",
     PARA,
     "The return value is a string which is suitable for use in an
     html file, readable by a world wide web client such as Netscape.",
     SeeAlso => "mathML"
     }

document {
     Key => PRE,
     Headline => "preformatted text",
	Usage => "PRE x",
	Inputs => {"x" => {}},
	Outputs => {PRE => {}},
     TT "PRE x", " encloses ", TT "x", " in a hypertext PRE item.",
     PARA,
     "The argument ", TT "x", " should be a string, possibly containing newlines.",
     "Here is an example.",
     PRE "
   1234   2345    4567    5678
     34    345    3455       7
",
	"If one wishes to use quotation marks in the preformatted text, then ", TO "///", " should be used instead of quotation marks as delimiters.",
     SeeAlso => "hypertext"
     }

document {
     Key => TITLE,
     Headline => "hypertext title",
	Usage => "TITLE x",
	Inputs => {"x" => {}},
	Outputs => {TITLE => {}},
     TT "TITLE x", " encloses ", TT "x", " in a hypertext TITLE item.",
     PARA,
     "The argument ", TT "x", " should be a string, or a list or sequence of
     strings or hypertext items.",
     PARA,
     SeeAlso => "hypertext"
     }

document {
     Key => HEAD,
     Headline => "hypertext HEAD item",
	Usage => "HEAD x",
	Inputs => {"x" => {}},
	Outputs => {HEAD => {}},
     TT "HEAD x", " encloses ", TT "x", " in a hypertext HEAD item.",
     PARA,
     "The argument ", TT "x", " should be a string, or a list or sequence of
     strings or hypertext items.",
     PARA,
     SeeAlso => "hypertext"
     }

document {
     Key => BODY,
     Headline => "hypertext BODY item",
	Usage => "BODY x",
	Inputs => {"x" => {}},
	Outputs => {BODY => {}},
     TT "BODY x", " encloses ", TT "x", " in a hypertext BODY item.",
     PARA,
     "The argument ", TT "x", " should be a string, or a list or sequence of
     strings or hypertext items.",
     PARA,
     SeeAlso => "hypertext"
     }

document {
     Key => IMG,
     Headline => "hypertext IMG item",
	Usage => "IMG{x,y}",
	Inputs => {"x" => {}, "y" => {}},
	Outputs => {IMG => {}},
     TT "IMG{x,y}", " encloses ", TT "x,y", " in a hypertext IMG item.",
     PARA,
     "The argument ", TT "x", " should be a string containing the URL of the image, and
     ", TT "y", " should be a suitable string for the ALT attribute.",
     PARA,
     SeeAlso => "hypertext"
     }

document {
     Key => SEQ,
     Headline => "hypertext sequence",
	Usage => "SEQ x",
	Inputs => {"x" => {}},
	Outputs => {SEQ => {}},
     TT "SEQ x", " encloses ", TT "x", " in a hypertext SEQ item.",
     PARA,
     "The argument ", TT "x", " should be a string, or a list or sequence of
     strings or hypertext items.  The result is that the entries in the
     list or sequence are displayed sequentially.",
     PARA,
     SeeAlso => "hypertext"
     }

document {
     Key => HTML,
     Headline => "hypertext item",
     Usage => "HTML x",
	Function => html,
	Inputs => {"x" => {}},
	Outputs => {HTML =>{}},
	TT "HTML x", " -- encloses ", TT "x", " in a hypertext HTML item.",
     PARA,
     "The argument ", TT "x", " should be a string, or a list or sequence of
     strings or hypertext items. Here is an example of the command ", TO "html", " being applied to ", TT "HTML x", ".",
     EXAMPLE {
		"html HTML x"
		},
	"This is invisible in non-html versions of the documentation",
     SeeAlso => "hypertext"
     }

document {
     Key => HEADER1,
     Headline => "hypertext HEADER1 item",
	Usage => "HEADER1 x",
	Inputs => {"x" => {}},
	Outputs => {HEADER1 => {}},
     TT "HEADER1 x", " encloses ", TT "x", " in a hypertext HEADER1 header item.",
     PARA,
     "The argument ", TT "x", " should be a string, or a list or sequence of
     strings or hypertext items.",
     PARA,
     "Here is an example.  The code ",
     PRE "HEADER1 \"Interesting thing\", \"Here is an interesting thing.\"",
     " produces ",
     HEADER1 "Interesting thing", "Here is an interesting thing.",
     PARA,
     SeeAlso => "hypertext"
     }

document {
     Key => HEADER2,
     Headline => "hypertext HEADER2 item",
	Usage => "HEADER2 x",
	Inputs => {"x" => {}},
	Outputs => {HEADER2 => {}},
     TT "HEADER2 x", " encloses ", TT "x", " in a hypertext HEADER2 header item.",
     PARA,
     "The argument ", TT "x", " should be a string, or a list or sequence of
     strings or hypertext items.",
     PARA,
     "Here is an example.  The code ",
     PRE "HEADER2 \"Interesting thing\", \"Here is an interesting thing.\"",
     " produces ",
     HEADER2 "Interesting thing", "Here is an interesting thing.",
     PARA,
     SeeAlso => "hypertext"
     }

document {
     Key => "SUBSECTION",
     Headline => "hypertext SUBSECTION item",
	Usage => "SUBSECTION x", 
	Inputs => {"x" => {}},
	Outputs => {HEADER2 => {}},
     TT "SUBSECTION x", " encloses ", TT "x", " in a hypertext HEADER2 header item. It is often used in the Mathematical Overview section of the documentation.",
     PARA,
     "The argument ", TT "x", " should be a string, or a list or sequence of
     strings or hypertext items.",
     PARA,
     "Here is an example.  The code ",
     PRE "SUBSECTION \"Interesting thing\", \"Here is an interesting thing.\"",
     " produces ",
     SUBSECTION "Interesting thing", "Here is an interesting thing.",
     PARA,
     SeeAlso => {"HEADER2", "hypertext"}
     }

document {
     Key => HEADER3,
     Headline => "hypertext HEADER3 item",
	Usage => "HEADER3 x",
	Inputs => {"x" => {}},
	Outputs => {HEADER3 => {}},
     TT "HEADER3 x", " encloses ", TT "x", " in a hypertext HEADER3 header item.",
     PARA,
     "The argument ", TT "x", " should be a string, or a list or sequence of
     strings or hypertext items.",
     PARA,
     "Here is an example.  The code ",
     PRE "HEADER3 \"Interesting thing\", \"Here is an interesting thing.\"",
     " produces ",
     HEADER3 "Interesting thing", "Here is an interesting thing.",
     PARA,
     SeeAlso => "hypertext"
     }

document {
     Key => HEADER4,
     Headline => "hypertext HEADER4 item",
	Usage => "HEADER4 x",
	Inputs => {"x" => {}},
	Outputs => {HEADER4 => {}},
     TT "HEADER4 x", " encloses ", TT "x", " in a hypertext HEADER4 header item.",
     PARA,
     "The argument ", TT "x", " should be a string, or a list or sequence of
     strings or hypertext items.",
     PARA,
     "Here is an example.  The code ",
     PRE "HEADER4 \"Interesting thing\", \"Here is an interesting thing.\"",
     " produces ",
     HEADER4 "Interesting thing", "Here is an interesting thing.",
     PARA,
     SeeAlso => "hypertext"
     }

document {
     Key => HEADER5,
     Headline => "hypertext HEADER5 item",
	Usage => "HEADER5 x",
	Inputs => {"x" => {}},
	Outputs => {HEADER5 =>{}},
     TT "HEADER5 x", " encloses ", TT "x", " in a hypertext HEADER5 header item.",
     PARA,
     "The argument ", TT "x", " should be a string, or a list or sequence of
     strings or hypertext items.",
     PARA,
     "Here is an example.  The code ",
     PRE "HEADER5 \"Interesting thing\", \"Here is an interesting thing.\"",
     " produces ",
     HEADER5 "Interesting thing", "Here is an interesting thing.",
     PARA,
     SeeAlso => "hypertext"
     }

document {
     Key => HEADER6,
     Headline => "hypertext HEADER6 item",
	Usage => "HEADER6 x",
	Inputs => {"x" => {}},
	Outputs => {HEADER6 => {}},
     TT "HEADER6 x", " encloses ", TT "x", " in a hypertext HEADER6 header item.",
     PARA,
     "The argument ", TT "x", " should be a string, or a list or sequence of
     strings or hypertext items.",
     PARA,
     "Here is an example.  The code ",
     PRE "HEADER6 \"Interesting thing\", \"Here is an interesting thing.\"",
     " produces ",
     HEADER6 "Interesting thing", "Here is an interesting thing.",
     PARA,
     SeeAlso => "hypertext"
     }

document {
     Key => LISTING,
     Headline => "hypertext LISTING item",
	Usage => "LISTING x",
	Inputs => {"x" => {}},
	Outputs => {LISTING => {}},
     TT "LISTING x", " encloses ", TT "x", " in a hypertext LISTING item.",
     PARA,
     "The argument ", TT "x", " should be a string.",
     PARA,
     "Here is an example.",
     LISTING "Here is a long line.  Here is a long line.  Here is a long line.  Here is a long line.  Here is a long line.  Here is a long line.  
   1234   2345    4567    5678
     34    345    3455       7
",
     PARA,
     SeeAlso => "hypertext"
     }

document {
     Key => BLOCKQUOTE,
     Headline => "hypertext BLOCKQUOTE item",
	Usage => "BLOCKQUOTE x",
	Inputs => {"x" => {}},
	Outputs => {BLOCKQUOTE => {}},
     TT "BLOCKQUOTE x", " encloses ", TT "x", " in a hypertext BLOCKQUOTE item.",
     PARA,
     "The argument ", TT "x", " should be a string.",
     PARA,
     "Here is an example.",
     BLOCKQUOTE "Here is a long line.  Here is a long line.  Here is a long line.  Here is a long line.  Here is a long line.  Here is a long line.  
   1234   2345    4567    5678
     34    345    3455       7
",
     PARA,
     SeeAlso => "hypertext"
     }

document {
     Key => EXAMPLE,
     Headline => "hypertext EXAMPLE item",
	Usage => "EXAMPLE x",
	Inputs => {"x" => {}},
	Outputs => {EXAMPLE => {}},
     TT "EXAMPLE x", " evaluates the string or list of strings
     ", TT "x", " as Macaulay 2 code, inserting the results in
     hypertext preformatted ", TO "PRE", " items.",
     PARA,
     "The evaluation is done by the Makefile at a separate time, and the
     results are left where they can be found the next time the same
     EXAMPLE is encountered.",
     PARA,
	"For example, the code",
	PRE "EXAMPLE { \"1+1\"}",
     " produces ",
     EXAMPLE {"1+1"},
     SeeAlso => "hypertext"
     }

document {
     Key => TABLE,
     Headline => "hypertext table",
	Usage => "TABLE x",
	Inputs => {"x" => {}},
	Outputs => {TABLE => {}},
     TT "TABLE x", " produces a hypertext TABLE from a list of lists."
     }

document {
     Key => LITERAL,
     Headline => "hypertext literal text",
	Usage => "LITERAL x",
	Inputs => {"x" => {}},
	Outputs => {LITERAL => {}},
     TT "LITERAL x", " produces a special hypertext item which contains
     HTML text that should be left unchanged by ", TO "html", "."
     }

document {
     Key => STRONG,
     Headline => "hypertext STRONG item",
	Usage => "STRONG x",
	Inputs => {"x" => {}},
	Outputs => {STRONG => {}},
     TT "STRONG x", " encloses ", TT "x", " in a hypertext STRONG item.",
     PARA,
     "The argument ", TT "x", " should be a string, or a list or sequence of
     strings or hypertext items.",
     PARA,
     "Here is an example.",
     PARA,
     STRONG "Here is strong text!",
     PARA,
     SeeAlso => "hypertext"
     }

document {
     Key => SMALL,
     Headline => "hypertext SMALL item",
	Usage => "SMALL x",
	Inputs => {"x" => {}},
	Outputs => {SMALL => {}},
     TT "SMALL x", " encloses ", TT "x", " in a hypertext SMALL item.",
     PARA,
     "The argument ", TT "x", " should be a string, or a list or sequence of
     strings or hypertext items.",
     PARA,
     "Here is an example.",
     PARA,
     SMALL "Here is some small text.",
     PARA,
     SeeAlso => "hypertext"
     }

document {
     Key => SUB,
     Headline => "hypertext subscript",
	Usage => "SUB x",
	Inputs => {"x" => {}},
	Outputs => {SUB => {}},
     TT "SUB x", " encloses ", TT "x", " in a hypertext ", TT "SUB", " item,
     thereby making it a subscript.",
     PARA,
     "The argument ", TT "x", " should be a string, or a list or sequence of
     strings or hypertext items.",
     PARA,
     SeeAlso => "hypertext"
     }

document {
     Key => SUP,
     Headline => "hypertext superscript",
	Usage => "SUP x",
	Inputs => {"x" =>{}},
	Outputs => {SUP => {}},
     TT "SUP x", " encloses ", TT "x", " in a hypertext ", TT "SUP", " item,
     thereby making it a superscript.",
     PARA,
     "The argument ", TT "x", " should be a string, or a list or sequence of
     strings or hypertext items.",
     PARA,
     SeeAlso => "hypertext"
     }

document {
     Key => ITALIC,
     Headline => "hypertext italic font",
     Usage => "ITALIC x",
	Inputs => {"x" => {}},
	Outputs => {ITALIC => {}},
	TT "ITALIC x", " encloses ", TT "x", " in a hypertext ITALIC item.",
     PARA,
     "The argument ", TT "x", " should be a string, or a list or sequence of
     strings or hypertext items.  The result corresponds to the
     html I command.",
     PARA,
     "Here is an example.",
     PARA,
     ITALIC "Here is a long line.  Here is a long line.  Here is a long line.  Here is a long line.  Here is a long line.  Here is a long line.",
     PARA,
     SeeAlso => "hypertext"
     }

document {
     Key => UNDERLINE,
     Headline => "hypertext underlining",
	Usage => "UNDERLINE x",
	Inputs => {"x" => {}},
	Outputs => {UNDERLINE => {}},
     TT "UNDERLINE x", " encloses ", TT "x", " in a hypertext UNDERLINE item.",
     PARA,
     "The argument ", TT "x", " should be a string, or a list or sequence of
     strings or hypertext items.",
     PARA,
     "Here is an example.",
     PARA,
     UNDERLINE "Here is a long line.  Here is a long line.  Here is a long line.  Here is a long line.  Here is a long line.  Here is a long line.",
     PARA,
     SeeAlso => "hypertext"
     }

document {
     Key => TEX,
     Headline => "hypertext TEX item",
	Usage => "TEX x",
	Inputs => {"x" => {}},
	Outputs => {TEX => {}},
     TT "TEX s", " includes the string ", TT "s", ", presumably
     containing TeX commands, in the TeX version of the documentation
     containing this ", TO "hypertext", " item.",
     PARA,
     "Invisible in the text and html versions."
     }

document {
     Key => TT,
     Headline => "hypertext TT item",
	Usage => "TT x",
	Inputs => {"x" => {}},
	Outputs => {TT => {}}, 
     TT "TT x", " encloses ", TT "x", " in a hypertext ", TT "TT", " item.",
     PARA,
     "The argument ", TT "x", " should be a string, or a list or sequence of
     strings or hypertext items.",
     PARA,
     "Here is an example.",
     PARA,
     TT "Here is a long line.  Here is a long line.  Here is a long line.  Here is a long line.  Here is a long line.  Here is a long line.",
     PARA,
     SeeAlso => "hypertext"
     }

document {
     Key => EM,
     Headline => "hypertext EM item",
	Usage => "EM x",
	Inputs => {"x" => {}},
	Outputs => {EM => {}},
     TT "EM x", " encloses ", TT "x", " in a hypertext EM item.",
     PARA,
     "The argument ", TT "x", " should be a string, or a list or sequence of
     strings or hypertext items.",
     PARA,
     "Here is an example.",
     PARA,
     EM "Here is a long line.  Here is a long line.  Here is a long line.  Here is a long line.  Here is a long line.  Here is a long line.",
     PARA,
     SeeAlso => "hypertext"
     }

document {
     Key => BOLD,
     Headline => "hypertext BOLD item",
	Usage => "BOLD x",
	Inputs => {"x" => {}},
	Outputs => {BOLD => {}},
     TT "BOLD x", " encloses ", TT "x", " in a hypertext BOLD item.",
     PARA,
     "The argument ", TT "x", " should be a string, or a list or sequence of
     strings or hypertext items.  This corresponds to B in html format.",
     PARA,
     "Here is an example.",
     PARA,
     BOLD "Here is a long line.  Here is a long line.  Here is a long line.  Here is a long line.  Here is a long line.  Here is a long line.",
     PARA,
     SeeAlso => "hypertext"
     }

document {
     Key => CODE,
     Headline => "hypertext CODE item",
	Usage => "CODE x",
	Inputs => {"x" => {}},
	Outputs => {CODE => {}},
     TT "CODE x", " encloses ", TT "x", " in a hypertext CODE item.",
     PARA,
     "The argument ", TT "x", " should be a string, or a list or sequence of
     strings or hypertext items.",
     PARA,
     "Here is an example.",
     PARA,
     CODE "Here is a long line.  Here is a long line.  Here is a long line.  Here is a long line.  Here is a long line.  Here is a long line.",
     PARA,
     SeeAlso => "hypertext"
     }

document {
     Key => HREF,
     Headline => "hypertext link",
	Usage => "HREF{u,p}",
	Inputs => {
		"u" => {"a url"},
		"p" => {"a phrase"}
		},
	Outputs => {HREF => {}},
     TT "HREF{u,p}", " encloses the phrase ", TT "p", " in a hypertext HREF link
     pointing to the url ", TT "u", ".",
     PARA,
     SeeAlso => "hypertext"
     }

document {
     Key => ANCHOR,
     Headline => "hypertext anchor",
	Usage => "ANCHOR{u,p}",
	Inputs => {
		"u" => {"the name of the anchor"},
		"p" => {"a phrase"}
		},
     TT "ANCHOR{u,p}", " encloses the phrase ", TT "p", " in a hypertext anchor
     named ", TT "u", ".",
     PARA,
     SeeAlso => "hypertext"
     }

document {
     Key => UL,
     Headline => "hypertext UL item",
	Usage => "UL x",
	Inputs => {"x" => {}},
	Outputs => {UL => {}},
     TT "UL x", " encloses the list x as a hypertext UL itemized list.",
     PARA,
     "The argument ", TT "x", " should be a list of strings or hypertext items.",
     PARA,
     "Here is an example. The expression ",
     PRE "UL {\"first\",\"second\",\"third\"}",
     "produces",
     UL {"first","second","third"},
     PARA,
     SeeAlso => "hypertext"
     }

document {
     Key => NL,
     Headline => "hypertext NL item",
	Usage => "NL x",
	Inputs => {"x" => {}},
	Outputs => {NL => {}},
     TT "NL x", " encloses the list x as a hypertext NL itemized list.",
     PARA,
     "The argument ", TT "x", " should be a list of strings or hypertext items.",
     PARA,
     "Here is an example. The expression ",
     PRE "NL {\"first\",\"second\",\"third\"}",
     "produces",
     NL {"first","second","third"},
     PARA,
     SeeAlso => "hypertext"
     }

document {
     Key => NOINDENT,
     Headline => "cancel hypertext indentation",
	Usage => "NOINDENT",
     TT "NOINDENT{}", " specifies that no indentation should be used
     for following hypertext items.",
     PARA,
     "This item is mainly of interest for hypertext that ultimately will
     be viewed with TeX, for html viewers don't indent paragraphs.",
     PARA,
     SeeAlso => "hypertext"
     }

document {
     Key => TO,
     Headline => "hypertext documentation link",
	Usage => "TO x",
	Inputs => {"x" => {"a documentation key"}},
	Outputs => {TO => {}},
     TT "TO \"x\"", " produces a hypertext link to the documentation page labeled ", TT "x", ".",
     PARA,
     "See also ", TO "hypertext", ".  The word ", ITALIC "hypertext", " in the previous
     sentence is an example of the use of ", TT "TO", ".",
     PARA,
     "The special form ", TT "TO {\"x\", \"s\"}", " produces a hypertext link to
     the page labeled ", TT "x", ", but with the string \"s\" appended to the
     string \"x\" at the point where the reference occurs.  This form is needed
     because in some modes of output the link is indicated with a section number
     in brackets.",
     PARA,
     "The special form ", TT "TO (f,X)", " produces a hypertext link to
     the page documenting the method used for applying the function ", TT "f", " to
     an argument of class ", TT "X", ".  For more arguments, use ", TT "TO (f,X,Y)", "
     or ", TT "TO (f,X,Y,Z)", ".",
     PARA,
     "The special form ", TT "TO [f,X]", " produces a hypertext link to the
     page documenting the optional argument named ", TT "X", " for the 
     function ", TT "f", ".",
     PARA,
     "If ", TT "TO x", " is an entry in a ", TO "UL", ", then it is treated
     as ", TT "TOH x", ", and headlines are added automatically.",
	SeeAlso => {Key, TO2, TOH}
     }

document {
     Key => TO2,
     Headline => "labeled hypertext documentation link",
	Usage => "TO2 {x,p}",
	Inputs => {
		"x" => {"a documentation key"},
		"p" => {"a phrase"}
		},
	Outputs => {TO2 => {}},
     TT "TO2 {x,\"p\"}", " produces a hypertext link labeled \"p\" to the documentation page labeled ", TT "x", "."
     }


document {
     Key => TOH,
     Headline => "hypertext documentation link followed by a headline",
	Usage => "TOH x",
	Inputs => {"x" => {"a documentation key"}},
	Outputs => {TOH => {}},
     TT "TOH \"x\"", " produces a hypertext link to the documentation page labeled ", TT "x", " followed by the ", TO "Headline", " for ", TT "x", ".  If ", TT "TO x", " is an entry in a ", TO "UL", ", then it is treated
     as ", TT "TOH x", ", and headlines are added automatically."
 }


document {
     Key => Command,
     Headline => "the class of all commands",
     Usage => "Command g",
     Inputs => { "g" => "a function or a string" },
     Outputs => { { "a new command that will evaluate ", TT "g()", " if ", TT "g", " is a function, and will evaluate ", TT "run g", " if ", TT "g", " is a string" } },
     "A command behaves as a function does if it is followed by an adjacent
     expression which can serve as its argument or argument list.  In addition,
     if it appears as the value of an expression typed by the user at top
     level (i.e., not in a file), then it gets executed with empty argument list.",
     EXAMPLE {
	  "(f = Command ( () -> 2^30 );)",
	  "f",
	  "(c = Command \"date\";)",
	  "c"
	  },
     SeeAlso => {"run", "AfterEval"}
     }


document {
     Key => monomialCurveIdeal, 
     Headline => "make the ideal of a monomial curve",
	Usage => "I = monomialCurveIdeal(R,a)",
	Inputs => {
		"R" => Ring => {},
		"a" => {"a list of integers to be used as exponents in the parametrization of a rational curve"}
		},
	Outputs => {"I" => Ideal => {}},
     TT "monomialCurveIdeal(R,a)", " yields the defining ideal of the projective
     curve given parametrically on an affine piece by 
     t |---> (t^a1, ..., t^an).",
     PARA,
     "The ideal is defined in the polynomial ring R,
     which must have at least n+1 variables, preferably all of equal 
     degree.  The first n+1 variables in the ring are used",
     "For example, the following defines a plane quintic curve of genus 6.",
     EXAMPLE {
	  "R = ZZ/101[a..f]",
	  "monomialCurveIdeal(R,{3,5})",
	  },
     "Here is a genus 2 curve with one singular point.",
     EXAMPLE "monomialCurveIdeal(R,{3,4,5})",
     "Here is one with two singular points, genus 7.",
     EXAMPLE "monomialCurveIdeal(R,{6,7,8,9,11})",
     "Finally, here is the smooth rational quartic in P^3.",
     EXAMPLE "monomialCurveIdeal(R,{1,3,4})"
     }

TEST ///
    R := ZZ/101[a..f];
    -- plane quintic, genus=6
    I1 := monomialCurveIdeal(R,{3,5});
    assert(I1 == image matrix{{b^5-a^2*c^3}});

    -- one singular point, g=2
    I2 := monomialCurveIdeal(R,{3,4,5});
    assert(I2 == image matrix {{c^2-b*d, b^2*c-a*d^2, b^3-a*c*d}});

    -- two singular points, g=7
    I3 := monomialCurveIdeal(R,{6,7,8,9,11});
    assert(I3 == image matrix {{
               d*e-b*f, e^2-c*f, c*d-b*e, d^2-c*e, 
               c^2-b*d, b*c*e-a*f^2, b^2*d-a*e*f, b^2*c-a*d*f, b^3-a*c*f}});

    -- smooth rational quartic in P^3
    I4 := monomialCurveIdeal(R,{1,3,4});
    assert(I4 == image matrix {{b*c-a*d, c^3-b*d^2, a*c^2-b^2*d, b^3-a^2*c}});
///

document {
     Key => Fano, 
     Headline => "Fano scheme"
     }

document {
	Key => (Fano,ZZ,Ideal),
	Headline => "Fano scheme",
	Usage => "Fano(k,I)",
	Inputs => {
		"k" => {"a positive integer less than ", TT "r"},
		"I" => {"an ideal representing a variety in in projective ", TT "r", "-space"}, 
		},
	Outputs => {"the ideal of a Fano scheme in the Grassmannian"},
	  "Given an ideal ", TT "I", " representing a projective variety ", TT "X", "
     in ", TT "P^r", ", a positive integer k<r, and optionally a 
     ring ", TT "GR", " with (exactly) ", TT "r+1", " choose ", TT "k+1", " variables, 
     representing the ambient space of the Grassmannian of 
     k-planes in ", TT "P^r", ", this routine returns the ideal in
     ", TT "GR", " of the Fano scheme that parametrizes the k-planes 
     lying on ", TT "X", ".  If the optional third argument is not 
     present, the routine fabricates its own ring, 
     and returns an ideal in it.",
	SeeAlso => (Fano,ZZ,Ideal,Ring)
	}

document {
	Key => (Fano,ZZ,Ideal,Ring),
	Headline => "Fano scheme",
	Usage => "Fano(k,I,GR)",
	Inputs => {
		"k" => {"a positive integer less than ", TT "r"},
		"I" => {"an ideal representing a variety in in projective ", TT "r", "-space"},
		"GR" => {} 
		},
	Outputs => {"the ideal of a Fano scheme in the Grassmannian"},
	  "Given an ideal ", TT "I", " representing a projective variety ", TT "X", "
     in ", TT "P^r", ", a positive integer k<r, and optionally a 
     ring ", TT "GR", " with (exactly) ", TT "r+1", " choose ", TT "k+1", " variables, 
     representing the ambient space of the Grassmannian of 
     k-planes in ", TT "P^r", ", this routine returns the ideal in
     ", TT "GR", " of the Fano scheme that parametrizes the k-planes 
     lying on ", TT "X", ".  If the optional third argument is not 
     present, the routine fabricates its own ring, 
     and returns an ideal in it.",
	SeeAlso => (Fano,ZZ,Ideal)
	}

document {
     Key => code,
     Headline => "display source code",
     TT "code f", " -- prints out the source code of the function ", TT "f", ".",
     BR, NOINDENT,
     TT "code(f,X)", " -- prints out the source code of the particular 
     method that would be applied if ", TT "f", " were applied to an argument of 
     class ", TT "X", ".",
     BR, NOINDENT,
     TT "code(f,X,Y)", " -- prints out the source code of the particular 
     method that would be applied if ", TT "f", " were applied to arguments of
     classes ", TT "X", " and ", TT "Y", ".",
     BR, NOINDENT,
     TT "code(f,X,Y,Z)", " -- prints out the source code of the 
     particular method that would be applied if ", TT "f", " were applied to 
     arguments of classes ", TT "X", ", ", TT "Y", ", and ", TT "Z", ".",
     BR, NOINDENT,
     TT "code {v,w,...}", " -- prints out the source code for each
     of the items listed.",
     PARA,
     EXAMPLE "code methods use",
     SeeAlso => "methods"
     }

document {
     Key => edit,
     Headline => "edit source code",
     TT "edit", " -- a command which starts the text editor",
     BR,NOINDENT,
     TT "edit f", " -- starts the text editor at the source code of the
     function ", TT "f", ".",
     BR,NOINDENT,
     TT "edit(f,X)", " -- edits the source code of the particular 
     method that would be applied if ", TT "f", " were applied to an argument of 
     class ", TT "X", ".",
     BR, NOINDENT,
     TT "edit(f,X,Y)", " -- edits the source code of the particular 
     method that would be applied if ", TT "f", " were applied to arguments of
     classes ", TT "X", " and ", TT "Y", ".",
     BR, NOINDENT,
     TT "edit(f,X,Y,Z)", " -- edits the source code of the 
     particular method that would be applied if ", TT "f", " were applied to 
     arguments of classes ", TT "X", ", ", TT "Y", ", and ", TT "Z", ".",
     PARA,
     "The name of the user's preferred editor is take from the environment 
     variable ", TT "EDITOR", ".  If X is running and the editor is not
     emacs, then the editor is started in a new ", TT "xterm", " window.",
     PARA,
     "For an interactive example, try ", TT "edit(dim,Module)", ".",
     PARA,
     "The value returned is the exit code returned by the editor, as with
     ", TO "run", ", usually zero."
     }

document {
     Key => methods,
     Headline => "list methods",
     TT "methods F", " -- produces a list of those methods associated with the
     function or type F.",
     BR, NOINDENT,
     TT "methods symbol **", " -- produces a list of the methods 
     usable with the operator ", TT "**", ".",
     BR, NOINDENT,
     TT "methods (symbol **, X)", " -- produces a list of the 
     methods usable with the operator ", TT "**", " and a thing of
     class ", TT "X", ".",
     BR, NOINDENT,
     TT "methods (X, Y)", " -- produces a list of the 
     methods usable with a thing of class ", TT "X", " and a thing of class
     ", TT "Y", ".",
     PARA,
     "This function operates by examining those types which are values of
     global symbols for keys which appear to be storing references to
     methods.  Types which don't appear as values of global variables will
     not be examined, so perhaps not all methods will be found.",
     PARA,
     EXAMPLE "methods drop"
     }

document {
     Key => isTable,
     Headline => "whether something is a rectangular list of lists",
     PARA,
     "Warning: it is intrinsically impossible to represent a ", TT "0", " 
     by ", TT "k", " matrix as a list of lists.",
     EXAMPLE {
	  "isTable {{1,2,3},{4,5}}",
	  "isTable {{1,2,3},{4,5,6}}",
	  }
     }

document {
     Key => Monoid,
     Headline => "the class of all monoids",
     "A monoid is a set with a multiplicative operation on
     it and an identity element.  A typical monoid is the set
     of monomials in a polynomial ring, which we consider to be
     created before the polynomial ring is created."
     }

document {
     Key => (symbol _, ZZ, Monoid),
     Headline => "get unit element",
     TT "1_M", " -- provides the unit element of a monoid ", TT "M", "."
     }


-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/m2 "
-- End:
