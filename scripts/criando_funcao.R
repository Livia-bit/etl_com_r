# criando uma funcao para mostrar os divisores de x

divisores <- function(x)
{
  print( paste("divisores de", x) )
  for(i in 1:x)
  {
    if (x %% i == 0)
    {
      print (i)
    }
  }
}

divisores (23)
divisores (27)