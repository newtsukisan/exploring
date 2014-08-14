# 0. El objetivo de este fichero es realizar todo el proceso de descarga de datos desde el API de
# idealista, la identificación de particulares y la obtencion de los telefonos desde la web
source("funciones/funciones.R")
# Busqueda en nueva España
# proccessDataFromIdealista("resultados","nuevaEsp",40.462926, -3.670845,555,pag=TRUE,deb=TRUE)

# Busqueda en Salamanca 1
proccessDataFromIdealista("resultados","Salamanca",40.426195, -3.674118, 480, pag=TRUE, deb=TRUE)

