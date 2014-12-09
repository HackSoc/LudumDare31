local class = require "middleclass.middleclass"
local Zgrid = require "zgrid"

local ZombieGrid = class("ZombieGrid", Zgrid)

local global = require "global"

local Collidable = require "collidable"

function ZombieGrid:initialize(w, h, cellsize)
    Zgrid.initialize(self, w, h, cellsize)
end

function ZombieGrid:compute()
    self:reset()
    for e, _ in pairs(global.entities) do
        if e:isInstanceOf(Collidable) then
            if e.w and e.h then
                self:putRegion(
                    function (i, j)
                        self.pre_weights[i][j] = e:brains()
                        self.resistances[i][j] = e:zombieResistance()
                    end,
                    e.x, e.y, e.w, e.h
                )
            else
                local x, y = e:center()
                self:put(
                    function (i, j)
                        self.pre_weights[i][j] = e:brains()
                        self.resistances[i][j] = e:zombieResistance()
                    end,
                    x, y
                )
            end
        end
    end
    Zgrid.compute(self)
end

function ZombieGrid:gradientAt(x, y)
    local dx, dy = Zgrid.gradientAt(self, x, y)
    local function isnan(x)
        return x ~= x
    end
    if (dx == 0 and dy == 0) or isnan(dx) or isnan(dy) then
        dx = love.graphics.getWidth()/2 - x
        dy = love.graphics.getHeight()/2 - y
    end
    return dx, dy
end

return ZombieGrid
