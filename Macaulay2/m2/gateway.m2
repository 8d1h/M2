--		Copyright 1995 by Daniel R. Grayson

ScriptedFunction = new Type of MutableHashTable
ScriptedFunction ^ Thing := (G,i) -> (
     if G#?superscript then G#superscript i
     else error("no method for ", toString G, "^", toString i))
ScriptedFunction _ Thing := (G,i) -> (
     if G#?subscript then G#subscript i
     else error("no method for ", toString G, "_", toString i))

GlobalAssignHook ScriptedFunction := globalAssignFunction
GlobalReleaseHook ScriptedFunction := globalReleaseFunction

id = new ScriptedFunction from { 
     subscript => (
	  (x) -> (
	       r := lookup(id,class x);
	       if r =!= null then r x
	       else error ("no method 'id_' found for item of class ", toString class x)))
     }

ScriptedFunctor = new Type of MutableHashTable
GlobalAssignHook ScriptedFunctor := globalAssignFunction
GlobalReleaseHook ScriptedFunctor := globalReleaseFunction
ScriptedFunctor ^ Thing := (G,i) -> (
     if G#?superscript 
     then G#superscript i
     else error("no method for ", toString G, "^", toString i)
     )
ScriptedFunctor _ Thing := (G,i) -> (
     if G#?subscript 
     then G#subscript i
     else error("no method for ", toString G, "_", toString i)
     )
ScriptedFunctor Thing := (G,X) -> (
     if G#?argument
     then G#argument X
     else error("no method for ", toString G, " ", toString X)
     )
protect argument
protect subscript
protect superscript

args := method()
args(Thing,Sequence) := (i,args) -> prepend(i,args)
args(Thing,Thing) := identity
args(Thing,Thing,Sequence) := (i,j,args) -> prepend(i,prepend(j,args))
args(Thing,Thing,Thing) := identity

HH = new ScriptedFunctor from {
     subscript => (
	  i -> new ScriptedFunctor from {
	       superscript => (
		    j -> new ScriptedFunctor from {
	       	    	 argument => (
			      X -> cohomology args(i,j,X)
			      )
	       	    	 }
		    ),
	       argument => (
		    X -> homology args(i,X)
		    )
	       }
	  ),
     superscript => (
	  j -> new ScriptedFunctor from {
	       subscript => (
		    i -> new ScriptedFunctor from {
	       	    	 argument => (
			      X -> homology args(j,i,X)
			      )
	       	    	 }
		    ),
	       argument => (
		    X -> cohomology args(j,X)
		    )
	       }
	  ),
     argument => homology
     }

cohomology(ZZ,Sequence) := (i,X) -> cohomology prepend(i,X)
  homology(ZZ,Sequence) := (i,X) ->   homology prepend(i,X)

