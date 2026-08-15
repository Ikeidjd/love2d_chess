local Object  = require "Object"
local sprites = require "sprites"

local EMPTY = "empty"
local OUT_OF_BOUNDS = "out_of_bounds"

local Piece = {
    WHITE = "white",
    BLACK = "black",
    SIZE = 48,
    color = "",
    name = "",
    move_generators = {},
    sprite = {},
}

Object:extend(Piece, "Piece")

function Piece:new(color, name, move_generators)
    local sprite = sprites[color] and sprites[color][name]

    return Object.new(self, {
        color = color,
        name = (color:sub(1, 1) .. name:sub(1, 1)):upper(),
        move_generators = move_generators,
        sprite = sprite,
    })
end

function Piece:new_empty()
    return self:new(EMPTY, "E", {})
end

function Piece:new_out_of_bounds()
    return self:new(OUT_OF_BOUNDS, "O", {})
end

function Piece:draw(pos, board)
    if self:is_empty() then return end
    assert(not self:is_out_of_bounds(), "Can't draw out of bounds piece")

    local x, y = pos:to_pixel_coords(board)
    love.graphics.draw(self.sprite, x, y)
end

function Piece:is_empty()
    return self.color == EMPTY
end

function Piece:is_out_of_bounds()
    return self.color == OUT_OF_BOUNDS
end

return Piece
