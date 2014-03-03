{application,websocket,
             [{description,"Cowboy websocket example."},
              {vsn,"1"},
              {modules,[reloader,ses,websocket_app,websocket_sup,ws_handler]},
              {registered,[websocket_sup]},
              {applications,[kernel,stdlib,cowboy]},
              {mod,{websocket_app,[]}},
              {env,[]}]}.
