-module(receive_client).

-behaviour(websocket_client_handler).

-export([
         receive_/0,
         start_link/1,
         init/2,
         websocket_handle/3,
         websocket_info/3,
         websocket_terminate/3
        ]).


start_link(Ip) ->
    crypto:start(),
    ssl:start(),
    websocket_client:start_link("ws://"++Ip++":8080/receive", ?MODULE, []).

init([], _ConnState) ->
    %websocket_client:cast(self(), {text, <<"init">>}),
    {ok, 2}.

websocket_handle({pong, _}, _ConnState, State) ->
    {ok, State};

websocket_handle({text, Msg}, _ConnState, State) ->
    io:format("receive from server : ~p~n", [Msg]),
    %{reply, {text, Msg}, State}.
    {ok, State};


websocket_handle({binary, Stream}, _ConnState, State) ->
    io:format("receive stream: ~p~n", [Stream]),
    {ok, State}.




websocket_info({text, Msg}, _ConnState, State) ->
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

receive_() ->
    {ok, Pid} = ?MODULE:start_link("10.100.120.210"),
    websocket_client:cast(Pid , {text, <<"RECEIVE#ronalfei">>}),
    ok.
    
