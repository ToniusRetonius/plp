# Ejercicio 1
Sea 
```haskell
foldu z f [] = z
foldu z f (x:xs) = f (x (foldu z f xs)) (foldu z f xs)
```
El tipo de la función es
```haskell
foldu :: b -> (c -> b -> b) -> [(b -> c)] -> b
```
Nos piden definir 'foldr' usando 'foldu'. Recordemos foldr:
```haskell
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr z f [] = z
foldr z f (x:xs) = f x (foldr z f xs)
```
Entonces
```haskell
foldr z f xs = foldu z f (map (\x -> const x) xs) {HI}
```
Habría que probar que esto es así, entonces decimos que 

foldr z f (x:xs) = foldu z f (map (\y -> const y) (x:xs))
                 = foldu z f ((const x) : map (\y -> const y) xs)
                 = f ((const x) (foldu z f (map (\y -> const y) xs))) (foldu z f (map (\y -> const y) xs))
                 = f x (foldr z f xs) {por HI}
```

Nos piden definir 'foldu' usando 'foldr'

```haskell
foldu z f xs = foldr z ((\x rec -> f (x rec) rec) xs)

foldu z f (x:xs) = foldr z ((\y rec -> f (y rec) rec) (x:xs))
                 = foldr z (f (x rec) rec) ((\y rec -> f (y rec) rec) xs)
                 = (f (x rec) rec) foldu z f xs {HI}
                 = f (x (foldu z f xs )) (foldu z f xs)
```