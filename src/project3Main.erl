-module(project3Main).
-export([start/2,find/5,registerActors/1]).

start(NumNodes,NumRequests)->
    Log=trunc(math:log2(NumNodes)),
    Nodes=trunc(math:pow(2,Log)),
    registerActors(Nodes),
    register(finding,spawn(chordmain,find,[Nodes,Nodes,NumRequests-1,NumRequests,0])).


find(CurrNode,Nodes,NumRequests,XY,Hops)->
    if
        CurrNode==0 ->
            if
                NumRequests==0 ->
                    io:format("Number of Hops : ~p ~n",[Hops]),
                    T=(Nodes*XY),
                    Avghops=Hops/T,
                    io:format("The Average Hop count : ~p ~n",[Avghops]);
                true ->
                    find(Nodes,Nodes,NumRequests-1,XY,Hops)
            end;
        true ->
            Random =rand:uniform(Nodes),
            if
                CurrNode==Random ->
                    find(CurrNode-1,Nodes,NumRequests,XY,Hops);
                true ->
                    Counter=1,
                    CurrentID=integer_to_list(CurrNode),
                    list_to_atom("actor"++CurrentID) ! {CurrNode,Nodes,Random,Counter},
                    receive
                        {Hop}->
                            find(CurrNode-1,Nodes,NumRequests,XY,Hops+Hop)
                    end
            end 
    end.

registerActors(Nodes)->
    if
        Nodes==0 ->
            ok;
        true ->
            CurrentID=integer_to_list(Nodes),
            register(list_to_atom("actor"++CurrentID),spawn(chordactor,startactor,[])),
            registerActors(Nodes-1)
    end.
