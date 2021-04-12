# criação de um objeto simples (vetor de caracteres)
vogais <-c("a","e","i","o","u")
vogais

# criação de um objeto complexo 
#(testando se existe uma correlação significativa entre o peso do carro e o galão por milha
correlacaoCarros <-cor.test(formula = ~ wt + mpg,
                            data = mtcars)
correlacaoCarros         
str(correlacaoCarros)
