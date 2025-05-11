-- dato y ejemplo
data AT a = NilT | Tri a (AT a) (AT a) (AT a)
at1 = Tri 1 (Tri 2 NilT NilT NilT) (Tri 3 (Tri 4 NilT NilT NilT) NilT NilT) (Tri 5 NilT NilT NilT)

-- funciones
foldAT :: b -> ( a -> b -> b -> b -> b) -> AT a -> b
foldAT fNilT fTri t = case t of 
        NilT -> fNilT
        Tri r izq med der -> fTri r (rec izq) (rec med) (rec der)
          where rec = foldAT fNilT fTri  

preorder :: AT a -> [a]
preorder t = foldAT [] (\r izq med der -> [r] ++ izq ++ med ++ der ) t

mapAT :: (a -> b) -> AT a -> AT b
mapAT f t = foldAT NilT (\r izq med der -> Tri (f r) izq med der ) t

nivel :: AT a -> Int -> [a]
nivel t n = foldAT (const []) (\r izq med der i -> if i == 0 then [r] else ((izq (i-1)) ++ (med (i-1)) ++ (der (i-1)))) t n