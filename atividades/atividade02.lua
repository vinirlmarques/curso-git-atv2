-- Da forma como foi pedido na atividade, o dano nunca será crítico, visto que
-- o dano máximo é 30 e a defesa é 15 (dano crítico só ocorre se for maior que 20).


-- Status do jogador
playerLife = 100
playerDefense = 15

--Loop de 5 ataques
for i = 1, 5 do
    -- Calcula dano
    damage = math.random(10, 30)

    -- Verifica se foi crítico
    critDamage = false
    if (damage > 20) then
        critDamage = true
    end

    -- Aplica defesa
    damage = damage - playerDefense
    if damage < 0 then
        damage = 0
    end

    -- Imprime resultado do ataque
    print ("O inimigo causou " .. damage .. " de dano!")
    if critDamage then
        print("Dano crítico!")
    end

    -- Aplica dano ao jogador
    playerLife = playerLife - damage
    if playerLife <= 0 then
        print("O jogador foi derrotado!")
        break
    end

    -- Caso o jogador sobreviva, imprime a vida restante
    print ("Vida do jogador: " .. playerLife)
end

-- Se chegou a esse ponto, o jogador sobreviveu
if (playerLife > 0) then
    print("O jogador sobreviveu ao ataque!")
end