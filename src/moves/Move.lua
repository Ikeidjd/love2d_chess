local Object = require "Object"

local Move = {}

Object:extend(Move, "Move")

function Move:perform(board) end

return Move
