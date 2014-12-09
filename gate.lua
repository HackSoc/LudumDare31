local class = require "middleclass.middleclass"

local Static = require "static"
local Gate = class("Gate", Static)

local global = require "global"
local Collidable = require "collidable"

function Gate:initialize(x, y, w, h, hotzone)
    Static.initialize(self, x, y, 5000)

    self.w = w
    self.h = h
    self.hotzone = hotzone
    self.command_open = false
    self.is_open = false
    self.hitbox = global.addHitbox(self, x, y, w, h)
    self.stopsHumans = false
    self.is_destroyed = false
    self.is_ghost = false
end

function Gate:stopsBullets()
    return not (self.is_open or self.is_destroyed or self.is_ghost)
end

function Gate:draw()
    if self.is_destroyed then
        return
    end
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
    if self.is_destroyed then
        return
    end
    self:ghost()
    self.is_open = true
end

function Gate:open()
    if self.is_destroyed then
        return
    end
    self:ghost()
    self.is_open = true
    self.command_open = true
end

function Gate:close()
    if self.is_destroyed then
        return
    end
    self:solidify()
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

function Gate:heal(amount)
    self:solidify()
    if self.is_destroyed then
       self.is_destroyed = false
       self.is_open = false
    end

    self.hp = self.hp + amount
    if self.hp >= self.maxhp then
        self.hp = self.maxhp
    end
end

function Gate:update(dt)
    Collidable.update(self)
    if not self.is_destroyed and self.is_open and not self.command_open then
        self:close()
    end
    if self.hotzone and self.hotzone:containsHuman() then
        self:heal(50 * dt)
    end
end

function Gate:destroy()
    self:ghost()
    self.is_destroyed = true
    self.is_open = true
end

function Gate:ghost()
    if not self.is_ghost then
        self.is_ghost = true
        global.setGhost(self.hitbox)
    end
end

function Gate:solidify()
    if self.is_ghost then
        self.is_ghost = false
        global.setSolid(self.hitbox)
    end
end

function Gate:brains()
    return 0
end

return Gate
