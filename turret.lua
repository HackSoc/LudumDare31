local global = require "global"
local class = require "middleclass.middleclass"

local Static = require "static"
local Turret = class("Turret", Static)

local Zombie = require "zombie"
local Gun = require "gun"

local image = love.graphics.newImage('turret.png')

-- Turrets have an ammo supply, which is gradually depleted. When
-- empty, the turret needs to recharge.
function Turret:initialize(x, y, ammo, cooldown, reload, accuracy, direction, spread, hotzone)
    Static.initialize(self, x, y)

    self.stopsBullets = false
    self.radius = 15 -- For drawing/hitbox
    if direction < 0 then
        self.direction = 2 * math.pi + direction
    else
        self.direction = direction
    end
    self.rotation = self.direction - math.pi/2
    self.spread = spread
    self.gun = Gun:new(self.radius, 50, ammo, cooldown, reload, accuracy)
    self.hitbox = global.addHitbox(self, x, y, self.radius * 2, self.radius * 2)
    self.hotzone = hotzone
    self.accuracy = accuracy
    self.target = nil
    self.layer = 3
end

function Turret:update(dt)
    if self.hotzone:containsHuman() then
        self.gun.accuracy = self.accuracy / 2
    elseif self.hotzone:containsZombie() then
        self.gun.accuracy = self.accuracy * 3
    end

    self.gun:update(dt)

    local zeds = {}
    local zcount = 0
    for _, e in pairs(global.zombies) do
        if self:isInFieldOfView(e) then
            zcount = zcount + 1
            zeds[zcount] = e
        end
    end
    if zcount > 0 then
        if not self.target or
           not global.entities[self.target] or
           not self:isInFieldOfView(self.target) then
            -- Pick a random zombie
            local zid = love.math.random(zcount)
            self.target = zeds[zid]
        end
    else
        self.target = nil
    end

    if self.target then
        local zx, zy = self.target.x, self.target.y
        self.rotation = math.atan2(zx - self.x, self.y - zy)
        self.gun:fire(self.x + self.radius, self.y + self.radius, self.target)
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
    love.graphics.setColor(255, 255, 255)
    local im = image
    -- love.graphics.rectangle(drawstyle, self.x, self.y, size, size)
    love.graphics.draw(im, self.x+im:getWidth()/2, self.y+im:getWidth()/2,
                       self.rotation,
                       1, 1,
                       im:getWidth()/2, im:getHeight()/2)

    -- local cx = self.x + self.radius
    -- local cy = self.y + self.radius

    -- love.graphics.setColor(210, 105, 30)
    -- love.graphics.circle("line", cx, cy, self.radius)

    -- -- Draw boundaries of the field of vier as lines
    -- local px = self.x
    -- local py = cy
    -- local theta0 = self.direction
    -- local theta1 = self.direction - self.spread
    -- local theta2 = self.direction + self.spread

    -- local rx, ry = rotateAbout(px, py, cx, cy, theta0)
    -- love.graphics.setColor(210, 180, 140)
    -- love.graphics.line(cx, cy, rx, ry)

    -- love.graphics.setColor(178, 34, 34)
    -- rx, ry = rotateAbout(px, py, cx, cy, theta1)
    -- love.graphics.line(cx, cy, rx, ry)

    -- rx, ry = rotateAbout(px, py, cx, cy, theta2)
    -- love.graphics.line(cx, cy, rx, ry)
end

return Turret
