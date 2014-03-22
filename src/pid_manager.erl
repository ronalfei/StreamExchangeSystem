-include("ses.hrl").
-module(pid_manager).


-export([init/0]).
-export([check/0]).
-export([add_pid/1]).
-export([get_pid/1]).

-define(TABLE_NAME, pid_map).

init() ->
    Name = ?TABLE_NAME,
    Options = [set, public, named_table, {read_concurrency, true} ],
    ets:new(Name, Options),
    Leader = group_leader(),
    lager:warning(" group leader for this connnection is ~p", [Leader]),
    ets:give_away(Name, Leader, []).


check() ->
    case ets:info(?TABLE_NAME) of
        undefined ->
            init();
        _ -> ok
    end.

add_pid(Tuple) ->
    check(),
    ets:insert(?TABLE_NAME, Tuple).

get_pid(Key) ->
    check(),
    case ets:lookup(?TABLE_NAME, Key) of 
        [{Key, Pid}] ->
            {ok, Pid};
        [] -> {error, <<"no pid found">>}
    end.
