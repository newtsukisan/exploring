load("../resultados/Salamanca/Thu-Aug-14-16-47-49-2014/respuestaID.RData")




require(data.table)
require(ggplot2)
load("resultados/Salamanca/Thu-Aug-14-16-47-49-2014/respuestaID.RData")
table(respuestaIdel$agency)
# Vemos el porcentaje de particulares y de agencias.
porcentajes  <- prop.table(table(respuestaIdel$agency))
particulares <- porcentajes [[1]];
agencias     <- porcentajes [[2]];


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