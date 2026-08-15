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
    moves = {},
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

function Piece:generate_moves(pos, board)
    self.moves = {}

    for _, move_generator in ipairs(self.move_generators) do
        move_generator:generate(pos, board)
    end
end

function Piece:draw(pos, board)
    if self:is_empty() then return end
    assert(not self:is_out_of_bounds(), "Can't draw out of bounds piece")

    local x, y = pos:to_pixel_coords(board)
    love.graphics.draw(self.sprite, x, y)
end

function Piece:draw_moves(board)
    for pos, _ in self:get_moves() do
        local x, y = pos:to_pixel_coords(board)

        x = x + Piece.SIZE / 2
        y = y + Piece.SIZE / 2

        love.graphics.setColor(0, 0, 0)
        if board:is_empty(pos) then
            love.graphics.circle("fill", x, y, Piece.SIZE / 8)
        else
            love.graphics.circle("line", x, y, Piece.SIZE / 2.1)
        end
        love.graphics.setColor(1, 1, 1)
    end
end

function Piece:draw_on_coords(x, y)
    love.graphics.draw(self.sprite, x - Piece.SIZE / 2, y - Piece.SIZE / 2)
end

function Piece:insert_move(pos, move)
    if not self.moves[pos.rank] then self.moves[pos.rank] = {} end
    self.moves[pos.rank][pos.file] = move
end

function Piece:get_move(pos)
    if not self.moves[pos.rank] then return end
    return self.moves[pos.rank][pos.file]
end

function Piece:get_moves()
    local Pos = require "Pos"

    local positions = {}

    for rank, files in pairs(self.moves) do
        for file, _ in pairs(files) do
            table.insert(positions, Pos:new(rank, file))
        end
    end

    local i = 1

    return function()
        local pos = positions[i]
        if pos == nil then return end

        i = i + 1
        return pos, self:get_move(pos)
    end
end

function Piece:is_empty()
    return self.color == EMPTY
end

function Piece:is_out_of_bounds()
    return self.color == OUT_OF_BOUNDS
end

function Piece:is_actual_piece()
    return not self:is_empty() and not self:is_out_of_bounds()
end

function Piece:is_enemy(piece)
    return self:is_actual_piece() and piece:is_actual_piece() and self.color ~= piece.color
end

return Piece
