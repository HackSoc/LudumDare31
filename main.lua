local global = require "global"
local Zombie = require "zombie"
local Human = require "human"
local Bullet = require "bullet"
local Gate = require "gate"
local LevelLoader = require "levelloader"

local zSpawnRate = 0.25

function love.load()
    love.window.setMode(1280, 720)
    love.graphics.setBackgroundColor(255, 248, 220)

    LevelLoader("level")
end

function love.update(dt)
    for o, _ in pairs(global.entities) do
        o:update(dt)
    end
    global.collider:update(dt)

    if love.math.random() <=  zSpawnRate * dt then
        zSpawnRate = math.min(zSpawnRate * 1.01, 7)
        Zombie.spawn()
    end
end

function love.draw()
    for i = 1, global.maxdrawlayer do
        for o, _ in pairs(global.drawables) do
            if o.layer == i then
                o:draw()
            end
        end
    end

    if dragging then
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", dragging.x, dragging.y,
                                love.mouse.getX() - dragging.x,
                                love.mouse.getY() - dragging.y)
    end

    love.graphics.setColor(0, 0, 0)
    local msgstr = ""
    for i = 1, global.messagenum do
        msgstr = msgstr .. global.messages[i] .. "\n"
    end
    love.graphics.printf(msgstr, 5, 20, 400)

    local selected = nil
    local selcount = 0
    for _, e in pairs(global.humans) do
        if e.selected then
            selected = e
            selcount = selcount + 1
        end
    end

    if selcount == 1 then
        local w = 200
        local wL = 275
        local x = love.graphics.getWidth() - w - 5
        local xL = love.graphics.getWidth() - wL - 5
        love.graphics.printf(selected.name .. " (" .. math.floor(selected.hp) .. ")", x, 5, w, "center")
        local y = 20
        if selected.talent ~= nil then
            love.graphics.setColor(100, 100, 100)
            love.graphics.printf("[" .. selected.talent .. "]", x, y, w, "center")
            y = y + 15
        end

        y = y + 15
        love.graphics.setColor(70, 130, 180)
        love.graphics.printf(selected.dream, xL, y, wL, "right")
        y = y + 30

        if selected.lastsaid ~= nil then
            love.graphics.setColor(165, 42, 42)
            love.graphics.printf(selected.lastsaid, xL, y, wL, "right")
        end
    end

    if global.debug then
        love.graphics.setColor(255, 0, 0)
        global.drawHitboxes()
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(string.format("x: %d, y: %d", love.mouse.getX(), love.mouse.getY()), 0, 0 ,130)
    end
end

function love.keypressed(key)
    if key == "d" then
        global.debug = not global.debug
    elseif key == 'escape' then
        unselectAll()
    elseif key == 'a' then
        for e, _ in pairs(global.humans) do
            e:setSelected()
        end
    elseif key == 'kp0' then
        for e, _ in pairs(global.humans) do
            if e.selected then
                e:setMode("normal")
            end
        end
    elseif key == 'kp1' then
        for e, _ in pairs(global.humans) do
            if e.selected then
                e:setMode("heal")
            end
        end
    elseif key == 'kp2' then
        for e, _ in pairs(global.humans) do
            if e.selected then
                e:setMode("trap")
            end
        end
    end

    if global.debug then
        if key == "z" then
            zSpawnRate = 5
        elseif key == "h" then
            local x, y = love.mouse.getPosition()
            global.addDrawable(Human:new(x, y, 10, 0.1, 1))
        elseif key == "q" then
            global.addDrawable(Zombie:new(love.mouse.getPosition()))
        elseif key == 'c' then
            for e, _ in pairs(global.humans) do
                e:destroy()
            end

            for e, _ in pairs(global.zombies) do
                e:destroy()
            end
        elseif key == 'b' then
            local b = Bullet(love.mouse.getX(), love.mouse.getY(),
                             love.math.random(-250,250),
                             love.math.random(-250,250), 50)
            global.addDrawable(b)
        elseif key == 't' then
            global.addDrawable(Trap(love.mouse.getX(), love.mouse.getY()))
        end
    end
end

function love.keyreleased(key)

end

-- When holding shift, toggle the selection state of entities in the
-- set (but don't unselect things we have already selected), if not
-- holding shift, same as before: one-unit selections.
function click(entities, isdragging)
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
        elseif e:isInstanceOf(Gate) and not isdragging and entities[e] then
            e:toggle()
        end
    end
end

-- Unselect all selected entities
function unselectAll()
    for e, _ in pairs(global.humans) do
        e:setUnselected()
    end
end

function love.mousepressed(x, y, button)
    if button == "l" then
        dragging = {x=x, y=y}
    end
end

function love.mousereleased(x, y, button)
    if button == "l" then
        if not (dragging.x == x and dragging.y == y) then
            if dragging.x == x then
                x = x + 1
            elseif dragging.y == y then
                y = y + 1
            end

            click(global.collidablesUnder(dragging.x, dragging.y, x, y), true)
        else
            click(global.collidablesAt(x, y), false)
        end
    elseif button == "r" then
        for e, _ in pairs(global.humans) do
            if e.selected then
                e:setTarget(x, y)
            end
        end
    end
    dragging = nil
end
