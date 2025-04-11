module PPON where

import Documento

data PPON
  = TextoPP String
  | IntPP Int
  | ObjetoPP [(String, PPON)]
  deriving (Eq, Show)

pponAtomico :: PPON -> Bool
pponAtomico (ObjetoPP xs) = False
pponAtomico  _ = True
             

pponObjetoSimple :: PPON -> Bool
pponObjetoSimple p = case p of   
  TextoPP s -> False 
  IntPP  i -> False 
  ObjetoPP lista -> foldr (\(x,y) rec -> pponAtomico y && rec) True lista 


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
aplanar = foldDoc vacio (\txt rec -> texto txt <+> rec) (\i rec -> texto " " <+> rec)

pponADoc :: PPON -> Doc
pponADoc (TextoPP s) = texto (show s)
pponADoc (IntPP i) = texto (show i)
pponADoc (ObjetoPP pares) =
  if pponObjetoSimple (ObjetoPP pares)
    then aplanar (entreLlaves (map (\(x,y) -> texto (show x) <+> texto ": " <+> pponADoc y) pares))
    else entreLlaves (map (\(x,y) -> texto (show x) <+> texto ": " <+> pponADoc y) pares)
    



