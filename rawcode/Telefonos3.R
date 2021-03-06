# 0. Objetivo -------------------------------------------------------------


# Telefonos 2.
# En lugar de utilizar un API de kimono labs, se trataria de analizar directamente
# las urls que tenemos almacenadas desde el API de idealista.
# //section/div/div/p  el la instruccion de xpath para obtener el telefono de cada inmueble

# 1. construir la url sumandole http:// a cada una de ellas.
# 2. para cada una de ellas obtener los telefonos.
# 3. añadirlos a nuestros data table.


# 1. Load libraries -------------------------------------------------------


require(RUnit)
require(XML)
require(foreach)
require(httr)
require(data.table)


# 2. Funciones a utilizar -------------------------------------------------

# Una funcion de ayuda que nos devuelva la url a partir de un propertyCode
getURL <- function (data,code){
  data[data$propertyCode==code]$url
}

# Una funcion que  recibe las url y devuelve tres listas. 
# lista de url  -> good.url, telefonos, bad.url
# lista con las url de las que se han obtenido los telefonos
# lista con los telefonos correspondientes
# lista con las url que han fallado.
getTelfFromURL  <- function(urlList){
  # Probamos utilizando un append para evitar conflitos al terminar la ejecución
  telf.list <- c()          # Para ir almacenando los telefonos
  bad.url   <- c()          # Para ir almacenando los valores de las que no funcionan
  good.url  <- c()          # Para almacenar las url correctas
  # Debemos tener cuidado cuando hay mas de un telefono.
  # Necesitamos dos listas, una para las URL o los identificadores de cada una de las url
  # que obtenemos otra para los que no conseguimos obtener
  n <- length(urlList)
  for(i in 1:n){
    ulr.iter    <- urlList[[i]]                                  # la url almacenada de la iter i
    url.llamada <- paste0("http://",ulr.iter)                    # construye la url
    response    <- GET(url.llamada)                              # construimos la respuesta
    if (response$status_code!=200){                              # HTTP request failed!!
      print(paste("Failure:",i,"Status:",response$status_code))  # show status error
      bad.url   <- append(bad.url,ulr.iter)                      # almacenamos las que no funcionan
      next                                                       # Pasamos al siguiente
    }# end if
    contenido   <- content(response,as="text")                   # Si funciona, parseamos
    html        <- htmlParse(contenido, asText = TRUE)           # html
    telf        <- xpathSApply(html,"//section/div/div/p",xmlValue)# devuelve el telefono
    telf.list   <- append(telf.list,telf[[1]])                   # almacenamos el 1º telefono                  
    good.url    <- append(good.url,ulr.iter)                     # almacenamos la url adecuada
    print(paste("Success:",i,"Telefono",telf,length(telf)))      # imprimimos el mensaje
  }
  # Ahora devolvemos los valores adecuados
  telf.list[sapply(telf.list, is.null)] <- NA                    # para que no tengamos NULL
  list(good.url=good.url, telf = telf.list, bad.url = bad.url)
}



# Ahora hacemos una data.table con los datos de url y telefonos buenos
# Pero para ello debemos tratar los valores que son NULL en la parte de los telefonos
telf.list[sapply(telf.list, is.null)] <- NA




# 3. Load data ------------------------------------------------------------

load("resultados/Salamanca.RData")
# Obtenemos los particulares, son aquellos en los que la agencia es false
particulares <- datos[datos$agency==FALSE,]


# 4. Proceso de obtenccion de los telefonos -------------------------------

# Probamos utilizando un append para evitar conflitos al terminar la ejecución
telf.list <- c()          # Para ir almacenando los telefonos
bad.url   <- c()          # Para ir almacenando los valores de las que no funcionan
good.url  <- c()          # Para almacenar las url correctas
# Debemos tener cuidado cuando hay mas de un telefono.
# Necesitamos dos listas, una para las URL o los identificadores de cada una de las url
# que obtenemos otra para los que no conseguimos obtener
for(i in 1:nrow(particulares)){
  ulr.iter    <- particulares$url[[i]]                         # la url almacenada de la iter i
  url.llamada <- paste0("http://",ulr.iter)                    # construye la url
  response    <- GET(url.llamada)                              # construimos la respuesta
  if (response$status_code!=200){                              # HTTP request failed!!
    print(paste("Failure:",i,"Status:",response$status_code))  # show status error
    bad.url   <- append(bad.url,ulr.iter)                      # almacenamos las que no funcionan
    next                                                       # Pasamos al siguiente
  }# end if
  contenido   <- content(response,as="text")                   # Si funciona, parseamos
  html        <- htmlParse(contenido, asText = TRUE)           # html
  telf        <- xpathSApply(html,"//section/div/div/p",xmlValue)# devuelve el telefono
  telf.list   <- append(telf.list,telf[[1]])                   # almacenamos el 1º telefono                  
  good.url    <- append(good.url,ulr.iter)                     # almacenamos la url adecuada
  print(paste("Success:",i,"Telefono",telf,length(telf)))      # imprimimos el mensaje
}


# Ahora hacemos una data.table con los datos de url y telefonos buenos
# Pero para ello debemos tratar los valores que son NULL en la parte de los telefonos
telf.list[sapply(telf.list, is.null)] <- NA
data.telefonos <- data.table(url=good.url,telefono=unlist(telf.list)) 


# Ahora lo unimos con los particulares que ya teniamos
final <- merge(particulares, data.telefonos, by ="url")
file  <- paste0("resultados/Salamaca",date(),".RData")
save(final,file = file)


