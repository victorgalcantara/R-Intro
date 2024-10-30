# Title : regressão com dados reais (pnadc)
# Author: Victor Gabriel Alcantara 
# Github: https://github.com/victorgalcantara 
# LinkedIn: https://www.linkedin.com/in/victorgalcantara/ 

# 0. Setup and packages --------------------------------------------------------
#install.packages("pacman")
library(pacman)
p_load(tidyverse,rio,stargazer)

# Clean memory
rm(list=ls())
gc()

# Aprendendo com dados reais

# Import -----------------------------------------------------------------------

mypnadc_sp <- import("../1_data/pnadc_sp_2023.csv")

# Análises descritivas (I): Gráficos Univariados -------------------------------

# Histograma da variável renda (original)
mypnadc_sp %>%
  ggplot(aes(x = rendOcup)) +
  geom_histogram()

# Histograma do log da renda original
mypnadc_sp %>%
  ggplot(aes(x = ln_rendaOcup)) +
  geom_histogram()

# Histograma da idad
mypnadc_sp %>%
  ggplot(aes(x = idad)) +
  geom_bar()

# Histograma da idad
tabx_idad_sexo <- table(mypnadc_sp$idad,mypnadc_sp$sexo) %>% as.data.frame()
tabx_idad_sexo <- tabx_idad_sexo %>% mutate(.,
                                            Freq = case_when(
                                              Var2 == "Mulher" ~ -Freq,
                                              Var2 == "Homem"  ~ Freq
                                            ))

tabx_idad_sexo %>% 
  ggplot(aes(x = Var1,y=Freq, fill = Var2)) +
  geom_bar(stat = "identity")+
  labs(title = "Pirâmide Etária por Sexo",
       x = "idad",
       y = "",fill="Sexo")+
  theme_minimal()+
  theme(
        #axis.text.y = element_blank(),
        legend.position = "bottom")+
  coord_flip()

# Histograma da Experiência
mypnadc_sp %>%
  ggplot(aes(x = experiencia)) +
  geom_bar()

# Histograma (na realidad, gráfico de barras) dos anos de estudo
mypnadc_sp %>%
  ggplot(aes(x = anosEst)) +
  geom_bar() +
  scale_x_continuous(limits = c(0,18),breaks = seq(1,17,1),expand = c(0,0))

# Análises descritivas (II): Gráficos Bivariados -------------------------------

# Diagrama de dispersão: anosEst x renda
mypnadc_sp %>%
  ggplot(aes(x = anosEst, y = ln_rendaOcup)) +
  geom_point()

# Diagrama de dispersão: idad x renda
mypnadc_sp %>%
  ggplot(aes(x = idad, y = rendOcup)) +
  geom_point()

# Diagrama de dispersão: experiência x renda
mypnadc_sp %>%
  ggplot(aes(x = experiencia, y = rendOcup)) +
  geom_point()

# Construindo um pequeno banco de dados agregados: médias condicionais por anosEstação
agreganosEst <- mypnadc_sp %>%
  group_by(anosEst) %>%
  summarise(m_renda   = mean(rendOcup),
            m_lnrenda = mean(ln_rendaOcup))

# Gráfico de linhas: média de renda por anos de estudos
agreganosEst %>%        
  ggplot(aes(x = anosEst, y = m_renda)) +
  geom_point(size = 1.5) +
  geom_line()

# Gráfico de linhas: média do log da renda por anos de estudos
agreganosEst %>%        
  ggplot(aes(x = anosEst, y = m_lnrenda)) +
  geom_point(size = 1.5) +
  geom_line()

# Construindo um pequeno banco de dados agregados: médias condicionais por anos 
# de experiência
agregExperiencia <- mypnadc_sp %>%
  group_by(experiencia) %>%
  summarise(m_renda   = mean(rendOcup),
            m_lnrenda = mean(ln_rendaOcup))

# Gráfico de linhas: média da renda por anos de experiência
agregExperiencia %>%        
  ggplot(aes(x = experiencia, y = m_renda)) +
  geom_point(size = 1.5) +
  geom_line()

