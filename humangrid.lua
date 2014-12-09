local class = require "middleclass.middleclass"
local Grid = require "grid"

local HumanGrid = class("HumanGrid", Grid)

local global = require "global"

local Collidable = require "collidable"

function HumanGrid:initialize(w, h, cellsize)
    Grid.initialize(self, w, h, cellsize)
    self.destx = nil
    self.desty = nil
end

function HumanGrid:setDest(x, y)
    self.destx = x
    self.desty = y
end

function HumanGrid:clearDest()
    self.destx = nil
    self.desty = nil
end

function HumanGrid:compute()
    self:reset()
    for e, _ in pairs(global.entities) do
        if e:isInstanceOf(Collidable) then
            if e.w and e.h then
                self:putRegion(
                    function (i, j)
                        self.resistances[i][j] = e:humanResistance()
                    end,
                    e.x, e.y, e.w, e.h
                )
            else
                local x, y = e:center()
                self:put(
                    function (i, j)
                        self.resistances[i][j] = e:humanResistance()
                    end,
                    x, y
                )
            end
        end
    end
    if self.destx and self.desty then
        self:put(
            function (i, j)
                self.pre_weights[i][j] = 0
            end,
            self.destx, self.desty
        )
    end
    Grid.compute(self)
end

function HumanGrid:gradientAt(x, y)
    local dx, dy = Grid.gradientAt(self, x, y)
    local function isnan(x)
        return x ~= x
    end
    if (dx == 0 and dy == 0) or isnan(dx) or isnan(dy) then
        dx = 0
        dy = 0
    end
    return dx, dy
end

return HumanGrid
