local global = require "global"
local Wall = require "wall"
local Zombie = require "zombie"
local Human = require "human"
local Bullet = require "bullet"
local Turret = require "turret"
local Gate = require "gate"
local Trap = require "trap"

function love.load()
    global.addDrawable(Wall:new(220, 150, 350, 3))
    global.addDrawable(Wall:new(200, 150, 3, 100))
    global.addDrawable(Wall:new(200, 350, 3, 100))
    global.addDrawable(Gate:new(198, 250, 5, 100))
    global.addDrawable(Wall:new(200, 450, 200, 3))
    global.addDrawable(Wall:new(450, 450, 150, 3))
    global.addDrawable(Wall:new(600, 150, 3, 300))
    global.addDrawable(Turret:new(190, 120, 10, 0.1, 1, 50, math.pi/4, math.pi/4))
    global.addDrawable(Turret:new(560, 120, 10, 0.1, 1, 50, 3*math.pi/4, math.pi/4))
    global.addDrawable(Turret:new(190, 430, 10, 0.1, 1, 50, -math.pi/4, math.pi/4))
    global.addDrawable(Turret:new(560, 430, 10, 0.1, 1, 50, -3*math.pi/4, math.pi/4))
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

    if dragging then
        love.graphics.setColor(255, 255, 255)
        love.graphics.rectangle("line", dragging.x, dragging.y,
                                love.mouse.getX() - dragging.x,
                                love.mouse.getY() - dragging.y)
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
        local x, y = love.mouse.getPosition()
        global.addDrawable(Human:new(x, y, 10, 0.1, 1))
    elseif key == "q" then
        global.addDrawable(Zombie:new(love.mouse.getPosition()))
    elseif key == 'c' then
        for e, _ in pairs(global.drawables) do
            if e:isInstanceOf(Human) or e:isInstanceOf(Zombie) then
                global.removeDrawable(e)
            end
        end
    elseif key == 'escape' then
        unselectAll()
    elseif key == 'a' then
        for e, _ in pairs(global.entities) do
            if e:isInstanceOf(Human) then
                e:setSelected()
            end
        end
    elseif key == 'b' then
        local b = Bullet(love.mouse.getX(), love.mouse.getY(), love.math.random(-250,250), love.math.random(-250,250), 50)
        global.addDrawable(b)
    elseif key == 't' then
        global.addDrawable(Trap(love.mouse.getX(), love.mouse.getY()))
    end
end

function love.keyreleased(key)

end

-- When holding shift, toggle the selection state of entities in the
-- set (but don't unselect things we have already selected), if not
-- holding shift, same as before: one-unit selections.
function click(entities)
    for e, _ in pairs(global.entities) do
        if e:isInstanceOf(Human) then
            if love.keyboard.isDown("lshift") then
                if entities[e] then
                    e:toggleSelected()
                end
            else
                if entities[e] then
                    e:setSelected()
                else
                    e:setUnselected()
                end
            end
        elseif e:isInstanceOf(Gate) and entities[e] then
            e:toggle()
        end
    end
end

-- Unselect all selected entities
function unselectAll()
    for e, _ in pairs(global.entities) do
        if e:isInstanceOf(Human) then
            e:setUnselected()
        end
    end
end

function love.mousepressed(x, y, button)
    dragging = {x=x, y=y}
end

function love.mousereleased(x, y, button)
    if not (dragging.x == x and dragging.y == y) then
        click(global.collidablesUnder(dragging.x, dragging.y, x, y))
    elseif button == "l" then
        click(global.collidablesAt(x, y))
    elseif button == "r" then
        for e, _ in pairs(global.entities) do
            if e:isInstanceOf(Human) and e.selected then
                e:setTarget(x, y)
            end
        end
    end
    dragging = nil
end
