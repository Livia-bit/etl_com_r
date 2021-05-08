 
# Compartilhe com a gente um código em que você faz o scrap de alguma página, criando um data.frame. Lembre-se de compartilhar um link do github!!!

# arquivos html
library(rvest)
library(dplyr)

# tabela da wikipedia eleições 2018
url <- "https://pt.wikipedia.org/wiki/Elei%C3%A7%C3%A3o_presidencial_no_Brasil_em_2018"


urlTables <- url %>% read_html %>% html_nodes("table")
urlTables

eleicoes2018 <- as.data.frame(html_table(urlTables[10]))


#-----------------------------------------------------------------------------
# fazendo algumas modificações para organizar melhor o nome das colunas
eleicoes2018Melhorada <- eleicoes2018[c(-1,-2),]

colnames(eleicoes2018Melhorada) <- c("Candidato", "Vice", "Total (1º turno - 7 de outubro de 2018)", "Percentagem (1º turno - 7 de outubro de 2018)", "Total (2º turno - 28 de outubro de 2018)", "Percentagem (2º turno - 28 de outubro de 2018)")



saveRDS(eleicoes2018Melhorada, "bases_originais/eleicoes2018Melhorada.rds")