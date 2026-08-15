local function makeShader(name)
    return love.graphics.newShader(io.open('res/shaders/' .. name .. '.txt'):read('a'))
end

local shaders = {
    scale = makeShader("scale")
}

return shaders
