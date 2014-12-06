local Mobile = {}
Mobile.__index = Mobile

local Collidable = require "collidable"

setmetatable(Mobile, {
    __index = Collidable
})

function Mobile.new()
    local self = Collidable.new()
    setmetatable(self, Mobile)
    return self
end

return Mobile
