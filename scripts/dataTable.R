# Data table
# Compartilhe com a gente um código criado por você com a aplicação direta do sumário de uma regressão linear, usando a sintaxe de data table.

library(data.table)
library(dplyr)

carrosDT <- mtcars %>% setDT()
class(carrosDT)
carrosDT[ , lm(formula = mpg ~ gear + cyl)]
