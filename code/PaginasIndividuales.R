# Vamos a probar la obtencion de responses desde una lista de urls.
# Luego todo el proceso comprende los siguientes pasos.
# 1- Obtener los datos del api de idealista
# inmuebles <- getDataFromIdealista(40.426195,-3.674118,400, paginar= TRUE, debug= TRUE)
# 2- Guardar los datos.
# save(inmuebles, file = "resultados/...")
# 3- De las url obtener los contenidos y guardarlos para usarlos posteriormente
# lista            <- datos$url[11:17]
# frame.responses  <- getResponsesFromUrl(lista)
# 4- Con los contenidos guardados analizar los elementos de las paginas que queramos.
# save(contenidos, file="...")
# Para analizar los diferentes contenidos utilizamos las busquedas de XPath
# getParameterFromResponse(c, "//section/div/div/p")
# Telefono "//section/div/div/p"
# Visitas  '//li/strong'
# "//section[@id='stats']//li/strong"
# "//section[@id=\'stats\']//li/strong"
source('funciones/funciones.R')
load("resultados/Salamanca.RData")

# Obtenemos algunos datos para ver las responses

lista             <- datos$url
frame.contenidos  <- getResponsesFromUrl(lista)
# Despues tendríamos que guardarlo para poder analizarlo posteriormente.

c <- frame.responses$contenidos[[1]]
getParameterFromResponse(c, "//section/div/div/p")

sapply(frame.responses$contenidos, function(l) getParameterFromResponse(l,"//section/div/div/p"))
