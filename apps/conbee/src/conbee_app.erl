%%%-------------------------------------------------------------------
%% @doc conbee public API
%% @end
%%%-------------------------------------------------------------------

-module(conbee_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    application:ensure_all_started(gun),
    {ok,_}=conbee_sup:start_link().
    

stop(_State) ->
    ok.

%% internal functions
