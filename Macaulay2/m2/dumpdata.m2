if not version#"dumpdata" then error "can't dump data with this version of Macaulay 2"
phase = 0
scan(openFiles(), f -> (
	  flush stderr;
	  flush stdout;
	  if not (f === stdout or f === stdin or f === stderr)
	  then (
	       << "--closing file " << name f << "\n";
	       close f;
	       )))
collectGarbage()
fn := concatenate("../cache/Macaulay2-",
     try first lines get "!uname -m | sed s=/=-=g" 
     else if getenv "ARCHITECTURE" != ""
     then getenv "ARCHITECTURE"
     else version#"architecture", 
     ".data")
<< "dumping to " << fn << endl
dumpdata fn
