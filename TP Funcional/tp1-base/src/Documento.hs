module Documento
  ( Doc,
    vacio,
    linea,
    texto,
    foldDoc,
    (<+>),
    indentar,
    mostrar,
    imprimir,
  )
where

data Doc
  = Vacio
  | Texto String Doc
  | Linea Int Doc
  deriving (Eq, Show)

vacio :: Doc
vacio = Vacio

linea :: Doc
linea = Linea 0 Vacio

texto :: String -> Doc
texto t | '\n' `elem` t = error "El texto no debe contener saltos de línea"
texto [] = Vacio
texto t = Texto t Vacio

foldDoc :: b -> (String -> b -> b) -> (Int -> b -> b) -> Doc -> b
foldDoc fVacio fTexto fLinea doc = 
  case doc of
  Vacio -> fVacio
  Texto s d -> fTexto s (rec d)
  Linea i d' -> fLinea i (rec d')
  where rec = foldDoc fVacio fTexto fLinea

-- NOTA: Se declara `infixr 6 <+>` para que `d1 <+> d2 <+> d3` sea equivalente a `d1 <+> (d2 <+> d3)`
-- También permite que expresiones como `texto "a" <+> linea <+> texto "c"` sean válidas sin la necesidad de usar paréntesis.
infixr 6 <+> 

final :: Doc -> Bool
final (Texto s d) = if d == Vacio then True else False
final (Linea i d) = False
final Vacio = False

unirTextos :: String -> Doc -> Doc
unirTextos s (Texto s' d) = Texto (s++s') d

(<+>) :: Doc -> Doc -> Doc
(<+>) d1 d2 = foldDoc 
  d2 
  (\text rec -> if final rec then unirTextos text rec else Texto text rec) 
  (\line rec -> Linea line rec) 
  d1
  
indentar :: Int -> Doc -> Doc
indentar i = if i < 0 then error "No se puede indentar negativo" else foldDoc 
  Vacio 
  (\text rec -> Texto text rec) 
  (\line rec -> Linea (line + i) rec)  --- preguntar si hago if line == 0 then Linea i rec else Linea (line + i) rec (resuelve pero después rompe)

mostrar :: Doc -> String
mostrar = foldDoc 
  "" 
  (\text rec -> text ++ rec) 
  (\line rec -> "\n" ++ replicate line ' ' ++ rec)

imprimir :: Doc -> IO ()
imprimir d = putStrLn (mostrar d)
