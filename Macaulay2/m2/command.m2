--		Copyright 1993-1999 by Daniel R. Grayson

-- documentation is in doc.m2 because this file loaded early

SelfInitializingType = new Type of Type
SelfInitializingType.synonym = "self initializing type"
SelfInitializingType.name = "SelfInitializingType"
SelfInitializingType.Symbol = symbol SelfInitializingType
SelfInitializingType Thing := (T,z) -> new T from z
SelfInitializingType\List := (T,z) -> (i -> T i) \ z
List/SelfInitializingType := (z,T) -> z / (i -> T i)

Command = new SelfInitializingType of BasicList
Command.synonym = "command"
Command.name = "Command"
new Command from Function := Command => (command,f) -> command {f}
new Command from String   := Command => (command,cmdname) -> command {
     x -> (
	  if x === ()
	  then run cmdname
	  else run (cmdname | " " | toString x))}
Command.AfterEval = x -> x#0 ()
Command Thing := (x,y) -> x#0 y

