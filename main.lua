local global = require "global"
local Wall = require "wall"
local Zombie = require "zombie"
local Human = require "human"

local selected = nil

function love.load()
    global.addDrawable(Wall:new(220, 150, 350, 1))
    global.addDrawable(Wall:new(200, 150, 1, 100))
    global.addDrawable(Wall:new(200, 350, 1, 100))
    global.addDrawable(Wall:new(200, 450, 200, 1))
    global.addDrawable(Wall:new(450, 450, 150, 1))
    global.addDrawable(Wall:new(600, 150, 1, 300))
    global.addDrawable(Human:new(300, 300))
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

    if global.debug then
        love.graphics.setColor(255, 0, 0)
        global.drawHitboxes()
        love.graphics.setColor(255, 255, 255)
    end
end

function love.keypressed(key)
    if key == "d" then
        global.debug = not global.debug
    end
end

function love.keyreleased(key)
	if key == "escape" then
		if selected then
			selected:setUnselected()
		end
		selected = nil
	end
end

function love.mousepressed(x, y, button)
    -- handle mouse presses
end

function love.mousereleased(x, y, button)
	if button == "l" then
		for _, c in pairs(global.collidablesAt(x, y)) do
			if c:isInstanceOf(Human) then
				selected = c
				c:setSelected()
				return
			end
		end
		if selected then
			selected:moveTo(x, y)
		end
	end
end
