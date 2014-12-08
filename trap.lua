local class = require "middleclass.middleclass"

local Static = require "static"
local Trap = class("Trap", Static)

local global = require "global"

local Zombie = require "zombie"

function Trap:initialize(x, y)
    Static.initialize(self, x, y)

    self.w = 5
    self.h = 5
    self.hitbox = global.addHitbox(self, x, y, self.w, self.h)
    self.damage = 100
    self.stopsHumans = false
end

function Trap:stopsBullets()
    return false
end

function Trap:draw()
    love.graphics.setColor(255, 140, 0)
    love.graphics.rectangle("fill", self.x, self.y, 5, 5)
end

function Trap:onCollision(other, dx, dy)
    if other:isInstanceOf(Zombie) then
        other:hurt(self.damage)
        self:destroy()
    elseif other:isInstanceOf(Trap) then
        -- each colliding trap gets half of the translation vector
        self.x = self.x + dx/2
        self.y = self.y + dy/2
        local hx0, hy0, hx1, hy1 = self.hitbox:bbox()
        local hw = hx1 - hx0
        local hh = hy1 - hy0
        self.hitbox:moveTo(self.x + hw/2, self.y + hh/2)
    end
end

return Trap
