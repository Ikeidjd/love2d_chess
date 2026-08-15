local function make_image(name)
    local image = love.graphics.newImage("res/sprites/" .. name .. ".png")
    image:setFilter("linear", "nearest")
    return image
end

local sprites = {
    white = {
        pawn = make_image("white/pawn"),
        knight = make_image("white/knight"),
        bishop = make_image("white/bishop"),
        rook = make_image("white/rook"),
        queen = make_image("white/queen"),
        king = make_image("white/king"),
    },
    black = {
        pawn = make_image("black/pawn"),
        knight = make_image("black/knight"),
        bishop = make_image("black/bishop"),
        rook = make_image("black/rook"),
        queen = make_image("black/queen"),
        king = make_image("black/king"),
    },
}

return sprites
