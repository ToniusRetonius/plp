# Ejercicio 1

```haskell
data Dato a b = C1 | C2 a | C3 b (Dato a b) (Dato a b)

recrDato fC1 fC2 fC3 dato = case dato of
    C1 -> fC1
    C2 x -> fC2 x
    C3 y d1 d2 -> fC3 y d1 d2 (rec d1) (rec d2)
        where rec = recrDato fC1 fC2 fC3

foldDato fC1 fC2 fC3 = recrDato fC1 fC2 (\y d1 d2 recd1 recd2 -> fC3 y recd1 recd2) 

split :: Dato a b -> ([a],[b])
split = foldDato 
    ([],[]) 
    (\x -> ([x],[]))
    (\y (izq1, der1) (izq2, der2) -> (izq1 ++ izq2, y : (der1 ++ der2) ) ) 

```

