local class = require "middleclass.middleclass"

local Mobile = require "mobile"
local Zombie = class("Zombie", Mobile)

local global = require "global"

local maxspeed = 10

function Zombie:initialize(x, y)
    Mobile.initialize(self, x, y)

    self.hitbox = global.addHitbox(self, x, y, 10, 10)
    self:setTarget(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    self:setMaxSpeed(10)
end

function Zombie:draw()
    local radius = 5
    love.graphics.setColor(255, 255, 255)
    love.graphics.circle("line", self.x+radius, self.y+radius, radius)
end

function Zombie.spawn()
    local x = 0
    local y = 0
    local rand = love.math.random(3)
    if rand == 0 then
        x = 0
        y = love.math.random(love.graphics.getHeight())
    elseif rand == 1 then
        x = love.math.random(love.graphics.getWidth())
        y = 0
    elseif rand == 2 then
        x = love.graphics.getWidth()
        y = love.math.random(love.graphics.getHeight())
    else
        x = love.math.random(love.graphics.getWidth())
        y = love.graphics.getHeight()
    end
    global.addDrawable(Zombie:new(x, y))
end

return Zombie
