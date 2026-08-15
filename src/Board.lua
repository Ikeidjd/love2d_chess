local Object = require "Object"
local Piece  = require "Piece"
local Pos    = require "Pos"

local Board = {
    width = 0,
    height = 0,
    selected_piece = nil,
    selected_piece_follows_cursor = false,
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

function Board:update()
    local x, y = self:get_mouse_coords()

    local pos = Pos:from_pixel_coords(x, y, self)
    --print(pos:tostring())

    local piece = self:get(pos)

    if MouseJustPressed[MOUSE_LEFT] then
        if piece:is_actual_piece() then
            piece:generate_moves(pos, self)
            self.selected_piece = piece
            self.selected_piece_follows_cursor = true
        elseif self.selected_piece and not self.selected_piece:get_move(pos) then
            self.selected_piece = nil
            self.selected_piece_follows_cursor = false
        end
    elseif MouseJustReleased[MOUSE_LEFT] then
        if self.selected_piece and self.selected_piece:get_move(pos) then
            self.selected_piece:get_move(pos):perform(self)
            self.selected_piece = nil
            self.selected_piece_follows_cursor = false
        else
            self.selected_piece_follows_cursor = false
        end
    end
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
            local piece = self:get(pos)

            if not self.selected_piece_follows_cursor or piece ~= self.selected_piece then
                piece:draw(pos, self)
            end
        end
    end

    if self.selected_piece then
        self.selected_piece:draw_moves(self)
        if self.selected_piece_follows_cursor then
            local x, y = self:get_mouse_coords()
            self.selected_piece:draw_on_coords(x, y)
        end
    end
end

function Board:get_mouse_coords()
    local x, y = love.mouse.getPosition()

    x = (x - BOARD_OFFSET_X) / BOARD_SCALE
    y = (y - BOARD_OFFSET_Y) / BOARD_SCALE

    return x, y
end

function Board:is_empty(pos)
    return self:get(pos):is_empty()
end

function Board:in_bounds(pos)
    return pos.rank >= 1 and pos.rank <= self.height and pos.file >= 1 and pos.file <= self.width
end

function Board:get(pos)
    if not self:in_bounds(pos) then return Piece:new_out_of_bounds() end
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
