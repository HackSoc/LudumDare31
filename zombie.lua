local Zombie = {}
Zombie.__index = Zombie

local Mobile = require "mobile"
local global = require "global"

setmetatable(Zombie, {
    __index = Mobile
})

local maxspeed = 50

function Zombie.new(x, y)
    local self = Mobile.new(x, y)
    self.hitbox = global.addHitbox(self, x, y, 10, 10)
    setmetatable(self, Zombie)
    return self
end

function Zombie:draw()
    local radius = 5
    love.graphics.setColor(255, 255, 255)
    love.graphics.circle("line", self.x+radius, self.y+radius, radius)
end

function Zombie:update(dt)
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    local cx = w/2
    local cy = h/2
    local dx = cx - self.x
    local dy = cy - self.y
    local mag = math.sqrt(dx^2 + dy^2)
    self.vx = dx / mag * maxspeed
    self.vy = dy / mag * maxspeed
    Mobile.update(self, dt)
end

return Zombie
