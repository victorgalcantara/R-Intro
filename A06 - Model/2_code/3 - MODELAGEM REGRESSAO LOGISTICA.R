# Title : Regressão logística
# Author: Victor Gabriel Alcantara 
# Github: https://github.com/victorgalcantara 
# LinkedIn: https://www.linkedin.com/in/victorgalcantara/ 
# Variável dependente (a ser explicada): binária com valores 0 e 1

# 1. Setup ---------------------------------------------------------------------

#install.packages(pacman)
library(pacman)
p_load(tidyverse,ggplot2,rio,car,
       pROC,ROCR,stargazer,caret)

# Remove notação científica
options(scipen = 999)

# Limpando a memória
rm(list=ls()) # Remove all objects - remove objetos
gc()          # Garbage Clean - limpeza de lixos

# Define diretório
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Conceitos fundamentais -------------------------------------------------------

# Probabilidade ----
# sucesso de um evento (Y=1) contra o total de tentativas ou risco de sucesso.

sucesso = 2
tentativas = 10

p = sucesso/tentativas
p

# probabilidade de erro (Y = 0)
1 - p

# Chance ----
# probabilidade de sucesso contra probabilidade de fracasso de um evento.

p / (1 - p)

p = seq(0,1,0.01)

c = p / (1 - p)

plot(p,c)

# Função para cálculo da chance com base em uma probabilidade
calc_chance <- function(p) {p / (1-p)}

calc_chance(p = 0.75)

# Parte conceitual regressão logística -----------------------------------------

#Estabelecendo uma função para a probabilidade de ocorrência de um evento
calc_prob_log <- function(z){
  prob = 1 / (1 + exp(-z)); return(prob)
}

#Plotando a curva sigmóide teórica de ocorrência de um evento
#para um logito z entre -5 e +5
data.frame(z = -5:5) %>%
  ggplot() +
  stat_function(aes(x = z, color = "Prob. Evento"),
                fun = calc_prob,
                size = 2) +
  geom_hline(yintercept = 0.5, linetype = "dotted") +
  scale_color_manual("Legenda:",
                     values = "#440154FF") +
  labs(x = "Logito z",
       y = "Probabilidade") +
  theme_bw()

# Aprendendo com simulação -----------------------------------------------------

N = 100

# Definindo distribuição aleatória de renda
renda = rnorm(n = N,mean = 1100,sd = 8500) %>% abs()
e = rnorm(n = N,mean = 0,sd = 3)

# Y = a + Bx
voto = 600 + 2.5*renda + e

# Discretizando para 0-1
voto = ifelse(voto < median(voto),0,1)

mydata <- data.frame(voto,renda)

reg1 = lm(data = mydata,voto ~ renda)
mydata$fit1 = reg1$fitted.values

plot(y=voto ,x=renda, 
     pch = 16, col = "blue", 
     main = "Linha de tendência da regressão linear", 
     xlab = "Renda", ylab = "Probabilidade")
abline(reg1, col = "red", lwd = 3)

reg2 = glm(data = mydata,family = "binomial",voto ~ renda)
mydata$fit2 <- reg2$fitted.values

new_data <- data.frame(renda = seq(min(renda), max(renda), length.out = 100))

# Predict probabilities using the logistic model
predicted_probs <- predict(reg2, newdata = new_data, type = "response")

plot(renda, voto, 
     pch = 16, col = "blue", 
     main = "Linha de tendência da regressão logística", 
     xlab = "Renda", ylab = "Probabilidade")
lines(new_data$renda, predicted_probs, col = "red", lwd = 2)

# Explorando pontos de corte ----

# Com modelo linear
mydata$cutoff_lm <- ifelse(mydata$fit1 <= 0.5,0,1)

# Com modelo logístico
mydata$cutoff_lg <- ifelse(mydata$fit2 <= 0.5,0,1)

# Matriz de confusão: recurso estatístico para avaliar a eficácia do modelo

m_confusao_lm <- table(mydata$cutoff_lm,mydata$voto)

m_confusao_lg <- table(mydata$cutoff_lg,mydata$voto)

