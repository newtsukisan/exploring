# 0.0 Objetivo y definición ------------------------------------------------

# Funciones para obtener y depurar los datos desde idealista.


# 0.1 libraries -----------------------------------------------------------
require(data.table)
require(jsonlite)
require(httr)
require(XML)
require(xlsx)
require(testit)
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
# distancia-> Distancia del radio de busqueda en metros. ejemplo 500
# key      -> Por defecto la generada para la la http://85.52.103.122 
# operation-> sale or rent, por defecto es sale.
# key cambia con cada ip de consulta. Para generarla es necesario ir a la web de idealista y 
# crear un api con la direccion http://ip
# http://87.221.8.75   Fermin caballero  -> a50c6300a116fdccbb24527e121895af
# http://85.52.103.122 Alcala            -> bf702313881a8fcc3c488d3e5e31bdfb

# ----------------------------------------------------------------------------------------------------
claveActual             <- "DpPOC772Ka5f9VAM4gvxKzSkT0Tq9bij"
MaxItems                <- "1000"
# ----------------------------------------------------------------------------------------------------
getURLBase  <- function(latitud,longitud, distancia, key =claveActual,
                        operation='V',aditional="",maxItems=MaxItems){
  url1      <-   "http://idealista-prod.apigee.net/public/2/search?"
  center    <-   paste0("center=",latitud,",",longitud)
  distancia <-   paste0("&distance=",distancia)
  key       <-   paste0("&apikey=",key)
  operation <-   paste0("&operation=",operation)
  action    <-   "&action=json"
  items     <-   paste0("&maxItems=",maxItems)
  #numpage  <-  "&numPage=139"
  paste0(url1,center,distancia,key,operation,action,aditional,items)
}# end function


# Funcion para conectarse al api de idealista
# recibe key, centro y distancia
# devuelve un data.table con los datos obtenidos.
# trying to get data form idealista
# Ejemplo de uso.
# inmuebles <- getDataFromIdealista(40.426195,-3.674118,400, operation='sale',
#                                   paginar= TRUE, debug= TRUE)
getDataFromIdealista <- function(lat ,long, dist,
                                 key =claveActual,
                                 operation='V', 
                                 paginar= TRUE, debug = FALSE,aditional="",maxItems=MaxItems){
  url.base  <- getURLBase(lat ,long, dist,key,operation,aditional,maxItems)
  # Para analizarlo podemos utilizar la libreria de json
  jsondata <- fromJSON(url.base)
  # Lo primero que necesitamos es el numero de paginas.
  if (debug) print("Comenzando peticion de datos ...")
  numpaginas <- 1;
  pagactual    <- jsondata$actualPage              # pagina cargada, suponemos la primera
  datos <- data.table(jsondata$elementList)        # primera carga de datos
  if (paginar) {                                   # si queremos obtener todas las paginas
    numpaginas   <- jsondata$totalPages            # paginas totales
  }
  # Bucle para realizar la paginación con los diferentes datos.
  # Tardará un rato
  # Necesitamos incluir un retardo al pedir cada una de las paginas
  while (pagactual < numpaginas){
    Sys.sleep(2)
    pag            <- paste0("&numPage=",pagactual+1)           # obtenemos la pagina siguiente.
    if(debug) print(paste0("Obteniendo datos de la pagina ",pag," de ",numpaginas))
    url.paginada   <- paste0(url.base,pag)                      # creamos la peticion.
    jsondata <- fromJSON(url.paginada)                          # obtenemos de nuevo los datos.
    datos <- rbind(datos,data.table(jsondata$elementList)) # unimos los datos nuevos
    pagactual    <- jsondata$actualPage                    # obtenemos la pagina actual
    
  }
  if(debug) print("Terminando peticion de datos.....")
  datos           # devolvemos los datos descargados despues de la paginacion
}


# Para la funcion de obtener parametros de cada una de las paginas, 
# necesitamos simular la distribución de tiempos en las llamadas con un elemento de pausa
# y una generacion de tiempos aleatoria.

