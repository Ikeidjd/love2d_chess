local Pos = require "Pos"
local pieces = require "pieces"
local Piece  = require "Piece"

local board_setup = {}

function board_setup.normal_board(board)
    board:set(Pos:new(1, 1), pieces.new_rook(Piece.WHITE))
    board:set(Pos:new(1, 2), pieces.new_knight(Piece.WHITE))
    board:set(Pos:new(1, 3), pieces.new_bishop(Piece.WHITE))
    board:set(Pos:new(1, 4), pieces.new_queen(Piece.WHITE))
    board:set(Pos:new(1, 5), pieces.new_king(Piece.WHITE))
    board:set(Pos:new(1, 6), pieces.new_bishop(Piece.WHITE))
    board:set(Pos:new(1, 7), pieces.new_knight(Piece.WHITE))
    board:set(Pos:new(1, 8), pieces.new_rook(Piece.WHITE))

    board:set(Pos:new(8, 1), pieces.new_rook(Piece.BLACK))
    board:set(Pos:new(8, 2), pieces.new_knight(Piece.BLACK))
    board:set(Pos:new(8, 3), pieces.new_bishop(Piece.BLACK))
    board:set(Pos:new(8, 4), pieces.new_queen(Piece.BLACK))
    board:set(Pos:new(8, 5), pieces.new_king(Piece.BLACK))
    board:set(Pos:new(8, 6), pieces.new_bishop(Piece.BLACK))
    board:set(Pos:new(8, 7), pieces.new_knight(Piece.BLACK))
    board:set(Pos:new(8, 8), pieces.new_rook(Piece.BLACK))

    for file = 1, board.width do
        board:set(Pos:new(2, file), pieces.new_pawn(Piece.WHITE))
        board:set(Pos:new(7, file), pieces.new_pawn(Piece.BLACK))
    end

    return board
end

function board_setup.pawnless_board(board)
    board:set(Pos:new(1, 1), pieces.new_rook(Piece.WHITE))
    board:set(Pos:new(1, 2), pieces.new_knight(Piece.WHITE))
    board:set(Pos:new(1, 3), pieces.new_bishop(Piece.WHITE))
    board:set(Pos:new(1, 4), pieces.new_queen(Piece.WHITE))
    board:set(Pos:new(1, 5), pieces.new_king(Piece.WHITE))
    board:set(Pos:new(1, 6), pieces.new_bishop(Piece.WHITE))
    board:set(Pos:new(1, 7), pieces.new_knight(Piece.WHITE))
    board:set(Pos:new(1, 8), pieces.new_rook(Piece.WHITE))

    board:set(Pos:new(8, 1), pieces.new_rook(Piece.BLACK))
    board:set(Pos:new(8, 2), pieces.new_knight(Piece.BLACK))
    board:set(Pos:new(8, 3), pieces.new_bishop(Piece.BLACK))
    board:set(Pos:new(8, 4), pieces.new_queen(Piece.BLACK))
    board:set(Pos:new(8, 5), pieces.new_king(Piece.BLACK))
    board:set(Pos:new(8, 6), pieces.new_bishop(Piece.BLACK))
    board:set(Pos:new(8, 7), pieces.new_knight(Piece.BLACK))
    board:set(Pos:new(8, 8), pieces.new_rook(Piece.BLACK))

    return board
end

function board_setup.castle_test_board(board)
    board:set(Pos:new(1, 1), pieces.new_rook(Piece.WHITE))
    board:set(Pos:new(1, 5), pieces.new_king(Piece.WHITE))
    board:set(Pos:new(1, 8), pieces.new_rook(Piece.WHITE))

    board:set(Pos:new(8, 1), pieces.new_rook(Piece.BLACK))
    board:set(Pos:new(8, 5), pieces.new_king(Piece.BLACK))
    board:set(Pos:new(8, 8), pieces.new_rook(Piece.BLACK))

    return board
end

return board_setup
