local Board = require "board"
local b = Board.new(175, 45)
love.graphics.setBackgroundColor(255, 255, 255)

function love.update(dt)
    b:update(dt)
end

function love.draw()
    b:draw(100, 100)
end

function love.keypressed(key)
    if b.opened then
        b:close()
    else
        b:open()
    end
end

