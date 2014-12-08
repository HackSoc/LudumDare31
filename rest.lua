local global = require "global"
local class = require "middleclass.middleclass"

local Periodic = require "periodic"
local Rest = class("Rest", Periodic)

local Human = require "human"

local image = love.graphics.newImage('rest.png')

function Rest:initialize(x, y, hotzone)
    Periodic.initialize(self, x, y, hotzone, image)
    self.max_cooldown = 15
end

function Rest:trigger()
    for _, h in pairs(global.humans) do
        if self:contains(h) then
            h:heal(50)
            h:awaken()
        end
    end
end

function Rest:contains(human)
    return human.x >= self.x and human.x <= self.x + self.image:getWidth() and
           human.y >= self.y and human.y <= self.y + self.image:getHeight()
end

return Rest
