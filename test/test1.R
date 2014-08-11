# Para crear test de las funciones que queramos
# Lista de definiciones de lo que debe cumplir la funcion
test_that("Repeated root", {
  expect_that(1 ^ 1, equals(1))
  expect_that(2 ^ 2, equals(4))
}
require(testit)
# Forma sencilla de introducir los test de funciones
assert("Debe funcionar bien", 1 != 1)


# expect_that(2 + 2 == 4, is_true())
# expect_that(2 == 1, is_false())
# 
# expect_that(1, is_a('numeric'))
# 
# expect_that(print('Hello World!'), prints_text('Hello World!'))
# 
# expect_that(log('a'), throws_error())