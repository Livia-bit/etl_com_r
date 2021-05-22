# O segundo exercício tem por base o que aprendemos sobre ETL e large data. 
# 1. Extraia em padrão ff todas as bases de situação final de alunos disponíveis neste endereço: http://dados.recife.pe.gov.br/dataset/situacao-final-dos-alunos-por-periodo-letivo
# 2. Junte todas as bases extraídas em um único objeto ff
# 3. Limpe sua staging area
# 4. Exporte a base única em formato nativo do R
# 
# Compartilhe com a gente o seu endereço de github com o código do exercícicio!!!

## 1. Extraindo em padrão ff todas as bases de situação final de alunos do site da PCR

library(ff)
install.packages("ffbase")
library(ffbase)

resultadoFinalAlunos2011 <- read.csv2.ffdf(file='bases_originais/situacaofinalalunos2011.csv')

resultadoFinalAlunos2012 <- read.csv2.ffdf(file='bases_originais/situacaofinalalunos2012.csv')

resultadoFinalAlunos2013 <- read.csv2.ffdf(file='bases_originais/situacaofinalalunos2013.csv')

resultadoFinalAlunos2014 <- read.csv2.ffdf(file='bases_originais/situacaofinalalunos2014.csv')

resultadoFinalAlunos2015 <- read.csv2.ffdf(file='bases_originais/situacaofinalalunos2015.csv')

resultadoFinalAlunos2016 <- read.csv2.ffdf(file='bases_originais/situacaofinalalunos2016.csv')

resultadoFinalAlunos2017 <- read.csv2.ffdf(file='bases_originais/situacaofinalalunos2017.csv')

resultadoFinalAlunos2018 <- read.csv2.ffdf(file='bases_originais/situacaofinalalunos2018.csv')

resultadoFinalAlunos2019 <- read.csv2.ffdf(file='bases_originais/situacaofinalalunos2019.csv')

resultadoFinalAlunos2020 <- read.csv2.ffdf(file='bases_originais/situacaofinalalunos2020.csv')

# 2. Juntanto todas as bases extraídas em um único objeto ff com a função ffdfrbind.fill (junta bases semelhantes forçando preenchimento)

resultadoFinalAlunosMerge <- ffdfrbind.fill(resultadoFinalAlunos2011, resultadoFinalAlunos2012, resultadoFinalAlunos2013, resultadoFinalAlunos2014, resultadoFinalAlunos2015, resultadoFinalAlunos2016, resultadoFinalAlunos2017, resultadoFinalAlunos2018, resultadoFinalAlunos2019, resultadoFinalAlunos2020) 

length(resultadoFinalAlunosMerge$nescolnome)
length(resultadoFinalAlunos2012$nescolnome)
length(resultadoFinalAlunos2011$nescolnome)

# 3. Limpando a staging area

# deletando todos os elementos, menos os listados: 
rm(list=(ls() [ls()!="resultadoFinalAlunosMerge"]))

# 4. Exportando a base única (resultadoFinalAlunosMerge) em formato nativo do R

saveRDS(resultadoFinalAlunosMerge, "bases_originais/resultadoFinalAlunosMerge.rds")
head(resultadoFinalAlunosMerge)
tail(resultadoFinalAlunosMerge)
