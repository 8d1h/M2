--		Copyright 1993-2003 by Daniel R. Grayson

-----------------------------------------------------------------------------
-- html input
-----------------------------------------------------------------------------

html = method(SingleArgumentDispatch=>true, TypicalValue => String)
-- text used to be one of the conversion functions, but now we just use "net"
tex = method(SingleArgumentDispatch=>true, TypicalValue => String)
texMath = method(SingleArgumentDispatch=>true, TypicalValue => String)
mathML = method(SingleArgumentDispatch=>true, TypicalValue => String)

MarkUpList = new Type of BasicList
MarkUpList.synonym = "mark-up list"

MarkUpListParagraph = new Type of MarkUpList
MarkUpList.synonym = "mark-up list paragraph"

     MarkUpType = new Type of Type
MarkUpType.synonym = "mark-up type"

DistributedMarkUpType = new Type of MarkUpType
DistributedMarkUpType.synonym = "distributed mark-up type"

EmptyMarkUpType = new Type of MarkUpType
EmptyMarkUpType.synonym = "empty mark-up type"
     MarkUpType Sequence := 
     MarkUpType List := (h,y) -> new h from select(y,i -> i =!= null)
EmptyMarkUpType List := (h,y) -> if #y === 0 then new h from y else error "expected empty list"
     MarkUpType Thing := (h,y) -> new h from {y}
     MarkUpType\List := (h,y) -> (i -> h i) \ y
DistributedMarkUpType MarkUpListParagraph := (h,y) -> apply(y, i -> h i)
     List/MarkUpType := (y,h) -> y / (i -> h i)
EmptyMarkUpType Thing := (h,y) -> error "expected empty list"

makeList := method()
makeList MarkUpType := X -> toString X
makeList Type       := X -> concatenate("new ", toString X, " from ")
toExternalString MarkUpList := s -> concatenate(makeList class s, toExternalString toList s)
toString         MarkUpList := s -> concatenate(makeList class s, toString         toList s)

htmlMarkUpType = s -> (
     on := "<" | s | ">";
     off := "</" | s | ">";
     t -> concatenate(on, apply(t,html), off))

MarkUpType.GlobalAssignHook = (X,x) -> (
     if not ReverseDictionary#?x then (
	  ReverseDictionary#x = X;
     	  html x := htmlMarkUpType toString X;
	  );
     )

new MarkUpType := x -> error "obsolete 'new' method called"

BR         = new EmptyMarkUpType of MarkUpList
NOINDENT   = new EmptyMarkUpType of MarkUpList
HR         = new EmptyMarkUpType of MarkUpListParagraph
PARA       = new MarkUpType of MarkUpListParagraph
EXAMPLE    = new MarkUpType of MarkUpListParagraph; new EXAMPLE from List := (EXAMPLE,x) -> select(x,i -> i =!= null)
TABLE      = new MarkUpType of MarkUpListParagraph
ExampleTABLE = new MarkUpType of MarkUpListParagraph
PRE        = new MarkUpType of MarkUpListParagraph
TITLE      = new MarkUpType of MarkUpList
BASE	   = new MarkUpType of MarkUpList
HEAD       = new MarkUpType of MarkUpList
BODY       = new MarkUpType of MarkUpList
IMG	   = new MarkUpType of MarkUpList
HTML       = new MarkUpType of MarkUpList
BIG        = new MarkUpType of MarkUpList
HEADER1    = new MarkUpType of MarkUpListParagraph
net HEADER1 := x -> (
     r := "" || horizontalJoin apply(x,net);
     r || concatenate( width r : "=" )
     )
HEADER2    = new MarkUpType of MarkUpListParagraph
net HEADER2 := x -> (
     r := "" || horizontalJoin apply(x,net);
     r || concatenate( width r : "-" )
     )
