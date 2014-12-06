local Collidable = {}
Collidable.__index = Collidable

local Drawable = require "drawable"

setmetatable(Collidable, {
    __index = Drawable
})

function Collidable.new(x, y, collider)
    local self = Drawable.new(x, y)
    self.collider = collider
    setmetatable(self, Collidable)
    return self
end

function Collidable:update(dt)
   -- self.hitbox should probably never be nil, but I can't think of a
   -- good default hitbox to add.
   if self.hitbox ~= nil then
      self.hitbox:moveTo(self.x, self.y)
   end
end

function Collidable:onCollision(other, dx, dy)

end

function Collidable:destroy()
   if self.hitbox ~= nil then
      self.collider:remove(self.hitbox)
   end
end

return Collidable