# Gráfico de linhas: média do log da renda por anos de experiência
agregExperiencia %>%        
  ggplot(aes(x = experiencia, y = m_lnrenda)) +
  geom_point(size = 1.5) +
  geom_line()

# Criando Experiencia ao quadrado
mypnadc_sp <- mypnadc_sp %>% 
  mutate(experiencia2  = experiencia^2)

# Regressao --------------------------------------------------------------------

reg = lm(data = mypnadc_sp,rendOcup ~ anosEst)
summary(reg)

# Explorando a função predict - valores preditos
anosEst <- mypnadc_sp$anosEst

valorPredito_rendaOcup = -1161.8 + 347.5*anosEst

valorPredito_rendaOcup[1]

predict(reg)[1]

reg$fitted.values[1]

stargazer(reg,
          type = "html",
          out = "../3_outp/1_table/reg1_pnadc_sp.html")

# Manipulando o objeto de regressão --------------------------------------------

# Podemos extrair informações de interesse:

yobs = reg$model$rendOcup
x1 = reg$model$anosEst

# Coeficientes ----
betas = coef(reg)

b0 = coefficients(reg)[1]
b1 = coefficients(reg)[2]

# Cálculo manual dos coeficientes de regressão
# Inclinação

b1 = sum((x1 - mean(x1))*(yobs - mean(yobs)))/sum((x1 - mean(x1))^2)
b1

cov(x1,yobs)/var(x1)

# Intercepto
b0 = mean(yobs) - b1*mean(x1)
b0

# Valores preditos ----
yhat = predict(reg)

# Resíduos ----
e = yobs - yhat
head(e)

e = residuals(reg)
head(e)

# Podemos calcular "na mão" algumas estatísticas de interesse

# - Variância dos resíduos (Média dos Quadrados do Erro - Mean Square Error - MSE)
n = nrow(mypnadc_sp)

MSE = sum(e^2)/(n-1)

# - Desvio-padrão dos resíduos (ou Root Mean Square Error - RMSE)
RMSE = sqrt(MSQE)

# Coef. de determinação ----
(var_y - MSQE) / var_y

r = cor(y, yhat)
r^2

# Análise gráfica de resíduos --------------------------------------------------

# Gráfico de resíduos
t = tibble(yhat, 
           e,
           anosEst      = mypnadc_sp$anosEst) 

# Diagrama de dispersão - valores preditos X Resíduos
t %>%
  ggplot(aes(x = yhat, y = e)) +
  geom_point(alpha = .9) +
  geom_hline(yintercept = 0, col = "red", lty = 2)


# Diagrama de dispersão - anos de estudo X Resíduos
t %>%
  ggplot(aes(x = anosEst, y = e)) +
  geom_point(alpha = .9) +
  geom_hline(yintercept = 0, col = "red", lty = 2)

# Prevendo valores -------------------------------------------------------------

# Prevendo valores
new_data = data.frame(anosEst = c(0,3,11,17,4,9)) 

predict(reg, newdata = new_data)

# Gráfico de anosEst contra y predito
new_data %>%
  ggplot(aes(x = anosEst, y = y_pred)) +
  geom_point() +
  geom_line()

mypnadc_sp %>% 
  ggplot(aes(x=anosEst,y=rendOcup))+
  geom_point()+
  geom_smooth(method = 'lm',formula = y~x)+
  geom_point(y = 2660.9019,x=11,size=4,col="red")

# Recodificando variáveis categóricas para alterar a categoria de referência (intercepto)

mypnadc_sp = mypnadc_sp %>% mutate(.,
                      classeOcup3 = factor(classeOcup2,
                                           levels = c('Ocupações elementares',
                                                      'Diretores e gerentes',
                                                      'Profissionais das ciências e intelectuais',
                                                      'Técnicos e profissionais de nível médio',
                                                      'Trabalhadores de apoio administrativo',
                                                      'Trabalhadores dos serviços, vendedores dos comércios e mercados',
                                                      'Trabalhadores qualificados da agropecuária, florestais, da caça e da pesca',
                                                      'Trabalhadores qualificados, operários e artesões da construção, das artes mecânicas e outros ofícios',
                                                      'Operadores de instalações e máquinas e montadores',
                                                      'Membros das forças armadas, policiais e bombeiros militares',
                                                      'Ocupações maldefinidas' 
                                                      )
                                           )
                      )

