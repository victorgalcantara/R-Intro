# Preparando dados UF Brasil
# Autor: Victor Gabriel Alcantara
# Github: https://github.com/victorgalcantara
# LinkedIn: https://www.linkedin.com/in/victorgalcantara/

# 0. Setup --------------------------------------------------------

library(pacman)
p_load(rio,tidyverse,geobr)

# Clean memory
rm(list=ls())
gc()

# 1. Import ----------------------------------------------------------

# source: https://basedosdados.org/dataset/cbfc7253-089b-44e2-8825-755e1419efc8?table=65639055-2408-46b4-8f82-ecae3d04b800
mydata <- import("D:/01 - data/ATLASBR/mundo_onu_adh_uf.csv")

names(mydata)

# 2. Management -----------------------------------------------------------

mydta <- mydata %>% filter(ano == 2010) %>% select(
  sigla_uf,populacao,populacao_urbana,renda_pc,
  pea,pia,expectativa_vida,taxa_superior_25_mais,
  indice_gini,prop_renda_10_ricos,prop_renda_40_pobres)

# 3. Export -----------------------------------------------------------

export(mydta,file = "G:/Meu Drive/02 - GitHub/R-Intro/000 - P&R/00 data/br_uf.csv")