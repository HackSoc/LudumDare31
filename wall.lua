local Wall = {}
Wall.__index = Wall

local Static = require "static"

setmetatable(Wall, {
    __index = Static
})

function Wall.new(x, y, width, height)
    local self = Static.new(x, y)
    self.width = width
    self.height = height

    setmetatable(self, Wall)
    return self
end

function Wall:draw()
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

return Wall
