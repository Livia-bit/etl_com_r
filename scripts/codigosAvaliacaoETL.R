library(readxl)
library(tidyverse)
library(data.table)
library(tidyverse)
library(Hmisc)
library(lubridate)

# 1. Extraia a base geral de covid em Pernambuco disponível neste endereço: https://dados.seplag.pe.gov.br/apps/corona_dados.html.
covidPE <- read.csv2("bases_originais/basegeral.csv", header = TRUE, sep = ';', encoding = 'UTF-8')

covidPEDT <- covidPE %>% setDT() #copiar base covidPE, usando a data.table

covidPEDT$municipio <- ifelse(covidPEDT$municipio=="IGUARACI", "IGUARACY", covidPEDT$municipio)#CORRIGINDO NOME DE IGUARACY Q HORA TEM Y E HORA TEM I


# 2. Calcule, para cada município do Estado, o total de casos confirmados e o total de óbitos por semana epidemiológica [atenção, você terá de criar uma variável de semana epidemiológica com base na data].

covidPEDT$dt_notificacao<-as.Date(covidPEDT$dt_notificacao, format = "%Y-%m-%d")
covidPEDT$dt_obito<-as.Date(covidPEDT$dt_obito, format = "%Y-%m-%d")

covidPEDT$classe <- as.factor(covidPEDT$classe)

covidPEDT<- covidPEDT %>% mutate( morreu = ifelse(is.na(covidPEDT$dt_obito), 0, 1)) %>% mutate(confirmado = ifelse(covidPEDT$classe=="CONFIRMADO", 1, 0)) %>% mutate(semanaEpidemiologicaNotificacao = epiweek(dt_notificacao)) %>% mutate (anoNotificacao = year(dt_notificacao))%>% mutate(semanaEpidemiologicaObitos = epiweek(dt_obito))%>% mutate(anoObitos = year(dt_obito))

baseNovaConfirmados <-covidPEDT %>% filter(confirmado==1 | morreu==1) %>% group_by(municipio,anoNotificacao,semanaEpidemiologicaNotificacao) %>% summarise(nConfirmados = sum(confirmado))

baseNovaObitos <-covidPEDT %>% filter(morreu==1 & confirmado==1) %>% group_by(municipio,anoObitos,semanaEpidemiologicaObitos) %>% summarise(nMortos = sum(morreu))

baseNova <- left_join(baseNovaConfirmados, baseNovaObitos, by = c('municipio' = 'municipio', 'anoNotificacao'='anoObitos', 'semanaEpidemiologicaNotificacao'='semanaEpidemiologicaObitos'))

# 3. Enriqueça a base criada no passo 2 com a população de cada município, usando a tabela6579 do sidra ibge.
populacao <- read_xlsx("bases_originais/tabela6579.xlsx", col_names = FALSE, skip=5)

colnames(populacao) <-c("municipio", "populacao")

populacao$municipioNovo<-str_to_upper(substring(populacao$municipio , 0,  last=nchar(populacao$municipio)-5))

populacao$estado<-substring(populacao$municipio , nchar(populacao$municipio)-2,  last=nchar(populacao$municipio)-1)

populacao<-populacao %>% filter(estado=="PE") %>% select(municipioNovo, populacao)

populacao$municipioNovo<- iconv(populacao$municipioNovo,from="UTF-8",to="ASCII//TRANSLIT")#RETIRANDO ACENTO E CARACTERES ESPECIAIS

populacao$municipioNovo <- ifelse(populacao$municipioNovo=="BELEM DO SAO FRANCISCO", "BELEM DE SAO FRANCISCO", populacao$municipioNovo)

populacao$municipioNovo <- ifelse(populacao$municipioNovo=="LAGOA DE ITAENGA", "LAGOA DO ITAENGA", populacao$municipioNovo)

(baseNova$municipio[!(baseNova$municipio %in% populacao$municipioNovo)])#CONFIRMANDO QUE TODOS OS MUNICÍPIOS TEM POPULAÇÃO CORRESPONDENTE NA OUTRA BASE

baseNovaEnriquecida <- left_join(baseNova, populacao, by = c('municipio' = 'municipioNovo'))

# 4. Calcule a incidência (casos por 100.000 habitantes) e letalidade (óbitos por 100.000 habitantes) por município a cada semana epidemiológica.

baseNovaEnriquecida$nConfirmadosPor100000 <- baseNovaEnriquecida$nConfirmados*100000/baseNovaEnriquecida$populacao

baseNovaEnriquecida$nMortosPor100000 <- baseNovaEnriquecida$nMortos*100000/baseNovaEnriquecida$populacao

summary(baseNovaEnriquecida)
