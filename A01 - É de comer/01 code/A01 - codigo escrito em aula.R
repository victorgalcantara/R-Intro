# Nosso primeiro script da aula 01
# Autor: Victor G Alcantara

# Vamos escrever nossos códigos aqui

# Exporando o R como uma grande calculadora

2+2

# victor

x <- 1
x

x = 2
x

y = 3

x <- c(1,2,3,4,5)

nome <- "Victor Gabriel Alcantara"

nomes <- c("Victor","Maria Cecília","Anna","Miguel","Maria Eduarda")

# Função para pedir ao R em qual pasta estamos trabalhando
getwd()

# Função para definir ao R em qual pasta quero trabalhar
setwd("C:/Users/victo/OneDrive/02 - GitHub/R-Intro")

# Pedindo novamente a função para ver se estamos na pasta correta
getwd()

# Função para listar as pastas e arquivos do nosso diretório principal
dir()

# Criando pastas no nosso diretório
dir.create("0 - Anexos")

# Utilizando a função paste e paste0 para criar frases com objetos
paste("A informação guardada em Y é ",y)

paste("Os nomes que aparecem na minha tela são:",nomes)

minha_pasta_do_curso <- c("C:/Users/victo/OneDrive/02 - GitHub/R-Intro")

setwd(minha_pasta_do_curso)

novo_diretorio <- paste(minha_pasta_do_curso,"/A01 - É de comer")

# Erro no caminho do diretório: um espaço foi adicionado
setwd(novo_diretorio)

novo_diretorio_2 <- paste0(minha_pasta_do_curso,"/A01 - É de comer")

setwd(novo_diretorio_2)

getwd()

dir()

# Criando o nosso primeiro vetor de informações

x <- c(1,2,3,4,5)
x <- c(1:5)

y <- c('V','M','C','J','K')

b <- c(1,"V",7,"C")
b

class(x)
typeof(x)

decimais <- c(1.25,5.65,7.35,9.5,10)

# Criando a nossa base de dados fictícia

# Vetor de nomes, do tipo caracteres (chr)
nome <- c("Carlos","Maria","Renata","Cleber","Joana")

# Vetor de idade, do tipo numérico (num)
idade <- c(18L,14L,45L,16L,33L)

# Vetor de posicionamento político à esquerda, do tipo lógico
renda <- c(1500.30,225.20,1900,3800.1,10000)

# Navegando entre as informações guaradadas nos vetores
nome[5]

# verificando o tipo/classe dos vetores
class(nome)
class(idade)
class(renda)

base_dados_1 <- data.frame(nome_1 = nome, idade_1 = idade, renda_1 = renda)

valor_base_dados <- base_dados_1[1,2]
valor_base_dados

View(base_dados_1)

base_dados_2 <- data.frame(coluna1 = 1:1000,coluna2 = 1000:2000)

coluna_1 <- 1:1000
coluna_2 <- 1000:1999

base_dados_2 <- data.frame(coluna1 = 1:1000,coluna2 = 1000:1999)

head(base_dados_2)

tail(base_dados_2)

base_dados_1[,2] + base_dados_1[,3]

base_dados_1[,2] * 2

base_dados_1[,"produto_1"] = base_dados_1[,2] * 2

# Parte lógica

3 > 1 

3 < 1

3 == 1

3 == "Victor"

"Victor" == "Victor"

coluna_testes_logicos <- c(FALSE,TRUE,TRUE,FALSE,TRUE)

base_dados_1

base_dados_1[,"valores_logicos"] <- coluna_testes_logicos

base_dados_1$valores_logicos

# Continuando com os testes lógicos

3 >= 1
3 != 1
3 %in% c(1:5)

3 <= 1
3 == 1
3 %in% c(6:10)

renda
length(renda)
length(idade)
length(nomes)

data.frame(renda,idade,nome)

novo_objeto <- c(1:10)

data.frame(renda,idade,nome,novo_objeto)

data.frame(idade,novo_objeto)


