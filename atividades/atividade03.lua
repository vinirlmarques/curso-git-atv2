while true do
    -- Solicita email do usuário
    print("Digite um email:")
    email = io.read()

    -- Se o email tem @ ele é valido
    if string.find(email, "@") then

        -- Remove espaços em branco no email
        email = string.gsub(email, " ", "")

        -- Pega o index do @
        atIndex = string.find(email, "@")

        -- Pega o domínio após o @
        dominio = string.sub(email, atIndex + 1, #email)

        -- Pega o usuário antes do @
        usuario = string.sub(email, 1, atIndex - 1)

           
            -- Verifica se o domínio tem um ponto, se  não tiver é inválido
            if not string.find(dominio, "%.") then
                print ("Email inválido, tente novamente (domínio sem ponto). \n ---------")
            else 
                -- Caso o email seja válido, imprime resultado
                print("Email válido!")
                print("Usuário: " .. usuario)
                print("Domínio: " .. dominio)
                print("Email completo: " .. email .. "\n ---------")
            end  
        
    else 
        -- Caso o email não tenha @, é inválido
        print("Email inválido, tente novamente (email sem arroba). \n ---------")
    end
    
    
end