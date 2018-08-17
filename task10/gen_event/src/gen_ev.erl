-module(gen_ev).

-behaviour(gen_event).

%% Application callbacks
-export([start_link/0, stop/0]).
-export([init/1, handle_call/2, handle_event/2, handle_info/2, terminate/2,
         code_change/3]).
-export([create_ev/1, create_req/0]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start_link() ->
    Result = gen_event:start_link({global, ?MODULE}),
    gen_event:add_handler({global, ?MODULE}, ?MODULE, []),
    Result.


stop() ->
    gen_event:stop({global, ?MODULE}).


init([]) ->
    {ok, {0, []}}.


handle_call(_Request, {Count, Events}) ->
    io:format("~p events: ~p~n",[Count, Events]),
    {ok, Count, {0, []}}.


handle_event(Event, {Count, Events}) ->
    io:format("event: ~p~n",[Event]),
    {ok, {Count + 1, Events ++ [Event]}}.


handle_info(Info, State) ->
    io:format("~p: ~p~n", [Info, State]).


terminate(_Reason, _State) ->
    ok.


code_change(_OldVersion, State, _Extra) ->
    {ok, State}.


create_ev(Event) ->
    gen_event:notify({global, ?MODULE}, Event).


create_req() ->
    gen_event:call({global, ?MODULE}, ?MODULE, request).
