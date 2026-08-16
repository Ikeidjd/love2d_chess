local Object = require "Object"
local Piece  = require "Piece"

local Bot = {}

Object:extend(Bot, "Bot")

function Bot:get_best_move(color, board, depth)
    local move = self:get_best_eval(color, board, depth, -1 / 0, 1 / 0)
    return move
end

function Bot:get_best_eval(color, board, depth, alpha, beta) end

function Bot:eval(color, board) end

return Bot
