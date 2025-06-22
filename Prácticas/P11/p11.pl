% Ej
natural(0).
natural(suc(X)) :- natural(X).

% se cuelga con  menorOIgual(0,X).
% menorOIgual(X,suc(Y)) :- menorOIgual(X,Y).
% menorOIgual(X,X) :- natural(X).

% no se cuelga con menorOIgual(0,X).
menorOIgual(X,X) :- natural(X).
menorOIgual(X,suc(Y)) :- menorOIgual(X,Y).

% preorder(bin(bin(nil,2,nil),1,nil),Lista).
preorder(nil,[]).
preorder(bin(I,R,D),[R|L]) :- append(LI,LD,L), preorder(I,LI), preorder(D,LD).

append([],YS,YS).
append([X|XS],YS,[X|L]) :- append(XS,YS,L).