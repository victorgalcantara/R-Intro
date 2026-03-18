# Título: Aula 02 - Mão na massa I
# Autor: Victor G Alcantara

x <- 1:5
x

# Removendo informações guaradadas na memória
# Função remove = rm()
rm(exemplo_de_vetor_combinado)

# O R é Case Sensitive: ele é sensível a letras maiúsculas e minúsculas
# Perceba a diferença: ele salva os dois objetos como sendo diferentes
Nomes <- c(letters[6:10])
NoMeS <- c(letters[11:15])

# Recapitulando
# Desafio - Lista de exercícios aula 01 ----
# Autor: Seu nome aqui

# 1. Crie três objetos que guardam vetores com valores 
# de tipos diferentes (numérico, caracteres e lógicos)

renda <- c(1220.20,1500.50,2000,225,10500.5)
idade <- c(18L,21L,25L,32L,65L)
LETRAS <- c(LETTERS[1:5])
letras <- c(letters[11:15])
nomes <- c('Maria Cecília','Daniel','Maria Eduarda','Miguel','Paula')
esquerda <- c(T,T,F,F,T)

exemplo_de_vetor_combinado <- c(renda,idade)
exemplo_de_vetor_combinado

exemplo2_de_vetor_combinado <- c(idade,21L)
exemplo2_de_vetor_combinado

# 2. Verifique se os vetores têm o mesmo comprimento/
# qtd. de valores

length(x = renda)
length(x = idade)
length(x = nomes)
length(x = letras)

# 3. Crie um data.frame/base de dados com os vetores

base_dados_1 <- data.frame(nomes,renda,idade,esquerda,LETRAS,letras)

# 4. Localize o valor guardado na posição 
# seus_dados[2,1] : segunda linha e primeira coluna

# Quando estamos trabalhando com vetores, pegamos a informação apenas inserindo um endereço
renda[ c(2,5) ]

# Diferente, para as bases de dados/data.frame, nós temos que colocar dois endeços (linha, coluna)

base_dados_1[1,1]

# 5. Faça um teste lógico para verificar se o primeiro valor do vetor
# numérico é maior ou igual ao último valor do mesmo vetor.
# Faça para o vetor e para a base de dados

renda[1] >= renda[5]

renda[1]
renda[5]

# 6. Crie uma nova coluna para a sua base de dados
# a quarta coluna deve ser um produto da 
# coluna numérica multiplicada por 2

2+2

renda * 2

base_dados_1[,"coluna_nova"] <- c(renda * 2)

# Outra forma de navegar pela base de dados
base_dados_1$coluna_nova_2 <- c(idade * 2)

# Operação com vetores
base_dados_1$coluna_nova_3 <- c(idade * renda)

# 7. Crie uma nova coluna para a sua base de dados
# a quinta coluna deve ser uma combinação dos valores
# formando a frase:
# O valor X multiplicado por 2 é igual a Y

paste("Os nomes que guardei no objeto são:",nomes)

base_dados_1$coluna_nova_4 <- paste("A renda da pessoa cujo nome é",nomes,"é igual a",renda)

base_dados_1[,"renda"]

base_dados_1$renda

# Exemplos de filtragem da base de dados fictícia usando teste lógico

base_dados_1[ base_dados_1$renda < 1000 ,]

# Operações relacionais

2 < 2 | 2 == 2
2 < 2 & 2 == 2

# Explorando as funções
# Funções são operadores que executam determinado procedimento recebendo um valor de input e retornando um valor output

# Um exemplo de função é data.frame, que recebe como imput vetores de igual tamanho e retorna como output um tipo de objeto reconhecido como base de dados estruturada

data.frame(nomes,renda)

# Quando precisamos criar uma função, fazemos:

nossa_primeira_funcao <- function( x ) { x + 1 }

nossa_primeira_funcao(x = 2)
  
nossa_primeira_funcao(x = c(2,5,7) )

nossa_primeira_funcao(x = base_dados_1$idade )

??base::data.frame
??base::length

