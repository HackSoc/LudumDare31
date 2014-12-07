function map(tbl, func)
    for k, v in pairs(tbl) do
        func(v)
    end
end

function filter(tbl, pred)
    local out = {}
    local num = 0

    for k, v in pairs(tbl) do
        if pred(v) then
            out[k] = v
            num = num + 1
        end
    end

    return out, num
end

function only(tbl)
    for _, v in pairs(tbl) do
        return v
    end
end

function omap(tbl, field, ...)
    local varargs = {...}
    map(tbl, function(o) o[field](o, unpack(varargs)) end)
end

function ofilter(tbl, field)
    return filter(tbl, function(o) return o[field] end)
end
