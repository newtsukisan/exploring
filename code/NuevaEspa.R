# Objetivo, obtener todos los inmuebles de la zona de hispanoamerica
source('funciones/funciones.R')

# Cargamos los datos de los inmuebles de la zona de Nueva España
# Consideramos centro en 40.462926, -3.670845 y un radio de 555 metros

NuevaEsp     <- getDataFromIdealista(40.462926, -3.670845,555, paginar= TRUE, debug= TRUE)
partNuevEsp  <- NuevaEsp[agency==FALSE,]              # Obtenemos los particulares
# Guardamos todos los datos.
save (NuevaEsp, file='resultados/nuevaEsp.RData')
save (partNuevEsp, file='resultados/nuevaEspPart.RData')
# Ahora podemos sacar todas las paginas asocidas a los particulares.
contenidosParticulares  <- getResponsesFromUrl(partNuevEsp$url)
# Guardamos para no tener que cargarlos de nuevo
save(conte)