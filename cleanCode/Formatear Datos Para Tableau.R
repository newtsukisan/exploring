# Objetivos ---------------------------------------------------------------
# 16-12-2014
# Este sencillo script es para intentar guardar la imagen de mi zona de Salamanca de los particulares 
# en un formato para latitude y longitude que pueda ser entendido por tableau. 
# Para ello abrimos los datos guardados en formato R y convertimos los datos numericos 
# en la forma adecuada


# 0. Constanst and name used ----------------------------------------------
file.xlsx <- "database/Salamanca15-12-2014.xls"


# 1. Loading functions -------------------------------------------------------
# Cargamos las librerias y posible funciones. Al cargar este fichero también cargamos todas la librerias
# que necesitabamos para el parser de los datos y para guardar los datos en formato excel.
source("funciones/funciones.R")


# 2.Loading data from file --------------------------------------------------
# Cargamos una versión de la respuesta que obtuvimos de idealista
load("resultados/Salamanca/Mon-Dec-15-18-15-34-2014/respuestaID.RData")


# 3. Convertimos los datos  --------------------------------------------------
respuestaIdel$latitude  <- as.numeric(respuestaIdel$latitude)
respuestaIdel$longitude <- as.numeric(respuestaIdel$longitude)


# 4. Saving in excel format -----------------------------------------------
write.xlsx(x = respuestaIdel, file = file.xlsx ,
           sheetName = "Total", row.names = TRUE)