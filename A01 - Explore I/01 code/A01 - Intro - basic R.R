# Introdução ao R - operações básicas ------------------------------------------
# Author: Victor Gabriel Alcantara 
# Github: https://github.com/victorgalcantara 
# LinkedIn: https://www.linkedin.com/in/victorgalcantara/ 

# Recomendações: 

# Livro introdutório "R for data science"
# https://r4ds.had.co.nz/index.html

# Tutorial Leonardo Barone
# https://github.com/leobarone/cebrap_lab_programacao_r

# Parte I - Noções gerais e funções básicas ----------------------------------------------

# 1. R como calculadora ----

2+3      # soma
2*3      # multiplicação
2^2      # potência

# Respeita ordem PEMDAS
# Parenteses> Expoentes > Multiplicação > Divisão > Adição > Subtração
2+2*3

2+2*3^3

# Ordem do cálculo
3 * 3 * 3
3 * 3 * 3 * 2
3 * 3 * 3 * 2 + 2

# Divisão inteira: quanto sobra da divisão
4%%2
3%%2

# No python não tem isso!
# no R, pi já é identificado como um objeto que guarda o valor 3,141593...

pi-2

# 1.2 Introduzindo funções básicas ----

#### Funções ----
# são operações já programadas
# (input-processo-output)
# nome_da_função(argumentos)

# Exemplo de funções
# argumentos = input

ifelse(test = 2>3,yes = "Que isso?",no ="Ah, tá.")
ifelse # Veja como essa função está programada

# Como vimos em aula, usamos funções para executar operações
# alguns cálculos são feitos com funções, como:

sqrt(16) # raíz quadrada / square roots

exp(1)   # exponencial - padrão: n de euler (e)

log(x = 10)  # logarítmo

log2(16)

2^4

# 2. Criando objetos (ou guardado valores na memória) ----

x <- 2
x = 3

x+3

x <- 1:16
y <- sqrt(1:16)

# Funções básicas para plot de gráficos
plot(x = x,y = y)
lines(x,y)

# PULO PARA BASE DE DADOS

## 1. Vetores ----
# Def.: coleção ordenada de dados de mesma classe/tipo
# Propriedades: nome, tipo/classe, elementos, dimensão

# 0. Unidade básica no R
# 1. Apenas uma dimensão
# 2. Só aceita uma classe (núm, char, logi)
# 3. Default: string sobrepõe

j <- c(1.20,3.2,2.2,3.4)
x <- c(2L,4L,4L,6L)
y <- c("Fulano","Ciclano","Beltrano","Tetrano")
z <- c(TRUE,FALSE,TRUE,FALSE)

# Funções para olhar classe e tipo dos vetores (CLASSE = TIPO)
# Função class para verificar a classe do vetor
class(j)
class(x)
class(y)
class(z)

# Função typeof para verificar tipo do vetor
typeof(j)
typeof(x)
typeof(y)
typeof(z)

# verificar se aparece mais abaixo no exercício
TRUE + TRUE
FALSE + FALSE
TRUE + FALSE

# O que acontece se unir valores de diferentes qualidades
# em um único vetor?

t <- c(1,2,"Fulano",FALSE)
class(t)

w <- c(j,x,y,z)
w # observe o que compõe o vetor "w"
class(w)

# o que aconteceria se tudo fosse transformado para número?
w <- as.numeric(w)
w

# Factor: é um tipo de vetor que guarda valores categóricos
# possibilitando a ordenação 

# Exemplo
a <- c("Bom","Ruim","Regular","Péssimo")

a <- factor(x = a,levels=c("Péssimo","Ruim","Regular","Bom"), ordered=TRUE)

a
levels(a)

# Outro exemplo
b <- c(0,1,2,3)

b <- factor(x=b,
            levels = c(0,1,2,3),
            labels = c("Péssimo","Ruim","Regular","Bom"),
            ordered = TRUE
)

b
levels(b)

# Agora podemos fazer algumas operações com factor
min(a)
max(a)

## 2. Data frame ----
# Def.: coleção de vetores de mesma dimensão que guardam infos
# Propriedades: dim e str
# 0. Dados estruturados em observações x variáveis (survey)

idad  <- c(65,74,21,24,27,34,24,23)
educ  <- c(2,2,12,14,12,16,14,14)
rend  <- c(1200,1600,1800,2200,1800,6400,2300,2500)
sexo  <- c("M","F","F","M","F","M","F","M")
raca  <- c("Branca","Parda","Preta","Parda","Preta","Branca",
           "Parda","Amarela")

d <- data.frame(educ, idad, rend,sexo,raca)
View(d)

# 3. Verbos importantes ----
# Visualizar dados - fluxo de trabalho

class(d)  # classe do objeto
dim(d)    # dimensão da base (linhas x colunas)
head(d,n = 6)   # Primeiros 6 casos
tail(d,n = 6)   # Últimos 6 casos
str(d)    # Estrutura dos dados

# sumário das variáveis
summary(d)      
summary(d$rend) # sumário de uma variável numérica
summary(d$sexo) # sumário de uma variável categórica

# 3. Operações lógicas ----
# São operações em testamos uma sentença tendo como resultado:
# TRUE (T) ou FALSE (F)

2 >  2  # MAIOR QUE
2 < 2   # MENOR QUE
2 == 3  # IGUALDADE

2 >= 2 # MAIOR OU IGUAL

# Por quê igualdade são dois sinais?
# R: Porque apenas um significa atribuição de valor. Igual a setinha.

x = 1:10
x <- 1:10

"eu" == "todo mundo" # Igualdade
"eu" == "eu"
"eu" != "vc"         # Diferença

# Teste em grupo
"eu" %in% c("vc","todo mundo") # Generalização - se contém

# Nota importante: "!" opera como um sinal de negação/diferença

!("eu" %in% c("vc","todo mundo"))

# 4. Relações "OU" e "E" ----
# "|" para "OU"
2 > 2 | 2 == 2
2 > 2 | 2 < 2

# "&" para "E"
2 > 2 & 2 == 2
2 > 1 & 2 == 2

# Desafios ----

# 1. Crie três objetos que guardam vetores com valores 
# de tipos diferentes (numérico, caracteres e lógicos)

# 2. Verifique se os vetores têm a mesma quantidade de valores

# 3. Crie um data.frame/base de dados com os vetores

# 4. Localize o valor guardado na posição 
# seus_dados[2,1] : segunda linha e terceira coluna

# 5. Faça um teste lógico para verificar se o primeiro valor do vetor
# numérico é maior ou igual ao último valor do vetor numérico da sua
# base de dados

