local global = require "global"
local class = require "middleclass.middleclass"

local Mobile = require "mobile"

local Tank = class("Tank", Mobile)

local Bullet = require "bullet"

local image = love.graphics.newImage("tank.png")

function Tank:initialize(x, y)
    Mobile.initialize(self, x, y, 5000)
    self.x = x
    self.y = y
    self.vx = 50
    self.vy = 0
    self.stopsBullets = false
    self.stopsHumans = true
    self.fire_cooldown_max = 0.05
    self.fire_cooldown = self.fire_cooldown_max
    self.damage = 50
    self.hitbox = global.addHitbox(self, x, y, image:getWidth(), image:getHeight())
    self.layer = 3
end

function Tank:update(dt)
    Mobile.update(self, dt)
    self.fire_cooldown = self.fire_cooldown - dt
    if self.fire_cooldown <= 0 then
        self.fire_cooldown = self.fire_cooldown_max
        self:fire()
    end
end

function Tank:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(image, self.x, self.y)
end

-- tanks don't really respect collisions
function Tank:onCollision(other, dx, dy)
    if other:isInstanceOf(Mobile) then
        other:destroy()
    end
end

function Tank:fire()
    local bx = self.vx + 100
    local by = math.random(-20, 20)
    global.addDrawable(Bullet(self.x + image:getWidth() + 10,
                              self.y + image:getHeight()/2,
                              bx, by, 50))
end


return Tank
