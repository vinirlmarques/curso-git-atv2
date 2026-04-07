-- Utility functions for Exercise 09 (Battleship Game)
local aux = {}

-- Transforms letter (A-Z) to number (1-26)
function aux.letterToNumber(letter)
    local letters = {
        ["A"] = 1, ["B"] = 2, ["C"] = 3, ["D"] = 4, ["E"] = 5,
        ["F"] = 6, ["G"] = 7, ["H"] = 8, ["I"] = 9, ["J"] = 10,
        ["K"] = 11, ["L"] = 12, ["M"] = 13, ["N"] = 14, ["O"] = 15,
        ["P"] = 16, ["Q"] = 17, ["R"] = 18, ["S"] = 19, ["T"] = 20,
        ["U"] = 21, ["V"] = 22, ["W"] = 23, ["X"] = 24, ["Y"] = 25,
        ["Z"] = 26
    }
    return letters[string.upper(letter)] or nil
end

-- Transforms number (1-26) to letter (A-Z)
function aux.numberToLetter(num)
    local letters = {
        [1] = "A", [2] = "B", [3] = "C", [4] = "D", [5] = "E",
        [6] = "F", [7] = "G", [8] = "H", [9] = "I", [10] = "J",
        [11] = "K", [12] = "L", [13] = "M", [14] = "N", [15] = "O",
        [16] = "P", [17] = "Q", [18] = "R", [19] = "S", [20] = "T",
        [21] = "U", [22] = "V", [23] = "W", [24] = "X", [25] = "Y",
        [26] = "Z"
    }
    return letters[num] or "?"
end

-- Format player board cell for display (always shows real values)
function aux.formatPlayerCell(cell)
    if cell == "~" or cell == "S" then
        return cell
    elseif cell == "O" then
        return "O"
    elseif cell == "X" then
        return "X"
    end
    return "?"
end

-- Format enemy board cell for display (respects devMode)
function aux.formatEnemyCell(cell, isDevMode)
    if cell == "~" or cell == "S" then
        if isDevMode then
            return cell
        end
        return "?"
    elseif cell == "O" then
        return "O"
    elseif cell == "X" then
        return "X"
    end
    return "?"
end

-- Get cell value from board
function aux.getCell(board, row, col)
    return board[row][col]
end

-- Set cell value on board
function aux.setCell(board, row, col, value)
    board[row][col] = value
end

-- Get score from entity (player or enemy)
function aux.getScore(entity)
    return entity.score
end

-- Set score on entity (player or enemy)
function aux.setScore(entity, value)
    entity.score = value
end

-- Get misses from entity (player or enemy)
function aux.getMisses(entity)
    return entity.misses
end

-- Set misses on entity (player or enemy)
function aux.setMisses(entity, value)
    entity.misses = value
end

return aux
