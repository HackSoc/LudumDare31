local Static = {}
Static.__index = Static

local Collidable = require "collidable"

setmetatable(Static, {
    __index = Collidable
})

function Static.new()
    local self = Collidable.new()
    setmetatable(self, Static)
    return self
end

return Static
