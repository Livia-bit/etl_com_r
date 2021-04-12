tarefaSemente <- addTaskCallback(function(...) {set.seed(123);TRUE})

variavelDistNormal <- rnorm(200, mean = 20, sd = 2)
variavelDistNormal

removeTaskCallback(tarefaSemente)

# aplicando a técnica bootstrapping com a função replicate
# criando um bootstrapping

set.seed(412)

bootsVariavel15 <- replicate(15, sample(variavelDistNormal, 12, replace = TRUE)) # replicando 15x a amostra de tamanho 12
bootsVariavel15

# calculando a média com bootstrapping de 20 amostras de 12 casos

mediaBootsVariavel20 <- replicate(20, mean(sample(variavelDistNormal, 12, replace = TRUE))) 

# calculando a média com bootstrapping de 75 amostras de 12 casos

mediaBootsVariavel75 <- replicate(75, mean(sample(variavelDistNormal, 12, replace = TRUE))) 

# calculando a média com bootstrapping de 100 amostras de 12 casos

mediaBootsVariavel100 <- replicate(100, mean(sample(variavelDistNormal, 12, replace = TRUE)))

# comparando

mean(mediaBootsVariavel20) # media do bootstraping 20
mean(mediaBootsVariavel75) # media do bootstraping 75
mean(mediaBootsVariavel100) # media do bootstraping 100
mean(variavelDistNormal) # media dos dados originais
