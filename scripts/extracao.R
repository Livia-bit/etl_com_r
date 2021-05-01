#### Staging area e uso de memória

########################################################################################

# Desta vez, mostre que você entendeu o conceito de área intermediária e ambiente no R, modificando o código para manter sinistrosRecifeRaw e a função naZero (ela pode ser útil no futuro!). Além disso, indique qual dos objetos na área intermediária mais estavam usando memória do R. Lembre-se de compartilhar um link do github!!!

ls() # lista todos os objetos no R

# vamos ver quanto cada objeto está ocupando

for (itm in ls()) { 
  print(formatC(c(itm, object.size(get(itm))), 
                format="d", 
                width=30), 
        quote=F)
}

# [1]                              a                        6456296
# [1]                              b                        6328392
# [1]                              c                        7011840
# [1]                              d                        7347224
# [1]                            itm                            112
# [1]                         naZero                          13336
# [1]                sinistrosRecife                        7347224
# [1]         sinistrosRecife2019Raw                        5851088
# [1]        sinistrosRecife2019Raw1                        4588368
# [1]         sinistrosRecife2020Raw                        1891328
# [1]         sinistrosRecife2021Raw                         142248
# [1]             sinistrosRecifeRaw                        6456296
## Os objetos que mais estavam ocupando memória eram: a base sinistrosRecife e d (7347224)

#caso quisesse achar o maior objeto (desconsiderando empates), poderia usar esse código abaixo

tamanhoMaiorObjeto <- 0
for (i in ls())
{
  if (object.size(get(i)) > tamanhoMaiorObjeto )
  {
    tamanhoMaiorObjeto <- object.size(get(i))
    nomeMaiorObjeto <- i
  }
}
if (tamanhoMaiorObjeto > 0)
  print(formatC(c(nomeMaiorObjeto, tamanhoMaiorObjeto), format="d", width=30), quote=F)

# agora, vamos remover

gc() # uso explícito do garbage collector

# deletando todos os elementos, menos os listados: 
rm(list=(ls() [ls()!="sinistrosRecifeRaw" & ls()!="naZero"]))


saveRDS(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.rds")

write.csv2(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.csv")
