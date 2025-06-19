% Práctica 8 - Programación Lógica

% Ejercicio 1 
% Suponemos la siguiente base de conocimiento
% juan es el padre de carlos 
padre(juan, carlos).                                 
padre(juan, luis).
padre(carlos, daniel).
padre(carlos, diego).
padre(luis, pablo).
padre(luis, manuel).
padre(luis, ramiro).

% X es el abuelo de Y cuando/si X es el padre de Z y Z es el padre de Y
abuelo(X,Y) :- padre(X,Z), padre(Z,Y).               

% 1 - consultamos abuelo(X, manuel). X = juan

% 2 - definir hijo, hermano y descendiente como predicados binarios P(A,B) (lo hacemos con una regla)
% X es hijo de Y si  - Y es padre de X
hijo(X,Y) :- padre(Y, X).  

% X es hermano de Y si - Z es padre de X , - Z es padre de Y ; - X e Y no son la misma persona                        
hermano(X,Y) :- padre(Z, X), padre(Z, Y), X \= Y.   

% X es descendiente de Y si: - Y es su padre
descendiente(X,Y) :- padre(Y,X).
%  - Y es su abuelo 
% descendiente(X,Y) :- abuelo(Y,X).
% - Y es su bisabuelo ...  y así entonces podemos recursivamente definir esta relación de parentesco
descendiente(X,Y) :- padre(Y,Z), descendiente(X,Z).

% 3

% 4
% ?- descendiente(X,juan),abuelo(juan,X).
% X = daniel ;
% X = diego ;
% X = pablo ;
% X = manuel ;
% X = ramiro ;

% 5
% ?- hermano(X,pablo).
% X = manuel ;
% X = ramiro.

% 6
% ancestro(X,Y).
% ancestro(X,Y) :- ancestro(Z,Y), padre(X,Z).
% ancestro(juan,X) -> true
% ancestro(juan,X) si pido muchas respuestas, -> true ; true ; ...
% lo que pasa acá es que es un hecho que cualquiera es ancestro de cualquiera : ancestro(_,_) es un hecho
% en la regla, que está definida recursivamente, nunca se logra evaluar padre(X,Z) porque hay infinitas llamadas antes de poder hacerlo
ancestro(X,Y) :- padre(X,Y).
ancestro(X,Y) :- padre(X,Z), ancestro(Z,Y).

% Ejercicio 3
natural(0).
natural(suc(X)) :- natural(X).

% menorOIgual(X,suc(Y)) :- menorOIgual(X,Y).
% menorOIgual(X,X) :- natural(X).

% 1 - si consultamos ?- menorOIgual(0,X).
% ERROR: Stack limit (1.0Gb) exceeded
% ERROR:   Stack sizes: local: 0.9Gb, global: 87.8Mb, trail: 43.9Mb
% ERROR:   Stack depth: 5,751,781, last-call: 0%, Choice points: 5,751,774
% ERROR:   Possible non-terminating recursion:
% ERROR:     [5,751,781] user:menorOIgual(0, _23012478)
% ERROR:     [5,751,780] user:menorOIgual(0, <compound suc/1>)
% esto sucede ya que prolog como no está instanciada Y, llama a menorOIgual(0,Y) y así por siempre
% 2 - circunstancias en las cuales un programa de prolog se cuelga :
% - Una regla recursiva sin caso base
% - Una regla recursiva que tiene al revés los predicados como en este ejemplo
% 3 - corrección
menorOIgual(X,X) :- natural(X).
menorOIgual(X,suc(Y)) :- menorOIgual(X,Y).

% Ejercicio 4 - juntar(?Lista1,?Lista2,?Lista3) :: análogo a append

juntar([],L,L).
juntar([X|Xs], Ys, [X|Zs]) :- juntar(Xs, Ys, Zs).
% juntar([1,2], [3,4]) = [1 | juntar([2], [3,4])]
%                      = [1 | [2 | juntar([], [3,4])]]
%                      = [1 | [2 | [3,4]]]
%                      = [1,2,3,4]

% Ejercicio 5 
last([X|[]],X).
last([X|Xs], Z) :- last(Xs, Z).

last2(X, Y) :- append(L, [Y],X).

invertir([],[]).
invertir([X|Xs], L) :- invertir(Xs,L2), append(L2, [X], L).

prefijo(L, P) :- append(P, _, L).

sufijo(L, S) :- append(_, S, L).

sublista(L, SL) :- append(_, L2, L), append(SL, _, L2).

pertenece(X,[X|_]).
pertenece(X,[_|L]) :- pertenece(X,L).

% Ejercicio 6 
aplanar([], []).
aplanar([X|Xs], L) :- not(is_list(X)), aplanar(Xs,L2), append([X],L2, L).
aplanar([X|Xs], L) :- (is_list(X)), aplanar(X,L3), aplanar(Xs,L4), append(L3,L4, L).
 
% Ejercicio 7
interseccion([],_,[]).
interseccion(L1,L2,L) :- interseccion2(L1,L2,[],L3), reverse(L3, L).

interseccion2([],_,LAcc, LAcc).
interseccion2([X|Xs], L2,LAcc, L) :- not(member(X, L2)), interseccion2(Xs, L2, LAcc,L).
interseccion2([X|Xs], L2,LAcc, L) :- member(X, L2), member(X, LAcc), interseccion2(Xs, L2, LAcc,L).
interseccion2([X|Xs], L2,LAcc, L) :- member(X, L2), not(member(X, LAcc)), interseccion2(Xs, L2, [X|LAcc],L).

% partimos la lista L en L1 (los primeros n-elementos) y L2 (el resto)
partir(0,L,[],L).
partir(N,[X|Xs],[X|L1],L2) :-N > 0, N1 is N-1, partir(N1,Xs, L1,L2). 

% Borrar todas las ocurrencias
borrar(_, [], []).
borrar(X, [X|Xs], L) :- borrar(X, Xs, L).
borrar(X, [H|Xs], [H|L]) :- X \= H, borrar(X, Xs, L).

% Sacar duplicados
sacarDuplicados([],[]).
sacarDuplicados(X,R) :- sacarDuplicados2(X,[],L), reverse(L, R).


sacarDuplicados2([],LAcc,LAcc).
sacarDuplicados2([X|Xs], LAcc, L) :- member(X, LAcc), sacarDuplicados2(Xs,LAcc,L).
sacarDuplicados2([X|Xs], LAcc, L) :- not(member(X, LAcc)), sacarDuplicados2(Xs,[X|LAcc],L).

% Permutación
permutacion([], []).
permutacion(L, [X|P]) :-borrar(X, L, R), permutacion(R, P).

% Reparto(+L,+N, -LListas) es true si LListas es una lista de listas de longitud N de forma que si las concatenamos nos da L
reparto([],0,[]). 
reparto(L,N,[X|Xs]) :- 
    % qué pasa con la longitud ?
    N > 0, N1 is N-1,
    % debe ser una lista concatenada
    append(X, Xs, L),
    % llamamos
    reparto(L, N1, Xs).

% Instanciación y Reversibilidad
desde(X,X).
desde(X,Y) :- N is X+1, desde(N,Y). 
% I. X, de dónde saca el N el X sino ?
desdeReversible(X,X).
desdeReversible(X,Y) :- var(Y), N is X+1, desdeReversible(N,Y).
desdeReversible(X,Y) :- nonvar(Y), Y > X.