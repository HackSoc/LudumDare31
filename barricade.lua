local class = require "middleclass.middleclass"

local Static = require "static"
local Barricade = class("Barricade", Static)

local global = require "global"
local Collidable = require "collidable"

local image = love.graphics.newImage('barricade.png')

function Barricade:initialize(x, y)
    Static.initialize(self, x, y, 200)

    self.hitbox = global.addHitbox(self, x, y, 15, 15)
end

function Barricade:stopsBullets()
    return false
end

function Barricade:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(image, self.x, self.y)
end

function Barricade:hurt(damage)
    -- Static does nothing
    Collidable.hurt(self, damage)
end

function Barricade:brains()
    return -3
end

function Barricade:destroy()
    Collidable.destroy(self)
end

return Barricade
