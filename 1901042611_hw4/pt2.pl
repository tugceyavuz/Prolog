:- style_check(-singleton).

% knowledge base

schedule(ankara,rize,5).
schedule(ankara,van,4).
schedule(van,gaziantep,3).
schedule(canakkale,erzincan,6).
schedule(erzincan,antalya,3).
schedule(antalya,izmir,2).
schedule(izmir,istanbul,2).
schedule(antalya,diyarbakir,4).
schedule(diyarbakir,ankara,8).
schedule(izmir,ankara,6).
schedule(ankara,istanbul,1).
schedule(istanbul,rize,4).


schedule(rize,ankara,5).
schedule(van,ankara,4).
schedule(gaziantep,van,3).
schedule(erzincan,canakkale,6).
schedule(antalya,erzincan,3).
schedule(izmir,antalya,2).
schedule(istanbul,izmir,2).
schedule(diyarbakir,antalya,4).
schedule(ankara,diyarbakir,8).
schedule(ankara,izmir,6).
schedule(istanbul,ankara,1).
schedule(rize,istanbul,4).

schedule(erzincan,izmir,5).
schedule(izmir,erzincan,5).
schedule(van,rize,4).
schedule(rize,van,4).


%rules
connection_base(X,Y,C) :- schedule(X,Y,C). % X and Y are connected if there is a schedule between them with cost C

% check if there is a connection between X and Y
% check connection between X and Y, with Y as the first element in the visited cities list
connection(X,Y,C):- check_connection(X, Y, [Y|Rest],C).

% search for a connection between X and Y, with X as the first element in the visited cities list
check_connection(X, Y,Connections,C) :- search_connection(X, Y,X,Connections,C).

% if X and Y are already connected
search_connection(X, Y, P, [Y|P],C) :- connection_base(X,Y,C).

% define search connection rule for when X and Y are not yet connected
% check if there is a connection between X and some other city Z
% search for a connection between Z and Y, with Z as the first element in the visited cities list
% total cost is the sum of the cost of the connection between X and Z and the cost of the connection between Z and Y
search_connection(X, Y, Connections, A, C) :- connection_base(X, Z, C1),not(Z == Y), not(in(Z, Connections)), not(Z == X),           
                                        search_connection(Z, Y, [Z|Connections],A,C2), C is C1+C2.

%To check whether an element is in array
in(E, [E|Rest]).
in(E, [I|Rest]):- in(E, Rest).