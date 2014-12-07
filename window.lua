local class = require "middleclass.middleclass"

local Static = require "static"
local Window = class("Window", Static)

local global = require "global"
local Collidable = require "collidable"

function Window:initialize(x, y, w, h)
    Static.initialize(self, x, y, 200)

    self.w = w
    self.h = h
    self.hitbox = global.addHitbox(self, x, y, w, h)
end

function Window:draw()
    love.graphics.setColor(112, 128, 144, 100)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

function Window:hurt(damage)
    -- Static does nothing
    Collidable.hurt(self, damage)
end

return Window

