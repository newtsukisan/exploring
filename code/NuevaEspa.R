# Objetivo, obtener todos los inmuebles de la zona de hispanoamerica
source('funciones/funciones.R')
require(xlsx)
# Cargamos los datos de los inmuebles de la zona de Nueva España
# Consideramos centro en 40.462926, -3.670845 y un radio de 555 metros

NuevaEsp     <- getDataFromIdealista(40.462926, -3.670845,555)
partNuevEsp  <- NuevaEsp[agency==FALSE,]              # Obtenemos los particulares
# Guardamos todos los datos.
save (NuevaEsp, file='resultados/nuevaEsp.RData')
save (partNuevEsp, file='resultados/nuevaEspPart.RData')
# Ahora podemos sacar todas las paginas asocidas a los particulares.
contenidosParticulares  <- getResponsesFromUrl(partNuevEsp$url)
# Guardamos para no tener que cargarlos de nuevo
save(contenidosParticulares, file="data/nuevaEspaContenidos.Rdata")
# Ahora obtenemos todos los telefonos de los particulares.

setTelf <- function(l) getParameterFromResponse(l,"//section/div/div/p")
telefonos <- sapply(contenidosParticulares$contenidos, setTelf)
# Ahora hacemos un merge de los datos 
temporal <- data.table(url=contenidosParticulares$url,telefono=telefonos)
particulares.NuevaEsp <- merge(temporal,partNuevEsp, by="url")
# Guardamos los datos
save(particulares.NuevaEsp, file='resultados/particularesNuevaEsp.RData')
# ahora podemos simplicar los datos
tidy.particulares <- getDataFromNames(c('neighborhood','address','rooms','floor','size','price',
                                        'telefono','url','propertyType'),particulares.NuevaEsp)


#  Ahora lo guardamos como un excel
write.xlsx(x = tidy.particulares, file = "resultados/particularesNuevaEsp.xlsx",
           sheetName = "particulares", row.names = FALSE)