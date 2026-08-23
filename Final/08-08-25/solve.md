# Ejercicio 1
Decimos que dos tipos son *isomorfos* si :
```haskell
f :: a -> b
g :: b -> a
```
tales que f . g = id y g . f = id
```haskell
Either a b = left a | right b
AB a = nil | bin a (AB a) (AB a)
AX a b = vacio | nodoA a (AX a b) (AX a b) | nodoAB a b (AX a b) (AX a b)
```
Nos piden demostrar que *AX a b* y *AB (Either a (a,b))* son isomorfos. Podemos hacer una sustitución y decir que 
AB (Either a (a,b)) = 
    nil 
    | 
    bin (Either a (a,b)) (AB (Either a (a,b))) (AB (Either a (a,b)))

Para hacer la demo, vamos a definir f y g como sigue

```haskell
f :: AX a b -> AB (Either a (a,b))
f ax = case ax of
    vacio -> nil
    nodoA x i d -> bin (left x) (f i) (f d)
    nodoAB x y i d -> bin (right (x,y)) (f i) (f d)


g :: AB (Either a (a,b)) -> AX a b
g ab = case ab of
    nil -> vacio
    bin r i d -> case r of 
        left x -> nodoA x (g i) (g d)
        right (x,y) -> nodoAB x y (g i) (g d)
```

Luego, queremos ver que **f . g = id  y g . f = id**
Por tanto, postulamos que 

forall ab :: AB (Either a (a,b)). f (g ab)= ab
forall ax :: AX a b. g (f ax) = ax 

