local global = require "global"
local Wall = require "wall"
local Zombie = require "zombie"

function love.load()
    global.addDrawable(Wall:new(220, 150, 350, 1))
    global.addDrawable(Wall:new(200, 150, 1, 100))
    global.addDrawable(Wall:new(200, 350, 1, 100))
    global.addDrawable(Wall:new(200, 450, 200, 1))
    global.addDrawable(Wall:new(450, 450, 150, 1))
    global.addDrawable(Wall:new(600, 150, 1, 300))
    global.addDrawable(Zombie:new(0,0))
    global.addDrawable(Zombie:new(0,love.graphics.getHeight()))
    global.addDrawable(Zombie:new(love.graphics.getWidth(),0))
    global.addDrawable(Zombie:new(love.graphics.getWidth(), love.graphics.getHeight()))
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
