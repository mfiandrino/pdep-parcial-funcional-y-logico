import Text.Show.Functions()

--Punto 1
data Torta = UnaTorta {nombre :: String , cantidadHarina :: Int , cantidadHuevos :: Int , ingredientes :: [Ingrediente]} deriving Show
torta1 = UnaTorta "Selva Negra" 300 2 [chocolate 20,frutal "Mango" 15]

--Punto 2
type Calorias = Int
type Ingrediente = Torta -> Calorias

type CantidadGramos = Int
chocolate :: CantidadGramos -> Ingrediente
chocolate gramos unaTorta = (*gramos).cantidadHuevos $ unaTorta

type Fruta = String
frutal :: Fruta -> CantidadGramos -> Ingrediente --la funcion no usa nada de la torta, revisar
frutal unaFruta gramos unaTorta = (flip div 2).(*gramos).length $ unaFruta

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


