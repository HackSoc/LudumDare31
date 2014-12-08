local global = require "global"
local class = require "middleclass.middleclass"

local LevelLoader = class("LevelLoader")

local Wall = require "wall"
local Gate = require "gate"
local Window = require "window"
local HotZone = require "hotzone"
local Turret = require "turret"
local Human = require "human"
local Helipad = require "helipad"

local level = {math=math}

local function correctWall(info, thickness, offby)
    local x, y, w, h
    offby = offby or 0
    x = info.x * 15 + 6
    y = info.y * 15 + 6
    if info.dir == 'v' then
        w = thickness
        h = info.len * 15 + 3 - offby * 2
        x = x - (thickness-3) / 2
        y = y + offby
    elseif info.dir == 'h' then
        w = info.len * 15 + 3 - offby * 2
        h = thickness
        y = y - (thickness-3) / 2
        x = x + offby
    else
        error("Invalid direction")
    end
    return x, y, w, h
end

local function mkhz(info)
    return HotZone(info.hx*15+8, info.hy*15+8, info.hw*15, info.hh*15)
end

--wall {x=<n>, y=<n>, dir=<'v'|'h'>, len=<n>}
function level.wall(info)
    local x, y, w, h = correctWall(info, 3)
    global.addDrawable(Wall(x, y, w, h))
    global.grid:fillRegion(x, y, w, h)
end

--wall {x=<n>, y=<n>, dir=<'v'|'h'>, len=<n>}
function level.window(info)
    local x, y, w, h = correctWall(info, 3)
    global.addDrawable(Window(x, y, w, h))
end

--gate {x=<n>, y=<n>, dir=<'v'|'h'>, len=<n>}
function level.gate(info)
    local hz
    if info.hx and info.hy and info.hw and info.hh then
        hz = mkhz(info)
        global.addDrawable(hz)
    end
    local x, y, w, h = correctWall(info, 5, 3)
    global.addDrawable(Gate(x, y, w, h, hz))
end

--turret {x=<n>, y=<n>, dir=<n*pi>, hx=<n>, hy=<n>, hw=<n>, hh=<n>}
function level.turret(info)
    local hz = mkhz(info)
    global.addDrawable(hz)
    global.addDrawable(Turret(info.x*15+8, info.y*15+8, 10, 0.1, 1, 75, info.dir, math.pi/4, hz))
    global.grid:fillRegion(info.x*15, info.y*15, 30, 30)
end

function level.helipad(info)
    local hz = mkhz(info)
    global.addDrawable(hz)
    global.addDrawable(Helipad(info.x*15+8, info.y*15+8, hz))
end


--human {x=<n>, y=<n>}
function level.human(info)
    global.addDrawable(Human(info.x*15+8, info.y*15+8, 10, 0.1, 1))
end

function LevelLoader:initialize(module)
    loadfile(module .. '.lua', 't', level)()
end

return LevelLoader
