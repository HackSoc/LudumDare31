local global = require "global"
local Wall = require "wall"
local Zombie = require "zombie"
local Mob = require "mob"

function love.load()
    global.addDrawable(Wall:new(220, 150, 350, 1))
    global.addDrawable(Wall:new(200, 150, 1, 100))
    global.addDrawable(Wall:new(200, 350, 1, 100))
    global.addDrawable(Wall:new(200, 450, 200, 1))
    global.addDrawable(Wall:new(450, 450, 150, 1))
    global.addDrawable(Wall:new(600, 150, 1, 300))
end

function love.update(dt)
    for o, _ in pairs(global.entities) do
        o:update(dt)
    end
    global.collider:update(dt)

    if love.math.random() <= 0.25 * dt then
        Zombie.spawn()
    end
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
