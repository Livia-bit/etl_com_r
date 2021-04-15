# Considerando a simulação feita anteriormente em que uma uti para Covid de um certo hospital está com ocupação de 60 leitos, com uma taxa de mortalidade diária de 20%, simulando agora o número de mortes em 100 dias.

numeroMortesCovidDistBinominal <- rbinom(100, 60, 0.2)
numeroMortesCovidDistBinominal

# acessando o número de mortes nos 30, 60, 90 e 100 dias usando indexação.
numeroMortesCovidDistBinominal[c(30, 60, 90, 100)]

# identificando os dias em que a taxa de mortalidade foi de 20% 

totalLeitos <- 60
percentualOcupacao <- (numeroMortesCovidDistBinominal/totalLeitos )*100
percentualOcupacao

round(percentualOcupacao,0)
which(percentualOcupacao == 20) # retorna a posição/linha da condição que foi verdadeira


