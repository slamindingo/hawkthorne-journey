local Board = require "board"
local window = require "window"
local Dialog = {}

Dialog.__index = Dialog
---
-- Create a new Dialog
-- @param message to display
-- @param callback when user answer's say
-- @return Dialog
function Dialog.new(width, height, message, callback)
    local say = {}
    setmetatable(say, Dialog)
    say.board = Board.new(width, height)
    say.board:open()
    say.message = message
    say.callback = callback
    say.called = false
    say.result = false
    return say
end

function Dialog:update(dt)
    self.board:update(dt)
    if self.board.done and self.callback and not self.called then
        self.called = true
        self.callback(self.result)
    end
end

function Dialog:draw(x, y)
    if self.board.hide then
        return
    end

    local oldFont = love.graphics.getFont()
    love.graphics.setFont(window.font)

    self.board:draw(x, y)

    if self.board.done then
        local ox = math.floor(x - self.board.width / 2 + 5)
        local oy = math.floor(y - self.board.height / 2 + 5)
        love.graphics.printf(self.message, ox, oy, self.board.width - 10)
    end

    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(oldFont)
end

function Dialog:keypressed(key)
    if self.board.hide then
        return
    end

    if key == 'return' then
        self.board:close()
        return
    end
end

return Dialog






