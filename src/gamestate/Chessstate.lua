local Gamestate = require "gamestate.Gamestate"
local shaders   = require "shaders"
local Piece     = require "Piece"

local Chessstate = {
    board = {},
    turn = Piece.WHITE,
    bots = {
        [Piece.WHITE] = nil,
        [Piece.BLACK] = nil,
    },
}

Gamestate:extend(Chessstate, "Chessstate")

function Chessstate:new(board, white_bot, black_bot)
    return Gamestate.new(self, {
        board = board,
        bots = {
            [Piece.WHITE] = white_bot,
            [Piece.BLACK] = black_bot,
        },
    })
end

function Chessstate:update()
    local bot = self.bots[self.turn]

    if bot then
        local move = bot:get_best_move(self.turn, self.board, 2)
        move:perform(self.board)
        self.turn = Piece.get_opposite_color(self.turn)
    else
        self.turn = self.board:update(self.turn)
    end
end

function Chessstate:draw()
    love.graphics.setShader(shaders.scale_and_center_board)
    self.board:draw()
    love.graphics.setShader()
end

return Chessstate
