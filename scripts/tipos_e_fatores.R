# Tipos e Fatores
# Compartilhe com a gente um código em que vocês cria uma estrutura de fatores.

estadoCivil <- c(2, 1, 4, 1, 3, 3, 4, 1, 2, 2, 0, 1, 1, 0)
recode <- c(solteiro = 1, casado = 2, viúvo = 3, divorciado = 4)
(estadoCivil <- factor(estadoCivil, levels = recode, labels = names(recode)))

