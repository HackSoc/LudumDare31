local class = require "middleclass.middleclass"
local global = require "global"

local Collidable = require "collidable"
local Mobile = class("Mobile", Collidable)

local bufsize = 32

function Mobile:initialize(x, y, maxhp)
    Collidable.initialize(self, x, y, maxhp)

    self.vx = 0
    self.vy = 0
    self.targetx = nil
    self.targety = nil
    self.maxspeed = 1 --Stupid small default speed

    self.layer = 10

    -- Record previous positions
    self.buffer = {}
    self.bufidx = 0
    self.rotation = 0
end

function Mobile:onCollision(other, dx, dy)
    if other:isInstanceOf(Collidable) then
        self.x = self.x + dx
        self.y = self.y + dy
    end
end

function Mobile:update(dt)
    if self.targetx and self.targety then
        local dx = self.targetx - self.x
        local dy = self.targety - self.y
        local mag = math.sqrt(dx^2 + dy^2)
        if mag ~= 0 then
            self.vx = dx / mag * self.maxspeed
            self.vy = dy / mag * self.maxspeed
            self.rotation = math.atan2(self.vx, -self.vy)
            -- don't move further than we need to
            if math.abs(self.vx * dt) > math.abs(dx) then
                self.vx = dx
            end
            if math.abs(self.vy * dt) > math.abs(dy) then
                self.vy = dy
            end
        else
            self:stop()
        end
    end

    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    self.buffer[self.bufidx] = {x=self.x, y=self.y}
    self.bufidx = (self.bufidx + 1) % bufsize
    local oldbufidx = (self.bufidx - bufsize) % bufsize
    if self.buffer[oldbufidx] then
        local dx = math.abs(self.buffer[oldbufidx].x - self.x)
        local dy = math.abs(self.buffer[oldbufidx].y - self.y)
        if dx < 2 and dy < 2 then
            self:stop()
        end
    end
    Collidable.update(self, dt)
end

function Mobile:getClosest(objType, dist, mustSee)
    local function compare(entity1, entity2)
        return self:getAbsDistance(entity1) < self:getAbsDistance(entity2)
    end
    assert(objType)
    local entities = {}
    for _, e in pairs(global.entities) do
        if e.class.name == objType and
           (dist == nil or self:getAbsDistance(e) < dist) then
            table.insert(entities, e)
        end
    end
    table.sort(entities, compare)
    for _, entity in ipairs(entities) do
        -- make nil truthy
        if mustSee == false or self:canSee(entity) then
            return entity
        end
    end
end

function riskyCanSee(self, target)
    local Static = require "static"
    local shapes = require "hardoncollider.shapes"

    local points = {self.x, self.y}
    if self.x < target.x then
        points[3] = self.x + 1
        points[4] = self.y
        if self.y < target.y then
            points[5] = target.x + 2
            points[6] = target.y + 1
            points[7] = target.x + 1
            points[8] = target.y + 1
        else
            points[5] = target.x + 1
            points[6] = target.y + 1
            points[7] = target.x
            points[8] = target.y + 1
        end
    else
        points[3] = self.x - 1
        points[4] = self.y
        if self.y < target.y then
            points[5] = target.x + 1
            points[6] = target.y + 1
            points[7] = target.x + 2
            points[8] = target.y + 1
        else
            points[5] = target.x
            points[6] = target.y + 1
            points[7] = target.x + 1
            points[8] = target.y + 1
        end
    end

    local check = shapes.newPolygonShape(unpack(points))

    local x1 = math.min(self.x, target.x)
    local y1 = math.min(self.y, target.y)
    local x2 = math.max(self.x, target.x)
    local y2 = math.max(self.y, target.y)

    for _, e in pairs(global.collider:shapesInRange(x1, y1, x2, y2)) do
        -- Only static things which stop bullets obstruct line of
        -- sight
        if e.entity ~= target and
           e.entity:isInstanceOf(Static) and
           e.entity.stopsBullets and
           not e.entity.is_open and
           e:collidesWith(check) then
            return false
        end
    end

    return true
end

-- Horrible work-around
function Mobile:canSee(target)
    out, res = pcall(function () return riskyCanSee(self, target) end)
    if out then
        return res
    else
        return false
    end
end

function Mobile:setTarget(x, y)
    self.targetx = x
    self.targety = y
    self.buffer = {}
end

function Mobile:setMaxSpeed(speed)
    self.maxspeed = speed
end

function Mobile:stop()
    self.vx = 0
    self.vy = 0
    self.targetx = nil
    self.targety = nil
end

return Mobile
