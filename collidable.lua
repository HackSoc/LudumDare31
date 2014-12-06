local Collidable = {}
Collidable.__index = Collidable

local Drawable = require "drawable"

setmetatable(Collidable, {
    __index = Drawable
})

function Collidable.new(x, y)
    local self = Drawable.new(x, y)
    setmetatable(self, Collidable)
    return self
end

function Collidable:onCollision(other)

end

return Collidable
