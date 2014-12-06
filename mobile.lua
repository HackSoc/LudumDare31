local class = require "middleclass.middleclass"

local Collidable = require "collidable"
local Mobile = class("Mobile", Collidable)

function Mobile:initialize(x, y)
    Collidable.initialize(self, x, y)

    self.vx = 0
    self.vy = 0
end

function Mobile:onCollision(other, dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
end

function Mobile:update(dt)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
    Collidable.update(self, dt)
end

return Mobile
