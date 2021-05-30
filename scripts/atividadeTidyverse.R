# Descoberta
# Compartilhe com a gente um código em que você implementa EDA sobre uma base diferentes daquela do exercício.

library(data.table)
library(dplyr)
library(tidyverse)
library(funModeling) 

# FONTE IPEADATA
# População residente - total

populacaoTotal <- read.csv2("C:/R/eletiva_de_dados/etl_com_r/bases_originais/populacaoResidenteTotalIpeaData.csv", encoding = "UTF-8", header = TRUE, skip = 1)

head(populacaoTotal) #verificando superficialmente se os dados foram importados corretamente
glimpse(populacaoTotal) # olhando melhor os dados

# limpeza parcial
populacaoTotal["X"]=NULL # apagando coluna X (erro decorrente do formato CSV errado do arquivo vindo do ipeadata, contém um ";" a mais no final de cada linha)

glimpse(populacaoTotal) # olhada nos dados (confirmando que o X foi removido)
status(populacaoTotal) # estrutura dos dados (missing etc)

# exploração dos valores da população ( dividi por 10.000, pq não vi sentido analisar frequencia diferenciando múnicípios por unidades, mas sim por múltiplos de 10.000 pessoas)
populacaoPor10000<-lapply(populacaoTotal[,c("X1996", "X2000", "X2007","X2010")], function(ano){return(round(ano/10000,0))})
lapply(populacaoPor10000, freq)
plot_num(data.frame(populacaoPor10000), bins = 10)
  
summary(data.frame(populacaoPor10000))

profiling_num(populacaoTotal) # estatísticas das variáveis numéricas

# Estruturação
# Compartilhe com a gente um código em que você implementa um pivô long to wide ou wide to long

# retirando Sigla e codigo
populacaoTotal<- populacaoTotal %>% select(Município, X1996, X2000, X2007, X2010)

# pivota o data frame de wide para long
#!Municipios - da base de dados manipule as outras colunas tirando a coluna Municipio
#names_to - nome da coluna a ser criada cujas linhas receberão o nome das colunas da base original
#names_prefix - remove  o texto do início do nome das colunas da base original 
#values_to - nome da coluna a ser criada que conterá os valores das celulas convertidas
populacaoTotalLong <- populacaoTotal %>% pivot_longer(!Município, names_to = "Ano", names_prefix="X",  values_to = "População")

# populacaoTotalLong <- populacaoTotal %>% pivot_longer(cols = c('X1996', 'X2000', 'X2007', 'X2010'), names_to = "Ano", names_prefix="X",  values_to = "População")

# Limpeza 
# Compartilhe com a gente uma ampliação do código desta aula, em que você remove os NA (not available) presentes nos dados

status(populacaoTotalLong)# Verificando que se há NA # existe cerca de 3% de NA

populacaoTotalLong %>% filter(População < 0 ) # Verificando se existe população negativa 
# não há

# para essa base de dados, não há sentido população NA e se transformasse o NA para 0 iria aparentar um aumento/diminuição de população inexistente (comparando com anos que não foram NA no mesmo município), logo a limpeza será feita filtrando apenas a população que não está como NA
populacaoTotalLong <- populacaoTotalLong %>% filter(!is.na(População))

status(populacaoTotalLong) # Verificando que limpou corretamente

# Enriquecimento
# Compartilhe com a gente uma aplicação de enriquecimento usando join em outra dupla de bases

# FONTE: IPEADATA
# PIB Municipal a preços constantes

pibMunicipal <- read.csv2("C:/R/eletiva_de_dados/etl_com_r/bases_originais/pibMunicipal.csv", encoding = "UTF-8", header = TRUE, skip = 1)

head(pibMunicipal) #verificando superficialmente se os dados foram importados corretamente
glimpse(pibMunicipal) # olhando melhor os dados

summary(pibMunicipal)

# exploração dos valores da PIB ( dividi por 1000, pq não vi sentido analisar frequencia diferenciando unidades (R$1.000,00), mas sim sentido analisar por R$1.000.000,00)

pibPor1000<-lapply(pibMunicipal[,c("X1996", "X2000", "X2007","X2010")], function(ano){return(round(ano/1000,0))})

summary(data.frame(pibPor1000))
#lapply(pibPor1000, freq) #não vi sentido ver a frequencia relativa, pois há municípios de pib anual entre cerca de 9 milhões até cerca de 26,5bilhões e muitas variações entre eles
plot_num(data.frame(pibPor1000), bins = 10)



#selecionando as colunas que tenho interesse
pibMunicipal <- pibMunicipal %>% select (Município, X1996, X2000, X2007, X2010)
#wide to long

pibMunicipalLong <- pibMunicipal %>% pivot_longer(!Município, names_to = "Ano", names_prefix="X",  values_to = "PIB")

status(pibMunicipalLong) # Verificando que se há NA # cerca de 3%

pibMunicipalLong %>% filter(PIB < 0 ) # Verificando se existe PIB negativo # não existe

#para essa base de dados, não há sentido população NA e se colocar como 0 iria aparentar um aumento do pib inexistente (comparando com anos que não foram NA no mesmo município)
pibMunicipalLong <- pibMunicipalLong %>% filter(!is.na(PIB))

status(pibMunicipalLong)#Verificando que limpou corretamente

basePopulacaoPIB = left_join(populacaoTotalLong, pibMunicipalLong, by = c("Município" = "Município", "Ano"= "Ano"))

glimpse(basePopulacaoPIB)

# validação
# Compartilhe com a gente uma aplicação de validação, com criação de regras pertinentes à base de dados que você estiver utilizando

#install.packages("validate")
library(validate)

#base completa, confirmando que está tudo ok com a base (anos dentro do intervalo desejado, população com valores positivos e não NA, PIB positivo e não NA )
regraPopulacaoPIBAno <- validator(Ano %in% c(1996, 2000, 2007, 2010), População >0, !is.na(População), PIB > 0, !is.na(PIB))

validacaoPopulacaoPIBAno <- confront(basePopulacaoPIB, regraPopulacaoPIBAno)

summary(validacaoPopulacaoPIBAno)

plot(validacaoPopulacaoPIBAno)

#confirmando se a base tem sentido (PIB ser influenciado pela população)
regressao <- lm(PIB ~ População, data=basePopulacaoPIB)
summary(regressao)
library(sjPlot)
plot_model(regressao)