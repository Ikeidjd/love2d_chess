local MoveGenerator = require "move_generators.MoveGenerator"
local BasicMove     = require "moves.BasicMove"

local SlidingMoveGenerator = {
    dirs = {},
}

MoveGenerator:extend(SlidingMoveGenerator, "SlidingMoveGenerator")

function SlidingMoveGenerator:new(dirs)
    return MoveGenerator.new(self, {
        dirs = dirs,
    })
end

function SlidingMoveGenerator:generate(from, board)
    local piece = MoveGenerator.get_piece(from, board)

    for _, dir in ipairs(self.dirs) do
        local to = from + dir

        while board:is_empty(to) do
            piece:insert_move(to, BasicMove:new(from, to))
            to = to + dir
        end

        if piece:is_enemy(board:get(to)) then
            piece:insert_move(to, BasicMove:new(from, to))
        end
    end
end

return SlidingMoveGenerator
