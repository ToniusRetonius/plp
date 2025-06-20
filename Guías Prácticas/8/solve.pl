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


% 6
% mal
% ancestro(X,Y).
% ancestro(X,Y) :- ancestro(Z,Y), padre(X,Z).
% corregida 
ancestro(X,Y) :- padre(X,Y).
ancestro(X,Y) :- padre(X,Z), ancestro(Z,Y).

% Ejercicio 2
% original
% vecino(X, Y, [X|[Y|_]]).
% vecino(X, Y, [_|Ls]) :- vecino(X, Y, Ls).
% invertido
vecino(X, Y, [_|Ls]) :- vecino(X, Y, Ls).
vecino(X, Y, [X|[Y|_]]).

% Ejercicio 3
natural(0).
natural(suc(X)) :- natural(X).

% menorOIgual(X,suc(Y)) :- menorOIgual(X,Y).
% menorOIgual(X,X) :- natural(X).
% corrección
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
last([_|Xs], Z) :- last(Xs, Z).

last2(X, Y) :- append(_, [Y],X).

invertir([],[]).
invertir([X|Xs], L) :- invertir(Xs,L2), append(L2, [X], L).

prefijo(L, P) :- append(P, _, L).

sufijo(L, S) :- append(_, S, L).

% sublista(L, SL) :- append(_, L2, L), append(SL, _, L2).
sublista(_, []).
sublista(L, SL) :- prefijo(L, P), sufijo(P, SL), SL \= [].

pertenece(X,[X|_]).
pertenece(X,[_|L]) :- pertenece(X,L).

% Ejercicio 6 
aplanar([], []).
aplanar([X|Xs], L) :- not(is_list(X)), aplanar(Xs,L2), append([X],L2, L).
aplanar([X|Xs], L) :- (is_list(X)), aplanar(X,L3), aplanar(Xs,L4), append(L3,L4, L).
 
% Ejercicio 7
interseccion([],_,[]).
interseccion(L1,L2,L) :- interseccion2(L1,L2,[],L3), reverse(L3,L).

interseccion2([],_,LAcc,LAcc).
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
% Ejercicio 9
desde(X,X).
desde(X,Y) :- N is X+1, desde(N,Y). 

desdeReversible(X,X).
desdeReversible(X,Y) :- var(Y), N is X+1, desdeReversible(N,Y).
desdeReversible(X,Y) :- nonvar(Y), Y > X.

% Ejercicio 11 - 
% En prolog definimos los Bin como 'nil' si es vacío, bin(izq, v, der) donde v es el valor del nodo
vacio(nil).

raiz(bin(izq, V, der), V).

altura(nil,0).
altura(bin(Izq,_,Der), Altura) :- altura(Izq, AltIzq), altura(Der, AltDer), AltDer >= AltIzq,  Altura is AltDer+1.
altura(bin(Izq,_,Der), Altura) :- altura(Izq, AltIzq), altura(Der, AltDer), AltDer < AltIzq,  Altura is AltIzq+1.

cantDeNodos(nil,0).
cantDeNodos(bin(Izq, _, Der), CantNodos) :- cantDeNodos(Izq, CantNodosIzq),  cantDeNodos(Der, CantNodosDer), SumSubarboles is CantNodosDer + CantNodosIzq, CantNodos is  SumSubarboles + 1.

% test : T = bin(bin(nil, a, nil), b, bin(nil, c, nil)), altura(T, A), cantDeNodos(T, N).

% Ejercicio 12
% inorder(+AB, -Lista)
inorder(nil, []).
inorder(bin(Izq, V, Der), Lista) :- inorder(Izq, LadoIzq), inorder(Der, LadoDer), append(LadoIzq, [V| LadoDer], Lista).

arbolConInorder([], nil).
arbolConInorder(Lista, bin(Izq, V, Der)) :-  append(LadoIzq, [V | LadoDer], Lista), arbolConInorder(LadoIzq, Izq), arbolConInorder(LadoDer, Der).

% test : arbolConInorder([1,2,3], T), inorder(T, L).

