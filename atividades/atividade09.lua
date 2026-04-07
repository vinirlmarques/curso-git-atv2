-- Import the auxiliary functions for the Battleship game
local aux = require("atividades.utils_atividade09")

isDevMode = false -- Set to true to reveal ship positions on the enemy board (for testing purposes)



-- BOARD FUNCTIONS --

-- Create a board
function createBoard(size)
    local board = {}
    for i = 1, size do
        board[i] = {}
        for j = 1, size do
            aux.setCell(board, i, j, "~")
        end
    end
    return board
end

-- Print both boards
function printBoards(playerBoard, enemyBoard)
    local size = #playerBoard
    local cols = #playerBoard[1]
    
    -- Titles
    io.write("     MY BOARD")
    io.write("                       ")
    io.write("ENEMY BOARD\n")
    
    -- Column headers
    io.write("  ")
    for j = 1, cols do
        io.write(aux.numberToLetter(j) .. " ")
    end
    io.write("               ")
    for j = 1, cols do
        io.write(aux.numberToLetter(j) .. " ")
    end
    io.write("\n")
    
    -- Rows of the boards
    for i = 1, size do
        -- Player board
        io.write(i .. " ")
        for j = 1, cols do
            io.write(aux.formatPlayerCell(aux.getCell(playerBoard, i, j)) .. " ")
        end
        
        io.write("             ")
        
        -- Enemy board
        io.write(i .. " ")
        for j = 1, cols do
            io.write(aux.formatEnemyCell(aux.getCell(enemyBoard, i, j), isDevMode) .. " ")
        end
        io.write("\n")
    end
end



-- POSITION FUNCTIONS --

-- Transforms the position from letter+number format to row and col
function transformPosition(position)
    -- Get the letter and number from the position
    local letter = string.sub(position, 1, 1)
    local number = tonumber(string.sub(position, 2))

    -- Check if a letter and a number were actually passed
    if not letter or not number then
        return nil, nil, "Position must contain a letter followed by a number."
    end

    -- Transform the letter into a column number
    local col = aux.letterToNumber(letter)

    -- Check if the letter is valid
    if not col then
        return nil, nil, "Position must start with a valid letter."
    end

    return number, col, nil
end

-- Validates the position for placing a ship
function validatePosition(board, row, col, action)
    -- If the column or row is out of the board, return error
    if col < 1 or col > #board[1] then
        return false, "Column out of board."
    end
    if row < 1 or row > #board then
        return false, "Row out of board."
    end

    -- Actions for ship placement
    if action == "place" then
        -- If there is already a ship in this position, return error
        if aux.getCell(board, row, col) == "S" then
            return false, "There is already a ship in this position."
        end
    end

    -- Actions for attack
    if action == "attack" then
        -- If this position has already been attacked, return error
        if (aux.getCell(board, row, col) == "O" or aux.getCell(board, row, col) == "X") then
            return false, "Position already attacked."
        end
    end
    return true, " "
end

-- Inserts a ship
function placeShip(targetBoard, position)
    -- Transform the position into row and col
    local row, col, err = transformPosition(position)
    if err then
        io.write(err)
        return false
    end

    -- Validate the position before placing the ship
    local valid, message = validatePosition(targetBoard, row, col, "place")
    if not valid then
        io.write(message)
        return false
    end

    -- Place the ship at the position
    aux.setCell(targetBoard, row, col, "S")
    return true
end

-- Attacks the given position
-- targetBoard: board to be attacked
function attackPosition(targetBoard, position)
    -- Transform the position into row and col
    local row, col, err = transformPosition(position)
    if err then
        io.write(err)
        return false
    end

    -- Validate the position before attacking
    local valid, err = validatePosition(targetBoard, row, col, "attack")
    if not valid then
        io.write(err)
        return false
    end

    -- Attack the position
    if aux.getCell(targetBoard, row, col) == "S" then
        aux.setCell(targetBoard, row, col, "O")  -- Hit ship
        return true, true
    else
        aux.setCell(targetBoard, row, col, "X")  -- Miss
        return true, false
    end
end



-- PLAYER FUNCTIONS --

-- Function for the player to place their ships
function playerPlaceShips()
    print("Place your " .. numShips .. " ships:")
    local i = 1
    while i <= numShips do
        printBoards(player.board, enemy.board)
        print("Ship " .. i .. " of " .. numShips)
        io.write("Enter the position (e.g., A1): ")
        local position = io.read()
        local success = placeShip(player.board, position)
        if success then
            i = i + 1
        else
            print(" Try again.")
        end
    end
