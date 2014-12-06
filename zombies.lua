local Zombie = {}
Zombie.__index = Zombie

local Mobile = require "mobile"

setmetatable(Zombie, {
    __index = Mobile
})

function Zombie.new()
    local self = Mobile.new()
    setmetatable(self, Zombie)
    return self
end

return Zombie
