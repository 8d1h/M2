--		Copyright 1994 by Daniel R. Grayson

-- make an html file for each documentation node

errorDepth 0

conceptTable = new MutableHashTable

scandb = (db,f) -> scanKeys(db,k->f(k,db#k))

process := (key,doc) -> (
     filename := linkFilename key;
     conceptTable#key = filename;
     filename << html HTML { 
	  HEAD {
	       TITLE key
	       },
	  BODY {
	       H2 key,
	       try evaluate doc else error ("evaluate ", doc),
	       if key != "index" then SEQ {
		    PARA,
		    "Go to ", HREF {"index.html", "main index"}, "."
		    },
	       PARA,
	       "Go to ", HREF {"concepts.html", "concepts index"}, "."
	       }
	  } << endl << close)
--try (
     scandb(openDatabase "../cache/Macaulay2.doc", process) 
--     )
--else (
--     scan(keys Documentation, k -> (
--	       v := Documentation#k;	  -- this doesn't work???
--	       if class v === SEQ then process (k,name v)
--	       )))

scan(linkFilenameKeys(),
     key -> if not conceptTable#?key then (
	  stderr << "Documentation for '" << key << "' missing." << endl;
	  linkFilename key << html HTML { 
	       HEAD {
		    TITLE key
		    },
	       BODY {
		    H2 key,
		    PARA,
		    "The text for this node has not been written yet.",
		    if key != "index" then SEQ {
			 PARA,
			 "Go to ", HREF {"index.html", "main index"}, "."
			 },
		    PARA,
		    "Go to ", HREF {"concepts.html", "concepts index"}, "."
		    }
	       } << endl << close;
	  ))

"concepts.html" << html HTML {
     HEAD {
	  TITLE "Concepts Index"
	  },
     BODY {
	  H2 "Concepts Index",
	  MENU apply(sort pairs conceptTable, (key, fname) -> HREF {fname, key}),
     	  PARA, "Go to ", HREF {"index.html", "main index"}, "."
	  }
     } << endl << close

OS := "operating system"

run concatenate ( 
     if version#OS === "MS-DOS" then "copy" else 
     if version#OS === "Windows NT" then "copy" else 
     if version#OS === "CYGWIN32-95" then "copy" else 
     if version#OS === "CYGWIN32-NT" then "copy" else 
	 "ln -s",
     " ",
     conceptTable#"Macaulay 2", 
     " index.html")
