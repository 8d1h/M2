-- -*- coding: utf-8 -*-
newPackage("Graphs",
     Authors => {
	  {Name => "Amelia Taylor"},
	  {Name => "Others"}
	  },
     DebuggingMode => true,
     Headline => "Data types, visualization, and basic funcitons for graphs",
     Version => "0.1"
     )

export {Graph, Digraph, graph, digraph, Singletons, descendents, nondescendents, 
     parents, children, neighbors, nonneighbors,displayGraph}
exportMutable {dotBinary,jpgViewer}


------------------------------------------------
-- Set graph types and constructor functions. -- 
------------------------------------------------

-- Give a graph as a hash table i => children for DAG and neighbors 
--                                   for undirected graphs. 

Digraph = new Type of HashTable
     -- a directed graph is a hash table in the form:
     -- { A => set {B,C,...}, ...}, where there are edges A->B, A->C, ...
     -- and A,B,C are symbols or integers. 

Graph = new Type of Digraph   
     -- an undirected graph is a hash table in the form:
     -- { A => set {B,C, ...}, where the set consists of 
     -- the neighbors of A. OR it is the neighbors for that 
     -- edge that are not a key earlier in the hash table. This 
     -- version removes the redunancy of each edge appearing twice. 
     -- simpleGraph is an internal conversion function. 

union = method()
union := S -> (
     x = new MutableHashTable;
     for t in S do scanKeys(t, z -> x#z = 1);
     new Set from x)  

graph = method(Options => {Singletons => null})
graph List := opts -> (g) -> (
     -- Input:  A list of lists with two elements which describe the 
     --         edges of the graph. 
     -- Output:  A hash table with keys the names of the nodes and the 
     --          values are the neighbors corresponding to that node. 
     ---- Note to Selves --- this code should also nicely build
     ---- hypergraphs as hash tables with again, nodes as keys and
     ---- neighbors as values. 
     h := new MutableHashTable;
     vertices := toList set flatten g;
     if opts.Singletons === null then (
	  neighbors := for j to #vertices-1 list( 
	       for k to #g-1 list (if member(vertices#j, set g#k) 
		    then set g#k - set {vertices#j} 
		    else continue)
	       );
	 -- error "what does union do?";
	  neighbors = apply(neighbors, i -> union i);
	  )
     else (vertices = join(vertices, opts.Singletons);
	  newEdges := apply(for i to #opts.Singletons - 1 list {}, i -> set i);
	  neighbors = for j to #vertices-1 list( 
	       for k to #g-1 list (if member(vertices#j, set g#k) 
		    then set g#k - set {vertices#j} 
		    else continue)
	       );
	  error "what does union do?";
	  neighbors = apply(neighbors, i -> union i);
	  neighbors = join(neighbors,newEdges);
	  );
     apply(#vertices, i -> h#(vertices#i) = neighbors#i);
     new Graph from h)

--graph MutableHashTable := opts -> (g) -> (
--     new Graph from h)

graph HashTable := opts -> (g) -> (
     -- Input:  A hash table with keys the names of the nodes of 
     --         the graph and the values the neighbors of that node. 
     -- Output: A hash table of type Graph. 
     new Graph from g)

digraph = method()
digraph List := (g) -> (
     -- Input:  A list pairs where the first element is the 
     --         name of the node and the second is the set of 
     --         children for that node. 
     -- Output:  A hashtable with keys the names of the nodes 
     --          with values the children.
     h := new MutableHashTable;
     apply(#g, i -> h#(g#i#0) = set g#i#1);
     new Digraph from h)

digraph HashTable := (g) -> (
     -- Input:  A hash table with keys the names of the nodes of 
     --         the graph and the values the children of that node. 
     -- Output: A hash table of type Diraph. 
     new Diraph from g)
     
-----------------------------
-- Graph Display Functions --
-----------------------------

-- dotBinary = "/sw/bin/dot"
dotBinary = "dot"
-- jpgViewer = "/usr/bin/open"
jpgViewer = "open"

simpleGraph := H -> (
     -- Input: A Graph.
     -- Output: A new Graph that has 
     pairH := new MutableList from pairs H;
     for k from 1 to #pairH-1 do (
	  testVertices := set for i to k-1 list pairH#i#0;
      	  pairH#k = (pairH#k#0, pairH#k#1-testVertices)
	  );
     new Graph from hashTable pairH)

 
