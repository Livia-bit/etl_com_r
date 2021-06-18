library(tidyverse)
# Compartilhe com a gente um código criado por você em que você junta duas bases por nomes não categorizados e, em seguida, realiza uma busca por determinados textos em uma das colunas. Atenção: a base de dados pode ser simulada! não precisa ser real.

AnoSerie <- c("Ninho", "Maternal", "Período 1", "Período 2", "Período 3", "Primeiro Ano", "Segundo Ano", " Terceiro Ano")
turno <- c("Manhã", "Manhã", "Manhã", "Manhã e Tarde", "Manhã e Tarde", "Tarde", "Tarde", "Tarde")
anuidade <- c(8762, 7860, 7860, 7860, 7860, 8027, 8027, 8027)
parcela <- c(736, 660, 660, 660, 660, 675, 675, 675)
condicao <- c("Desconto por antecipação","Desconto por antecipação","Sem desconto", "Sem desconto", "Sem desconto", "Bônus Família", "Bônus Família", "Bônus Família")

banco1 <- data.frame(AnoSerie, turno, anuidade, parcela, condicao)

AnoSerie <- c("Ninho.", "Maternall", "Período 01", "Período 2", "Período 3", "1º Ano", "Segundo Ano", " terceiro AnoO")
turno <- c("Manhã", "Manhã", "Manhã", "Manhã e Tarde", "Manhã e Tarde", "Tarde", "Tarde", "Tarde")

banco2 <- data.frame(AnoSerie, turno)

#juntando as bases por nomes não categorizados
banco3 <- fuzzyjoin::stringdist_join(banco1, banco2, mode='left')

#realizando uma busca de texto (dois exemplos)
doisTurnos <- c("Período 2", "Período 3")
banco4 <- banco1 %>% mutate(tag_turno = ifelse(grepl(paste(doisTurnos, collapse="|"), AnoSerie), 'integral', 'não integral'))

banco4 <- banco4 %>% mutate(podeTerDesconto = ifelse(grepl("Sem desconto", condicao), FALSE, TRUE))


### Compartilhe com a gente um código criado por você em que você carrega para o R um pdf que tenha alguma data; em seguida, troca as barras "/" das datas por hífens "-", e, por fim, faz a extração das datas usando esse novo padrão.

library(dplyr)
library(pdftools)
library(stringr)
library(textreadr)

planoAula <- read_pdf('documentos/Plano de Estatística e Econometria.pdf', ocr = T)

# agrupar páginas em 1 doc: 1) agrupa por id 2) cria nova coluna colando a coluna texto na mesma linha 3) seleciona apenas colunas de interesse 4) remove duplicata
planoAula2 <- planoAula %>% group_by(element_id) %>% mutate(textoCompleto = paste(text, collapse = " | ")) %>% select(element_id, textoCompleto) %>% unique()

planoAula2$textoConvertido <- str_replace_all(string = planoAula2$textoCompleto, pattern = "/", replacement = "-") # modifica um padrão # no caso, substituindo "/" por "-"

# extração das datas usando o novo padrão
( datas <- str_extract_all(planoAula2$textoConvertido, "\\d{2}-\\d{2}"))
