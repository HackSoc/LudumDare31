local Zombie = {}
Zombie.__index = Zombie

local Mobile = require "mobile"

setmetatable(Zombie, {
    __index = Mobile
})

function Zombie.new(x, y, collider)
    local self = Mobile.new(x, y, collider)
    self.hitbox = collider:addCircle(x, y, 5)
    setmetatable(self, Zombie)
    self.vx = 5
    self.vy = 5
    return self
end

function Zombie:draw()
    local radius = 5
    love.graphics.setColor(255, 255, 255)
    love.graphics.circle("line", self.x+radius, self.y+radius, radius)
end

return Zombie
