--		Copyright 1993-2002 by Daniel R. Grayson

olderror := error
erase symbol error
error = args -> olderror apply(
     sequence args, x -> if class x === String then x else toString x
     )
protect symbol error

on = { CallLimit => 100000, Name => null } >>> opts -> f -> (
     depth := 0;
     totaltime := 0.;
     callCount := 0;
     limit := opts.CallLimit;
     if class f =!= Function then error("expected a function");
     fn := if opts.Name =!= null then opts.Name else try toString f else "--function--";
     x -> (
	  saveCallCount := callCount = callCount+1;
     	  << fn << " (" << saveCallCount << ")";
	  if depth > 0 then << " [" << depth << "]";
	  << " called with ";
	  try << class x << " ";
	  try << x else "SOMETHING";
	  << endl;
	  if callCount > limit then error "call limit exceeded";
	  depth = depth + 1;
     	  r := timing f x;
	  timeused := r#0;
	  value := r#1;
	  depth = depth - 1;
	  if depth === 0 then totaltime = totaltime + timeused;
     	  << fn << " (" << saveCallCount << ")";
	  if depth > 0 then << " [" << depth << "]";
	  if timeused > 1. then << " used " << timeused << " seconds";
	  if totaltime > 1. and depth === 0 then << " (total " << totaltime << " seconds)";
	  << " returned " << class value << " " << value << endl;
     	  value)
     )

notImplemented = x -> error "not implemented yet"

benchmark = (s) -> (
     n := 1;
     while (
	  s1 := concatenate("timing scan(",toString n,", i -> (",s,";null;null))");
	  s2 := concatenate("timing scan(",toString n,", i -> (      null;null))");
	  collectGarbage();
	  value s1;
	  value s2;
	  collectGarbage();
	  value s1;
	  value s2;
	  collectGarbage();
	  t1 := first value s1;
	  t2 := first value s2;
	  t := t1 - t2;
	  t < 1 and t2 < 5)
     do (
	  n = if t > 0.01 then floor(2*n/t+.5) else 100*n;
	  );
     t/n)

-----------------------------------------------------------------------------
Descent := new Type of MutableHashTable
net Descent := x -> stack sort apply(pairs x,
     (k,v) -> (
	  if #v === 0
	  then net k
	  else net k | " : " | net v
	  ))
select1 := syms -> select(apply(syms, value), s -> instance(s, Type))
     
show1 := method(SingleArgumentDispatch => true)
show1 Sequence := show1 List := types -> (
     world := new Descent;
     install := v -> (
	  w := if v === Thing then world else install parent v;
	  if w#?v then w#v else w#v = new Descent
	  );
     scan(types, install);
     net world)
show1 Thing := X -> show1 {X}
showUserStructure = Command(() -> show1 select1 userSymbols())
showStructure = Command(types -> show1 if types === () then select1 flatten(values \ globalDictionaries) else types)

-----------------------------------------------------------------------------

typicalValues#frame = MutableList

pos := s -> (
     t := locate s;
     if t =!= null then t#0 | ":" | toString t#1| ":" | toString t#2 | "-" | toString t#3| ":" | toString t#4)

sortByHash := v -> last \ sort \\ (i -> (hash i, i)) \ v

select2 := (type,syms) -> apply(
     sort apply(
	  select(syms, sym -> mutable sym and instance(value sym,type)),
	  symb -> (hash symb, symb)
	  ),
     (h,s) -> s)

ls = f -> reverse \\ flatten \\ sortByHash \ values \ localDictionaries f
localSymbols = method()
localSymbols Pseudocode :=
localSymbols Symbol :=
localSymbols Dictionary :=
localSymbols Function := ls

-- make this work eventually:
-- localSymbols() := () -> if errorCode === null then ls() else ls errorCode
-- meanwhile: (see also method123())
-- nullaryMethods # (singleton localSymbols) = () -> if errorCode =!= null then ls errorCode else error "not in debugger (i.e., errorCode not set)"
-- also meanwhile:
installMethod(localSymbols, () -> if errorCode =!= null then ls errorCode else error "not in debugger (i.e., errorCode not set)")

localSymbols(Type,Symbol) :=
localSymbols(Type,Dictionary) :=
localSymbols(Type,Function) :=
localSymbols(Type,Pseudocode) := (X,f) -> select2(X,localSymbols f)

localSymbols Type := X -> select2(X,localSymbols ())

abbreviate := x -> (
     if class x === Function and match("^--Function.*--$", toString x) then "..."
     else x)

vbar := (ht,dp) -> " "^(ht-1)
upWidth := (wid,n) -> n | horizontalJoin(wid - width n : " "^(height n - 1))
joinRow := x -> horizontalJoin mingle(#x+1:vbar(max\\height\x,max\\depth\x),x)
robustNetTable := x -> (
     if not isTable x then error "expected a table";
     if #x == 0 or #x#0 == 0 then return stack();
     x = applyTable(x,y -> silentRobustNet(25,4,3,y)); -- fix
     colwids := max \ transpose applyTable(x,width);
     x = joinRow \ apply(x, row -> apply(colwids,row,upWidth));
     hbar := "";
     (stack mingle(#x+1:hbar,x))^(height x#0))

listSymbols = x -> (
     if #x == 0 then "--no local variables"
     else robustNetTable prepend(
	  {"symbol"||"------",, "type"||"----",, "value"||"-----", "location"||"--------"},
	  apply (x, s -> {s,":", class value s, "--", abbreviate value s, pos s})))

listLocalSymbols = Command(f -> listSymbols localSymbols f)

userSymbols = type -> (
     if type === () then type = Thing;
     select2(type,values UserDictionary))

listUserSymbols = Command ( type -> listSymbols userSymbols type )

usage := () -> (
     << endl
     << " -- useful debugger commands:" << endl
     << " --     break                   leave the debugger, returning to top level" << endl
     << " --     end                     restart debugger one step earlier" << endl
     << " --     listLocalSymbols        display local symbols and their values" << endl
     << " --     listUserSymbols         display user symbols and their values" << endl
     << " --     continue                execute the code again" << endl
     << " --     continue n              execute the code again, stop after n steps" << endl
     << " --     return                  return 'null' as the value of the code" << endl
     << " --     return x                return 'x' as the value of the code" << endl
     )

firstTime := true
debuggerHook = () -> 
     -- if interpreterDepth > 1 then 
     (
     -- << listLocalSymbols errorCode << endl;
     if firstTime then ( usage(); firstTime = false; );
     << endl << " -- code just attempted: " << code errorCode << endl
     )

clearOutput = Command (() -> (
	  oo <- ooo <- oooo <- null;
	  scan(values OutputDictionary, s -> ( s <- null; erase s ));
	  ))

clearAll = Command (() -> ( 
     	  unmarkAllLoadedFiles();
	  clearOutput(); 
	  scan(userSymbols(), i -> i <- i);
	  )
     )

erase symbol silentRobustNet				    -- symbol was created in setup.m2
erase symbol unmarkAllLoadedFiles			    -- symbol was created in setup.m2

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/m2 "
-- End:
