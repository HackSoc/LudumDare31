local class = require "middleclass.middleclass"

local Mobile = require "mobile"
local Human = class("Human", Mobile)

local global = require "global"

function Human:initialize(x, y)
    Mobile.initialize(self, x, y)

    self.hitbox = global.addHitbox(self, x, y, 10, 10)
end

function Human:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("line", self.x, self.y, 10, 10)
end

return Human
