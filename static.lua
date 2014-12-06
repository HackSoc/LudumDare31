local class = require "middleclass.middleclass"

local Collidable = require "collidable"
local Static = class("Static", Collidable)

function Static:initialize(x, y)
    -- 999 is a good approximation of infinity
    Collidable.initialize(self, x, y, 999)
end

function Static:onCollision(other, dx, dy)
end

function Static:hurt()
    -- Most statics will be invulnerable, so override hurt here.
end

return Static
