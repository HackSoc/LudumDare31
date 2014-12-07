local class = require "middleclass.middleclass"

local Mobile = require "mobile"
local Human = class("Human", Mobile)

local global = require "global"
local Gun = require "gun"
local Zombie = require "zombie"

local size = 10
local range = 100

local heal_rate = 10

local image = love.graphics.newImage('human.png')
local image_selected = love.graphics.newImage('human_selected.png')

function Human:initialize(x, y, ammo, cooldown, reload)
    Mobile.initialize(self, x, y, 100)

    self.hitbox = global.addHitbox(self, x, y, size, size)
    self.selected = false
    self.targetx = nil
    self.targety = nil
    self.infected = false
    self:setMaxSpeed(50)

    self.mode = "normal"

    self.gun = Gun:new(15, 10, ammo, cooldown, reload, 10)
end

function Human:draw()
    love.graphics.setColor(255, 255, 255)
    local im = image
    if self.selected then
        im = image_selected
    end
    -- love.graphics.rectangle(drawstyle, self.x, self.y, size, size)
    love.graphics.draw(im, self.x, self.y, self.rotation,
                       1, 1,
                       im:getWidth()/2, im:getHeight()/2)

    -- draw portion of health bar for remaining health
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle("fill",
                            self.x-im:getWidth()/2,
                            self.y-im:getHeight()/2,
                            self.hp/10, 2)
    -- draw portion of health bar for health lost
    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle("fill",
                            self.x-im:getWidth()/2 + self.hp/10,
                            self.y-im:getHeight()/2,
                            10 - self.hp/10, 2)
end

function Human:update(dt)
    self.gun:update(dt)

    if self.mode == "normal" then
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
            local zx, zy = zeds[zid].x, zeds[zid].y
            self.rotation = math.atan2(zx - self.x, self.y - zy)
            self.gun:fire(self.x + size / 2, self.y + size / 2, zeds[zid])
        end
    elseif self.mode == "heal" then
        self.hp = self.hp + heal_rate * dt
        if self.hp >= self.maxhp then
            self.hp = self.maxhp
            self.infected = false
        end
    end

    closeZ = self:getClosest("Zombie")
    if self.targetx == nil and closeZ and self:getAbsDistance(closeZ) < 20 then
        self.targetx = self.x - (closeZ.x - self.x)
        self.targety = self.y - (closeZ.y - self.y)
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

function Human:setMode(mode)
    self.mode = mode
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
