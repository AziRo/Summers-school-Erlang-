-module(test_SUITE).


-include_lib("common_test/include/ct.hrl").
-compile(export_all).


all() ->
    [
        changeList_tests,
        revers_tests,
    ].


init_per_suite(Config) ->
    Config.


init_per_testcase(_, Config) ->
    Config.


end_per_testcase(_, Config) ->
    Config.


end_per_suite(Config) ->
    Config.


changeList_tests(_Config) ->
    try
        tester:changeList(123)
    catch
        error:function_clause ->
            ok
    end,
    [1, 2] = task12:changeList([1, 2]),
    [1, 2, -1, 4] = task12:changeList([1, 2, 3, 4]),
    [1, 2, -1, 4, 5, -1, 7] = task12:changeList([1, 2, 3, 4, 5, 6, 7]).


revers_tests(_Config) ->
    try
        tester:revers(123)
    catch
        error:function_clause ->
            ok
    end,
    [1] = tester:revers([1]),
    [1, 2, 3] = tester:revers([3, 2, 1]).