writeDotFile = method()
writeDotFile(String, Graph) := (filename, G) -> (
     G = simpleGraph G;
     fil := openOut filename;
     fil << "graph G {" << endl;
     q := pairs G;
     for i from 0 to #q-1 do (
	  e := q#i;
	  fil << "  " << toString e#0;
	  if #e#1 === 0 or all(q, j->member(e#0,j#1)) then
	    fil << ";" << endl
	  else (
	    fil << " -- {";
	    links := toList e#1;
	    for j from 0 to #links-1 do
		 fil << toString links#j << ";";
     	    fil << "};" << endl;
	    )
	  );
     fil << "}" << endl << close;
     )

writeDotFile(String, Digraph) := (filename, G) -> (
     fil := openOut filename;
     fil << "digraph G {" << endl;
     q := pairs G;
     for i from 0 to #q-1 do (
	  e := q#i;
	  fil << "  " << toString e#0;
	  if #e#1 === 0 then
	    fil << ";" << endl
	  else (
	    fil << " -> {";
	    links := toList e#1;
	    for j from 0 to #links-1 do
		 fil << toString links#j << ";";
     	    fil << "};" << endl;
	    )
	  );
     fil << "}" << endl << close;
     )

runcmd := cmd -> (
     stderr << "--running: " << cmd << endl;
     r := run cmd;
     if r != 0 then error("--command failed, error return code ",r);
     )

displayGraph = method()

displayGraph(String,String,Digraph) := (dotfilename,jpgfilename,G) -> (
     writeDotFile(dotfilename,G);
     runcmd(dotBinary | " -Tjpg "|dotfilename | " -o "|jpgfilename);
     runcmd(jpgViewer | " " | jpgfilename);
     )
displayGraph(String,Digraph) := (dotfilename,G) -> (
     jpgfilename := temporaryFileName() | ".jpg";
     displayGraph(dotfilename,jpgfilename,G);
     --removeFile jpgfilename;
     )
displayGraph Digraph := (G) -> (
     dotfilename := temporaryFileName() | ".dot";
     displayGraph(dotfilename,G);
     --removeFile dotfilename;
     )

------------------
-- Graph basics --
------------------

descendents = method()
descendents(Digraph,ZZ) := (G,v) -> (
     -- returns a set of vertices
     result := G#v;
     scan(reverse(1..v-1), i -> (
	  if member(i,result) then result = result + G#i;
     ));
     result)

nondescendents = method()
nondescendents(Digraph,ZZ) := (G,v) -> set(1..#G) - descendents(G,v) - set {v}

parents = method()
parents(Digraph,ZZ) := (G,v) -> set select(1..#G, i -> member(v, G#i))

children = method()
children(Digraph,ZZ) := (G,v) -> G#v

neighbors = method()
neighbors(Graph,Thing) := (G,v) -> G#v  

nonneighbors = method()
nonneighbors(Graph, Thing) := (G,v) -> set(1..#G) - neighbors(G,v)-set{v}


--------------------
-- Documentation  --
--------------------

beginDocumentation()

doc ///
  Key
    Graphs
  Headline
    Data types and basic functions on graphs used in algebra and algebraic geometry. 
  Description
    Text
      This package is used to construct graphs. 
///

end


A = graph({{a,b},{c,d},{a,d},{b,c}}, Singletons => {f})
flatten {{a,b},{c,d},{a,d},{b,c}}
set oo
toList oo
