local class = require "middleclass.middleclass"

local Drawable = require "drawable"
local Button = class("Button", Drawable)

local global = require "global"

function Button:initialize(x, y, sprite)
    Drawable.initialize(self, x, y)
    self.h = sprite:getHeight()
    self.w = sprite:getWidth()
    self.sprite = sprite
    self.hitbox = global.addHitbox(self, x, y, self.w, self.h)
    self.depressed = false
    self.layer = 4
end

function Button:draw()
    if self.depressed then
        love.graphics.setColor(100, 100, 100)
    else
        love.graphics.setColor(255, 255, 255)
    end

    love.graphics.draw(self.sprite, self.x, self.y)
end

function Button:onClick()
end

function Button:onCollision()
end

function Button:destroy()
   if self.hitbox ~= nil then
      global.removeHitbox(self.hitbox)
   end

   Drawable.destroy(self)
end

return Button
