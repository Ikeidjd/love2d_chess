local Object = require "Object"
local Piece  = require "Piece"

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

function Pos:__add(dir)
    return Pos:new(self.rank + dir.drank, self.file + dir.dfile)
end

function Pos:from_pixel_coords(x, y, board)
    local rank = math.ceil(board.height - y / Piece.SIZE)
    local file = math.ceil(x / Piece.SIZE)

    return self:new(rank, file)
end

function Pos:to_pixel_coords(board)
    local x = (self.file - 1) * Piece.SIZE
    local y = (board.height - self.rank) * Piece.SIZE

    return x, y
end

return Pos
