local Piece                = require "Piece"
local Dir                  = require "Dir"
local SingleMoveGenerator  = require "move_generators.SingleMoveGenerator"
local SlidingMoveGenerator = require "move_generators.SlidingMoveGenerator"
local CastleMoveGenerator  = require "move_generators.CastleMoveGenerator"
local DoublePawnMoveGenerator = require "move_generators.DoublePawnMoveGenerator"

local pieces = {}

function pieces.new_pawn(color)
    local dir

    if color == Piece.WHITE then dir = Dir:new(1, 0)
    else dir = Dir:new(-1, 0) end

    local west = Dir:new(0, -1)
    local east = Dir:new(0, 1)

    return Piece:new(color, "pawn", {
        SingleMoveGenerator:new({dir}, true, false),
        DoublePawnMoveGenerator:new(dir),
        SingleMoveGenerator:new({dir + west, dir + east}, false, true),
    })
end

function pieces.new_bishop(color)
    return Piece:new(color, "bishop", {SlidingMoveGenerator:new(Dir.BISHOP_DIRS)})
end

function pieces.new_knight(color)
    return Piece:new(color, "knight", {SingleMoveGenerator:new(Dir.KNIGHT_DIRS)})
end

function pieces.new_rook(color)
    return Piece:new(color, "rook", {SlidingMoveGenerator:new(Dir.ROOK_DIRS)}, {castle_target = true})
end

function pieces.new_queen(color)
    return Piece:new(color, "queen", {SlidingMoveGenerator:new(Dir.QUEEN_DIRS)})
end

function pieces.new_king(color)
    return Piece:new(color, "king", {
        SingleMoveGenerator:new(Dir.KING_DIRS),
        CastleMoveGenerator:new(),
    })
end

return pieces
