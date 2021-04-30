# carrega a base de sinistros de transito do site da PCR
sinistrosRecife2020Raw <- read.csv2('http://dados.recife.pe.gov.br/dataset/44087d2d-73b5-4ab3-9bd8-78da7436eed1/resource/fc1c8460-0406-4fff-b51a-e79205d1f1ab/download/acidentes_2020-novo.csv', sep = ';', encoding = 'UTF-8')

sinistrosRecife2021Raw <- read.csv2('http://dados.recife.pe.gov.br/dataset/44087d2d-73b5-4ab3-9bd8-78da7436eed1/resource/2caa8f41-ccd9-4ea5-906d-f66017d6e107/download/acidentes_2021-jan.csv', sep = ';', encoding = 'UTF-8')

##########################################################################################
# Desta vez, queremos que você mostre que entendeu o processo de ETL modificando um pouco a extração e o tratamento. Ou seja: adicione mais ano de acidentes de trânsito à extração e lembre-se de uni-lo aos demais com o rbind; depois, busque mais ou coluna para transformar em fator e acrescente isso ao código. Lembre-se de compartilhar um link do github!!!

# carregando a base de sinistros de transito do site da PCR para o ano de 2019
sinistrosRecife2019Raw <- read.csv2('http://dados.recife.pe.gov.br/dataset/44087d2d-73b5-4ab3-9bd8-78da7436eed1/resource/3531bafe-d47d-415e-b154-a881081ac76c/download/acidentes-2019', sep = ';', encoding = 'UTF-8')

# verificando as variáveis
print(colnames(sinistrosRecife2019Raw))
print(colnames(sinistrosRecifeRaw))

# renomeando a base original
sinistrosRecife2019Raw1 <- sinistrosRecife2019Raw

#removendo colunas "numero_cruzamento", "referencia_cruzamento" e "endereco_cruzamento" usando indexador ou (atribuindo nulo a elas) para deixar apenas as mesmas variáveis dos outros anos

sinistrosRecife2019Raw1 <- sinistrosRecife2019Raw[,c(1:9, 13:41)]
View(sinistrosRecife2019Raw1)

# OU

sinistrosRecife2019Raw1$numero_cruzamento<-NULL
sinistrosRecife2019Raw1$referencia_cruzamento<-NULL
sinistrosRecife2019Raw1$endereco_cruzamento<-NULL

#renomeando "DATA" de 2019 para "data"
names(sinistrosRecife2019Raw1)[1] <- "data"
colnames(sinistrosRecife2019Raw1)[1]

# juntando as bases de dados com comando rbind (por linhas)

sinistrosRecifeRaw <- rbind(sinistrosRecife2019Raw1, sinistrosRecife2020Raw, sinistrosRecife2021Raw)

# observando a estrutura dos dados
str(sinistrosRecifeRaw)

# modificando a data para formato date
sinistrosRecifeRaw$data <- as.Date(sinistrosRecifeRaw$data, format = "%Y-%m-%d")


# modificando outras variáveis em texto para fator
sinistrosRecifeRaw[, c(3:5, 10)] <- lapply(sinistrosRecifeRaw[, c(3:5, 10)], as.factor)


# repetindo a função para substituir not available (na) por 0
naZero <- function(x) {
  x <- ifelse(is.na(x), 0, x)
}

# aplica a função naZero a todas as colunas de contagem
sinistrosRecifeRaw[, 15:25] <- sapply(sinistrosRecifeRaw[, 15:25], naZero)

# exporta em formato nativo do R
saveRDS(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.rds")

# exporta em formato tabular (.csv) - padrão para interoperabilidade
write.csv2(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.csv")


