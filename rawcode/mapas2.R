# Trabajando con mapas en R


# Libraries ---------------------------------------------------------------
require(ggmap)
require(plyr)
# Functions ---------------------------------------------------------------



# Create some usefull functions


# Loading data ------------------------------------------------------------

load("resultados/Salamanca/Thu-Aug-14-16-47-49-2014/respuestaID.RData")
# Tenemos que añadir el precio por metro cuadrado.
respuestaIdel$preciometro  <- respuestaIdel$price / respuestaIdel$size
data <- respuestaIdel[,c('latitude','longitude','preciometro','propertyType','price','size')]
#data <- as.data.frame(data)
data$latitude  <- as.numeric(data$latitude)
data$longitude <- as.numeric(data$longitude)
# Ahora convertimos algunas de las variables continuas en variables discretas y factores
data$factor.preciometro  <- cut(data$preciometro, c(0,3000,4000,20000))
data$factor.price        <- cut(data$price, c(0,200000,350000,500000,6000000))
data$factor.size         <- cut(data$size,  c(0,45,120,200,300,1000))

levels(data$factor.price) <- c('hasta 200.000', 'entre 200.000 y 350.000',
                               'entre 350.000 y 500.000', ' mas de 500.000')


histograma    <- ggplot(data,aes(x=factor.price))
histograma + geom_histogram(fill=factor.price)

# Dibujando los mapas -----------------------------------------------------

salamanca      <- get_map(location=c(lon=-3.674118,lat=40.426195), zoom=16)
mapa.salamanca <- ggmap(salamanca, extent = "device", legend = "topleft")

mapa.salamanca +
  stat_density2d(
    aes(x = longitude, y = latitude, fill = ..level..,  alpha = ..level..),
    size = 2, bins = 4, data = data,
    geom = "polygon"
  )
overlay <- stat_density2d(
  aes(x = longitude, y = latitude, fill = ..level..,alpha = ..level..),
  bins = 10, geom = "polygon",
  data = data
) 
mapa.salamanca + overlay + scale_fill_gradient(low = "yellow", high = "red") +
  geom_point(data=data, aes(x=longitude, y=latitude),size=5,alpha=0.4)
mapa.salamanca + 
  geom_point(data=data, aes(x=longitude, y=latitude,color=factor.price),size=5,alpha=0.7) +
  scale_colour_brewer(palette="Set1") + 
  facet_wrap( ~ propertyType) 


mapa.salamanca + 
  geom_point(data=data[data$propertyType=='piso',], aes(x=longitude, y=latitude,color=factor.price),size=5,alpha=0.7) +
  scale_colour_brewer(palette="Set1") #+ 
  #facet_wrap( ~ propertyType) 

class(data$factor.preciometro)

#+
  # scale_color_gradient(low = "yellow", high = "red")



# funcion para seleccionar los elementos de cierto tipo, en cierto tipo de nivel y mostrar
# un mapa de densidades.
# mapa.salamanca -> mapa donde vamos a dibujar las densidades
# datatable      -> datos que vamos a representar
# columnaTipo    -> donde vamos a seleccionar uno de los datos para agregar
# tipo           -> que tipo vamos a seleccionar
# colLevel       -> columna donde se encuentra el level para seleccionar
# level          -> nivel que vamos a seleccionar

drawMaps  <- function(mapa.salamanca,datatable,columnaTipo, tipo, colLevel,level){
  # Tiene este tipo de inmueble este tipo de factor.price
  index   <- which(datatable[,c(columnaTipo)] == tipo & datatable[,c(colLevel)] == level)
  # Ahora seleccionamos los elementos
  pisos     <- data[index ,]          # Seleccion de los elmentos para representar
  elementos <- nrow(pisos)            # Comprobamos que tenemos datos para la densidad
  if(elementos >1) {                  # Condicion para dibujar
    overlay <- stat_density2d(
      aes(x = longitude, y = latitude, fill = ..level..,alpha = ..level..),
      size =2, bins = 10, geom = "polygon",
      data = pisos
    ) 
    
    mapa.salamanca + overlay + scale_fill_gradient(low = "yellow", high = "red") +
      geom_point(data=pisos, aes(x=longitude, y=latitude),size=5,alpha=0.4) + 
      theme(legend.position="none") +
      ggtitle(paste("Densidad elementos en tipo",tipo,level))
  }
}

tipos    <- levels(as.factor(data$propertyType))
precios  <- levels(data$factor.price)
drawMaps (mapa.salamanca,data,"propertyType",tipos[[4]],"factor.price",precios[[4]])

pisos <- data[data$propertyType =='piso' levels(data$factor.price)[[2]],]

pisos <- data[data$propertyType ==tipos[[]] & data$factor.price == precios[[1]],]

nrow(pisos)
nrow(data[data$propertyType =='duplex' & data$factor.price == precios[[2]],])
