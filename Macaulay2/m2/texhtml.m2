-- tex to html conversion

html TEX := str -> (
     str = str#0;
     f := (p,r) -> (
	  n := replace(p,r,str);
	  if n != str and debugLevel > 0 then (
	       stderr << "html TEX: ///" << str << "/// matches ///" << p << "/// and becomes ///" << n << "///" << endl;
	       );
	  str = n);
     f(///''///,///&rdquo;///);
     f(///'///,///&rsquo;///); -- This is for text.  But an apostrophe in math mode should be a prime!
     f(///\$\$([^$]*)\$\$///,///<p align=center><i>\1</i></p>///);
     f(///\$([^$]*)\$///,///<i>\1</i>///);
     f(///``///,///&ldquo;///);
     f(///`///,///&lsquo;///);
     f(///\\\\///,///\backslash ///);
     f(///\\\{///,///\lbrace ///);
     f(///\\\}///,///\rbrace ///);
     while (
	  oldstr := str;
	  f(///\{ *\\bf +([^{}]*)\}///,///{<b>\1</b>}///);
	  f(///\{ *\\mathbf +([^{}]*)\}///,///{<b>\1</b>}///);
	  f(///\{ *\\mathbb +([^{}]*)\}///,///{<b>\1</b>}///);
	  f(///\{ *\\rm +([^{}]*)\}///,///{\1}///);
	  f(///\{ *\\it +([^{}]*)\}///,///{<i>\1</i>}///);
	  f(///\{ *\\tt +([^{}]*)\}///,///{<tt>\1</tt>}///);
	  f(///\{ *\\em +([^{}]*)\}///,///{<em>\1</em>}///);
	  f(///\{ *\\cal +([^{}]*)\}///,///{<i>\1</i>}///);
	  f(///\{ *\\mathcal +([^{}]*)\}///,///{<i>\1</i>}///);
	  f(///\\url *\{([^{}]*)\}///,///<a href="\1" target=blank>\1</a>///);
	  f(///\\frac *\{([^{}]*)\}\{([^{}]*)\}///,///{(\1)/(\2)}///);
	  f(///\{([^{}]*)\\over *([^{}]*)\}///,///{\1/\2}///);
	  f(///\^ *\{([^{}]*)\}///,///<sup>\1</sup>///);
	  f(///_ *\{([^{}]*)\}///,///<sub>\1</sub>///);
	  oldstr != str) do null;
     while (
	  oldstr = str;
     	  f(///\{([^{}]*)\}///,///\1///);
	  oldstr != str) do null;
     f(///\^(\\[a-zA-Z]*)///,///<sup>\1</sup>///);
     f(///_(\\[a-zA-Z]*)///,///<sub>\1</sub>///);
     f(///\^ *(.)///,///<sup>\1</sup>///);
     f(///_ *(.)///,///<sub>\1</sub>///);
     f(///\\frac *([0-9]) *([0-9])///,///{\1/\2}///);
     f(///\\"a///,///&auml;///);
     f(///\\"o///,///&ouml;///);
     f(///\\"u///,///&uuml;///);
     f(///\\#///,///#///);
     f(///\\&///,///&amp;///);
     f(///\\'e///,///&eacute;///);
     f(///\\,///,///&nbsp;///);
     f(///\\\^a///,///&acirc;///);
     f(///\\\^e///,///&ecirc;///);
     f(///\\`e///,///&egrave;///);
     f(///\\NN\> *///,///&#x2115;///);			    -- these unicode characters are experimental
     f(///\\QQ\> *///,///&#x211A;///);			    -- on at least some machines they are represented by bitmaps, not by truetype fonts!
     f(///\\RR\> *///,///&#x211D;///);
     f(///\\ZZ\> *///,///&#x2124;///);
     f(///\\PP\> *///,///&#x2119;///);
     f(///\\Gamma\> *///,///&Gamma;///);
     f(///\\Lambda\> *///,///&Lambda;///);
     f(///\\Omega\> *///,///&Omega;///);
     f(///\\Psi\> *///,///&Psi;///);
     f(///\\Theta\> *///,///&Theta;///);
     f(///\\aleph\> *///,///&aleph;///);
     f(///\\alpha\> *///,///&alpha;///);
     f(///\\backslash\> *///,///\///);
     f(///\\beta\> *///,///&beta;///);
     f(///\\beth\> *///,///&beth;///);
     f(///\\bf\> *///,//////);
     f(///\\bullet\> *///,///&bull;///);
     f(///\\cap\> *///,///&cap;///);
     f(///\\cdots,\> *///,///&hellip;///);
     f(///\\centerline\> *///,//////);
     f(///\\cong\> *///,///&#8773;///);
     f(///\\cos\> *///,///cos///);
     f(///\\cup\> *///,///&cup;///);
     f(///\\daleth\> *///,///&daleth;///);
     f(///\\datefont\> *///,//////);
     f(///\\delta\> *///,///&delta;///);
     f(///\\dots,\> *///,///&hellip;///);
     f(///\\ell\> *///,///<em>l</em>///);
     f(///\\emptyset\> *///,///&Oslash///);
     f(///\\epsilon\> *///,///&epsilon;///);
     f(///\\equiv\> *///,///&equiv;///);
     f(///\\exists\> *///,///&exist;///);
     f(///\\forall\> *///,///&forall;///);
     f(///\\gamma\> *///,///&gamma;///);
     f(///\\geq?\> *///,///&ge;///);
     f(///\\gimel\> *///,///&gimel;///);
     f(///\\in\> *///,///&isin;///);
     f(///\\infty\> *///,///&infin;///);
     f(///\\infty\> *///,///&infin;///);
     f(///\\int\> *///,///&int;///);
     f(///\\it\> *///,//////);
     f(///\\lambda\> *///,///&lambda;///);
     f(///\\lbrace\> *///,///{///);
     f(///\\ldots,\> *///,///...///);
     f(///\\leftarrow\> *///,///&larr;///);
     f(///\\leq?\> *///,///&le;///);
     f(///\\mapsto\> *///,///&rarr;///);
     f(///\\mathbb\> *///,//////);
     f(///\\mathbf\> *///,//////);
     f(///\\mathcal\> *///,//////);
     f(///\\mid\> *///,///&nbsp;|&nbsp;///);
     f(///\\mod\> *///,///mod///);
     f(///\\mu\> *///,///&mu;///);
     f(///\\neq\> *///,///&ne;///);
     f(///\\nu\> *///,///&nu;///);
     f(///\\omega\> *///,///&omega;///);
     f(///\\oplus\> *///,///&oplus;///);
     f(///\\otimes\> *///,///&otimes;///);
     f(///\\par\> *///,///<p>///);
     f(///\\partial\> *///,///&part;///);
     f(///\\phi\> *///,///&phi;///);
     f(///\\pi\> *///,///&pi;///);
     f(///\\prime\> *///,///&prime;///);
     f(///\\prod\> *///,///&prod;///);
     f(///\\psi\> *///,///&psi;///);
     f(///\\rbrace\> *///,///}///);
     f(///\\rho\> *///,///&rho;///);
     f(///\\rightarrow\> *///,///&rarr;///);
     f(///\\rm\> *///,//////);
     f(///\\setminus\> *///,///&#92;///);
     f(///\\sigma\> *///,///&sigma;///);
     f(///\\sin\> *///,///sin///);
     f(///\\subset\> *///,///&sub;///);
     f(///\\subseteq\> *///,///&sube;///);
     f(///\\supset\> *///,///&sup;///);
     f(///\\supseteq\> *///,///&supe;///);
     f(///\\sum\> *///,///&sum;///);
     f(///\\tau\> *///,///&tau;///);
     f(///\\textrm\> *///,//////);
     f(///\\theta\> *///,///&theta;///);
     f(///\\times\> *///,///&times;///);
     f(///\\to\> *///,///&rarr;///);
     f(///\\ +///,///&nbsp;///);
     f(///\\wedge\> *///,///&and;///);
     f(///\\wp\> *///,///&weierp;///);
     f(///\\xi\> *///,///&xi;///);
     f(///\\zeta\> *///,///&zeta;///);
     f(///Macaulay2///,///<i>Macaulay2</i>///);
     f(///Macaulay 2///,///<i>Macaulay 2</i>///);
     r := select("\\\\(.|[a-zA-Z]+)?",str);
     if #r > 0 then error("in conversion to html, unknown TeX control sequence(s): ",concatenate between(", ",r));
     str)

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/m2 "
-- End:
