local global = require "global"
local class = require "middleclass.middleclass"

local Periodic = require "periodic"
local Helipad = class("Helipad", Periodic)

local Human = require "human"

local image = love.graphics.newImage('helipad.png')

function Helipad:initialize(x, y, hotzone)
    Periodic.initialize(self, x, y, hotzone, image)
    self.max_cooldown = 30
end

function Helipad:trigger()
    global.addDrawable(Human(self.x+15, self.y+15, 10, 0.1, 1))
end

return Helipad
