-module(task5).

-include("task5.hrl").

%% Application callbacks
-export([test_pow/2]).
-export([phonebook_node/1, start/2, cancel/1]).
-export([read/2, search_by_name/2, search_by_pnumber/2]).

%% ===================================================================
%% Application callbacks
%% ===================================================================


%% Testing macro Pow
test_pow(Value, Power) ->
    ?Pow(Value, Power).


%% Function of node
phonebook_node(Phonebook) ->
    receive
        {From, {read_phonebook, Filename}} ->
            Map = phonebook:read_phonebook(Filename),
            From ! {self(), ok},
            phonebook_node(Map);
        {From, {search_by_name, Name}} ->
            Clients = phonebook:search_by_name(Phonebook, Name),
            From ! {self(), Clients},
            phonebook_node(Phonebook);
        {From, {search_by_pnumber, Phone}} ->
            Clients = phonebook:search_by_pnumber(Phonebook, Phone),
            From ! {self(), Clients},
            phonebook_node(Phonebook);
        cancel ->
            ok;
        {From, _} ->
            From ! {self(), unknown_request},
            phonebook_node(Phonebook)
    end.


%% Starting of node
start(Node, Phonebook) ->
    spawn(Node, ?MODULE, phonebook_node, [Phonebook]).


%% Close of node
cancel(Pid) ->
    Pid ! cancel.


%% Read phonebook request
read(Pid, Filename) ->
    Pid ! {self(), {read_phonebook, Filename}},
    receive
        {Pid, Resp} -> Resp
    after 5000 ->
        timeout
    end.


%% Search by name request
search_by_name(Pid, Name) ->
    Pid ! {self(), {search_by_name, Name}},
    receive
        {Pid, Resp} -> Resp
    after 5000 ->
        timeout
    end.


%% Serch by phone request
search_by_pnumber(Pid, Phone) ->
    Pid ! {self(), {search_by_pnumber, Phone}},
    receive
        {Pid, Resp} -> Resp
    after 5000 ->
        timeout
    end.
