
# Compartilhe com a gente um código criado por você extraindo dados de pelos menos 3 dessas 5 fontes. Lembre-se de compartilhar um link do github!!!
# Busque as bases de dados nos repositórios que já conhecemos

# extrair / carregar arquivos texto

# arquivos .data com read.table

mpgAuto <- read.table(file = "https://archive.ics.uci.edu/ml/machine-learning-databases/auto-mpg/auto-mpg.data", header = FALSE, sep = '', dec = '.', col.names	= c('mpg', 'cylinders', 'displacement', 'horsepower', 'weight', 'acceleration', 'model year', 'origin', 'car name')
)

# arquivos .csv com read.csv2
vacinados <- read.csv2('http://dados.recife.pe.gov.br/dataset/f381d9ea-4839-44a6-b4fe-788239189900/resource/966e9c4c-df45-40d7-9c58-2f13c61a6d28/download/vacinados.csv', sep = ';', encoding = 'UTF-8')

# arquivos .xml
install.packages('XML')
library(XML)

leilaoEbay <- xmlToDataFrame("http://aiweb.cs.washington.edu/research/projects/xmltk/xmldata/data/auctions/ebay.xml")

saveRDS(vacinados, "bases_originais/vacinados.rds")
write.csv2(vacinados, "bases_originais/vacinados.csv")

