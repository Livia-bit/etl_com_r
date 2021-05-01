########################################################################################
# ▶ Desta vez, indique uma vantagem e uma desvantagem de cada tipo de arquivo (nativo e plano com interoperabilidade) e acrescente no código uma forma adicional de exportação e de leitura, com a respectiva comparação usando a função microbenchmark. Lembre-se de compartilhar um link do github!!!

# Vantagem do arquivo nativo rds: a exportação e a leitura desse tipo de arquivo se torna mais rápida por ser binário, otimizado para velocidade e compressão de dados e, portanto, é mais eficiente em tamanho de armazenagem e execução comparado com o do tipo interoperável (cvs)

# Desvantagem do arquivo nativo rds: Não é comum a outros programas o que dificultaria sua leitura por eles, além de por ser binário não tem fácil leitura por humanos.

# Vantagem do arquivo interoperável csv: esse tipo de arquivo tem formato comum a vários programas, os dados podem ser utilizados por eles, várias linguagens de programação conseguem ler ou tem bibliotecas que permitem sua leitura, além de, normalmente, serem legíveis por humanos.

# desvantagem: é computacionamente menos eficiente e a base de dados ocupa mais espaço.

#########
install.packages("microbenchmark")

library(microbenchmark)

# exporta em formato nativo do R
saveRDS(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.rds")

# exporta em formato tabular (.csv) - padrão para interoperabilidade
write.csv2(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.csv")

# carrega base de dados em formato nativo R
sinistrosRecife <- readRDS('bases_tratadas/sinistrosRecife.rds')

# carrega base de dados em formato tabular (.csv) - padrão para interoperabilidade
sinistrosRecife <- read.csv2('bases_tratadas/sinistrosRecife.csv', sep = ';')


install.packages("writexl")
  library(writexl)

install.packages("readxl")
library(readxl)

# exporta em formato xlsx 
write_xlsx(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.xlsx")

# carrega base de dados em formato xlsx 
sinistrosRecife <- read_xlsx('bases_tratadas/sinistrosRecife.xlsx')

install.packages("haven")
library(haven)

# exportar em formato .dta para STATA
write_dta(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.dta")

# carrega base de dados em formato .dta 
sinistrosRecife <- read_dta('bases_tratadas/sinistrosRecife.dta')

# compara os quatro processos de exportação, usando a função microbenchmark

microbenchmark(a <- saveRDS(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.rds"), b <- write.csv2(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.csv"), c <- write_xlsx(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.xlsx"), d <- write_dta(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.dta"), times = 10L)

microbenchmark(a <- readRDS('bases_tratadas/sinistrosRecife.rds'), b <- read.csv2('bases_tratadas/sinistrosRecife.csv', sep = ';'), c <- read_xlsx('bases_tratadas/sinistrosRecife.xlsx'), d <- read_dta('bases_tratadas/sinistrosRecife.dta'), times = 10L)

# Quanto ao menor tempo médio de execução, entre as funções das bibliotecas usadas para salvar, a função usada para o formato .dta foi mais eficiente. Já para a leitura a função usada para o .rds foi mais eficiente.

# Quanto ao menor tamanho da base de dados, o formato .rds foi o melhor.
