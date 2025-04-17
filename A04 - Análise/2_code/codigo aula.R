# Aula 04 - Analisando dados
# Autor: Victor G Alcantara

# Iniciando com relações condicionais

if( 2 > 0 ) { print("Dois é maior que zero") }

if( 2 > 0 & 2 == 0 ) { print("Dois é maior que zero") }

if( 2 == 0 ) { print("Dois é igual a zero") } else{ 
  print("Dois não é igual a zero") }

ifelse(test = 2 > 0,
       yes = "Dois maior",
       no = "Dois menor")

# Setup ----

# Removendo notação científica
options(scipen=999)

# Limpeza da memória local
rm(list = ls())
gc()

# Pacotes
library(rio)
library(tidyverse)

# Definir o diretório de trabalho
setwd("G:/Meu Drive/02 - GitHub/R-Intro/A02 - Explore II/0 - data/")
getwd()

# Importando dados ----

meus.dados <- import("mydata.RDS")

# Criar uma variável dummy usando ifelse

meus.dados2 <- meus.dados %>% mutate(.,
                                     exemplo_dummy = ifelse(gini > 0.6,
                                                            yes = "Muito desigual",
                                                            no = "Desigual")
                                     )

# Observando a estrutura de uma matriz

minha.matriz <- matrix(data = 1:10, nrow = 5, ncol = 2,byrow = F)
minha.matriz

minha.matriz * 2

# Observando a estrutura de uma lista

minha.lista <- list(matriz = minha.matriz,
     base_dados = meus.dados2,
     vetor1 = 1:10,
     valor1 = "x"
     )

minha.lista[[2]][,"rpct"]

minha.lista[[4]]

# Análise Exploratória de dados
# Estatística descritiva

# Variáveis métricas

var_metrica_continua <- c(77.2,83.4,93.4,40.2,65.3)
var_metrica_continua

# Medidas de Tendência Central

# Média
media.meu.vetor = mean(var_metrica_continua)
media.meu.vetor

sum(var_metrica_continua) / length(var_metrica_continua)

# Mediana
median(var_metrica_continua)

# Quantis
quantile(x = var_metrica_continua, probs = seq(0,1,0.25))

# Medidas de dispersão

# Amplitude
range(var_metrica_continua)
min(var_metrica_continua)
max(var_metrica_continua)
max(var_metrica_continua) - min(var_metrica_continua)

# Variância
var(var_metrica_continua)

sum(var_metrica_continua - media.meu.vetor)

valores_quadrado <- (var_metrica_continua - media.meu.vetor) ^ 2

sum(valores_quadrado) / length(var_metrica_continua)

# Desvio-padrão
sd(var_metrica_continua)

sqrt( var(var_metrica_continua) )

# Variáveis categóricas

var_categorica_nominal <- c('P','P','P','A')

table(var_categorica_nominal)

# Aplicando estatísticas descritivas aos dados

mean(meus.dados$rpct)

meus.dados2 %>% group_by(exemplo_dummy) %>% summarise(mean(rpct))

# Explorando visualização gráfica com ggplot2

# Para representar variáveis métricas contínuas
meus.dados2 %>% 
  ggplot(aes(x = rpct))+
  geom_density()

# Para representar variáveis categóricas
meus.dados2 %>% 
  ggplot(aes(x = exemplo_dummy))+
  geom_bar()

# Para estilizar o gráfico

meus.dados2 %>% 
  ggplot(aes(x = exemplo_dummy))+
  geom_bar(fill = "steelblue")+
  scale_x_discrete(name = "Exemplo Dummy")+
  scale_y_continuous(name="Frequência absoluta")+
  theme_bw()


