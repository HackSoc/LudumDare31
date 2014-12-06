local class = require "middleclass.middleclass"

local Mobile = require "mobile"
local Zombie = class("Zombie", Mobile)

local global = require "global"

local maxspeed = 50

function Zombie:initialize(x, y)
    Mobile.initialize(self, x, y)

    self.hitbox = global.addHitbox(self, x, y, 10, 10)
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
