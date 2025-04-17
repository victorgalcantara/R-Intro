# Aula 03 - Praticando manuseio de dados
# Autor: Victor G Alcantara

# Setup -----

library(tidyverse)
library(rio)

# Import ----

mydata <- import("D:/01 - data/EDUC/CEB/2023/dados/microdados_ed_basica_2023.csv")

# Esse dado tem problema de encoding

mydata <- import("D:/01 - data/EDUC/CEB/2023/dados/microdados_ed_basica_2023.csv",
                 encoding = "Latin-1" )

str(mydata)

# Selecionar algumas vars ----

mydata2 <- mydata %>% 
  select(NO_ENTIDADE,SG_UF) %>% 
  filter(SG_UF == "SP") %>% 
  rename(uf=SG_UF)

dim(mydata2)

# Filtrar alguns casos ----

# Renomear variáveis ----

mydata2 <- mydata %>% rename(
  uf = SG_UF,
  nome_esc = NO_ENTIDADE,
  dep = TP_DEPENDENCIA,
  qt_bas = QT_MAT_BAS
  ) %>% 
  filter(uf == "SP")

# Começando a usar a função mutate

mydata2 <- mydata2 %>% mutate(
                              exemplo_ridiculo = qt_bas * 1000  
)

# usando case_when dentro do mutate

mydata2 <- mydata2 %>% mutate(
  porte = case_when(
    qt_bas < 1000 ~ "Pequeno",
    qt_bas >= 1000 ~ "Grande",
  )
)

mydata2 <- mydata2 %>% mutate(
  porte2 = case_when(
    porte == "Pequeno" ~ "P",
    porte == "Grande" ~ "G",
  )
)

mydata2 <- mydata2 %>% mutate(
  exemplo = case_when(
    qt_bas > 1000 & qt_bas < 2000 ~ "Médio"
  )
)

??case_when

# Usando recode

mydata2 <- mydata2 %>% mutate(
  exemplo2 = recode(porte,
                    "Pequeno" = "PQ",
                    "Grande"  = "GD"
  )
) 

# usando a função factor

mydata2 <- mydata2 %>% mutate(
  nivel_porte = factor(porte,
                       levels=c("Pequeno","Grande"),
                       ordered = TRUE
                       )
)

class(mydata2$nivel_porte)

# usando cut

mydata2 <- mydata2 %>% mutate(
  niveis_porte3 = cut(qt_bas,
                      breaks = c(0,500,1000,3000,
                                 max(mydata2$qt_bas,na.rm = T)),
                      labels = c("Pequeno","Médio","Alto","Muito Alto")
    
  )
)

  
  
  





