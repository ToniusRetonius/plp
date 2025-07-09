
{--
take' :: [a] -> Int -> [a]
take' []     n = []
take' (x:xs) n = if n == 0
                 then []
                 else x : take' xs (n-1)
--}

{--
take' :: [a] -> Int -> [a]
take' []     = const []
take' (x:xs) = \n -> if n == 0
                     then []
                     else x : take' xs (n-1)
--}

take' :: [Int] -> Int -> [Int]
take' = foldr (\x rec -> \n -> if n == 0
                               then []
                               else x : rec (n-1)) (const []) -- take' definida por foldr


-- Árbol estrictamente binario

data AEB a = Hoja a | Bin (AEB a) a (AEB a)

aeb :: AEB Int
aeb = Bin (Hoja 3) 5 (Bin (Hoja 7) 8 (Hoja 1))

foldAEB :: (a -> b) -> (b -> a -> b -> b) -> AEB a -> b
foldAEB fHoja fBin t = case t of
    Hoja n      -> fHoja n
    Bin t1 n t2 -> fBin (rec t1) n (rec t2)
  where
    rec = foldAEB fHoja fBin

alturaAEB :: AEB a -> Int
alturaAEB = foldAEB (const 1) (\recI _ recD -> 1 + max recI recD)

ramasAEB :: AEB a -> [[a]]
ramasAEB = foldAEB (\x -> [[x]]) (\recI r recD -> map (r:) (recI ++ recD))

cantNodosAEB :: AEB a -> Int
cantNodosAEB = foldAEB (const 1) (\recI _ recD -> 1 + recI + recD)

cantHojasAEB :: AEB a -> Int
cantHojasAEB = foldAEB (const 1) (\recI _ recD -> recI + recD)

-- Recuerden que los constructores también son funciones
espejoAEB :: AEB a -> AEB a
espejoAEB = foldAEB Hoja (\recI r recD -> Bin recD r recI)

                    
-- Polinomio, notar que tiene dos constructores no recursivos y dos recursivos

data Polinomio a = X
                 | Cte a
                 | Suma (Polinomio a) (Polinomio a)
                 | Prod (Polinomio a) (Polinomio a)

p :: Polinomio Int
p = Suma (Prod X X) (Cte 1)

foldPoli :: b -> (a -> b) -> (b -> b -> b) -> (b -> b -> b) -> Polinomio a -> b 
foldPoli cX cCte cSuma cProd p = case p of
    X         -> cX
    Cte k     -> cCte k
    Suma p' q -> cSuma (rec p') (rec q)
    Prod p' q -> cProd (rec p') (rec q)
  where
    rec = foldPoli cX cCte cSuma cProd
-- Usa case of en vez de pattern matching. Es lo mismo pero case of escribe menos y podes usar un solo where porque es ua sola ecuación

evaluar :: Num a => a -> Polinomio a -> a
{- 
Evaluar e p = case e of 
	x -> e 
	Cte i -> i 
	Suma p' q -> (evaluar e p') + (evaluar e q) 
	Prod p' q -> (evaluar e p') * (evaluar e q) 
-}
evaluar e = foldPoli e id (+) (*)

-- RoseTree, estructura con un único constructor recursivo

data RoseTree a = Rose a [RoseTree a]

rose = Rose 2 [Rose 3 [], Rose 4 [Rose 5 []]]

foldRose :: (a -> [b] -> b) -> RoseTree a -> b
foldRose f (Rose r rs) = f r (map (foldRose f) rs)
-- Con map (map (foldRose f) rs). A cada RoseTree de rs le aplica la función foldrRose f. Así obtiene [b]. Luego combina eso con r usando f. 
  
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

-- Conj, funciones como estructuras de datos

type Conj a = (a -> Bool)

vacio :: Conj a
vacio = const False
-- Define el conjunto vacío con una función que dice si un elemento esta o no. vacío elem = False para todo elem

-- agregar :: Eq a => a -> (a -> Bool) -> (a -> Bool)
agregar :: Eq a => a -> Conj a -> Conj a
agregar e c = \x -> x == e || c x

union :: Conj a -> Conj a -> Conj a
union c1 c2 = \x -> c1 x || c2 x

interseccion :: Conj a -> Conj a -> Conj a
interseccion c1 c2 = \x -> c1 x && c2 x

diferencia :: Conj a -> Conj a -> Conj a
diferencia c1 c2 = \x -> c1 x && not (c2 x)

