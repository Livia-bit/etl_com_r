# Criem um objeto próprio de data e tempo, convertam pros três formatos de data e tempo, e façam pelo menos 3 extrações de componentes e/ou operações.

#criando uma tabela com um vetor de data e tempo
pessoas <- data.frame(
  nome = c("joão","maria","jose"),
  dataNascimento = c("1984-06-07 12:00", "1986-12-10 7:00","2018-08-20 18:37"),
  peso = c(78, 50, 12)
)

# convertendo o vetor para data
(str(datas1 <-as.Date(pessoas$dataNascimento)))

# convertendo o vetor para POSIXct (formato de segundos)
(str(datas2 <- as.POSIXct(pessoas$dataNascimento))) 
unclass(datas2) # observamos o POSIXct no formato original (segundos)

# Conversão o vetor para POSIXlt
(str(datas3 <- as.POSIXlt(pessoas$dataNascimento)))
unclass(datas3) # observamos o POSIXlt no formato original (componentes de tempo)

library(lubridate)

#extraindo componente
year(datas1)
month(datas1, label = T)
wday(datas1, label = T, abbr = T)

#operações
(paste("Seu aniversário de 3 anos é em:", datas1[3] + years(3)))
 
###
# Nos vídeos, vocês viram o exemplo com casos totais e novos casos. Agora, o desafio de vocês é replicar isso com outra variável da base.

url = 'https://raw.githubusercontent.com/wcota/covid19br/master/cases-brazil-states.csv' # passar a url para um objeto
covidBR = read.csv2(url, encoding='latin1', sep = ',') # baixar a base de covidBR

covidPE <- subset(covidBR, state == 'PE') # filtrar para Pernambuco

str(covidPE) # observar as classes dos dados

covidPE$date <- as.Date(covidPE$date, format = "%Y-%m-%d") # modificar a coluna data de string para date

str(covidPE) # observar a mudança na classe

covidPE$dia <- seq(1:length(covidPE$date)) # criar um sequencial de dias de acordo com o total de datas para a predição

predDia = data.frame(dia = covidPE$dia) # criar vetor auxiliar de predição
predSeq = data.frame(dia = seq(max(covidPE$dia)+1, max(covidPE$dia)+180)) # criar segundo vetor auxiliar 

predDia <- rbind(predDia, predSeq) # juntar os dois 

install.packages("drc")
library(drc) # pacote para predição

fitLL <- drm(deaths ~ dia, fct = LL2.5(),
             data = covidPE, robust = 'mean') # fazendo a predição log-log com a função drm

plot(fitLL, log="", main = "Log logistic") # observando o ajuste

predLL <- data.frame(predicao = ceiling(predict(fitLL, predDia))) # usando o modelo para prever para frente, com base no vetor predDia
predLL$data <- seq.Date(as.Date('2020-03-12'), by = 'day', length.out = length(predDia$dia)) # criando uma sequência de datas para corresponder aos dias extras na base de predição

predLL <- merge(predLL, covidPE, by.x ='data', by.y = 'date', all.x = T) # juntando as informações observadas da base original 
install.packages("plotly")

library(plotly) # biblioteca para visualização interativa de dados

###alterando a variável casos para a variável mortes

plot_ly(predLL) %>% add_trace(x = ~data, y = ~predicao, type = 'scatter', mode = 'lines', name = "Mortes - Predição") %>% add_trace(x = ~data, y = ~deaths, name = "Mortes - Observadas", mode = 'lines') %>% layout(
  title = 'Predição de Mortes de COVID 19 em Pernambuco', 
  xaxis = list(title = 'Data', showgrid = FALSE), 
  yaxis = list(title = 'Mortes Acumuladas por Dia', showgrid = FALSE),
  hovermode = "compare") # plotando tudo junto, para comparação

library(zoo) # biblioteca para manipulação de datas e séries temporais

covidPE <- covidPE %>% mutate(newDeathsMM7 = round(rollmean(x = newDeaths, 7, align = "right", fill = NA), 2)) # média móvel de 7 dias

covidPE <- covidPE %>% mutate(newDeathsL7 = dplyr::lag(newDeaths, 7)) # valor defasado em 7 dias

plot_ly(covidPE) %>% add_trace(x = ~date, y = ~newDeaths, type = 'scatter', mode = 'lines', name = "Novas Mortes") %>% add_trace(x = ~date, y = ~newDeathsMM7, name = "Novas Mortes MM7", mode = 'lines') %>% layout(
  title = 'Novas Mortes de COVID19 em Pernambuco', 
  xaxis = list(title = 'Data', showgrid = FALSE), 
  yaxis = list(title = 'Novas Mortes por Dia', showgrid = FALSE),
  hovermode = "compare") # plotando tudo junto, para comparação

install.packages("xts")
library(xts)

(covidPETS <- xts(covidPE$newDeaths, covidPE$date)) # transformar em ST
str(covidPETS)

autoplot(covidPETS)
acf(covidPETS)
