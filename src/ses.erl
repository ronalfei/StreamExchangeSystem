-include("ses.hrl").
-module(ses).
-export([start/0, start_link/0, test/0]).
-export([stop/0]).  

start()->
    lager:start(), 
    application:start(ranch), 
lager:info("ranch ok"),
    application:start(cowlib),
lager:info("cowlib ok"),
    application:start(crypto),
lager:info("crypto ok"),
    application:start(cowboy),
lager:info("cowboy ok"),
    application:start(websocket).

start_link()->
    application:start(websocket).

stop()->
    application:stop(websocket).

test() ->
    lager:info("asdfasdf").