# Acurácia -----
# Prop de acerto
(m_confusao_lm[1,1] + m_confusao_lm[2,2]) / sum(m_confusao_lm[,])

(m_confusao_lg[1,1] + m_confusao_lg[2,2]) / sum(m_confusao_lg[,])

# A acurácia com o modelo linear é de 0.9, uma vez que estamos errando em alguns
# casos. Já com o modelo logístico, a acurácia é de 1, uma vez nosso modelo é perfeito
# e capaz de acertar todos os cados na nossa base de dados.

# Com dados do Enem ------------------------------------------------------------

# Saeb 2019
enem_2021_sp <- import("../1_data/mydata_enem_2021_sp.csv")

# 3. Manuseio dos dados --------------------------------------------------------

mydata <- mutate(.data = enem_2021_sp,
                 
                 educMae_sd = scale(educMae),
                 rendFamP_sd = scale(rendFamP),
                 depAdmin2 = case_when(tpEscola == "Publica" ~ 0,
                                       tpEscola == "Privada" ~ 1),
                 faixas_rendFamP = case_when(
                   rendFamP < 1500 ~ "1. Baixa",
                   rendFamP >= 1500 & rendFamP < 5000 ~ "2. Média",
                   rendFamP > 5000 ~ "3. Alta"
                 )
)

# Evento: nota para ingresso ser maior que o mínimo necessário
# para ingresso na USP (corte arbitrário = 700)

corte = 600

mydata$NPI <- ifelse(mydata$media > corte,1,0)

# Variável dependente: Nota Para Ingresso (NPI)
# 1 = "Sim"
# 0 = "Não"

# Variáveis independentes:
# 1. escolaridade da mãe
# 2. renda familiar per capta
# 3. tipo de escola (dep Admin)

# Análise exploratória ---------------------------------------------------------

# Como se comportam nossas variáveis?

# Histograma da média de desempenho com o corte da nota
mydata %>%
  ggplot(aes(x = media)) +
  theme_bw()+
  geom_histogram(bins = 50,fill="steelblue",alpha=.7)+
  geom_vline(xintercept = corte,lty=2,size=.7,color="red")+
  geom_text(aes(y=1600,x=760,label="NPI = 600"),color="red")+
  labs(x="Média de desempenho",y="Frequência")

# Quantidade de 0 e 1
mydata %>% mutate(NPI = factor(NPI)) %>% drop_na(NPI) %>% 
  ggplot(aes(x = NPI)) +
  theme_bw()+
  geom_bar(alpha=.8)+
  labs(fill="")+
  labs(x="NPI",y="Frequência")

# Regressão logística ----------------------------------------------------------

mydata.2 <- mydata %>% select(NPI,educMae,rendFamP,faixas_rendFamP,
                              educMae_sd,rendFamP_sd,
                              depAdmin2,tpEscola) %>% na.exclude()

# Agora, ao invés de usar a função para os modelos lineares, mobilizaremos
# a função para os modelos lineares generalizados:

# Generalized Linear Models (GLM): função para regressão logística

reg <- glm(formula = NPI ~ educMae + rendFamP + depAdmin2, 
           data = mydata.2, 
           family = "binomial")
summary(reg)

# Com variáveis padronizadas
reg <- glm(formula = NPI ~ educMae_sd + rendFamP_sd + depAdmin2, 
           data = mydata.2, 
           family = "binomial")
summary(reg)

# Transformando os resultados do logito para chances e probabilidades

# Chances
# exponencial do logito, que é o valor de euler elevado ao valor do logito
chance_educMae = 2.7182818284^0.39208

(chance_educMae - 1) * 100

# Função para calcular a chance
calc_chance_log = function(z) { 
  chance = 2.7182818284^z
  return(chance)
  }

logitos = coefficients(reg)
calc_chance_log(z = logitos)

prob_eduMae = 1 / (1 + 2.7182818284^-0.39208)

calc_prob_log(z = logitos)

p = calc_prob(z = reg$fitted.values)

plot(y=p,x=reg$model$rendFamP_sd)

