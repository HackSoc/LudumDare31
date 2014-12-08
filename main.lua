local global = require "global"
local Zombie = require "zombie"
local Human = require "human"
local Bullet = require "bullet"
local Gate = require "gate"
local LevelLoader = require "levelloader"
local HumanInfo = require "humaninfo"
local Trap = require "trap"
local Button = require "button"
local ModeButton = require "modebutton"
local Collidable = require "collidable"
local Tank = require "tank"
local Static = require "static"

local zSpawnRate = 0.25

local totalTime = 0

function love.load()
    love.window.setMode(1280, 720)
    love.window.setTitle("Zombie Simulator 2014")
    love.graphics.setBackgroundColor(255, 248, 220)

    reset()
end

function reset()
    global.reset()

    global.addDrawable(HumanInfo())

    LevelLoader("level")

    -- Define mode buttons
    global.addDrawable(ModeButton(864, 582,
                                  love.graphics.newImage("button_normal.png"),
                                  "normal"))
    global.addDrawable(ModeButton(1002, 582,
                                  love.graphics.newImage("button_heal.png"),
                                  "heal"))
    global.addDrawable(ModeButton(1140, 582,
                                  love.graphics.newImage("button_trap.png"),
                                  "trap"))
end

function love.update(dt)
    if global.showHelp then
        return
    end
    totalTime = totalTime + dt

    -- update pathfinding
    global.grid:clear()
    for e, _ in pairs(global.entities) do
        if e:isInstanceOf(Static) and e.stopsHumans then
            -- hope that all things with area also have these properties...
            if e.w and e.h then
                global.grid:fillRegion(e.x, e.y, e.w, e.h)
            else
                global.grid:fill(e:center())
            end
        end
    end

    for o, _ in pairs(global.entities) do
        o:update(dt)
    end
    global.collider:update(dt)

    if love.math.random() <= zSpawnRate * math.abs(math.cos(math.rad(totalTime))) * dt then
        zSpawnRate = math.min(zSpawnRate * 1.01, 7)
        Zombie.spawn()
    end

    local humancount = 0
    for _, _ in pairs(global.humans) do
        humancount = humancount + 1
    end
    if humancount == 0 then
        global.endGame = true
        global.showHelp = false
    end
end

function drawHelp(x, y, w, h)
    love.graphics.setColor(105, 105, 105, 220)
    love.graphics.rectangle("fill", x, y, w - 2*x, h - 2*y)

    local text = [[Welcome to Zombie Simulator 2014




Use the mouse to direct your human survivors.
Left-click (and drag) to select, right-click to direct.


When a survivor is in a relevant 'hotzone', they can:]]

    local tasks = [[ - radio the military for help
 - call for reinforcements at the helipad
 - repair outer doors
 - increase turret accuracy
 - recover in a rest area]]

    love.graphics.setColor(255, 255, 255)
    love.graphics.printf(text, x, y + 10, w - 2*x, "center")
    love.graphics.printf(tasks, x + 490, y + 165, w)

    love.graphics.printf("Good luck!", x, y + 300, w - 2*x, "center")
    love.graphics.printf("(Press Esc or ? to begin)", x, y + 315, w - 2*x, "center")
end

function drawEndgame(x, y, w, h)
    love.graphics.setColor(178, 34, 34, 220)
    love.graphics.rectangle("fill", x, y, w - 2*x, h - 2*y)

    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("Oh no, everyone died", x, y + 10, w - 2*x, "center")
    love.graphics.printf("Here is some text which mocks/praises you based on how many zombies you managed to kill:",
                         x, y + 30, w - 2*x, "center")

    -- :(
    local texts = {
        [100]   = "what? you suck",
        [500]   = "meh",
        [1000]  = "not bad",
        [5000]  = "nice work",
        [10000] = "excellent!"
    }
    local textkeys = {}
    for k, _ in pairs(texts) do
        textkeys[#textkeys+1] = k
    end
    table.sort(textkeys)
    local text = "i think you broke the game"
    for _, count in ipairs(textkeys) do
        if global.killedZombies <= count then
            text = texts[count]
            break
        end
    end

    love.graphics.setNewFont(50)
    love.graphics.printf(text, x, y + 245, w - 2*x, "center")

    love.graphics.setNewFont(24)
    love.graphics.printf("Press [r] to restart", x, h - 2*y, w - 2*x, "center")

    love.graphics.setNewFont(12)
end

function love.draw()
    local winW = love.graphics.getWidth()
    local winH = love.graphics.getHeight()
    local mouseX = love.mouse.getX()
    local mouseY = love.mouse.getY()

    global.correctDrawables()
    for _, d in pairs(global.drawables) do
        d:draw()
    end

    if dragging then
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", dragging.x, dragging.y,
                                mouseX - dragging.x, mouseY - dragging.y)
    end

    love.graphics.setNewFont(20)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(string.format("Zombie kills: %05d", global.killedZombies),
                         0, 5, winW, "center")
    love.graphics.setNewFont(12)

    local msgstr = ""
    for i = 1, global.messagenum do
        msgstr = msgstr .. global.messages[i] .. "\n"
    end
    love.graphics.printf(msgstr, 5, winH - global.maxmessages * 18, 450)


    if global.debug then
        love.graphics.setColor(255, 0, 0)
        global.drawHitboxes()
        global.grid:draw()
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(string.format("x: %d, y: %d", mouseX, mouseY), 0, 0, 130)
        love.graphics.printf(string.format("i: %d, j: %d",
                                           math.floor(mouseX / 15), math.floor(mouseY / 15)),
                             130, 0 ,130)
    end

    if global.showHelp then
        drawHelp(40, 40, winW, winH)
    elseif global.endGame then
        drawEndgame(40, 40, winW, winH)
    end
end

function love.keypressed(key)
    if global.endGame then
        if key == "r" then
            reset()
        else
            return
        end
    end

    if key == "d" then
        global.debug = not global.debug
    elseif key == 'escape' and global.showHelp then
        global.showHelp = false
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
    elseif (key == '/' or key == '?') and not global.endGame then
        global.showHelp = not global.showHelp
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
        elseif key == 'm' then
            global.addDrawable(Tank(love.mouse.getX(), love.mouse.getY()))
        end
    end
end

function love.keyreleased(key)

end

-- When holding shift, toggle the selection state of entities in the
-- set (but don't unselect things we have already selected), if not
-- holding shift, same as before: one-unit selections.
function click(entities, isdragging)
    for e, _ in pairs(entities) do
        if e:isInstanceOf(Button) and e.depressed then
            e:onClick()
            e.depressed = false
            return
        end
    end

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

        for _, o in pairs(global.collidablesAt(x, y)) do
            if o:isInstanceOf(Button) then
                o.depressed = true
            end
        end
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
                e:setDest(x, y)
            end
        end
    end
    dragging = nil
end
