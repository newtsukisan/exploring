# Toma todos los datos guardados en formato R y los almacena en un excel para poder trabajar con él. 
# Recorre todos los directorios buscando los ficheros repuestaIdel.RData y los guarda en el mismo 
# directorio con un nombre que identica la fecha de grabación.



# 1. Funciones a cargar ---------------------------------------------------
source("funciones/funciones.R")

# funciones auxiliares para recorrer las listas y utilizar natural recursion
first         <- function(lista){head(lista,1)}
rest          <- function(lista){tail(lista,(length(lista)-1))}
isEmpty       <- function(lista) if (length(lista)== 0) TRUE else FALSE
# para generar los nombres a utilizar para grabar los datos
extract       <- function(lista) head(tail(lista,3),2)
extractPlace  <- function(lista) head(tail(lista,3),1)
extractTime   <- function(lista) head(tail(lista,2),1)[[1]]

# Para unir los nombres de 
joinNames  <- function(lista,acc){
  if (isEmpty(lista)) acc
  else joinNames(rest(lista),paste0(acc,first(lista)))
}

# 2. Directorio para buscar los ficheros ----------------------------------
routeStr              <- "/Users/trabajo/Dropbox/desarrollos/Analisis/resultados"
file.name.busqueda    <- 'respuestaID.RData'

# 3. Cargamos el path de todos los ficheros. ------------------------------


files <- grep(file.name.busqueda ,list.files(path = routeStr, all.files = TRUE, 
              full.names = TRUE, recursive = TRUE),value=TRUE) 


# 4. Proceso de lectura y grabación en excel ------------------------------


for (counter in files) {
  load(counter)
  datos      <- strsplit(counter,"/")[[1]]
  fileName   <- joinNames(extract(datos),"")[[1]]
  dir        <- extractPlace(datos)[[1]]
  time       <- extractTime(datos)
  # Generamos el fichero excel
  excelFile  <- paste0(routeStr,"/",dir,"/",time,"/",fileName,".xls")
  print(excelFile)
  # Convertimos los datos 
  respuestaIdel$latitude  <- as.numeric(respuestaIdel$latitude)
  respuestaIdel$longitude <- as.numeric(respuestaIdel$longitude)

  # Saving in excel format
  write.xlsx(x = respuestaIdel, file = excelFile ,
             sheetName = "Total", row.names = TRUE)

}




