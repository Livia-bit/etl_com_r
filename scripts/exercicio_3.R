# 1. Extraia a base geral de covid em Pernambuco disponível neste endereço: https://dados.seplag.pe.gov.br/apps/corona_dados.html
# 2. Corrija os NAs da coluna sintomas através de imputação randômica 
# 3. Calcule, para cada município do Estado, o total de casos confirmados e negativos
# 4. Crie uma variável binária se o sintoma inclui tosse ou não e calcule quantos casos confirmados e negativos tiveram tosse como sintoma
# 5. Agrupe os dados para o Estado, estime a média móvel de 7 dias de confirmados e negativos

#### 1. Extraindo
library(data.table)
library(tidyverse)
library(Hmisc)

covidPE <- read.csv2("bases_originais/basegeral.csv", header = TRUE, sep = ';', encoding = 'UTF-8')

covidPEDT <- covidPE %>% setDT() #copiar base covidPE, usando a data.table

# 2. Corrija os NAs da coluna sintomas através de imputação randômica 
### atribuindo NAs nos valores ausentes para corrigir
covidPEDT$sintomas <- ifelse(covidPEDT$sintomas=="", NA, covidPEDT$sintomas)
###corrigindo
(covidPEDT$sintomas <- impute(covidPEDT$sintomas, "random"))

# 3. Calcule, para cada município do Estado, o total de casos confirmados e negativos

casos <- c('CONFIRMADO', 'NEGATIVO')

totalCasos <- covidPEDT %>% select(municipio, classe) %>% group_by(municipio, classe) %>% count(classe) %>% filter (classe %in% casos) %>% pivot_wider(names_from = classe, values_from = n)

# 4. Crie uma variável binária se o sintoma inclui tosse ou não e calcule quantos casos confirmados e negativos tiveram tosse como sintoma

covidPEDT <- covidPEDT %>% mutate (Tosse = ifelse(grepl("TOSSE", sintomas), "sim", "não"))
tosse <- "sim"
casosSintomas <- covidPEDT %>% select(municipio, classe, Tosse) %>% group_by(municipio, classe, Tosse) %>% count(classe) %>% filter (classe %in% casos)%>% filter (Tosse %in% tosse) %>% pivot_wider(names_from = classe, values_from = n)

# 5. Agrupe os dados para o Estado, estime a média móvel de 7 dias de confirmados e negativos

totalCasos <- covidPEDT %>% select(classe, dt_notificacao) %>% group_by( classe, dt_notificacao) %>% count(classe) %>% filter (classe %in% casos) %>% pivot_wider(names_from = classe, values_from = n)

totalCasos<-as.data.frame(totalCasos)
mediaMovel <- totalCasos  %>% mutate(confirmadosMM7 = round(rollmean(x = CONFIRMADO,  7, align = "right", fill = NA), 2)) # média móvel de 7 dias

mediaMovel<- mediaMovel %>% arrange(dt_notificacao)
mediaMovel <- mediaMovel  %>% mutate(negativosMM7 = round(rollmean(x = NEGATIVO,  7, align = "right", fill = NA), 2)) # média móvel de 7 dias
