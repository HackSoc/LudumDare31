local global = require "global"
local class = require "middleclass.middleclass"

local LevelLoader = class("LevelLoader")

local Wall = require "wall"
local Gate = require "gate"
local HotZone = require "hotzone"
local Turret = require "turret"
local Human = require "human"

local level = {math=math}

--wall {x=<n>, y=<n>, dir=<'v'|'h'>, len=<n>}
function level.wall(info)
    local w = 0
    local h = 0
    if info.dir == 'v' then
        w = 3
        h = info.len
    elseif info.dir == 'h' then
        w = info.len
        h = 3
    else
        error("Invalid wall direction")
    end
    global.addDrawable(Wall(info.x, info.y, w, h))
end

--gate {x=<n>, y=<n>, dir=<'v'|'h'>, len=<n>}
function level.gate(info)
    local w = 0
    local h = 0
    if info.dir == 'v' then
        w = 5
        h = info.len
    elseif info.dir == 'h' then
        w = info.len
        h = 5
    else
        error("Invalid gate direction")
    end
    global.addDrawable(Gate(info.x, info.y, w, h))
end

--turret {x=<n>, y=<n>, dir=<n*pi>, hx=<n>, hy=<n>, hw=<n>, hh=<n>}
function level.turret(info)
    local hz = HotZone(info.hx, info.hy, info.hw, info.hh)
    global.addDrawable(hz)
    global.addDrawable(Turret(info.x, info.y, 10, 0.1, 1, 75, info.dir, math.pi/4, hz))
end

--human {x=<n>, y=<n>}
function level.human(info)
    global.addDrawable(Human(info.x, info.y, 10, 0.1, 1))
end

function LevelLoader:initialize(module)
    loadfile(module .. '.lua', 't', level)()
end

return LevelLoader
