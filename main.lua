local entities = {}

function love.load()
    -- initialisation code goes here
end

function love.update(dt)
    for _, e in pairs(entities) do
        e:update(dt)
    end
end

function love.draw()
    -- draw the current frame
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