end

-- Function for the player to attack
function playerAttack(enemyBoard, position)
    local valid, hit = attackPosition(enemyBoard, position)
    if not valid then
        return false, nil
    end
    if hit then
        print("You attacked " .. position .. " and hit a ship!")
        aux.setScore(player, aux.getScore(player) + 1)
    else
        print("You attacked " .. position .. " and missed.")
        aux.setMisses(player, aux.getMisses(player) + 1)
    end
    print("Your attacks: " .. aux.getScore(player) .. " hits, " .. aux.getMisses(player) .. " misses")
    return true, checkWin(aux.getScore(player), numShips, "You")
end



-- ENEMY FUNCTIONS --

-- Function for the enemy to place ships randomly
function enemyPlaceShips(enemyBoard)
    local placed = false
    while not placed do
        -- Generates a random position for the enemy's ship
        local row = math.random(1, #enemyBoard)
        local col = math.random(1, #enemyBoard[1])
        
        -- Checks if the position already has a ship
        if aux.getCell(enemyBoard, row, col) ~= "S" then
            local position = aux.numberToLetter(col) .. row
            -- Places the ship in the generated position
            placeShip(enemyBoard, position)
            placed = true
        end
    end
end

-- Function for the enemy to attack
function enemyAttack(playerBoard)
    -- Generates a random position that has not been attacked yet
    local row = math.random(1, #playerBoard)
    local col = math.random(1, #playerBoard[1])
    
    -- Ensures that the generated position has not been attacked yet
    while aux.getCell(playerBoard, row, col) == "O" or aux.getCell(playerBoard, row, col) == "X" do
        row = math.random(1, #playerBoard)
        col = math.random(1, #playerBoard[1])
    end
    
    local position = aux.numberToLetter(col) .. row

    -- Attacks the generated position (enemy attacks MY board)
    local valid, hit = attackPosition(playerBoard, position)
    if hit then
        print("Enemy attacked " .. position .. " and hit a ship!")
        aux.setScore(enemy, aux.getScore(enemy) + 1)
    else
        print("Enemy attacked " .. position .. " and missed.")
        aux.setMisses(enemy, aux.getMisses(enemy) + 1)
    end
    print("Enemy attacks: " .. aux.getScore(enemy) .. " hits, " .. aux.getMisses(enemy) .. " misses")
    return checkWin(aux.getScore(enemy), numShips, "Enemy")
end



-- GAME FUNCTIONS --

-- Checks if the player has won
function checkWin(score, numShips, player)
    if score >= numShips then
        print(player .. " won the game!")
        return true
    end
    return false
end

-- Initializes the game
function initializeGame()
    -- Initializes the players
    player = {
        board = createBoard(8),
        score = 0,
        misses = 0
    }
    enemy = {
        board = createBoard(8),
        score = 0,
        misses = 0
    }

    -- Number of ships
    numShips = 5

    -- Places enemy ships
    for i = 1, numShips do
        enemyPlaceShips(enemy.board)
    end
end

-- Game loop
function gameLoop()
    local gameOver = false
    
    while not gameOver do
        printBoards(player.board, enemy.board)
        print("\nScore: You " .. aux.getScore(player) .. " x " .. aux.getScore(enemy) .. " Enemy")
        
        -- Player's turn
        local validAttack = false
        while not validAttack do
            io.write("\nEnter the position to attack (e.g., A1): ")
            local position = io.read()
            
            local success, result = playerAttack(enemy.board, position)
            
            if success then
                validAttack = true
                if result then
                    gameOver = true
                    break
                end
            else
                print(" Try again.")
            end
        end
        
        if not gameOver then
            -- Enemy's turn
            print("")
            if enemyAttack(player.board) then
                gameOver = true
            end
        end
        
        print("\n" .. string.rep("-", 40) .. "\n")
    end
    
    printBoards(player.board, enemy.board)
    print("\n=== GAME OVER ===")
    print("You: " .. aux.getScore(player) .. " hits, " .. aux.getMisses(player) .. " misses")
    print("Enemy: " .. aux.getScore(enemy) .. " hits, " .. aux.getMisses(enemy) .. " misses")
end

-- Core
function main()
    math.randomseed(os.time())
    
    print("=== BATTLESHIP ===\n")
    
    initializeGame()
    playerPlaceShips()
    
    print("\n=== STARTING THE GAME ===\n")
    gameLoop()
end

main()