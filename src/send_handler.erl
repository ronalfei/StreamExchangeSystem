-module(send_handler).
-behaviour(cowboy_websocket_handler).

-export([init/3]).
-export([websocket_init/3]).
-export([websocket_handle/3]).
-export([websocket_info/3]).
-export([websocket_terminate/3]).

init({tcp, http}, _Req, _Opts) ->
	{upgrade, protocol, cowboy_websocket}.

websocket_init(_TransportName, Req, _Opts) ->
	erlang:start_timer(1000, self(), <<"HI">>),
	{ok, Req, <<>>}.


websocket_handle({text, <<"SEND#", ToUserid/binary>>}, Req, State) ->
    check_ets(pid_map),
    case get_pid(pid_map, <<"RECEIVE#", ToUserid/binary>>) of 
        {ok, Pid} ->
            NewState = <<"SEND#", Pid/binary>>,
            insert_ets(pid_map, {NewState, self()}),%% 把发送流的进程插入到ets, 目前没有太大意义
	        {reply, {text, <<"GO">>}, Req, NewState};
        {error, Reason} ->
            {reply, {text, Reason}, Req, State}
    end;

websocket_handle({text, Msg}, Req, State) ->
	%{reply, {text, << "receive", Msg/binary >>}, Req, State};
	{ok, Req, State};


websocket_handle({binary, Bin}, Req, <<"SEND#", ToPid/binary>>) ->
    erlang:start_timer(0, ToPid, {binary, Bin}),
	{ok, Req, <<"SEND#", ToPid/binary>>};

websocket_handle({binary, Bin}, Req, State) ->
	{ok, Req, State};

websocket_handle(_Data, Req, State) ->
	{ok, Req, State}.




websocket_info({timeout, _Ref, Msg}, Req, State) ->
	{reply, {text, Msg}, Req, State};

websocket_info(_Info, Req, State) ->
	{ok, Req, State}.

websocket_terminate(_Reason, _Req, _State) ->
	ok.



%%------------- ets intenal function------------
init_ets(TableName) ->
    Name = TableName,
    Options = [set, public, named_table, {read_concurrency, true} ],
    ets:new(Name, Options),
    Leader = group_leader(),
    %lager:debug(" group leader for this connnection is ~p", [Leader]),
    ets:give_away(Name, Leader, []).


check_ets(TableName) ->
    case ets:info(TableName) of
        undefined ->
            init_ets(TableName);
        _ -> ok
    end.

insert_ets(TableName, Tuple) ->
    ets:insert(TableName, Tuple).

get_pid(TableName, Key) ->
    case ets:lookup(TableName, Key) of 
        [{Key, Pid}] ->
            {ok, Pid};
        [] -> {error, <<"no pid found">>}
    end.