table(mypnadc_sp$classeOcup3)

mypnadc_sp = mypnadc_sp %>% mutate(.,
                                   sexo2 = factor(mypnadc_sp$sexo,
                                                  levels = c("Mulher","Homem")
                                   ) )

table(mypnadc_sp$sexo2)

mypnadc_sp$sexo2 <- relevel(mypnadc_sp$sexo2,ref = "Mulher")

table(mypnadc_sp$sexo2)

mypnadc_sp <- mypnadc_sp %>% mutate(.,
                                    raca2 = case_when(
                                      raca %in% c("Amarela","Branca") ~ "Brancos",
                                      raca %in% c("Preta","Parda") ~ "Negros"
                                    )
                                    )

table(mypnadc_sp$raca2,mypnadc_sp$sexo)

# Inserindo variáveis categóricas no modelo ------------------------------------
# Y ~ X
reg1 = lm(data = mypnadc_sp, rendOcup ~ sexo2)
summary(reg1)

mypnadc_sp %>% group_by(sexo) %>% summarise(mean(rendOcup,na.rm=T))

# Regressão múltipla -----------------------------------------------------------

reg1 = lm(data = mypnadc_sp, rendOcup ~ sexo2)

reg2 = lm(data = mypnadc_sp, rendOcup ~ sexo2 + anosEst)

reg3 = lm(data = mypnadc_sp, rendOcup ~ sexo2 + anosEst + raca2)

reg4 = lm(data = mypnadc_sp, rendOcup ~ sexo2 + anosEst + raca2 + idad)

reg5 = lm(data = mypnadc_sp, rendOcup ~ sexo2 + anosEst + raca2 + idad + classeOcup3)

reg6 = lm(data = mypnadc_sp, rendOcup ~ sexo2 + anosEst + raca2 + idad + classeOcup3 + sexo2:raca2)

# Repare como mudaram os coeficientes!

stargazer(reg1,reg2,reg3,reg4,reg5,reg6,
          type = "html",
          out = "../3_outp/1_table/regressoes.xls",
          title = "Explicando a renda da ocupação principal")

# Próxima aula

# Como construir variáveis com ordens (ordinais) usando factors.
# Intercepto em modelos com interações
# VIF : inflação da variância como forma de entender a multicolinearidade

# Interações
reg4 = lm(data = mypnadc_sp, rendOcup ~ anosEst + sexo + raca + sexo:raca)
summary(reg4)

# Viés de variável omitida -----------------------------------------------------

# Inferência sobre os coeficientes ---------------------------------------------

reg = lm(data=mypnadc_sp,rendOcup ~ sexo:raca2)
reg

mypnadc_sp %>% group_by(sexo,raca2) %>% summarise(mean(rendOcup,na.rm = T))

# Discutindo testes estatísticos -----------------------------------------------

reg1 = lm(data=mypnadc_sp,rendOcup ~ anosEst)
summary(reg1)

# Distribuição t-student -------------------------------------------------------
# dt(x,df): f = density (pf)

n = nrow(reg1$model)
df = n - 2

#find the value of the Student t distribution pdf at x = 2 with 10 degrees of freedom
dt(2, df = df)

# depict the t(10) graphically
x <- seq(-5, 5, length=100)
y <- dt(x = x, df = 10)
plot(x,y, type = "l", lwd = 2)

# pt(x,df): F = cummulative distribution (cdf)

# Find the area to the left of x = 2 under the curve
pt(-9.085, df = df) 

# Find the area to the right of x = 2 under the curve
pt(2, df = 10, lower.tail = FALSE) 
1-pt(2, df = 10)

n = nrow(reg$model)
k = 2

# VIF - Variance Inflation Factor ----------------------------------------------
p_load(car)

reg = lm(data=mypnadc_sp,rendOcup ~ anosEst + idad)
summary(reg)

regx1 = lm(data=mypnadc_sp,anosEst ~  idad)
summary(regx1)
tol = 1 - 0.06128
1/tol

vif(reg)
