module PPON where

import Documento

data PPON
  = TextoPP String
  | IntPP Int
  | ObjetoPP [(String, PPON)]
  deriving (Eq, Show)


foldPPON :: (String -> b) -> (Int -> b) -> ([(String, b)] -> b) -> PPON -> b
foldPPON fTexto fInt fObjeto ppon = 
  case ppon of
    TextoPP str -> fTexto str
    IntPP i -> fInt i
    ObjetoPP pares -> 
      let pares' = [(clave , rec valor) | (clave,valor) <- pares]
      in fObjeto pares'
      where rec = foldPPON fTexto fInt fObjeto

    -- versión Sol :
    -- ObjetoPP pares -> fObjeto (map (\(x, y) -> (x, rec y)) pares)
    -- where rec = foldPPON fTexto fInt fObjeto

pponAtomico :: PPON -> Bool
pponAtomico = foldPPON (const True) (const True) (const False)

pponObjetoSimple :: PPON -> Bool
pponObjetoSimple ppon = 
  case ppon of
    TextoPP t -> False
    IntPP i -> False
    ObjetoPP objeto -> foldr (\(x, y) rec -> pponAtomico y && rec) True objeto

intercalar :: Doc -> [Doc] -> Doc
intercalar d [] = vacio
intercalar d lista = foldr1 (\x rec -> x <+> d <+> rec) lista

entreLlaves :: [Doc] -> Doc
entreLlaves [] = texto "{ }"
entreLlaves ds =
  texto "{"
    <+> indentar
      2
      ( linea
          <+> intercalar (texto "," <+> linea) ds
      )
    <+> linea
    <+> texto "}"

aplanar :: Doc -> Doc
aplanar = foldDoc 
  vacio
  (\text rec -> texto text <+> rec)
  (\line rec -> texto " " <+> rec)

pponADoc :: PPON -> Doc
pponADoc = foldPPON 
  (\t -> texto (show t)) 
  (\i -> texto (show i)) 
  (\pares -> entreLlaves (map (aplanar) (map (\(x, y) -> texto (show x) <+> texto ": " <+> y) pares)))

pericles, merlina, addams, familias :: PPON
pericles = ObjetoPP [("nombre", TextoPP "Pericles"), ("edad", IntPP 30)]
merlina = ObjetoPP [("nombre", TextoPP "Merlina"), ("edad", IntPP 24)]
addams = ObjetoPP [("0", pericles), ("1", merlina)]
familias = ObjetoPP [("Addams", addams)]