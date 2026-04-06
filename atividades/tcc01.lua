-- Cria o tabuleiro do jogo
function createBoard(size)
    local board = {}
    for i = 1, size do
        board[i] = {}
        for j = 1, size do
            board[i][j] = "~" 
        end
    end
    return board
end

-- Função auxiliar para formatar uma célula
local function formatCell(cell)
    if cell == "~" or cell == "S" then
        return "?"
    elseif cell == "O" then
        return "O"
    elseif cell == "X" then
        return "X"
    end
    return "?"
end

-- Imprime ambos os tabuleiros lado a lado
function printBoards(playerBoard, enemyBoard)
    local size = #playerBoard
    local cols = #playerBoard[1]
    
    -- Títulos
    io.write("   MEU TABULEIRO")
    io.write("        ")
    io.write("TABULEIRO INIMIGO\n")
    
    -- Cabeçalho das colunas
    io.write("  ")
    for j = 1, cols do
        io.write(string.char(64 + j) .. " ")
    end
    io.write("               ")
    for j = 1, cols do
        io.write(string.char(64 + j) .. " ")
    end
    io.write("\n")
    
    -- Linhas dos tabuleiros
    for i = 1, size do
        -- Meu tabuleiro
        io.write(i .. " ")
        for j = 1, cols do
            io.write(formatCell(playerBoard[i][j]) .. " ")
        end
        
        io.write("             ")
        
        -- Tabuleiro inimigo
        io.write(i .. " ")
        for j = 1, cols do
            io.write(formatCell(enemyBoard[i][j]) .. " ")
        end
        io.write("\n")
    end
end


-- Insere navio na posição passada
function placeShip(board, position)
    -- Transforma a posição em row e col
    local row, col, err = transformPosition(position)
    if err then
        error(err)
        return
    end

    -- Valida a posição antes de colocar o navio
    local valid, message = validatePosition(board, row, col, "place")
    if not valid then
        error(message)
        return
    end

    -- Coloca o navio na posição
    board[row][col] = "S"
end

-- Ataca a posição passada
-- targetBoard: tabuleiro a ser atacado (se eu ataco, é o tabuleiro inimigo; se inimigo ataca, é o meu)
function attackPosition(targetBoard, position)
    -- Transforma a posição em row e col
    local row, col, err = transformPosition(position)
    if err then
        error(err)
        return
    end

    -- Valida a posição antes de atacar
    local valid, message = validatePosition(targetBoard, row, col, "attack")
    if not valid then
        error(message)
        return
    end

    -- Ataca a posição
    if targetBoard[row][col] == "S" then
        targetBoard[row][col] = "O"  -- Acertou navio
        return true
    else
        targetBoard[row][col] = "X"  -- Água
        return false
    end
end

-- Transforma a posição do formato letra+numero para row e col
function transformPosition(position)
    -- Pega a letra e o número da posição
    local letter = string.sub(position, 1, 1)
    local number = tonumber(string.sub(position, 2))

    -- Verifica se de fato foi passado uma letra e um número
    if not letter or not number then
        return nil, nil, "Posição deve conter uma letra seguida de um número."
    end

    -- Verifica se a letra é letra
    if not letter:match("%a") then
        return nil, nil, "Posição deve começar com uma letra."
    end

    -- Transforma a letra em número (coluna)
    local col = string.byte(string.upper(letter)) - 64

    return number, col, nil
end

-- Valida a posição para colocar o navio
function validatePosition(board, row, col, action)
    -- Se a coluna ou a linha estiver fora do tabuleiro, retorna erro
    if col < 1 or col > #board[1] then
        return false, "Coluna fora do tabuleiro."
    end
    if row < 1 or row > #board then
        return false, "Linha fora do tabuleiro."
    end

    -- Ações para caso de posição de navio
    if action == "place" then
        -- Se já existe um navio nessa posição, retorna erro
        if board[row][col] == "S" then
            return false, "Já existe um navio nessa posição."
        end
    end

    -- Ações para caso de ataque
    if action == "attack" then
        -- Se já foi atacada essa posição, retorna erro
        if (board[row][col] == "O" or board[row][col] == "X") then
            return false, "Posição já atacada."
        end
    end
    return true, " "
end

-- Verifica se o jogador venceu
function checkWin(score, numShips, player)
    if score >= numShips then
        print(player .. " venceu o jogo!")
        return true
    end
    return false
end

