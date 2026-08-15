local Move = require "moves.Move"
local Piece= require "Piece"

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
    board:set(self.to, board:get(self.from))
    board:set(self.from, Piece:new_empty())
end

return BasicMove
