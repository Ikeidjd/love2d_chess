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

Dir.QUEEN_DIRS = {table.unpack(Dir.BISHOP_DIRS)}

for _, value in ipairs(Dir.ROOK_DIRS) do
    table.insert(Dir.QUEEN_DIRS, value)
end

Dir.KING_DIRS = {table.unpack(Dir.QUEEN_DIRS)}

return Dir
