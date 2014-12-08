local class = require "middleclass.middleclass"

local Static = require "static"
local Trap = class("Trap", Static)

local global = require "global"

local Zombie = require "zombie"

function Trap:initialize(x, y)
    Static.initialize(self, x, y)

    self.hitbox = global.addHitbox(self, x, y, 5, 5)
    self.damage = 100
    self.stopsBullets = false
end

function Trap:draw()
    love.graphics.setColor(255, 140, 0)
    love.graphics.rectangle("fill", self.x, self.y, 5, 5)
end

function Trap:onCollision(other, dx, dy)
    if other:isInstanceOf(Zombie) then
        other:hurt(self.damage)
        self:destroy()
    end
end

return Trap
