# EJ 1
```haskell
foldAt :: (a -> b) -> ((indice -> b) -> b) -> AT a -> b
foldAT fHoja fNodo at = case at of
	Hoja x -> fHoja x
	Nodo f -> fNodo (\i -> rec (f i))
		where rec = foldAt fHoja fNodo
```		

La altura la define la rama más larga =>

```haskell
altura :: AT a -> Int 
altura = foldAt (const 1) (\f -> max (max (f I1) (f I2) ) (f I3) + 1)
```		

mapAT es una fn que aplica a las hojas de un árbol trébol cierta f

```haskell
mapAT :: (a -> b) -> AT a -> AT b
mapAT f = foldAT (\x -> Hoja (f x)) (\g -> Nodo g)
```		
o lo que es lo mismo : 
```haskell
mapAT f = foldAT (Hoja . f) Nodo
```		
