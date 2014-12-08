local global = require "global"
local class = require "middleclass.middleclass"

local Static = require "static"
local Periodic = class("Periodic", Static)

local drawing = require "drawing"

function Periodic:initialize(x, y, hotzone, image)
    Static.initialize(self, x, y)

    self.stopsBullets = false
    self.stopsHumans = false

    self.cooldown = 0
    self.max_cooldown = 30

    self.hotzone = hotzone

    self.image = image
    self.callback = callback
end

function Periodic:update(dt)
    if self.hotzone:containsHuman() then
        self.cooldown = self.cooldown + dt
    end

    if self.cooldown >= self.max_cooldown then
        self.cooldown = 0
        self:trigger()
    end
end

function Periodic:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.image, self.x, self.y)
    drawing.bar(self.x, self.y - 5,
                self.image:getWidth(), 3,
                self.cooldown / self.max_cooldown,
                {0, 255, 255},
                {0, 0,   255})
end

function Periodic:trigger()

end

return Periodic
