local Static = {}
Static.__index = Static

local Collidable = require "collidable"

setmetatable(Static, {
    __index = Collidable
})

function Static.new(x, y)
    local self = Collidable.new(x, y)
    setmetatable(self, Static)
    return self
end

return Static
