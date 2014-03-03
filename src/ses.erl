-include("ses.hrl").
-module(ses).
-export([start/0, start_link/0, test/0]).
-export([stop/0]).  

start()->
    lager:start(), 
    application:start(ranch), 
    lager:info("ranch ok"),
    application:start(cowlib),
    lager:debug("cowlib ok"),
    application:start(crypto),
    lager:warning("crypto ok"),
    application:start(cowboy),
    lager:error("cowboy ok"),
    application:start(websocket).

start_link()->
    application:start(websocket).

stop()->
    application:stop(websocket).

test() ->
    lager:debug("asdfasdf"),
    lager:info("asdfasdf"),
    lager:notice("asdfasdf"),
    lager:warning("asdfasdf"),
    lager:error("asdfasdf"),
    lager:critical("asdfasdf"),
    lager:alert("asdfasdf"),
    lager:emergency("asdfasdf"),
    ok.

