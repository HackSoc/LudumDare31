local Zombie = {}
Zombie.__index = Zombie

local Mobile = require "mobile"
local global = require "global"

setmetatable(Zombie, {
    __index = Mobile
})

function Zombie.new(x, y)
    local self = Mobile.new(x, y)
    self.hitbox = global.addHitbox(self, x, y, 10, 10)
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
