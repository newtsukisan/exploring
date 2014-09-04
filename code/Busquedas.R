# 0. El objetivo de este fichero es realizar todo el proceso de descarga de datos desde el API de
# idealista, la identificación de particulares y la obtencion de los telefonos desde la web
source("funciones/funciones.R")
# Busqueda en nueva España
# proccessDataFromIdealista("resultados","nuevaEsp",40.462926, -3.670845,555,pag=TRUE,deb=TRUE)

# Busqueda en Salamanca 1
#proccessDataFromIdealista("resultados","Salamanca",40.426195, -3.674118, 480, pag=TRUE, deb=TRUE)

# Busquedas en Salmanca 2
# proccessDataFromIdealista("resultados","Salamanca2",40.422958, -3.681797,350, pag=TRUE, deb=TRUE)


proccessDataFromIdealista("resultados","HispanoAmerica", 40.455110, -3.674150 ,370, pag=TRUE, deb=TRUE)
