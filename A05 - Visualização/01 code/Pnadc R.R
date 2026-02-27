# Renda e composição étnico-racial em Cotia-SP - setores censitarios
# author: Victor Gabriel Alcantara

# 0. Packages and setup --------------------------------------------------------

# To clean memory
rm(list=ls()) # Remove all objects
gc() # Garbage Clean

# install.package(pacman)
library(pacman)
p_load(tidyverse,rio,janitor,patchwork,geobr,sf,PNADcIBGE)

# Work directories
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

options(scipen = 9999)

# 1. Import data ---------------------------------------------------------------

# Pnad-c

pnadc_2025 <- get_pnadc( year = 2025,
          quarter = 1, # trimestre
          design = F,   # estrutura específica survey design
          deflator = F,
          labels = T,
          vars = c("UF","Capital","RM_RIDE",
                   "V1022", # Área rural/urbana
                   "V1023", # Tipo de área
                   "V2009", # Idade
                   "V2007", # Sexo
                   "V2010", # Cor/Raca
                   "V3009", # Curso mais elevado frequentado
                   "VD3004",# Nvl de instrução mais elevado
                   "VD3005",# Anos de estudo
                   "VD4001",# Pos forca de trab
                   "VD4002",# Pos ocup
                   "VD4016",# Renda da ocupacao princip
                   "VD4009",# Pos ocupacional
                   "V4010", # Código ocup princip
                   "VD4010",# Agrupamento ocup1
                   "VD4011", # Agrupamento ocup2
                   
                   "V1028" # Peso amostral
          ) )

# Salvando dados
library(arrow)
arrow::write_parquet(pnadc_2025,"C:/Users/victo/OneDrive/03_work/acadêmico/workshops/LAPS 2025/01 - data/IBGE/PNADc/2025/pnadc_2025.parquet")
pnadc_2025 <- read_parquet("C:/Users/victo/OneDrive/03_work/acadêmico/workshops/LAPS 2025/01 - data/IBGE/PNADc/2025/pnadc_2025.parquet")

# Renomeando vars

pnadc_2025 <- pnadc_2025 %>% rename(.,
                                    area = "V1022", # Área rural/urbana
                                    tipoArea = "V1023", # Tipo de área
                                    peso = "V1028", # Peso amostral
                                    idad = "V2009", # Idade
                                    sexo = "V2007", # Sexo
                                    raca = "V2010", # Cor/Raca
                                    cursoMaisElevado = "V3009", # Curso mais elevado frequentado
                                    nvlMaisElevado = "VD3004",# Nvl de instrução mais elevado
                                    anosEst = "VD3005",# Anos de estudo
                                    posTrab = "VD4001",# Pos forca de trab
                                    posOcup = "VD4002",# Pos ocup
                                    rendOcup = "VD4016",# Renda da ocupacao princip
                                    grupPosOcup="VD4009",# grupos de pos ocupacional
                                    ocup = "V4010", # Código ocup princip
                                    classeOcup1="VD4010",# Agrupamento ocup1
                                    classeOcup2="VD4011" # Agrupamento ocup2
)

pnadc_2025 <- pnadc_2025 %>% 
  mutate(.,
         # Formatando para numérico
         anosEst = ifelse(
           test = anosEst == "Sem instrução e menos de 1 ano de estudo",
           yes  = 0,
           no   = as.numeric(anosEst)),
         
         ocup = as.numeric(ocup),
  )

pnadc_2025_sp <- pnadc_2025 %>% filter(UF == "São Paulo")

## 2.1 Medidas de tendência central ----
mean(pnadc_2025$rendOcup, na.rm=T)     # média
median(pnadc_2025$rendOcup, na.rm=T)   # mediana

# Medidas de dispersão
var(pnadc_2025$rendOcup, na.rm=T )    # variância
sd(pnadc_2025$rendOcup, na.rm=T)     # desvio-padrão

# Funções úteis para descrição
summary(pnadc_2025$rendOcup)
psych::describe(pnadc_2025$rendOcup)

table(pnadc_2025$raca)

# Cálculos por grupos
# group_by()

t_ocup <- pnadc_2025 %>% group_by(classeOcup1) %>% summarise(
  n = n(),
  me_educ = round(mean(anosEst),1),
  me_rend = mean(rendOcup,na.rm=T)
) %>% arrange(-me_rend)

t_sexo <- pnadc_2025 %>% group_by(sexo) %>% summarise(
  n = n(),
  me_educ = round(mean(anosEst),1),
  me_rend = mean(rendOcup,na.rm=T)
) %>% arrange(-me_rend)

t_educ <- pnadc_2025 %>% group_by(nvlMaisElevado) %>% summarise(
  n = n(),
  me_rend = mean(rendOcup,na.rm=T),
  ma_rend = median(rendOcup,na.rm=T)
)

## 2.2 Tabelas de frequência ----

tab1 <- table(pnadc_2025$sexo,pnadc_2025$raca)

tab1_prop <- prop.table(tab1,margin = 1) # margin 1 = percentual na linha

# 3. Gráficos ------------------------------------------------------------------

# 4. GGPLOT --------------------------------------------------------------------
# Grammar of Graphics

# Barras
ggplot(data=pnadc_2025,aes(x = sexo))+
  theme_bw()+
  geom_bar(fill="steelblue")+
  scale_y_continuous(expand = c(0.01,0))+
  scale_x_discrete(name="")

# Histograma
ggplot(data=pnadc_2025,aes(x = rendOcup))+
  theme_bw()+
  geom_histogram(bins = 50)+
  scale_x_continuous(limits = c(0,50000),breaks = seq(0,100000,5000))

# Densidade
ggplot(data=pnadc_2025,aes(x = rendOcup))+
  theme_bw()+
  geom_density()+
  scale_x_continuous(limits = c(0,50000),breaks = seq(0,100000,5000))

# Boxplot
ggplot(data=pnadc_2025,aes(x = nvlMaisElevado,y=log(rendOcup)))+
  theme_bw()+
  geom_boxplot(fill="steelblue")+
  coord_flip()

# Dispersão
ggplot(data=pnadc_2025,aes(x = anosEst,y=log(rendOcup)))+
  theme_bw()+
  geom_point()+
  scale_x_continuous(name="Anos de escolarização")+
  scale_y_continuous(name="ln renda")#+
# stat_smooth(aes(x = educ, y = ln_rend), method = "lm",
#             formula = y ~ x, se = FALSE)+
#facet_wrap(~sexo)
