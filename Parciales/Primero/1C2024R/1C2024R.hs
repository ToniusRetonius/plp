-- tipo Prop
data Prop = Var String | No Prop | Y Prop Prop | O Prop Prop | Imp Prop Prop

type Valuacion = String -> Bool -- es un alias para funciones de este tipo

-- fold (recursión estructural)
foldProp :: (String -> a) -> (a -> a) -> (a -> a -> a) -> (a -> a -> a) -> (a -> a -> a) -> Prop -> a
foldProp fVar fNo fY fO fImp prop = case prop of
    Var s -> fVar s
    No p -> fNo (rec p)
    Y p p' -> fY (rec p) (rec p')
    O p p'-> fO (rec p) (rec p')
    Imp p p'-> fImp (rec p) (rec p')
    where rec = foldProp fVar fNo fY fO fImp

-- la recursión primitiva lo único que agrega es la posibilidad de mantener referencia sin procesar de la estructura 
recProp :: (String -> a) -> (Prop -> a -> a) -> (Prop -> Prop -> a -> a -> a) -> (Prop -> Prop -> a -> a -> a) -> (Prop -> Prop -> a -> a -> a) -> Prop -> a
recProp fVar fNo fY fO fImp prop = case prop of
    Var s -> fVar s
    No p -> fNo p (rec p)
    Y p p' -> fY p p' (rec p) (rec p')
    O p p'-> fO p p' (rec p) (rec p')
    Imp p p'-> fImp p p' (rec p) (rec p')
    where rec = recProp fVar fNo fY fO fImp

-- 
variables :: Prop -> [String]
variables prop = eliminarRepetidos (foldProp (\s -> [s]) (\p -> p) (++) (++) (++) prop)
-- ejemplo :
ej1 = (O (Var "P") (No(Y (Var "Q") (Var "P"))))

eliminarRepetidos :: Eq a => [a] -> [a]
eliminarRepetidos [] = []
eliminarRepetidos (x:xs) = if (elem x xs) then eliminarRepetidos xs else x : eliminarRepetidos xs


-- evaluar
evaluar :: Valuacion -> Prop -> Bool 
evaluar val = foldProp val (not) (&&) (||) (\p q -> not p || q)


