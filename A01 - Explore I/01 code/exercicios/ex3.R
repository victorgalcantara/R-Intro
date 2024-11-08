#Desafio aula 1 R

#Questão 1:

vetor_numerico <- c(20, 21, 42, 10, 53) #vetor numerico
vetor_character <- c("Maria Clara", "Mateus", "Silvana", "Laura", "Ivair") #vetor character
vetor_logico <- c(TRUE, FALSE, TRUE, FALSE, TRUE)

#qUESTÃO 2:
# Verificando o comprimento dos vetores
comprimento_idade <- length(vetor_numerico)
comprimento_nome <- length(vetor_character)
comprimento_logico <- length(vetor_logico)

# Verificando se todos têm o mesmo comprimento
todos_têm_o_mesmo_comprimento <- comprimento_idade == comprimento_nome && comprimento_idade == comprimento_logico
todos_têm_o_mesmo_comprimento
 #Resposta: TRUE

#Questão 3:
dados <- data.frame(
  idade = vetor_numerico,
  nome = vetor_character,
  true_false = vetor_logico
)

print(dados) #exibindo data frame

#Questão 4
# Localizando o valor na posição [2, 1]
valor_localizado <- dados[2, 1]
print(valor_localizado)
valor_localizado <- dados[3, 2]
print(valor_localizado)

#Questão 5:
# Teste lógico para verificar se o primeiro valor é maior ou igual ao último
diferença_valores <- dados$idade[1] >= dados$idade[length(dados$idade)]
print(diferença_valores)
