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
