-module(receive_handler).
-include("ses.hrl").
-behaviour(cowboy_websocket_handler).

-export([init/3]).
-export([websocket_init/3]).
-export([websocket_handle/3]).
-export([websocket_info/3]).
-export([websocket_terminate/3]).

init({tcp, http}, _Req, _Opts) ->
	{upgrade, protocol, cowboy_websocket}.

websocket_init(_TransportName, Req, _Opts) ->
	erlang:start_timer(0, self(), <<"HI">>),
	{ok, Req, <<>>}.


websocket_handle({text, <<"RECEIVE#", MyUserid/binary>>}, Req, _State) ->
    check_ets(pid_map),
    NewState = <<"RECEIVE#", MyUserid/binary>>,
    insert_ets(pid_map, {NewState, self()}),   %把自己的pid放进去
    {reply, {text, <<"OK">>}, Req, NewState};

websocket_handle({text, _Msg}, Req, State) ->
	%{reply, {text, << "receive", Msg/binary >>}, Req, State};
	{ok, Req, State};

websocket_handle({binary, _Bin}, Req, State) ->
	{ok, Req, State};

websocket_handle(_Data, Req, State) ->
	{ok, Req, State}.




websocket_info({binary, Bin}, Req, State) ->
	{reply, {binary, Bin}, Req, State};


websocket_info({text, Msg}, Req, State) ->
	{reply, {text, Msg}, Req, State};


websocket_info({timeout, _Ref, Msg}, Req, State) ->
	{reply, {text, Msg}, Req, State};



websocket_info(Info, Req, State) ->
    lager:warning("receive info : ~p", [Info]),
	{ok, Req, State}.

websocket_terminate(_Reason, _Req, _State) ->
	ok.



%%------------- ets intenal function------------
init_ets(TableName) ->
    Name = TableName,
    Options = [set, public, named_table, {read_concurrency, true} ],
    ets:new(Name, Options),
    Leader = group_leader(),
    lager:warning(" group leader for this connnection is ~p", [Leader]),
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
