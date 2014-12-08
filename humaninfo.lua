local class = require "middleclass.middleclass"

local Drawable = require "drawable"
local HumanInfo = class("HumanInfo", Drawable)

local global = require "global"

function HumanInfo:initialize(x, y) -- Unlikely to be used
    Drawable.initialize(self, x, y)
    self.selected = nil
end

function HumanInfo:update(dt)
    local selcount = 0
    for _, e in pairs(global.humans) do
        if e.selected then
            self.selected = e
            selcount = selcount + 1
        end
    end
    if selcount ~= 1 then
        self.selected = nil
    end
end

function HumanInfo:draw()
    if self.selected then
        local w = 200
        local wL = 275
        local x = love.graphics.getWidth() - w - 5
        local xL = love.graphics.getWidth() - wL - 5
        local y = 5

        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(self.selected.name .. " (" .. math.floor(self.selected.hp) .. ")", x, y, w, "center")
        y = y + 15

        if self.selected.talent ~= nil then
            love.graphics.setColor(100, 100, 100)
            love.graphics.printf("[" .. self.selected.talent .. "]", x, y, w, "center")
        end
        y = y + 30

        love.graphics.setColor(70, 130, 180)
        love.graphics.printf(self.selected.dream, xL, y, wL, "right")
        y = y + 30

        if self.selected.lastsaid ~= nil then
            love.graphics.setColor(165, 42, 42)
            love.graphics.printf(self.selected.lastsaid, xL, y, wL, "right")
        end
    end
end

return HumanInfo
