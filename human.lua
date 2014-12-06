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

return Human
