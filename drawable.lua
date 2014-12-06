local Drawable = {}
Drawable.__index = Drawable


function Drawable.new()
    local self = {
    }
    setmetatable(self, Drawable)
    return self
end

return Drawable
