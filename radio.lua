local global = require "global"
local class = require "middleclass.middleclass"

local Periodic = require "periodic"
local Radio = class("Radio", Periodic)

local Tank = require "tank"

local image = love.graphics.newImage('radio.png')

function Radio:initialize(x, y, hotzone)
    Periodic.initialize(self, x, y, hotzone, image)
    self.max_cooldown = 90
end

function Radio:trigger()
    if math.random(2) == 1 then
        global.addDrawable(Tank(0, 40))
    else
        global.addDrawable(Tank(0, 650))
    end
end

return Radio
