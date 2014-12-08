local class = require "middleclass.middleclass"

local Mobile = require "mobile"
local Human = class("Human", Mobile)

local global = require "global"
local Gun = require "gun"
local Zombie = require "zombie"
local Trap = require "trap"
local Bullet = require "bullet"

local drawing = require "drawing"

local size = 10
local range = 100

local heal_rate = 10
local deploy_cooldown_start = 10

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

local talents = {"Velociraptor Whisperer"}
local talentcount = 1

local dreams = {"Get a summer house in Spain",
                "Buy a farm",
                "Start a business",
                "Get married",
                "See son through university",
                "Become a teacher",
                "Learn to dance"}
local dreamcount = 7

function Human:initialize(x, y, ammo, cooldown, reload)
    Mobile.initialize(self, x, y, 100)

    self.hitbox = global.addHitbox(self, x-1, y-1,
                                   image:getWidth()+2, image:getHeight()+2)
    self.selected = false
    self.targetx = nil
    self.targety = nil
    self.infected = false
    self.stopsBullets = false
    self:setMaxSpeed(50)

    self.mode = "normal"
    self.deployCooldown = deploy_cooldown_start

    self.gun = Gun:new(15, 10, ammo, cooldown, reload, 10)

    self:setName(forenames[love.math.random(1, forenamecount)],
                 surnames[love.math.random(1, surnamecount)])

    if love.math.random() <= 0.25 then
        self.talent = talents[love.math.random(1, talentcount)]
    end

    self.dream = dreams[love.math.random(1, dreamcount)]
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

function Human:update(dt)
    self.gun:update(dt)

    local zeds = {}
    local zcount = 0
    for _, e in pairs(global.zombies) do
        -- cycle breaking :(
        if self:getAbsDistance(e) < range and self:canSee(e) then
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
        self:heal(heal_rate * dt)
    elseif self.mode == "trap" then
        if self.deployCooldown <= 0 then
            self.deployCooldown = deploy_cooldown_start
            global.addDrawable(Trap(self.x, self.y))
        end
    end

    -- Heal passively (but slowly)
    if self.mode ~= "heal" then
        self:heal(dt)
    end

    closeZ = self:getClosest("Zombie", 20)
    if self.targetx == nil and closeZ then
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

    -- naive pathfinding
    if self.destx and self.desty then
        if not (self.targetx and self.targety) or
        self:getAbsDistance({x=self.targetx, y=self.targety}) <= 1 then
            local cx, cy = self.hitbox:center()
            local tx, ty = global.grid:pathNext({cx, cy},
                                                {self.destx, self.desty})
            tx = tx - cx + self.x
            ty = ty - cy + self.y
            self:setTarget(tx, ty)
        end
        if self:getAbsDistance({x=self.destx, y=self.desty}) <= 1 then
            self:stop()
        end
    end

    self.deployCooldown = self.deployCooldown - dt
    Mobile.update(self, dt)
end

function Human:onCollision(other, dx, dy)
    if not other:isInstanceOf(Bullet) then
        Mobile.onCollision(self, other, dx, dy)
    end
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

function Human:heal(amount)
    self.hp = self.hp + amount

    if self.hp >= self.maxhp then
        self.hp = self.maxhp
        self.infected = false
    end
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

function Human:setDest(x, y)
    self.destx = x
    self.desty = y
    self.targetx = nil
    self.targety = nil
    self.buffer = {}
end

function Human:stop()
    Mobile.stop(self)
    self.destx = nil
    self.desty = nil
end

return Human
