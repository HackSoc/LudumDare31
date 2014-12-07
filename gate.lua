local class = require "middleclass.middleclass"

local Static = require "static"
local Gate = class("Gate", Static)

local global = require "global"
local Collidable = require "collidable"

function Gate:initialize(x, y, w, h)
    Static.initialize(self, x, y, 5000)

    self.w = w
    self.h = h
    self.is_open = false
    self.hitbox = global.addHitbox(self, x, y, w, h)
end

function Gate:draw()
    if self.is_open then
        love.graphics.setColor(205, 133, 63, 100)
    else
        love.graphics.setColor(205, 133, 63)
    end
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

function Gate:open()
    self.is_open = true
    global.setGhost(self.hitbox)
end

function Gate:close()
    self.is_open = false
    global.setSolid(self.hitbox)
end

function Gate:toggle()
    if self.is_open then
        self:close()
    else
        self:open()
    end
end

function Gate:hurt(damage)
    -- Static does nothing
    Collidable.hurt(self, damage)
end

return Gate
