-module(gen_srv).

-behaviour(gen_server).

%% Application callbacks

-export([start_link/0]).
-export([get_date/0, get_time/0]).
-export([init/1, handle_req/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

get_date() ->
    gen_server:call({global, ?MODULE}, {get_date}).


get_time() ->
    gen_server:call({global, ?MODULE}, {get_time}).


init([]) ->
    process_flag(trap_exit, true),
    {ok, []}.


handle_req(Req) ->
    case Req of
        date ->
            {{Y, M, D}, _T} = calendar:now_to_datetime(erlang:timestamp()),
            io:format("Date: ~p.~p.~p~n", [D, M, Y]),
            {Y, M, D};
        time ->
            {_D, {H, M, S}} = calendar:now_to_datetime(erlang:timestamp()),
            io:format("Time: ~p:~p:~p~n", [H, M, S]),
            {H, M, S};
        _ ->
            ok
    end.


handle_call({get_date}, _From, State) ->
    {reply, handle_req(date), State};


handle_call({get_time}, _From, State) ->
    {reply, handle_req(time), State};


handle_call(_Req, _From, State) ->
    {reply, wrong_req, State}.


handle_cast(_Req, State) ->
    {noreply, State}.


handle_info(Info, State) ->
    {noreply, Info, State}.


terminate(_Reason, _State) ->
    ok.


code_change(_OldVer, State, _Extra) ->
    {ok, State}.
