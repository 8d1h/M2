-- This file contains the code to interface to the engine
-- (c) 1994  Michael E. Stillman

ggPush HashTable := n -> (ggINT, gg n.handle, ggderef)
ggPush Handle := n -> (ggINT, gg n, ggderef)

callgg = args -> (
     sendgg (apply(#args-1, i -> ggPush args#(i+1)), args#0)
     )

ggPush String := s -> concatenate(ggSTRING, gg (# s), s)
eePop = format -> convert(format, sendgg ggtonet)

ZZ.pop = eePopInt = () -> eePop ConvertInteger
ZZ.handle = newHandle ggZ

ggPush ZZ := i -> (ggINT, gg i)

eePopBool = () -> eePop ConvertInteger === 1
eePopIntarray = () -> eePop ConvertList ConvertInteger
eePromote = (f,R) -> (
     sendgg(ggPush R, ggPush f, ggpromote);
     R.pop())
eeLift = (f,R) -> (
     sendgg(ggPush R, ggPush f, gglift);
     R.pop())

-- these routines are used just for debugging
look  = Command (() -> (<< sendgg ggsee;))
     
engineStack = Command (() -> stack lines sendgg ggstack)
heap = Command (() -> (<< sendgg ggheap;))
engineMemory = Command (() -> (<< sendgg ggmem;))

see = method()
see ZZ := i -> sendgg(ggPush i, ggderef, ggsee, ggpop)
see Handle := i -> sendgg(ggPush i, ggsee, ggpop)
see HashTable := (X) -> if X.?handle then see X.handle else error "not an engine object"
