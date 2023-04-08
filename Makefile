#	Makefile for rebar3 RELEASE 
all:
	rm -rf  *~ apps/conbee/src/*~ *~ apps/conbee/src/*.beam test/*.beam test/*~ erl_cra* config/*~;
	rm -rf _build ebin test_ebin;
	rm -rf common sd api;
	rm -rf Mnesia.* logs;
	rebar3 release;
	rm -rf _build*;
	git add  *;
	git commit -m $(m);
	git push;
	echo Ok there you go!make
build:
	rm -rf  *~ apps/conbee/src/*~ *~ apps/conbee/src/*.beam test/*.beam test/*~ erl_cra* config/*~;
	rm -rf common sd api;
	rm -rf Mnesia.* logs;
	rm -rf  _build/test; # A bugfix in rebar3 or OTP
	rm -rf  _build;
	rebar3 release;
	rm -rf _build*

clean:
	rm -rf  *~ apps/conbee/src/*~ *~ apps/conbee/src/*.beam test/*.beam test/*~ erl_cra* config/*~;
	rm -rf _build ebin test_ebin;
	rm -rf common sd api;
	rm -rf Mnesia.* logs;

prod:
	rm -rf  *~ apps/conbee/src/*~ *~ apps/conbee/src/*.beam test/*.beam test/*~ erl_cra* config/*~;
	rm -rf _build ebin test_ebin;
	rm -rf common sd api;
	rm -rf Mnesia.* logs;
	rebar3 as prod release;
	rebar3 as prod tar;
	rm /home/joq62/erlang/infra/api_repo/conbee.api;
	cp api/*.api /home/joq62/erlang/infra/api_repo;
	mv _build/prod/rel/conbee/*.tar.gz ../release 

eunit:
	rm -rf  *~ apps/conbee/src/*~ *~ apps/conbee/src/*.beam test/*.beam test/*~ erl_cra* config/*~;
	rm -rf _build ebin test_ebin;
	rm -rf common sd api;
	rm -rf Mnesia.* logs;
	rebar3 release;
	mkdir api;
	cp apps/conbee/src/*.api api;
	mkdir test_ebin;
	erlc -I api -I /home/joq62/erlang/infra/api_repo -o test_ebin test/*.erl;
	erl -pa _build/default/lib/*/* -pa test_ebin -sname do_test -run $(m) start $(a) $(b) -setcookie $(c)
