---------------------------------------------------------------------------------
-- InfoLevel switch 
-- determines how often and of which depth remarks are made by D-routines
-- Suggested levels:
-- 	1: "still-alive" remarks as "localize: computing b-function..."
--     	    	      	   	     ^^^^^^^^
--         (should include a reference to the routine talking)
--     
-- 	2: benchmarks: "time = ..."
--      666: debugging info, reserved for developers.
---------------------------------------------------------------------------------
INFOLEVEL = 0

setInfoLevel = method()
setInfoLevel (ZZ) := level -> (t := INFOLEVEL;  INFOLEVEL = level; t)
    
-- prints Info 
-- format: pInfo(min_level, Thing)
pInfo = method();
pInfo(ZZ, Thing) := (minLevel, s) -> (
     if minLevel <= INFOLEVEL then print s 
     ); 
pInfo(ZZ, List) := (minLevel, l) -> (
     if minLevel <= INFOLEVEL then (
	  scan(l, u-><<u); 
     	  << endl;
	  )
     ); 
----------------------------------------------------------------------------------
-- Homogenization switch 
-- determines whether homogenized Weyl algebra is used in certain algorithms
---------------------------------------------------------------------------------- 
HOMOGENIZATION = true

setHomSwitch = method ()
setHomSwitch(Boolean) := s -> (t := HOMOGENIZATION; HOMOGENIZATION = s; t) 










