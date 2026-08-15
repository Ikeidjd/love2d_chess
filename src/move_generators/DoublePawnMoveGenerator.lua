local MoveGenerator = require "move_generators.MoveGenerator"
local BasicMove     = require "moves.BasicMove"
local CastleMove    = require "moves.CastleMove"
local SlidingMoveGenerator = require "move_generators.SlidingMoveGenerator"

local DoublePawnMoveGenerator = {
    sliding_move_generator = {},
}

MoveGenerator:extend(DoublePawnMoveGenerator, "DoublePawnMoveGenerator")

function DoublePawnMoveGenerator:new(dir)
    local out = MoveGenerator.new(self, true, false)
    out.sliding_move_generator = SlidingMoveGenerator:new({dir}, 2, true, false)
    return out
end

function DoublePawnMoveGenerator:generate(from, board)
    local piece = MoveGenerator.get_piece(from, board)

    if not piece.tags.has_moved then
        self.sliding_move_generator:generate(from, board)
    end
end

return DoublePawnMoveGenerator
