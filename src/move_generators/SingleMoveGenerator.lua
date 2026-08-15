local MoveGenerator = require "move_generators.MoveGenerator"
local BasicMove     = require "moves.BasicMove"

local SingleMoveGenerator = {
    dirs = {},
}

MoveGenerator:extend(SingleMoveGenerator, "SingleMoveGenerator")

function SingleMoveGenerator:new(dirs)
    return MoveGenerator.new(self, {
        dirs = dirs,
    })
end

function SingleMoveGenerator:generate(from, board)
    local piece = MoveGenerator.get_piece(from, board)

    for _, dir in ipairs(self.dirs) do
        local to = from + dir
        local target_piece = board:get(to)

        if target_piece:is_empty() or piece:is_enemy(target_piece) then
            piece:insert_move(to, BasicMove:new(from, to))
        end
    end
end

return SingleMoveGenerator
