# Título: A02 - Parte 2 - Depois do intervalo

# Nosso primeiro setup ----

### Gestão da memória -------------------------------------------------------

# Listando objetos guardados na memória
ls()

# Removendo os objetos
rm()

# Estratégia para remover todos os objetos de uma vez
# a listagem de objetos entra como imput na função remove, e remove todos de uma vez
rm(list = ls())

# Garbage Clean: função que faz a limpeza da lixeira
gc()


### Gestão dos pacotes e das funções ----------------------------------------

install.packages("tidyverse") # Este é o pacote de referência para manuseio e análise de dados no R
library(tidyverse)

# R Imput Output
install.packages("rio") # Este é um pacote que facilita a nossa vida para importar e exportar dados
library(rio)

# Carregando um pacote no ambiente de trabalho
library(arrow) # Este pacote eu só carreguei como exemplo para removê-lo depois

# Descarregando/removento um pacote do ambiente de trabalho
detach("package:arrow", unload = TRUE)

install.packages("pacman") # Este é um pacote que nos ajuda a instalar e carregar outros pacotes em uma linha só
library(pacman)

p_load('tidyverse','rio')

# Gestão do diretório de trabalho -----------------------------------------

getwd() # Função para saber qual é o diretório de trabalho de referência

dir() # Lista os arquivos que estão no diretório

# Definindo uma pasta de referência para o projeto
setwd("C:/Users/victo/OneDrive/02 - GitHub/R-Intro/A02 - Mão na massa")

# Função para criar uma pasta dentro do diretório de trabalho
dir.create("00 data")

# Importando uma base de dados real ---------------------------------------

# Importando a nossa primeira base de dados
nse_escolas_brasileiras <- rio::import("00 data/NSE_ESCOLA.csv")

# Explorando outros argumentos da função import do pacote rio
??rio::import

nossa_base_criada_na_mao <- import('00 data/nossa_base_fictica.csv',delim = ";",encoding = 'Latin-1')  

# Funções do R Base para visualização e manuseio de bases de dados

dim(nse_escolas_brasileiras) # Dimensões da base de dados | Por definição LINHAS x COLUNAS [ L , C ]

names(nse_escolas_brasileiras) # Nome das colunas

head(nse_escolas_brasileiras) # Primeiras linhas

tail(nse_escolas_brasileiras) # Últimas linhas

str(nse_escolas_brasileiras) # Estrutura da base de dados

# Manuseando a base de dados com R base

# Selecionando variáveis de interesse
base_nse_selecionado <- nse_escolas_brasileiras[,c('NOME_ESCOLA','NOME_UF','DEP_ADM','N_MATRICULAS','NSE')]

# Filtrando a base 

# Filtro 1: NSE > 70
base_nse_selecionada_e_filtrada <- base_nse_selecionado[ base_nse_selecionado$NSE > 70 ,]

# Filtro 2: NOME_UF == 'MG'
base_nse_selecionada_e_filtrada <- base_nse_selecionada_e_filtrada[ base_nse_selecionada_e_filtrada$NOME_UF == 'Minas Gerais' ,]

# Renomeando nossas colunas
names(base_nse_selecionada_e_filtrada)[1] <- "Escola"

base_filtrada_com_tidyverse <- nse_escolas_brasileiras %>% 
  select(NOME_ESCOLA,NOME_UF,DEP_ADM,N_MATRICULAS,NSE) %>% 
  filter(NSE > 70, NOME_UF == "Minas Gerais")

dim(base_filtrada_com_tidyverse) == dim(base_nse_selecionada_e_filtrada)



  
  
