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

primerComandotext :: Doc -> Bool
primerComandotext (Texto s d) = True
primerComandotext _ = False

consigoString :: Doc -> String
consigoString (Texto s d) = s

consigoproxDoc :: Doc -> Doc
consigoproxDoc (Texto s d) = d


foldDoc :: b -> (String -> b -> b) -> (Int -> b -> b) -> Doc -> b
foldDoc fVacio fTexto fLinea documento = case documento of
  Vacio -> fVacio
  Texto s d -> fTexto s (rec d)
  Linea i d -> fLinea i (rec d)
  where rec = foldDoc fVacio fTexto fLinea

-- NOTA: Se declara `infixr 6 <+>` para que `d1 <+> d2 <+> d3` sea equivalente a `d1 <+> (d2 <+> d3)`
-- También permite que expresiones como `texto "a" <+> linea <+> texto "c"` sean válidas sin la necesidad de usar paréntesis.
infixr 6 <+>

(<+>) :: Doc -> Doc -> Doc
d1 <+> d2 = foldDoc 
            d2 
            (\s rec -> if primerComandotext rec then Texto (s++(consigoString rec)) (consigoproxDoc rec) else Texto s rec) 
            (\i rec -> Linea i rec)
            d1

indentar :: Int -> Doc -> Doc
indentar i = foldDoc
              vacio
              (\txt rec -> Texto txt rec)
              (\espacios rec -> Linea (espacios + i) rec) 

mostrar :: Doc -> String
mostrar = foldDoc 
          ""
          (\txt rec -> (txt++rec))
          (\linea rec -> "\n" ++ replicate linea ' ' ++ rec)


-- | Función dada que imprime un documento en pantalla

-- ghci> imprimir (Texto "abc" (Linea 2 (Texto "def" Vacio)))
-- abc
--   def

imprimir :: Doc -> IO ()
imprimir d = putStrLn (mostrar d)

