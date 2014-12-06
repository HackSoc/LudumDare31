local Human = {}
Human.__index = Human

local Mobile = require "mobile"

setmetatable(Human, {
    __index = Mobile
})

function Human.new(x, y)
    local self = Mobile.new(x, y)
    setmetatable(self, Human)
    return self
end

function Human:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.rect("line", self.x, self.y, 10, 10)
end

return Human
