local Piece                = require "Piece"
local Dir                  = require "Dir"
local SlidingMoveGenerator = require "move_generators.Sliding"

local pieces = {}

function pieces.new_bishop(color)
    return Piece:new(color, "bishop", {SlidingMoveGenerator:new(Dir.BISHOP_DIRS)})
end

function pieces.new_knight(color)
    return Piece:new(color, "knight", {--[[SingleMoveGenerator:new(Dir.KNIGHT_DIRS)]]})
end

function pieces.new_rook(color)
    return Piece:new(color, "rook", {SlidingMoveGenerator:new(Dir.ROOK_DIRS)})
end

function pieces.new_queen(color)
    return Piece:new(color, "queen", {SlidingMoveGenerator:new(Dir.QUEEN_DIRS)})
end

function pieces.new_king(color)
    return Piece:new(color, "king", {--[[SingleMoveGenerator:new(Dir.KING_DIRS)]]})
end

return pieces
