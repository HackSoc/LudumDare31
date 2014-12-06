local global = require "global"
local Wall = require "wall"
local Zombie = require "zombie"
local Human = require "human"

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

    if global.continuousspawn and love.math.random() <= 0.25 * dt then
        Zombie.spawn()
    end
end

function love.draw()
    for o, _ in pairs(global.drawables) do
        o:draw()
    end

    if global.debug then
        love.graphics.setColor(255, 0, 0)
        global.drawHitboxes()
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf(string.format("x: %d, y: %d", love.mouse.getX(), love.mouse.getY()), 0, 0 ,130)
    end
end

function love.keypressed(key)
    if key == "d" then
        global.debug = not global.debug
    elseif key == "z" then
        global.continuousspawn = not global.continuousspawn
    elseif key == "h" then
        global.addDrawable(Human:new(love.mouse.getPosition()))
    elseif key == 'c' then
        for e, _ in pairs(global.drawables) do
            if e:isInstanceOf(Human) or e:isInstanceOf(Zombie) then
                global.removeDrawable(e)
            end
        end
    elseif key == 'a' then
        select(global.entities)
    end
end

function love.keyreleased(key)

end

function select(entities)
    for e, _ in pairs(global.entities) do
        if e:isInstanceOf(Human) then
            if entities[e] then
                e:setSelected()
            else
                e:setUnselected()
            end
        end
    end
end

function love.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)
    if button == "l" then
        select(global.collidablesAt(x, y))
    elseif button == "r" then
        for e, _ in pairs(global.entities) do
            if e:isInstanceOf(Human) and e.selected then
                e:setTarget(x, y)
            end
        end
    end

end
