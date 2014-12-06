local Mobile = {}
Mobile.__index = Mobile

local Collidable = require "collidable"

setmetatable(Mobile, {
    __index = Collidable
})

function Mobile.new(x, y)
    local self = Collidable.new(x, y)
    self.vx = 0
    self.vy = 0
    setmetatable(self, Mobile)
    return self
end

function Mobile:update(dt)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
end

return Mobile
