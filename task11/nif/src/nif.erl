-module(nif).

-on_load(init/0).

%% Application callbacks
-export([fact/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

init() ->
    erlang:load_nif("priv/nif_fact", 0).


fact(_) ->
    {error}.
