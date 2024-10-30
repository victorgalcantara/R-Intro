# Title : executa códigos
# Author: Victor Gabriel Alcantara 
# Github: https://github.com/victorgalcantara 
# LinkedIn: https://www.linkedin.com/in/victorgalcantara/ 

# Clean memory
rm(list=ls())
gc() # Garbage Clean

# Definição do diretório
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

base::source(file = '1 - IMPORTANDO DADOS PNADC.R' , echo = TRUE, encoding = "UTF-8")

# base::source(file = '2 - ESTATISTICA DESCRITIVA.R' , echo = TRUE, encoding = "UTF-8")

# base::source(file = '3 - GRÁFICOS.R' , echo = TRUE, encoding = "UTF-8")