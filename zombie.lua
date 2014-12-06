local Zombie = {}
Zombie.__index = Zombie

local Mobile = require "mobile"

setmetatable(Zombie, {
    __index = Mobile
})

function Zombie.new()
    local self = Mobile.new()
    setmetatable(self, Zombie)
    return self
end

function Zombie:draw()
    local radius = 5
    love.graphics.setColor(255, 255, 255)
    love.graphics.circle("line", self.x+radius, self.y+radius, radius)
end

return Zombie
