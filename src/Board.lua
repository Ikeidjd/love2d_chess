local Object = require "Object"
local Piece  = require "Piece"
local Pos    = require "Pos"

local Board = {
    width = 0,
    height = 0,
}

Object:extend(Board, "Board")

function Board:new(width, height)
    local board = {
        width = width,
        height = height,
    }

    for i = 1, height do
        board[i] = {}

        for j = 1, width do
            board[i][j] = Piece:new_empty()
        end
    end

    return Object.new(self, board)
end

function Board:draw()
    for rank = 1, self.height do
        for file = 1, self.width do
            local color = {0.2, 0.4, 0.2}

            if (rank + file) % 2 ~= 0 then
                color = {0.88, 0.82, 0.82}
            end

            local pos = Pos:new(rank, file)
            local x, y = pos:to_pixel_coords(self)

            love.graphics.setColor(color)
            love.graphics.rectangle("fill", x, y, Piece.SIZE, Piece.SIZE)
        end
    end

    love.graphics.setColor(1, 1, 1)

    for rank = 1, self.height do
        for file = 1, self.width do
            local pos = Pos:new(rank, file)
            self:get(pos):draw(pos, self)
        end
    end
end

function Board:in_bounds(pos)
    return pos.rank >= 1 and pos.rank <= self.height and pos.file >= 1 and pos.rank <= self.width
end

function Board:get(pos)
    if not self:in_bounds(pos) then
        return Piece:new_out_of_bounds()
    end

    return self[pos.rank][pos.file]
end

function Board:set(pos, piece)
    assert(self:in_bounds(pos), pos:tostring() .. " is out of bounds for " .. Object.tostring(self))

    self[pos.rank][pos.file] = piece
end

function Board:tostring()
    local out = "Board {"

    for rank = self.height, 1, -1 do
        out = out .. "\n    {"
        for file = 1, self.width do
            out = out .. self[rank][file].name .. ","
        end
        out = out .. "},"
    end

    return out .. "\n}"
end

return Board
