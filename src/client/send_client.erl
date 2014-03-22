-module(send_client).

-behaviour(websocket_client_handler).

-export([
         send/0,
         start_link/1,
         init/2,
         websocket_handle/3,
         websocket_info/3,
         websocket_terminate/3
        ]).


start_link(Ip) ->
    crypto:start(),
    ssl:start(),
    websocket_client:start_link("ws://"++Ip++":8080/send", ?MODULE, []).

init([], _ConnState) ->
    %websocket_client:cast(self(), {text, <<"init">>}),
    {ok, 2}.

websocket_handle({pong, _}, _ConnState, State) ->
    {ok, State};

websocket_handle({text, Msg}, _ConnState, State) ->
    io:format("receive from server : ~p", [Msg]),
    %{reply, {text, Msg}, State}.
    {ok, State}.



websocket_info({text, Msg}, _ConnState, State) ->
    erlang:start_timer(1000, self(), <<"alive2">>),
    {reply, {text, Msg}, _ConnState, State};

websocket_info({timeout, _Ref, _Msg}, _ConnState, State) ->
    %erlang:start_timer(1000, self(), <<"alive2">>),
    %{reply, {text, <<"alive">>}, _ConnState, State};
    {ok, State};

websocket_info(start, _ConnState, State) ->
    %{reply, {text, <<"from client, erlang message received">>}, State}.
    {ok, State}.

websocket_terminate(Reason, _ConnState, State) ->
    io:format("Websocket closed in state ~p wih reason ~p~n",
              [State, Reason]),
    ok.

send() ->
    {ok, Pid} = send_client:start_link("127.0.0.1"),
    websocket_client:cast(Pid , {text, <<"SEND#ronalfei">>}),
    ok.
    
