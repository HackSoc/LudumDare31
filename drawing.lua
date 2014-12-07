local drawing = {}

function drawing.bar(x, y, width, height, fraction, fill_color, empty_color)
    local filled_width = fraction * width
    local empty_width = width - filled_width

    -- draw portion of health bar for remaining health
    love.graphics.setColor(unpack(fill_color))
    love.graphics.rectangle("fill", x, y,
                            filled_width, height)
    -- draw portion of health bar for health lost
    love.graphics.setColor(unpack(empty_color))
    love.graphics.rectangle("fill", x + filled_width, y,
                            empty_width, height)

end

return drawing
