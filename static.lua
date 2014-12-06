local class = require "middleclass.middleclass"

local Collidable = require "collidable"
local Static = class("Static", Collidable)

function Static:initialize(x, y)
    Collidable.initialize(self, x, y)
end

return Static
