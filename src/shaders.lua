local function make_shader(name)
    return love.graphics.newShader(io.open('res/shaders/' .. name .. '.txt'):read('a'))
end

local shaders = {
    scale_and_center_board = make_shader("scale_and_center_board")
}

return shaders
