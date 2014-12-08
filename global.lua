local global = {}

global.entities = {}
global.drawables = {}
global.destroyedDrawables = nil
global.humans = {}
global.zombies = {}
global.killedZombies = 0

global.debug = false
global.showHelp = true
global.endGame = false

local HC = require "hardoncollider"
local HCShapes = require "hardoncollider.shapes"
local Grid = require "grid"

global.grid = Grid(86, 48, 15)

local function onCollision(dt, a, b, dx, dy)
    a.entity:onCollision(b.entity, dx, dy)
    b.entity:onCollision(a.entity, -dx, -dy)
end

global.collider = HC(100, onCollision)

function global.addHitbox(obj, x, y, w, h)
    local hitbox = global.collider:addRectangle(x, y, w, h)
    hitbox.entity = obj

    return hitbox
end

function global.removeHitbox(hitbox)
    global.collider:remove(hitbox)
end

function global.setGhost(hitbox)
    global.collider:setGhost(hitbox)
end

function global.setSolid(hitbox)
    global.collider:setSolid(hitbox)
end

function global.drawHitboxes()
    for h, _ in pairs(global.entities) do
        if h.hitbox ~= nil then
            h.hitbox:draw("line")
        end
    end
end

function global.addEntity(obj)
    global.entities[obj] = obj

    local class = obj.class.name:lower() .. "s"
    if global[class] ~= nil then
        global[class][obj] = obj
    end
end

function global.removeEntity(obj)
    global.entities[obj] = nil

    local class = obj.class.name:lower() .. "s"
    if global[class] ~= nil then
        global[class][obj] = nil
    end
end

function global.addDrawable(obj)
    global.addEntity(obj)
    table.insert(global.drawables, obj)
end

function global.removeDrawable(obj)
    global.removeEntity(obj)
    global.destroyedDrawables = global.destroyedDrawables or {}
    global.destroyedDrawables[obj] = obj
end

function global.correctDrawables()
    if global.destroyedDrawables then
        local newDrawables = {}
        for _, d in ipairs(global.drawables) do
            if not global.destroyedDrawables[d] then
                table.insert(newDrawables, d)
            end
        end
        global.drawables = newDrawables
    end
    global.destroyedDrawables = nil
    table.sort(global.drawables,
               function (d1, d2) return d1.layer < d2.layer end)
end

function global.collidablesAt(x, y)
    local collidables = {}
    for _, shape in pairs(global.collider:shapesAt(x, y)) do
        collidables[shape.entity] = shape.entity
    end
    return collidables
end

function global.collidablesUnder(x0, y0, x1, y1)
    local collidables = {}
    if x0 == x1 or y0 == y1 then
        return collidables
    end

    local rect = HCShapes.newPolygonShape(x0, y0, x1, y0, x1, y1, x0, y1)
    if x0 > x1 then
        x0, x1 = x1, x0
    end
    if y0 > y1 then
        y0, y1 = y1, y0
    end
    for _, shape in pairs(global.collider:shapesInRange(x0, y0, x1, y1)) do
        if shape:collidesWith(rect) then
            collidables[shape.entity] = shape.entity
        end
    end
    return collidables
end

function global.countSelected()
    local selcount = 0
    for _, h in pairs(humans) do
        if h.selected then
            selcount = selcount + 1
        end
    end
    return selcount
end

global.messages = {}
global.messagenum = 0
global.maxmessages = 10

function global.log(str)
    if global.messagenum == global.maxmessages then
        local msgs = {}
        for i = 1, global.messagenum - 1 do
            msgs[i] = global.messages[i + 1]
        end

        global.messages = msgs
        global.messagenum = global.messagenum - 1
    end

    global.messagenum = global.messagenum + 1
    global.messages[global.messagenum] = str
end

return global
