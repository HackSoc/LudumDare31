local class = require "middleclass.middleclass"

local Static = require "static"
local Wall = class("Wall", Static)

local global = require "global"

function Wall:initialize(x, y, w, h)
    Static.initialize(self, x, y)

    self.w = w
    self.h = h
    self.hitbox = global.addHitbox(self, x, y, w, h)
end

function Wall:draw()
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

return Wall
