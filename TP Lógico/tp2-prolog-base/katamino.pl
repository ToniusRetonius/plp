:- use_module(piezas).

% sublista(+D,+T,+L,-R) D:descarto T: tomo de L: lista
sublista(D,T,L,R) :- 
    % la lenght de la sublista que sacamos es D, si la unimos a sublista-resto es el total de la lista
    append(SLDelete, SLR, L), length(SLDelete, D), 
    % la length del resultado es lo que tomo, y si al resultado le agrego cualquier cosa me da la sublista restante
    append(R, _ , SLR), length(R, T).

% tablero(+K,-T) genera un tablero vacío de K > 0 columnas. (Matriz de 5 X K)
tablero(K,T) :- 
    length(T, 5),
    maplist(lista_vacia(K), T).
% lista vacía de N-elementos
lista_vacia(N,L) :- length(L, N).

% tamaño(+M, -F, -C), dada una matriz si M tiene F filas y C columnas => True (vale para piezas y tablero)
tamaño(M,F,C) :- 
    length(M, F), 
    maplist(lista_vacia(C), M).

% Coordenadas : T  = 5 x K, coordenadas(+T, -IJ) es verdadero para todo par IJ tal que sea una coordenada válida del tablero.
coordenadas(T, (I,J)) :- 
    % medimos la matriz
    tamaño(T,_,C), 
    % los índices van de 1...5 y de 1...K (between)
    between(1,5,I), between(1,C,J). 

% K-Piezas (+K,-PS)
kPiezas(K,PS) :-  
    % piezas
    nombrePiezas(L),
    permutaciones(K,L,PS).
% aux 
permutaciones(0,_,[]).
% con el elemento
permutaciones(K, [X|Xs], [X|Ys]) :- K > 0, K1 is K-1, permutaciones(K1, Xs, Ys).
% sin el elemento 
permutaciones(K, [_|Xs], Ys) :- K > 0, permutaciones(K, Xs,Ys).

% SeccionTablero(+T,+ALTO,+ANCHO, +IJ,?ST)
seccionTablero(T,ALTO,ANCHO,(I,J),ST) :- 
    % vamos a querer sublistar los elementos de T (qué filas necesitamos)
    I1 is I-1, 
    sublista(I1, ALTO, T, Filas),
    % para cada fila, recortamos dejamos y tomamos cuántos ?
    J1 is J-1,
    maplist(sublista(J1, ANCHO),Filas, ST).

% ubicarPieza(+Tablero, +Identificador) genera TODAS las posibles ubicaciones de la pieza en el tablero
ubicarPieza(Tablero, Identificador) :-
    % pieza
    pieza(Identificador, Pieza),
    % tam
    tamaño(Pieza, Alto, Ancho),
    % coord
    coordenadas(Tablero, IJ),
    % seccion (resolver el (1,1) para que se desplace)
    seccionTablero(Tablero, Alto, Ancho, IJ,Pieza).

% ubicarPiezas(+Tablero,+Poda,+Identificadores) 
% Identificadores es una lista de id de piezas
% Poda : es una estrategia de para podar el espacio de búsqueda (usamos sinPoda)
ubicarPiezas(_, _, []).
ubicarPiezas(Tablero, Poda, Identificadores) :- maplist(ubicarPiezaPodado(Tablero,Poda),Identificadores).

% -------- aux --------
ubicarPiezaPodado(Tablero, Poda, Pieza) :- ubicarPieza(Tablero, Pieza), poda(Poda, Tablero).

% llenarTablero(+Poda, +Columnas, -Tablero)
llenarTablero(Poda, Columnas, Tablero) :- 
    % tablero de K-Columnas x 5 
    tablero(Columnas, Tablero),
    % le doy todas las piezas(optimización K-Piezas)
    kPiezas(Columnas,Piezas),
    % ubicalas
    ubicarPiezas(Tablero,Poda,Piezas).

% medición
cantSoluciones(Poda, Columnas, N) :-
findall(T, llenarTablero(Poda, Columnas, T), TS),
length(TS, N).

% ?- time(cantSoluciones(sinPoda,3,N)).       
%  22,674,750 inferences, 3.477 CPU in 4.537 seconds (77% CPU, 6521372 Lips)
% N = 28.
% ?- time(cantSoluciones(sinPoda,4,N)).
% 837,093,195 inferences, 58.074 CPU in 58.103 seconds (100% CPU, 14414141 Lips)
% N = 200

% tenemos que definir una poda de forma que si un tablero no tiene 5 lugares
poda(sinPoda, _).
poda(podaMod5,T) :- todosGruposLibresModulo5(T).

todosGruposLibresModulo5(Tablero) :- 
    % nos generamos las coordenadas libres del tablero -- > findall(Template, Goal, Bag)
    findall((I,J), esCoordenadaLibre(Tablero, (I,J)), ListaCoordenadasLibres),
    % las agrupamos
    agrupar(ListaCoordenadasLibres, CoordenadasLibresAgrupadas),
    % chequeamos que sean grupos de 5 para que potencialmente entre una pieza
    maplist(sublistaMod5, CoordenadasLibresAgrupadas).

% -------- aux -------- 
esCoordenadaLibre(Tablero,(I,J)) :- nth1(I, Tablero, Fila), nth1(J, Fila, Elem), var(Elem).
sublistaMod5(Lista) :- length(Lista, I), 0 is I mod 5.

% % Medición con podaMod5
% ?- time(cantSoluciones(podaMod5, 3,N)).
%  11,025,540 inferences, 0.912 CPU in 0.912 seconds (100% CPU, 12090098 Lips)
% N = 28.

% ?- time(cantSoluciones(podaMod5, 4,N)).
%  228,723,527 inferences, 21.656 CPU in 21.665 seconds (100% CPU, 10561602 Lips)
% N = 200.

% Probar reversibilidad en sublista(+D,+T,+L,-R) sobre D y R. Para probarlo, nos preguntamos si teniendo la instanciación opuesta, produce un resultado adecuado :

%  caso sublista(-D,+T,+L,-R) como length(?List, ?Int) es reversible sobre el segundo parámetro, entonces, length(SLDelete, D) funciona adecuadamente instanciando en D en runtime, es importante destacar el orden de las cláusulas, primero el append, sino se cuelga ya que nunca pasa el length sin sus parámetros instanciados.

% zero
% ?- sublista(X,5,[a,b,c,d],R).
% false.

% one
% ?- sublista(X,4,[a,b,c,d],R).
% X = 0,
% R = [a, b, c, d] ;
% false.

% many
% ?- sublista(X, 2, [a,b,c,d],R).
% X = 0,
% R = [a, b] ;
% X = 1,
% R = [b, c] ;
% X = 2,
% R = [c, d] ;
% false.

%  caso sublista(+D,+T,+L,+R), en este caso, podemos decir que es reversible ya que en [append(R, _ , SLR), length(R, T)] append/3 cumple : append(?List1, ?List2, ?List1AndList2). List1AndList2 is the concatenation of List1 and List2. Por tanto, nos garantiza reversibilidad y length lo mismo como ya vimos.

% zero
% ?- sublista(0,5,[a,b,c,d],[a,b,c,d]).
% false.

% one
% ?- sublista(0,4,[a,b,c,d],[a,b,c,d]).
% true ;
% false.

% caso sublista(-D,+T,+L,+R) el caso en que ambas están en su opuesta instanciación, 

% zero
% ?- sublista(X,5,[a,b,c,d],[a,b,c,d]).
% false.

% one
% ?- sublista(X,4,[a,b,c,d],[a,b,c,d]).
% X = 0 ;
% false.

