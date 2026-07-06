# EJ 1
```haskell
data Form = Prop String | And Form Form | Or Form Form | Neg Form

foldForm :: (String -> b) -> (b -> b -> b) -> (b -> b -> b) -> (b -> b) -> Form -> b
foldForm fProp fAnd fOr fNeg form = case form of 
	Prop s -> fProp s
	And f1 f2 -> fAnd (rec f1) (rec f2)
	Or f1 f2 -> fOr (rec f1) (rec f2)
	Neg f -> fNeg (rec f)
		where rec = foldForm fProp fAnd fOr fNeg

```
fnn pasa a la fórmula 'f' a forma normal negada si recibe True y si recibe False pasa la negación de 'f' a fnn .

```haskell
fnn :: Form -> Bool -> Form
fnn = foldForm (\s -> \b -> if b then Prop s else Neg (Prop s)) 
	(\rec1 rec2 -> \b -> if b then And (rec1 b) (rec2 b) else Or (rec1 b) (rec2 b) )
	(\rec1 rec2 -> \b -> if b then Or (rec1 b) (rec2 b) else And (rec1 b) (rec2 b) )
	(\rec1 -> \b -> rec1 (not b) )
```