local global = require "global"

function love.load()
    -- initialisation code goes here
end

function love.update(dt)
    for o, _ in pairs(global.entities) do
        o:update(dt)
    end
    global.collider:update(dt)
end

function love.draw()
    -- draw the current frame
    for o, _ in pairs(global.drawables) do
        o:draw()
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
