local global = {}

global.entities = {}
global.drawables = {}

global.debug = false
global.continuousspawn = false

local HC = require 'hardoncollider'

local function onCollision(dt, a, b, dx, dy)
    a.entity:onCollision(b, dx, dy)
    b.entity:onCollision(a, -dx, -dy)
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

function global.drawHitboxes()
    for h, _ in pairs(global.entities) do
        if h.hitbox ~= nil then
            h.hitbox:draw("line")
        end
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
        collidables[shape.entity] = 1
    end
    return collidables
end

return global
