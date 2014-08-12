# Telefonos 2.
# En lugar de utilizar un API de kimono labs, se trataria de analizar directamente
# las urls que tenemos almacenadas desde el API de idealista.
# //section/div/div/p  el la instruccion de xpath para obtener el telefono de cada inmueble

# 1. construir la url sumandole http:// a cada una de ellas.
# 2. para cada una de ellas obtener los telefonos.
# 3. añadirlos a nuestros data table.

require(RUnit)
require(XML)
require(foreach)
require(httr)
load("resultados/Salamanca.RData")
# Obtenemos los particulares, son aquellos en los que la agencia es false
particulares <- datos[agency==FALSE]

# Una funcion de ayuda que nos devuelva la url a partir de un propertyCode
getURL <- function (data,code){
  data[data$propertyCode==code]$url
}
# assert ("28304254 corresponde a", getURL(particulares,"28304254") == "www.idealista.com/28304254")
# assert("one equals one", 1 == 1)



# Queremos una función que para cada url nos de los numeros de telefono.
# Recibe un id y una url base y un id que sirve como parametro.
# Devuelve todos el telefono correspondiente a cada uno de ellos
# getTelf  <- function(url){
#   url.llamada <- paste0("http://",url)                      # construye la url
#   html <- htmlTreeParse(url.llamada, useInternalNodes = T)  # consulta el api
#   xpathSApply(html, "//section/div/div/p",xmlValue)         # devuelve el telefono
#   
# }
getTelf  <- function(url){
  url.llamada <- paste0("http://",url)                      # construye la url
  response    <- GET(url.llamada)
  if (response$status_code!=200){ # HTTP request failed!!
    # do some stuff...
    print(paste("Failure:",i,"Status:",response$status_code))
    next
  }
  contenido   <- content(response,as="text")
  html        <- htmlParse(contenido, asText = TRUE)
  # do some other stuff
  # print(paste("Success:",i,"Status:",response$status_code))
  xpathSApply(html, "//section/div/div/p",xmlValue)         # devuelve el telefono
}





getTelf(particulares$url[[1]])

# Probamos utilizando un append para evitar conflitos al terminar la ejecución
telf.list <- c()          # Para ir almacenando los telefonos
bad.url   <- c()          # Para ir almacenando los valores de las que no funcionan
goog.url  <- c()          # Para almacenar las url correctas
# Necesitamos dos listas, una para las URL o los identificadores de cada una de las url
# que obtenemos otra para los que no conseguimos obtener
for(i in 1:nrow(particulares)){
  ulr         <- particulares$url[[i]]                         # la url almacenada de la iter i
  url.llamada <- paste0("http://",url)                         # construye la url
  response    <- GET(url.llamada)                              # construimos la respuesta
  if (response$status_code!=200){                              # HTTP request failed!!
    print(paste("Failure:",i,"Status:",response$status_code))  # show status error
    bad.url   <- append(bad.url,)                              # almacenamos las que no funcionan
    next                                                       # Pasamos al siguiente
  }# end if
  contenido   <- content(response,as="text")                   # Si funciona, parseamos
  html        <- htmlParse(contenido, asText = TRUE)           # html
  print(paste("Success:",i,"Status:",response$status_code))    # imprimimos el mensaje
  telf        <- xpathSApply(html,"//section/div/div/p",xmlValue)# devuelve el telefono
  telf.list   <- append(telf.list,telf)                        # almacenamos telefono                  
  good.url    <- append(good.url,url)                          # almacenamos la url adecuada
}





telefonos <- foreach(i=1:5, .combine = c) %do%
{
  url.llamada <- paste0("http://",particulares$url[i])      # construye la url
  html <- htmlTreeParse(url.llamada, useInternalNodes = T)  # consulta el api
  print(i)
  xpathSApply(html, "//section/div/div/p", xmlValue)
}
telefonos               <- sapply(particulares$url,getTelf)
particulares$telefonos  <- telefonos

# assert ("28304254 corresponde a", getTelf("28304254",url.telf) == "629 764 345")
# assert ("27796597 corresponde a", getTelf("27796597",url.telf) == "696 853 941")
# assert ("1728652  corresponde a", getTelf("1728652", url.telf) == "682 452 016")
getTelf(particulares$url[118])

getTelf("www.idealista.com/1111111111454545454545454545")


vari <- 1
tryCatch(print("passes"), error = function(e) print(vari), finally=print("finished")) 
tryCatch(stop("fails"), error = function(e) print(vari), finally=print("finished")) 

url  <- "http://www.idealista.com/28304254"
html <- htmlTreeParse(url, useInternalNodes = T)
xpathSApply(html, "//title",xmlValue)
xpathSApply(html, "//section/div/div/p",xmlValue)
