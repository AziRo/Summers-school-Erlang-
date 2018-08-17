-module(task12).


%% Application callbacks
-export([changeList/1]).
-export([revers/1]).


%% ===================================================================
%% Application callbacks
%% ===================================================================

changeList([H1,H2,_|T]) ->
    [H1,H2,-1|changeList(T)];
changeList(Atom) -> Atom.


revers([H|T]) ->
    revers(T) ++ [H];
revers(Atom) -> Atom.
