local global = {}

global.entities = {}
global.drawables = {}

global.debug = false
global.continuousspawn = false

global.maxdrawlayer = 2

local HC = require "hardoncollider"
local HCShapes = require "hardoncollider.shapes"

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
end

function global.removeEntity(obj)
    global.entities[obj] = nil
end

function global.addDrawable(obj)
    global.addEntity(obj)
    global.drawables[obj] = obj
end

function global.removeDrawable(obj)
    global.removeEntity(obj)
    global.drawables[obj] = nil
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
