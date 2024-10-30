# Title : regressão com simulação
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

# Aprendendo com simulação -----------------------------------------------------

N = 50

# Definindo distribuição aleatória de renda
renda = rnorm(n = N,mean = 1100,sd = 8500) %>% abs()
hist(renda)

# Definindo distribuição aleatória de anos de estudo
anosEst <- rnorm(n = N,mean = 9,sd = 4) %>% round() %>% abs()
anosEst <- ifelse(test = anosEst > 17,
                  yes = 17,no = anosEst)

hist(anosEst)

mydata <- data.frame(renda,anosEst)

# As variáveis aleatórias criadas têm alguma relação entre si?
# Vamos observar com o gráfico
plot(y=renda,x=anosEst)

# Difícil de observar qualquer tendência, né?
# Vamos ver se fica mais fácil com a média da renda por anos de estudo.

t_renda <- mydata %>% group_by(anosEst) %>% summarise(m_renda = mean(renda))

# Vamos observar
plot(t_renda)
lines(t_renda)

plot(y=renda,x=anosEst)
lines(t_renda,lwd=3,col="red")

# e aí, tem alguma tendência?

# Não, porque as variáveis são aleatórias e independentes entre si.
# Vamos agora criar uma nova renda totalmente dependente dos anos de estudo.

# Como fazemos? Com uma função linear simples.

# Definindo distribuição da renda condicionada aos anos de estudo

# Y = a + Bx
renda1 = 600 + 100*anosEst

plot(anosEst,renda1)
abline(lm(renda1 ~ anosEst),col="red",lwd=3)

# E agora, qual é a relação?

mydata <- data.frame(anosEst,renda1)

# Definição de intercepto: y quando a média de x é zero
mydata %>% filter(anosEst == 0) %>% summarise(mean(renda1))

# E se aplicarmos uma regressão agora?
# a função é sempre escrita como: y ~ x

reg1 <- lm(renda1 ~ anosEst) # Linear Models
reg1

options(scipen = 999)

summary(reg1)

# Como vimos, nossos modelos sempre têm um erro. Então vamos criar uma nova
# variável renda considerando um termo de erro aleatório.

# Definindo o quanto vamos errar
e = rnorm(n = N,mean = 0,sd = 10000) # random error term

renda2 = 600 + 100*anosEst + e

plot(anosEst,renda2)

reg2 <- lm(renda2 ~ anosEst)
reg2

summary(reg2)

plot(anosEst,renda2)
abline(lm(renda2 ~ anosEst),col="blue",lwd=2.5)

# Um gráfico mais bonito para explorarmos

data.frame(renda2,anosEst) %>% 
ggplot(aes(y = renda2,x=anosEst))+
  geom_jitter(size=3,col='grey30')+
  geom_smooth(formula = y~x,method='gam',se = F)+
  scale_x_continuous(breaks = seq(0,17,1))+
  geom_vline(xintercept = mean(anosEst),lty=3)+
  geom_hline(yintercept = mean(renda2),lty=3)+
  theme_minimal()

# yobs <- reg2$model$renda2
# 
# ypred <- reg2$fitted.values
# 
# mydata <- data.frame(yobs,ypred)
# 
# mydata$e <- mydata$yobs - mydata$ypred
# 
# sum(mydata$e)
# 
# sum(mydata$e^2)

# Agora vamos explorar o objeto com os resultados da regressão.

y = reg2$model$renda2
x = reg2$model$anosEst
e = reg2$residuals

b0 = reg2$coefficients[1]
b1 = reg2$coefficients[2]

# Cálculo manual dos coeficientes de regressão
# Inclinação

b1 = sum((x - mean(x))*(y - mean(y)))/sum((x - mean(x))^2)
b1

cov(x,y)/var(x)

# Intercepto
a = mean(y) - b1*mean(x)
a

# Função da renda
renda = a + b1 * x + e
ypred = renda

plot(y,ypred)

# Viés de variável omitida -----------------------------------------------------

N = 1000

idade = rnorm(n = N,mean = 8,sd = 2) %>% round() %>% abs()

e = rnorm(n = N,mean = 0,sd = .2)

tamanhoPe = idade*1 + e

desempenho = 6.5 + idade*2 + e
hist(desempenho)

mydata = data.frame(tamanhoPe,idade,desempenho)
reg = lm(data=mydata, desempenho ~ tamanhoPe)
reg

cor(reg$residuals,idade)
