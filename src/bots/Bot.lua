local Object = require "Object"
local Piece  = require "Piece"

local Bot = {}

Object:extend(Bot, "Bot")

function Bot:get_best_move(color, board, depth) end

function Bot:eval(board) end

function Bot.best_move_and_eval(move1, eval1, move2, eval2, color)
    if eval1 == nil then return move2, eval2 end
    if eval2 == nil then return move1, eval1 end

    if color == Piece.WHITE then
        if eval1 > eval2 then return move1, eval1
        else return move2, eval2 end
    else
        if eval1 < eval2 then return move1, eval1
        else return move2, eval2 end
    end
end

return Bot
