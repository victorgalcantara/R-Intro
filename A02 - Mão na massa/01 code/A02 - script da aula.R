# Nossa segunda aula de análise de dados com R
# Autor: Victor G Alcantara

# A primeira parte de um código deve ser sempre uma 
# identificação do que se trata e do(a) autor(a)

# Depois, fazemos o setup para configurar o ambiente de trabalho

# É importante ter o código bem organizado, para que seja de fácil
# interpretação para outras pessoas.

# Um macete na identação (organização) do código é entender que:

# 1 hashtag + no mínimo 4 hífens no final: define o título de uma seção

# Primeiro título ----

# 2 hashtags + no mínimo 4 hífens no final: define o subtítulo

# 3 hashtags + no mínimo 4 hífens no final: define o subsubtítulo

# 1. Setup ----

## Gestão da memória  ----

# Para listar objetos guardados na memória
ls()

# Para remover objetos
rm() # vc pode inserir o nome de um objeto que queira excluir, dentro da função

# Para remover todos os objetos de uma só vez
rm(list = ls())

# Limpeza da lixeira com Garbage Clean
gc()

## Gestão dos pacotes  ----

# Na gestão de pacotes, temos duas funções:

# install.packages : para instalar o pacote no computador 
# (necessário apenas na primeira vez)

# library : para carregar o pacote no ambiente de trabalho
# (necessário sempre que for usar o pacote no script)

#install.packages("tidyverse") # como já tenho instalado, deixei comentado para não executar
library(tidyverse)
library(rio)

# O pacote tidyverse é uma coleção de pacotes para análise de dados
# Para inspecionar um pacote (ver suas funções e usos), podemos recorrer ao Help:

# vamor inspecionar um dos pacotes do tidyverse, o dplyr

help(package = "dplyr")

# Observe que abrirá na janela "Help", inferior direita, uma documentação do pacote

# Você pode ver as funções disponíveis e clicar diretamente nelas para ver para que servem

## Gestão do diretório ----

# Aqui é bem importante. É onde definimos em qual pasta do nosso computador
# vamos definir como principal para trabalhar
# Working Directory (wd) : get e set

getwd() # saber qual pasta está trabalhando


# Definir a pasta de trabalho
# Para definir a pasta de trabalho, basta copiar o endereço da pasta do seu computador
# Você pode fazer isso copiando o caminho da busca, que aparece na parte superior da janela da pasta
# ou clickando com o botão direito e selecionando "copiar caminho"

setwd(" cole aqui o endereço da pasta com as barras '/' ") 

# Atenção para a direção das barras! Sempre "/"

# 2. Importando dados ----

# Se você definiu a pasta do curso como referência, a localização do arquivo abaixo vai funcionar
mydata <- import("000 - P&R/00 data/br_uf.csv")

# Uma alternativa é utilizar uma função que abre uma janela para você procurar o arquivo no computador
# essa alternativa facilita o caminho, mas não deixa o código automatizado

mydata <- import( file.choose() )

# Em algum lugar aparecerá uma janela para você procurar o arquivo para importar

# 3. Observando nossa base de dados ----

# A seguir, temos um conjunto de funções úteis para visualizar a estrutura do nosso dado

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
# Tudo fica mais simples

# Função select
mydata2 <- mydata %>% select(uf,indice_gini,prop_renda_40_pobres) 

# Função filter
mydata2 <- mydata2 %>% filter(indice_gini < 0.6) 

# Função rename
mydata2 <- mydata2 %>% rename(gini = indice_gini,
                              p_renda_40 = prop_renda_40_pobres) 

# Exportando dados com rio
export(mydata2,file = "000 - P&R/00 data/dado_exportado.xlsx")
