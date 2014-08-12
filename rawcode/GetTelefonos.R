
# 0. Definition de los objetivos. -----------------------------------------

# Dado un data.table con los resultados obtenidos de idealista, se trataría de utilzar un api
# para obtener los telefonos de cada uno de los particulares.
require(jsonlite)

load("resultados/Salamanca.RData")

# Obtenemos los particulares, son aquellos en los que la agencia es false
particulares <- datos[agency==FALSE]

# Obtenemos los telefonos desde el API de kimonolabs
url.telf  <- "https://www.kimonolabs.com/api/d5k0p7zu?apikey=03lnybQ4tbJSOM7UuqzEzHR1ZxASryjf"

# Queremos una función que para cada identificador nos de un numero de telefono.
# Recibe un id y una url base y un id que sirve como parametro.
# Devuelve todos el telefono correspondiente a cada uno de ellos
getTelf  <- function(id, url){
  url.llamada <- paste0(url,"&kimpath2=",id)    # construye la url
  results     <- fromJSON(url.llamada)          # consulta el api
  results$results$collection1[[1]]              # devuelve el telefono
}

# testing
getTelf("28304254",url.telf)
assert ("28304254 corresponde a", getTelf("28304254",url.telf) == "629 764 345")
assert ("27796597 corresponde a", getTelf("27796597",url.telf) == "696 853 941")
assert ("1728652  corresponde a", getTelf("1728652", url.telf) == "682 452 016")

telefonos               <- sapply(particulares$propertyCode,function(id) getTelf(id,url.telf))
particulares$telefonos  <- telefonos 
