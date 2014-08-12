
# Introduccion ------------------------------------------------------------
# TODO convertir esto en una función, para poder simplificar su uso.
# Entrada, centro, distancia, clave.

# trying to get data form idealista
# 08-08-2014 tratamos de obtener de nuevo los datos obteniendo la clave a traves de 
# http://www.vermiip.es/
# http://85.52.103.122     bf702313881a8fcc3c488d3e5e31bdfb

# Datos de prueba con los que funciona
#url <- "http://www.idealista.com/labs/propertyMap.htm?center=40.415914,-3.696148
#&radio=40.41766848762555,-3.69614839553833&operation=sale&k=bf702313881a8fcc3c488d3e5e31bdfb&action=json"
#download.file (url, destfile="data/trialIdealista.json", method = "curl")

# 0. Cargamos las librerias necesarias ------------------------------------

require(data.table)
require(jsonlite)

# Determinamos zona de búsqueda -------------------------------------------

# Zona Salamanca. Con un radio de 480 metros
url1      <-   "http://www.idealista.com/labs/propertyMap.htm?"
center    <-   "center=40.426195,-3.674118"
distancia <-   "&distance=480"
key       <-   "&k=bf702313881a8fcc3c488d3e5e31bdfb"
operation <-   "&operation=sale&action=json"
#numpage   <-  "&numPage=139"

url.salamanca.base <- paste0(url1,center,distancia,key,operation)


# Obtenemos los datos -----------------------------------------------------
# Para analizarlo podemos utilizar la libreria de json

jsondata <- fromJSON(url.salamanca.base)
# Lo primero que necesitamos es el numero de paginas.
numpaginas   <- jsondata[[2]]$totalPages              # paginas totales
pagactual    <- jsondata[[2]]$actualPage              # pagina cargada, suponemos la primera
datos <- data.table(jsondata[[2]]$elementList)        # primera carga de datos

# Bucle para realizar la paginación con los diferentes datos.
# Tardará un rato
while (pagactual < numpaginas){
  pag            <- paste0("&numPage=",pagactual+1)           # obtenemos la pagina siguiente.
  url.salamanca  <- paste0(url.salamanca.base,pag)            # creamos la peticion.
  jsondata <- fromJSON(url.salamanca)                         # obtenemos de nuevo los datos.
  datos <- rbind(datos,data.table(jsondata[[2]]$elementList)) # unimos los datos nuevos
  pagactual    <- jsondata[[2]]$actualPage                    # obtenemos la pagina actual
}
# Vemos el porcentaje de inmuebles con agencia y sin agencia.
# 
table(datos$agency)/nrow(datos) *100

# Guardamos los datos.
save(datos, file = "resultados/08-08-2014-Salamanca-centro-r-480")

# Ahora tendríamos que obtener los telefonos de los particulares.