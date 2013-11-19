%%%
%%% Copyright (c) 2011 JackNyfe. All rights reserved.
%%% THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. DO NOT REDISTRIBUTE.
%%%
%%% vim: set ts=4 sts=4 sw=4 et:

-module(erpc).

-export([
    call/4,
    call/5,
    handle_call/3,
    handle_call/4
]).

-ifdef(TEST).
-export([handle_answer/1]).
-endif.

-type result() :: {'badrpc', 'nodedown' | 'timeout'} | term().

-spec call(Node :: node(), Module :: atom(), Function :: atom(), Args :: [term()]) -> result().
call(Node, Module, Function, Args) ->
    %BlogInfo = gtl:get_clerk_info(),
    BlogInfo = undefined,
    handle_answer(rpc:call(Node, ?MODULE, handle_call, [Module, Function, Args, BlogInfo])).

-spec call(Node :: node(), Module :: atom(), Function :: atom(), Args :: [term()], Timeout :: timeout()) -> result().
call(Node, Module, Function, Args, Timeout) ->
    %BlogInfo = gtl:get_clerk_info(),
    BlogInfo = undefined,
    handle_answer(rpc:call(Node, ?MODULE, handle_call, [Module, Function, Args, BlogInfo], Timeout)).

handle_call(Module, Function, Args) ->
    try
        apply(Module, Function, Args)
    catch
        E:R -> {badrpc, {exception, {{E, R}, erlang:get_stacktrace()}}}
    end.

handle_call(Module, Function, Args, BlogInfo) ->
    case BlogInfo of
        undefined -> nop;
        _ -> nop %gtl:set_clerk_info(BlogInfo)
    end,
    handle_call(Module, Function, Args).

handle_answer({badrpc, {exception, {{E, R}, StackTrace}}}) ->
    erlang:raise(E, R, StackTrace);
handle_answer(R) -> R.

