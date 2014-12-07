local class = require "middleclass.middleclass"

local Mobile = require "mobile"
local Human = class("Human", Mobile)

local global = require "global"
local Gun = require "gun"
local Zombie = require "zombie"

local size = 10
local range = 100

function Human:initialize(x, y, ammo, cooldown, reload)
    Mobile.initialize(self, x, y, 100)

    self.hitbox = global.addHitbox(self, x, y, size, size)
    self.selected = false
    self.targetx = nil
    self.targety = nil
    self.infected = false
    self:setMaxSpeed(50)

    self.gun = Gun:new(15, 10, ammo, cooldown, reload, 10)
end

function Human:draw()
    love.graphics.setColor(0, 191, 255)
    local drawstyle = "line"
    if self.selected then
        drawstyle = "fill"
    end
    love.graphics.rectangle(drawstyle, self.x, self.y, size, size)

    -- draw portion of health bar for remaining health
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle("fill", self.x, self.y-5, self.hp/10, 2)
    -- draw portion of health bar for health lost
    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle("fill", self.x + self.hp/10, self.y-5, 10 - self.hp/10, 2)
end

function Human:update(dt)
    self.gun:update(dt)

    local zeds = {}
    local zcount = 0
    for _, e in pairs(global.entities) do
        -- cycle breaking :(
        if e:isInstanceOf(Zombie) and self:getAbsDistance(e) < range then
            zcount = zcount + 1
            zeds[zcount] = e
        end
    end

    if zcount > 0 then
        -- Pick a random zombie
        local zid = love.math.random(zcount)
        self.gun:fire(self.x + size / 2, self.y + size / 2, zeds[zid])
    end

    if self.infected then
        self:hurt(5 * dt)
    end

    Mobile.update(self, dt)
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

function Human:zomb()
    self.infected = true
end

function Human:hurt(damage)
    self.hp = self.hp - damage

    if self.hp <= 0 then
        if self.infected then
            global.addDrawable(Zombie:new(self.x, self.y))
        end

        self:destroy()
    end
end

return Human
