# Título: A02 - Parte 2 - Depois do intervalo
# Autor: Victor G Alcantara
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
setwd("C:/Users/sn1101492/OneDrive/02 - GitHub/R-Intro/A02 - Mão na massa")

# Função para criar uma pasta dentro do diretório de trabalho
dir.create("00 data")

# Importando uma base de dados real ---------------------------------------

# Importando a nossa primeira base de dados
nse_escolas_brasileiras <- rio::import("00 data/CSV/NSE_ESCOLA.csv")

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


# Aula 03 -----------------------------------------------------------------

# Revisando manuseio de bases ---------------------------------------------

dados_exemplo_anna <- import("C:/Users/sn1101492/OneDrive/02 - GitHub/R-Intro/A03 - Mão na massa/00 data/exemplo_dados_anna.csv")

dados_exemplo_anna %>% select()

# Funções com tidyverse ---------------------------------------------------

names(nse_escolas_brasileiras)

mydata <- select(.data = nse_escolas_brasileiras,COD_ESCOLA,NSE)

# Usando o pipe
base_filtrada_com_tidyverse <- nse_escolas_brasileiras %>% 
  select(NOME_ESCOLA,NOME_UF,DEP_ADM,N_MATRICULAS,NSE) %>% 
  filter(NSE > 70, NOME_UF == "Minas Gerais")

dim(base_filtrada_com_tidyverse) == dim(base_nse_selecionada_e_filtrada)

nse_escolas_brasileiras %>% select(NOME_MUNIC,N_MATRICULAS) %>% filter(N_MATRICULAS > 1000)

# Renomeando a nossa base selecionada

mydata <- mydata %>% rename(CO_ENTIDADE = COD_ESCOLA)

# Utilizando mutate para fazer uma operação de transformação
mydata <- mydata %>% mutate( NSE10 = NSE / 10 )

# Baixando outra base de dados de escolas para praticar o join
censoescolar2024 <- import("C:/Users/sn1101492/MEC-Ministério da Educação/Team Channel - Painel PAR5/0_data/Censo Escolar/2024/dados/microdados_ed_basica_2024.csv",encoding = "Latin-1")

dim(censoescolar2024)

censoescolar2024 <- censoescolar2024 %>% select(CO_ENTIDADE,TP_DEPENDENCIA,QT_MAT_BAS,QT_MAT_PROF_TEC,QT_MAT_INF_INT,QT_MAT_FUND_INT,QT_MAT_MED_INT)

# Juntar as duas bases de dados cuja referência é a chave de identificação da escola

dim(mydata)
dim(censoescolar2024)

mydata <- merge(x = mydata, y = censoescolar2024, by = "CO_ENTIDADE",all.x = TRUE)

dim(mydata)

# Puxando mais informações das escolas
# pacote geobr do brverse
# https://github.com/ipeaGIT/brverse?tab=readme-ov-file
install.packages('geobr')
library(geobr)

escolas_geobr <- read_schools(year = 2023)
escolas_geobr <- escolas_geobr %>% rename(CO_ENTIDADE = code_school) %>% 
  select(CO_ENTIDADE,address,admin_category,government_level,geom)

mydata <- merge(x = mydata, y = escolas_geobr, by = "CO_ENTIDADE",all.x = TRUE)

# Recode
# recodificando categorias da nossa base de dados

table(mydata$government_level)

class(mydata)

mydata <- mydata %>% 
  mutate(
  nova_variavel_recodificada = 
    recode(government_level,
          "Estadual" = "Pública", 
          "Municipal"= "Pública",
          "Federal"  = "Pública",
          "Privada"  = "Privada") )

mydata <- mydata %>% 
  mutate(
    nivel_nse = 
      case_when(
        NSE10 < 3 ~ "Muito baixo",
        NSE10 >= 3 & NSE10 < 5 ~ "Baixo",
        NSE10 >= 5 & NSE10 < 6 ~ "Médio",
        NSE10 >= 6 & NSE10 < 6.5 ~ "Alto",
        NSE10 >= 6.5 ~ "Muito alto",
      )
    )

# Factor: um tipo de informação específica que une categorias com níveis ou ordem

mydata <- mydata %>% mutate(
  
  nivel_nse_ordenado = factor(nivel_nse,
                              levels = c("Muito Baixo","Baixo","Médio","Alto","Muito alto"),
                              ordered = TRUE )
)

# Typeof é uma função mais específica no reconhecimento do tipo de informação guardado vetor
typeof(mydata$nivel_nse_ordenado) # Ela identifica a ordem por trás das caterogias (número inteiro)
class(mydata$nivel_nse_ordenado) # Identifica o tipo específico do vetor

# Cut: é uma função auxiliar no mutate para criar uma nova variável usando pontos de corte

mydata <- mydata %>% mutate(
  grupo_nse_corte = cut(NSE10,
                    breaks = c(0,4,6,10),
                    labels = c("Baixo","Médio","Alto") )
)

# Função para agrupamento de casos com base em uma variável categórica

mydata %>% group_by(nivel_nse) %>% summarise( quantidade_escolas = n() )



# Retomando operações fundamentais ----------------------------------------


# Operações condicionais (IF ELSE) ----------------------------------------

# Se a condição é verificada (TRUE), o R executa o procetimento {}
if( 2 == 2 ) { print("O teste é verdadeiro") }

# Se a condição não é verificada, o R não executa o procedimento
if( 2 > 2 ) { print("O teste é verdadeiro") }

if( 2 > 2 ) { print("O teste é verdadeiro") } else { print("O teste é falso") }

ifelse( test = 2 > 2,yes = "O teste é verdadeiro",no =  "O teste é falso")

# Usando a operação condicional para fazer uma transformação na base de dados

mydata <- mydata %>% mutate(
  porte_escola = ifelse(test = QT_MAT_BAS > 1000, yes = "Grande", no = "Pequena")
)

# Operações com loops/iterativas ------------------------------------------

for( i in c(1:5)  ) { print(i) }
  
for( i in c(1:5)  ) { x = i + 2; print(x) }

# Exemplo imaginando se eu tivesse dados da pnad de 2021 a 2020
for( ano in c(2012:2020)  ) { minha_pnad <- import(  paste0("00 data/pnad_ano_",ano,".csv")  ) }

# Exemplo importando os dados da pnad série histórica

install.packages("PNADcIBGE")
library(PNADcIBGE)

dadosPNADc <- get_pnadc(year=2023, quarter=1,design = FALSE) 

??PNADcIBGE::get_pnadc

for( ano in 2012:2015  ) {
  
  if(ano == 2012){
  dadosPNADc_2012 <- get_pnadc(year = ano , quarter=1,design = FALSE) 
  } 
  
  else if(ano == 2013){
    dadosPNADc_2013 <- get_pnadc(year = ano , quarter=1,design = FALSE) 
  }

  else if(ano == 2014){
    dadosPNADc_2014 <- get_pnadc(year = ano , quarter=1,design = FALSE) 
  }
  
  else if(ano == 2015){
    dadosPNADc_2015 <- get_pnadc(year = ano , quarter=1,design = FALSE) 
  }
  
}

merge(x = dadosPNADc_2012, y = dadosPNADc_2015, by = "CPF")


  
  