-module(test_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).
-export([pow/2]).
-export([record_user/1]).
-export([changeList/1]).
-export([revers/1]).
-export([func_A/2]).

-record(user, {name = "user", money = 0}).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    test_sup:start_link().

stop(_State) ->
    ok.


pow(_, 0) -> 1;
pow(A, 1) -> A;
pow(A, N) when N > 0 ->
    A * pow(A, N - 1);
pow(A, N) when N < 0 ->
    pow(A, N + 1) / A.


record_user([]) -> 0;
record_user([H|T]) ->
    H#user.money + record_user(T).


changeList([H1,H2,_|T]) ->
    [H1,H2,-1|changeList(T)];
changeList(Atom) -> Atom.


revers([H|T]) ->
    revers(T) ++ [H];
revers(Atom) -> Atom.


func_A(N, 0) -> N + 1;
func_A(0, M) when M > 0 ->
    func_A(1, M - 1);
func_A(N, M) when N > 0, M > 0 ->
    func_A(func_A(N - 1, M), M - 1).
