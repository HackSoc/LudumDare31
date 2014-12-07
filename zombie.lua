local class = require "middleclass.middleclass"

local Mobile = require "mobile"
local Zombie = class("Zombie", Mobile)

local global = require "global"

local drawing = require "drawing"

local image = love.graphics.newImage('zombie.png')

function Zombie:initialize(x, y)
    Mobile.initialize(self, x, y, 100)

    self.hitbox = global.addHitbox(self, x, y, image:getWidth(), image:getHeight())
    self:setTarget(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    self:setMaxSpeed(10)
    self.damageCooldown = 0
    self.planningCooldown = 0
    self.target = nil
    self.followDist = 250
    self.noticeDist = 150
    self.waitForPlan = false
end

function Zombie:draw()
    local radius = 5
    local im = image
    love.graphics.setColor(255, 255, 255)

    love.graphics.draw(im,
                       self.x+im:getWidth()/2, self.y+im:getWidth()/2,
                       self.rotation,
                       1, 1,
                       im:getWidth()/2, im:getHeight()/2)
    drawing.bar(self.x, self.y - 5,
                im:getWidth(), 2,
                self.hp / self.maxhp,
                {0, 255, 0},
                {255, 0, 0})
end

function Zombie:update(dt)
    -- It's got stuck
    if not self.waitForPlan and (not self.targetx or not self.targety) then
        self:setTarget(self.x + love.math.random(-100, 100),
                       self.y + love.math.random(-100, 100))
    end

    if self.target == nil or
       self.planningCooldown <= 0 or
       self:getAbsDistance(self.target) > self.followDist then
        self.target = self:getClosest("Human", self.noticeDist)

        -- If no humans, head to breakables further afield
        for _, objType in ipairs({"Window", "Gate"}) do
            if self.target == nil then
                self.target = self:getClosest(objType, self.followDist)
            end
        end

        self.planningCooldown = 1
        self.waitForPlan = false

    elseif not self.waitForPlan then
        local targetx = self.target.x
        if self.target.w ~= nil then
            targetx = targetx + love.math.random(self.target.w)
            self.waitForPlan = true
        end

        local targety = self.target.y
        if self.target.h ~= nil then
            targety = targety + love.math.random(self.target.h)
            self.waitForPlan = true
        end

        self:setTarget(targetx, targety)
    end

    self.planningCooldown = self.planningCooldown - dt

    if self.damageCooldown > 0 then
        self.damageCooldown = self.damageCooldown - dt
    end

    Mobile.update(self, dt)
end

function Zombie:onCollision(other, dx, dy)
    Mobile.onCollision(self, other, dx, dy)
    if (other.class.name == "Human" or other.class.name == "Gate")
       and (self.damageCooldown <= 0) then
        if other.class.name == "Human" then
            other:zomb()
        end
        other:hurt(10)
        self.damageCooldown = 1
    end
end

function Zombie.spawn()
    local x = 0
    local y = 0
    local rand = love.math.random(4)
    if rand == 1 then
        x = 0
        y = love.math.random(love.graphics.getHeight())
    elseif rand == 2 then
        x = love.math.random(love.graphics.getWidth())
        y = 0
    elseif rand == 3 then
        x = love.graphics.getWidth()
        y = love.math.random(love.graphics.getHeight())
    else
        x = love.math.random(love.graphics.getWidth())
        y = love.graphics.getHeight()
    end
    global.addDrawable(Zombie:new(x, y))
end

return Zombie
