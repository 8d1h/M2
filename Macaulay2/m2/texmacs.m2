--		Copyright 2000 by Daniel R. Grayson

TeXmacsBegin = ascii 2
TeXmacsEnd   = ascii 5

statementNumber := 0

rot := x -> (
     symbol oooo <- ooo;			  -- avoid GlobalAssignHook with <-
     symbol ooo <- oo;
     symbol oo <- x;
     )

String.TeXmacsEvaluate = s -> (
     statementNumber = statementNumber + 1;
     << TeXmacsBegin << "verbatim:";
     try (
	  v := value s;
	  if v =!= null then value concatenate("symbol o",toString statementNumber) <- v;
	  rot v;
	  if v =!= null then (
-- replacing latex below by mathml...
	     tv := try mathML v else "\\text{Display failed}";
	     tc := try mathML class v else "\\text{Class display failed}";
	     << TeXmacsBegin << "html:<math>";
		<< "\\begin{leqnarray*}"
		   << "\\text{o" << statementNumber << "} & = & " << tv << "\\\\"
		   << "\\text{o" << statementNumber << "} & : & " << tc
		<< "\\end{leqnarray*}"
		<< "</math>"
	     << TeXmacsEnd;
	     );
	  )
     else << "evaluation failed";
     << TeXmacsEnd << flush;
     )
