-module(task8_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(Id, Module), {Id, {Module, start_link, [Id]}, permanent, 5000, worker, [Module]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    {ok, { {one_for_one, 5, 10}, [
                ?CHILD(1234, task8),
                ?CHILD(2345, task8),
                ?CHILD(3456, task8)
            ]
        }
    }.
