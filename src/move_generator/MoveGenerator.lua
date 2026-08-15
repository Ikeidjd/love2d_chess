local Object = require "Object"
local MoveGenerator = {}

Object:extend(MoveGenerator, "MoveGenerator")

--Doesn't return anything. Instead, it adds to the corresponding piece's moves table
function MoveGenerator:generate(pos, board) end

function MoveGenerator.get_piece(pos, board)
    local piece = board:get(pos)
    assert(not piece:is_empty() and not piece:is_out_of_bounds())
    return piece
end

return MoveGenerator
