local Object = require "Object"

local Dir = {}

Object:extend(Dir, "Dir")

function Dir:new(drank, dfile)
    return Object.new(self, {
        drank = drank,
        dfile = dfile,
    })
end

Dir.KNIGHT_DIRS = {
    Dir:new(1, 2),
    Dir:new(-1, 2),
    Dir:new(1, -2),
    Dir:new(-1, -2),
    Dir:new(2, 1),
    Dir:new(-2, 1),
    Dir:new(2, -1),
    Dir:new(-2, -1),
}

Dir.BISHOP_DIRS = {
    Dir:new(1, 1),
    Dir:new(-1, 1),
    Dir:new(1, -1),
    Dir:new(-1, -1),
}

Dir.ROOK_DIRS = {
    Dir:new(0, 1),
    Dir:new(0, -1),
    Dir:new(1, 0),
    Dir:new(-1, 0),
}

Dir.QUEEN_DIRS = {
    table.unpack(Dir.BISHOP_DIRS),
    table.unpack(Dir.ROOK_DIRS),
}

Dir.KING_DIRS = {
    table.unpack(Dir.BISHOP_DIRS),
    table.unpack(Dir.ROOK_DIRS),
}

return Dir
