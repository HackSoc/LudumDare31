local class = require "middleclass.middleclass"

local Zgrid = class("Zgrid")

local function mean(...)
    local ns = {...}
    local sum = 0
    for _, v in ipairs(ns) do
        sum = sum + v
    end
    return sum / #ns
end

function Zgrid:initialize(w, h, cellsize)
    self.width = w
    self.height = h
    self.cellsize = cellsize
    self.cand_idx = 1
    self:reset()
end

function Zgrid:reset()
    self.pre_weights = self:mk(math.huge)
    self.resistances = self:mk(1)
    self.post_weights = self:mk(0)
    self.heights = self:mk(0)
end

function Zgrid:compute()
    -- propagate preweights
    local propagated = self:propagate(self.pre_weights)
    self.propagated = propagated
    -- add postweights to get heights
    local heights = self:mk(0)
    self:mapGrid(
        function (i, j)
            self.heights[i][j] = propagated[i][j] + self.post_weights[i][j]
        end
    )
    -- self.heights = self:mk(0)
    -- -- smooth heights
    -- self:mapGrid(
    --     function (i, j)
    --         self.heights[i][j] =
    --             mean(
    --                 -- centre
    --                 heights[i][j],
    --                 -- left col
    --                 heights[i-1][j-1],
    --                 heights[i-1][j],
    --                 heights[i-1][j+1],
    --                 -- right col
    --                 heights[i+1][j-1],
    --                 heights[i+1][j],
    --                 heights[i+1][j+1],
    --                 -- gaps
    --                 heights[i][j-1],
    --                 heights[i][j+1]
    --             )
    --     end
    -- )
end

function Zgrid:propagate(weights)
    local propagated = self:mk(math.huge)
    self:mapGrid(
        function (i, j)
            propagated[i][j] = weights[i][j]
        end
    )
    local r = 0
    local changed = true
    while changed do
        changed = false
        self:mapGrid(
            function (i, j)
                local v = self:propagatePoint(propagated, i, j)
                if v ~= propagated[i][j] then
                    propagated[i][j] = v
                    changed = true
                end
            end
        )
    end
    return propagated
end

function Zgrid:propagatePoint(propagated, i, j)
    local r = self.resistances[i][j]
    return
        math.min(
            -- centre
            propagated[i][j],
            -- left col
            propagated[i-1][j-1] +1.4*r,
            propagated[i-1][j]   +1*r,
            propagated[i-1][j+1] +1.4*r,
            -- right col
            propagated[i+1][j-1] +1.4*r,
            propagated[i+1][j]   +1*r,
            propagated[i+1][j+1] +1.4*r,
            -- gaps
            propagated[i][j-1]   +1*r,
            propagated[i][j+1]   +1*r
        )
end

function Zgrid:drawGrid(grid)
    local min = math.huge
    local max = -math.huge
    self:mapGrid(
        function (i, j)
            local v = grid[i][j]
            if math.abs(v) == math.huge then
                return
            end
            min = math.min(v, min)
            max = math.max(v, max)
        end
    )
    local diff = max - min
    self:mapGrid(
        function (i, j)
            local alpha = grid[i][j]
            if math.abs(alpha) == math.huge then
                return
            end
            alpha = alpha - min
            alpha = 255 - (alpha / diff * 220)
            love.graphics.setColor(0, 255, 0, alpha)
            love.graphics.rectangle("fill",
                                    i*self.cellsize,
                                    j*self.cellsize,
                                    self.cellsize,
                                    self.cellsize)
        end
    )
end

function Zgrid:put(fn, x, y)
    local i, j = self:coord2Cell(x, y)
    if i < 0 or j < 0 or
    i > self.width or j > self.height or
    i ~= i or j ~= j then
        return
    end
    fn(i, j)
end

function Zgrid:putRegion(fn, x, y, w, h)
    for cx = x, x+w, self.cellsize do
        for cy = y, y+h, self.cellsize do
            self:put(fn, cx, cy)
        end
    end
end

function Zgrid:gradientAt(x, y)
    local i, j = self:coord2Cell(x, y)
    local function isnan(x)
        return x ~= x
    end
    if isnan(i) or isnan(j) or
    i < 1 or j < 1 or
    i > self.width-1 or j > self.height-1 then
        return 0, 0
    end
    local rx, ry = x % self.cellsize, y % self.cellsize
    local dx, dy = math.random(), math.random()
    if rx < 8 then
        dx = self.heights[i-1][j] - self.heights[i][j]
    elseif rx > 8 then
        dx = self.heights[i][j] - self.heights[i+1][j]
    end
    if ry < 8 then
        dy = self.heights[i][j-1] - self.heights[i][j]
    elseif ry > 8 then
        dy = self.heights[i][j] - self.heights[i][j+1]
    end
    
    -- nasty hack
    if dx == math.huge then
        dx = 10000
    elseif dx == -math.huge then
        dx = -10000
    end

    -- nasty hack
    if dy == math.huge then
        dy = 10000
    elseif dy == -math.huge then
        dy = -10000
    end

    return dx, dy
end

function Zgrid:coord2Cell(x, y)
    return math.floor(x/self.cellsize), math.floor(y/self.cellsize)
end

function Zgrid:cell2Coord(i, j)
    return i*self.cellsize+(self.cellsize/2), j*self.cellsize+(self.cellsize/2)
end

function Zgrid:mk(default)
    local g = {}
    for i = -1, self.width+1, 1 do
        g[i] = {}
        for j = -1, self.height+1, 1 do
            g[i][j] = default
        end
    end
    return g
end

function Zgrid:mapGrid(fn, pred)
    local answers = {}
    for i = 0, self.width, 1 do
        for j = 0, self.height, 1 do
            if not pred or pred(i, j) then
                fn(i, j)
            end
        end
    end
end

function Zgrid:mapNeighbours(pi, pj, fn, pred)
    for i = pi-1, pi+1, 1 do
        for j = pj-1, pj+1, 1 do
            if not pred or pred(i, j) then
                fn(i, j)
            end
        end
    end
end

return Zgrid
