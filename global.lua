local global = {}

global.entities = {}
global.drawables = {}

global.debug = false

-- State used for the onCollision function. 'collider' is the actual
-- collider object, and 'shapeMap' is a map from hitboxes to objects,
-- as we cannot associate data with shapes.
local HC = require 'hardoncollider'
local shapeMap = {}

local function onCollision(dt, a, b, dx, dy)
    shapeMap[a]:onCollision(b, dx, dy)
    shapeMap[b]:onCollision(a, -dx, -dy)
end

global.collider = HC(100, onCollision)

function global.addHitbox(obj, x, y, w, h)
    local hitbox = global.collider:addRectangle(x, y, w, h)
    shapeMap[hitbox] = obj

    return hitbox
end

function global.removeHitbox(hitbox)
    global.collider:remove(hitbox)
    shapeMap[hitbox] = nil
end

function global.drawHitboxes()
    for h, _ in pairs(shapeMap) do
        h:draw("line")
    end
end

function global.addEntity(obj)
    global.entities[obj] = 1
end

function global.removeEntity(obj)
    global.entities[obj] = nil
end

function global.addDrawable(obj)
    global.addEntity(obj)
    global.drawables[obj] = 1
end

function global.removeDrawable(obj)
    global.removeEntity(obj)
    global.drawables[obj] = nil
end

function global.collidablesAt(x, y)
    local collidables = {}
    for _, shape in pairs(global.collider:shapesAt(x, y)) do
        table.insert(collidables, shapeMap[shape])
    end
    return collidables
end

return global
