local Object = require "Object"

local Pos = {
    rank = 0,
    file = 0,
}

Object:extend(Pos, "Pos")

function Pos:new(rank, file)
    return Object.new(self, {
        rank = rank,
        file = file,
    })
end

function Pos:to_pixel_coords(board)
    local Piece = require "Piece"

    local x = (self.file - 1) * Piece.SIZE
    local y = (board.height - self.rank) * Piece.SIZE

    return x, y
end

return Pos
