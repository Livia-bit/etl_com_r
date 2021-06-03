# Mais fatores 
# Compartilhe com a gente um código criado por você com um processo de one hot encoding ou de discretização, e também a transformação dos fatores de uma base de dados em 3 tipos: mais frequente, segundo mais frequente e outros.

install.packages("arules")
install.packages("forcats")

library(arules)
library(forcats)
library(tidyverse)

mtcars
glimpse(mtcars)

carros = mtcars

# Discretização
carros$mpg.Disc <- discretize(carros$mpg, method = "interval", breaks = 3, labels = c("Bebe feito um alcoólatra", 'consumo médio', 'econômico'))

carros$carb<-as.factor(carros$carb)

fct_count(carros$carb) # conta os fatores

fct_lump(carros$carb, n = 2) # reclassifica os fatores em mais frequente, segundo mais frequente e outros
