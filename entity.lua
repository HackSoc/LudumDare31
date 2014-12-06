local Entity = {}
Entity.__index = Entity

function Entity.new(x, y)
    local self = {
        x = x,
        y = y
    }
    setmetatable(self, Entity)
    return self
end

function Entity:update(dt)

end

return Entity
