
-module(send_client).
-include("../ses.hrl").
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


websocket_handle({text, <<"GO">>}, _ConnState, State) ->
    %{reply, {text, Msg}, State}.
lager:notice("1111111111111111111"),
Self = self(),
    spawn(fun() -> loop(Self) end),
lager:notice("22222222222222222"),
    %{reply, {binary, <<"bbbbbbbb">>}, _ConnState, State};
    {ok, State};


websocket_handle({text, Msg}, _ConnState, State) ->
    lager:notice("receive from server : ~p~n", [Msg]),
    %{reply, {text, Msg}, State}.
    {ok, State}.


websocket_info({text, <<"GO">>}, _ConnState, State) ->
lager:notice("3333333333333333"),
lager:notice("self() :~p", [self()]),
    websocket_client:cast(self(), {text, <<"GO">>}),
    {reply, {binary, <<"bbbbbbbb">>}, _ConnState, State};


websocket_info({text, Msg}, _ConnState, State) ->
lager:notice("4444444444444"),
    {reply, {text, Msg}, _ConnState, State};

websocket_info({timeout, _Ref, _Msg}, _ConnState, State) ->
    %erlang:start_timer(1000, self(), <<"alive2">>),
    %{reply, {text, <<"alive">>}, _ConnState, State};
    {ok, State};


websocket_info(start, _ConnState, State) ->
    %{reply, {text, <<"from client, erlang message received">>}, State}.
    {ok, State};


websocket_info(Info, _ConnState, State) ->
    %{reply, {text, <<"from client, erlang message received">>}, State}.
lager:notice("555555555555555"),
    {ok, State}.

websocket_terminate(Reason, _ConnState, State) ->
    io:format("Websocket closed in state ~p wih reason ~p~n",
              [State, Reason]),
    ok.

send() ->
    {ok, Pid} = ?MODULE:start_link("127.0.0.1"),
lager:notice("pid:~p", [Pid]),
    websocket_client:cast(Pid , {text, <<"SEND#ronalfei">>}),
    ok.
    
loop(Pid) ->
    websocket_client:cast(Pid ,  {binary, <<"bbbbbbbb">>}),
    receive
    after 3000 ->
        loop(Pid)
    end.
