# Guardamos los datos de los particulares para poder hacer con ellos llamadas.
# Guardamos todos los datos de los particulares que nos pueden interesar para hacer las
# llamadas
require(data.table)
require(xlsx)


file  <- paste0("resultados/SalamacaSat Aug9-2",".RData")
load(file)
revision <- final[,c(1,38),with=FALSE]
names(final)[8]
# Ahora queremos crear un data table 
particulares.Salamanca   <- data.table(zona = final$neighborhood, calle  = final$address,
                                       dorm = final$rooms,  planta = final$floor,
                                       metros = final$size, precio = final$price,
                                       telef = final$telefono, 
                                       url   = paste0("http://",final$url), 
                                       tipo  = final$propertyType)

#  Ahora lo guardamos como un excel
write.xlsx(x = particulares.Salamanca, file = "resultados/particularesSalamanca.xlsx",
           sheetName = "particulares", row.names = FALSE)