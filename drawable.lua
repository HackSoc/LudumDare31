local Drawable = {}
Drawable.__index = Drawable

local Entity = require "entity"

setmetatable(Drawable, {
    __index = Entity
})

function Drawable.new(x, y)
    local self = Entity.new(x, y)
    setmetatable(self, Drawable)
    return self
end

function Drawable:draw()

end

return Drawable
