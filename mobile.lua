local class = require "middleclass.middleclass"

local Collidable = require "collidable"
local Mobile = class("Mobile", Collidable)

function Mobile:initialize(x, y)
    Collidable.initialize(self, x, y)

    self.vx = 0
    self.vy = 0
    self.targetx = nil
    self.targety = nil
    self.maxspeed = 1 --Stupid small default speed
end

function Mobile:onCollision(other, dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
end

function Mobile:update(dt)
    if self.targetx and self.targety then
        local dx = self.targetx - self.x
        local dy = self.targety - self.y
        local mag = math.sqrt(dx^2 + dy^2)
        self.vx = dx / mag * self.maxspeed
        self.vy = dy / mag * self.maxspeed
    end
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
    Collidable.update(self, dt)
end

function Mobile:setTarget(x, y)
    self.targetx = x
    self.targety = y
end

function Mobile:setMaxSpeed(speed)
    self.maxspeed = speed
end

return Mobile
