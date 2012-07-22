local anim8 = require 'vendor/anim8'
local Helper = require 'helper'
local window = require "window"
local heartImage = love.graphics.newImage('images/heart.png')
local menuImage = love.graphics.newImage('images/hilda_menu.png')
local h = anim8.newGrid(69, 43, menuImage:getWidth(), menuImage:getHeight())

local Menu = {}
Menu.__index = Menu

local menuDefinition = {
    { ['text']='talk', ['option']='foobar' },
    { ['text']='command' },
    { ['text']='inventory' },
    { ['text']='exit' },
}

function Menu.new(items)
   	local menu = {}
	setmetatable(menu, Menu)
    menu.items = items
    menu.active = false
    menu.itemWidth = 150
    menu.choice = 1
    menu.animation = anim8.newAnimation('once', h('1-6,1'), .08)
    return menu
end

function Menu:keypressed(key, player)
    if key == 'w' or key == 'up' then
        self.choice = math.max(1, self.choice - 1)
    elseif key == 's' or key == 'down' then
        self.choice = math.min(4, self.choice + 1)
    elseif key == 'return' then
        local item  = self.items[self.choice]
        if item.text == 'exit' then
            self:close()
            player.freeze = false
        else
            print(item.option)
        end
    end
end


function Menu:update(dt)
    if not self.active then
        return
    end
    self.animation:update(dt)
end

function Menu:draw(x, y)
    if not self.active then
        return
    end

    self.animation:draw(menuImage, x + 3, y + 4)

    local oldFont = love.graphics.getFont()
    love.graphics.setFont(window.font)
    love.graphics.setColor(0, 0, 0)

    for i, value in ipairs(self.items) do
        love.graphics.printf(value.text, x - self.itemWidth, y + (i - 1) * 12, 
                             self.itemWidth, 'right')

        if self.choice == i then
            love.graphics.setColor(255, 255, 255)
            love.graphics.draw(heartImage, x + 2, y + (i - 1) * 12 + 2)
            love.graphics.setColor(0, 0, 0)
        end
    end
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(oldFont)
end

function Menu:open()
    self.active = true
    self.choice = 1
end

function Menu:close()
    self.active = false
end


local Hilda = {}
Hilda.__index = Hilda

local hildaImage = love.graphics.newImage('images/hilda.png')
local g = anim8.newGrid(32, 48, hildaImage:getWidth(), hildaImage:getHeight())

function Hilda.new(node, collider)
	local hilda = {}
	setmetatable(hilda, Hilda)
	hilda.image = hildaImage
    hilda.animation = anim8.newAnimation('once', g(1,1), 1)

	hilda.bb = collider:addRectangle(node.x, node.y, node.width, node.height)
	hilda.bb.node = hilda
    hilda.collider = collider
	hilda.collider:setPassive(hilda.bb)

	hilda.position = { x = node.x, y = node.y }
    hilda.menu = Menu.new(menuDefinition)
	return hilda
end

function Hilda:draw()
	self.animation:draw(self.image, self.position.x, self.position.y)
    self.menu:draw(self.position.x, self.position.y - 50)
end

function Hilda:update(dt, player)
	--Helper.moveBoundingBox(self)
    self.menu:update(dt)
end

function Hilda:keypressed(key, player)
    if key == 'rshift' or key == 'lshift' then
        player.freeze = true
        player.state = 'idle'
        self.menu:open()
    end

    if player.freeze then
        self.menu:keypressed(key, player)
    end
end

return Hilda

