-module(hello).

-export([test/0, test/1]).


test() ->
    io:format("Hello Erlang!~n").

test(A) ->
    B = math:sqrt(A),
    io:format("SQRT(A) = ~p~n", [B]).

