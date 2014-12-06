local class = require "middleclass.middleclass"

local Collidable = require "collidable"
local Mobile = class("Mobile", Collidable)

local bufsize = 32

function Mobile:initialize(x, y, maxhp)
    Collidable.initialize(self, x, y, maxhp)

    self.vx = 0
    self.vy = 0
    self.targetx = nil
    self.targety = nil
    self.maxspeed = 1 --Stupid small default speed

    -- Record previous positions
    self.buffer = {}
    self.bufidx = 0
    self.rotation = 0
end

function Mobile:onCollision(other, dx, dy)
    if other:isInstanceOf(Collidable) then
        self.x = self.x + dx
        self.y = self.y + dy
    end
end

function Mobile:update(dt)
    if self.targetx and self.targety then
        local dx = self.targetx - self.x
        local dy = self.targety - self.y
        local mag = math.sqrt(dx^2 + dy^2)
        self.vx = dx / mag * self.maxspeed
        self.vy = dy / mag * self.maxspeed
        if (self.vx ~= 0 or self.vy ~= 0) then
            self.rotation = math.deg(math.atan2(self.vx, self.vy))
        end
    end
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    self.buffer[self.bufidx] = {x=self.x, y=self.y}
    self.bufidx = (self.bufidx + 1) % bufsize
    local oldbufidx = (self.bufidx - bufsize) % bufsize
    if self.buffer[oldbufidx] then
        local dx = math.abs(self.buffer[oldbufidx].x - self.x)
        local dy = math.abs(self.buffer[oldbufidx].y - self.y)
        if dx < 2 and dy < 2 then
            self.vx = 0
            self.vy = 0
            self.targetx = nil
            self.targety = nil
        end
    end
    Collidable.update(self, dt)
end

function Mobile:setTarget(x, y)
    self.targetx = x
    self.targety = y
    self.buffer = {}
end

function Mobile:setMaxSpeed(speed)
    self.maxspeed = speed
end

return Mobile
