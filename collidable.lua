local Collidable = {}
Collidable.__index = Collidable

local Drawable = require "drawable"

setmetatable(Collidable, {
    __index = Drawable
})

function Collidable.new()
    local self = Drawable.new()
    setmetatable(self, Collidable)
    return self
end

return Collidable
