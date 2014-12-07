local class = require "middleclass.middleclass"

local Drawable = require "drawable"
local HotZone = class("HotZone", Drawable)

local global = require "global"

local Human = require "human"
local Zombie = require "zombie"

function HotZone:initialize(x, y, w, h)
    Drawable.initialize(self, x, y)
    self.hitbox = global.addHitbox(self, x, y, w, h)
    self.w = w
    self.h = h
    self.contains_human = false
    self.contains_zombie = false
end

function HotZone:update(dt)
    self.contains_human = false
    self.contains_zombie = false
    
end

function HotZone:draw()
    if self.contains_human and self.contains_zombie then
        love.graphics.setColor(218, 165, 32)
    elseif self.contains_human then
        love.graphics.setColor(0, 255, 0)
    elseif self.contains_zombie then
        love.graphics.setColor(255, 255, 0)
    else
        love.graphics.setColor(0, 0, 255);
    end
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end


function HotZone:onCollision(other, dx, dy)
    if other:isInstanceOf(Human) then
        self.contains_human = true
    elseif other:isInstanceOf(Zombie) then
        self.contains_zombie = true
    end
end

function HotZone:containsHuman()
    return self.contains_human
end

function HotZone:containsZombie()
    return self.contains_zombie
end

function HotZone:destroy()
    if self.hitbox ~= nil then
        global.removeHitbox(self.hitbox)
    end

    Drawable.destroy(self)
end

return HotZone
