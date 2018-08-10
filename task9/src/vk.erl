-module(vk).

%% Application callbacks
-export([find/3]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

find(AccessToken, Start_Id, Dest_Id) ->
    ssl:start(),
    inets:start(),
    {ok, {_,_,Binary}} = httpc:request(
                        "https://api.vk.com/method/friends.get?user_id="
                        ++ Start_Id
                        ++ "&v=5.52" ++ "&access_token=" ++ AccessToken),
    Set = sets:new(),
    Set1 = sets:add_element(Start_Id, Set),
    {[{_,{[{_,_},{_,List}]}}]} = jiffy:decode(Binary),
    find(Set1, List, Dest_Id, AccessToken, 1).



find(_,[],_,_,_) ->
    io:format("empty List~n"),
    failed;

find(_,_,_,_, 3) ->
    io:format("level 3 return~n"),
    failed;

find(Set, [H|T], Dest_Id, AccessToken, Lvl) ->
    io:format("level ~p~n", [Lvl]),
    List_H = integer_to_list(H),
    if
        Dest_Id == List_H ->
            sets:to_list(sets:add_element(List_H, Set));

        true ->

            case sets:is_element(List_H, Set) of
                true ->
                    find(Set, T, Dest_Id, AccessToken, Lvl);

                false ->
                        io:format("~p~n",[List_H]),
                        {ok, {_,_,Binary}} = httpc:request(
                                        "https://api.vk.com/method/friends.get?user_id="
                                        ++ List_H
                                        ++ "&v=5.52" ++ "&access_token=" ++ AccessToken),
                    Set1 = sets:add_element(List_H, Set),

                    case jiffy:decode(Binary) of
                        {[{_,{[{<<"error_code">>,6},_,_]}}]} ->
                            find(Set, [H|T], Dest_Id, AccessToken, Lvl);
                        {[{_,{[{<<"error_code">>,_},_,_]}}]} ->
                            failed;
                        {[{_,{[{_,_},{_,List}]}}]} ->
                            case find(Set1, List, Dest_Id, AccessToken, Lvl + 1) of
                                failed ->
                                    find(Set, T, Dest_Id, AccessToken, Lvl);
                                Result ->
                                    Result
                            end
                    end
            end

    end.
