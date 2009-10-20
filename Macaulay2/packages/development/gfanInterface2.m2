
-- THIS FILE IS UNDER CONSTRUCTION!!  It will replace gfanInterface in 1.3? (Nope.)

--needsPackage "Polymake"

newPackage(
	"gfanInterface2",
	Version => "0.3", 
	Date => "July 15, 2009",
	Authors => {
		{Name => "Mike Stillman", Email => "mike@math.cornell.edu", HomePage => ""},
		{Name => "Andrew Hoefel", Email => "andrew.hoefel@mathstat.dal.ca", HomePage => ""}
	},
	Headline => "Interface to A. Jensen's gfan package",
	Configuration => { 
		"path" => "",
		"fig2devpath" => "",
		--"keep files" => true,
		"verbose" => true
	},
	DebuggingMode => false
)

export {
	MarkedPolynomialList,
	markedPolynomialList,
	gfan, 
	gfanBuchberger,
	gfanDoesIdealContain,
	gfanFanCommonRefinement, -- v0.4
	gfanFanLink, -- v0.4
	gfanFanProduct, -- v0.4
	gfanGroebnerCone,
	gfanHomogeneitySpace,
	gfanHomogenize,
	gfanInitialForms,
	gfanInteractive,
	gfanIsMarkedGroebnerBasis,
	gfanKrullDimension,
	gfanLatticeIdeal, -- v0.4
	gfanLeadingTerms,
	gfanMarkPolynomialSet,
	gfanMinkowskiSum, -- v0.4
	gfanMinors, -- v0.4
	gfanPolynomialSetUnion,
	gfanRender, 
	gfanRenderStaircase, 
	gfanSaturation,
	gfanSecondaryFan, -- v0.4
	gfanStats,
	gfanSubstitute,
	gfanToLatex,
	gfanToPolyhedralFan,
	gfanTropicalBasis,
	gfanTropicalBruteForce,
	gfanTropicalEvaluation, -- v0.4
	gfanTropicalFunction, -- v0.4
	gfanTropicalHyperSurface, -- v0.4
	gfanTropicalIntersection,
	gfanTropicalLifting,
	gfanTropicalLinearSpace, -- v0.4
	gfanTropicalMultiplicity,
	gfanTropicalRank, -- v0.4
	gfanTropicalStartingCone,
	gfanTropicalTraverse,
	gfanTropicalWeilDivisor, -- v0.4
	gfanFunctions -- for testing purposes
}

gfanPath = gfanInterface2#Options#Configuration#"path"
fig2devPath = gfanInterface2#Options#Configuration#"fig2devpath"
gfanVerbose = gfanInterface2#Options#Configuration#"verbose"
--gfanKeepFiles = gfanInterface2#Options#Configuration#"keep files"

--needsPackage "Polymake"

MarkedPolynomialList = new Type of List
  -- Currently: this is a list {inL,L}, where 
  --   inL is a list of monomials (with coefficient, often 1)
  --   L is a list of polynomials
  -- and L and inL have the same length, and the
  -- the monomial inL#i is the marked monomial, which
  -- should occur with the same coefficient in L#i.

markedPolynomialList = method();
markedPolynomialList List := L -> (
	if #L =!= 2 then 
		error("A MarkedPolynomialList must be a list containing "
			| "a list of initial terms and a list of polynoimals."
		);
	if #(first L) =!= #(last L) then
		error("The lists of initial terms and polynomials in a "
			| "MarkedPolynomialList must have the same length."
		);
	if #(first L) =!= 0 then (
		R := class first first L;
		if class R =!= PolynomialRing then
			error("Initial terms and polynomials in a MarkedPolynomialList "
				| "should be elements of a polynomial ring."
			);
		scan(transpose L, t -> (
			m := first t;
			f := last t;
			if class m =!= R or class f =!= R then 
				error("Each initial term and polynomial of a MarkedPolynomialList "
					| "should be a member of the same polynomial ring."
				);
			if #(terms m) =!= 1 then
				error("Initial terms of a MarkedPolynomialList should consist "
					| "of a single term."
				);
			if not member(m, terms f) then
				error("Each initial terms of a MarkedPolynomialList should "
					| "appear in its corresponding polynomial. "
					| "(" | toString m | " is not a term of " | toString f | ")."
				);
			)
		);
	);
	new MarkedPolynomialList from L
)

expression MarkedPolynomialList := L -> 
	expression apply(transpose L, t -> (
		m := t#0;
		f := t#1;
		out := "(" | toString m | ")";
		if leadCoefficient(f-m) > 0 then 
			out = out | " +";
		if f-m != 0 then 
			return out | " " | toString(f-m)
			else
			return out;
		)
	)

net MarkedPolynomialList := L -> net expression L

--------------------------------------------------------
--------------------------------------------------------
-- PARSING FUNCTIONS
--------------------------------------------------------
--------------------------------------------------------

