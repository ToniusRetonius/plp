% base de conocimiento
zombie(juan).
zombie(valeria).

tomo_mate_despues(juan,carlos).
tomo_mate_despues(clara,juan).

infectado(ernesto).
infectado(X) :- zombie(X).
infectado(X) :- zombie(Y), tomo_mate_despues(Y,X).


% Ejercicio - Naturales con el 0
natural(cero).
natural(suc(M)) :- natural(M).


mayorA2(suc(suc(suc(_)))). % podemos hacerlo explícitamente
% mayorA2(suc(suc(suc(X)))) :- natural(X). de manera de generar todos

esPar(cero).
esPar(suc(suc(X))) :- esPar(X). % si X es par, entonces el sucesor del sucesor también lo es

menor(cero, suc(_)). % cero es más chico que todos
menor(suc(X),suc(Y)) :- menor(X,Y).

% reversible
append([], Ys, Ys).
append([X|Xs], Ys, [X|Zs]) :- append(Xs, Ys, Zs).

% predicado no-reversible
suma(X, Y, Z) :- Z is X + Y.

% ejercicio 2 - entre
entre(X,Y,X) :- X =< Y. 
entre(X,Y,Z) :- X < Y, X1 is X + 1, entre(X1, Y, Z). 

long([], 0).
long([_|T], N) :- long(T, N1), N is N1 + 1.

sacarTodas(_, [], []).
sacarTodas(X, [X|T], R) :- sacarTodas(X, T, R).
sacarTodas(X, [H|T], [H|R]) :- X \= H, sacarTodas(X, T, R).

sinConsecRep([], []).
sinConsecRep([X], [X]).
sinConsecRep([X,X|T], R) :- sinConsecRep([X|T], R).
sinConsecRep([X,Y|T], [X|R]) :- X \= Y, sinConsecRep([Y|T], R).

% ejercicios 3
prefijo(L, P) :- append(P, _, L).

sufijo(L, S) :- append(_, S, L).

sublista(L, SL) :- append(_, L2, L), append(SL, _, L2).

insertar(X, L, LX) :- append(P, S, L), append(P, [X|S], LX).

sacarUna(X, [X|T], T).
sacarUna(X, [H|T], [H|R]) :- sacarUna(X, T, R).

permutacion([], []).
permutacion(L, [X|P]) :-sacarUna(X, L, R), permutacion(R, P).

% capicua
capicua([]).
capicua([_]).
capicua([H|T]) :- append(M, [H], T), capicua(M).

capicuaB ( L ) : - reverse (L , L ).

% member
member(X,[X|_]).
member(X,[_|L]) :- member(X,L).