HEADER3    = new MarkUpType of MarkUpListParagraph
HEADER4    = new MarkUpType of MarkUpListParagraph
HEADER5    = new MarkUpType of MarkUpListParagraph
HEADER6    = new MarkUpType of MarkUpListParagraph
LISTING    = new MarkUpType of MarkUpListParagraph
LITERAL    = new MarkUpType of MarkUpList
XMP        = new MarkUpType of MarkUpList
BLOCKQUOTE = new MarkUpType of MarkUpList
VAR        = new MarkUpType of MarkUpList
DFN        = new MarkUpType of MarkUpList
STRONG     = new MarkUpType of MarkUpList
BIG        = new MarkUpType of MarkUpList
SMALL      = new MarkUpType of MarkUpList
SAMP       = new MarkUpType of MarkUpList
KBD        = new MarkUpType of MarkUpList
SUB        = new MarkUpType of MarkUpList
SUP        = new MarkUpType of MarkUpList
ITALIC     = new MarkUpType of MarkUpList
UNDERLINE  = new MarkUpType of MarkUpList
TEX	   = new MarkUpType of MarkUpList
SEQ	   = new MarkUpType of MarkUpList
TT         = new MarkUpType of MarkUpList
EM         = new MarkUpType of MarkUpList
CITE       = new MarkUpType of MarkUpList
LABEL      = new MarkUpType of MarkUpList
BOLD       = new MarkUpType of MarkUpList
CODE       = new MarkUpType of MarkUpList
HREF       = new MarkUpType of MarkUpList
ANCHOR     = new MarkUpType of MarkUpList
Hypertext  = new MarkUpType of MarkUpList		    -- top level, to be returned to user by "help" and "hypertext", includes text that has been already fixed up

UL         = new MarkUpType of MarkUpListParagraph

CONTENTS   = new DistributedMarkUpType of MarkUpList
NOCONTENTS = new DistributedMarkUpType of MarkUpList

OL         = new MarkUpType of MarkUpListParagraph
DIV        = new MarkUpType of MarkUpList
NL         = new MarkUpType of MarkUpListParagraph
DL 	   = new MarkUpType of MarkUpListParagraph
TO         = new MarkUpType of MarkUpList
TO2        = new MarkUpType of MarkUpList
TOH        = new MarkUpType of MarkUpList
SECTION    = new MarkUpType of MarkUpListParagraph		    -- let's get rid of this
TOC	   = new MarkUpType of MarkUpListParagraph		    -- let's get rid of this

MarkUpList ^ MarkUpList := (x,y) -> SEQ{x,SUP y}
MarkUpList _ MarkUpList := (x,y) -> SEQ{x,SUB y}

trimline0 := x -> selectRegexp ( "^(.*[^ ]|) *$",1, x)
trimline  := x -> selectRegexp ( "^ *(.*[^ ]|) *$",1, x)
trimline1 := x -> selectRegexp ( "^ *(.*[^ ]|)$",1, x)
addspaces := x -> if x#?0 then if x#-1=="." then concatenate(x,"  ") else concatenate(x," ") else x

fixup := method(SingleArgumentDispatch => true)
flat := method()
flat Thing := identity
flat SEQ := x -> toSequence x
flat Nothing := x -> ()
fixflat := z -> splice apply(z, i -> flat fixup i)
fixup Thing      := z -> error("unrecognizable item inside documentation: ", toString z)
fixup Nothing    := identity				       -- null
fixup Sequence   := 
fixup List       := z -> SEQ fixflat z
fixup MarkUpList := z -> apply(z,fixup)			       -- recursion
fixup Option     := z -> z#0 => fixup z#1		       -- Headline => "...", ...
fixup PRE        := 
fixup TO         := 
fixup TO2        := 
fixup TOH        := identity
fixup MarkUpType := z -> z{}				       -- convert PARA to PARA{}
fixup Function   := z -> z				       -- allow Function => f in Synopsis
fixup String     := s -> (				       -- remove clumsy newlines within strings
     ln := lines s;
     if not ln#?1 then return s;
     concatenate ({addspaces trimline0 ln#0}, addspaces \ trimline \take(ln,{1,#ln-2}), {trimline1 ln#-1}))

new Hypertext from List := (h,x) -> splice apply(x, i -> flat i)
hypertext = x -> Hypertext fixup x

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/m2 "
-- End:
