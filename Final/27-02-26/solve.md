# Ejercicio 1
```haskell
data ABBComp a = Nil | Comp [a] | Nodo a (ABBComp a) (ABBComp a)

foldABBComp :: b -> ([a] -> b) -> (a -> b -> b -> b) -> ABBComp a -> b
foldABBComp fNil fComp fNodo abb = case abb of
    Nil -> fNil
    Comp lista -> fComp lista
    Nodo x izq der -> fNodo x (rec izq) (rec der)
        where rec = foldABBComp fNil fComp fNodo

mapABBComp :: (a -> b) -> ABBComp a -> ABBComp b
mapABBComp f = foldABBComp Nil (\l -> Comp (map f l)) (\x reci recd -> Nodo (f x) reci recd)

recABBComp :: b -> ([a] -> b) -> (a -> b -> b -> ABBComp a -> ABBComp a -> b) -> ABBComp a -> b
recABBComp fNil fComp fNodo abb = case abb of
    Nil -> fNil 
    Comp l -> fComp l
    Nodo x izq der -> fNodo x (rec izq) (rec der) izq der
        where rec = recABBComp fNil fComp fNodo

```
Queremos verificar el invariante del ABB (los valores del subárbol izquierdo de la raiz son menores (no valen repetidos) y los del derecho son mayores). 
```haskell
ordenado :: ABBComp a -> Bool
ordenado abb = inorder abb == sort (inorder abb)

inorder = foldABBComp [] (\l -> l) (\x reci recd -> reci ++ [x] ++ recd)

iguales :: ABBComp a -> ABBComp a -> Bool
iguales = foldABBComp 
    esNil 
    (\l -> \b -> case b of 
        Nil -> False
        Comp xs -> xs == l
        Nodo x i d -> False
    )
    (\x reci recd -> \b -> case b of
        Nil -> False
        Comp xs -> False
        Nodo y i d -> x == y && (reci i) && (recd d)
    ) 

esNil :: ABBComp a -> Bool
esNil Nil = True
esNil a = False
```