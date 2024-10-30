# Title : exercícios for e if/else
# Author: Victor Gabriel Alcantara 
# Github: https://github.com/victorgalcantara 
# LinkedIn: https://www.linkedin.com/in/victorgalcantara/ 

# Clean memory
rm(list=ls())
gc()

# Parte 1 - exercitando a função -----------------------------------------------

# Ex 1 ----

# Imprima na sua tela os nomes indexados nas posições 3 à 5 (Ricardo, Roberto e Vinícius)

# considere:
nomes <- c("João","Ana","Ricardo","Roberto","Vinicius","Carla","Mauro")

for(i in 3:5) { print(nomes[i]) }

# Ex 2 ----

# Crie um vetor com 10 valores, começando pelo 1 e cujo próximo será sempre a 
# múltiplicação do anterior por 3.

# 1 * 3, 3 * 3, 9 * 3, 27 * 3 ... e assim por diante.

# Utilize for ( i in 1:10 ){ expressão }

x <- 1
for( i in 1:10 ) { x[i+1] = x[i]*3 }
x

# Parte 2 - desafio ------------------------------------------------------------

# importe os dados da pnadc do Estado de São Paulo

pnadc_sp <- import("../1_data/pnadc_sp_2021.csv")

# compute tabelas de frequência para as variáveis categóricas indicadas abaixo:
# sexo, raça e classeOcup2

vars <- c('sexo','raca','classeOcup2')

tabs <- list()
for(i in 1:3){
tabs[[i]] <-  table(pnadc_sp[,vars[i]])
}
