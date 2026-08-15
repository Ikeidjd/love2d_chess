local Move  = require "moves.Move"
local Piece = require "Piece"

local BasicMove = {
    from = {},
    to = {},
}

Move:extend(BasicMove, "BasicMove")

function BasicMove:new(from, to)
    return Move.new(self, {
        from = from,
        to = to,
    })
end

function BasicMove:perform(board)
    local piece = board:get(self.from)
    piece.tags.has_moved = true

    board:set(self.to, piece)
    board:set(self.from, Piece:new_empty())
end

return BasicMove
