local global = require "global"
local class = require "middleclass.middleclass"

local Entity = require "entity"
local Drawable = class("Drawable", Entity)

function Drawable:initialize(x, y)
    Entity.initialize(self, x, y)
end

function Drawable:draw()

end

function Drawable:destroy()
    global.removeDrawable(self)
    Entity.destroy(self)
end

return Drawable
