:- module(piezas, [nombrePiezas/1,pieza/2,mostrar/1,agrupar/2]).

nombrePiezas([a, b, c, d, e, f, g, h, i, j, k, l]).

pieza(I, E) :-
	forma(I, F),
	orientaciones(F, FS),
	member(FXO, FS),
	build(FXO, I, E).

forma(a, [[x, x], [x, o], [x, o], [x, o]]).
forma(b, [[o, x, o, o], [x, x, x, x]]).
forma(c, [[x, x, x, o], [o, o, x, x]]).
forma(d, [[x, x, x], [o, o, x], [o, o, x]]).
forma(e, [[o, x, x], [x, x, x]]).
forma(f, [[x, x, x], [x, o, x]]).
forma(g, [[o, x, o], [x, x, o], [o, x, x]]).
forma(h, [[x, x, x], [o, x, o], [o, x, o]]).
forma(i, [[x, x, o], [o, x, o], [o, x, x]]).
forma(j, [[o, o, x], [o, x, x], [x, x, o]]).
forma(k, [[o, x, o], [x, x, x], [o, x, o]]).
forma(l, [[x, x, x, x, x]]).

orientaciones(F, O) :-
	rotar(F, F1),
	rotar(F1, F2),
	rotar(F2, F3),
	flip(F, E),
	rotar(E, E1),
	rotar(E1, E2),
	rotar(E2, E3),
	list_to_set([F, F1, F2, F3, E, E1, E2, E3], O).

flip([], []).
flip([H|T], [R|RT]) :-
	reverse(H, R),
	flip(T, RT).

rotar([], []).
rotar([HF|TF], R) :-
	rotar(TF, RTF),
	reverse(HF, RHF),
	consAll(RHF, RTF, R).

consAll(L, [], T) :-
	consAllAux(L, T).
consAll([H|HS], [T|TS], [[H|T]|R]) :-
	consAll(HS, TS, R).

consAllAux([], []).
consAllAux([H|HS], [[H]|T]) :-
	consAllAux(HS, T).

build([], _, []).
build([HFXO|TFXO], I, [HE|TE]) :-
	buildF(HFXO, I, HE),
	build(TFXO, I, TE).

buildF([], _, []).
buildF([x|TF], I, [I|T]) :-
	buildF(TF, I, T).
buildF([o|TF], I, [_|T]) :-
	buildF(TF, I, T).



mostrar(M) :-
	strM(M, S),
	writef(S).

ansiColor(black, '\x1B[30m').
ansiColor(red, '\x1B[31m').
ansiColor(green, '\x1B[32m').
ansiColor(yellow, '\x1B[33m').
ansiColor(blue, '\x1B[34m').
ansiColor(magenta, '\x1B[35m').
ansiColor(cyan, '\x1B[36m').
ansiColor(white, '\x1B[37m').

style(a, red, '██').
style(b, green, '██').
style(c, blue, '██').
style(d, red, '▓▓').
style(e, green, '▓▓').
style(f, blue, '▓▓').
style(g, red, '▒▒').
style(h, green, '▒▒').
style(i, blue, '▒▒').
style(j, red, '░░').
style(k, green, '░░').
style(l, blue, '░░').
style(free, white, '  ').

reset('\x1B[39m\x1B[49m').

string_concat_many([], '').
string_concat_many([H|T], S) :-
	string_concat_many(T, ST),
	string_concat(H, ST, S).

str(Id, S) :-
	reset(R),
	style(Id, Color, C),
	ansiColor(Color, ColorCode),
	string_concat_many([R, ColorCode, C, R], S).

strM(T, S) :-
	[TH|_] = T,
	length(TH, N),
	border(N, B),
	strMAux(T, ST),
	string_concat_many(['╔', B, '╗\n', ST, '╚', B, '╝\n'], S).

border(0, '').
border(N, S) :-
	N > 0,
	Nm1 is N - 1,
	border(Nm1, S1),
	string_concat('══', S1, S).

strMAux([], '').
strMAux([MH|MT], S) :-
	strL(MH, S1),
	strMAux(MT, S2),
	string_concat(S1, S2, S).
  
strL(L, S) :-
	strLAux(L, S1),
	string_concat('║', S1, S).

strLAux([], '║\n').
strLAux([LH|LT], S) :-
	var(LH),
	str(free, S1),
	strLAux(LT, S2),
	string_concat(S1, S2, S).
strLAux([LH|LT], S) :-
	nonvar(LH),
	str(LH, S1),
	strLAux(LT, S2),
	string_concat(S1, S2, S).

agrupar([], []).
agrupar([P|PS], Grupos) :-
	agrupar(PS, GruposPS),
	combinar(P, GruposPS, Grupos).

% combinar(Pieza, Grupos, GrupoCombinado, RestoGrupos).
combinar(Pieza, Grupos, [[Pieza|GrupoCombinado]|RestoGrupos]) :-
	combinarAux(Pieza, Grupos, GrupoCombinado, RestoGrupos).

% combinarAux(Pieza, Grupos, GrupoCombinado, RestoGrupos).
% * No agrega Pieza a GrupoCombinado
combinarAux(_, [], [], []).
combinarAux(P, [G|GT], GC, RG) :-
	combinarAux(P, GT, GC1, RG1),
	combinarGrupo(P, G, GC0, RG0),
	append(GC0, GC1, GC),
	append(RG0, RG1, RG).

combinarGrupo(P, G, G, []) :-
	pegado(P, G).
combinarGrupo(P, G, [], [G]) :-
	 \+ pegado(P, G).

pegado(P, G) :-
	member(E, G),
	vecinos(E, P),
	!.

vecinos((I1, J1), (I2, J2)) :-
	DI is abs(I1 - I2),
	DJ is abs(J1 - J2),
	DM is DI + DJ,
	DM =< 1.
