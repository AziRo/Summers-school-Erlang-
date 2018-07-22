-module(task4).

%% Application callbacks
-export([fact/1, fact_t/1]).
-export([qSort/1, qSort_t/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

%% Factorial
fact(0) -> 1;
fact(Number) ->
    Number * fact(Number - 1).


%% Factorial with tail recursion
fact_t(Number) -> fact_tail(Number, 1).

fact_tail(0, Acc) -> Acc;
fact_tail(Number, Acc) ->
    fact_tail(Number - 1, Acc * Number).

%% Quick sort
qSort([Pivot|Rest]) ->
    qSort([X || X <- Rest, X < Pivot])
    ++ [X || X <- [Pivot|Rest], X == Pivot]
    ++ qSort([X || X <- Rest, X > Pivot]);
qSort([]) -> [].


%% Quick sort with tail recursion
qSort_t([]) -> [];
qSort_t([Pivot|Rest]) ->
	{Smallers, Greaters} = qSort_t(Pivot, Rest),
	SortedSmallers = qSort_t(Smallers),
	SortedGreaters = qSort_t(Greaters),
	SortedSmallers ++ [Pivot] ++ SortedGreaters.

%% Division of elements into two lists, Greaters and Smallers
qSort_t(Pivot, List) -> qSort_t(Pivot, [], [], List).

qSort_t(_Pivot, Smallers, Greaters, []) -> {Smallers, Greaters};

qSort_t(Pivot, Smallers, Greaters, [First|Rest]) when First < Pivot ->
	qSort_t(Pivot, [First|Smallers], Greaters, Rest);

qSort_t(Pivot, Smallers, Greaters, [First|Rest]) when First >= Pivot ->
    qSort_t(Pivot, Smallers, [First|Greaters], Rest).
