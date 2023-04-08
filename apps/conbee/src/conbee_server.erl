%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : resource discovery accroding to OPT in Action 
%%% This service discovery is adapted to 
%%% Type = application 
%%% Instance ={ip_addr,{IP_addr,Port}}|{erlang_node,{ErlNode}}
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(conbee_server).
 
-behaviour(gen_server).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("log.api").

%% --------------------------------------------------------------------
-define(ConbeeContainer,"deconz"). 

%% External exports
-export([
	
]).


%% gen_server callbacks



-export([init/1, handle_call/3,handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%%-------------------------------------------------------------------

-record(state,{ip_addr,
	       ip_port,
	       crypto
	      }).


%% ====================================================================
%% External functions
%% ====================================================================


%% ====================================================================
%% Server functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([]) ->
    
    lib_db:dynamic_db_init([]),
    {ok,HostName}=inet:gethostname(),
    [HostSpec]=[HostSpec||HostSpec<-db_host_spec:get_all_id(),
			  {ok,HostName}==db_host_spec:read(hostname,HostSpec)],
    {ok,ApplConfig}=db_host_spec:read(application_config,HostSpec),
    [{conbee,[{conbee_addr,ConbeeAddr},
              {conbee_port,ConbeePort},
              {conbee_key,Crypto}]}
    ]=ApplConfig,
    
    os:cmd("docker restart "++?ConbeeContainer),
    timer:sleep(5*1000),
    ?LOG_NOTICE("Server started ",[{conbee_addr,ConbeeAddr},
				   {conbee_port,ConbeePort},
				   {conbee_key,Crypto}]),
    {ok, #state{ip_addr=ConbeeAddr,
		ip_port=ConbeePort,
		crypto=Crypto}}.   


%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_call({set,DeviceName,DeviceState},_From, State) ->
    ConbeeAddr=State#state.ip_addr,
    ConbeePort=State#state.ip_port,
    Crypto=State#state.crypto,
    Reply=rpc:call(node(),lib_conbee,set,[DeviceName,DeviceState,
					     ConbeeAddr,ConbeePort,Crypto],2*5000),
    {reply, Reply, State};

handle_call({get,DeviceName},_From, State) ->
    ConbeeAddr=State#state.ip_addr,
    ConbeePort=State#state.ip_port,
    Crypto=State#state.crypto,
    Reply=rpc:call(node(),lib_conbee,get,[DeviceName,ConbeeAddr,ConbeePort,Crypto],2*5000),
    {reply, Reply, State};


handle_call({get_all_device_info,DeviceType},_From, State) ->
    ConbeeAddr=State#state.ip_addr,
    ConbeePort=State#state.ip_port,
    Crypto=State#state.crypto,
    Reply=rpc:call(node(),lib_conbee,all_info,[DeviceType,ConbeeAddr,ConbeePort,Crypto],2*5000),
    {reply, Reply, State};

handle_call({device_info,WantedDeviceName},_From, State) ->
    ConbeeAddr=State#state.ip_addr,
    ConbeePort=State#state.ip_port,
    Crypto=State#state.crypto,
    Reply=rpc:call(node(),lib_conbee,device_info,[WantedDeviceName,ConbeeAddr,ConbeePort,Crypto],2*5000),
    {reply, Reply, State};

handle_call({get_state},_From, State) ->
    Reply=State,
    {reply, Reply, State};

handle_call({ping},_From, State) ->
    Reply=pong,
    {reply, Reply, State};

handle_call(Request, From, State) ->
    sd:cast(nodelog,nodelog,log,[warning,?MODULE_STRING,?LINE,["Unmatched signal",
							       Request]]),
    Reply = {unmatched_signal,?MODULE,Request,From},
    {reply, Reply, State}.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_cast(Msg, State) ->
    sd:cast(nodelog,nodelog,log,[warning,?MODULE_STRING,?LINE,["Unmatched signal",
							       Msg]]),
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------

handle_info(timeout, State) -> 
    io:format("timeout ~p~n",[{?MODULE,?LINE}]), 
    
    {noreply, State};

handle_info(Info, State) ->
    sd:cast(nodelog,nodelog,log,[warning,?MODULE_STRING,?LINE,["Unmatched signal",
							       Info]]),
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
