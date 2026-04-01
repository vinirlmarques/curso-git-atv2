-- Cria uma lista com 5 elementos
list = {3, 2 , 6, 7, 1}

-- Imprime o primeiro e o último elemento da lista
print ("Primeiro elemento: " .. list[1])
print ("Último elemento: " .. list[#list])

-- Modifica o segundo e o quarto elemento da lista
list[2] = 8
list[4] = 9

-- Insere novo número com o table.insert
table.insert(list, 15)

-- Imprime a lista completa usando um loop
print ("Lista completa:")
for position in pairs(list) do
    print ("Elemento " .. position .. ": " .. list[position])
end

-- Ultima etapa
-- Criar variavel com numero
var = 10

-- Adicionar a lista
table.insert(list, var)

-- Trocar valor da variavel
var = 20

-- Mostrar que o valor da variavel na lista não mudou
print ("Valor da variável: " .. var)
print ("Valor da variável na lista: " .. list[#list])