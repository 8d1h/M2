--		Copyright 1995 by Daniel R. Grayson

load "booktex.m2"

--------------------------------------------------- make the tex file
bookFile = openOut "M2book.tmp"
--------------------------------------------
bookFile << ///
%% Macaulay 2 manual
%% latex
%% Copyright 1996-1999, by Daniel R. Grayson and Michael E. Stillman

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% some macros

\documentclass{amsbook}
\usepackage{hyperref} \hypersetup{
        bookmarks=true,
	bookmarksnumbered=true,
        pdftitle=Macaulay 2,
        pdfsubject=symbolic algebra,
        pdfkeywords=syzygy Groebner resolution polynomials,
        pdfauthor=Daniel R. Grayson and Michael E. Stillman,
    	colorlinks=true
        }

\renewcommand{\thepart}{\Roman{part}}
\renewcommand{\thechapter}{\arabic{chapter}}
\renewcommand{\thesection}{\thechapter.\arabic{section}}
\renewcommand{\thesubsection}{\thesection.\arabic{subsection}}
\renewcommand{\thesubsubsection}{\thesubsection.\arabic{subsubsection}}

\makeindex

% \parindent=10pt
% \parskip=4pt

\overfullrule=0pt

{\obeyspaces\global\let =\ \tt}
\def\beginverbatim{%
     \begingroup
     % \parindent=24pt
     \baselineskip=9.5pt
     \tt
     \parskip=0pt
     \obeyspaces\def\par{\leavevmode\hss\endgraf}\obeylines}
\def\endverbatim{\endgroup}

\font\headerFontOne=cmbx12 scaled \magstep 1
\font\headerFontTwo=cmbx12 scaled \magstep 1
\font\headerFontThree=cmbx12
\font\headerFontFour=cmbx12
\font\headerFontFive=cmbx10
\font\headerFontSix=cmbx10

\begin{document}
        \title{Macaulay 2}
        \thanks{Supported by the NSF}
        \author[Grayson]{Daniel R. Grayson}
        \address{University of Illinois at Urbana-Champaign}
        \email{dan\char`\@math.uiuc.edu}
        \urladdr{\href{http://www.math.uiuc.edu/~dan}{http://www.math.uiuc.edu/\char`\~dan}}
        \author[Stillman]{Michael E. Stillman}
        \address{Cornell University}
        \email{mike\char`\@math.cornell.edu}
        \urladdr{\href{http://www.math.cornell.edu/~mike}{http://www.math.cornell.edu/\char`\~mike}}
        \date{/// << version#"compile time" << ///}
        \maketitle
	\tableofcontents
///
--------------------------------------------
    -- this loop depends on the feature of hash tables that when the keys
    -- are consecutive integers starting at 0, the keys are scanned
    -- in the natural order, which in turn depends on the hash number of
    -- a small integer being the integer itself

    sectionType := sectionNumber -> (
	 level := 1 + # select(characters sectionNumber, i -> i === ".");
	 if level === 0 then "\\part"
	 else if level === 1 then "\\chapter"
	 else if level === 2 then "\\section"
	 else if level === 3 then "\\subsection"
	 else "\\subsubsection"
	 )

    scan(pairs nodeTable, (i,node) -> (
	      n := sectionNumberTable#i;
	      bookFile << endl << endl
	      << sectionType n << "{" << cmrLiteral formatDocumentTag node << "}"
	      << "\\label{" << n << "}" << endl
	      << "\\hypertarget{" << n << "}{}" << endl
	      << concatenate booktex documentation node << endl;
	      )
	 )
-----------------------------------------------------------------------------
-- all done

bookFile << ///

We should cite at least one paper \cite{MR47:3318}.

\bibliographystyle{plain}
\bibliography{papers}
\printindex
\end{document}
/// << close
