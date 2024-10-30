# Title : exemplo simples de data.frame e listas
# Author: Victor Gabriel Alcantara 
# Github: https://github.com/victorgalcantara 
# LinkedIn: https://www.linkedin.com/in/victorgalcantara/ 

# Clean memory
rm(list=ls())
gc()

df <- data.frame(v1 = 1:5,v2 = c("João","Maria","Ronaldo","Pedro","Ana"))

lista1 <- list(df,x = 1:20,df$v2)

lista1[[1]]
lista1[[2]]
lista1[[3]]
