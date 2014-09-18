# Es necesario realizar una actualizacion de los datos de forma periodica
# Base datos [lo que utilizamos, centro donde se encuentran almacenadas]
# la base de datos genera un excel donde estan los que estan. 
# Consultamos.
# Sacamos los particulares.
# Vemos los particulares que no están en nuestra base de datos.
# Estos particulares son los que pondriamos en nuevo excel para importar desde la base de datos.


# http://95.16.1.137  -> 33c703f985e886fcb93fbda51b9fc37e

# Loading functions -------------------------------------------------------
source("funciones/funciones.R")


# Configuracion -----------------------------------------------------------

dir.base  <- "resultados" # para guardar los ficheros
zona      <- "Nuevos"     # para guardar los ficheros
xpath   = "//section/div/div/p"# Busqueda telefonos
names.tidy   = c('neighborhood','address','rooms','floor','size','price','telefono','url',
                 'propertyType') # in tidy data
dir.name  <- paste0(dir.base,"/",zona,"/",date(),"/")   # directorio donde guardar las descargas
dir.name  <- setDirFormats(dir.name)                    # Cambiamos algunos caracteres para guardar
dir.create(dir.name,recursive = TRUE)                   # creamos un directorio con las fechas.
getfileName  <- function(name) paste0(dir.name,name)    # para crear cada uno de los nombres
# Nombres para los ficheros intermedios.
file.respuestaIdealista <- getfileName("respuestaID.RData")
file.contenidos         <- getfileName("contenidos.RData")
file.tidy               <- getfileName("tidy.RData")
file.xlsx               <- getfileName(paste0(zona,".xlsx"))
file.tidy               <- getfileName("tidy.RData")
file.xlsx               <- getfileName(paste0(zona,".xlsx"))


# prueba simple de codigo
s <- "http://www.idealista.com/1632913"
extractCode(s)

# lo que tenemos. Tenemos que tener un excel con una columna con todas las url para poder 
# extraer los datos codigos de la propiedad
res <- read.xlsx("data/Particulares.xlsx", sheetName="Hoja 1")
res <- data.table(res)
class(res)
res <- res[c(2:nrow(res)),]
res$code <- extractCode(res$Tabla.1)

# Encontramos los datos ahora 
# Zona de Salamanca 40.426195, -3.674118, 480
# Operations --------------------------------------------------------------
# Para las diferentes zonas, cargamos los datos desde idealista.
Salamanca <- getDataFromIdealista(40.426195, -3.674118, 480, 
                                  key ="33c703f985e886fcb93fbda51b9fc37e",
                                  operation='sale', pag=TRUE, deb=TRUE)

Ariel     <- getDataFromIdealista(40.393537, -3.679118 ,189, 
                                  key ="33c703f985e886fcb93fbda51b9fc37e",
                                  operation='sale', pag=TRUE, deb=TRUE)

Hispano   <- getDataFromIdealista(40.455110, -3.674150 ,370, 
                                  key ="33c703f985e886fcb93fbda51b9fc37e",
                                  operation='sale', pag=TRUE, deb=TRUE)

  
# Creamos el total
total  <- rbind(rbind(Salamanca,Ariel),Hispano)
# Buscamos los particulares, para cada una de las zonas.
particulares       <- subset(total, agency == FALSE)
particulares$code  <- extractCode(particulares$url)
# Seleccionamos aquellos que no estan en res$code
index  <- which(sapply (particulares$code, function (x)  x %in% res$code) == FALSE)
nuevos <- particulares[index,]
particulares <- nuevos


# Ahora podemos sacar todas las paginas asocidas a los particulares.
contenidosParticulares  <- getResponsesFromUrl(particulares$url)
# Ahora tenemos que obtener los números de telefonos de los nuevos.
# Si hemos obtenido respuesta de la pagina web de algunos particulares.
if(!is.null(contenidosParticulares)){ # Si los particulares tienen pagina y contenidos.
  # Guardamos para no tener que cargarlos de nuevo
  # save(contenidosParticulares, file=file.contenidos)
  # Ahora obtenemos todos los telefonos de los particulares.
  setTelf <- function(l) getParameterFromResponse(l,xpath)
  telefonos <- sapply(contenidosParticulares$contenidos, setTelf)
  # Ahora hacemos un merge de los datos 
  temporal <- data.table(url=contenidosParticulares$url,telefono=telefonos)
  particulares.telefono <- merge(temporal,particulares, by="url")
  # Guardamos los datos
  # ahora podemos simplicar los datos
  tidy.particulares <- getDataFromNames(names.tidy,particulares.telefono)
  save(tidy.particulares, file =  file.tidy)
  #  Ahora lo guardamos como un excel
  write.xlsx(x = tidy.particulares, file = file.xlsx ,
             sheetName = "particulares", row.names = FALSE)
} else {
  print("NO se han encontrado contenidos para ninguno de los particulares detectados.")
}


# 
