# Tratando de analizar algunas cuestiones en los datos descargados.
 require(ggplot2)
 require(data.table)
 getwd()
 source("funciones/funciones.R")
# Cargamos los datos de salamanca.
load("resultados/Salamanca/Wed-Aug-13-13-39-00 2014/respuestaID.RData")
campos <- c('neighborhood','address','rooms','floor','size','price','agency','url','propertyType','showAddress')
# Creamos un conjunto de datos tidy con los campos minimos para analizarlo.
tidyData <- getDataFromNames(campos, respuestaIdel)
 
# Podríamos creer que las inmobiliarias que no tienen exclusiva son aquellos anuncios que
# son de agencia y que no tienen planta. En la tabla siguiente tendremos TRUE reprenta el
# numero de agencias que posiblemente se encuentren en exclusiva
table(tidyData$floor !="" & tidyData$agency == TRUE)
table(tidyData$agency)

# Podemos ver una distribucion de los precios en la zona

p <- ggplot(tidyData,aes(x=price))
p + geom_histogram() + geom_density()
p + geom_density()

# Podemos ver la distribucion de precios teniendo en cuenta las habitaciones
# para lo cual utilizamos facet
d1 <-  ggplot(tidyData,aes(x=size,y=price)) + geom_point()
d1 + facet_grid(. ~ rooms)
# Podemos ver la distribucion de los precios dependiendo del tipo de piso

 d2 <- ggplot(tidyData,aes(as.factor(propertyType),price))
 d2 + geom_boxplot()
 
# Vemos las medianas para cada uno de los casos.
 tapply(tidyData$price, tidyData$propertyType, median)
 tapply(tidyData$price, tidyData$propertyType, mean  )
