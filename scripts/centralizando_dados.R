# centralizando a coluna Sepal.Length da base de dados iris

head(iris)

# selecionando a coluna
iris$Sepal.Length

# vizualizando o histograma
hist(iris$Sepal.Length)

# para centralizar a coluna coluna Sepal.Length, vou reduzir a média dos valores dela

irisSepalCentral <- iris$Sepal.Length - mean(iris$Sepal.Length)

# visualizando a centralização por meio dos histogramas
hist(iris$Sepal.Length) 
hist(irisSepalCentral)

# para as outras colunas aplicaria a mesma técnica
irisPetalCentral <- iris$Petal.Length - mean(iris$Petal.Length)
hist(iris$Petal.Length)
hist(irisPetalCentral)

irisSepalWidthCentral <- iris$Sepal.Width - mean(iris$Sepal.Width)
hist(iris$Sepal.Width)
hist(irisSepalWidthCentral)

irisPetalWidthCentral <- iris$Petal.Width - mean(iris$Petal.Width)
hist(iris$Petal.Width)
hist(irisPetalWidthCentral)
