# Desafio ----

# 1. Crie três objetos que guardam vetores com valores 
# de tipos diferentes (numérico, caracteres e lógicos)

#primeiro_vetor_númerico

primeiro_vetor_númerico <- c(1,2,3,4)

#primeiro_vetor_caracteres<-c("Adalberto","Bruno","Carlos","Dida")

primeiro_vetor_caracteres<-c("Adalberto","Bruno","Carlos","Dida")

#primeiro_vetor_lógicos

primeiro_vetor_logicos <-c(T,F,T,F)

# 2. Verifique se os vetores têm a mesma quantidade de valores

#Ok, possuem

# 3. Crie um data.frame/base de dados com os vetores

nossa_base_dados <-data.frame(primeiro_vetor_númerico,primeiro_vetor_caracteres,primeiro_vetor_logicos)

# 4. Localize o valor guardado na posição:
# seus_dados[2,1] : segunda linha e terceira coluna

nossa_base_dados [2,1]

# 5. Faça um teste lógico para verificar se o primeiro valor do vetor
# numérico é maior ou igual ao último valor do vetor numérico da sua
# base de dados

ifelse(test = 1>4,yes = "verdade", no="mentira") 
