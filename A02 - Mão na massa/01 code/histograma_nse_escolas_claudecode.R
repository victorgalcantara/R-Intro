# Título: Aula 02 - Histograma do NSE das Escolas Brasileiras
# Autor: Victor G Alcantara
# Data: 2026-03-17

# -------------------------------------------------------------------
# O que é o NSE?
# O Nível Socioeconômico (NSE) das escolas é calculado pelo INEP com
# base nas condições de vida e escolaridade das famílias dos alunos.
# Os dados estão em formato CSV na pasta 00 data.
# -------------------------------------------------------------------

# 1. Importando a base de dados ----
# Usamos read.csv() para ler arquivos .csv (valores separados por vírgula)
# O argumento sep = "," indica que o separador de colunas é a vírgula

nse_escolas <- read.csv(
  file = "00 data/CSV/NSE_ESCOLA.csv",
  sep  = ","
)

# Verificando as primeiras linhas da base
head(nse_escolas)

# Verificando os nomes das colunas
names(nse_escolas)

# Dimensões da base: quantas linhas e colunas?
dim(nse_escolas)

# Resumo estatístico da variável NSE
summary(nse_escolas$NSE)

# -------------------------------------------------------------------
# 2. Histograma com funções base do R ----
# A função hist() cria um histograma de uma variável numérica
# -------------------------------------------------------------------

hist(
  x      = nse_escolas$NSE,
  main   = "Distribuição do NSE das Escolas Brasileiras",
  xlab   = "Nível Socioeconômico (NSE)",
  ylab   = "Número de escolas",
  col    = "steelblue",
  border = "white",
  breaks = 40
)

# Adicionando uma linha vertical para a média
abline(
  v   = mean(nse_escolas$NSE, na.rm = TRUE),
  col = "firebrick",
  lwd = 2,
  lty = 2
)

# Adicionando uma legenda
legend(
  x      = "topright",
  legend = paste("Média =", round(mean(nse_escolas$NSE, na.rm = TRUE), 2)),
  col    = "firebrick",
  lwd    = 2,
  lty    = 2,
  bty    = "n"
)

# -------------------------------------------------------------------
# 3. Salvando o gráfico na pasta 02 outp ----
# Usamos png() para abrir um "dispositivo gráfico" que salva em arquivo,
# depois dev.off() para fechar e gravar o arquivo.
# -------------------------------------------------------------------

png(
  filename = "02 outp/histograma_nse_escolas.png",
  width    = 800,
  height   = 500,
  res      = 120
)

hist(
  x      = nse_escolas$NSE,
  main   = "Distribuição do NSE das Escolas Brasileiras",
  xlab   = "Nível Socioeconômico (NSE)",
  ylab   = "Número de escolas",
  col    = "steelblue",
  border = "white",
  breaks = 40
)

abline(
  v   = mean(nse_escolas$NSE, na.rm = TRUE),
  col = "firebrick",
  lwd = 2,
  lty = 2
)

legend(
  x      = "topright",
  legend = paste("Média =", round(mean(nse_escolas$NSE, na.rm = TRUE), 2)),
  col    = "firebrick",
  lwd    = 2,
  lty    = 2,
  bty    = "n"
)

dev.off()

# Mensagem de confirmação
cat("Gráfico salvo em: 02 outp/histograma_nse_escolas.png\n")
