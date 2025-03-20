-- Ejercicio 2

valorAbsoluto :: Float -> Float
valorAbsoluto n 
    | n < 0 = -n
    | otherwise = n

-- Para saber si un año es bisiesto :
-- Debe (divisible por 4) y (no divisible por 100 o divisible por 400)
bisiesto :: Int -> Bool
bisiesto n 
    | mod n 4 == 0 && mod n 100 /= 0 = True
    | mod n 4 == 0 && mod n 400 == 0 = True
    | otherwise = False

factorial :: Int -> Int
factorial 0 = 1
factorial n = n * (factorial (n-1))


-- Es primo y divide ? Sumo 1
esPrimo :: Int -> Bool
esPrimo 0 = False
esPrimo 1 = False
esPrimo n 
    | n > 1 = not (divideAlguno n (n-1))

-- Divide alguno se fija si entre [1;n] con los extremos que no pertenecen al conj de divisores, divide
divideAlguno :: Int -> Int -> Bool
divideAlguno n 1 = False
divideAlguno n a
    | mod n a == 0 = True
    | otherwise = divideAlguno n (a-1)

-- sacamos divisores
divisores :: Int -> Int -> [Int]
divisores _ 1 = []
divisores a b
    | mod a b == 0 = b : divisores a (b-1)
    | otherwise = divisores a (b-1)

-- cuántos primos ?
cantDivisoresPrimos :: Int -> Int
cantDivisoresPrimos 0 = 0
cantDivisoresPrimos 1 = 0
cantDivisoresPrimos n = contarPrimos (divisores n (n-1)) 0

-- cuántos elementos de la lista son primos
contarPrimos :: [Int] -> Int -> Int
contarPrimos [] cuenta = cuenta
contarPrimos (x:xs) cuenta
    | esPrimo x = contarPrimos xs (cuenta + 1)
    | otherwise = contarPrimos xs cuenta

-- Ejercicio 3

-- el inverso multiplicativo de un número a es el número b tal que 'a x b = 1'
inverso :: Float -> Maybe Float
inverso 0 = Nothing
inverso a = Just (1/a)

-- la idea es convertir una expresión que puede ser booleana a su equivalente (0,1)
-- Se le pasa a la función el parámetro como sigue : aEntero (Left 5) o aEntero (Right (True && False))
aEntero :: Either Int Bool -> Int
aEntero (Left n) = n
aEntero (Right False) = 0
aEntero (Right True) = 1


-- Ejercicio 4

-- Esta función elimina todas las apariciones de los caracteres del primer string en el segundo
-- Ejemplo limpiar ''susto'' ''puerta'', elimina las 's' en puerta, luego la 'u', ... y entonces devuelve ''pera''
-- Se puede usar limpiar "susto" "puerta" también
limpiar :: String -> String -> String
limpiar [] str2 = str2 
limpiar (x:xs) str2
    | elem x str2 = limpiar xs (eliminarChar x str2)
    | otherwise = limpiar xs str2

eliminarChar :: Char -> String -> String
eliminarChar _ [] = []
eliminarChar x (y:ys) 
    | x == y = eliminarChar x ys
    | otherwise = y : eliminarChar x ys
    

-- difPromedio toma una lista de float, calcula el promedio y devuelve otra lista con las diferencias entre el número y el promedio
sumatoria :: [Float] -> Float
sumatoria [] = 0
sumatoria (x:xs) = x + sumatoria xs

elementos :: [Float] -> Float
elementos [] = 0
elementos (x:xs) = 1 + elementos xs

promedio :: [Float] -> Float
promedio [] = 0
promedio x = (sumatoria x) / (elementos x)

difPromedio :: [Float] -> [Float]
difPromedio [] = []
difPromedio lista = 
    let prom = promedio lista
    in [x - prom | x <- lista]

difPromedioMap :: [Float] -> [Float]
difPromedioMap [] = []
difPromedioMap lista = map(\x -> x - promedio(lista)) lista

todosIguales :: [Int] -> Bool
todosIguales [] = True
todosIguales (x:xs)
    | xs /= [] && x == head xs = todosIguales xs
    | xs == [] = True
    | otherwise = False


-- Ejercicio 5
-- Nos dan una definición de un árbol binario ...
data AB a = Nil | Bin (AB a) a (AB a)

-- para probar si funciona tenemos que declarar uno vacío y otro no
arbolVacio :: AB Int
arbolVacio = Nil

arbolNoVacio :: AB Int
arbolNoVacio = Bin Nil 1 Nil

-- ahora implementamos vacío
vacioAB :: AB a -> Bool
vacioAB Nil = True
vacioAB _ = False

-- declaramos el árbol booleano
arbolBool :: AB Bool
arbolBool = Bin (Bin Nil True Nil) False (Bin Nil True Nil)

-- cómo se recorre un árbol binario ?
recorrerAB :: AB a -> [a]
recorrerAB Nil = []
recorrerAB (Bin izq x der) = x : recorrerAB izq ++ recorrerAB der

-- negamos
negacionAB :: AB Bool -> AB Bool
negacionAB Nil = Nil
negacionAB (Bin izq x der) = Bin (negacionAB izq) (not x) (negacionAB der)

-- ahora nos piden el producto de todos los nodos
arbolEnteros :: AB Int
arbolEnteros = Bin (Bin Nil 2 Nil) 3 (Bin Nil 4 Nil)

elementos2 :: [Int] -> Int
elementos2 [] = 0
elementos2 (x:xs) = 1 + elementos2 xs

productoAB :: AB Int -> Int
productoAB arbol
    | total == 0 = 0
    | otherwise = producto lista
    where 
        lista = recorrerAB arbol
        total = elementos2 lista
        producto :: [Int] -> Int
        producto list
            | list == [] = 1
            | otherwise = head list * producto (tail list) 
