local global = require "global"
local class = require "middleclass.middleclass"

local Entity = class("Entity")

function Entity:initialize(x, y)
    self.x = x
    self.y = y
end

function Entity:update(dt)
    -- If off the edge of the screen (with a 50px buffer), destroy
    -- self.
    if self.x < -50 or self.x > love.screen.getWidth() + 50 or
       self.y < -50 or self.y > love.screen.getHeight() + 50 then

        self:destroy()
    end
end

function Entity:destroy()
    global.removeEntity(self)
end

return Entity
