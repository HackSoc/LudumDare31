local global = require "global"
local class = require "middleclass.middleclass"

local Static = require "static"
local Turret = class("Turret", Static)

local Zombie = require "zombie"
local Bullet = require "bullet"

-- Turrets have an ammo supply, which is gradually depleted. When
-- empty, the turret needs to recharge
function Turret:initialize(x, y, ammo, cooldown, reload, accuracy)
    Static.initialize(self, x, y)

    self.stopsBullets = false
    self.ammo = ammo
    self.maxammo = ammo
    self.cooldown = 0
    self.maxcooldown = cooldown
    self.maxreload = reload
    self.accuracy = 10 -- bullet scatter
    self.radius = 25 -- For drawing/hitbox
    self.hitbox = global.addHitbox(self, x, y, self.radius * 2, self.radius * 2)
end

function Turret:update(dt)
    if self.cooldown > 0 then
        self.cooldown = self.cooldown - dt
    end

    if self.ammo >= 0 and self.cooldown <= 0 then
        local zeds = {}
        local zcount = 0
        for _, e in pairs(global.entities) do
            if e:isInstanceOf(Zombie) then
                zcount = zcount + 1
                zeds[zcount] = e
            end
        end

        if zcount > 0 then
            -- Pick a random zombie
            local zid = love.math.random(zcount)

            -- Get the target coordinates (fuzzed slightly)
            local tx = zeds[zid].x + love.math.random(-self.accuracy, self.accuracy)
            local ty = zeds[zid].y + love.math.random(-self.accuracy, self.accuracy)

            -- Get the vector
            local dx = tx - self.x - self.radius
            local dy = ty - self.y - self.radius

            -- And normalise to speed
            local mag = math.sqrt(dx*dx + dy*dy)
            local vx = dx / mag * 100
            local vy = dy / mag * 100

            -- Spawn a bullet
            global.addDrawable(Bullet:new(self.x + self.radius,
                                          self.y + self.radius,
                                          vx, vy, 50))
            self.ammo = self.ammo - 1

            -- Reload if we have no ammo, and set the cooldown
            -- appropriately
            if self.ammo == 0 then
                self.cooldown = self.maxreload
                self.ammo = self.maxammo
            else
                self.cooldown = self.maxcooldown
            end
        end
    end

    Static.update(self, dt)
end

function Turret:draw()
    love.graphics.setColor(255, 0, 255)
    love.graphics.circle("line", self.x + 25, self.y + 25, 25)
end

return Turret
