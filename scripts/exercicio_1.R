   
# O primeiro exercício tem por base o que aprendemos na introdução do curso, e no tópico de Programação com R. 
#   
# # 
# 📋
# 
# 1. Crie um data frame com pelo menos 500 casos e a seguinte composição: duas variáveis normais de desvio padrão diferente, uma variável de contagem (poisson), uma variável de contagem com dispersão (binomial negativa), uma variável binomial (0,1), uma variável qualitativa que apresenta um valor quando a variável binomial é 0 e outro quando é 1, e uma variável de index. 
# 
# 
# ⭕ As variáveis (normais, contagem e binomial) devem ser simuladas!!!

tarefaSemente <- addTaskCallback(function(...) {set.seed(123);TRUE}) 
tarefaSemente 

# criando as variáveis

normal1 <- rnorm(500, mean = 10, sd = 50)
normal1

normal2 <- rnorm(500, mean = 10, sd = 20)
normal2

poisson <- rpois(500, 4)
poisson

binomialnegativa <- rnbinom(500, mu = 4, size = 50)
binomialnegativa

binomial <- rbinom (500, 1, 0.7)
binomial

categoricaBinomial <- binomial
   
categorica <- ifelse(categoricaBinomial == 1, "sim", "não")
categorica

binomial [1:5]  
categorica [1:5]
categorica [c(2, 5, 7)]

index <- seq(1, length(normal1))
index 

# criando o data.frame

bancoOriginalSimulado <- data.frame (normal1, normal2, poisson, binomialnegativa, binomial, categorica, index)

View(bancoOriginalSimulado)

head(bancoOriginalSimulado)

# 2. Centralize as variáveis normais. 

normal1Central <- normal1 - mean(normal1)
normal1Central

par(mfrow = c(2,2))

hist(normal1)
hist(normal1Central)

normal2Central <- normal2 - mean(normal2)
normal2Central

hist(normal2)
hist (normal2Central)


# 3. Troque os zeros (0) por um (1) nas variáveis de contagem. 

bancoOriginalSimulado1 <- bancoOriginalSimulado

# 

for(i in 3:4)# para i variando entre 3 e 4 colunas
{
   for (j in 1:length(bancoOriginalSimulado1[, i]))#para j variando entre 1 e o numero de linhas da coluna i
   {
     if(bancoOriginalSimulado1[j,i] == 0)
     {
       bancoOriginalSimulado1[j, i] <- 1
     }
   }
   
}


bancoOriginalSimulado[272:277, 3:4]
bancoOriginalSimulado1[272:277, 3:4]



# 4. Crie um novo data.frame com amostra (100 casos) da base de dados original.

bancoNovo <- bancoOriginalSimulado[sample(nrow(bancoOriginalSimulado), 100, r = T), ]

# ou 

bancoTeste <- as.data.frame(lapply(bancoOriginalSimulado, sample, size=100, replace=TRUE))

view(bancoTeste)

view(bancoOriginalSimulado)

View(bancoNovo)

 
# # ▶ Compartilhe com a gente o seu endereço de github com o código do exercícicio!!!
# 



