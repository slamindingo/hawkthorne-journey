local anim8 = require 'vendor/anim8'
local Helper = require 'helper'

local Hilda = {}
Hilda.__index = Hilda

local hildaImage = love.graphics.newImage('images/hilda.png')

function Hilda.new(node, collider)
	local hilda = {}
	setmetatable(hilda, Hilda)
	hilda.image = hildaImage
	hilda.bb = collider:addRectangle(node.x, node.y, node.width, node.height)
	hilda.bb.node = hilda
    hilda.collider = collider
	hilda.collider:setPassive(hilda.bb)

	hilda.position = { x = node.x, y = node.y }
	hilda.width = node.width
	hilda.height = node.height

	return hilda
end

function Hilda:draw()
	love.graphics.draw(self.image, self.position.x, self.position.y)
end

function Hilda:collide_end(player, dt)
	player:cancelHoldable(self)
end

function Hilda:update(dt, player)
	Helper.moveBoundingBox(self)
end

function Hilda:keypressed(key, player)
    self.menu.keypressed(key)
end

return Hilda

