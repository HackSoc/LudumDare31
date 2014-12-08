local class = require "middleclass.middleclass"

local Grid = class("Grid")

function Grid:initialize(w, h, cellsize)
    self.width = w
    self.height = h
    self.cellsize = cellsize
    self.cells = self:mk(false)
    self.lasti = nil
    self.lastj = nil
    self.cand_idx = 1
end

function Grid:clear()
    self.cells = self:mk(false)
end

function Grid:draw()
    for i, row in pairs(self.cells) do
        for j, row in pairs(self.cells) do
            local alpha = 30
            if self.lastd and self.lastd[i][j] then
                alpha = self.lastd[i][j] * 3
            end
            if self.cells[i][j] then
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

function Grid:pathNext(from, to)
    local fi, fj = self:coord2Cell(unpack(from))
    local ti, tj = self:coord2Cell(unpack(to))

    -- if we are in the same cell, do not pathfind
    if fi == ti and fj == tj then
        return unpack(to)
    end

    -- initialise the distance matrix with infinity
    local d = self:mk(math.huge)

    -- desination is no distance from itself
    d[ti][tj] = 0

    -- propagate shortest distances
    local r = 0
    local rlimit = math.sqrt(self.width^2 + self.height^2)
    while d[fi][fj] == math.huge do
        self:mapGrid(
            function (i, j)
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
            end,
            function (i, j)
                return
                    (i == fi and j == fi) or
                    not self.cells[i][j]
            end
        )
        r = r + 1
        -- reached iteration limit (this allows for a path that covers
        -- every cell in the grid)
        if r >= rlimit then
            break
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
    self:mapNeighbours(
        fi, fj,
        function (i, j)
            if d[i][j] < md then
                md = d[i][j]
            end
        end
    )

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
    self:mapNeighbours(
        fi, fj,
        function (i, j)
            if math.abs(d[i][j] - md) < 1 then
                table.insert(candidates, {i, j})
            end
        end
    )
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

function Grid:mk(default)
    local g = {}
    for i = -1, self.width+1, 1 do
        g[i] = {}
        for j = -1, self.height+1, 1 do
            g[i][j] = default
        end
    end
    return g
end

function Grid:mapGrid(fn, pred)
    for i = 0, self.width, 1 do
        for j = 0, self.height, 1 do
            if not pred or pred(i, j) then
                fn(i, j)
            end
        end
    end
end

function Grid:mapNeighbours(pi, pj, fn, pred)
    for i = pi-1, pi+1, 1 do
        for j = pj-1, pj+1, 1 do
            if not pred or pred(i, j) then
                fn(i, j)
            end
        end
    end
end

return Grid
