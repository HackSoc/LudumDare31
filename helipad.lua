local global = require "global"
local class = require "middleclass.middleclass"

local Static = require "static"
local Helipad = class("Helipad", Static)

local Human = require "human"

local drawing = require "drawing"

local image = love.graphics.newImage('helipad.png')

function Helipad:initialize(x, y, hotzone)
    Static.initialize(self, x, y)

    self.stopsBullets = false
    self.stopsHumans = false

    self.cooldown = 0
    self.max_cooldown = 30

    self.hotzone = hotzone
end

function Helipad:update(dt)

    if self.hotzone:containsHuman() then
        self.cooldown = self.cooldown + dt
    end

    if self.cooldown >= self.max_cooldown then
        self.cooldown = 0
        global.addDrawable(Human(self.x+15, self.y+15, 10, 0.1, 1))
    end

end

function Helipad:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(image, self.x, self.y)
    drawing.bar(self.x, self.y - 5,
                image:getWidth(), 3,
                self.cooldown / self.max_cooldown,
                {0, 255, 255},
                {0, 0,   255})
end

return Helipad
