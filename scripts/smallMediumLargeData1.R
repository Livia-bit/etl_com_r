# Compartilhe com a gente um código criado por você em que você usa um dos dois processos otimizados (read.csv2 com amostragem ou fread) para ler uma base de dados ampla! Também compartilhe prints, mostrando a eficiência de cada caso. Mas lembre-se de conferir se a interpretação das colunas está de acordo, hein??? Não adiante puxar os dados com eficiência e perder eficácia, criando anomalias!

tarefaSemente <- addTaskCallback(function(...) {set.seed(123);TRUE})
library(data.table)

# meu computador só tem 4GB de memória Ram, não consegui carregar bases com 1GB para caracterizar large data e simulei com a que segue.

casos= 2e6

# cria o data.frame com o total de casos definido acima
dfLarge = data.table( sensacaoTermica=rnorm(casos, m=35, s=1.5),
                      temperatura=rnorm(casos, m=28, s=1.2), 
                      velocidadeVento=sample(5L:80L, casos, replace=TRUE),
                      clima=sample(c("chovendo com trovoadas", "muito nublado", "ensolarado e com poucas nuvens", "um sol para cada um"), casos,replace=TRUE )
)

head(dfLarge)

object.size(dfLarge)
# 56002056 bytes

write.table(dfLarge,"bases_originais/dfLarge.csv",sep=";", dec=",",row.names=FALSE,quote=FALSE) # salva em disco

rm(list= 'dfLarge')
#-----------------------------------------------------------------------------


enderecoDfLarge <- 'bases_originais/dfLarge.csv'

# extração direta via read.csv2
system.time(extracao1 <- read.csv2(enderecoDfLarge))

#   usuário   sistema decorrido 
#      7.97      0.63      8.69 

head(extracao1)

# extração via amostragem com read.csv2

# ler apenas as primeiras 20 linhas
amostraDfLarge1 <- read.csv2(enderecoDfLarge, nrows=20)  

amostraDfLarge1Classes <- sapply(amostraDfLarge1, class) # encontra a classe da amostra amostra

# fazemos a leitura passando as classes de antemão, a partir da amostra
system.time(extracaoDfLarge2 <- data.frame(read.csv2("bases_originais/dfLarge.csv", colClasses=amostraDfLarge1Classes) ) )  

# comparado ao método anterior,o tempo com a extração via amostragem com read.csv2 foi menor que a extração direta

#   usuário   sistema decorrido 
#     5.03      0.30      5.38 

# extração via função fread, que já faz amostragem automaticamente
system.time(extracaoDfLarge3 <- fread(enderecoDfLarge))

# comparado com a extração por amostragem anterior, a extração com fread foi mais rápida.

#  usuário   sistema decorrido 
#     2.42      0.07      1.96 

head(extracaoDfLarge3)
# como a base foi simulada, não foi verificado problemas de importação, os dados foram importados sem anomalias.

#----------------------------------------------------------------------------

# Compartilhe com a gente um código criado por você em que um large data é lido através da função ff. Também mostre pelo menos duas operações estatísticas (média, mediana...) ou matemáticas básicas (soma, produto...), e uma aplicação de estatística inferencial (regressão linear, X²...), usando uma amostra da base.

library(ff)

enderecoDfLarge <- 'bases_originais/dfLarge.csv'

# criando o arquivo ff
system.time(extracaoDfLarge4 <- read.csv2.ffdf(file=enderecoDfLarge))

# comparado com as formas de extração otimizada anteriores, verifica-se que o tempo foi um pouco mais lento com a função ff.

# usuário   sistema decorrido 
#    5.26      0.50      5.80 


class(extracaoDfLarge4) # veja a classe do objeto
# "ffdf"

head(extracaoDfLarge4)
object.size(extracaoDfLarge3) # apesar dessa extração ser otimizada no tempo de importação, ela ocupa mais memória comparado com a extração com a função ff.

# 369576648  bytes

object.size(extracaoDfLarge4) # verifica-se a vantagem no tamanho.
# 17896  bytes

# # operações estatísticas

median(extracaoDfLarge4[, 1]) 
# 34.99887

mean(extracaoDfLarge4[, 1])
# 34.99844

# pra outras, será preciso amostrar...
extracaoDfLarge4Amostra <- extracaoDfLarge4[sample(nrow(extracaoDfLarge4), 100000) , ]
head(extracaoDfLarge4Amostra)
summary(extracaoDfLarge4Amostra)

regressao <- lm(sensacaoTermica ~ temperatura + velocidadeVento, data=extracaoDfLarge4Amostra)
summary(regressao)

# Como esperado, por a base ter sido criada aleatoriamente, a regressão não teve resultados significantes.

# Residuals:
#   Min      1Q  Median      3Q     Max 
# -6.8826 -1.0152  0.0041  1.0044  6.6651 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept)      3.514e+01  1.113e-01 315.892   <2e-16 ***
#   temperatura     -5.314e-03  3.956e-03  -1.343    0.179    
# velocidadeVento -1.791e-05  2.172e-04  -0.082    0.934    
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 1.503 on 99997 degrees of freedom
# Multiple R-squared:  1.811e-05,	Adjusted R-squared:  -1.886e-06 
# F-statistic: 0.9057 on 2 and 99997 DF,  p-value: 0.4043