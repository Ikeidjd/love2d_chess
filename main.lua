love.filesystem.setRequirePath("src/?.lua")

---@diagnostic disable-next-line: deprecated
table.unpack = table.unpack or unpack

function math.signum(n)
    if n < 0 then return -1
    elseif n > 0 then return 1
    else return 0 end
end

local Board       = require "Board"
local Piece       = require "Piece"
local pieces      = require "pieces"
local Pos         = require "Pos"
local shaders     = require "shaders"
local board_setup = require "board_setup"

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

function love.load()
    love.window.setMode(initial_screen_width * 2, initial_screen_height * 2, {fullscreen = false, resizable = true})
    love.resize(love.graphics.getWidth(), love.graphics.getHeight())
    board_setup.castle_test_board(state.board)
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
