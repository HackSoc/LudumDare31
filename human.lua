local Human = {}
Human.__index = Human

local Mobile = require "mobile"

setmetatable(Human, {
    __index = Mobile
})

function Human.new()
    local self = Mobile.new()
    setmetatable(self, Human)
    return self
end

return Human
