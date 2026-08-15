local Object = require "Object"

local MoveGenerator = {
    can_move = true,
    can_capture = true,
}

Object:extend(MoveGenerator, "MoveGenerator")

function MoveGenerator:new(can_move, can_capture)
    return Object.new(self, {
        can_move = can_move,
        can_capture = can_capture,
    })
end

--Doesn't return anything. Instead, it adds to the corresponding piece's moves table
function MoveGenerator:generate(pos, board) end

function MoveGenerator.get_piece(pos, board)
    local piece = board:get(pos)
    assert(not piece:is_empty() and not piece:is_out_of_bounds())
    return piece
end

return MoveGenerator
