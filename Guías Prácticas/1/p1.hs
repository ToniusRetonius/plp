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


