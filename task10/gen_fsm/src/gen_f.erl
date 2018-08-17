-module(gen_f).

-behaviour(gen_fsm).

%% Application callbacks
-export([start_link/0]).
-export([call/1, up_phone/0, down_phone/0, error_event/0]).
-export([init/1, wait/2, call/2, talk/2]).
-export([handle_event/3, handle_info/3,handle_sync_event/4, terminate/3,
         code_change/4]).


%% ===================================================================
%% Application callbacks
%% ===================================================================

start_link() ->
    gen_fsm:start_link({global, ?MODULE}, ?MODULE, [], []).


call(Pid) ->
    gen_fsm:send_event({global, ?MODULE}, {self(), Pid}).


up_phone() ->
    gen_fsm:send_event({global, ?MODULE}, {up_phone, self()}).


down_phone() ->
    gen_fsm:send_event({global, ?MODULE}, down_phone).


error_event() ->
    gen_fsm:send_all_state_event({global, ?MODULE}, error).


init([]) ->
    io:format("Wait...~n"),
    {ok, wait, []}.


wait({FromPid, ToPid}, []) ->
    io:format("Call from ~p to ~p~n", [FromPid, ToPid]),
    ToPid ! ring,
    {next_state, call, [FromPid, ToPid]}.


call({up_phone, ToPid}, [_FromPid, ToPid]) ->
    io:format("~p is connected!~n", [ToPid]),
    {next_state, talk, [ToPid]}.


talk(down_phone, [ToPid]) ->
    io:format("~p is disconnected!~n", [ToPid]),
    {next_state, wait, []}.


handle_event(error, _StateName, _StateData) ->
    {stop, "Error event!", []}.


handle_sync_event(error, _From, _StateName, _StateData) ->
    {stop, "Error event!", []}.


handle_info(_Info, _StateName, _StateData) ->
    {stop, normal, []}.


terminate(Reason, StateName, StateData) ->
    {terminate, Reason, StateName, StateData}.


code_change(_OldVersion, _StateName, _StateData, _Extra) ->
    {ok, wait, []}.
