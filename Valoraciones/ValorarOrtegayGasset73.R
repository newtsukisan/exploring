# Este es un script para guardar la respuesta de idealista en formato excel y poder cargarlo en otras
# aplicaciones como tableu o mismamente excel.

# Loading functions -------------------------------------------------------
source("funciones/funciones.R")



# Preparacion -------------------------------------------------------------
# http://188.76.205.16      -> key 9afc447517f3b00421b692bcb3129c4e
# http://95.16.1.137        -> 33c703f985e886fcb93fbda51b9fc37e
# Salamanca                 -> 40.426195, -3.674118, 480
# Calle Alba 14             -> 40.460086, -3.651279, 200
# Calle Nicaragua 19        -> 40.457828, -3.670684, 150
# Calle Ortega y Gasset 73  -> 40.429918, -3.672971, 200 
file.xlsx <- "resultados/excel/CalleOrtegaGasset19-18-09-2014.xls"


# Operations --------------------------------------------------------------
# Zona de salamanca. Cargamos los datos desde idealista.
idealista <- getDataFromIdealista(40.429918, -3.672971, 201, 
                     key ="33c703f985e886fcb93fbda51b9fc37e",
                     operation='sale', pag=TRUE, deb=TRUE)
# Ahora seleccionamos los datos que son de tipo piso con por encima de los 60 metros cuadrados.

comparativos <- subset (idealista, propertyType=='dúplex') # Por tipo
comparativos <- subset (comparativos, size > 100)

# Podemos ahora seleccionar solo una serie de columnas para incluir en nuestro estudio.
names.tidy   = c('district','neighborhood','address','rooms','floor','size','price','url','propertyType')
representativos <- getDataFromNames(names.tidy, comparativos)

write.xlsx(x = representativos, file = file.xlsx ,
           sheetName = "Nicaragua", row.names = TRUE)


