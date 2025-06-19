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

capicuaB(L) :- reverse(L,L).

% member
member(X,[X|_]).
member(X,[_|L]) :- member(X,L).

%iesimo(+I, +L, -X)
iesimo(0, [X|_], X).
iesimo(I, [X|XS], Y) :- I2 is I-1, iesimo(I2, XS, Y).

%iesimo(?I, +L, -X)
iesimo2(I, L, X) :- nonvar(I), I >= 0, length(L1, I), append(L1, [X|_], L).
iesimo2(I, L, X) :- var(I), append(L1, [X|_], L), length(L1, I).

%desde(+X, -Y)
desde(X, X).
desde(X, Y) :- N is X+1, desde(N, Y).

%desdeReversible(+X, ?Y)
desdeReversible(X,Y) :- var(Y), desde(X,Y).
desdeReversible(X,Y) :- nonvar(Y), X =< Y.


%pmq(+X, -Y)
pmq(X, Y) :- between(0, X, Y),  par(Y).
% generamos los y, testeamos que cumplan

%par(+Y)
par(Y) :- 0 =:= Y mod 2.


%%%NO HACER ESTO!!!!!!!!!!!!!!!!!!!!!!!!!
%pmq2(+X, -Y)
pmq2(X,Y) :- pares(Y), between(0, X, Y).
%pares(-Y)
pares(Y) :- desdeReversible(0, Y), par(Y).
% !!!!!!!!!!!!!!!!!!!!

%coprimos(-X, -Y)
coprimos(X, Y) :- generarPares(X,Y), X > 0, Y > 0, 1 =:= gcd(X,Y).

%generarPares(-X, -Y)
generarPares(X,Y) :- desde(0, N), paresQueSuman(N, X, Y).

%paresQueSuman(+N, -X, -Y)
paresQueSuman(N, X, Y) :- between(0, N, X), Y is N-X.


progenitorx(yocasta,edipo).
progenitorx(yocasta,antigona).
progenitorx(edipo,antigona).

abuela(X,Y) :- progenitorx(X,Z), progenitorx(Z,Y).

pariente(X,Y) :- progenitorx(X,Y), not(abuela(X,Y)).
pariente(X,Y) :- abuela(X,Y).

%EL NOT NO INSTANCIA 


%corteMásParejo(+L,-L1,-L2)
corteMasParejo(L, I, D) :- append(I, D, L), not(hayUnCorteMasParejo(I,D,L)).

hayUnCorteMasParejo(I,D,L) :- append(I2, D2, L), esMasParejo(I2, D2, I, D).

esMasParejo(I2, D2, I, D) :- sum_list(I2, SI2), sum_list(D2, SD2), 
                             sum_list(I, SI), sum_list(D, SD), 
                             abs(SI - SD) >  abs(SI2 - SD2).




%proximoPrimo(+N,-P) --> instancia P en el menor primo >= N
proximoPrimo(N, N2) :- N2 is N+1, esPrimo(N2).
proximoPrimo(N, P)  :- N2 is N+1, not(esPrimo(N2)), proximoPrimo(N2, P).


% esPrimo(+N)
esPrimo(N) :- N > 1, not(tieneUnDivisorNoTrivial(N)).
tieneUnDivisorNoTrivial(N) :- N1 is N-1, between(2, N1, D), 0 =:= N mod D.


% esTriangulo(+T)
esTriangulo(tri(A,B,C)) :- valido(A,B,C), valido(B,C,A),valido(C,A,B).
% valido(+A, +B, +C)
valido(A, B, C) :- A < B + C.



%perimetro(?T, ?P)
perimetro(tri(A,B,C), P) :- ground(tri(A,B,C)), esTriangulo(tri(A,B,C)), P is A + B + C.
perimetro(tri(A,B,C), P) :- not(ground(tri(A,B,C))), triplasQueSuman(P, A, B, C), esTriangulo(tri(A,B,C)).

%triplasQueSuman(?P, -A, -B, -C)
triplasQueSuman(P, A, B, C) :- 
    desdeReversible(0,P), 
    between(1,P,A), between(1,P,B), 
    C is P - A - B,  C > 0.


%triangulo(-T)
triangulo(T) :- perimetro(T, _).


