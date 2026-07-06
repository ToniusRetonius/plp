# Ejercicio 1


```haskell
data Trie a = TrieNodo (Maybe a) [(Char, Trie a)]

foldTrie :: (Maybe a -> [(Char, b)] -> b) -> Trie a -> b
foldTrie fTrieNodo (TrieNodo v hijos) = fTrieNodo v (map (\(c,t) -> (c, rec t)) hijos )
    where rec = foldTrie fTrieNodo
```

Idea : todos pegan las letras de sus hijos a la lista foldeada de palabras que viene de abajo, si es Just, suman un "" sino, nada. El chiste es que map (x:) [] = [] por eso si la hoja es Nothing no la agrega
```haskell
palabras :: Trie a -> [[Char]]
palabras = foldTrie (\v hijos -> 
    let palabrasDeLosHijos = concatMap (\(c,ps) -> map (c:) ps) hijos
    in case v of
        Nothing -> palabrasDeLosHijos
        Just _ -> "" : palabrasDeLosHijos
        ) 
```
** No se puede usar 'where' dentro de una lambda, por eso usamos let..in

```haskell
mapTrie :: (a -> b) -> Trie a -> Trie b
mapTrie f = foldTrie (\v hijos -> TrieNodo (fAux f v) hijos)

fAux :: (a -> b) -> Maybe a -> Maybe b
fAux f Nothing = Nothing
fAux f (Just x) = Just (f x)
```
** otra manera: inline sería
```haskell
mapTrie :: (a -> b) -> Trie a -> Trie b
mapTrie f = foldTrie (\v hijos -> 
    TrieNodo (case v of 
        Nothing -> Nothing
        Just x -> Just (f x) 
    ) hijos
)
```
No alcanza con mapTrie ya que por transparecia referencia/pureza: una función pura, ante entradas iguales, obligatoriamente produce salidas iguales. Y cuando tengamos el caso (True,1) vs (True,2), con mapTrie los tratamos a ambos de la misma manera, sin conocer la profundidad, por eso..
```haskell
mapTrieConProfundidad :: (Int -> a -> b) -> Trie a -> Trie b
mapTrieConProfundidad f = foldTrie (\v hijos -> \profundidad -> ...)
```
