# Title : estatística descritiva dados pnadc 2023
# Author: Victor Gabriel Alcantara 
# Github: https://github.com/victorgalcantara 
# LinkedIn: https://www.linkedin.com/in/victorgalcantara/ 

# 0. Setup and packages --------------------------------------------------------
#install.packages("pacman")
library(pacman)
p_load(tidyverse,rio,janitor)

# Clean memory
rm(list=ls())
gc()

# 1. Import --------------------------------------------------------------------

mydata <- import("1_data/mypnadc_2023_sp.xlsx")

# 2. Manipulando dados ---------------------------------------------------------

## 2.1 Observando --------------------------------------------------------------

dim(mydata) # Dimensão da base

head(mydata) # primeiros casos
tail(mydata) # últimos casos

str(mydata) # Estrutura dos dados

summary(mydata) # Descrições das variáveis

# Descrição variável métrica
summary(mydata$rendEfet)

# Descrição variável categórica
summary(mydata$raca)

# 3. Estatísticas --------------------------------------------------------------

# 3.1 Variáveis categóricas

table(mydata$sexo) # R Base

prop.table()

mydata %>% tabyl(sexo) # Janitor

mydata %>% tabyl(sexo) %>% adorn_totals() %>% adorn_pct_formatting()

## 3.2 Variáveis métricas ----

### 3.2.1 Medidas de tendência central ----
min(mydata$rendEfet) # mínimo
max(mydata$rendEfet) # máximo

mean(mydata$rendEfet) # média
median(mydata$rendEfet) # mediana

quantile(mydata$rendEfet,probs=0.5) # quantis

quantile(mydata$rendEfet,probs=c(0.25,0.50,0.75))

summary(mydata$rendEfet) # sumário descritivo

### 3.2.2 Medidas de dispersão ----

range(mydata$rendEfet) # amplitude (menor - maior)

var(mydata$rendEfet) # variância

sd(mydata$rendEfet) # desvio-padrão

# Abrindo cálculo da variância
attach(mydata)

me_rendEfet = mean(rendEfet)

desvMedia = rendEfet - me_rendEfet

desvMedia2 = desvMedia^2

SMDM2 = sum(desvMedia2)/(nrow(mydata) - 1)
DESVPAD = sqrt(SMDM2)

var(rendEfet)
sd(rendEfet)