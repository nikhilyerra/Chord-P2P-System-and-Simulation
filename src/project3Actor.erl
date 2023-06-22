-module(project3Actor).
-export([nearest/4,startactor/0]).

nearest(CurrNode,Nodes,Result,Limit)->
    if
        Limit==0 ->
            NextNode=CurrNode+1,
            if
                NextNode>Nodes ->
                   Remainder =(NextNode rem Nodes); 
                true ->
                    Remainder =NextNode
            end;
        true ->
            X=nearest(CurrNode,Nodes,Result,Limit-1),
            Y=CurrNode+trunc(math:pow(2,Limit)),
            if
                Y>Nodes ->
                   Z=Y rem Nodes; 
                true ->
                    Z=Y
            end,
            if
                ((Result-X>=0) and (Result-Z>=0)) ->
                    if
                        X>Z->
                            Remainder =X;
                        true->
                            Remainder =Z
                    end;
                true ->
                    if (Result - X) >= 0 ->
                        Remainder  = X;
                    true ->
                        if (Result - Z) >= 0 ->
                            Remainder  = Z;
                        true ->
                            if
                                X>Z ->
                                    Remainder =X;
                                true ->
                                    Remainder =Z
                            end
                        end
                    end
            end
    end,
    Remainder.

startactor()->
    receive
        {CurrNode,Nodes,Result,Counter}->
            I=trunc(math:log2(Nodes))-1,
            J=nearest(CurrNode,Nodes,Result,I),
            if
                J==Result ->
                    finding ! {Counter},
                    startactor();
                true ->
                    CurrentID=integer_to_list(J),
                    list_to_atom("Actor"++CurrentID) ! {J,Nodes,Result,Counter+1},
                    startactor()
            end,
            startactor()
    end.
            