aBB(nil).
aBB(bin(Izq, V, Der)) :- aBB(Izq),aBB(Der), inorder(Izq, LadoIzq), mayorATodos(V, LadoIzq), inorder(Der, LadoDer), menorIgual(V, LadoDer).

mayorATodos(X, Lista) :- forall(member(E, Lista), X > E).
menorIgual(X, Lista) :- forall(member(E, Lista), X =< E).

% test : aBB(bin(bin(bin(nil, 2, nil), 3, nil), 5, bin(bin(nil, 6, nil), 7, bin(nil, 8, nil)))). -> True
% test : aBB(bin(bin(bin(nil, 2, nil), 3, nil), 5, bin(bin(nil, 8, nil), 7, bin(nil, 6, nil)))). -> False

aBBInsertar(X, nil, bin(nil, X, nil)). 
% caso X es menor a la raiz
aBBInsertar(X, bin(Izq, V, _), bin(IzqRes, V, _)) :- X < V, aBBInsertar(X, Izq, IzqRes).
% caso X >= Raiz
aBBInsertar(X, bin(_, V, Der), bin(_, V, DerRes)) :- X >= V, aBBInsertar(X, Der, DerRes).

% test nil : aBBInsertar(5, nil, T).
% test izq : aBBInsertar(3, bin(nil, 5, nil), T).
% test der :  aBBInsertar(7, bin(nil, 5, nil), T).
% test complex : Complex = bin(bin(nil, 3, nil), 5, bin(nil, 7, nil)), aBBInsertar(4, Complex, T).

% Generate and Test 
% Ejercicio 13
%coprimos(-X, -Y)
coprimos(X, Y) :- generarPares(X,Y), X > 0, Y > 0, 1 =:= gcd(X,Y).

%generarPares(-X, -Y)
generarPares(X,Y) :- desde(0, N), paresQueSuman(N, X, Y).

%paresQueSuman(+N, -X, -Y)
paresQueSuman(N, X, Y) :- between(0, N, X), Y is N-X.

% Ejercicio 14

% Ejercicio 15 
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

% Negación por Falla y Cut
frutal(frutilla).
frutal(banana).
frutal(manzana).
cremoso(banana).
cremoso(americana).
cremoso(frutilla).
cremoso(dulceDeLeche).

% original
% leGusta(X) :- frutal(X), cremoso(X).
% cucurucho(X,Y) :- leGusta(X), leGusta(Y).

% 1! en le gusta (encuentra una fruta que cumpla con frutal y cremoso y no explora otra)
% leGusta(X) :- frutal(X), cremoso(X), !.
% cucurucho(X,Y) :- leGusta(X), leGusta(Y).

% 2! en le gusta (encuentra una fruta que cumpla frutal no explora otra que sea frutal y luego busca cremoso )
% leGusta(X) :- frutal(X), !, cremoso(X).
% cucurucho(X,Y) :- leGusta(X), leGusta(Y).

% 3! en le gusta (lo mismo que el original)
% leGusta(X) :- !,frutal(X), cremoso(X).
% cucurucho(X,Y) :- leGusta(X), leGusta(Y).

% 1! en cucurucho (encuentra un par que cumple y lo devuelve)
% leGusta(X) :- frutal(X), cremoso(X).
% cucurucho(X,Y) :- leGusta(X), leGusta(Y), !.

% 2! en cucurucho (no repite, da los resultados bien)
% leGusta(X) :- frutal(X), cremoso(X).
% cucurucho(X,Y) :- leGusta(X), !, leGusta(Y).

% 3! en cucurucho (lo mismo que el original)
% leGusta(X) :- frutal(X), cremoso(X).
% cucurucho(X,Y) :- !,leGusta(X), leGusta(Y).

% Ejercicio 18
%corteMásParejo(+L,-L1,-L2)
corteMasParejo(L, I, D) :- append(I, D, L), not(hayUnCorteMasParejo(I,D,L)).

hayUnCorteMasParejo(I,D,L) :- append(I2, D2, L), esMasParejo(I2, D2, I, D).

esMasParejo(I2, D2, I, D) :- 
    sum_list(I2, SI2), sum_list(D2, SD2), 
    sum_list(I, SI), sum_list(D, SD), 
    abs(SI - SD) >  abs(SI2 - SD2).
