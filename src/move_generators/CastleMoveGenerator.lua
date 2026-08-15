local MoveGenerator = require "move_generators.MoveGenerator"
local BasicMove     = require "moves.BasicMove"
local CastleMove    = require "moves.CastleMove"

local CastleMoveGenerator = {}

MoveGenerator:extend(CastleMoveGenerator, "CastleMoveGenerator")

function CastleMoveGenerator:new()
    return MoveGenerator.new(self, true, false)
end

local function try_add_castle(castle_doer_from, castle_target_from, castle_doer, castle_target, board)
    if not castle_doer:is_friend(castle_target) then return end
    if not castle_target.tags.castle_target then return end
    if castle_doer.tags.has_moved then return end
    if castle_target.tags.has_moved then return end

    local dir = (castle_target_from - castle_doer_from):normalize()
    local pos = castle_doer_from + dir

    while pos ~= castle_target_from do
        if not board:is_empty(pos) then return end
        pos = pos + dir
    end

    local castle_doer_to = castle_doer_from + dir * 2
    local castle_target_to = castle_doer_from + dir

    local castle_doer_move = BasicMove:new(castle_doer_from, castle_doer_to)
    local castle_target_move = BasicMove:new(castle_target_from, castle_target_to)

    castle_doer:insert_move(castle_doer_to, CastleMove:new(castle_doer_move, castle_target_move))
end

function CastleMoveGenerator:generate(castle_doer_from, board)
    local castle_doer = MoveGenerator.get_piece(castle_doer_from, board)

    for castle_target_from, castle_target in board:get_pieces() do
        try_add_castle(castle_doer_from, castle_target_from, castle_doer, castle_target, board)
    end
end

return CastleMoveGenerator
