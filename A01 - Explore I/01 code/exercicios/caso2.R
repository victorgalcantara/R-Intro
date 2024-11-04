# Autor Francisco Alves Almeida
# Desafio da primeira aula

vetor_numeros <- c(5,2,3,4,5,1)
vetor_numeros
vetor_caracteres = c("a","b","c","d","e","f")
vetor_caracteres
vetor_logico = c(T, F, F, T, F, T)
vetor_logico

estrutura = data.frame(vetor_numeros, vetor_caracteres, vetor_logico)

estrutura[1,1]
estrutura[6,1]

if(estrutura[1,1] >= estrutura[6,1])
  print("O valor é maior ou igual")
