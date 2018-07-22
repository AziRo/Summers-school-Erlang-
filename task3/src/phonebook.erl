-module(phonebook).

%% Application callbacks
-export([read_phonebook/1]).
-export([search_by_name/2]).
-export([search_by_pnumber/2]).

%% ===================================================================
%% Application callbacks
%% ===================================================================


%% Reads a file with records in the format "Id name phone"
%% and translates it to a map
read_phonebook(Filename) ->
    {ok, Data} = file:read_file(Filename),

    Lines = binary:split(Data, [<<"\n">>], [global]),
    Elements = [binary:split(Line, [<<" ">>], [global]) || Line <- Lines],
    Records = [{binary_to_integer(Id), {binary_to_list(Name), binary_to_list(Phone)}} || [Id, Name, Phone] <- Elements],

    maps:from_list(Records).


%% search functions by name and phone
search_by_name(Phonebook, SearchName) ->
    Pred = fun(_, {Name, _}) -> Name =:= SearchName end,
    maps:filter(Pred, Phonebook).


search_by_pnumber(Phonebook, Number) ->
    Pred = fun(_, {_, Phone}) -> Phone =:= Number end,
    maps:filter(Pred, Phonebook).
