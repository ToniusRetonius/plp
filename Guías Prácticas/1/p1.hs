-- Ejericicio 1
-- a)
substr :: (Fractional a) => a -> a -> a
substr x y = x - y
substract = flip substr
predecesor = substract 1

func :: (Num a) => a -> a
func x = x + 10

evaluarEnCero = \f -> f 0 
dosVeces = \f -> f . f

funciones = [(/),(-)]
flipAll = map flip

flipRaro = flip flip

-- b)
max2 :: (Ord a) => a -> a -> a
max2 x y| x >= y = x
        | otherwise = y

-- Ejercicio 2
currificar :: ((a,b) -> c) -> a -> b -> c
currificar f x y = f (x,y)

descurrificar :: (a -> b -> c) -> (a,b) -> c
descurrificar f (x,y) = f x y


-- Ejercicio 3 
foldr' :: (a -> b -> b) -> b -> [a] -> b
foldr' _ z [] = z
foldr' f z (x:xs) = f x (foldr' f z xs)

map' :: (a -> b) -> [a] -> [b]
map' f [] = []
map' f (x:xs) = f x : map' f xs


filter' :: (a -> Bool) -> [a] -> [a]
filter' p [] = []
filter' p (x:xs)        | p x == True = x : filter' p xs
                        | otherwise = filter' p xs


sum' :: (Num a) =>[a] -> a
sum' lista = foldr (+) 0 lista

elem' :: (Eq a) => a -> [a] -> Bool
elem' n = foldr (\x rec -> (x == n) || rec) False

concatenar :: [a] -> [a] -> [a]
concatenar [] ys = ys
concatenar (x:xs) ys = x : concatenar xs ys

concatenar' :: [a] -> [a] -> [a]
concatenar' xs ys = foldr (:) ys xs

concatenar'' :: [a] -> [a] -> [a]
concatenar'' xs ys = foldr (\x rec -> x : rec) ys xs

map'' :: (a -> b) -> [a] -> [b]
map'' f = foldr (\x rec -> f x : rec) []  

filter'' :: (a -> Bool) -> [a] -> [a]
filter'' p xs = foldr (\x rec -> if p x then x : rec else rec) [] xs

mejorSegun :: (a -> a -> Bool) -> [a] -> a 
mejorSegun p (x:xs) = foldr (\y rec -> if p y rec then y else rec) x xs 

foldl' :: (a -> b -> a) -> a -> [b] -> a
foldl' fn acc [] = acc
foldl' fn acc (x:xs) = foldl' fn (fn acc x) xs

sumasParciales :: (Num a) => [a] -> [a]
sumasParciales xs = foldl (\y x -> if null y then [x] else y ++ [last y + x]) [] xs

sumaAlt :: [Int] -> Int
sumaAlt = foldr' (-) 0


---- no funciona :
sumaAlt' :: [Int] -> Int
sumaAlt' = foldl' (flip (-)) 0


-- Ejercicio 4


-- Ejercicio 5 
elementosEnPosicionesPares :: [a] -> [a]
elementosEnPosicionesPares [] = []
elementosEnPosicionesPares (x:xs) = 
        if null xs
        then [x]
        else x : elementosEnPosicionesPares (tail xs)

entrelazar :: [a] -> [a] -> [a]
entrelazar [] = id
entrelazar (x:xs) = 
        \ys -> if null ys
                then x : entrelazar xs []
                else x : head ys : entrelazar xs (tail ys)


-- Ejercicio 6
recr :: (a -> [a] -> b -> b) -> b -> [a] -> b
recr _ z [] = z
recr f z (x:xs) = f x xs (recr f z xs)

sacarUna :: Eq a => a -> [a] -> [a]
sacarUna a = recr (\x xs rec -> if x == a then xs else x : rec) []

sacarUna' a = foldr (\x rec -> if x == a then rec else x : rec) []

-- casos : 
-- 1 [2] => [1,2]
-- 1 [0,2] => [0,1,2]
-- 3 [0,2] => [0,2,3]

insertarOrdenado :: Ord a => a -> [a] -> [a]
insertarOrdenado a = recr (\x xs rec -> 
        if xs == [] then 
                if x < a then x : a : rec 
                else a : x : rec 
        else if a < head xs then x : a : xs 
        else if a > head xs then x : xs 
        else x: rec) []

-- Ejercicio 7
mapPares :: (a -> b -> c) -> [(a,b)] -> [c]
mapPares f = map (uncurry f)


-- armarPares :: [a] -> [b] -> [(a,b)]
-- armarPares = foldr (\x (y:ys) rec -> (x,y) : rec)


-- Ejercicio 9

foldNat :: (Int -> b -> b) -> b -> Int -> b
foldNat _ z 0 = z
foldNat f z n = f n (foldNat f z (n-1))

potenciacion n = foldNat (\x rec -> n * rec) 1

-- Ejercicio 11
data Polinomio a = X | Cte a | Suma (Polinomio a) (Polinomio a) | Prod (Polinomio a) (Polinomio a) deriving (Show)

foldPoli fX fCte fSuma fProd poli = case poli of
        X -> fX
        Cte a -> fCte a
        Suma i d -> fSuma (rec i) (rec d)
        Prod i d -> fProd (rec i) (rec d)
        where rec = foldPoli fX fCte fSuma fProd

evaluar a = foldPoli a id (+) (*)

-- Ejercicio 12
data AB a = Nil | Bin (AB a) a (AB a)
foldAB :: b -> (b -> a -> b -> b) -> AB a -> b
foldAB fNIl fBin t = case t of 
        Nil -> fNIl
        Bin i r d -> fBin (rec i) r (rec d)
        where rec = foldAB fNIl fBin 

esNil :: AB a -> Bool
esNil Nil = True
esNil _ = False

altura = foldAB (const 1) (\reci _ recd-> 1 + max reci recd)

cantNodos = foldAB (const 1) (\reci _ recd -> 1 + recIzq + recd)

-- Ejercicio 13


-- Ejercicio 15
data RoseTree a = Rose a [RoseTree a]

rose = Rose 2 [Rose 3 [], Rose 4 [Rose 5 []]]

foldRose :: (a -> [b] -> b) -> RoseTree a -> b
foldRose f (Rose r rs) = f r (map (foldRose f) rs)
  
hojasRose :: RoseTree a -> [a]
hojasRose = foldRose (\r rec -> if null rec
                                then [r]
                                else concat rec)

ramasRose :: RoseTree a -> [[a]]
ramasRose = foldRose (\r rec -> if null rec
                                then [[r]]
                                else map (r:) (concat rec))

tamañoRose :: RoseTree a -> Int
tamañoRose = foldRose (\_ rec -> 1 + sum rec)

alturaRose :: RoseTree a -> Int
alturaRose = foldRose (\_ rec -> if null rec
                                 then 1
                                 else 1 + maximum rec)
