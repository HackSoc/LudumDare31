local global = require "global"
local class = require "middleclass.middleclass"

local Entity = class("Entity")

function Entity:initialize(x, y)
    self.x = x
    self.y = y
end

function Entity:update(dt)
    -- If off the edge of the window (with a 50px buffer), destroy
    -- self.
    if self.x < -50 or self.x > love.window.getWidth() + 50 or
       self.y < -50 or self.y > love.window.getHeight() + 50 then

        self:destroy()
    end
end

function Entity:getAbsDistance(other)
    local x = other.x - self.x
    local y = other.y - self.y
    return math.sqrt(x^2 + y^2)
end

function Entity:destroy()
    global.removeEntity(self)
end

return Entity
