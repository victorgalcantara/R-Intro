# A06 - Regressão linear com dados escolas

# 1. Setup ---------------------------------------------------------------------
#install.packages(pacman)
library(pacman)
p_load(tidyverse,ggplot2,rio,stargazer,car,patchwork)

# Remove notação científica
options(scipen = 999)

# Limpando a memória
rm(list=ls()) # Remove all objects - remove objetos
gc()          # Garbage Clean - limpeza de lixos

# Define diretório
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# import ----------------------------------------------------------------------
escolas <- import("../1_data/escolas.xlsx")

str(escolas)

# manuseio -------------------------------------------------------------------

m_data <- escolas %>% select(NSE10,IEE,IAD,IDEB,ICG,tipo,area) %>% na.exclude()

m_data <- m_data %>% mutate(.,
                            NSE10 = scale(NSE10),
                            IEE = scale(IEE),
                            IDEB = scale(IDEB),
                            IAD = scale(IAD),
                            ICG = scale(ICG)
)

# análise exploratória

scater0 <- m_data %>% 
  ggplot(aes(y=IDEB,x=ICG))+
  geom_jitter(alpha=.05,color="grey70")+
  scale_y_continuous(limits = c(-3,3),breaks = seq(-3,3,0.5))+
  geom_smooth(method = "lm", se = FALSE, color = "black")+
  labs(title='ICG',
       subtitle = paste("Cor = ",round(cor(m_data$IDEB,m_data$ICG),2)),
       y="IDEB")+
  theme_minimal()

scater1 <- m_data %>% 
  ggplot(aes(y=IDEB,x=IEE))+
  geom_jitter(alpha=.05,color="grey70")+
  scale_y_continuous(limits = c(-3,3),breaks = seq(-3,3,0.5))+
  geom_smooth(method = "lm", se = FALSE, color = "black")+
  labs(title="IEE",subtitle = paste("Cor = ",round(cor(m_data$IDEB,m_data$IEE),2)),
       y="IDEB")+
  theme_minimal()

scater2 <- m_data %>% 
  ggplot(aes(y=IDEB,x=IAD))+
  geom_jitter(alpha=.05,color="grey70")+
  scale_y_continuous(limits = c(-3,3),breaks = seq(-3,3,0.5))+
  geom_smooth(method = "lm", se = FALSE, color = "black")+
  labs(title="IAD",subtitle = paste("Cor = ",round(cor(m_data$IDEB,m_data$IAD),2)),
       y="IDEB")+
  theme_minimal()

scater3 <- m_data %>% 
  ggplot(aes(x=NSE10,y=IDEB))+
  geom_jitter(alpha=.05,color="grey70")+
  scale_y_continuous(limits = c(-3,3),breaks = seq(-3,3,0.5))+
  geom_smooth(method = "lm", se = FALSE, color = "black")+
  labs(title='IDEB',
       subtitle = paste("Cor = ",round(cor(m_data$NSE10,m_data$IDEB),2)),
       x="INSE")+
  theme_minimal()

scaters <- scater0 + scater2 + scater1 + scater3

# Save as pdf
pdf(file = "../3_outp/2_graph/scaters.pdf",width = 8,height = 3)
plot(scaters)
dev.off()

# regressão --------------------------------------------------------------------

reg1 = lm(data = m_data,formula = IDEB ~ NSE10)

reg2 = lm(data = m_data,formula = IDEB ~ NSE10 + IEE)

reg3 = lm(data = m_data,formula = IDEB ~ NSE10 + IEE + IAD)

reg4 = lm(data = m_data,formula = IDEB ~ NSE10 + IEE + IAD + ICG)

stargazer(reg1,reg2,reg3,reg4,type = "html",out = "../3_outp/1_table/reg_escolas.html")

# e a multicolinearidade? ------------------------------------------------------

# Variance Inflaction Factor - VIF -------

vif(reg4)
