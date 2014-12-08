local global = require 'global'
local class = require 'middleclass.middleclass'

local Collidable = require 'collidable'
local Bullet = class('Bullet', Collidable)

function Bullet:initialize(x, y, dx, dy, damage)
    Collidable.initialize(self, x, y)

    self.hitbox = global.addHitbox(self, x, y, 2, 2)
    self.dx = dx
    self.dy = dy
    self.damage = damage
    self.layer = 2
    self.stopsHumans = false
end

function Bullet:hurt()
end

function Bullet:onCollision(other, dx, dy)
    if other:isInstanceOf(Collidable) and other:stopsBullets() then
        other:hurt(self.damage)
        self:destroy()
    end
end

function Bullet:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    Collidable.update(self)
end

function Bullet:draw()
    love.graphics.setPointSize(2)
    love.graphics.setColor(50, 100, 150)
    love.graphics.point(self.x, self.y)
end

return Bullet
