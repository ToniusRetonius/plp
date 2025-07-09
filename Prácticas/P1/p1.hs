curry :: ((a,b) -> c) -> a -> b -> c
curry f x y = f (x,y)
-- curry f es de tipo a -> b -> c
-- x es de tipo a 
-- y es de tipo b 
-- haskell lee (curry f) x y 

-- Alternativas:
-- curry f = \x -> \y -> f (x,y)
-- curry f = \x y -> f (x,y)

uncurry :: (a -> b -> c) -> (a,b) -> c
uncurry f = \(x,y) -> f x y
-- = uncurry f (x,y) = f x y 

triple :: Float -> Float
triple = (*) 3
-- Haskell inifere el tipo Num a => a -> a 
-- Esto está evaluado parcialmente  

esMayorDeEdad :: Int -> Bool
esMayorDeEdad = (<) 17 
-- = (17<) 
-- > :: Int -> Int -> Bool ; (>) 5 3 = True 

(.) :: (b -> c) -> (a -> b) -> a -> c
(.) f g x = f (g x)
-- Alternativas:
-- (.) f g = \x -> f (g x)
-- g . f x = f (g x) 

flip :: (a -> b -> c) -> (b -> a -> c)
-- Tambien podría haber puesto flip ((a->b)->c) -> (b->a->c) 
flip f = \x -> \y -> f y x
-- Alternativas:
-- flip f = \x y -> f y x
-- flip f x y = f y x

($) :: (a -> b) -> a -> b
($) f = f
-- Toma una función y argumento, y devuelve la función aplicada al argumento. 
-- Sirve para omitir paréntesis. Ejemplo: f(g(h x)) = f $ g $ h $ x. 
-- Como $ asocia a derecha, haskell lee f $ (g $ (h$x)). 

const :: a -> (b -> a)
const x = \_ -> x
-- Alternativas:
-- const x _ = x
-- const = \x -> \_ -> x
-- const x = \y ->  x 
-- const = \x -> \y -> c
-- OJO: const \x -> x es la identidad 

-- ((==0) . (flip mod 2)) 6
-- = (==0) ((flip mod 2) 6)
-- = (==0) (mod 6 2)
-- = (==0) 0
-- = True

-- maximo :: Ord a => [a] -> a
-- maximo [x] = x
-- maximo (x:xs) = if x > maximo xs then x else maximo xs

-- minimo :: Ord a => [a] -> a
-- minimo [x] = x
-- minimo (x:xs) = if x < minimo xs then x else minimo xs

-- listaMasCorta :: [[a]] -> [a]
-- listaMasCorta [xs] = xs
-- listaMasCorta (xs:xss) = if length xs < length (listaMasCorta xss)
--                          then
--                             xs
--                          else
--                             listaMasCorta xss
-- Obs: toma bien el length xs < length (listaMasCorta xss) y no lo toma como (length xs < length) (listaMasCorta xss) 
-- porque la aplicación de funciones tiene precedencia más alta que los operadores como <, -, *, /, ^, ==, >, &&, ||, :, ++, =, <- etc. 

mejorSegun :: (a -> a -> Bool) -> [a] -> a
-- Entra un predicado que devuelve true si el primer parámetro es mejor que el segundo 
mejorSegun _ [x] = x
mejorSegun p (x:xs) = if p x rec then x else rec
    where rec = mejorSegun p xs
-- mejorSegun p (x:xs) = if (p x (mejorSegun p xs)) then x else (mejorSegun p xs) 

maximo :: Ord a => [a] -> a
maximo = mejorSegun (>)

minimo :: Ord a => [a] -> a
maximo = mejorSegun (<)

listaMasCorta :: [[a]] -> [a]
listaMasCorta = mejorSegun (\x1 x2 -> length x1 < length x2)

deLongitudN :: Int -> [[a]] -> [[a]]
deLongitudN n = filter (\x -> length x == n)
-- deLongitudN n xs = filter (\x -> length x == n) xs 

soloPuntosFijosEnN :: Int -> [Int->Int] -> [Int->Int]
soloPuntosFijosEnN n = filter (\f -> f n == n)

-- Podemos usar reverse :: [a] -> [a]
reverseAnidado :: [[Char]] -> [[Char]]
reverseAnidado = reverse . (map reverse)
-- Es lo mismo que:
-- reverseAnidado xs = reverse (map reverse xs). Acá no podes sacar ni el xs ni los paréntesis 
--                   = \XS -> reverse (map reverse xs)
--                   = reverse . (map reverse) -- Dado XS aplico map reverse y después reverse 

paresCuadrados :: [Int] -> [Int]
paresCuadrados = map (\x -> if even x then x*x else x)

suma :: [Int] -> Int
suma [] = 0
suma (x:xs) = x + suma xs

suma' :: [Int] -> Int
suma' = foldr (+) 0
-- Es lo mismo que:
-- suma' = foldr (\x rec -> x + rec)  0

and = foldr (&&) True 

-- listaComp f xs p = [f x | x <- xs, p x]
-- Ahora usando map y filter
-- Agarra [a], la filtra segun (a->Bool), y a lo que queda le aplica (a->b) a cada elemeneto. 
listaComp :: (a->b) -> [a] -> (a->Bool) -> [b] 
listaComp f xs p = map f (filter p xs) 

