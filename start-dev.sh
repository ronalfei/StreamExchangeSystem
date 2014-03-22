#!/bin/sh
erl -name ses@10.100.1.83 -pa ebin -pa deps/*/ebin -s ses -s reloader \
 +K true \
 +A 128 \
 -env ERL_MAX_PORTS 6400000 \
 -env ERL_FULLSWEEP_AFTER 0 \
 -smp enable \
 +zdbbl 32768 \
 -setcookie ses \
 -eval "io:format(\"* Eventsource: http://localhost:8080/~n~n~n\"). " 
 %-detached 
