-- tipo
data Operador = Sumar Int | DividirPor Int | Secuencia [Operador] deriving (Show)

-- foldOperador
foldOperador :: (Int -> a) -> (Int -> a) -> ([a] -> a) -> Operador -> a
foldOperador fSuma fDividir fSecuencia operator = case operator of
    Sumar n -> fSuma n
    DividirPor n -> fDividir n
    Secuencia op -> fSecuencia (map rec op) 
    -- como es una lista de Operador, tenemos que usar map ! 
    -- Esto se debe a que queremos procesar, con las funciones definidas en el fold, cada elemento de la secuencia
        where rec = foldOperador fSuma fDividir fSecuencia

-- falla (existe div por 0)
falla :: Operador -> Bool
falla = foldOperador (\n -> False) (\i -> if i == 0 then True else False) (\l -> or l )

ej1 = Secuencia[Sumar 5, DividirPor 2]
ej2 = Secuencia[Sumar 5, DividirPor 0]

-- aplanar 
aplanar :: Operador -> Operador
aplanar = foldOperador (\o -> Sumar o) (\o -> DividirPor o) (\l -> Secuencia (concatMap listar l))
    where 
        listar (Secuencia lista) = concatMap listar lista   -- buscamos aplanar recursivamente
        listar operacion = [operacion]                      -- caso base cuando ya no hay secuencia


ej3 = Secuencia [Sumar 1, Secuencia[DividirPor 3, Sumar 2]] -- le ponemos deriving (Show) al tipo para poder chequear

-- componerTodas (de izquierda a derecha)
componerTodas ::  [a -> a] -> (a -> a)
componerTodas = foldl (.) id

-- aplicar
-- incompleto
aplicar :: Operador -> Int -> Maybe Int
aplicar = foldOperador 

-- pista 1
aplicacionEntero :: Operador -> Int -> Maybe Int
aplicacionEntero (Sumar i) n = Just (i + n)
aplicacionEntero (DividirPor i) n = if i == 0 the Nothing else Just (div n i)
