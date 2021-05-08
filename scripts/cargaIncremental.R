# Compartilhe com a gente um código criado por você utilizando um dos três métodos em um conjunto de dados diferente daquele do exercício. Lembre-se de compartilhar um link do github!!!

# carrega base de dados original
vacinados <- read.csv2('http://dados.recife.pe.gov.br/dataset/f381d9ea-4839-44a6-b4fe-788239189900/resource/966e9c4c-df45-40d7-9c58-2f13c61a6d28/download/vacinados.csv', sep = ';', encoding = 'UTF-8')

# código usado para testar preliminarmente no primeiro momento que baixei a base: removendo o elemento 4
# vacinadosAntigos <- vacinados
# vacinadosAntigos <- vacinadosAntigos[-4,]

# carrega base de dados para atualização
vacinadosNovos <- read.csv2('http://dados.recife.pe.gov.br/dataset/f381d9ea-4839-44a6-b4fe-788239189900/resource/966e9c4c-df45-40d7-9c58-2f13c61a6d28/download/vacinados.csv', sep = ';', encoding = 'UTF-8')

library(dplyr)
teste <- vacinadosNovos %>% group_by(cpf, nome) %>% tally(sort = TRUE)

# por esse código acima associado a visualização da base verificou-se que há registos de pessoas com mesmo nome e parte de cpf tomando mais de duas doses, logo isso causa problemas, pois a chave substituta natural seria cpf,nome e dose, porém esses registros duplicados impedem seu objetivo (identificar uma linha), vericou-se que somente usando todas as colunas conseguiu-se identificar unicamente cada linha. Percebeu-se, também, que há registros removidos em novas versões da base (possíveis correções).


# compara usando a chave substituta (usando todas as colunas conforme o comentário acima)(margin se refere a linhas se for 1)
# criar a chave substituta
vacinadosAntigos$chaveSubstituta = apply(vacinadosAntigos[, c(1,2,3,4,5,6,7,8)], MARGIN = 1, FUN = function(i) paste(i, collapse = ""))

vacinadosNovos$chaveSubstituta = apply(vacinadosNovos[, c(1,2,3,4,5,6,7,8)], MARGIN = 1, FUN = function(i) paste(i, collapse = ""))

# compara usando a chave substituta
VacinadosAdicionados <- (!vacinadosNovos$chaveSubstituta %in% vacinadosAntigos$chaveSubstituta)

#QNT ADICIONADOS
nrow(vacinadosNovos[VacinadosAdicionados,])

# procurando os removidos
vacinadosRemovidos <- (!vacinadosAntigos$chaveSubstituta %in% vacinadosNovos$chaveSubstituta)

#QNT REMOVIDOS
nrow(vacinadosAntigos[vacinadosRemovidos,])

#valores mantidos
vacinadosMantidos <- (vacinadosAntigos$chaveSubstituta %in% vacinadosNovos$chaveSubstituta)

#removendo removidos
vacinadosAntigos <- vacinadosAntigos[vacinadosMantidos,]

# junta base original e incremento
vacinadosFinal <- rbind(vacinadosAntigos, 
                        vacinadosNovos[VacinadosAdicionados,])

saveRDS(vacinadosAntigos, "bases_tratadas/vacinadosAntigos.rds")
saveRDS(vacinadosNovos, "bases_tratadas/vacinadosNovos.rds")
saveRDS(vacinadosFinal, "bases_tratadas/vacinadosFinal.rds")