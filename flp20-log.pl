% FLP 2020/2021 – logicky projekt
% Kostra grafu
% author: Alexandra Slezakova (xsleza20)

:- dynamic vertex/1.

main :- 
	prompt(_, ''),
	/* read lines from input */
	read_lines(Lines), 
	/* create edges, ignore invalid lines and parallel edges */
	get_edges(Lines, E),
	/* sort edges again to remove duplicates */
	sort(E, SE),
	/* remove self loops */
	remove_self_loops(SE, Edges),
	/* spanning tree will have n - 1 edges, where n is number of vertices */
	findall(X, vertex(X), Res), 
	!, is_connected(Res, Edges),
	length(Res, N),
	/* number of edges of spanning tree */
	EdgeCount is N - 1,
	/* find all combinations of edges */
	findall(X, combinations(EdgeCount, Edges, X), Combinations),
	get_trees(Combinations, N, [], Trees),
	sort(Trees, SortedTrees),
	print_trees(SortedTrees),
	halt.

	
/* READ INPUT */
read_line(L, C) :-
	get_char(C),
	(isEOFEOL(C), L = [], !;
	read_line(LL, _),
	[C|LL] = L).
	
	
isEOFEOL(C) :-
	C == end_of_file;
	(char_code(C, Code), Code == 10).


read_lines(Ls) :-
	read_line(L,C),
	(C == end_of_file, Ls = [];
	(read_lines(LLs), [L|LLs] = Ls)).
	
	
/* SPANNING TREE */
get_trees([], _, Trees, List) :- List = Trees, !.
get_trees([H|T], VertexCount, Trees, List) :- 
	has_all_vertices(H, [], 0, VertexCount, Result),
	(Result == true ->
		check_cycle(H, VertexCount), 
		get_trees(T, VertexCount, [H|Trees], List), !;
		get_trees(T, VertexCount, Trees, List), !).
		
get_trees([_|T], VertexCount, Trees, List) :- !, get_trees(T, VertexCount, Trees, List).


/* Check if spanning tree has all vertices */
has_all_vertices([], _, VerticesCount, N, Result) :- 
	(N == VerticesCount -> Result = true; Result = false), !.
	
has_all_vertices([[V1, V2]|T], Seen, VerticesCount, N, Result) :- 
	check_vertex(V1, Seen, VerticesCount, N1),
	check_vertex(V2, Seen, N1, N2),
	has_all_vertices(T, [V1, V2 | Seen], N2, N, Result).
	
	
/* Check if vertex exists, increment counter of vertices */
check_vertex(V1, Seen, N, N1) :-
	\+ member(V1, Seen),
	vertex(V1),
	N1 is N + 1, !.
	
check_vertex(_, _, N, N1) :- N1 = N, !.


/* Check if spanning tree has cycle */
check_cycle([], _) :- !.
check_cycle(_, 2) :- !.
check_cycle([Edge|EdgesRest], VertexCount) :- 
	is_cycle(Edge, [Edge|EdgesRest]),
	check_cycle(EdgesRest, VertexCount).



is_cycle([], _) :- !.
is_cycle([Vertex|T], Edges) :- 
	\+ cycle(Vertex, Edges),
	is_cycle(T, Edges).



cycle(X, Edges) :- cycleh(X, Edges, [X]).

cycleh(X, Edges, Visited) :- 
	member(Edge, Edges),
	member(X, Edge),
	member(Y, Edge),
	X \= Y,
	delete(Edges, Edge, Rest),
	(member(Y, Visited) -> 
		!, true;
		cycleh(Y, Rest,[Y|Visited])).


/* Check if given input graph is connected (a path from first vertex to the last one exists) */
is_connected([FirstV|Vertices], Edges) :- travel(FirstV, Vertices, Edges).

travel(_, [], _) :- !.
travel(V1, [V2|Vertices], Edges) :-
	(member([V1, V2], Edges) ->	
		travel(V1, Vertices, Edges);
		path([V1, V2], Edges, [[V1, V2]])).

path(Edge, Edges, _) :- member(Edge, Edges), !.		
path([V1, V2], Edges, Visited) :-
	member(Edge, Edges),
	member(V1, Edge),
	member(C, Edge),
	V1 \= C,
	V2 \= C,
	sort([C, V2], E),
	\+ member(E, Visited),
	path(E, Edges, [E|Visited]), !.


/* EDGES */
get_edges([], []).

/* Create list of pairs (vertex1, vertex2) without duplicates */
get_edges([[V1, ' ', V2]|T], [Edge|TE]) :-
	sort([V1, V2], Edge),
	get_edges(T, TE).
	
/* Ignore invalid line or duplicates (parallel edges) */
get_edges([_|T], Edges) :-
	get_edges(T, Edges).
	
/* Add vertex to DB */
add_vertex(V) :-
	\+ vertex(V), !,
	assert(vertex(V)).
	
add_vertex(_) :- !.


/* Remove self loops */
remove_self_loops([], []) :- !.
remove_self_loops([[_]|T], List) :- !, remove_self_loops(T, List).
remove_self_loops([[V1, V2]|T], [[V1, V2]|T1]) :- 
	/* check if input has correct notation */
	((is_uppercase_letter(V1), is_uppercase_letter(V2)) ->
		/* add vertex to db */
		add_vertex(V1), add_vertex(V2),
		remove_self_loops(T, T1);
		
		delete(T1, [V1, V2], Rest),
		remove_self_loops(T, Rest)).
	

/* Create combinations of edges, spanning tree has n - 1 edges, 
	 where n is number of vertices */
combinations(0, _, []).

combinations(N, [X|T], [X|C]) :-
    N > 0,
    N1 is N - 1,
    combinations(N1, T, C).

combinations(N, [_|T], C) :-
    N > 0,
    combinations(N, T, C).


/* Check if vertex is labeled the the uppercase letter */
is_uppercase_letter(C) :-
	member(C, ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']).

	
/* PRINT */
print_trees([]).
print_trees([Tree|T]) :- print_edges(Tree), print_trees(T).
	
print_edges([]).
print_edges([[V1, V2]|TE]) :-
	write(V1), write('-'), write(V2),
	length(TE, N),
	(N \= 0 -> write(' '); write('\n')),
	print_edges(TE).
