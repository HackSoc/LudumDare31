local class = require "middleclass.middleclass"

local Mobile = require "mobile"
local Human = class("Human", Mobile)

local global = require "global"

function Human:initialize(x, y)
    Mobile.initialize(self, x, y)

    self.hitbox = global.addHitbox(self, x, y, 10, 10)
    self.selected = false
    self.targetx = nil
    self.targety = nil
    self:setMaxSpeed(50)
end

function Human:draw()
    love.graphics.setColor(255, 255, 255)
    local drawstyle = "line"
    if self.selected then
        drawstyle = "fill"
    end
    love.graphics.rectangle(drawstyle, self.x, self.y, 10, 10)

    -- draw portion of health bar for remaining health
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle("fill", self.x, self.y-5, self.hp/10, 2)
    -- draw portion of health bar for health lost
    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle("fill", self.x + self.hp/10, self.y-5, 10 - self.hp/10, 2)
end

function Human:toggleSelected()
    self.selected = not self.selected
end

function Human:setSelected()
    self.selected = true
end

function Human:setUnselected()
    self.selected = false
end

return Human
