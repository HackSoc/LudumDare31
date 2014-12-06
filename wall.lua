local Wall = {}
Wall.__index = Wall

local Static = require "static"
local global = require "global"

setmetatable(Wall, {
    __index = Static
})

function Wall.new(x, y, w, h)
    local self = Static.new(x, y)
    self.w = w
    self.h = h
    self.hitbox = global.addHitbox(self, x, y, w, h)
    setmetatable(self, Wall)
    return self
end

function Wall:draw()
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

return Wall
