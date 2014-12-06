local class = require "middleclass.middleclass"

local Entity = class("Entity")

function Entity:initialize(x, y)
    self.x = x
    self.y = y
end

function Entity:update(dt)

end

return Entity
