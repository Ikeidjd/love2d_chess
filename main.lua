love.filesystem.setRequirePath("src/?.lua")

local Board   = require "Board"
local Piece   = require "Piece"
local Pos     = require "Pos"
local shaders = require "shaders"
local sprites = require "sprites"

local state = {
    board = Board:new(8, 8),
}

function love.load()
    love.window.setMode(Piece.SIZE * state.board.width, Piece.SIZE * state.board.height, {fullscreen = false, resizable = true})
    shaders.scale:send("initial_screen_size", {love.graphics.getWidth(), love.graphics.getHeight()})

    state.board:set(Pos:new(1, 1), Piece:new(Piece.WHITE, "rook", {}))
    state.board:set(Pos:new(1, 2), Piece:new(Piece.WHITE, "knight", {}))
    state.board:set(Pos:new(1, 3), Piece:new(Piece.WHITE, "bishop", {}))
    state.board:set(Pos:new(1, 4), Piece:new(Piece.WHITE, "queen", {}))
    state.board:set(Pos:new(1, 5), Piece:new(Piece.WHITE, "king", {}))
    state.board:set(Pos:new(1, 6), Piece:new(Piece.WHITE, "bishop", {}))
    state.board:set(Pos:new(1, 7), Piece:new(Piece.WHITE, "knight", {}))
    state.board:set(Pos:new(1, 8), Piece:new(Piece.WHITE, "rook", {}))

    state.board:set(Pos:new(8, 1), Piece:new(Piece.BLACK, "rook", {}))
    state.board:set(Pos:new(8, 2), Piece:new(Piece.BLACK, "knight", {}))
    state.board:set(Pos:new(8, 3), Piece:new(Piece.BLACK, "bishop", {}))
    state.board:set(Pos:new(8, 4), Piece:new(Piece.BLACK, "queen", {}))
    state.board:set(Pos:new(8, 5), Piece:new(Piece.BLACK, "king", {}))
    state.board:set(Pos:new(8, 6), Piece:new(Piece.BLACK, "bishop", {}))
    state.board:set(Pos:new(8, 7), Piece:new(Piece.BLACK, "knight", {}))
    state.board:set(Pos:new(8, 8), Piece:new(Piece.BLACK, "rook", {}))

    for file = 1, state.board.width do
        state.board:set(Pos:new(2, file), Piece:new(Piece.WHITE, "pawn", {}))
        state.board:set(Pos:new(7, file), Piece:new(Piece.BLACK, "pawn", {}))
    end
end

function love.update()
end

function love.draw()
    love.graphics.setShader(shaders.scale)
    state.board:draw()
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'f11' and not isrepeat then love.window.setFullscreen(not love.window.getFullscreen()) end
end
