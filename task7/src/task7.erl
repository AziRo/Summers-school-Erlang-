-module(task7).

%% Application callbacks
-export([start/0, start_fsm/1, fsm/1, fsm/3, fsm/4]).
-export([getValue/2, getValue_rpc/2, getValue_rpc/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================


%% Get value using final state machine
start() ->
    fsm(wait).

start_fsm(Node) ->
    spawn(Node, ?MODULE, start, []).


fsm(wait) ->
    receive
        {From, {get_val, Filename}} ->
            fsm(open, Filename, From);
        {From, _} ->
            From ! {self(), failed_request},
            fsm(wait)
    end.


fsm(open, Filename, From) ->
    try
        {ok, Fd} = file:open(Filename, [read, binary]),
        fsm(read, Fd, From)
    catch
        _:Reason ->
            From ! {self(), {failed_open_file, Reason}},
            fsm(wait)
    end;


fsm(read, Fd, From) ->
    try
        {ok, Data} = file:read_line(Fd),
        [Number|_] = binary:split(Data, [<<"\n">>], [global]),
        Value = binary_to_list(Number),
        fsm(close, Value, Fd, From)
    catch
        _:Reason ->
            From ! {self(), {failed_read_file, Reason}},
            fsm(wait)
    end;


fsm(answer, Value, From) ->
    From ! {self(), {answer, Value}},
    fsm(wait).


fsm(close, Value, Fd, From) ->
    try
        file:close(Fd),
        fsm(answer, Value, From)
    catch
        _:Reason ->
            From ! {self(), {failed_close_file, Reason}},
            fsm(wait)
    end.


getValue(Pid, Filename) ->
    Pid ! {self(), {get_val, Filename}},
    receive
        {_, {answer, Value}} ->
            io:format("Value = ~p~n", [Value]);

        {_,failed_request} ->
            io:format("Error: failed_request.~n");

        {_,{failed_open_file, Reason}} ->
            io:format("Error open: ~p~n", [Reason]);

        {_,{failed_read_file, Reason}} ->
            io:format("Error read: ~p~n", [Reason]);

        {_,{failed_close_file, Reason}} ->
            io:format("Error close: ~p~n", [Reason])
end.


%% Get value using rpc
getValue_rpc(Node, Filename) ->
    rpc:call(Node, ?MODULE, getValue_rpc, [Filename]).

getValue_rpc(Filename) ->
    try
        {ok, Data} = file:read_file(Filename),
        [Number|_] = binary:split(Data, [<<"\n">>], [global]),
        binary_to_integer(Number)
    catch
        _:Reason -> {failed_read_file, Reason}
end.
