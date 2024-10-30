# Title : importando dados da pnad-c
# Author: Victor Gabriel Alcantara 
# Github: https://github.com/victorgalcantara 
# LinkedIn: https://www.linkedin.com/in/victorgalcantara/ 

# 0. Setup and packages --------------------------------------------------------
#install.packages("pacman")
library(pacman)
p_load(tidyverse,rio,PNADcIBGE)

# Clean memory
rm(list=ls())
gc()

# Definição do diretório
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# 1. Import --------------------------------------------------------------------

ano = 2023

# Requisitando/baixando dados da pnad-c 2022, 1º trim
for (i in length(ano)){
  
pnadc <- get_pnadc(year = ano[i], # ano
                   quarter = 1, # trimestre
                   design = F,   # estrutura específica survey design
                   labels = T,
                   vars = c("UF","Capital",
                            "V2001", # N pessoas no domicílio
                            "V2007", # Sexo
                            "V2009", # Idade
                            "V2010", # Cor/Raca
                            "VD3004",# nvl educacao
                            "VD3005",# Anos de estudo
                            "V4010", # Código ocup princip
                            "V4013", # CNAE 2.0
                            "VD4016",# Renda da ocupacao princip
                            "VD4020",# Renda mensal efetiva
                            "VD4010",# Agrupamento ocup1
                            "VD4011",# Agrupamento ocup2
                            "V1028" # Peso domicílio e pessoas
                   )
)

# 2. Management ----------------------------------------------------------------

# Selecionando vars de interesse
mypnadc <- pnadc %>% select(
    "UF","Capital",
    "V2001", # N pessoas no domicílio
    "V2007", # Sexo
    "V2009", # Idade
    "V2010", # Cor/Raca
    "VD3004",# nvl educacao
    "VD3005",# Anos de estudo
    "V4010", # Código ocup princip
    "V4013", # CNAE 2.0
    "VD4016",# Renda da ocupacao princip
    "VD4020", # Renda mensal efetiva
    "VD4010",# Agrupamento ocup1
    "VD4011",# Agrupamento ocup2
    "V1028" # Peso
  )

# Renomeando vars

mypnadc <- mypnadc %>% rename(.,
                                    peso = "V1028", # Peso amostral
                                    nPessoas = "V2001", # N pessoas no domicilio
                                    idad = "V2009", # Idade
                                    sexo = "V2007", # Sexo
                                    raca = "V2010", # Cor/Raca
                                    educ = "VD3004",# Nvl de instrução mais elevado
                                    anosEst = "VD3005",# Anos de estudo
                                    rendOcup = "VD4016",# Renda da ocupacao princip
                                    rendEfet = "VD4020", # Renda mensal efetiva
                                    ocup = "V4010", # Código ocup princip
                                    cnae="V4013",# CNAE
                                    classeOcup1="VD4010",# Agrupamento ocup1
                                    classeOcup2="VD4011" # Agrupamento ocup2
)

# Modificações

mypnadc <- mypnadc %>% 
  filter(idad %in% 18:64,
         rendOcup > 0) %>%
  mutate(ln_rendaOcup    = log(rendOcup),
         anosEst     = as.numeric(anosEst),
         experiencia = idad - anosEst - 6) %>%
  mutate(.,
  experiencia  = ifelse(experiencia < 0, 0, experiencia) # Ajuste
  )

# Ordenando a base pela renda
mypnadc <- arrange(mypnadc,-rendOcup)

mypnadc[,"ano"] <- ano[i]

# Filtro São Paulo (UF == 35)
mypnadc_sp <- mypnadc %>% filter(UF == "São Paulo")

## Save -------

# R Data Format
save(mypnadc, file = paste0("../1_data/pnadc_",ano[i],".RDS"))
save(mypnadc_sp, file = paste0("../1_data/pnadc_sp_",ano[i],".RDS"))

# CSV format
export(mypnadc, file = paste0("../1_data/pnadc_",ano[i],".csv"))
export(mypnadc_sp, file = paste0("../1_data/pnadc_sp_",ano[i],".csv"))

}
