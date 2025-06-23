% Ejercicio 20
natural(0).
natural(suc(X)) :- natural(X).

%  
mayorOIgual(suc(X),Y) :- mayorOIgual(X,Y).
mayorOIgual(X,X) :- natural(X).

% si consultamos mayorOIgual(suc(suc(N)), suc(0)).  -->
% ERROR: Stack limit (1.0Gb) exceeded
% ERROR:   Stack sizes: local: 0.9Gb, global: 87.9Mb, trail: 43.9Mb
% ERROR:   Stack depth: 5,749,042, last-call: 0%, Choice points: 5,749,035
% ERROR:   Possible non-terminating recursion:
% ERROR:     [5,749,042] user:mayorOIgual(_23038330, <compound suc/1>)
% ERROR:     [5,749,041] user:mayorOIgual(<compound suc/1>, <compound suc/1>)

% si invertimos el orden de las reglas no se cuelga.