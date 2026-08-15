local MoveGenerator = require "move_generators.MoveGenerator"
local BasicMove     = require "moves.BasicMove"

local SingleMoveGenerator = {
    dirs = {},
}

MoveGenerator:extend(SingleMoveGenerator, "SingleMoveGenerator")

function SingleMoveGenerator:new(dirs, can_move, can_capture)
    local out = MoveGenerator.new(self, can_move, can_capture)
    out.dirs = dirs
    return out
end

function SingleMoveGenerator:generate(from, board)
    local piece = MoveGenerator.get_piece(from, board)

    for _, dir in ipairs(self.dirs) do
        local to = from + dir
        local target_piece = board:get(to)

        if self.can_move and target_piece:is_empty() or self.can_capture and piece:is_enemy(target_piece) then
            piece:insert_move(to, BasicMove:new(from, to))
        end
    end
end

return SingleMoveGenerator
