-module(ws_client).

-behaviour(websocket_client_handler).

-export([
         start_link/0,
         init/2,
         websocket_handle/3,
         websocket_info/3,
         websocket_terminate/3
        ]).


start_link() ->
    crypto:start(),
    ssl:start(),
    websocket_client:start_link("ws://10.100.120.210:8080/websocket", ?MODULE, []).

init([], _ConnState) ->
    %websocket_client:cast(self(), {text, <<"init">>}),
    {ok, 2}.

websocket_handle({pong, _}, _ConnState, State) ->
    {ok, State};

websocket_handle({text, Msg}, _ConnState, State) ->
    io:format("pid:~p, cccccccccccccc :~p ~n", [self(), Msg]),
    %{reply, {text, <<"alive">>}, State}.
    {ok, State}.

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
