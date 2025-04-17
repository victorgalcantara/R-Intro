# Renda e composição étnico-racial em Cotia-SP - setores censitarios
# Author: Victor Gabriel Alcantara

# 0. Packages and setup --------------------------------------------------------

# To clean memory
rm(list=ls()) # Remove all objects
gc() # Garbage Clean

# install.package(pacman)
library(pacman)
p_load(tidyverse,rio,patchwork,geobr,sf,censobr)

# Work directories
setwd( dirname(rstudioapi::getActiveDocumentContext()$path) )

# 1. Import data ---------------------------------------------------------------

# Population census

data_dictionary(year = 2010,dataset = "tracts")

# Básico
setor_censo_basico <- read_tracts(year = 2010,
                          dataset = "Basico",
                          as_data_frame = T,
                          showProgress = T,cache = T)

basico_cotia <- setor_censo_basico %>% select(code_tract,
                                              name_muni,code_muni,
                                       V002,
                                       V005
                                       ) %>% 
  filter(name_muni == "COTIA") %>% select(!c(name_muni,code_muni))

# Pessoas
setor_censo_pessoas <- read_tracts(year = 2010,
                                  dataset = "Pessoa",
                                  as_data_frame = T,
                                  showProgress = T,cache = T)

pessoas_cotia <- setor_censo_pessoas %>% select(code_tract,code_muni,
                                              pessoa03_V001,pessoa03_V002) %>% 
  filter(code_muni == 3513009) %>% select(!code_muni)

cotia <- merge(basico_cotia,pessoas_cotia,by="code_tract")

# Geo data of SP State
geo_sp <- read_census_tract(code_tract = 35,year = 2010)

# 1. Data imput and merge --------------------------------------

dados_cotia <- cotia %>% 
  rename(
         total_pop  = pessoa03_V001,
         pop_branca = pessoa03_V002,
         me_renda = V005
         ) %>%
  mutate(.,
         me_renda = me_renda*2.83455580,
         # Índice de correção no período 2.83455580 ( IGP-M (FGV) )
         # https://www3.bcb.gov.br/CALCIDADAO/publico/corrigirPorIndice.do?method=corrigirPorIndice
         
         p_branca = (pop_branca / total_pop)  * 100,
         
         p_naobranca = 100 - p_branca
         
  )

# Liberando memória
rm(setor_censo_basico,setor_censo_pessoas)
gc()

dados_cotia <- merge(x = dados_cotia,y = geo_sp,by = "code_tract",all.x = T)

# 2. Data management -------------------------------------------

# Área em km2
for(i in 1:nrow(dados_cotia)){
  print(i)
  coords <- dados_cotia$geom[i,][[1]][[1]][[1]] %>% as.matrix(ncol=2,byrow=T)
  
  # Crie um objeto sf do tipo polígono com sistema de coordenadas WGS84 (EPSG:4326)
  polygon <- st_polygon(list(coords)) %>%
    st_sfc(crs = 4326) %>%
    st_sf()
  
  # Verifique o polígono
  # print(polygon)
  # plot(polygon)
  
  # Converta o sistema de coordenadas para uma projeção métrica 
  # (Ex: EPSG: 3857 - Mercator)
  polygon_m <- st_transform(polygon, crs = 3857)
  
  # Calcule a área em metros quadrados (m²)
  area_m2 <- st_area(polygon_m)
  
  # Converta para quilômetros quadrados (km²)
  area_km2 <- as.numeric(area_m2) / 1e6
  
  # Exiba a área
  dados_cotia[i,'areakm2'] <- area_km2
}

dados_cotia <- mutate(.data = dados_cotia,
                 dens_demo = total_pop / area_km2)

summary(dados_cotia$me_rend)

dados_cotia$me_renda2 <- cut(dados_cotia$me_rend,
                         breaks = c(0,1500,2000,5000,10000,max(dados_cotia$me_rend, na.rm = T)),
                         labels = c("até 1.500", "1.500 - 2.000", 
                                    "2.000 - 5.000","5.000 - 10.000", "maior que 10.000"),
                         ordered_result = T)

