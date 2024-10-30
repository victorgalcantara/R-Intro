# Title : executa códigos
# Author: Victor Gabriel Alcantara 
# Github: https://github.com/victorgalcantara 
# LinkedIn: https://www.linkedin.com/in/victorgalcantara/ 

# Clean memory
rm(list=ls())
gc()

# Definindo diretório atual
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Iterações/Loops

# No R, os loops são executados principalmente através do **for**.
# A estrutura básica de uma sintaxe com a função **for** é:

for( i in 1:100) { print(i) }

# Suponha que você deseja imprimir na tela todos os nomes salvos em um vetor:

nomes <- c("José","Maria","Henrique","Paula")

nomes[1]
nomes[2]
nomes[3]

# Essa é uma tarefa repetitiva, certo?

for (i in nomes) { print(i) }

# Repare que também podemos escrever como

for (i in 1:4) { print( nomes[i] ) }

# Também podemos adicionar funções

for (i in 1:4){ print( paste("O nome",i,"é",nomes[i]) ) }

# Alguns exemplos um pouco menos simples... 

#Exemplo 1:
for (h in 1:10){
  print("Ola Mundo")
}

for(i in 1:10){
  print(x <- i+5)
}

# Exemplo 3:

soma_seq = 0

for (n in 1:10){
  soma_seq = soma_seq + n
  
  print(soma_seq)
}

# Condicionais IF ELSE ---------------------------------------------------------

x = 10

if( x == 10 ) {"OK"} # Altere o valor e veja que ele não retorna nada

if( x == 10 ){ x = x^2 ; print(x) }

# Podemos também incluir a condição alternativa (OU - OU SE / ELSE - ELSE IF)
if( x == 10 ) {"x é igual a 10"} else {"x é diferente de 10"}

if( x == 10 ) {"x é igual a 10"} else if(x == 100) {"x não é 10, é 100"}

# Complicando

if( x == 10 ) {"x é 10"} else if(x == 11) {"x é 11"} else{"o que é x, afinal?"}

# Lidando com erros ------------------------------------------------------------

nomes

# Observe o que está causando o erro

for(i in 1:8){
  
  if(i < 4) { nomes[i]/2 } else if (i > 4) { print(i) }
  
}

# Para que o erro seja desconsiderado e continue tentando executar o código
# usamos tryCatch({ })

for(i in 1:8){
  
  tryCatch({ expr = if(i <= 4) { nomes[i]/2 } else if (i > 4) { print(i) } }, 
           
           error = function(x) { print(x) }
  )
  
}

# Pulando iterações - NEXT ------------------------
for(i in 1:8){
  
  if(i <= 4) { next } else if (i > 4) { print(i) }
  
}

# Parando iterações - BREAK ------------------------

for(i in 1:8){
  
  if(i <= 4) { next } else if (i == 7) { break } else if(i > 4){ print(i) }
  
}

# AQUI A ORDEM E A SEQUÊNCIA LÓGICA IMPORTA
# Veja o exemplo:

for(i in 1:8){
  
  if(i < 4) { next } else if (i > 3) { print(i) } else if(i == 7){ break }
  
}

# Exemplo concreto -------------------------------------------------------------

load("1_data/pnadc_sp_2023.RDS")

vars <- c("sexo","raca","classeOcup2")

for( i in 1:3 ){
  
  print(i)

  var_i <- vars[i]
  
  mydata <- mypnadc_sp %>% na.exclude() %>% select(ln_rendaOcup,anosEst,var_i)
  
  names(mydata)[3] <- "var_i"
  
  plt_i <- mydata %>% na.exclude() %>% 
  ggplot(aes(y=ln_rendaOcup,x=anosEst,col=var_i))+
  geom_point()+
  geom_smooth(formula = y~x, method="gam",col="black")+
  theme_minimal()+
    labs(title = var_i,x="Anos de estudo",y="Log(Renda)",col=var_i)+
  theme(legend.position = "none")+
  facet_wrap(~var_i)
  
  # Export pdf
  
  pdf(file = paste0("3_outp/2_graph/plt_",var_i,".pdf"),
      width = 10,height = 8)
  print(plt_i)
  dev.off()
}
