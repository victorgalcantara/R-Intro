# Title : gráficos dados pnadc 2023
# Author: Victor Gabriel Alcantara 
# Github: https://github.com/victorgalcantara 
# LinkedIn: https://www.linkedin.com/in/victorgalcantara/ 

# 0. Setup and packages --------------------------------------------------------
#install.packages("pacman")
library(pacman)
p_load(tidyverse,rio)

# Clean memory
rm(list=ls())
gc()

# 1. Import --------------------------------------------------------------------

mydata <- import("1_data/mypnadc_2023_sp.xlsx")
attach(mydata)

# 2. Gráficos ------------------------------------------------------------------

# 2.1 Variáveis categóricas

tab_raca <- table(mydata$raca)

barplot(tab_raca)

ord_tab_raca <- reorder(x = names(tab_raca), X = -tab_raca)
levels(ord_tab_raca)

barplot(tab_raca[ levels(ord_tab_raca) ],
        main = "Raça/etnia",
        xlab = "Categorias",
        ylab = "Frequência absoluta",
        col = "steelblue",
        ylim=c(0,2500))

pie(tab_raca,
    main = "Raça/etnia",
    col = rainbow(n=5),
    ylim=c(0,2500),
    radius = 1.3
    )

## 2.2 Variáveis métricas ----

### 2.2.1 Discretas ----

tab_nPessoas <- table(mydata$nPessoas)

barplot(tab_nPessoas,
        main = "Número de pessoas no domicílio",
        xlab = "número de pessoas",
        ylab = "Frequência absoluta",
        col = "steelblue",
        ylim=c(0,1400))

### 2.2.1 Contínuas ----

# Histograma
hist(rendEfet,freq=F,
        main = "Renda Efetiva",
        xlab = "renda efetiva",
        ylab = "Frequência absoluta",
        col = "steelblue",
     breaks = 100 # VAMOS BRINCAR COM OS BREAKS (BREANKANDO)
     )
lines(density(rendEfet), col = "darkred", lwd = 2)

# Boxplot
boxplot(rendEfet)

hist(rendEfet,freq = F,
     main = "Renda Efetiva",
     xlab = "renda efetiva",
     ylab = "Frequência absoluta",
     col = "steelblue",
     ylim=c(0,6.581e-05)
)
lines(density(rendEfet,bw=5000))

# Usando a "Gramática dos Gráficos" (GGPLOT) - A Grammar of Graphics -----------


