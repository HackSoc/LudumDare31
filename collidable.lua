local class = require "middleclass.middleclass"

local Drawable = require "drawable"
local Collidable = class("Collidable", Drawable)

local global = require "global"

function Collidable:initialize(x, y)
    Drawable.initialize(self, x, y)
end

function Collidable:update(dt)
   -- self.hitbox should probably never be nil, but I can't think of a
   -- good default hitbox to add.
   if self.hitbox ~= nil then
       local hx0, hy0, hx1, hy1 = self.hitbox:bbox()
       local hw = hx1 - hx0
       local hh = hy1 - hy0
       self.hitbox:moveTo(self.x + hw/2, self.y + hh/2)
   end
end

function Collidable:onCollision(other, dx, dy)
end

function Collidable:destroy()
   if self.hitbox ~= nil then
      global.removeHitbox(self.hitbox)
   end
end

return Collidable
