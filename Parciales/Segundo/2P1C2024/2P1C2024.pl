% Hechos base
estudiante(juan).
estudiante(maria).

notas([tripla(juan, algebra, 8),tripla(maria, analisis, 6),tripla(maria, algebra, 7)]).

% Saber si un estudiante tiene aprobada una materia
tieneMateriaAprobada(E, M) :-
    notas(Notas),
    member(tripla(E, M, Nota), Notas),
    Nota >= 4.

% Eliminar aplazos si el estudiante finalmente aprobó esa materia
eliminarAplazos([], []).
eliminarAplazos([(E, M, N)|Xs], [(E, M, N)|Ns]) :-
    N >= 4,
    eliminarAplazos(Xs, Ns).
eliminarAplazos([(E, M, N)|Xs], [(E, M, N)|Ns]) :-
    N < 4,
    \+ tieneMateriaAprobada(E, M),
    eliminarAplazos(Xs, Ns).
eliminarAplazos([(E, M, N)|Xs], Ns) :-
    N < 4,
    tieneMateriaAprobada(E, M),
    eliminarAplazos(Xs, Ns).

% Extraer notas de un estudiante
notasAlumno(_, [], []).
notasAlumno(A, [tripla(E, M, N)|Xs], [(E, M, N)|Filtradas]) :-
    A = E,
    notasAlumno(A, Xs, Filtradas).
notasAlumno(A, [tripla(E, _, _)|Xs], Filtradas) :-
    A \= E,
    notasAlumno(A, Xs, Filtradas).

extraerNota((_, _, N), N).

% Promedio de una lista de notas
prom([], 0).
prom(L, P) :-
    length(L, Lg),
    sum_list(L, S),
    P is S / Lg.

% Promedio de un estudiante
promedio(E, P) :-
    notas(Notas),
    notasAlumno(E, Notas, NotasE),
    eliminarAplazos(NotasE, NotasSinAplazos),
    maplist(extraerNota, NotasSinAplazos, SoloNotas),
    prom(SoloNotas, P).

tupla_promedio(E, (E, P)) :- promedio(E, P).

mayorProm([X], X).
mayorProm([(E1, P1), (E2, P2)|Xs], Max) :-
    P1 >= P2, mayorProm([(E1, P1)|Xs], Max).
mayorProm([(E1, P1), (E2, P2)|Xs], Max) :-
    P1 < P2,  mayorProm([(E2, P2)|Xs], Max).

mejorA(A) :-
    findall(E, estudiante(E), Estudiantes),
    maplist(tupla_promedio, Estudiantes, Promedios),
    mayorProm(Promedios, (A, _)).
