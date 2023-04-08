%% Author: uabjle
%% Created: 10 dec 2012
%% Description: TODO: Add description to application_org
-module(conbee).

-compile({no_auto_import,[get/1]}).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

-include("log.api").


-define(SERVER,list_to_atom(atom_to_list(?MODULE)++"_server")).
%% --------------------------------------------------------------------
%% Internal exports
%% --------------------------------------------------------------------


-export([
	 %lights
	 set/2,
	 get/1,
	 device_info/1,
	 get_all_device_info/1,
	 set/3,
	 get/2,
	 device_info/2,
	 get_all_device_info/2
	 % 

	]).


-export([
	 start/0,
	 start/1,
	 stop/0,
	 stop/1, 
	 get_state/0,
	 get_state/1,
	 ping/0,
	 ping/1

	]).


%% --------------------------------------------------------------------
%% Macros
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Records
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% API Functions
%% --------------------------------------------------------------------
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
device_info(DeviceName,_SenderInfo)->
    ?LOG_NOTICE("Input ",[DeviceName]),
    T1=os:system_time(millisecond),
    Result=device_info(DeviceName),
    T2=os:system_time(millisecond),
    ?LOG_NOTICE("Result ",["ExecutionTime = ",T2-T1," Result= ",Result]),
    Result.

device_info(DeviceName)->
    gen_server:call(?SERVER, {device_info,DeviceName},infinity).

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
set(DeviceName,DeviceState,_SenderInfo)->
    ?LOG_NOTICE("Input ",[DeviceName,DeviceState]),
    T1=os:system_time(millisecond),
    Result=set(DeviceName,DeviceState),
    T2=os:system_time(millisecond),
    ?LOG_NOTICE("Result ",["ExecutionTime = ",T2-T1," Result= ",Result]),
    Result.

set(DeviceName,DeviceState)->
    gen_server:call(?SERVER, {set,DeviceName,DeviceState},infinity).

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
get(DeviceName,_SenderInfo)->
    ?LOG_NOTICE("Input ",[DeviceName]),
    T1=os:system_time(millisecond),
    Result=get(DeviceName),
    T2=os:system_time(millisecond),
    ?LOG_NOTICE("Result ",["ExecutionTime = ",T2-T1," Result= ",Result]),
    Result.

get(DeviceName)->
    gen_server:call(?SERVER, {get,DeviceName},infinity).

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
get_all_device_info(DeviceType,_SenderInfo)->
    ?LOG_NOTICE("Input ",[DeviceType]),
    T1=os:system_time(millisecond),
    Result=get_all_device_info(DeviceType),
    T2=os:system_time(millisecond),
    ?LOG_NOTICE("Result ",["ExecutionTime = ",T2-T1," Result= ",Result]),
    Result.

get_all_device_info(DeviceType)->
    gen_server:call(?SERVER, {get_all_device_info,DeviceType},infinity).




%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
ping(_SenderInfo)->
    ?LOG_NOTICE("Input ",[]),
    T1=os:system_time(millisecond),
    Result=ping(),
    T2=os:system_time(millisecond),
    ?LOG_NOTICE("Result ",["ExecutionTime = ",T2-T1," Result= ",Result]),
    Result.
ping() ->
    gen_server:call(?SERVER, {ping},infinity).
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
get_state(_SenderInfo)->
    ?LOG_NOTICE("Input ",[]),
    T1=os:system_time(millisecond),
    Result=get_state(),
    T2=os:system_time(millisecond),
    ?LOG_NOTICE("Result ",["ExecutionTime = ",T2-T1," Result= ",Result]),
    Result.

get_state() ->
    gen_server:call(?SERVER, {get_state},infinity).

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

start(_SenderInfo)->
    ?LOG_NOTICE("Input ",[]),
    T1=os:system_time(millisecond),
    Result=start(),
    T2=os:system_time(millisecond),
    ?LOG_NOTICE("Result ",["ExecutionTime = ",T2-T1," Result= ",Result]),
    Result.

start()->
    gen_server:start_link({local, ?SERVER}, ?SERVER, [], []).
    
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
stop(_SenderInfo)->
    ?LOG_NOTICE("Input ",[]),
    T1=os:system_time(millisecond),
    Result=stop(),
    T2=os:system_time(millisecond),
    ?LOG_NOTICE("Result ",["ExecutionTime = ",T2-T1," Result= ",Result]),
    Result.

stop()->
    gen_server:call(?SERVER, {stop},infinity).





%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

%% ====================================================================!
%% External functions
%% ====================================================================!


%% ====================================================================
%% Internal functions
%% ====================================================================
