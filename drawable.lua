local Drawable = {}
Drawable.__index = Drawable


function Drawable.new(x, y)
    local self = {
        x = x,
        y = y
    }
    setmetatable(self, Drawable)
    return self
end

function Drawable:draw()

end

return Drawable
