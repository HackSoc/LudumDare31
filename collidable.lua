local class = require "middleclass.middleclass"

local Drawable = require "drawable"
local Collidable = class("Collidable", Drawable)

local global = require "global"

function Collidable:initialize(x, y, maxhp)
    Drawable.initialize(self, x, y)
    self.stopsHumans = true
    self.maxhp = maxhp
    self.hp = maxhp
    -- this is wrong, but will disappear quickly
    self.centerx = x
    self.centery = y
    self.is_ghost = false
end

function Collidable:update(dt)
   -- self.hitbox should probably never be nil, but I can't think of a
   -- good default hitbox to add.
   if self.hitbox ~= nil then
       local hx0, hy0, hx1, hy1 = self.hitbox:bbox()
       local hw = hx1 - hx0
       local hh = hy1 - hy0
       self.centerx = self.x + hw/2
       self.centery = self.y + hh/2
       self.hitbox:moveTo(self.centerx, self.centery)
   end

   Drawable.update(self, dt)
end

function Collidable:stopsBullets()
    return not self.is_ghost
end

function Collidable:center()
    return self.centerx, self.centery
end

function Collidable:onCollision(other, dx, dy)
    print("Collidable colliding")
end

function Collidable:hurt(damage)
    self.hp = self.hp - damage
    if self.hp <= 0 then
        self:destroy()
    end
end

function Collidable:destroy()
   if self.hitbox ~= nil then
      global.removeHitbox(self.hitbox)
   end

   Drawable.destroy(self)
end

function Collidable:ghost()
    if not self.is_ghost and self.hitbox ~= nil then
        self.is_ghost = true
        global.setGhost(self.hitbox)
    end
end

function Collidable:solidify()
    if self.is_ghost and self.hitbox ~= nil then
        self.is_ghost = false
        global.setSolid(self.hitbox)
    end
end

return Collidable
