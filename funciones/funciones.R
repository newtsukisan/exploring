
# 0.0 Objetivo y definición ------------------------------------------------

# Funciones para obtener y depurar los datos desde idealista.


# 0.1 libraries -----------------------------------------------------------


require(data.table)
require(jsonlite)
require(testit)
require(httr)
# 1. Funciones ------------------------------------------------------------

# Funcion para conectarse al api de idealista
# recibe key, centro y distancia
# devuelve un data.table con los datos obtenidos.
# trying to get data form idealista
# 08-08-2014 tratamos de obtener de nuevo los datos obteniendo la clave a traves de 
# http://www.vermiip.es/
# http://85.52.103.122     bf702313881a8fcc3c488d3e5e31bdfb

# Funcion para obtener la url base para la consulta.
# "http://www.idealista.com/labs/propertyMap.htm?center=40.426195,-3.674118&distance=500&k=bf702313881a8fcc3c488d3e5e31bdfb&operation=sale&action=json"
# download.file (url, destfile="data/trialIdealista.json", method = "curl")
# latitud  -> latitud  del centro del circulo de busqueda, ejemplo 40.426195
# longitud -> longitud del centro del circulo de busqueda, ejemplo -3.674118"
# key      -> Por defecto la generada para la la http://85.52.103.122     bf702313881a8fcc3c488d3e5e31bdfb
# distancia-> Distancia del radio de busqueda en metros. ejemplo 500
getURLBase  <- function(latitud,longitud, distancia, key ="bf702313881a8fcc3c488d3e5e31bdfb"){
  url1      <-   "http://www.idealista.com/labs/propertyMap.htm?"
  center    <-   paste0("center=",latitud,",",longitud)
  distancia <-   paste0("&distance=",distancia)
  key       <-   paste0("&k=",key)
  operation <-   "&operation=sale&action=json"
  #numpage   <-  "&numPage=139"
  paste0(url1,center,distancia,key,operation)
}# end function

url.test    <- "http://www.idealista.com/labs/propertyMap.htm?center=40.426195,-3.674118&distance=500&k=bf702313881a8fcc3c488d3e5e31bdfb&operation=sale&action=json"
url.test.1  <- getURLBase(40.426195,-3.674118,500)
assert("Creacion del url de base", url.test == url.test.1)

# Funcion para conectarse al api de idealista
# recibe key, centro y distancia
# devuelve un data.table con los datos obtenidos.
# trying to get data form idealista
# Ejemplo de uso.
# inmuebles <- getDataFromIdealista(40.426195,-3.674118,400, debug= TRUE)
getDataFromIdealista <- function(lat ,long, dist,
                                 key ="bf702313881a8fcc3c488d3e5e31bdfb",debug = FALSE){
  url.base  <- getURLBase(lat ,long, dist,key)
  # Para analizarlo podemos utilizar la libreria de json
  jsondata <- fromJSON(url.base)
  # Lo primero que necesitamos es el numero de paginas.
  if(debug) print("Comenzando peticion de datos ...")
  numpaginas   <- jsondata[[2]]$totalPages              # paginas totales
  pagactual    <- jsondata[[2]]$actualPage              # pagina cargada, suponemos la primera
  datos <- data.table(jsondata[[2]]$elementList)        # primera carga de datos
  
  # Bucle para realizar la paginación con los diferentes datos.
  # Tardará un rato
  while (pagactual < numpaginas){
    pag            <- paste0("&numPage=",pagactual+1)           # obtenemos la pagina siguiente.
    if(debug) print(paste0("Obteniendo datos de la pagina ",pag," de ",numpaginas))
    url.paginada   <- paste0(url.base,pag)                      # creamos la peticion.
    jsondata <- fromJSON(url.paginada)                          # obtenemos de nuevo los datos.
    datos <- rbind(datos,data.table(jsondata[[2]]$elementList)) # unimos los datos nuevos
    pagactual    <- jsondata[[2]]$actualPage                    # obtenemos la pagina actual
    
  }
  if(debug) print("Terminando peticion de datos.....")
  datos           # devolvemos los datos descargados despues de la paginacion
}


# Para la funcion de obtener parametros de cada una de las paginas, 
# necesitamos simular la distribución de tiempos en las llamadas con un elemento de pausa
# y una generacion de tiempos aleatoria.

# Creamos una funcion que dado un contenido obtenido de un GET nos de un parametro
# asociado a una determinada cadena de busqueda utilizando Xpath
# 
# response -> es obtenido GET(url). Utiliza la biblioteca httr
# xpath    -> para buscar el parametro "//section/div/div/p"
getParameterFromResponse <- function (response, xpath){
  contenido   <- content(response,as="text")                     # Si funciona, parseamos
  html        <- htmlParse(contenido, asText = TRUE)             # html
  param       <- xpathSApply(html,xpath,xmlValue)                # devuelve el parametro
  Reduce(function (x,y) paste(x,y), param, "")                   # Para tener solo un elemento
}

# Nos devuelve una lista de parametros si hay mas de uno que cumple estas caracteristicas
# para la consulta de xpath
# El paquete de scrape permite hacer un scrape de forma parece que mas eficiente.

# Para obtener cada uno de los datos de idealista, podríamos recoger las paginas on line
# guardarlas y hacer el analisis off line
# idealista ---> (API)  ---> Datos zona
# idealista ---> (WEB)  ---> responses (GET(url)) ---> files .RData
# .RData    ---> vector ---> parametros que queramos
# La peticion a la web se hara simulando la navegacion de un personas esperando entre peticiones
# un tiempo aleatorio
testit <- function(x)
{
  p1 <- proc.time()
  Sys.sleep(x)
  proc.time() - p1 # The cpu usage should be negligible
}
testit(2)
mean(rnorm(100,4,2))
