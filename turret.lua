local global = require "global"
local class = require "middleclass.middleclass"

local Static = require "static"
local Turret = class("Turret", Static)

local Zombie = require "zombie"
local Bullet = require "bullet"

-- Turrets have an ammo supply, which is gradually depleted. When
-- empty, the turret needs to recharge.
function Turret:initialize(x, y, ammo, cooldown, reload, accuracy, direction, spread)
    Static.initialize(self, x, y)

    self.stopsBullets = false
    self.ammo = ammo
    self.maxammo = ammo
    self.cooldown = 0
    self.maxcooldown = cooldown
    self.maxreload = reload
    self.accuracy = 10 -- bullet scatter
    self.radius = 25 -- For drawing/hitbox
    if direction < 0 then
        self.direction = 2 * math.pi + direction
    else
        self.direction = direction
    end
    self.spread = spread
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
            if e:isInstanceOf(Zombie) and self:isInFieldOfView(e) then
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

local function rotateAbout(x, y, cx, cy, theta)
    local rx = (x - cx) * math.cos(theta) - (y - cy) * math.sin(theta)
    local ry = (x - cx) * math.sin(theta) + (y - cy) * math.cos(theta)

    return rx + cx, ry + cy
end

function Turret:isInFieldOfView(entity)
    local theta1 = self.direction - self.spread
    local theta2 = self.direction + self.spread

    local cx = self.x + self.radius
    local cy = self.y + self.radius

    local dx = cx - entity.x
    local dy = cy - entity.y

    local theta = math.atan2(dy, dx)

    if theta < 0 then
        theta = 2 * math.pi + theta
    end

    return theta1 <= theta and theta <= theta2
end

function Turret:draw()
    local cx = self.x + self.radius
    local cy = self.y + self.radius

    love.graphics.setColor(255, 0, 255)
    love.graphics.circle("line", cx, cy, self.radius)

    -- Draw boundaries of the field of vier as lines
    local px = self.x
    local py = cy
    local theta0 = self.direction
    local theta1 = self.direction - self.spread
    local theta2 = self.direction + self.spread

    local rx, ry = rotateAbout(px, py, cx, cy, theta0)
    love.graphics.setColor(255, 228, 181)
    love.graphics.line(cx, cy, rx, ry)

    love.graphics.setColor(200, 0, 100)
    rx, ry = rotateAbout(px, py, cx, cy, theta1)
    love.graphics.line(cx, cy, rx, ry)

    rx, ry = rotateAbout(px, py, cx, cy, theta2)
    love.graphics.line(cx, cy, rx, ry)
end

return Turret
