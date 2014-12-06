local Wall = {}
Wall.__index = Wall

local Static = require "static"

setmetatable(Wall, {
    __index = Static
})

function Wall.new()
    local self = Static.new()
    setmetatable(self, Wall)
    return self
end

return Wall
