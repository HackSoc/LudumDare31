local entities = {}
local drawables = {}

-- State used for the onCollision function. 'collider' is the actual
-- collider object, and 'shapeMap' is a map from hitboxes to objects,
-- as we cannot associate data with shapes.
local HC = require 'hardoncollider'
local collider = nil
local shapeMap = {}

function love.load()
    -- initialisation code goes here

   collider = HC(100, onCollision)
end

function love.update(dt)
    for _, e in pairs(entities) do
        e:update(dt)
    end
end

function love.update(dt)
    -- simulate the passing of time---<dt> is the
    -- time (fraction of a second) that has passed
    -- since the last call to love.update

   collider:update(dt)
end

function onCollision(dt, a, b, dx, dy)
   shapeMap[a]:onCollision(b, dx, dy)
   shapeMap[b]:onCollision(a, dx, dy)
end

function love.draw()
    -- draw the current frame
    for k, v in pairs(drawables) do
        v:draw()
    end
end

function love.keypressed(key)
    -- handle <key> being pressed
end

function love.keyreleased(key)
    -- handle <key> being released
end

function love.mousepressed(x, y, button)
    -- handle mouse presses
end

function love.mousereleased(x, y, button)
    -- handle mouse button releases
end
