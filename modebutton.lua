local class = require "middleclass.middleclass"

local Button = require "button"
local ModeButton = class("ModeButton", Button)

local global = require "global"

function ModeButton:initialize(x, y, sprite, mode)
    Button.initialize(self, x, y, sprite)
    self.mode = mode
end

function ModeButton:onClick()
    for _, o in pairs(global.humans) do
        if o.selected then
            o:setMode(self.mode)
        end
    end
end

return ModeButton
