# Ejercicio 1
Tipo algebraico que describe a las adjunciones de árboles binarios

```haskell
data AdjAB a = Raiz a [AB a] | Adj [AB a]
data AB a = Nil | Hoja a | Arb a (AB a) (AB a)


foldAdjAB :: (a -> [b] -> b) -> ([b] -> b) ->  b -> (a -> b) -> (a -> b -> b -> b) -> AdjAB a -> b
foldAdjAB fRaiz fAdj fNil fHoja fArb adjAB = case adjAB of
    Raiz x xs -> fRaiz x (map rec xs)
    Adj xs -> fAdj (map rec xs)
        where rec = foldAB fNil fHoja fArb


foldAB :: b -> (a -> b) -> (a -> b -> b -> b) -> AB a -> b
foldAB fNil fHoja fArb ab = case ab of
    Nil -> fNil
    Hoja x -> fHoja x
    Arb x i d -> fArb x (rec i) (rec d)
        where rec = foldAB fNil fHoja fArb


mapAdjAB f = foldAdjAB (\x xs -> Raiz (f x) xs) (\l -> Adj l) Nil (\y -> Hoja (f y)) (\z i d -> Arb (f z) i d)


recAdjAB :: (a -> [b] -> [AB a] -> b) -> ([b] -> [AB a] -> b) ->  b -> (a -> b) -> (a -> b -> b -> AB a -> AB a -> b) -> AdjAB a -> b
recAdjAB fRaiz2 fAdj2 fNil2 fHoja2 fArb2 adjAB = case adjAB of
    Raiz x xs -> fRaiz2 x (map rec xs) xs 
    Adj xs -> fAdj2 (map rec xs) xs
        where rec = recAB fNil2 fHoja2 fArb2

recAB :: b -> (a -> b) -> (a -> b -> b -> AB a -> AB a -> b) -> AB a -> b
recAB fNil2 fHoja2 fArb2 ab = case ab of
    Nil -> fNil2
    Hoja x -> fHoja2 x
    Arb x i d -> fArb2 x (rec i) (rec d) i d
        where rec = recAB fNil2 fHoja2 fArb2


-- extrae la primera componente (el booleano) de cada tupla de la lista
valorBooleano :: [(Bool, Maybe a, Maybe a)] -> [Bool]
valorBooleano = foldr (\(a,b,c) rec -> a : rec) []

ordenado :: Ord a => AdjAB a -> Bool
ordenado = foldAdjAB fRaiz fAdj fNil fHoja fArb
  where
    fNil = (True, Nothing, Nothing)
    fHoja x = (True, Just x, Just x)

    -- fArb x (rec i) (rec d) donde los resultados son las tuplas
    fArb x (okI, minI, maxI) (okD, minD, maxD) =
      let 
          -- si maxI es Nothing => poné True ; análogo con el otro lado
          -- si maxI tiene un valor (i.e Just m) => el resultado es m <= x
          cumpleIzq = maybe True (<= x) maxI
          cumpleDer = maybe True (x <=) minD
          -- el nodo actual es ABB si cumple a izq y a der
          ok = okI && okD && cumpleIzq && cumpleDer
          -- calculamos máximo del derecho y el mínimo del izq (en caso de que no haya nada,ponemos a x)
          nuevoMin = maybe (Just x) Just minI
          nuevoMax = maybe (Just x) Just maxD
      in (ok, nuevoMin, nuevoMax)

    -- nuevas: fRaiz y fAdj reciben la lista de tuplas de cada árbol,
    -- se quedan con los booleanos (valorBooleano) y ven si todos son True
    fAdj resultados = all id (valorBooleano resultados)
    fRaiz x resultados = all id (valorBooleano resultados)
```