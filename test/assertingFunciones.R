# Para probar de forma sencilla algunas de las funciones
source("funciones/funciones.R")
require(scrapeR)
# testeando getParameterFromResponse
# Para hacer pruebas podemos guardar una de las paginas y utilizarla como fuente.

# "//section/div/div/p"
# Vamos a ver como seria hacer un scrape mas profesional
particulares$url

# Sacamos cuales estan sin respuesta
pageSource<-scrape(url=particulares$url,headers=TRUE,parse=FALSE)

# Filtramos las que nos interesan
# Ahora debemos hacer un recorrido por cada uno de ellos
if(attributes(pageSource)$headers["statusCode"]==200) {
  page<-scrape(object="pageSource")
  xpathSApply(page,"//table//td/a",xmlValue)
} else {
  cat("There was an error with the page. \n")
}
pageSource[1]$names

require(foreach)
foreach (i= 1:length(pageSource)) %do% {
  (attributes(pageSource[[1]])$headers)[1]==200
}



pageSource<-scrape(url="http://www.idealista.com/inmueble/27600141",headers=TRUE,parse=FALSE)

