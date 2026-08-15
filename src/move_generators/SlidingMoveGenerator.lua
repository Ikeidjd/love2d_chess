local MoveGenerator = require "move_generators.MoveGenerator"
local BasicMove     = require "moves.BasicMove"

local SlidingMoveGenerator = {
    dirs = {},
    limit = 0, --If limit == 0, it's considered infinite
}

MoveGenerator:extend(SlidingMoveGenerator, "SlidingMoveGenerator")

function SlidingMoveGenerator:new(dirs, limit, can_move, can_capture)
    local out = MoveGenerator.new(self, can_move, can_capture)
    out.dirs = dirs
    out.limit = limit
    return out
end

local function under_limit(steps, limit)
    return limit == 0 or steps < limit
end

function SlidingMoveGenerator:generate(from, board)
    local piece = MoveGenerator.get_piece(from, board)

    for _, dir in ipairs(self.dirs) do
        local to = from + dir
        local steps = 0

        while under_limit(steps, self.limit) and board:is_empty(to) do
            if self.can_move then
                piece:insert_move(to, BasicMove:new(from, to))
            end

            to = to + dir
            steps = steps + 1
        end

        if under_limit(steps, self.limit) and self.can_capture and piece:is_enemy(board:get(to)) then
            piece:insert_move(to, BasicMove:new(from, to))
        end
    end
end

return SlidingMoveGenerator
