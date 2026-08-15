love.filesystem.setRequirePath("src/?.lua")

---@diagnostic disable-next-line: deprecated
table.unpack = table.unpack or unpack

local Board   = require "Board"
local Piece   = require "Piece"
local pieces  = require "pieces"
local Pos     = require "Pos"
local shaders = require "shaders"

MouseJustPressed = {}
MouseJustReleased = {}
MOUSE_LEFT = 1
MOUSE_RIGHT = 2
MOUSE_MIDDLE = 3

local state = {
    board = Board:new(8, 8),
}

local initial_screen_width = Piece.SIZE * state.board.width
local initial_screen_height = Piece.SIZE * state.board.height

BOARD_SCALE = 1
BOARD_OFFSET_X = 0
BOARD_OFFSET_Y = 0

local function setup_board(board)
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

    --[[for file = 1, board.width do
        board:set(Pos:new(2, file), Piece:new(Piece.WHITE, "pawn", {}))
        board:set(Pos:new(7, file), Piece:new(Piece.BLACK, "pawn", {}))
    end]]
end

function love.load()
    love.window.setMode(initial_screen_width * 2, initial_screen_height * 2, {fullscreen = false, resizable = true})
    love.resize(love.graphics.getWidth(), love.graphics.getHeight())
    setup_board(state.board)
end

function love.update()
    state.board:update()
    MouseJustPressed = {}
    MouseJustReleased = {}
end

function love.draw()
    love.graphics.setShader(shaders.scale)
    state.board:draw()
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'f11' and not isrepeat then love.window.setFullscreen(not love.window.getFullscreen()) end
end

function love.mousepressed(x, y, button, istouch, presses)
    MouseJustPressed[button] = true
end

function love.mousereleased(x, y, button, istouch, presses)
    MouseJustReleased[button] = true
end

function love.resize(w, h)
    local scale_x = math.floor(w / initial_screen_width);
    local scale_y = math.floor(h / initial_screen_height);

    scale_x = math.max(1, scale_x);
    scale_y = math.max(1, scale_y);

    BOARD_SCALE = math.min(scale_x, scale_y);

    BOARD_OFFSET_X = (w - initial_screen_width * BOARD_SCALE) / 2;
    BOARD_OFFSET_Y = (h - initial_screen_height * BOARD_SCALE) / 2;

    shaders.scale:send("scale_num", BOARD_SCALE)
    shaders.scale:send("offset_x", BOARD_OFFSET_X)
    shaders.scale:send("offset_y", BOARD_OFFSET_Y)
end
