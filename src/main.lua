local Prompt = require "prompt"
local b = nil

function love.update(dt)
    if b then
        b:update(dt)
    end
end


function love.load()
    love.graphics.setBackgroundColor(255, 255, 255)
    love.graphics.setDefaultImageFilter('nearest', 'nearest')

    local font = love.graphics.newImage("imagefont.png")
    font:setFilter('nearest', 'nearest')

    love.graphics.setFont(love.graphics.newImageFont(font,
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/:;%&`'*#=\""), 35)
end



function love.draw()
    if b then
        b:draw(100, 100)
    end
end

function love.keypressed(key)
    if key == ' ' then
        b = Prompt.new(120, 55, 'Straigthen masterpiece?', function(result)
            if result then
                print('YES')
            else
                print('NO')
            end
        end)
        return
    end

    if b then
        b:keypressed(key)
    end
end

