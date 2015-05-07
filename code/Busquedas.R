# 0. El objetivo de este fichero es realizar todo el proceso de descarga de datos desde el API de
# idealista, la identificación de particulares y la obtencion de los telefonos desde la web
source("funciones/funciones.R")
# http://87.221.0.243    -> 2c7f76b7dbb9cce5234135fa97f94a19
# http://82.158.176.205  -> 0507bf75d3e75390e3946abee5b56121
# 15-12-2014 cambio los datos del centro de la zona de Salamaca


# Busqueda en nueva España
proccessDataFromIdealista("resultados","nuevaEsp",40.462926, -3.670845,555,pag=TRUE,deb=TRUE)


# Busqueda en Salamanca 1
#proccessDataFromIdealista("resultados","Salamanca",40.426195, -3.674118, 480, pag=TRUE, deb=TRUE)
proccessDataFromIdealista("resultados","Salamanca",    # Para guardar los datos.
                           40.426195, -3.674118, 500,  # centro y radio de la zona 
                          pag=TRUE, deb=TRUE)          # paginado para extraer los datos.


# Busqueda en hispano America
# coordenadas de la calle cuarta   40.455986, -3.669036 462
proccessDataFromIdealista("resultados","HispanoAmerica", 
                          40.455986, -3.669036 ,462, 
                          pag=TRUE, deb=TRUE,
                          k="DpPOC772Ka5f9VAM4gvxKzSkT0Tq9bij")





# Busqueda en la zona de Ariel 4.
# 40.393537, -3.679118, radio = 189
#proccessDataFromIdealista("resultados","Salamanca",# Para guardar los datos.
#                      40.426195, -3.674118, 485,   # centro y radio de la zona 
#                          pag=TRUE, deb=TRUE,      # paginado para extraer los datos.
#                         k="bf702313881a8fcc3c488d3e5e31bdfb") # clave para la conexion
