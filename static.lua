local class = require "middleclass.middleclass"

local Collidable = require "collidable"
local Static = class("Static", Collidable)

function Static:initialize(x, y, health)
    local health = health or math.huge
    Collidable.initialize(self, x, y, health)
end

function Static:onCollision(other, dx, dy)
end

function Static:hurt()
    -- Most statics will be invulnerable, so override hurt here.
end

return Static
