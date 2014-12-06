local Wall = {}
Wall.__index = Wall

local Static = require "static"

setmetatable(Wall, {
    __index = Static
})

function Wall.new(x, y, collider, width, height)
    local self = Static.new(x, y, collider)
    self.width = width
    self.height = height
    self.hitbox = collider:addRectangle(x, y, width, height)
    setmetatable(self, Wall)
    return self
end

function Wall:draw()
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

return Wall
