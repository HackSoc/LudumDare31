local class = require "middleclass.middleclass"

local Mobile = require "mobile"
local Human = class("Human", Mobile)

local global = require "global"
local Gun = require "gun"
local Zombie = require "zombie"

local size = 10
local range = 100

local heal_rate = 10

local image = love.graphics.newImage('human.png')
local image_selected = love.graphics.newImage('human_selected.png')

local forenames = {"Clarence",
                   "Galahad",
                   "Joseph",
                   "Edward",
                   "Sebastian",
                   "Colin",
                   "Rupert",
                   "Montague",
                   "Hugo",
                   "Gerald",
                   "Cyril",
                   "Ann",
                   "Constance",
                   "Millicent",
                   "Daphne",
                   "Joan",
                   "Aileen",
                   "Linda",
                   "Susan",
                   "Lavender",
                   "Alexandra",
                   "Eve"}
local forenamecount = 22

local surnames = {"Threepwood",
                  "Warblington",
                  "Keeble",
                  "Jackson",
                  "Cumberbatch",
                  "Runciman",
                  "Fish",
                  "Moresby",
                  "Garland",
                  "Wedge",
                  "Allsop"}
local surnamecount = 11

function Human:initialize(x, y, ammo, cooldown, reload)
    Mobile.initialize(self, x, y, 100)

    self.hitbox = global.addHitbox(self, x, y, size, size)
    self.selected = false
    self.targetx = nil
    self.targety = nil
    self.infected = false
    self:setMaxSpeed(50)

    self.mode = "normal"

    self.gun = Gun:new(15, 10, ammo, cooldown, reload, 10)

    self:setName(forenames[love.math.random(1, forenamecount)],
                 surnames[love.math.random(1, surnamecount)])
end

function Human:setName(forename, surname)
    self.forename = forename
    self.surname = surname
    self.name = forename .. " " .. surname
end

function Human:say(msg)
    self.lastsaid = msg
    global.log("(" .. self.name .. ") " .. msg)
end

function Human:draw()
    love.graphics.setColor(255, 255, 255)
    local im = image
    if self.selected then
        im = image_selected
    end
    -- love.graphics.rectangle(drawstyle, self.x, self.y, size, size)
    love.graphics.draw(im, self.x, self.y, self.rotation,
                       1, 1,
                       im:getWidth()/2, im:getHeight()/2)

    -- draw portion of health bar for remaining health
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle("fill",
                            self.x-im:getWidth()/2,
                            self.y-im:getHeight()/2,
                            self.hp/10, 2)
    -- draw portion of health bar for health lost
    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle("fill",
                            self.x-im:getWidth()/2 + self.hp/10,
                            self.y-im:getHeight()/2,
                            10 - self.hp/10, 2)
end

function Human:update(dt)
    self.gun:update(dt)

    local zeds = {}
    local zcount = 0
    for _, e in pairs(global.entities) do
        -- cycle breaking :(
        if e:isInstanceOf(Zombie) and self:getAbsDistance(e) < range then
            zcount = zcount + 1
            zeds[zcount] = e
        end
    end

    if self.mode == "normal" then
        if zcount > 0 then
            -- Pick a random zombie
            local zid = love.math.random(zcount)
            local zx, zy = zeds[zid].x, zeds[zid].y
            self.rotation = math.atan2(zx - self.x, self.y - zy)
            self.gun:fire(self.x + size / 2, self.y + size / 2, zeds[zid])
        end
    elseif self.mode == "heal" then
        self.hp = self.hp + heal_rate * dt
        if self.hp >= self.maxhp then
            self.hp = self.maxhp
            self.infected = false
        end
    end

    closeZ = self:getClosest("Zombie")
    if self.targetx == nil and closeZ and self:getAbsDistance(closeZ) < 20 then
        self:setTarget(self.x - (closeZ.x - self.x), self.y - (closeZ.y - self.y))
    end

    if self.infected then
        self:hurt(5 * dt)
    end

    if love.math.random() <= 0.05 * dt then
        local phrases1 = {"Ho hum",
                          "Red hair, sir, in my opinion, is dangerous.",
                          "Do trousers matter?",
                          "I am far from being gruntled.",
                          "What ho!",
                          "What ho?",
                          "What ho! What ho!",
                          "I always advise people never to give advice.",
                          "Unseen in the background, Fate was quietly slipping lead into the boxing-glove.",
                          "I am not always good and noble.",
                          "If he had a mind, there was something on it.",
                          "You would not enjoy Nietzsche, sir. He is fundamentally unsound."}
        local p1count = 12

        local phrases2 = {}
        local p2count = 0

        if self.gun.ammo <= 0 then
            table.insert(phrases2, "I'm out of ammo!")
            p2count = p2count + 1
        end

        if zcount == 0 then
            table.insert(phrases2, "Can't see anything...")
            p2count = p2count + 1
        elseif zcount <= 3 then
            table.insert(phrases2, "Got the blighter in my sights!")
            p2count = p2count + 1
        else
            table.insert(phrases2, "There are so many!")
            p2count = p2count + 1
        end

        if self.infected then
            table.insert(phrases2, "I'm feeling a little woozy...")
            p2count = p2count + 1
        end

        if self.hp < 10 then
            table.insert(phrases2, "It's all going dark!")
            p2count = p2count + 1
        elseif self.hp < 50 then
            table.insert(phrases2, "That hurt!")
            p2count = p2count + 1
        end

        local p2prob = 0.5
        if p2count > 2 then
            p2prob = 0.75
        end

        if love.math.random() <= p2prob then
            self:say(phrases2[love.math.random(1, p2count)])
        else
            self:say(phrases1[love.math.random(1, p1count)])
        end
    end

    Mobile.update(self, dt)
end

function Human:toggleSelected()
    self.selected = not self.selected
end

function Human:setSelected()
    self.selected = true
end

function Human:setUnselected()
    self.selected = false
end

function Human:zomb()
    self.infected = true
    self:say("It got me!")
end

function Human:setMode(mode)
    self.mode = mode
end

function Human:hurt(damage)
    self.hp = self.hp - damage

    if self.hp <= 0 then
        self:say("Argh!")

        if self.infected then
            self:say("*hiss*")
            global.addDrawable(Zombie:new(self.x, self.y))
        end

        self:destroy()
    end
end

return Human
