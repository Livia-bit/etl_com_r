#### Compartilhe com a gente um código criado por você com uma shadow matrix e um teste de aleatoriedade de valores ausentes. Lembre-se de compartilhar um link do github!!!

library(data.table)
library(funModeling) 
library(tidyverse) 

# Fonte: IPEADATA
# Pessoal ocupado - Serviços
# Fonte: Instituto Brasileiro de Geografia e Estatística
# Frequência: Quinquenal de 1970 até 1995
# Unidade: Pessoa
# Comentário: O universo de municípios da tabela é definido pelo IBGE no levantamento censitário e não necessariamente coincide com o oficialmente existente ou instalado na data de referência.
# Atualizado em:12/05/2011

library(readr)
pessoalOcupado <- read.csv2("bases_originais/pessoalOcupado.csv", sep=";", header = TRUE, skip = 1,encoding = 'UTF-8')

pessoalOcupado$X<-NULL

status(pessoalOcupado) # estrutura dos dados (missing etc)

dim(pessoalOcupado)

# Complete-case analysis – listwise deletion
dim(pessoalOcupadoCompleto <- na.omit(pessoalOcupado)) # deixa apenas os casos completos, nesse caso, restaram 3557 registros, o que corresponde a 63,6% da base.

# criando a matrix sombra
pessoalOcupado1 <- as.data.frame(abs(is.na(pessoalOcupado)))
head(pessoalOcupado1)

# deixando as variáveis com NA
pessoalOcupado1 <- pessoalOcupado1[which(sapply(pessoalOcupado1, sd) > 0)]
head(pessoalOcupado1)

# calculando correlações
round(cor(pessoalOcupado1), 3) # existem fortes associações entre as colunas, provavelmente os dados ausentes não são aleatórios, pode existir erro sistêmico

# # modificação já que vão temos uma base numérica
# pessoalOcupado1 <- cbind(pessoalOcupado1, Município = pessoalOcupado$Município) # trazemos uma variável de interesse (municípios) de volta pro frame
# pessoalOcupado1Mun <- pessoalOcupado1 %>% group_by(Município) %>% summarise(across(everything(), list(sum))) # sumarizamos e observamos se os NA se concentram nos municípios com mais casos

##### Compartilhe com a gente um código criado por você usando uma das técnicas de identificação de outliers, mas no lugar da variável casos, busque em uma das outras duas variáveis ajustadas (casos2 ou casosLog)

library(dplyr)
install.packages("plotly")
library(plotly)

# carregar dados covid19 Pernambuco
covid19PE <- fread('https://dados.seplag.pe.gov.br/apps/basegeral.csv')

covid19PEMun <- covid19PE %>% count(municipio, sort = T, name = 'casos') %>% mutate(casos2 = sqrt(casos), casosLog = log10(casos))

# teste de Rosner
install.packages('EnvStats')
library(EnvStats)
covid19PERosner <- rosnerTest(covid19PEMun$casosLog, k = 10)
covid19PERosner
covid19PERosner$all.stats # por esse teste foi identificado 4 outlier correspondendo as observações (188, 187, 1 e 186)

### Compartilhe com a gente um código criado por você usando uma técnica de imputação numérica e uma técnica de hot deck para substituir NA.

## imputação numérica

pessoalOcupadoDT <- pessoalOcupado %>% setDT() #copiar base pessoalOcupado, usando a data.table

# tendência central
install.packages("Hmisc")
library(Hmisc) # biblio que facilita imputação de tendência central
pessoalOcupadoDT1<-pessoalOcupadoDT
status(pessoalOcupadoDT1)
pessoalOcupadoDT1$X1970 <- impute(pessoalOcupadoDT1$X1970, fun = mean) # média
pessoalOcupadoDT1$X1975 <- impute(pessoalOcupadoDT1$X1975, fun = mean) # média
pessoalOcupadoDT1$X1980 <- impute(pessoalOcupadoDT1$X1980, fun = mean) # média
pessoalOcupadoDT1$X1985 <- impute(pessoalOcupadoDT1$X1985, fun = mean) # média
pessoalOcupadoDT1$X1995 <- impute(pessoalOcupadoDT1$X1995, fun = mean) # média


table(is.imputed(pessoalOcupadoDT1$X1975)) # tabela de imputação por sim / não

## Hot deck

# imputação por instâncias
install.packages("VIM")
library(VIM)
pessoalOcupadoDT3<-pessoalOcupadoDT
status(pessoalOcupadoDT3)
pessoalOcupadoDT3 <- kNN(pessoalOcupadoDT)
status(pessoalOcupadoDT3)
