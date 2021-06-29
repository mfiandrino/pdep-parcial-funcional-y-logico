import Text.Show.Functions()

--Punto 1
data Torta = UnaTorta {nombre :: String , cantidadHarina :: Int , cantidadHuevos :: Int , ingredientes :: [Ingrediente]} deriving (Show)
torta1 = UnaTorta "Selva Negra" 300 3 [chocolate 20,frutal "Mango" 15]
torta2 = UnaTorta "CheeseCake" 50 1 [puñadoDeFrutas , bañoDeCrema]

--Punto 2
type Calorias = Int
type Ingrediente = Torta -> Calorias

type CantidadGramos = Int
chocolate :: CantidadGramos -> Ingrediente
chocolate gramos unaTorta = (*gramos).cantidadHuevos $ unaTorta

type Fruta = String
{-Teoricamente es un ingrediente pero la funcion no usa datos de la torta, por lo tanto pongo que es del tipo 
ingrediente y que reciba la torta para luego agregarlo a las listas de ingredientes de las tortas-}
frutal :: Fruta -> CantidadGramos -> Ingrediente 
frutal unaFruta gramos unaTorta = (flip div 2).(*gramos).length $ unaFruta

{-Teoricamente es un ingrediente pero la funcion no usa datos de la torta, por lo tanto pongo que es del tipo 
ingrediente y que reciba la torta para luego agregarlo a las listas de ingredientes de las tortas-}
puñadoDeFrutas :: Ingrediente 
puñadoDeFrutas unaTorta = 100

bañoDeCrema :: Ingrediente
bañoDeCrema unaTorta = (+50).cantidadHarina $ unaTorta

--Punto 3
--a)
totalCalorias :: Torta -> Int
totalCalorias unaTorta = foldl (sumarCalorias unaTorta) 0 (ingredientes unaTorta)  

sumarCalorias :: Torta -> Int -> Ingrediente -> Int
sumarCalorias  unaTorta sumatoria ingrediente = (+sumatoria).ingrediente $ unaTorta

--b)
tortaPunto3 = UnaTorta "Torta3" 200 0 ([frutal "banana" 30 , chocolate 80 , bañoDeCrema ] ++ replicate 3 (frutal "frutilla" 20) ++ [\torta -> (*(cantidadHarina $ torta)).cantidadHuevos $ torta])
-- *Main> totalCalorias tortaPunto3 
-- 1420

--Punto 4

type Criterio = Torta -> Bool
esUnaBomba :: Criterio
esUnaBomba unaTorta = ((>180).totalCalorias $ unaTorta) && ((>3).length.ingredientes $ unaTorta)

esAptaVegano :: Criterio
esAptaVegano unaTorta = (==0).cantidadHuevos $ unaTorta

esSana :: Calorias -> Criterio
esSana calorias unaTorta = ((<calorias).totalCalorias $ unaTorta) || ((<200).cantidadHarina $ unaTorta) 

esNutritiva :: Criterio
esNutritiva unaTorta = (>3).cantidadHuevos $ unaTorta 

--Punto 5
listaDeCriterios = [esNutritiva , esSana 100 , esUnaBomba]

tortasMasElegidas :: [Torta] -> [Criterio] -> Condicion -> [Torta]
tortasMasElegidas tortas criterios condicion = filter (cumpleCondicion criterios condicion) tortas

cumpleCondicion :: [Criterio] -> Condicion -> Torta -> Bool
cumpleCondicion criterios condicion torta = condicion torta criterios

--1)
type Condicion = Torta -> [Criterio] -> Bool
condicion1 :: Condicion
condicion1 unaTorta criterios = ((>2).length.ingredientes $ unaTorta) && (any ($ unaTorta) criterios)
-- *Main> tortasMasElegidas [torta1,torta2,tortaPunto3] listaDeCriterios condicion1
-- [UnaTorta {nombre = "Torta3", cantidadHarina = 200, cantidadHuevos = 0, ingredientes = [<function>,<function>,<function>,<function>,<function>,<function>,<function>]}]

--2)
condicion2 :: Condicion
condicion2 unaTorta criterios = ((==3).cantidadHuevos $ unaTorta) && (all ($ unaTorta) criterios)
-- *Main> tortasMasElegidas [torta1,torta2,tortaPunto3] listaDeCriterios condicion2
-- []

--3)
condicion3 :: Condicion
condicion3 unaTorta criterios = ((<100).cantidadHarina $ unaTorta) && (any ($ unaTorta) criterios)
-- *Main> tortasMasElegidas [torta1,torta2,tortaPunto3] listaDeCriterios condicion3
-- [UnaTorta {nombre = "CheeseCake", cantidadHarina = 50, cantidadHuevos = 1, ingredientes = [<function>,<function>]}]


--Punto 6
--a)
tortaInfinita = UnaTorta "LaTortaInfinita" 1000 3 (cycle [puñadoDeFrutas , bañoDeCrema , frutal "Manzana" 100])
tortaInfinita2 = UnaTorta "LaTortaInfinita2" 1000 80 (cycle [puñadoDeFrutas])

--b)


--c)
{-
No se puede verificar si un ingrediente esta incluido en la torta infinita ya que en Haskell las funciones no pueden ser del tipo Eq
para ser comparadas con la funcion elem, y justamente los ingredientes son funciones. Al colocar deriving (Show,Eq) al tipo de dato Torta,
me indica que no se puede aplicar ya que el tipo Ingrediente (funcion) no es del tipo Eq.
En caso de que fuera un tipo de dato generico, como por ejemplo un String, Int, etc. y el ingrediente no estuviera en la torta infinita,
el programa se quedaria buscando infinitamente dicho ingrediente, ya que la funcion elem recorrera todos los elementos de la lista infinita
de ingredientes no encontrando ninguno que coincida.
En el caso que el ingrediente estuviera en la torta infinita, el programa devolvera True. Esto se debe al lazy evaluation, que hace que 
solo se genere lo que se va a usar, por lo tanto, el programa no crea primero la lista infinita (que nunca terminaria) y luego se fija 
si hay un coincide algun elemento, sino que sabiendo que fue aplicada la funcion elem, va a generar la lista hasta encontrar dicho elemento,
sin generar toda la lista infinita.    
-}



