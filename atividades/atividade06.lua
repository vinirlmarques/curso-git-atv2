-- Lista de usuários
users = {
    {
        name = "Vinicius",
        age = 25,
    },
    {
        name = "Maria",
        age = 30,
    },
    {
        name = "João",
        age = 20,
    }
}

-- Valida usuário
function validateUser(user)
    -- Verifica se o usuário tem nome e idade
    if user.age <= 18 then
        return false, "Usuário " .. user.name .. " é menor de idade."
    end
    -- Verifica se o nome do usuário tem pelo menos 4 caracteres
    if #user.name < 4 then
        return false, "Usuário " .. user.name .. " tem nome muito curto."
    end

    -- Se o usuário passou por todas as validações, retorna verdadeiro
    return true, "Usuário " .. user.name .. " é válido."
end
    
-- Cria usuário
function createUser(name, age)

    -- Verifica se o nome e a idade foram fornecidos
    if not name or not age then
        error("Nome e idade são obrigatórios para criar um usuário.")
        return
    end

    user = {
        name = name,
        age = age
    }

    -- Valida o usuário antes de adicioná-lo à lista
    valid, message = validateUser(user)
    if not valid then
        error(message)
        return
    end

    -- Se o usuário for válido, adiciona à lista
    table.insert(users, user)
    print("Usuário " .. name .. " criado com sucesso!")
end

-- Exclui usuário por índice
function deleteUser(index)
    -- Verifica se o índice é válido
    if index < 1 or index > #users then
        error("Índice inválido para exclusão de usuário.")
        return
    end

    -- Remove o usuário da lista
    table.remove(users, index)
    print("Usuário na posição " .. index .. " excluído com sucesso!")
end

-- Imprime lista de usuários
function printUsers()
    print("\nLista de usuários:")
    for i, user in pairs(users) do
        print(i .. " - Nome: " .. user.name .. " - Idade: " .. user.age)
    end
end



printUsers()
createUser("Carlin", 22)
printUsers()
deleteUser(2)
printUsers()

