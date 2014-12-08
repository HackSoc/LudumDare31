local class = require "middleclass.middleclass"

local Grid = class("Grid")

local function mkgrid(w, h, default)
    local g = {}
    for i = 0, w, 1 do
        g[i] = {}
        for j = 0, h, 1 do
            g[i][j] = default
        end
    end
    return g
end

function Grid:initialize(w, h, cellsize)
    self.width = w
    self.height = h
    self.cellsize = cellsize
    self.cells = mkgrid(w, h, false)
    self:clearOverlay()
    self.lasti = nil
    self.lastj = nil
    self.cand_idx = 1
end

function Grid:clearOverlay()
    self.overlay = mkgrid(self.width, self.height, false)
end

function Grid:draw()
    for i, row in pairs(self.cells) do
        for j, row in pairs(self.cells) do
            local alpha = 30
            if self.lastd and self.lastd[i][j] then
                alpha = self.lastd[i][j] * 3
            end
            if self.cells[i][j] or (self.overlay and self.overlay[i][j]) then
                love.graphics.setColor(255, 0, 0, 30)
            else
                love.graphics.setColor(0, 255, 0, alpha)
            end
            love.graphics.rectangle("fill",
                                    i*self.cellsize,
                                    j*self.cellsize,
                                    self.cellsize,
                                    self.cellsize)
        end
    end
end

function Grid:fill(x, y)
    local i, j = self:coord2Cell(x, y)
    self.cells[i][j] = true
end

function Grid:fillRegion(x, y, w, h)
    for i = x, x+w, 15 do
        for j = y, y+h, 15 do
            self:fill(i, j)
        end
    end
end

function Grid:overlayFill(x, y)
    local i, j = self:coord2Cell(x, y)
    if not self.overlay then
        self:clearOverlay()
    end
    if i < 0 or i > self.width or j < 0 or j >= self.height then
        return
    end
    self.overlay[i][j] = true
end

function Grid:overlayFillRegion(x, y, w, h)
    for i = x, x+w, 15 do
        for j = y, y+h, 15 do
            self:overlayFill(i, j)
        end
    end
end

function Grid:pathNext(from, to)
    local fi, fj = self:coord2Cell(unpack(from))
    local ti, tj = self:coord2Cell(unpack(to))

    -- if we are in the same cell, do not pathfind
    if fi == ti and fj == tj then
        return unpack(to)
    end

    -- initialise the distance matrix with infinity
    local d = mkgrid(self.width, self.height, math.huge)

    -- calculate bounds for fill
    -- currently just using the whole screen
    local li = 1
    local ui = self.width-1
    local lj = 1
    local uj = self.height-1

    -- desination is no distance from itself
    d[ti][tj] = 0

    -- keep a local reference to the overlay, so we can clear it for fallback
    local overlay = self.overlay

    -- propagate shortest distances
    local r = 0
    while d[fi][fj] == math.huge do
        for i = li, ui, 1 do
            for j = lj, uj, 1 do
                if ((i == fi and j == fj) or
                    ((not overlay or not overlay[i][j]) and
                     not self.cells[i][j]))
                then
                    -- propagate distances from neighbours
                    -- 1.4 ~~ sqrt(2) for diagonals
                    d[i][j] = math.min(
                        -- cannot be further than itself
                        d[i][j],
                        -- left col
                        d[i-1][j-1]+1.4,
                        d[i-1][j]+1,
                        d[i-1][j+1]+1.4,
                        -- right col
                        d[i+1][j-1]+1.4,
                        d[i+1][j]+1,
                        d[i+1][j+1]+1.4,
                        -- others
                        d[i][j-1]+1,
                        d[i][j+1]+1
                    )
                end
            end
        end
        r = r + 1
        -- reached iteration limit (this allows for a path that covers
        -- every cell in the grid)
        if r >= self.width*self.height then
            -- fall back to the static grid, just in case
            if overlay then
                print("falling back to static pathfinding")
                overlay = nil
            else
                break
            end
        end
    end

    -- save distance matrix for display
    self.lastd = d

    -- check for unreachable destination
    if d[fi][fj] == math.huge then
        print("destination unreachable")
        return unpack(to)
    end

    -- choosing the next cell to go to is a little nuanced:
    -- we want to avoid being completely deterministic, as
    -- this causes all the humans to collide en route

    -- to mitigate this, we find all nearly-equally-good next cells,
    -- and deal them out

    -- find cheapest next cell
    local md = math.huge
    d[fi][fj] = math.huge

    -- first pass: find minimum (cell) distance to target
    for i = fi-1, fi+1, 1 do
        for j = fj-1, fj+1, 1 do
            if d[i][j] < md then
                md = d[i][j]
            end
        end
    end

    -- second pass: find candidate cells

    -- anything within 1 cell-distance of optimal
    -- is a potential candidate

    -- using a diagonal to take a parallel path adds 0.8
    -- (because of our approximation to sqrt(2), but would be
    -- valid even if 'exact')

    -- negative progress must add >1

    -- this therefore guarantees possibly-suboptimal progress

    --   /---- x + 0.8 ----\
    -- -------    x    -------
    --   \---- x + 0.8 ----/
    local candidates = {}
    for i = fi-1, fi+1, 1 do
        for j = fj-1, fj+1, 1 do
            if math.abs(d[i][j] - md) < 1 then
                table.insert(candidates, {i, j})
            end
        end
    end

    -- we do not have to check that candidates is non-empty;
    -- were that the case, we would have bailed out in
    -- the unreachability check above


    -- if we're aiming for the same destination,
    -- deal candidates out to takers in sequence

    -- this is clearly bizarre in the general case,
    -- but with the usage pattern we have,
    -- it will tend to reduce contention for the same cell
    if ti == self.lasti and tj == self.lastj then
        self.cand_idx = (self.cand_idx + 1) % #candidates
        if self.cand_idx == 0 then
            self.cand_idx = 1
        end
    else
        self.cand_idx = 1
    end

    local mi, mj = unpack(candidates[self.cand_idx])

    -- if next path cell is the target, just return target coords
    if mi == ti and mj == tj then
        return unpack(to)
    end

    return self:cell2Coord(mi, mj)
end

function Grid:coord2Cell(x, y)
    return math.floor(x/self.cellsize), math.floor(y/self.cellsize)
end

function Grid:cell2Coord(i, j)
    return i*self.cellsize+(self.cellsize/2), j*self.cellsize+(self.cellsize/2)
end

return Grid