# Creamos una funcion que dado un contenido obtenido de un GET nos de un parametro
# asociado a una determinada cadena de busqueda utilizando Xpath
# response -> es obtenido GET(url). Utiliza la biblioteca httr
# xpath    -> para buscar el parametro "//section/div/div/p"
getParameterFromResponse <- function (response, xpath){
  # contenido   <- content(response,as="text")             # Si funciona, parseamos
  # html        <- htmlParse(contenido, asText = TRUE)     # html
  param <- xpathSApply(response,xpath,xmlValue)            # devuelve el parametro
  Reduce(function (x,y) paste(x,y), param, "")             # Para tener solo un elemento
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

wait <- function(tmedio,sd){
  Sys.sleep(rnorm(1,tmedio,sd))
}

# Funcion para extraer los datos de un data.table a partir de los nombres.
# Recibe los nombres en data frame y extrae los datos con esos nombres en otro data frame
# namesof   -> vector of names in the data table c('code','url')
# datatable -> datatable con los datos.
getDataFromNames <- function(namesof, datatable){ 
  datatable[,namesof,with =FALSE] 
}

# Una funcion de ayuda que nos devuelva la url a partir de un propertyCode
getURL <- function (data,code){
  data[data$propertyCode==code]$url
}

# Funcion para obtener las responses que contienen los datos de cada una de las paginas
# recibe una lista de url y devuelve una data.table con las url y los
# contenidos. En el caso de no encontrar contenidos devuelve NULL.
# los contenidos devueltos se utilizan con la funcion getParameterFromResponse
# funcion getParameterFromResponse
getResponsesFromUrl <- function (urlList, debug = TRUE, tiempo = 2, sd= 0.3){
  n             <- length(urlList)                      # Size de nuestra lista de url               
  contenidos    <- c()                                  # Para almacenar los datos
  url.final     <- c()                                  # Para almacenar las url
  assert("Debemos tener valores en la lista de urls", n !=0)
  for(i in 1:n){                                        # Bucle de iteracion
    wait(tiempo,sd)                                     # Esperamos un tiempo entre llamadas
    url.iter    <- urlList[[i]]                         # la url almacenada de la iter i
    url.llamada <- paste0("http://",url.iter)           # Utilizamos nuestra ip directamente
    response    <- GET(url.llamada)                     # Obtenemos la respuesta
    if (response$status_code!=200){                     # HTTP request failed!!
      if(debug) 
        print(paste("Failure:",i,"Status:",response$status_code)) # show status error
      next                                               # Pasamos al siguiente
    }else {
      contenido   <- content(response,as="text")         # Si funciona, parseamos
      html        <- htmlParse(contenido, asText = TRUE) # html
      contenidos  <- append (contenidos, html)        # Vector de salida
      url.final   <- append (url.final, url.iter)         # Vector de url
    }# end else
    
  }# end bucle for
  # Lo guardamos en una estructura que luego podamos utilizar para ser almacenada y 
  # podamos extraer los datos que nos interesan sin problema
  # Debemos tener datos. Si no tenemos nada almacenado, porque todas las direcciones
  # se encuentran mal, entonces devolvemos NULL
  if(length(url.final) == 0) NULL
    else data.table(url = unlist(url.final), contenidos = contenidos)
} #end function.


# Automatizar todo el proceso desde una funcion. 
# Toma los datos desde idealista y lo guarda en varios ficheros organizados en directorios por
# la fecha.
# como manejar fechas en R para que sean validas como nombres de ficheros
proccessDataFromIdealista <- function (dir.base,zona,     # para guardar los ficheros
                                       latitud, longitud, # centro de la busqueda
                                       radio,             # radio de busqueda
                                       xpath   = "//section/div/div/p",# Busqueda telefonos
                                       names.tidy   = c('neighborhood','address',
                                                        'rooms','floor','size','price',
                                                        'telefono','url','propertyType'), # in tidy data
                                       pag = TRUE, deb = TRUE,
                                       adit="",
                                       k = claveActual,
                                       maxIt=MaxItems){
  
  dir.name  <- paste0(dir.base,"/",zona,"/",date(),"/")   # directorio donde guardar las descargas
  dir.name  <- setDirFormats(dir.name)                    # Cambiamos algunos caracteres para guardar
  dir.create(dir.name,recursive = TRUE)                   # creamos un directorio con las fechas.
  getfileName  <- function(name) paste0(dir.name,name)    # para crear cada uno de los nombres
  # Nombres para los ficheros intermedios.
  file.respuestaIdealista <- getfileName("respuestaID.RData")
  file.contenidos         <- getfileName("contenidos.RData")
  file.tidy               <- getfileName("tidy.RData")
  file.xlsx               <- getfileName(paste0(zona,".xlsx"))
  # Ahora realizamos todo el proceso.
  print("pedimos los datos.")
  respuestaIdel     <- getDataFromIdealista(latitud, longitud, radio, key=k,paginar = pag, debug= deb,
                                            aditional=adit,maxItems=maxIt)
  particulares      <- respuestaIdel[showAddress==TRUE,]              # Obtenemos los particulares
  # Guardamos todos los datos.
  save (respuestaIdel, file=file.respuestaIdealista)
  # Ahora podemos sacar todas las paginas asocidas a los particulares.
  contenidosParticulares  <- getResponsesFromUrl(particulares$url)
  # Si hemos obtenido respuesta de la pagina web de algunos particulares.
  if(!is.null(contenidosParticulares)){ # Si los particulares tienen pagina y contenidos.
    # Guardamos para no tener que cargarlos de nuevo
    save(contenidosParticulares, file=file.contenidos)
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
}

# Funcion para generar los nombres de los ficheros con fechas de forma que luego sean legibles
# Como al guardar los datos en las carpetas con fecha se puede hacer un poco complicado el 
# recuperarla. Se trata de transformar los nombres un poco para que luego sea facil el poder 
# recuperar los ficheros de cada uno de los archivos que tienen fechas.
# entrada <- "resultados/Salamanca/Thu Aug 14 12:16:51 2014/"
# salida <- "resultados/Salamanca/Thu-Aug-14-12-16-51-2014/"
setDirFormats   <- function (dir.name){
  gsub(":","-",gsub(" ","-",dir.name))
}

# Funcion que recibe un url y extrae el codigo del final.
# Con esta funcion tratamos de obtener el codigo del inmueble para poder 
# saber si tenemos nuevas propiedades que no está incluidas en la base de datos.
# http://www.idealista.com/1632913" -> 1632913
extractCode <- function (url){
  m     <- regexpr("/([0-9]+)", url)
  lista <- regmatches(url, m)
  gsub("/","",lista) 
}

