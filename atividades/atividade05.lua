-- Cria matriz 3x3 vazia
matriz = {
    {'.', '.', '.'},
    {'.', '.', '.'},
    {'.', '.', '.'}
}

-- Jogador e posicionamento
jogador = {
    nome = "Jogador",
    x = 2,
    y = 2
}

-- Insere jogador na matriz
matriz[jogador.x][jogador.y] = 'P'

-- Mostrando matriz com posição do jogador no centro
print("Matriz inicial:")
for i, line in pairs(matriz) do
    for i, column in pairs(line) do
        io.write(column)
    end
    print()
end

-- Simulando movimento do jogador
matriz[jogador.x][jogador.y] = '.'
jogador.x = 1
jogador.y = 1
matriz[jogador.x][jogador.y] = 'P'

-- Mostrando matriz com nova posição do jogador
print("\nMatriz após movimento do jogador:")
for i, line in pairs(matriz) do
    for i, column in pairs(line) do
        io.write(column)
    end
    print()
end
