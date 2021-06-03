# Dplyr
# Compartilhe com a gente um código criado por você com a aplicação de pelo menos um sumário, um agrupamento, uma manipulação de casos e uma manipulação de colunas.

sinistrosRecife2019Raw <- readRDS("C:/R/eletiva_de_dados/etl_com_r/bases_originais/sinistrosRecife2019Raw.rds")

library(dplyr)

# sumário
count(sinistrosRecife2019Raw, tipo) 

# sumário com agrupamento
sinistrosRecife2019Raw %>% group_by(tipo) %>% summarise(avg = mean(vitimas, na.rm = T))

# manipulação de casos
# ordenar casos
arrange(sinistrosRecife2019Raw, vitimas) # ascendente
#filtar acidentes com mais de 5 vitimas
filter(sinistrosRecife2019Raw, vitimas>5)

# manipulação de colunas
(sinistrosRecife2019Raw %>% rename(mortes = vitimasfatais))$mortes
