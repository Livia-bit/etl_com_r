# utilizando um controle de repetição e condicional para mostrar os divisores de x

x <- 23
for(i in 1:x)
{
  if (x %% i == 0)
  {
    print (i)
  }
}

# utilizando controle condicional para saber se y é par

y <- 10

if (y %% 2 == 0)
{
    print("é par")
} else {
  print("é impar")
}