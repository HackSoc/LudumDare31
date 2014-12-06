local class = require "middleclass.middleclass"

local Collidable = require "collidable"
local Static = class("Static", Collidable)

function Static:initialize(x, y)
    Collidable.initialize(self, x, y)
end

function Static:onCollision(other, dx, dy)
end

return Static
