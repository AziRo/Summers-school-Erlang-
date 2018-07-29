-module(task6).

%% Application callbacks
-export([start_udp_rcv/1, handle_udp/1]).
-export([snd_udp/2, snd_tcp/1]).
-export([start_tcp_rcv/1, accept/2, handle_tcp/2]).
-export([start_web_server/0, handle_web/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================


%% UDP active false
start_udp_rcv(Port) ->
    {ok, Socket} = gen_udp:open(Port, [binary, {active, false}]),
    spawn(?MODULE, handle_udp, [Socket]).


handle_udp(Sock) ->
    case gen_udp:recv(Sock, 0, 30000) of
        {ok, {Addr, Port, Msg}} ->
            io:format("[Handler]: ~p~n", [binary_to_list(Msg)]),
            gen_udp:send(Sock, Addr, Port, <<"Hello sender!">>);
        {error, Reason} ->
            Reason
    end.


snd_udp(PortFrom, PortTo) ->
    {ok, Socket} = gen_udp:open(PortFrom, [binary, {active, false}]),
    io:format("Socket = ~p~n", [Socket]),
    gen_udp:send(Socket, "localhost", PortTo, <<"Hello receiver!">>),
    case gen_udp:recv(Socket, 0, 30000) of
        {ok, {_, _, Msg}} ->
            io:format("[Client]: ~p~n", [binary_to_list(Msg)]);
        {error, Reason} ->
            Reason
    end.


%% TCP active true
start_tcp_rcv(Port) ->
    case gen_tcp:listen(Port, [binary, {active, true}]) of
        {ok, ListenSocket} ->
            [spawn(?MODULE, accept, [Id, ListenSocket]) || Id <- lists:seq(1, 5)],
            timer:sleep(infinity);
        {error, Reason} ->
            Reason
    end.


accept(Id, ListenSocket) ->
    io:format("Accept ~p started.~n",[Id]),
    {ok, _} = gen_tcp:accept(ListenSocket),
    io:format("New connection!~n"),
    handle_tcp(Id, ListenSocket).


handle_tcp(Id, ListenSocket) ->
    receive
        {tcp, Sock, Msg} ->
            io:format("[Handler ~p]: ~p~n", [Id, binary_to_list(Msg)]),
            gen_tcp:send(Sock, <<"Hello sender!">>),
            handle_tcp(Id, ListenSocket);
        {tcp_closed, _} ->
            accept(Id, ListenSocket)
    end.


snd_tcp(Port) ->
    case gen_tcp:connect("localhost", Port, [binary, {active, true}]) of
        {ok, Socket} ->
            io:format("Socket = ~p~n", [Socket]),
            gen_tcp:send(Socket, <<"Hello receiver!">>),
            receive
                {tcp, Socket, Msg} ->
                    io:format("[Client]: ~p~n", [binary_to_list(Msg)]),
                    gen_tcp:close(Socket)
            end;
        {error, Reason} ->
            Reason
    end.


%% Web-server
start_web_server() ->
    case gen_tcp:listen(80, [{active, false}]) of
        {ok, ListenSocket} ->
            spawn(?MODULE, handle_web, [ListenSocket]),
            timer:sleep(infinity);
        {error, Reason} ->
            {error, Reason}
    end.


handle_web(ListenSocket) ->
    io:format("Start handle!~n"),
    {ok, Socket} = gen_tcp:accept(ListenSocket),
    io:format("New connection!~n"),

    gen_tcp:send(Socket,
        "HTTP/1.1 200 OK\r\nContent-Length: 65\r\nContent-Type: text/html\r\n
        <html><body><h1 align = 'center'>Hello Sender!</h1></body></html>"),
    gen_tcp:close(Socket),
    handle_web(ListenSocket).
