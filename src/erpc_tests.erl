%%% 
%%% Copyright (c) 2008-2014 JackNyfe, Inc. <info@jacknyfe.com>
%%% All rights reserved.
%%%
%%% vim: set ts=4 sts=4 sw=4 et:

-module(erpc_tests).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

-export([
    test_callback/1
]).

test_callback(Fun) ->
    Fun().

positive_test() ->
    ?assertEqual(ok, test_call(fun() ->
        ok
    end)).

exception_test() ->
    ?assertEqual({error, someerror},
        try
            test_call(fun() ->
                erlang:error(someerror)
            end),
            '$ok'
        catch
            C:R -> {C, R}
        end).

% test private functions

test_call(Fun) ->
    erpc:handle_answer(erpc:handle_call(?MODULE, test_callback, [Fun])).

-endif.
