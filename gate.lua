local class = require "middleclass.middleclass"

local Static = require "static"
local Gate = class("Gate", Static)

local global = require "global"
local Collidable = require "collidable"

function Gate:initialize(x, y, w, h)
    Static.initialize(self, x, y, 5000)

    self.w = w
    self.h = h
    self.command_open = false
    self.is_open = false
    self.hitbox = global.addHitbox(self, x, y, w, h)
    self.stopsHumans = false
end

function Gate:draw()
    if self.is_open then
        love.graphics.setColor(205, 133, 63, 100)
    else
        local nr, ng, nb = 205, 133, 63
        local dr, dg, db = 255, 0, 0
        local hpr = self.hp/self.maxhp
        local r = (nr * hpr + dr * (1-hpr))
        local g = (ng * hpr + dg * (1-hpr))
        local b = (nb * hpr + db * (1-hpr))
        love.graphics.setColor(r, g, b)
    end
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

function Gate:passingHuman()
    if not self.is_open then
        global.setGhost(self.hitbox)
    end
    self.is_open = true
end

function Gate:open()
    if not self.is_open then
        global.setGhost(self.hitbox)
    end
    self.is_open = true
    self.command_open = true
end

function Gate:close()
    if self.is_open then
        global.setSolid(self.hitbox)
    end
    self.is_open = false
    self.command_open = false
end

function Gate:toggle()
    if self.command_open then
        self:close()
    else
        self:open()
    end
end

function Gate:hurt(damage)
    -- Static does nothing
    Collidable.hurt(self, damage)
end

function Gate:update()
    Collidable.update(self)
    if self.is_open and not self.command_open then
        self:close()
    end
end

return Gate
