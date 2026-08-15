local MoveGenerator = require "move_generator.MoveGenerator"

local Sliding = {
    dirs = {},
}

MoveGenerator:extend(Sliding, "SlidingMoveGenerator")

function Sliding:new(dirs)
    return MoveGenerator.new(self, {
        dirs = dirs,
    })
end

function Sliding:generate(pos, board)
    local piece = MoveGenerator.get_piece(pos, board)

    for _, dir in ipairs(self.dirs) do
        local target_pos = pos + dir

        while board:is_empty(target_pos) do
            piece:insert_move(target_pos, true) --TODO: add Move type
            target_pos = target_pos + dir
        end

        if piece:is_enemy(board:get(target_pos)) then
            piece:insert_move(target_pos, true) --TODO: add Move type
        end
    end
end

return Sliding
