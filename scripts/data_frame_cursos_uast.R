# criando um data.frame com a lista dos cursos da UFRPE/UAST
# vetor com o nome dos cursos 

nomeCurso <- c("Administração", "Agronomia", "Ciências Econômicas", "Sistemas da Informação", "Engenharia de Pesca", "Licenciatura em Química")

# vetor com o turno

turno <- c("Noite", "Manhã", "Noite", "Noite", "Tarde", "Noite")

# vetor de vagas autorizadas

vagas <- c(40, 80, 50, 80, 45, 60)

# vetor com o número de professores por curso

numeroProfessores <- c(20, 30, 15, 17, 21, 18)

# vetor com a relação aluno por professor

alunoPorProfessor <- vagas/numeroProfessores

# data frame dos cursos da Uast

listaCursos <- data.frame(Curso = nomeCurso, Turno = turno, "Vagas SISU" = vagas, "Quantidades de Professores" = numeroProfessores,"Aluno por professor" = alunoPorProfessor)
           