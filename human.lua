local class = require "middleclass.middleclass"

local Mobile = require "mobile"
local Human = class("Human", Mobile)

local global = require "global"

local maxspeed = 50

function Human:initialize(x, y)
    Mobile.initialize(self, x, y)

    self.hitbox = global.addHitbox(self, x, y, 10, 10)
    self.selected = false
    self.targetx = nil
    self.targety = nil
end

function Human:draw()
    love.graphics.setColor(255, 255, 255)
    local drawstyle = "line"
    if self.selected then
        drawstyle = "fill"
    end
    love.graphics.rectangle(drawstyle, self.x, self.y, 10, 10)
end

function Human:update(dt)
    if self.targetx and self.targety then
        local dx = self.targetx - self.x
        local dy = self.targety - self.y
        local mag = math.sqrt(dx^2 + dy^2)
        self.vx = dx / mag * maxspeed
        self.vy = dy / mag * maxspeed
    end
    Mobile.update(self, dt)
end

function Human:toggleSelected()
    self.selected = not self.selected
end

function Human:moveTo(x, y)
    self.targetx = x
    self.targety = y
end

return Human
