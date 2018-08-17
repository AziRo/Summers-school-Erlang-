-module (test1_SUITE).


-include_lib("eunit/include/eunit.hrl").
-compile(export_all).


test1_changeList_test() ->
    ?assertError(function_clause, task12:changeList(123)).


test2_changeList_test() ->
    ?assertEqual([1, 2], task12:changeList([1, 2])).


test3_changeList_test() ->
    ?assertEqual([1, 2, -1, 4], tester:th_elem([1, 2, 3, 4])).


reverse_test_() ->
    [
        ?_assert(tester:revers([1]) =:= [1]),
        ?_assert(tester:revers([1, 2, 3]) =:= [3, 2, 1]),
        ?_assertError(function_clause, tester:revers(123))
    ].
