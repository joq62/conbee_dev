%%%-------------------------------------------------------------------
%% @doc conbee public API
%% @end
%%%-------------------------------------------------------------------

-module(conbee_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    application:ensure_all_started(gun),
    db_host_spec:
    {conbee_addr,ConbeeAddr}=lists:keyfind(conbee_addr,1,I),
    {conbee_port,ConbeePort}=lists:keyfind(conbee_port,1,I),
    {conbee_key,ConbeeKey}=lists:keyfind(conbee_key,1,I),
    io:format("~p~n",[{addr,ConbeeAddr,port,ConbeePort,key,ConbeeKey}]),
    ok=application:set_env([{conbee_rel,[{addr,ConbeeAddr},{port,ConbeePort},{key,ConbeeKey}]}]),
    {ok,_}=conbee_sup:start_link().
    

stop(_State) ->
    ok.

%% internal functions
