local global = require "global"
local class = require "middleclass.middleclass"

local Gun = class("Gun")
local Bullet = require "bullet"

local speed = 100

function Gun:initialize(radius, damage, ammo, cooldown, reload, accuracy)
    self.damage = damage
    self.ammo = ammo
    self.maxammo = ammo
    self.cooldown = 0
    self.maxcooldown = cooldown
    self.maxreload = reload
    self.accuracy = accuracy -- bullet scatter
    self.radius = radius
end

function Gun:update(dt)
    if self.cooldown > 0 then
        self.cooldown = self.cooldown - dt
    end
end

-- x, y - where the bullet initially appears (not including radius of the gun)
function Gun:fire(x, y, target)
    if self.ammo <= 0 or self.cooldown > 0 then
        return
    end

    -- Get the target coordinates (fuzzed slightly)
    local tx = target.x + love.math.random(-self.accuracy, self.accuracy)
    local ty = target.y + love.math.random(-self.accuracy, self.accuracy)

    -- Get the vector
    local dx = tx - x
    local dy = ty - y

    -- And normalise to speed
    local mag = math.sqrt(dx*dx + dy*dy)
    local vx = dx / mag * speed
    local vy = dy / mag * speed

    -- Spawn a bullet
    global.addDrawable(Bullet:new(x + (dx / mag * self.radius),
                                  y + (dy / mag * self.radius),
                                  vx, vy, self.damage))
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

return Gun
