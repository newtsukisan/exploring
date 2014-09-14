#load("../resultados/Salamanca/Thu-Aug-14-16-47-49-2014/respuestaID.RData")




require(data.table)
require(ggplot2)
load("resultados/Salamanca/Thu-Aug-14-16-47-49-2014/respuestaID.RData")
table(respuestaIdel$agency)
# Vemos el porcentaje de particulares y de agencias.
porcentajes  <- prop.table(table(respuestaIdel$agency))
particulares <- porcentajes [[1]];
agencias     <- porcentajes [[2]];
# Tenemos que añadir el precio por metro cuadrado.
respuestaIdel$preciometro  <- respuestaIdel$price / respuestaIdel$size
respuestaIdel <- data.table(respuestaIdel)

medianas.1 <- respuestaIdel[,c(median(preciometro)), by =  propertyType]
medianas.2 <- respuestaIdel[,c(sd(preciometro))    , by =  propertyType]
setnames(medianas.1,colnames(medianas.1),c('Tipo','Mediana metro 2'))
setnames(medianas.2,colnames(medianas.2),c('Tipo','Desviacion'))
merge(medianas.1,medianas.2,by='Tipo')

p <- ggplot(data.frame(tipo=c('particular','agencia'),porcentaje=c(particulares,agencias)),
            aes(x=tipo,y=porcentaje))
p + geom_bar(colour="black", fill="#DD8888", width=.7, stat="identity") + 
  guides(fill=FALSE) +
  xlab("Tipo de gestión") + ylab("Porcentaje") +
  ggtitle("Porcentaje de Particulares vs Agencias")

# Tenemos que añadir el precio por metro cuadrado.
respuestaIdel$preciometro  <- respuestaIdel$price / respuestaIdel$size
d.metros <- ggplot(respuestaIdel,aes(x=preciometro))
d.metros +geom_histogram()

# Histogram overlaid with kernel density curve
ggplot(respuestaIdel, aes(x=preciometro)) + 
  geom_histogram(aes(y=..density..),      # Histogram with density instead of count on y-axis
                 binwidth=500,
                 colour="black", fill="white") +
  geom_density(alpha=.2, fill="#FF6666")       + # Overlay with transparent density plot
  geom_vline(aes(xintercept=mean(preciometro)), # Ignore NA values for mean
             color="red", linetype="dashed", size=1) + 
  geom_vline(aes(xintercept=median(preciometro)), # Ignore NA values for mean
             color="blue", linetype="dashed", size=1) + 
  facet_grid(propertyType~. )




respuestaIdel  <- as.data.frame(respuestaIdel)
data <- respuestaIdel[,c('latitude','longitude','preciometro','propertyType','price','size')]
data$latitude  <- as.numeric(respuestaIdel$latitude)
data$longitude <- as.numeric(respuestaIdel$longitude)
# Ahora convertimos algunas de las variables continuas en variables discretas y factores
data$factor.preciometro  <- cut(as.numeric(data$preciometro), c(0,3000,4000,20000))
data$factor.price        <- cut(as.numeric(data$price), c(0,200000,350000,500000,6000000))
data$factor.size         <- cut(as.numeric(data$size),  c(0,45,120,200,300,1000))
# 
levels(data$factor.price) <- c('hasta 200.000', 'entre 200.000 y 350.000',
                               'entre 350.000 y 500.000', ' mas de 500.000')