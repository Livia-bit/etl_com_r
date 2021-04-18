# aplicando a função apply

mtcars

mediaMarca <- function(marca)
{
  print(paste("Selecionando carros da marca",marca))
  
  posicoesCarros<-grep(marca, rownames(mtcars))
  print(posicoesCarros)
  carrosDaMarca <- mtcars[posicoesCarros, ]
  print("Carros Selecionados")
  print(carrosDaMarca)
  mediaMarcaCalculada <- apply(carrosDaMarca, 2, mean)
  print(paste("Media das variaveis dos carros da", marca, mediaMarcaCalculada))
}
mediaMarca("Toyota")