# Outras maneiras de apresentar os outputs do modelo
# Função 'stargazer' do pacote 'stargazer'

stargazer(reg, nobs = T, type = "text") # mostra o valor de Log-Likelihood

# Manipulando o objeto de regressão --------------------------------------------

# Podemos extrair informações de interesse:

# Probabilidades preditas pelo modelo
mydata.2$phat <- reg$fitted.values

# Vamos analisar as probabilidades preditas antes de avançar

# Distribuição das probabilidades preditas pelo modelo
mydata.2 %>%
  ggplot(aes(x = phat))+
  theme_bw()+
  geom_histogram(bins = 50)+
  scale_y_continuous(expand = c(0.01,0))+
  scale_x_continuous(expand = c(0.01,0))+
  labs(x="Probabilidade predita pelo modelo",y="Frequência")

# Por que, em geral, a probabilidade predita é baixa? 
# [lembrar discriminação da nota de corte]

# Distrib. de probabilidade por tipo de escola
mydata.2 %>%
  ggplot(aes(x = phat))+
  theme_bw()+
  geom_density(aes(fill=tpEscola),bw=0.02,alpha=.7)+
  scale_y_continuous(expand = c(0.01,0))+
  scale_x_continuous(expand = c(0.01,0))+
  labs(fill="Escola",x="Probabilidade predita")

mydata.2 %>%
  ggplot(aes(x = phat))+
  theme_bw()+
  geom_density(aes(fill=faixas_rendFamP),bw=0.02,alpha=.7)+
  scale_y_continuous(expand = c(0.01,0))+
  scale_x_continuous(expand = c(0.01,0))+
  labs(fill="Renda Familiar \n per capta",x="Probabilidade predita")

# Voltando a manipular o objeto de regressão -----------------------------------

# Podemos extrair informações de interesse:

# Coeficientes
reg$coefficients

# Modelo
modelo <- reg$model

# Probabilidades preditas
modelo$phat <- reg$fitted.values

modelo <- relocate(.data = modelo,
                   NPI,phat,
                   .after = depAdmin2)
view(modelo)

# Máxima verossimilhança (maximally likelihood) - probabilidade de acerto > maximizar o acerto
# Quanto mais o Log-Lik se aproxima do zero, maior é a maximização do acerto e a explicação do modelo.

# valor de Log-Likelihood (LL)
logLik(reg)

# Fazendo predições para o modelo

#Exemplo: qual a probabilidade média de ter nota para ingressar na Usp 
# se a mãe tiver escolaridade 16 e a renda ser 10000
educMae_sd = c(2,1.2,0,0.9)
rendFamP_sd = c(8000,3500,2200,5000) 
depAdmin2 = c(1,1,0,0)

dados_predicao <- data.frame(educMae_sd,rendFamP_sd,depAdmin2)

# PARA VERIFICAR O ERRO
dados_predicao$prob_predita = predict(object = reg, 
                                      newdata = dados_predicao, 
                                      type = "response")

view(dados_predicao)

# Matriz de confusão para cutoff = 0.10
# Interpretação: para casos em que a predição com o modelo é de probabilidade
# maior que 0.10, considere que o indivíduo tem NPI == 1

predito <- predict(reg, type = "response") >= 0.15

observado <- mydata.2$NPI == 1

m_confus <- table(predito,observado)[2:1, 2:1]
m_confus

data.frame(predito,observado) %>% head()

# Acurácia -----
# Prop de acerto
(m_confus[1,1] + m_confus[2,2]) / sum(m_confus[,])

# Sensitividade ----
# Prop de acerto (Y = 1)
sensitividade = m_confus[1,1] / sum(m_confus[,1])
sensitividade

# Especificidade ----
# Prop de acerto (Y = 0)
especificidade = m_confus[2,2] / sum(m_confus[,2])
especificidade

#(função confusionMatrix do pacote caret)
confusionMatrix(m_confus)

#função roc do pacote pROC
ROC <- roc(response = mydata.2$NPI, 
           predictor = reg$fitted.values)

plot(ROC,xlim = c(1,0))

# Variance Inflation Factor ----------------------------------------------------

vif(reg)
