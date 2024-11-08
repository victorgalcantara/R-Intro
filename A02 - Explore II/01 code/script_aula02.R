# Nossa segunda aula de análise de dados com R
# Autor: Victor G Alcantara

# 1. Setup ----

## Gestão da memória  ----

# Para listar objetos guardados na memória
ls()

# Para remover objetos
rm(esc)

# Para remover todos os objetos de uma só vez
rm(list = ls())

# Limpeza da lixeira com Garbage Clean
gc()

## Gestão dos pacotes  ----

#install.packages("tidyverse")
library(tidyverse)
library(rio)

## Gestão do diretório ----

getwd()
setwd("G:/Meu Drive/02 - GitHub/R-Intro")

# Atenção para a direção das barras!

# 2. Importando dados ----

mydata <- import("000 - P&R/00 data/br_uf.csv")

# 3. Observando nossa base de dados ----

dim(mydata) # retorna as dimensões da base de dados (linhas x colunas)

names(mydata) # retorna o nome das colunas/variáveis

head(mydata) # retorna os primeiros valores da base de dados (default = 5, maspassível de alteração) 

tail(mydata) # retorna os últimos valores da base de dados (default = 5, mas passível de alteração) 

str(mydata) # retorna a estrutura da base de dados, indicando as dimensões e o  tipo de cada variáve

# 4. Manuseando dados ----

# Selecionando variáveis da base dados
uf <- mydata[,"sigla_uf"]
uf

mydata2 <- mydata[,c("sigla_uf","indice_gini","populacao")]
mydata2 <- mydata[,c(1,9)]

# Filtrando a base de dados
filtro <- mydata[,"taxa_superior_25_mais"] >= 10
filtro

mydata3 <- mydata[filtro,c("sigla_uf","taxa_superior_25_mais")]

# Renomeando variáveis
colnames(mydata)[1] <- "uf"

colnames(mydata)[c(1:3)] <- c("uf","pop","pop_urb")

# Fazendo todas as operações usando o tidyverse

# Função select
mydata2 <- mydata %>% select(uf,pop,indice_gini,expectativa_vida,taxa_superior_25_mais) 

# Função filter
mydata2 <- mydata2 %>% filter(taxa_superior_25_mais >= 10) 

# Função rename
mydata2 <- mydata2 %>% rename(gini = indice_gini) 

# Exportando dados com rio
export(mydata2,file = "000 - P&R/00 data/dados_aula02.xlsx")
