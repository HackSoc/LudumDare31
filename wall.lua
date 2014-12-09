local class = require "middleclass.middleclass"

local Static = require "static"
local Wall = class("Wall", Static)

local global = require "global"

function Wall:initialize(x, y, w, h)
    Static.initialize(self, x, y)

    self.w = w
    self.h = h
    self.layer = 2
    self.hitbox = global.addHitbox(self, x, y, w, h)
end

function Wall:draw()
    love.graphics.setColor(128,128,128)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

function Wall:zombieResistance()
    return math.huge
end

function Wall:humanResistance()
    return math.huge
end

return Wall
