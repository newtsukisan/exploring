# Este es un script para guardar la respuesta de idealista en formato excel y poder cargarlo en otras
# aplicaciones como tableu o mismamente excel.

# Loading functions -------------------------------------------------------
source("funciones/funciones.R")



# Preparacion -------------------------------------------------------------
# http://188.76.205.16 -> key 9afc447517f3b00421b692bcb3129c4e
# Salamanca            -> 40.426195, -3.674118, 480
# Calle Alba 14        -> 40.460086, -3.651279, 200
file.xlsx <- "resultados/excel/Alba14-3-09-2014.xls"


# Operations --------------------------------------------------------------
# Zona de salamanca. Cargamos los datos desde idealista.
idealista <- getDataFromIdealista(40.460086, -3.651279, 300, 
                     key ="9afc447517f3b00421b692bcb3129c4e",
                     operation='rent', pag=TRUE, deb=TRUE)
# Ahora los exportamos a una hoja de calculo de excel para poder importarlos facilmente en Tableu
#  Ahora lo guardamos como un excel
write.xlsx(x = idealista, file = file.xlsx ,
           sheetName = "Alba", row.names = TRUE)
