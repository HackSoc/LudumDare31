local Static = {}
Static.__index = Static

local Collidable = require "collidable"

setmetatable(Static, {
    __index = Collidable
})

function Static.new(x, y, collider)
    local self = Collidable.new(x, y, collider)
    setmetatable(self, Static)
    return self
end

return Static
