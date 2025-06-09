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