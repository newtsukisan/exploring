# Para testear los datos de las diferentes versiones de las funciones.

# source('funciones/funciones.R')


# testeo basico de la creacion de uan url
test_that("Testear la funcion de tiempos aleatorios", {
url.test    <- "http://www.idealista.com/labs/propertyMap.htm?center=40.426195,-3.674118&distance=500&k=bf702313881a8fcc3c488d3e5e31bdfb&operation=sale&action=json"
url.test.1  <- getURLBase(40.426195,-3.674118,500)
expect_true( url.test == url.test.1)
})


test_that("Adquision de los datos desde el API de idealista", {
  inmuebles <- getDataFromIdealista(40.426195,-3.674118,400, paginar= FALSE,debug= TRUE)
  expect_true(is.data.table(inmuebles))
  expect_true(nrow(inmuebles)==20)
})


# Testeo de generacion de tiempos aleatorios.
test_that("Testear la funcion de tiempos aleatorios", {
  t1 <- proc.time()
  wait(1,0.3)
  t2 <- proc.time() -t1
  expect_true(t2[3]<= (1+3*0.3))
})
# Test conversion de nombres para la generacion de los directorios con fechas.
test_that("Nombres para los directorios con fechas.", {
  entrada <- "resultados/Salamanca/Thu Aug 14 12:16:51 2014/"
  deseado <- "resultados/Salamanca/Thu-Aug-14-12-16-51-2014/"
  expect_that(deseado,equals(setDirFormats(entrada)))
})

test_that("Testeamos la obtencion de datos por el nombre",{
  d1 <- data.table (a = 1:5, b= 6:10)
  d2 <- getDataFromNames (c('a'),d1) 
  d3 <- data.table(a = 1:5)
  expect_that(d2, equals(d3))
})