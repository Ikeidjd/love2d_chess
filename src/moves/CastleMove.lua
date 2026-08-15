local Move  = require "moves.Move"

local CastleMove = {
    castle_doer_move = {},
    castle_target_move = {},
}

Move:extend(CastleMove, "CastleMove")

function CastleMove:new(castle_doer_move, castle_target_move)
    return Move.new(self, {
        castle_doer_move = castle_doer_move,
        castle_target_move = castle_target_move,
    })
end

function CastleMove:perform(board)
    self.castle_doer_move:perform(board)
    self.castle_target_move:perform(board)
end

return CastleMove
