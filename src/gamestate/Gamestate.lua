local Object = require "Object"

local Gamestate = {}

Object:extend(Gamestate, "Gamestate")

function Gamestate:update() end

function Gamestate:draw() end

return Gamestate
