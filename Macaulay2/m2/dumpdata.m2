dump = () -> (
     -- load dumpdata.m2 and then execute dump(), so dumpdata.m2 is closed when the dump occurs
     if not version#"dumpdata" then error "can't dump data with this version of Macaulay 2";
     if version#"operating system" === "Linux" then (
     	  << "open files : " << stack lines get("!ls -l /proc/"|string processID()|"/fd") << endl;
	  );
     fn := concatenate("../cache/Macaulay2-",
	  try first lines get "!uname -m | sed s=/=-=g" 
	  else if getenv "ARCH" != "" then concatenate between("-", lines(getenv "ARCH","/"))
	  else version#"architecture", 
	  "-data");
     << "dumping to " << fn << endl << flush;
     runEndFunctions();
     erase quote dump;
     phase = 0;
     collectGarbage();
     dumpdata fn;
     exit 0;
     )
