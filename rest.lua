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
        h:heal(50)
        h:awaken()
    end
end

return Rest
