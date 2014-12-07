local class = require "middleclass.middleclass"

local Mobile = require "mobile"
local Zombie = class("Zombie", Mobile)

local global = require "global"

function Zombie:initialize(x, y)
    Mobile.initialize(self, x, y, 100)

    self.hitbox = global.addHitbox(self, x, y, 10, 10)
    self:setTarget(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    self:setMaxSpeed(10)
    self.damageCooldown = 0
    self.planningCooldown = 0
    self.targetHuman = nil
end

function Zombie:draw()
    local radius = 5
    love.graphics.setColor(107, 142, 35)
    love.graphics.circle("fill", self.x+radius, self.y+radius, radius)

    -- draw portion of health bar for remaining health
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle("fill", self.x, self.y-5, self.hp/10, 2)
    -- draw portion of health bar for health lost
    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle("fill", self.x+self.hp/10, self.y-5, 10-self.hp/10, 2)
end

function Zombie:update(dt)
    -- It's got stuck
    if not self.targetx or not self.targety then
        self:setTarget(self.x + love.math.random(-100, 100),
                       self.y + love.math.random(-100, 100))
    end

    if self.targetHuman == nil or self.planningCooldown <= 0 then
       	local function compare(entity1, entity2)
            return self:getAbsDistance(entity1) < self:getAbsDistance(entity2)
        end
        local entities = {}
        for _, e in pairs(global.entities) do
            table.insert(entities, e)
        end
        table.sort(entities, compare)
        for _, entity in ipairs(entities) do
            if entity.class.name == "Human" and
            self:hasLineOfSight(entity.hitbox) then
                self.targetHuman = entity
                self.planningCooldown = 1
                break
            end
        end
    else
        self:setTarget(self.targetHuman.x, self.targetHuman.y)
        self.planningCooldown = self.planningCooldown - dt
    end

    if self.damageCooldown > 0 then
        self.damageCooldown = self.damageCooldown - dt
    end

    Mobile.update(self, dt)
end

function Zombie:onCollision(other, dx, dy)
    Mobile.onCollision(self, other, dx, dy)
    if other.class.name == "Human" and (self.damageCooldown <= 0) then
        other:zomb()
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
