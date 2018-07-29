-module(task8).

%% Application callbacks
-export([start_link/1, start_web_server/1, handle_web/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================


%% Starting worker
start_link(Port) ->
    Pid = spawn(?MODULE, start_web_server, [Port]),
    {ok, Pid}.


% Web-server
start_web_server(Port) ->
    case gen_tcp:listen(Port, [{active, false}]) of
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