dados_cotia$p_naobranca2 <-  cut(dados_cotia$p_naobranca,
                         breaks = c(0,20,30,40,50,max(dados_cotia$p_naobranca, na.rm = T)),
                         labels = c("até 20%", "20% - 30% ", "30% - 40%",
                                    "40% - 50%", "mais que 50%"),
                         ordered_result = T)

n = quantile(dados_cotia$dens_demo,probs = seq(0,1,.25))
dados_cotia$dens_demo2 <- cut(dados_cotia$dens_demo,
                          breaks = c(n),
                          labels = c("1Q", "2Q", "3Q","4Q"),
                          ordered_result = T)

class(dados_cotia)

export(dados_cotia,file = "../../000 - P&R/00 data/cotia_censustract.xlsx")
save(dados_cotia,file = "../../000 - P&R/00 data/cotia_censustract.RDS")

# 2. Plot maps --------------------------------------------------

# We have to remove axis from the ggplot layers
no_axis <- theme(axis.title=element_blank(),
                 axis.text=element_blank(),
                 axis.ticks=element_blank(),
                 title = element_text(size=16),
                 legend.text = element_text(size=10),
                 legend.title = element_text(size=12),
                 )

dados_cotia <- sf::st_as_sf(dados_cotia)
class(dados_cotia)

# Mean of income
map_cotia_renda <- dados_cotia %>% 
  drop_na(me_renda2) %>% 
  ggplot() +
  geom_sf(aes(fill = me_renda2), show.legend = T,color=NA) +
  
  scale_fill_manual(name="Renda média \n em Reais (R$)",
                    values = rev(heat.colors(6, alpha = 1.0)))+
  theme_minimal()+
  labs(title = "Composição Econômica")+
  theme(legend.position = "bottom")+
  no_axis

mp2 <- dados_cotia %>% 
  select(dens_demo2,geom) %>%
  na.exclude() %>% 
  ggplot() +
  geom_sf(aes(fill = dens_demo2),col="white",show.legend = T) +
  scale_fill_manual(values = rev(heat.colors(4, alpha = 1.0)), name="Densidade \n (hab./km2)")+
  labs(title="Densidade demográfica", 
       subtitle = "Setores censitários de SP, 2010",
       size=12,
       caption = "Fonte: IBGE")+
  theme_minimal() +
  no_axis

# Proportion race
map_cotia_raca <- dados_cotia %>% drop_na(p_naobranca2) %>% ggplot() +
  geom_sf(aes(fill = p_naobranca2), show.legend = T,color=NA) +
  scale_fill_manual(name="Percentual \n Pop. Não Branca",
                    values = rev(heat.colors(6, alpha = 1.0)))+
  theme_minimal()+
  labs(title = "Composição étnico-racial")+
  theme(legend.position = "bottom")+
  no_axis

plt_map_renda_raca <- map_cotia_renda + map_cotia_raca+
  plot_annotation(tag_levels = "A")

# Save plot
dev.off()
pdf(file=paste0(wd_out_graph,"map_raca.pdf"),
    width = 10, height = 6)
plot(plt_map_renda_raca)
dev.off()

# Leaflet ----

p_load(leaflet)

# Criar o mapa com a elevação representada por dens_demo e a cor por me_rend
leaflet(dados_cotia) %>%
  addTiles() %>%
  addPolygons(
    fillColor = ~colorFactor("YlOrRd", me_renda2)(me_renda2),  # Cor pela renda média
    weight = 1,
    color = "white",
    fillOpacity = 1.5
  ) %>%
  # addElevation(
  #   zProperty = ~dens_demo,  # Elevação pela densidade demográfica
  #   elevationScale = 1.5,    # Ajuste a escala de elevação conforme necessário
  #   baseColor = "gray"
  # ) %>%
  addScaleBar(position = "bottomleft") %>%
  addMiniMap() %>%
  setView(lng = -46.6, lat = -23.6, zoom = 10)  # Defina o centro do mapa conforme necessário