gfanParseList = method();
gfanParseList String := (S) -> (
	S = replace("\n", "", S);
	stack := {};
	r := regex(///[\{,\}]///, S);
	popstate := false;
	while #r === 1 do (
		startpos := first first r;
		character := substring(startpos,1,S);
		prestring := substring(0, startpos, S);
		S = substring(startpos+1, #S,S);
		if character == "," then (
			if not popstate then (
				stack = append(drop(stack,-1), append(last stack, prestring));
			);
			popstate = false;
		) else if character == "{" then (
			stack = append(stack, {});
		) else if #stack == 0 then (
			error "Parsing error";
		) else if #stack == 1 then (
			if not popstate then (
				stack = append(drop(stack,-1), append(last stack, prestring));
			);
			return first stack;
		) else (
			if not popstate then (
				stack = append(drop(stack,-1), append(last stack, prestring));
			);
			stack = append(drop(stack,-2), append(stack#(#stack -2), last stack));
			popstate = true;
		);
		r = regex(///[\{,\}]///, S);
	);
	error "Parsing error";
)

gfanParseMarkedPoly = method();
gfanParseMarkedPoly String := (S) -> (
	indices := first regex(///\`[:space:]*.[^+-]*///,S);
	return { value substring(first indices, last indices,S), value S};
	--match from the start of the string all whitespace, one
	--non-white space character and then everything until the +/-
)

gfanParseIdeals = method()
gfanParseIdeals String := (s) -> (
	--needs to be simplified
	G := separate("\n,",s);
	firstLine := G#0;
	firstLine = separate("\n", firstLine);
	firstLine = drop(firstLine, 1);  -- remove the ring from the first line
	tempStr  := "";
	scan(firstLine, t -> tempStr = concatenate(tempStr, "\n", t)); -- build the firstline

	G = drop(G,1);  -- drop the old first entry
	G = prepend(tempStr, G); -- and then add the first entry minus the ring
	H := apply(G, t -> replace(///[\{\}]*///,"",t));
	apply(H, s -> value("{"|s|"}"))
)

gfanParseIdeal = method()
gfanParseIdeal String := (s) -> (
	G := separate("]",s);
	G = drop(G,1);
	value concatenate G 
)

gfanParseMarkedIdeal = method()
gfanParseMarkedIdeal String := (s) -> (
	G := separate("]",s);
	G = drop(G,1);
	transpose apply(gfanParseList(concatenate G), p -> gfanParseMarkedPoly(p))
)

gfanParseMarkedIdeals = method()
gfanParseMarkedIdeals String := (s) -> (
	G := separate("]",s);
	G = drop(G,1);
	apply(gfanParseList(concatenate G), L -> transpose apply(L, p -> gfanParseMarkedPoly(p)))
)

gfanParseMPL = method()
gfanParseMPL String := (s) -> (
	G := separate("]",s);
	G = drop(G,1);
	new MarkedPolynomialList from 
		transpose apply(gfanParseList(concatenate G), p -> gfanParseMarkedPoly(p))
)

gfanParseLMPL = method()
gfanParseLMPL String := (s) -> (
	G := separate("]",s);
	G = drop(G,1);
	apply(gfanParseList(concatenate G), L -> 
		new MarkedPolynomialList from transpose apply(L, p -> gfanParseMarkedPoly(p)))
)

gfanParseMPLPair = method()
gfanParseMPLPair String := (s) -> (
	G := separate("\n",s);
	G = drop(G,1); -- drop the ring
	L := gfanParseList("{"| replace(///\{///, ",{", concatenate G ) | "}");
	P := {apply(L#1, gfanParseMarkedPoly), apply(L#2, gfanParseMarkedPoly)};
	apply(P, c -> new MarkedPolynomialList from transpose c)
)

gfanParseIdealPair = method()
gfanParseIdealPair String := (s) -> (
	G := separate("\n",s);
	G = drop(G,1);
	drop(value ("{"| replace(///\{///, ",{", concatenate G ) | "}"), 1)
)

gfanParseMarkedIdealPair = method()
gfanParseMarkedIdealPair String := (s) -> (
	G := separate("\n",s);
	G = concatenate drop(G,1);
	apply(drop(regex(///(\{[^\}]*\})(\{[^\}]*\})///, G),1), i-> transpose apply(gfanParseList(substring(first i, last i, G)), p-> gfanParseMarkedPoly(p)))
)

gfanParseInteger = method()
gfanParseInteger String := (s) -> value s

gfanParseBool = method()
gfanParseBool String := (s) -> s == "true\n"

gfanParseBoolInteger = method()
gfanParseBoolInteger String := (s) -> s == "1\n"


gfanSymbolToString = method()
gfanSymbolToString Symbol := (X) -> (
	toString(X) | "\n"  
	--- toExternalString will write the word symbol if X is assigned
	--- and this is not desireable
)

gfanIdealToString = method()
gfanIdealToString Ideal := (I) -> (
	out := "{";
	n := numgens I - 1;
	for i from 0 to n do (
		out = out | toExternalString(I_i);
		if i < n then out = out | "," else out = out | "}";
	out = out | newline;
	);
	return out;
)

gfanPolynomialListToString = method()
gfanPolynomialListToString List := (L) -> (
	out := "{";
	n := #L - 1;
	for i from 0 to n do (
		out = out | toExternalString(L#i);
		if i < n then out = out | "," else out = out | "}";
		out = out | newline;
	);
	return out;
)

gfanMPLToString = method()
gfanMPLToString List := (L) -> (
	L = transpose L;
	out := "{";
	n := #L - 1;
	for i from 0 to n do (
		out = out | toExternalString(first L#i);
		if (last L#i) - (first L#i) != 0 then 
			out = out | " + " | toExternalString((last L#i) - (first L#i));
		if i < n then out = out | "," else out = out | "}";
		out = out | newline;
	);
	return out;
)

gfanPairOfPolynomialListsToString = method()
gfanPairOfPolynomialListsToString (List, List) := (L,K) -> (
	return "{" | gfanPolynomialListToString(L)
		| gfanPolynomialListToString(K)
		| "}\n"; -- note there is no comma. Is this a bug in gfan?
)

gfanListOfPolynomialListsToString = method()
gfanListOfPolynomialListsToString := (L) -> (
	out := "{";
	n := #L - 1;
	for i from 0 to n do (
		out = out | gfanPolynomialListToString(L#i);
		if i < n then out = out | "," else out = out | "}";
		out = out | newline;
	);
	return out;
)

--list of marked polynomial lists to string
gfanLMPLToString = method()
gfanLMPLToString := (L) -> (
	out := "{";
	n := #L - 1;
	for i from 0 to n do (
		out = out | gfanMPLToString(L#i);
		if i < n then out = out | "," else out = out | "}";
		out = out | newline;
	);
	return out;
)

gfanSymmetriesToString = method()
gfanSymmetriesToString := (L) -> (
	if L === null then return "";
	out := "{";
	n := #L - 1;
	for i from 0 to n do (
		out = out | gfanSymmetryToString(L#i);
		if i < n then out = out | "," else out = out | "}";
		out = out | newline;
	);
	return out;
)

gfanSymmetryToString = method()
gfanSymmetryToString List := (L) -> (
	if L === null then return "";
	out := "(";
	n := #L - 1;
	for i from 0 to n do (
		out = out | toExternalString(L#i);
		if i < n then out = out | "," else out = out | ")";
		out = out | newline;
	);
	return out;
)

gfanIntegerListToString = method()
gfanIntegerListToString := (L) -> if L === null then ""  else toString L

gfanRingToString = method()
gfanRingToString PolynomialRing := (R) -> (
	p := char R;
	out := if p === 0 then "Q" else "Z/"|p|"Z";
	out = out | toExternalString(new Array from gens R) | newline;
	return out;
)

gfanMPLToRingToString = method()
gfanMPLToRingToString List := (L) -> (
	R := ring first last L; 
	p := char R;
	out := if p === 0 then "Q" else "Z/"|p|"Z";
	out = out | toExternalString(new Array from gens R) | newline;
	return out;
)


--------------------------------------------------------
-- gfanArgumentToString
--------------------------------------------------------

gfanArgumentToString = method()
gfanArgumentToString (String, String, Thing) := (cmd, key, value) -> (
	if value === null or value === false then 
		return "";

	cmdLineValue := false; -- whether a value is passed on the commandline
	if cmdLineArgs#?cmd and member(key, cmdLineArgs#cmd) then
		cmdLineValue = true;

	" " | argStrs#key | (if cmdLineValue then " " | value else "")
)


--------------------------------------------------------
-- runGfanCommand
--------------------------------------------------------

runGfanCommand = (cmd, opts, data) -> (
	tmpName := temporaryFileName();
	if gfanVerbose then << "using temporary file " << tmpName << endl;
	args = concatenate apply(keys opts, key -> gfanArgumentToString(cmd, key, opts#key));
	ex = gfanPath | cmd | args | " < " | tmpName | " > " | tmpName | ".out";
	tmpFile := openOut tmpName;
	tmpFile << data << close;
	if gfanVerbose then << ex << endl;
	run ex;
	get(tmpName | ".out")
)

runGfanCommandCaptureError = (cmd, argStrs, args, data) -> (
	tmpName := temporaryFileName();
	if gfanVerbose then << "using temporary file " << tmpName << endl;
	args = concatenate toList apply(#argStrs, i-> if args#i then " " | argStrs#i else "");
	ex = gfanPath | cmd | args | " < " | tmpName | " 2> " | tmpName | ".out";
	tmpFile := openOut tmpName;
	tmpFile << data << close;
	if gfanVerbose then << ex << endl;
	run ex;
	get(tmpName | ".out")
)


---------------------------------------------------
-- Information on functions and arguments
--------------------------------------------------

-- Fix capitalization
argFuncs = {
	"d" => {gfanRenderStaircase, gfanTropicalStartingCone},
	"e" => {gfan},
	"g" => {gfan,gfanBuchberger,gfanTropicalStartingCone},
	"h" => {gfanToLatex,gfanTropicalBasis},
	"i" => {gfanHomogenize},
	"m" => {gfanLeadingTerms,gfanRenderStaircase},
	"L" => {gfanRender},
	"r" => {gfanBuchberger},
	"s" => {gfanPolynomialSetUnion},
	"t" => {gfanTropicalIntersection},
	"w" => {gfanBuchberger,gfanHomogenize,gfanRenderStaircase},
	"W" => {gfanBuchberger},
	"asfan" => {gfanGroebnerCone},
	"disableSymmetryTest" => {gfan},
	--missing help
	"ideal" => {gfanInitialForms},
	"noincidence" => {gfanTropicalTraverse},
	"pair" => {gfanGroebnerCone, gfanInitialForms},
	"polynomialset" => {gfanToLatex},
	"polynomialsetlist" => {gfanToLatex},
	"restrict" => {gfanGroebnerCone,gfanToPolyhedralFan},
	"shiftVariables" => {gfanRender},
	-- "subspace" => {gfan}, -- missing v0.4
	"symmetry" => {gfan,gfanTropicalTraverse,gfanToPolyhedralFan},
	"tplane" => {gfanTropicalIntersection},
}

-- Fix capitalization
argStrs = hashTable {
	"d" => "-d",
	"e" => "-e",
	"g" => "-g",
	"h" => "-h",
	"i" => "-i",
	"i1" => "-i1", -- should these be removed?
	"i2" => "-i2", -- ibid
	"L" => "-L",
	"m" => "-m",
	"n" => "-n",
	"M2" => "-M2",
	"r" => "-r",
	"s" => "-s",
	"t" => "-t",
	"w" => "-w",
	"W" => "-W",
	"asfan" => "--asfan",
	"disableSymmetryTest" => "--disablesymmetrytest",
	"dressian" => "--dressian",
	"help" => "--help",
	"ideal" => "--ideal",
	"kapranov" => "--kapranov",
	"mark" => "--mark",
	"names" => "--names",
	"nocones" => "--nocones",
	"noincidence" => "--noincidence",
	"pair" => "--pair",
	"pluckersymmetries" => "--pluckersymmetries",
	"polynomialset" => "--polynomialset",
	"polynomialsetlist" => "--polynomialsetlist",
	"restrict" => "--restrict",
	"scale" => "--scale",
	"shiftVariables" => "--shiftVariables",
	"star" => "--star",
	"symmetry" => "--symmetry",
	"symmetryExploit" => "--symmetryExploit",
	"symmetryPrinting" => "--symmetryPrinting",
	"symsigns" => "--symsigns",
	-- "subspace" => "--subspace", -- missing in v0.4
	"tplane" => "--tplane",
	"trees" => "--trees",
	"unimodular" => "--unimodular",
	"vectorinput" => "--vectorinput",
	"xml" => "--xml"
};


---------------------------------------------------------
-- cmdLineArgs
-- Describes which functions have command line arguments
-- that take values on the command line and not on stdin.
-- Used by gfanArgumentToString
---------------------------------------------------------
cmdLineArgs = hashTable { 
	"gfanRender" => { "shiftVariables" },
	"gfanRenderStaircase" => { "d", "w" }
}


--------------------------------------------------------
--------------------------------------------------------
-- GFAN HOOKS START HERE 
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
-- gfan
--------------------------------------------------------

gfan = method( Options => {
	"g" => false, 
	"symmetry" => null, 
	"e" => false, 
	-- "subspace" => false,  -- missing from v0.4
	"disableSymmetryTest" => false
	}
)

gfan Ideal := opts -> (I) -> (
	if opts#"g" then error "Polynomials must be marked for the -g option";
	input := gfanRingToString(ring I) 
		| gfanIdealToString(I) 
		| gfanSymmetriesToString(opts#"symmetry");
	gfanParseLMPL runGfanCommand("gfan", opts, input)
)

gfan MarkedPolynomialList := opts -> (L) -> (
	input := gfanMPLToRingToString(L)
		| gfanMPLToString(L) 
		| gfanSymmetriesToString(opts#"symmetry");
	gfanParseLMPL runGfanCommand("gfan", opts, input)
)

gfan List := opts -> (L) -> (
	if opts#"g" then error "Polynomials must be marked for the -g option";
	input := gfanRingToString(ring first L)
		| gfanPolynomialListToString(L) 
		| gfanSymmetriesToString(opts#"symmetry");
	gfanParseLMPL runGfanCommand("gfan", opts, input)
)

--------------------------------------------------------
-- gfan_buchberger
--------------------------------------------------------

gfanBuchberger = method( Options => {
	"w"=>null, 
	"r"=>false, 
	"W"=>false, 
	"g"=>false
	}
)

gfanBuchberger List := opts -> (L) -> (
	input := gfanRingToString(ring first L) 
		| gfanPolynomialListToString(L) 
		| gfanIntegerListToString(opts#"w");
	gfanParseMPL runGfanCommand("gfan_buchberger", opts, input)
)

gfanBuchberger Ideal := opts -> (I) -> (
	gfanBuchberger(flatten entries gens I, opts)
)

gfanBuchberger MarkedPolynomialList := opts -> (L) -> (
	gfanBuchberger(last L, opts)
)

--------------------------------------------------------
-- gfan_doesidealcontain
--------------------------------------------------------

gfanDoesIdealContain = method(Options=>{})
gfanDoesIdealContain (MarkedPolynomialList, List) := opts -> (I,J) -> (
	input := gfanMPLToRingToString(I) 
		| gfanMPLToString(I) 
		| gfanPolynomialListToString(J);
	gfanParseBoolInteger runGfanCommand("gfan_doesidealcontain", opts, input)
)

--------------------------------------------------------
-- gfan_fancommonrefinement
--------------------------------------------------------

gfanFanCommonRefinement = method( Options => {
	"i1" => null,  -- should these be arguments instead?
	"i2" => null
	}
)

gfanFanCommonRefinement (String, String) := opts -> (F,G) -> (
	-- version 0.4
)

--------------------------------------------------------
-- gfan_fanlink
--------------------------------------------------------

gfanFanLink = method( Options => {
	"i" => null,  -- should this be an argument instead?
	"symmetry" => null,
	"star" => false
	}
)

gfanFanLink (String, List) := opts -> (F,V) -> (
	-- version 0.4
)

--------------------------------------------------------
-- gfan_fanproduct
--------------------------------------------------------

gfanFanProduct = method( Options => {
	"i1" => null,  -- should this be an argument instead?
	"i2" => null,
	}
)

gfanFanProduct (String, String) := opts -> (F,G) -> (
	-- version 0.4
)


--------------------------------------------------------
-- gfan_groebnercone
--------------------------------------------------------

gfanGroebnerCone = method( Options => {
	"restrict" => false,
	"pair" => false,
	"asfan" => false,
	"xml" => false,
	"vectorinput" => false
	}
)

gfanGroebnerCone (MarkedPolynomialList, MarkedPolynomialList) := opts -> (L,M) -> (
	if not opts#"pair" then (
		if gfanVerbose then 
			 << "Using --pair option for gfanGroebnerCone." << endl;
		opts = opts ++ {"pair" => true};
	);

	if gfanMPLToRingToString(L) != gfanMPLToRingToString(M) then (
		error("The arguments to gfanGroebnerCone should be defined over the same ring.");
	);

	input := gfanMPLToRingToString(L) 
		| gfanMPLToString(L) 
		| gfanMPLToString(M);
	runGfanCommand("gfan_groebnercone", opts, input) -- PARSE POLYNOMIAL DATA
)

gfanGroebnerCone MarkedPolynomialList := opts -> (L) -> (
	if opts#"pair" then
		error("The pair option for gfanGroebnerCone should be used along with " 
			| "two MarkedPolynomialLists as arguments.");
	input := gfanMPLToRingToString(L) 
		| gfanMPLToString(L);
	runGfanCommand("gfan_groebnercone", opts, input) -- PARSE POLYNOMIAL DATA
)

--------------------------------------------------------
-- gfan_homogeneityspace
--------------------------------------------------------

gfanHomogeneitySpace = method(Options=>{})

gfanHomogeneitySpace (List) := opts -> (L) -> (
	input := gfanRingToString(ring first L) | gfanPolynomialListToString(L);
	runGfanCommand("gfan_homogeneityspace", opts, input) -- should be parsed
)

gfanHomogeneitySpace (MarkedPolynomialList) := opts -> (L) -> (
	gfanHomogeneitySpace(last L)
)

--------------------------------------------------------
-- gfan_homogenize
--------------------------------------------------------

gfanHomogenize = method( Options => {
	"i"=>false,
	"w"=>false
	}
)

gfanHomogenize (List, Symbol) := opts -> (L,X) -> (
	input := gfanRingToString(ring first L) 
		| gfanPolynomialListToString(L) 
		| gfanSymbolToString(X) 
		| gfanIntegerListToString(opts#"w");
	out := runGfanCommand("gfan_homogenize", opts, input);
	R := ring first L;
	S := R[X];
	gfanParseIdeal(out)
)

gfanHomogenize (MarkedPolynomialList, Symbol) := opts -> (L,X) -> (
	input := gfanMPLToRingToString(L) 
		| gfanMPLToString(L) 
		| gfanSymbolToString(X) 
		| gfanIntegerListToString(opts#"w");
	out := runGfanCommand("gfan_homogenize", opts, input);
	R := ring first first L;
	S := R[X];
	gfanParseMPL(out)
)


--------------------------------------------------------
-- gfan_initialforms
--------------------------------------------------------

--Dear Mike:
--If --ideal is used, does the output need to be marked? Note, it is a GB wrt W.
--Does --pair make sense without --ideal? Probably not.
--Does --pair and --ideal need to be marked? I would assume so.
--So, is no --pair and no --ideal the only case where the output is not marked?

--Hey! Version 0.4 clarifies this.

gfanInitialForms = method( Options => {
	"ideal" => false,
	"pair" => false,
	"mark" => false
	}
)

gfanInitialForms (List, List) := opts -> (L,W) -> (
	input := gfanRingToString(ring first L) 
		| gfanPolynomialListToString(L) 
		| gfanIntegerListToString(W);
	if opts#"pair" then
		gfanParseIdealPair runGfanCommand("gfan_initialforms", opts, input)
	else 
		gfanParseIdeal runGfanCommand("gfan_initialforms", opts, input)
)

gfanInitialForms (MarkedPolynomialList, List) := opts -> (L,W) -> (
	input := gfanMPLToRingToString(L) 
		| gfanMPLToString(L) 
		| gfanIntegerListToString(W);
	if opts#"pair" then
		gfanParseMPLPair runGfanCommand("gfan_initialforms", opts, input)
	else 
		gfanParseMPL runGfanCommand("gfan_initialforms", opts, input)
)

--------------------------------------------------------
-- gfan_interactive
--------------------------------------------------------

gfanInteractive = method( Options => {} )

gfanInteractive := opts -> () -> (
	error "Not implemented";
)

--------------------------------------------------------
-- gfan_ismarkedgroebnerbasis
--------------------------------------------------------

gfanIsMarkedGroebnerBasis = method( Options => {} )

gfanIsMarkedGroebnerBasis (MarkedPolynomialList) := opts -> (L) -> (
	input := gfanMPLToRingToString(L) 
		| gfanMPLToString(L);
	gfanParseBool runGfanCommand("gfan_ismarkedgroebnerbasis", opts, input)
)


--------------------------------------------------------
-- gfan_krulldimension
--------------------------------------------------------

gfanKrullDimension = method( Options => {} )

gfanKrullDimension (List) := opts -> (L) -> (
	input := gfanMPLToRingToString(L) 
		| gfanMPLToString(L);
	gfanParseInteger runGfanCommand("gfan_krulldimension", opts, input)
)


--------------------------------------------------------
-- gfan_latticeideal
--------------------------------------------------------

gfanLatticeIdeal = method( Options => {
	"t" => false
	}
)

gfanLatticeIdeal (List) := opts -> (L) -> (
	--version 0.4
)


--------------------------------------------------------
-- gfan_leadingterms
--------------------------------------------------------

gfanLeadingTerms = method( Options => { 
	"m" => false 
	} 
)

gfanLeadingTerms (List) := opts -> (L) -> (
	input := "";
	if opts#"m" then (
		input = gfanMPLToRingToString(first L) | gfanLMPLToString(L);
		return gfanParseIdeals runGfanCommand("gfan_leadingterms", opts, input);
	) else (
		input = gfanMPLToRingToString(L) | gfanMPLToString(L);
		return gfanParseIdeal runGfanCommand("gfan_leadingterms", opts, input);
	)
)


--------------------------------------------------------
-- gfan_markpolynomialset
--------------------------------------------------------

gfanMarkPolynomialSet = method( Options => {} )

gfanMarkPolynomialSet (List, List) := opts -> (L,W) -> (
	input := gfanRingToString(ring first L) 
		| gfanPolynomialListToString(L) 
		| gfanIntegerListToString(W);
	gfanParseMarkedIdeal runGfanCommand("gfan_markpolynomialset", opts, input)
)


--------------------------------------------------------
-- gfan_minkowskisum
--------------------------------------------------------

gfanMinkowskiSum = method( Options => {
	"symmetry" => null,
	"disableSymmetryTest" => false,
	"nocones" => false
	}
)

gfanMinkowskiSum (List) := opts -> (L) -> (
	--version 0.4
)

--------------------------------------------------------
-- gfan_minors
--------------------------------------------------------

gfanMinors = method( Options => {
	"r" => null, -- these should be arguments
	"d" => null, -- ibid
	"n" => null, -- "
	"M2" => false,
	"names" => null,
	"dressian" => null,
	"pluckersymmetries" => null
	}
)

gfanMinors (ZZ,ZZ,ZZ) := opts -> (r,d,n) -> (
	--version 0.4
)


--------------------------------------------------------
-- gfan_polynomialsetunion
--------------------------------------------------------

--Should this be marked?
gfanPolynomialSetUnion = method( Options => { 
	"s"=>false 
	}
)

gfanPolynomialSetUnion (List,List) := opts -> (L,K) -> (
	input := gfanRingToString(ring first L) 
		| gfanPairOfPolynomialListsToString(L,K);
	gfanParseIdeal runGfanCommand("gfan_polynomialsetunion", opts, input)
)


--------------------------------------------------------
-- gfan_render
--------------------------------------------------------

gfanRender = method( Options => {
	"L" => false,
	"shiftVariables" => 0,
	}
)

gfanRender (List) := opts -> (L) -> (
	argStrs := {"-L", "--shiftVariables " | opts#"shiftVariables", "--help"};
	args := {opts#"L", opts#"shiftVariables" != 0, opts#"help"};
	out := runGfanCommand("gfan_render",
		argStrs, args,
		gfanMPLToRingToString(first L) | gfanLMPLToString(L));
	if opts#"help" then return out;
	fileName = temporaryFileName();
	figure = openOut(fileName | ".fig");
	figure << out << close;
	<< "Figure rendered to " << fileName << ".fig" << endl;
	if fig2devPath != "" then	(
	run fig2devPath | "fig2dev -Lpng " | fileName  | ".fig " | fileName |".png";
	<< "Figure converted to png: " << fileName << ".png" << endl;
	show URL("file://" | fileName | ".png");
	) else << "fig2dev path not set." << endl ;
)


--------------------------------------------------------
-- gfan_renderstaircase
--------------------------------------------------------

gfanRenderStaircase = method( Options=> {
	"m"=>false,
	"d"=>8,
	"w"=>5
	}
)
gfanRenderStaircase (List) := opts -> (L) -> (
	argStrs := {"-m", "-d " | opts#"d", "-w " | opts#"w", "--help"};
	args := {opts#"m", opts#"d" != 8, opts#"w" != 5, opts#"help"};
	out := if opts#"m" then
		runGfanCommand("gfan_renderstaircase",
			argStrs, args,
			gfanMPLToRingToString(first L) | gfanLMPLToString(L))
	else
		runGfanCommand("gfan_renderstaircase",
			argStrs, args,
			gfanMPLToRingToString(L) | gfanMPLToString(L));
	if opts#"help" then return out;
	fileName = temporaryFileName();
	figure = openOut(fileName | ".fig");
	figure << out << close;
	<< "Figure rendered to " << fileName << ".fig" << endl;
	if fig2devPath != "" then	(
		run fig2devPath | "fig2dev -Lpng " | fileName  | ".fig " | fileName |".png";
		<< "Figure converted to png: " << fileName << ".png" << endl;
		show URL("file://" | fileName | ".png");
	) else << "fig2dev path not set." << endl ;
)

--------------------------------------------------------
-- gfan_saturation
--------------------------------------------------------

gfanSaturation = method( Options => {
	"h" => false
	}
)

gfanSaturation (Ideal) := opts -> (I) -> (
	input := gfanRingToString(ring I) | gfanIdealToString(I);
	gfanParseIdeal runGfanCommand("gfan_saturation", opts, input)
)

--------------------------------------------------------
-- gfan_secondaryfan
--------------------------------------------------------

gfanSecondaryFan = method( Options => {
	"unimodular" => false,
	"scale" => null,
	"symmetry" => null
	}
)

gfanSecondaryFan (List) := opts -> (L) -> (
	--version 0.4
)

--------------------------------------------------------
-- gfan_stats
--------------------------------------------------------

gfanStats = method( Options => {} )

gfanStats (List) := opts -> (L) -> (
	input := gfanMPLToRingToString(first L) 
		| gfanLMPLToString(L);
	runGfanCommand("gfan_stats", opts, input) -- Parse this?
)

--------------------------------------------------------
-- gfan_substitute
--------------------------------------------------------

gfanSubstitute = method( Options => {} )

gfanSubstitute (List, PolynomialRing) := opts -> (L,R) -> (
	input := gfanMPLToRingToString(L) | gfanMPLToString(L) | gfanRingToString(R);
	gfanParseMarkedIdeal runGfanCommand("gfan_substitute", opts, input)
)


--------------------------------------------------------
-- gfan_tolatex
--------------------------------------------------------

gfanToLatex = method( Options => { 
	"h" => false,
	"polynomialset" => false,
	"polynomialsetlist" => false
	}
)

gfanToLatex (List) := opts -> (L) -> (
	if opts#"polynomialsetlist" then (
		return runGfanCommand("gfan_tolatex", opts, gfanLMPLToString(L));
	) else (
		return runGfanCommand("gfan_tolatex", opts,  gfanMPLToString(L));
	);
)

--------------------------------------------------------
-- gfan_topolyhedralfan
--------------------------------------------------------

gfanToPolyhedralFan = method( Options => {
	"restrict" => false,
	"symmetry" => null
	}
)

gfanToPolyhedralFan List := opts -> (L) -> (
	input := gfanMPLToRingToString(first L) 
		| gfanSymmetriesToString(opts#"symmetry") 
		| gfanLMPLToString(L);
	runGfanCommand("gfan_topolyhedralfan", opts, input) --- PARSE AS POLYHEDRAL DATA
)

--------------------------------------------------------
-- gfan_tropicalbasis
--------------------------------------------------------

gfanTropicalBasis = method( Options => {
	"h"=>false
	}
)

gfanTropicalBasis (Ideal) := opts -> (I) -> (
	input := gfanRingToString(ring I) 
		| gfanIdealToString(I);
	gfanParseIdeal runGfanCommand("gfan_tropicalbasis", opts, input) -- should this be marked?
)


--------------------------------------------------------
-- gfan_tropicalbruteforce
--------------------------------------------------------

gfanTropicalBruteForce = method( Options => {} )

gfanTropicalBruteForce List := opts -> (L) -> (
	input := gfanMPLToRingToString(L) | gfanMPLToString(L);
	runGfanCommand("gfan_tropicalbruteforce", opts, input) ---- PARSE AS POLYHEDRAL DATA
)


--------------------------------------------------------
-- gfan_tropicalevaluation
--------------------------------------------------------

gfanTropicalEvaluation = method( Options => {} )

gfanTropicalEvaluation List := opts -> (L) -> (
	--v0.4 -- note that the arguments are probably wrong.
)


--------------------------------------------------------
-- gfan_tropicalfunction
--------------------------------------------------------

gfanTropicalFunction = method( Options => {} )

gfanTropicalFunction Ideal := opts -> (I) -> (
	--v0.4 -- note that the arguments are probably wrong.
)


--------------------------------------------------------
-- gfan_tropicalhypersurface
--------------------------------------------------------

gfanTropicalHyperSurface = method( Options => {} )

gfanTropicalHyperSurface Ideal := opts -> (I) -> (
	--v0.4 -- note that the arguments are probably wrong.
)


--------------------------------------------------------
-- gfan_tropicalintersection
--------------------------------------------------------

gfanTropicalIntersection = method( Options => {
	"t" => false,
	"tplane" => false,
	"symmetryPrinting" => false,
	"symmetryExploit" => false,
	"restrict" => false
	}
)

gfanTropicalIntersection (List) := opts -> (L) -> (
	input := gfanRingToString(ring first L) | gfanPolynomialListToString(L);
	runGfanCommand("gfan_tropicalintersection", opts, input) -- should this be parsed?
)

--------------------------------------------------------
-- gfan_tropiciallifting
--------------------------------------------------------

gfanTropicalLifting = method( Options => {} )

gfanTropicalLifting := opts -> () -> (
	error "Not implemented";
)

--------------------------------------------------------
-- gfan_tropiciallinearspace
--------------------------------------------------------

gfanTropicalLinearSpace = method( Options => {
	"trees" => false
	}
)

gfanTropicalLinearSpace (ZZ, ZZ) := opts -> (n, d) -> (
	--v0.4
)


--------------------------------------------------------
-- gfan_tropicalmultiplicity
--------------------------------------------------------

gfanTropicalMultiplicity = method( Options => {} )

gfanTropicalMultiplicity (List) := opts -> (L) -> (
	input := gfanMPLToRingToString(L) | gfanMPLToString(L);
	gfanParseInteger runGfanCommand("gfan_tropicalmultiplicity", opts, input)
)

--------------------------------------------------------
-- gfan_tropicalrank
--------------------------------------------------------

gfanTropicalRank = method( Options => {
	"kapranov" => false
	}
)

gfanTropicalRank (Matrix) := opts -> (M) -> (
	--v0.4
)

--------------------------------------------------------
-- gfan_tropicalstartingcone
--------------------------------------------------------

gfanTropicalStartingCone = method( Options => {
	"g" => false, 
	"d" => false
	}
)

gfanTropicalStartingCone (List) := opts -> (L) -> (
	input := gfanRingToString(ring first L) | gfanPolynomialListToString(L);
	gfanParseMarkedIdealPair runGfanCommand("gfan_tropicalstartingcone", opts, input)
)


--------------------------------------------------------
-- gfan_tropicaltraverse
--------------------------------------------------------

gfanTropicalTraverse = method( Options => {
	"symmetry"=>false,
	"symsigns"=>false,
	"noincidence"=>false
	}
)

gfanTropicalTraverse (List) := opts -> (L) -> (
	input := gfanMPLToRingToString(first L) 
		| gfanMPLToString(first L) 
		| gfanMPLToString(last L)
		| gfanSymmetriesToString(S);
	runGfanCommand("gfan_tropicaltraverse", opts, input) --- PARSE POLYHEDRAL DATA
)


--------------------------------------------------------
-- gfan_tropicalweildivisor
--------------------------------------------------------

gfanTropicalWeilDivisor = method( Options => {
	"i1" => null,  -- perhaps these should be removed
	"i2" => null
	}
)

gfanTropicalTraverse (String, String) := opts -> (F,G) -> (
	--v0.4
)


--------------------------------------------------------
-- Documentation
--------------------------------------------------------

beginDocumentation()

gfanFunctions = hashTable {
	gfan => "gfan", 
	gfanBuchberger => "gfan_buchberger",
	gfanDoesIdealContain => "gfan_doesidealcontain",
	gfanFanCommonRefinement => "gfan_fancommonrefinement", -- v0.4
	gfanFanLink => "gfan_fanlink", -- v0.4
	gfanFanProduct => "gfan_fanproduct", -- v0.4
	gfanGroebnerCone => "gfan_groebnercone",
	gfanHomogeneitySpace => "gfan_homogeneityspace",
	gfanHomogenize => "gfan_homogenize",
	gfanInitialForms => "gfan_initialforms",
	gfanInteractive => "gfan_interactive",
	gfanIsMarkedGroebnerBasis => "gfan_ismarkedgroebnerbasis",
	gfanKrullDimension => "gfan_krulldimension",
	gfanLatticeIdeal => "gfan_latticeideal", -- v0.4
	gfanLeadingTerms => "gfan_leadingterms",
	gfanMarkPolynomialSet => "gfan_markpolynomialset",
	gfanMinkowskiSum => "gfan_minkowskisum", -- v0.4
	gfanMinors => "gfan_minors", -- v0.4
	gfanPolynomialSetUnion => "gfan_polynomialsetunion",
	gfanRender => "gfan_render", 
	gfanRenderStaircase => "gfan_renderstaircase", 
	gfanSaturation => "gfan_saturation",
	gfanSecondaryFan => "gfan_secondaryfan", -- v0.4
	gfanStats => "gfan_stats",
	gfanSubstitute => "gfan_substitute",
	gfanToLatex => "gfan_tolatex",
	gfanToPolyhedralFan => "gfan_topolyhedralfan",
	gfanTropicalBasis => "gfan_tropicalbasis",
	gfanTropicalBruteForce => "gfan_tropicalbruteforce",
	gfanTropicalEvaluation => "gfan_tropicalevaluation", -- v0.4
	gfanTropicalFunction => "gfan_tropicalfunction", -- v0.4
	gfanTropicalHyperSurface => "gfan_tropicalhypersurface", -- v0.4
	gfanTropicalIntersection => "gfan_tropicalintersection",
	gfanTropicalLifting => "gfan_tropicallifting",
	gfanTropicalLinearSpace => "gfan_tropicallinearspace", -- v0.4
	gfanTropicalMultiplicity => "gfan_tropicalmultiplicity",
	gfanTropicalRank => "gfan_tropicalrank", -- v0.4
	gfanTropicalStartingCone => "gfan_tropicalstartingcone",
	gfanTropicalTraverse => "gfan_tropicaltraverse",
	gfanTropicalWeilDivisor => "gfan_tropicalweildivisor" -- v0.4
}

gfanHelp = hashTable apply(keys gfanFunctions, fn -> 
	gfanFunctions#fn => apply( lines runGfanCommandCaptureError(gfanFunctions#fn, {"--help"}, {true}, "") , l->PARA {l}) 
)

doc ///
	Key
		"gfanInterface2"
	Headline
		a Macaulay2 interface to gfan
	Description
		Text
			@EM "gfanInterface2"@ is an interface to Anders Jenssen's gfan package, which is a C++
			program to compute the Groebner fan (i.e. all the initial ideals) of an ideal.

			The main function in this package is @TO gfan@ which computes all of the Groebner 
			bases and initial ideals of a given ideal.  A useful feature of this function is 
			that it can handle symmetries in the ideal. If you want the geometric information 
			of this list of Groebner basis, see @TO gfanGroebnerCone@.

			Most of the functions in gfanInterface2 required marked Groebner bases as input. 
			We represent marked Groebner bases as pairs of lists, where the first list 
			contains the monomial leading terms of the Groebner basis in the second list. 
			See @TO "Marked Groebner Basis Example"@ for more details.

			New users should read the following guides:

			@TO "Installation and Configuration of gfanInterface2"@

			@TO "Conventions for calling methods with options"@

			Most of functions in the gfan package are accessible through this interface.
			If you wish to use one whose interface is not included here send a message to 
			the package author. Also, please feel free to suggest changes to the
			parameter types and return types of each method. 
///

doc ///
	Key
		"Marked Groebner Basis Example"
	Description
		Text
			A marked Groebner basis is a set of polynomials which forms a 
			Groebner basis in which the leading terms of each polynomial have been
			distinguished.

			In gfan, the leading terms of polynomials are marked by writing them first. 
			For example, the leading term of @TEX "$y^2 + x^2 + z^2$"@ is @TEX "$y^2$"@ as 
			it appears first. In Macaulay 2, polynomials are sorted based on the term 
			order of the ring and so distinguished terms are lost if they do not correspond 
			to the current ring's term order.

		Example
			QQ[x,y,z];
			y^2 + x^2 + z^2

		Text
			In {\tt gfanInterface2}, we represent marked Groebner bases using a list 
			of leading terms and a second list of the Groebner basis itself. 
			For example, we take a list of polynomials and call @TO gfanMarkPolynomialSet@ 
			which takes a list of polynomials and a weight vector and returns a list of 
			marked polynomials. In this case, the leading term is first computed using 
			the weight vector and then lexicographic order to break ties.

		Example
			QQ[x,y,z];
			gfanMarkPolynomialSet({x*y^3+z^4, x^2*z^2 + y^3*z}, {-1,2,5})

///

doc ///
	Key
		"Installation and Configuration of gfanInterface2"
	Description
		Text
			In order to use the {\tt gfanInterface2} in Macaulay 2, {\tt gfan} by Anders Jenssen
			must already be installed. In addition, {\tt gfanInterface2} must know the path
			of the {\tt gfan} executables. This can be specified when loading the package:

		Example
			loadPackage("gfanInterface2", Configuration => { "path" => "/directory/to/gfan/"})

		Text
			The path to the executables should end in a slash. 
			To set the path permanently, one needs to change 
			{\tt gfanInterface2.m2} either before installing or in the installed copy.
			You will find the path configuration near the top of the file.

			If {\tt gfanInterface2} is already installed and loaded, you can find the path
			of the source file by the following command:

		Example
			gfanInterface2#"source file"

		Text
			Finally, if you want to be able to render Groebner fans and monomial staircases
			to {\tt .png} files, you should install {\tt fig2dev} and specify its path
			as follows:

		Example
			loadPackage("gfanInterface2", Configuration => { "fig2devpath" => "/directory/to/fig2dev/"})

		Text
			Again, the path should end in a slash.
///


doc ///
	Key
		"Conventions for calling methods with options"
	Description
		Text
			In creating {\tt gfanInterface2} the objective has been to mirror
			the {\tt gfan} commands as closely as possible in Macaulay 2. 
			Many commands in {\tt gfan} allow command line options and these
			reproduced in {\tt gfanInterface2} as optional arguments. 

			For example, say we want to find the Groebner bases of 
			an ideal with symmetry. From the command line, one would
			type @TT "gfan --symmetry"@ and then give the ring, ideal and 
			symmetries of the ideal as input.

			In {\tt gfanInterface2} we pass the optional argument {\tt "symmetry"} the
			symmetries and provide the ideal as an argument.

		Example
			QQ[x,y,z]; 
			gfan(ideal(x^2*y -z, y^2*z - x, z^2*x - y), "symmetry" => {{0,1,2}, {1,2,0}})

		Text
			For each optional {\tt gfan} argument, the corresponding {\tt gfanInterface2}
			argument is obtained by simply removing the dashes.

			Here's another example. If we run {\tt gfanBuchberger} without a weight vector,
			it will use the lexicographic order.

		Example
			QQ[x,y,z];
			gfanBuchberger(ideal(x,y+z))

		Text
			If we want to use a different order, the {\tt gfan} documentation tells us to
			use the {\tt -w} argument. So, in Macaulay 2, we set the {\tt w} argument 
			to the desired weight vector.

		Example
			QQ[x,y,z];
			gfanBuchberger(ideal(x,y+z), "w" => {1,2,3})

		Text
			Many optional arguments to {\tt gfan} require no addition input. In this case,
			we set the optional argument in Macaulay 2 to be {\tt true}.
///

doc ///
	Key
		gfan
		(gfan, Ideal)
		(gfan, List)
		(gfan, MarkedPolynomialList)
	Headline
		all reduced Groebner bases of a polynomial ideal
	Usage
		G = gfan(I)
		G = gfan(L)
		G = gfan(M)
	Inputs
		I:Ideal
			contained in a polynomial ring
		L:List
			of polynomials
		M:MarkedPolynomialList
	Outputs 
		G:List
			all @TO2 {"Marked Groebner Basis Example", "marked reduced Groebner bases"}@ of {\tt I}, {\tt L}, or {\tt M}
	Description
		Text
			This method produces all reduced Groebner bases of a polynomial ideal. 
			The ideal can be given as an {\tt Ideal}, {\tt List} of polynomials, or
			a {\tt MarkedPolynomialList}. 
			The {\tt "g"=> true} option can be used to inform {\tt gfan} that the input
			is already a Groebner basis with respect to some monomial order. 
			However, in this case, the input must be a {\tt MarkedPolynomialList}.

		Example
			R = QQ[x,y,z]; 
			gfan(ideal(x^2*y -y^2, y^2*x - x^2))
			gfan({x^2*y -y^2, y^2*x - x^2}, "symmetry" => {{0,1,2}, {1,0,2}})
			gfan(markedPolynomialList {{y^5, x*y^2, x^2},{y^5-y^2,x*y^2 - y^4, x^2 -y^4}}, "g" => true)

		Text
			
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan"@
///

doc ///
	Key
		gfanBuchberger
		(gfanBuchberger, Ideal)
		(gfanBuchberger, List)
		(gfanBuchberger, MarkedPolynomialList)
	Headline
		reduced Groebner basis with respect to some monomial order
	Usage
		G = gfanBuchberger(I)
		G = gfanBuchberger(L)
		G = gfanBuchberger(M)
	Inputs
		I:Ideal
			contained in a polynomial ring
	Outputs
		G:MarkedPolynomialList
			a @TO2 {"Marked Groebner Basis Example", "marked reduced Groebner basis"}@ of {\tt I}
	Description
		Text
			This method computes a reduced Groebner basis of an ideal 
			with respect to the lexicographic order (by default) or with 
			respect to some weight vector if option {\tt w} is specified. The output
			is a {\tt MarkedPolynomialList}.
			The input can be given as an {\tt Ideal}, {\tt List} of polynomials, or 
			{\tt MarkedPolynomialList}. In the case of a {\tt MarkedPolynomialList},
			the marked terms are ignored.

		Example
			QQ[x,y,z];
			I = ideal(x*y + z, x*z + y);
			gfanBuchberger(I)
			gfanBuchberger(I, "w" => {1,2,3})
			gfanBuchberger({x*y + z, x*z +y}, "w" => {1,2,3})

		Text
			
			Note that Macaulay 2 can compute Groebner bases with respect to given
			weights without using gfan. 

		Example
			QQ[x,y,z, MonomialOrder => { Weights => {1,2,3}, Lex } ];
			G = gens gb ideal(x*y + z,  x*z + y )
			markedPolynomialList transpose  apply(flatten entries G, g-> {leadTerm g, g})

		Text
			
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_buchberger"@
///

doc ///
	Key
		gfanDoesIdealContain
		(gfanDoesIdealContain, MarkedPolynomialList, List)
	Headline
		check ideal membership by the division algorithm
	Usage
		B = gfanDoesIdealContain(L,K)
	Inputs
		L:MarkedPolynomialList
			a @TO2 {"Marked Groebner Basis Example", "marked Groebner basis"}@
		K:List
			a list of polynomials
	Outputs
		B:Boolean
			true if every polynomial in {\tt K} belongs to the ideal generated by {\tt L}
	Description
		Text
			This method determines if a list of polynomialsis contained in an ideal.
			Macaulay 2 provides this functionality in the @TO isSubset@ method.

		Example
			QQ[x,y,z];
			gfanDoesIdealContain(gfanBuchberger({x*y - y, x*z + z}), {y*z})
			isSubset(ideal(y*z), ideal(x*y - y, x*z +z))

		Text
			
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_doesidealcontain"@
///

doc ///
	Key
		gfanFanCommonRefinement
	Headline
		placeholder
	Usage
		placeholder
	Inputs
	Outputs
	Description
		Text
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_fancommonrefinement"@
///

doc ///
	Key
		gfanFanLink
	Headline
		placeholder
	Usage
		placeholder
	Inputs
	Outputs
	Description
		Text
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_fanlink"@
///

doc ///
	Key
		gfanFanProduct
	Headline
		placeholder
	Usage
		placeholder
	Inputs
	Outputs
	Description
		Text
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_fanproduct"@
///

doc ///
	Key
		gfanGroebnerCone
		(gfanGroebnerCone, MarkedPolynomialList)
		(gfanGroebnerCone, MarkedPolynomialList, MarkedPolynomialList)
	Headline
		polyhedral information about a Groebner cone
	Usage
		S = gfanGroebnerCone(L)
		S = gfanGroebnerCone(L, M)
	Inputs
		L:MarkedPolynomialList
			a marked reduced Groebner basis, or a minimal basis.
		M:MarkedPolynomialList
			a marked reduced Groebner basis.
	Outputs
		S:String
			a description of the Groebner cone of {\tt L}
	Description
		Text
			This method compute the Grobener cone of {\tt L} in the case where {\tt L} is
			a marked reduced Groebner basis. If {\tt L} is only a marked minimal basis, then
			a smaller cone is produced.

		Example
			QQ[x,y];
			gfanGroebnerCone( markedPolynomialList {{x}, {x+y}} )  

		Text
			
			In the above example any weights {\em w = a(1,1) + p (1,-1)} for a 
			a real number and {\em p >= 0} give {\em (x)} as the initial ideal 
			of {\em (x+y)} with respect to {\em w}.
			
			When both {\tt L} and {\tt M} are given as input and are compatible marked 
			reduced Groebner bases in the sense that {\tt L} is an initial ideal of {\tt M} 
			then {\tt gfaGroebnerCone(L,M)} computes the cone of {\tt L} in the fan of {\tt M}.
			For example, the cone on which {\em (x+y)} is its own initial ideal is simply the line 
			{\em w = a(1,1)} for {\em a} a real number.

		Example 
			QQ[x,y];
			gfanGroebnerCone( markedPolynomialList {{x}, {x+y}}, markedPolynomialList {{x}, {x+y}} )  
		Text
			
			Note that the {\tt pair} option will automatically be specified when 
			two marked Groebner bases are given.
			
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_groebnercone"@
///

doc ///
	Key
		gfanHomogeneitySpace
		(gfanHomogeneitySpace, List)
		(gfanHomogeneitySpace, MarkedPolynomialList)
	Headline
		homogeneity space of a list of polynomials
	Usage
		gfanHomogeneitySpace(L)
		gfanHomogeneitySpace(M)
	Inputs
		L:List
			of polynomials
		M:MarkedPolynomialList
	Outputs
		S:String
			polymake data with a lineality space of all weight vectors for which {\tt L} is homogeneous.
	Description
		Text
			This method computes the homogeneity space of {\tt L} or {\tt M}. 
			If a {\tt MarkedPolynomialList} is used, then the marked terms are simply ignored.

		Example
			QQ[x,y,z];
			gfanHomogeneitySpace {x+y^2, y+z^2}

		Text
			
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_homogeneityspace"@
///

doc ///
	Key
		gfanHomogenize
		(gfanHomogenize, List, Symbol)
		(gfanHomogenize, MarkedPolynomialList, Symbol)
	Headline
		homogenize a list of polynomials with respect to a weight vector
	Usage
		G = gfanHomogenize(L,X)
		H = gfanHomogenize(M,X)
	Inputs
		L:List
			of polynomials
		M:MarkedPolynomialList
		X:Symbol
			the homogenizing variable
	Outputs
		G:List
			polynomials from {\tt L} homogenized with variable {\tt X}
		H:MarkedPolynomialList
			polynomials from {\tt M} homogenized with variable {\tt X}
	Description
		Text
			The method homogenizes the polynomials in {\tt L} or {\tt M} with respect to 
			a given weight vector provided by the optional argument {\tt w}. 
			If the {\tt w} option is not specified, the polynomials are
			homogenized with respect to total degree.
			This functionality is also provided by the 
			@TO homogenize@ method which does not use {\tt gfan}.

		Example
			QQ[x,y];
			L = {x+y, x^2*y + x};
			gfanHomogenize(L, symbol z, "w" => {2,3})
			QQ[x,y,z];
			L = {x+y, x^2*y + x}; 
			homogenize(matrix{L}, z, {2,3,1})

		Text
			Using the variant that accepts a {\tt MarkedPolynomialList} as input produces
			a {\tt MarkedPolynomialList} as output.

		Example
			QQ[x,y];
			L = markedPolynomialList {{y}, {x+y}};
			gfanHomogenize(L, symbol z,  "w" => {2,3})

		Text
			
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_homogenize"@
///

doc ///
	Key
		gfanInitialForms
		(gfanInitialForms, List, List)
	Headline
		initial forms of polynomials with respect to a weight vector
	Usage
		G = gfanInitialForms(L,W)
		H = gfanInitialForms(M,W)
	Inputs
		L:List
			of polynomials
		M:MarkedPolynomialList
		W:List
			a weight vector
	Outputs
		G:List
			initial forms of the polynomials in {\tt L} with respect to weight {\tt W}
		H:MarkedPolynomialList
			marked initial forms of the polynomials in {\tt L} with respect to weight {\tt W}
	Description
		Text
			This method takes the initial forms of a list of polynomials. 
			If the {\tt "ideals"} option is used, generators for the initial ideal are given.
			If the {\tt "pair"} option is used, then the output is a pair of MarkedPolynomialLists.

		Example
			QQ[x,y,z]
			L = {x + y, x + z}
			gfanInitialForms(L, {1,2,1})
			gfanInitialForms(L, {1,2,1}, "ideal"=>true)
			gfanInitialForms(L, {1,2,1}, "ideal"=>true, "pair"=>true)

		Text
			
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_initialforms"@
///

doc ///
	Key
		gfanInteractive
	Headline
		not implemented
	Description
		Text
			This method is not implemented.

			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_interactive"@
///

doc ///
	Key
		gfanIsMarkedGroebnerBasis
		(gfanIsMarkedGroebnerBasis, MarkedPolynomialList)
	Headline
		check if a list of marked polynomials are a Groebner basis
	Usage
		B = gfanIsMarkedGroebnerBasis(L)
	Inputs
		L:MarkedPolynomialList
	Outputs
		B:Boolean
			true if {\tt L} forms a Groebner basis
	Description
		Text
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_ismarkedgroebnerbasis"@
///

doc ///
	Key
		gfanKrullDimension
		(gfanKrullDimension, List)
	Headline
		krull dimension
	Usage
		D = gfanKrullDimension(L)
	Inputs
		L:List
			a @TO2 {"Marked Groebner Basis Example", "marked Groebner basis"}@
	Outputs
		D:ZZ
			the Krull dimension of the polynomial ring modulo the ideal generated by {\tt L}
	Description
		Text
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_krulldimension"@
///

doc ///
	Key
		gfanLatticeIdeal
	Headline
		placeholder
	Usage
		placeholder
	Inputs
	Outputs
	Description
		Text
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_latticeideal"@
///

doc ///
	Key
		gfanLeadingTerms
		(gfanLeadingTerms, List)
	Headline
		leading terms of a list (or list of lists) of marked polynomials
	Usage
		T = gfanLeadingTerms(L)
	Inputs
		L:List
			of @TO2 {"Marked Groebner Basis Example", "marked polynomials"}@ (or, for the {\tt m} option, a lists of marked polynomials 
	Outputs
		T:List
			the leading terms of {\tt L} (or lists of the leading terms of each list in {\tt L})
	Description
		Text
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_leadingterms"@
///

doc ///
	Key
		gfanMarkPolynomialSet
		(gfanMarkPolynomialSet, List, List)
	Headline
		mark the initial terms of a list of polynomials with respect to a weight vector
	Usage
		M = gfanMarkPolynomialSet(L,W)
	Inputs
		L:List
			of polynomials
		W:List
			a weight vector
	Outputs
		M:List
			the polynomials in {\tt L} @TO2 {"Marked Groebner Basis Example", "marked"}@ with respect to {\tt W}
	Description
		Text
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_markpolynomialset"@
///

doc ///
	Key
		gfanMinkowskiSum
	Headline
		placeholder
	Usage
		placeholder
	Inputs
	Outputs
	Description
		Text
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_minkowskisum"@
///

doc ///
	Key
		gfanMinors
	Headline
		placeholder
	Usage
		placeholder
	Inputs
	Outputs
	Description
		Text
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_minors"@
///

doc ///
	Key
		gfanPolynomialSetUnion
		(gfanPolynomialSetUnion, List, List)
	Headline
		union of two lists of polynomials
	Usage
		U = gfanPolynomialSetUnion(L,K)
	Inputs
		L:List
			of polynomials
		K:List
			of polynomials
	Outputs
		U:List
			the union of lists {\tt L} and {\tt K}
	Description
		Text
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_polynomialsetunion"@
///

doc ///
	Key
		gfanRender
		(gfanRender, List)
	Headline
		render an image of a Grobener fan
	Usage
		gfanRender(L)
	Inputs
		L:List
			all @TO2 {"Marked Groebner Basis Example", "marked reduced Groebner bases"}@ of {\tt I} or an ideal 
	Description
		Text
			This method renders the Groebner fan of an ideal and writes it to a {\tt .fig} file.
			If {\tt fig2dev} is installed then the {\tt .fig} file will be converted to {\tt .png}
			and displayed. The names of the {\tt .fig} and {\tt .png} files are printed on 
			standard out.

			This method may support more options in the future to control rendering, conversion,
			and display. It may also eventually output file names in a list.

			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_render"@
///

doc ///
	Key
		gfanRenderStaircase
		(gfanRenderStaircase, List)
	Headline
		render the staircase of a monomial initial ideal
	Usage
		gfanRenderStaircase(L)
	Inputs
		L:List
			a @TO2 {"Marked Groebner Basis Example", "marked Groebner basis"}@ }
			or lists of @TO2 {"Marked Groebner Basis Example", "marked Groebner bases"}@ }
			(for use with the {\tt m} option)
	Description
		Text
			This method renders the staircase of the monomial initial ideal of the given
			Groebner basis (or bases in the case of the {\tt m} option).
			The rendered image is written to a {\tt .fig} file.
			If {\tt fig2dev} is installed then the {\tt .fig} file will be converted to {\tt .png}
			and displayed. The names of the {\tt .fig} and {\tt .png} files are printed on 
			standard out.

			This method may support more options in the future to control rendering, conversion,
			and display. It may also eventually output file names in a list.

			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_renderstaircase"@
///

doc ///
	Key
		gfanSaturation
		(gfanSaturation, Ideal)
	Headline
		saturation of a ideal
	Usage
		gfanSaturation(I)
	Inputs
		I:Ideal
	Outputs
		L:List
			polynomials generating the saturation of {\tt I} with the product of the 
			variables of the ring of {\tt I}
	Description
		Text
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_saturation"@
///

doc ///
	Key
		gfanSecondaryFan
	Headline
		placeholder
	Usage
		placeholder
	Inputs
	Outputs
	Description
		Text
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_secondaryfan"@
///

doc ///
	Key
		gfanStats
		(gfanStats, List)
	Headline
		display certain properties of a list of polynomials
	Usage
		gfanStats(L)
	Inputs
		L:List
			containing lists of @TO2 {"Marked Groebner Basis Example", "marked Groebner bases"}@
	Outputs
		S:String
			describing the bases in {\tt L}
	Description
		Text
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_stats"@
///

doc ///
	Key
		gfanSubstitute
		(gfanSubstitute, List, PolynomialRing)
	Headline
		rename the variables of a list of polynomials
	Usage
		gfanSubstitute(L,R)
	Inputs
		L:List
			of polynomials
		R:PolynomialRing
			with the name number of variables as the ring of the polynomials in {\tt L}
	Outputs
		L:List
			of polynomials from {\tt L} with variables replaced by those in {\tt R}
	Description
		Text
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_substitute"@
///

doc ///
	Key
		gfanToLatex
		(gfanToLatex, List)
	Headline
		convert a list of polynomials to LaTeX
	Usage
		gfanToLatex(L)
	Inputs
		L:List
			of polynomials or lists of polynomials (for the {\tt polynomialsetlist} option)
	Outputs
		S:String
			LaTeX math for {\tt L}
	Description
		Text
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_tolatex"@
///

doc ///
	Key
		gfanToPolyhedralFan
		(gfanToPolyhedralFan, List)
	Headline
		polyhedral data about the fan of a list of Groebner bases
	Usage
		gfanToPolyhedralFan(L)
	Inputs
		L:List
			containing lists of @TO2 {"Marked Groebner Basis Example", "marked reduced Groebner bases"}@
	Outputs
		P:String
			polymake data describing the fan of the Groebner basis in {\tt L}
	Description
		Text
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_topolyhedralfan"@
///

doc ///
	Key
		gfanTropicalBasis
		(gfanTropicalBasis, Ideal)
	Headline
		tropical basis of an ideal
	Usage
		gfanTropicalBasis(I)
	Inputs
		I:Ideal
	Outputs
		L:List
			of polynomials that give a tropical basis of {\tt I}
	Description
		Text
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_tropicalbasis"@
///

doc ///
	Key
		gfanTropicalBruteForce
		(gfanTropicalBruteForce, List)
	Headline
		polyhedral data describing the tropical variety of an ideal
	Usage
		gfanTropicalBruteForce(L)
	Inputs
		L:List
			a @TO2 {"Marked Groebner Basis Example", "marked reduced Groebner basis"}@ for a homogeneous ideal
	Outputs
		P:String
			polymake data describing the tropical variety of the ideal of {\tt L}
	Description
		Text
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_tropicalbruteforce"@
///

doc ///
	Key
		gfanTropicalEvaluation
	Headline
		placeholder
	Usage
		placeholder
	Inputs
	Outputs
	Description
		Text
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_tropicalevaluation"@
///

doc ///
	Key
		gfanTropicalFunction
	Headline
		placeholder
	Usage
		placeholder
	Inputs
	Outputs
	Description
		Text
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_tropicalfunction"@
///

doc ///
	Key
		gfanTropicalHyperSurface
	Headline
		placeholder
	Usage
		placeholder
	Inputs
	Outputs
	Description
		Text
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_tropicalhypersurface"@
///

doc ///
	Key
		gfanTropicalIntersection
		(gfanTropicalIntersection, List)
	Headline
		polyhedral data describing intersection of tropical hypersurfaces
	Usage
		gfanTropicalIntersection(L)
	Inputs
		L:List
			of polynomials
	Outputs
		P:String
			polymake data describing the intersection of the tropical hypersurfaces of polynomials in {\tt L}
	Description
		Text
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_tropicalintersection"@
///

doc ///
	Key
		gfanTropicalLifting
	Headline
		not implemented
	Description
		Text
			This method is not implemented.

			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_tropicallifting"@
///

doc ///
	Key
		gfanTropicalLinearSpace
	Headline
		placeholder
	Usage
		placeholder
	Inputs
	Outputs
	Description
		Text
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_tropicallinearspace"@
///

doc ///
	Key
		gfanTropicalMultiplicity
		(gfanTropicalMultiplicity, List)
	Headline
		multiplicity of a tropical cone
	Usage
		gfanTropicalMultiplicity(L)
	Inputs
		L:List
			a @TO2 {"Marked Groebner Basis Example", "marked reduced Groebner basis"}@
	Outputs
		M:ZZ
			the multiplicity of the tropical cone of {\tt L}
	Description
		Text
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_tropicalmultiplicity"@
///

doc ///
	Key
		gfanTropicalRank
	Headline
		placeholder
	Usage
		placeholder
	Inputs
	Outputs
	Description
		Text
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_tropicalrank"@
///

doc ///
	Key
		gfanTropicalStartingCone
		(gfanTropicalStartingCone, List)
	Headline
		a pair of Groebner bases for use with gfanTropicalTraverse
	Usage
		gfanTropicalStartingCone(L)
	Inputs
		L:List
			of homogeneous polynomials
	Outputs
		P:List
			a pair of @TO2 {"Marked Groebner Basis Example", "marked reduced Groebner bases"}@
	Description
		Text
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_tropicalstartingcone"@
	SeeAlso
		gfanTropicalTraverse
///

doc ///
	Key
		gfanTropicalTraverse
		(gfanTropicalTraverse, List)
	Headline
		polyhedral data describing a tropical variety
	Usage
		gfanTropicalTraverse(L)
	Inputs
		L:List
			a pair of @TO2 {"Marked Groebner Basis Example", "marked reduced Groebner bases"}@ 
	Outputs
		P:String
			polymake data describing the tropical variety of the given ideal
	Description
		Text
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_tropicaltraverse"@
///

doc ///
	Key
		gfanTropicalWeilDivisor
	Headline
		placeholder
	Usage
		placeholder
	Inputs
	Outputs
	Description
		Text
			@STRONG "gfan Documentation"@
			@gfanHelp#"gfan_tropicalweildivisor"@
///

end


-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------

-- Code for extracting options and methods

loadPackage "gfanInterface2"

applyBinary = (L, f) -> (
	S := null;
	scan(L, i -> if S === null then S = i else S = f(i,S));
	S
)

fns = select(gfanInterface2#"exported symbols", k -> 
		substring(0,4,toString k) == "gfan" and class value k === MethodFunctionWithOptions)

apply(fns, f -> f => (value f, options value f))

opts = select(apply(fns, f -> options value f), o -> o =!= null)
opts = applyBinary(opts, (x,y) -> x ++ y)
sort keys opts

-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------


restart
uninstallPackage "gfanInterface2"
installPackage("gfanInterface2", UserMode=>true, DebuggingMode=>true)
installPackage("gfanInterface2", Configuration => { "path" => "/opts/gfan/bin/"}) ---gfan version 0.4 for Andrew

loadPackage "gfanInterface2"
loadPackage("gfanInterface2", Configuration => { "path" => "/opts/gfan/bin/"}) ---gfan version 0.4 for Andrew

viewHelp

R = QQ[x,y,z]; 
I = ideal(x,y+z); 
L = transpose {{x,x},{z,y+z}};
gfan(I)
gfan(ideal(x^2*y -z, y^2*z - x, z^2*x - y), "symmetry" => {{0,1,2}, {1,2,0}})
gfan(new MarkedPolynomialList from transpose{{x,x},{z,y+z}})
gfanBuchberger(I)
gfanBuchberger(I, "w"=> {1,2,3})
gfanDoesIdealContain(L, {x})
gfanDoesIdealContain(L, {y})
gfanGroebnerCone(transpose{{x,x},{y,y+z}})
gfanGroebnerCone(transpose{{x,x},{y,y+z}}, "restrict"=>true)
gfanGroebnerCone(transpose{{x,x},{y,y+z}}, "asfan"=>true)
gfanGroebnerCone({transpose{{x,x},{y,y+z}},transpose{{y,y+z},{x,x}}}, "pair"=>true)
gfanHomogeneitySpace(transpose{{x,x},{y,y+z}})
gfanHomogenize({z+1},a)
gfanInitialForms({z+x+y},{2,1,2})
gfanInitialForms({z+x+y},{2,1,2}, "pair"=>true)
gfanInitialForms({z+x+y},{2,1,2}, "ideal"=>true)
gfanIsMarkedGroebnerBasis(transpose{{y,y+z},{x, x+1}})
gfanKrullDimension(transpose{{x,x+1}})
gfanLeadingTerms(transpose{{x,x+y},{z,z+x+y}})
gfanLeadingTerms({transpose{{x,x+y},{z,z+x+y}},transpose{{x*y,x*y + y^2}}}, "m"=>true)
gfanMarkPolynomialSet({x+y+z}, {1,1,2})
gfanPolynomialSetUnion({x},{x+y})
gfanRender(gfan(ideal(x*y+z, y^3+x*z)))
gfanRenderStaircase(transpose{{x,x},{y^3,y^3}, {z^2,z^2}})
gfanRenderStaircase({transpose{{x,x},{y^3,y^3}, {z^2,z^2}},transpose{{x,x},{y^3,y^3}, {z^2,z^2}}}, "m"=>true)
gfanStats({transpose{{x,x+y},{z,z}},transpose{{y,y+x},{z,z}}})
gfanSubstitute(transpose{{y,y+x},{z,z}}, QQ[a,b,c])
gfanToLatex(transpose{{y,y+x},{z,z}}, "polynomialset"=>true)
gfanToLatex({transpose{{y,y+x}},transpose{{z,z}}}, "polynomialsetlist"=>true)
gfanToLatex({transpose{{y,y+x}},transpose{{z,z}}}, "polynomialsetlist"=>true, "h"=>true)
gfanTropicalBasis(ideal{x^2+x*y, z^2})
gfanTropicalBasis(ideal{x^2+y, z^2}, "h"=>true)
gfanTropicalIntersection({x^2+y, z^2})
gfanTropicalIntersection({x^2+y, z^2}, "t"=>true)
gfanTropicalStartingCone({x^2+y*x, x*y+z^2})
gfanTropicalStartingCone({x^2+y*x, x*y+z^2}, "d"=>true)
gfanTropicalTraverse(gfanTropicalStartingCone({x^2+y*x, x*y+z^2}))
gfanTropicalMultiplicity(first gfanTropicalStartingCone({x^2+y*x, x*y+z^2}))
gfanSaturation(ideal(z*y-z*x))
gfanToPolyhedralFan({transpose{{x*y, x*y+ z}, {z,z}}, transpose{{x*y, x*y},{z,z}}})
gfanToPolyhedralFan({transpose{{x*y, x*y+ z}, {z,z}}, transpose{{x*y, x*y},{z,z}}}, "restrict"=>true)
gfanToPolyhedralFan(gfan(ideal(x^2*y -z, y^2*z - x, z^2*x - y), {{0,1,2}, {1,2,0}}, "symmetry"=>true), {{0,1,2}, {1,2,0}}, "symmetry"=>true)
gfanTropicalBruteForce(transpose{{x*y,x*y + z}, {z,z}})

