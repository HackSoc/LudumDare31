local class = require "middleclass.middleclass"

local Collidable = require "collidable"
local Mobile = class("Mobile", Collidable)

function Mobile:initialize(x, y)
    Collidable.initialize(self, x, y)

    self.vx = 0
    self.vy = 0
end

function Mobile:update(dt)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
end

return Mobile
