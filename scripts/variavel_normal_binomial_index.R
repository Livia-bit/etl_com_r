# seta a semente aleatória de geração de dados
# usando a função addTaskCallback deixamos a set.seed fixa, rodando no back

tarefaSemente <- addTaskCallback(function(...) {set.seed(123);TRUE})

# criando uma variável com distribuição normal com a função rnorm

variavelDistNormal <- rnorm(200, mean = 20, sd = 2)
variavelDistNormal

# criando uma variável com distribuição binomial com a função rbinom
# Considerando que uma uti para Covid de um certo hospital está com ocupação de 60 leitos, com uma taxa de mortalidade diária de 20%, deseja-se simular o número de mortes em 7 dias de uma semana.

numeroMortesCovidDistBinominal <- rbinom(7, 60, 0.2)
numeroMortesCovidDistBinominal

# criando uma variável com index usando a função seq() e a função length para indexar a primeita metade dos casos

indexvariavel <- seq(1, length(variavelDistNormal)/2) 
indexvariavel

# removendo a tarefa criada acima

removeTaskCallback(tarefaSemente)

