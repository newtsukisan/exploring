# Tratando de crear mapas de color con los datos de los pisos que estamos captando.
require(RgoogleMaps)
require(MASS)
require(RColorBrewer)
source('funciones/colorRampPaletteAlpha.R')
load("resultados/Salamanca/Thu-Aug-14-16-47-49-2014/respuestaID.RData")
# Tenemos que añadir el precio por metro cuadrado.
respuestaIdel$preciometro  <- respuestaIdel$price / respuestaIdel$size
# Create an data frame with values that we want
# Create heatmap with kde2d and overplot

cols <- rev(colorRampPalette(brewer.pal(8, 'RdYlGn'))(100))

data <- respuestaIdel[,c('latitude','longitude','preciometro')]
data$latitude  <- as.numeric(data$latitude)
data$longitude <- as.numeric(data$longitude)


# Tratamos de analizar los puntos para un heatmap
# Create heatmap with kde2d and overplot
k <- kde2d(data[,1], data[,2], n=500)
# Intensity from green to red
cols <- rev(colorRampPalette(brewer.pal(8, 'RdYlGn'))(100))
# par(bg='white')
image(k, col=cols, xaxt='n', yaxt='n')
points(data, cex=0.1, pch=16)
# Create exponential transparency vector and add
alpha <- seq.int(0.5, 0.95, length.out=100)
alpha <- exp(alpha^6-1)
cols2 <- addalpha(cols, alpha)



map  <- GetMap(center=c(40.426195, -3.674118), zoom=16)
PlotOnStaticMap(map)

# Plot
PlotOnStaticMap(map)
image(k, col=cols2, add=T)
points(data, cex=0.1, pch=16)
