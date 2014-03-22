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
    %f(10000),

    ok.

f(0) ->
    ok;
f(N) ->
    ws_client:start_link("127.0.0.2"),
    ws_client:start_link("127.0.0.3"),
    ws_client:start_link("127.0.0.4"),
    ws_client:start_link("127.0.0.5"),
    ws_client:start_link("127.0.0.6"),
    ws_client:start_link("127.0.0.7"),
    ws_client:start_link("10.100.120.210"),
    ws_client:start_link("10.100.120.210"),
    ws_client:start_link("10.100.120.210"),
    ws_client:start_link("10.100.120.210"),
    ws_client:start_link("10.100.120.210"),
    ws_client:start_link("10.100.120.210"),
    f(N-1).
