local global = require "global"
local class = require "middleclass.middleclass"

local LevelLoader = class("LevelLoader")

local Wall = require "wall"
local Gate = require "gate"
local HotZone = require "hotzone"
local Turret = require "turret"
local Human = require "human"

local level = {math=math}

local function correctWall(info, thickness)
    local x, y, w, h
    x = info.x * 15 + 6
    y = info.y * 15 + 6
    if info.dir == 'v' then
        w = thickness
        h = info.len * 15 + 3
        x = x - (thickness-3) / 2
    elseif info.dir == 'h' then
        w = info.len * 15 + 3
        h = thickness
        y = y - (thickness-3) / 2
    else
        error("Invalid direction")
    end
    return x, y, w, h
end

--wall {x=<n>, y=<n>, dir=<'v'|'h'>, len=<n>}
function level.wall(info)
    global.addDrawable(Wall(correctWall(info, 3)))
end

--gate {x=<n>, y=<n>, dir=<'v'|'h'>, len=<n>}
function level.gate(info)
    global.addDrawable(Gate(correctWall(info, 5)))
end

--turret {x=<n>, y=<n>, dir=<n*pi>, hx=<n>, hy=<n>, hw=<n>, hh=<n>}
function level.turret(info)
    local hz = HotZone(info.hx*15+8, info.hy*15+8, info.hw*15, info.hh*15)
    global.addDrawable(hz)
    global.addDrawable(Turret(info.x*15+8, info.y*15+8, 10, 0.1, 1, 75, info.dir, math.pi/4, hz))
end

--human {x=<n>, y=<n>}
function level.human(info)
    global.addDrawable(Human(info.x*15+8, info.y*15+8, 10, 0.1, 1))
end

function LevelLoader:initialize(module)
    loadfile(module .. '.lua', 't', level)()
end

return LevelLoader
