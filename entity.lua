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

function Entity:hasLineOfSight(targetx, targety)
    if self.x < targetx then
        x1 = self.x
        x2 = targetx
    else
        x2 = self.x
        x1 = targetx
    end
    if self.y < targety then
        y1 = self.y
        y2 = targety
    else
        y2 = self.y
        y1 = targety
    end
    possibleBlockers = global.collider.shapesInRange(x1, y1, x2, y2)
    for _, shape = pairs(possibleBlockers) do
        if shape:intersectsRay(self.x, self.y, targetx-self.x, targety-self.y) then
            shapex, shapey = shape:center()
            if shapex > x1 and shapex < x2 and shapey > y1 and shapey < y2 then
                return false
            end
        end 
    end
    return true
end

function Entity:destroy()
    global.removeEntity(self)
end

return Entity