-- Função para o inimigo atacar
function enemyAttack(playerBoard)
    -- Gera posição aleatória que ainda não foi atacada
    local row, col, position
    repeat
        row = math.random(1, #playerBoard)
        col = math.random(1, #playerBoard[1])
    until playerBoard[row][col] ~= "O" and playerBoard[row][col] ~= "X"
    
    position = string.char(64 + col) .. row

    -- Ataca a posição gerada (inimigo ataca MEU tabuleiro)
    local hit = attackPosition(playerBoard, position)
    if hit then
        print("Inimigo atacou " .. position .. " e acertou um navio!")
        enemyScore = enemyScore + 1
    else
        print("Inimigo atacou " .. position .. " e errou.")
        enemyMisses = enemyMisses + 1
    end
    print("Ataques do inimigo: " .. enemyScore .. " acertos, " .. enemyMisses .. " erros")
    return checkWin(enemyScore, numShips, "Inimigo")
end

-- Função para o jogador atacar
function playerAttack(enemyBoard, position)
    local hit = attackPosition(enemyBoard, position)
    if hit then
        print("Você atacou " .. position .. " e acertou um navio!")
        playerScore = playerScore + 1
    else
        print("Você atacou " .. position .. " e errou.")
        playerMisses = playerMisses + 1
    end
    print("Seus ataques: " .. playerScore .. " acertos, " .. playerMisses .. " erros")
    return checkWin(playerScore, numShips, "Você")
end

-- Função para o inimigo colocar seus navios aleatoriamente
function enemyPlaceShip(enemyBoard)
    local placed = false
    while not placed do
        -- Gera posição aleatória para o navio do inimigo
        local row = math.random(1, #enemyBoard)
        local col = math.random(1, #enemyBoard[1])
        
        -- Verifica se a posição já tem navio
        if enemyBoard[row][col] ~= "S" then
            local position = string.char(64 + col) .. row
            -- Coloca o navio na posição gerada
            placeShip(enemyBoard, position)
            placed = true
        end
    end
end

-- Inicializa o jogo
function initializeGame()
    -- Inicializa os tabuleiros
    playerBoard = createBoard(8)
    enemyBoard = createBoard(8)

    -- Score (acertos)
    playerScore = 0
    enemyScore = 0

    -- Erros
    playerMisses = 0
    enemyMisses = 0

    -- Numero de navios
    numShips = 5

    -- Coloca navios do inimigo
    for i = 1, numShips do
        enemyPlaceShip(enemyBoard)
    end
end

-- Função para o jogador colocar seus navios
function playerPlaceShips()
    print("Coloque seus " .. numShips .. " navios:")
    local i = 1
    while i <= numShips do
        printBoards(playerBoard, enemyBoard)
        print("Navio " .. i .. " de " .. numShips)
        io.write("Digite a posição (ex: A1): ")
        local position = io.read()
        local success, err = pcall(function()
            placeShip(playerBoard, position)
        end)
        if success then
            i = i + 1
        else
            print("Erro: " .. tostring(err))
        end
    end
end

-- Loop de jogadas
function gameLoop()
    local gameOver = false
    
    while not gameOver do
        printBoards(playerBoard, enemyBoard)
        print("\nPlacar: Você " .. playerScore .. " x " .. enemyScore .. " Inimigo")
        
        -- Turno do jogador
        io.write("Digite a posição para atacar (ex: A1): ")
        local position = io.read()
        
        local success, result = pcall(function()
            return playerAttack(enemyBoard, position)
        end)
        
        if not success then
            print("Erro: " .. tostring(result))
        else
            if result then
                gameOver = true
                break
            end
            
            -- Turno do inimigo
            print("")
            if enemyAttack(playerBoard) then
                gameOver = true
            end
        end
        
        print("\n" .. string.rep("-", 40) .. "\n")
    end
    
    printBoards(playerBoard, enemyBoard)
    print("\n=== FIM DE JOGO ===")
    print("Você: " .. playerScore .. " acertos, " .. playerMisses .. " erros")
    print("Inimigo: " .. enemyScore .. " acertos, " .. enemyMisses .. " erros")
end

-- Core
function main()
    math.randomseed(os.time())
    
    print("=== BATALHA NAVAL ===\n")
    
    initializeGame()
    playerPlaceShips()
    
    print("\n=== COMEÇANDO O JOGO ===\n")
    gameLoop()
end

main()