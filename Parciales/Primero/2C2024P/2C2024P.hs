-- tipo de dato
data Buffer a = Empty | Write Int a (Buffer a) | Read Int (Buffer a)

-- ejemplo
buf = Write 1 'a' $ Write 2 'b' $ Write 1 'c' $ Empty

-- foldBuffer
foldBuffer :: b -> (Int-> a -> b -> b) -> (Int-> b -> b) -> Buffer a -> b
foldBuffer fEmpty fWrite fRead buf = case buf of
    Empty -> fEmpty
    Write n s b -> fWrite n s (rec b)
    Read n b -> fRead n (rec b)
    where rec = foldBuffer fEmpty fWrite fRead

-- recBuffer
recBuffer :: b -> (Int-> a -> Buffer a -> b -> b) -> (Int-> Buffer a -> b -> b) -> Buffer a -> b
recBuffer fEmpty fWrite fRead buf = case buf of
    Empty -> fEmpty
    Write n s b -> fWrite n s b (rec b)
    Read n b -> fRead n b (rec b)
    where rec = recBuffer fEmpty fWrite fRead

-- posicionesOcupadas (sin repetidos)
posicionesOcupadas :: Buffer a -> [Int]
posicionesOcupadas = foldBuffer [] (\n s rec -> if (elem n rec) then rec else rec ++ [n]) (\n rec -> rec)

-- contenido
contenido :: Int -> Buffer a -> Maybe  a
contenido n = recBuffer Nothing (\m s l rec -> if n == m then Just s else Nothing) (\m l rec -> Nothing)

-- puedeCompletarLecturas
puedeCompletarLecturas :: (Eq a) => Buffer a -> Bool
puedeCompletarLecturas = recBuffer False (\m s l rec -> rec ) (\m l rec -> if (contenido m l) /= Nothing then True else False )

-- deshacer 
deshacer :: Buffer a -> Int -> Buffer a
deshacer = recBuffer (const Empty) (\m s l rec -> \n-> if n == 0 then Write m s l else rec (n-1)) (\m l rec -> \n -> if n == 0 then Read m l else rec (n-1))

deshacerCheck = contenido 1 (deshacer buf 2)