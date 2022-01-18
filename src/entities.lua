local bump = require 'src.libs.bump'

local entities = {
	classes = {},
	world = nil,
	list = {},
}

for i,v in ipairs(love.filesystem.getDirectoryItems('src/entities')) do
	entities.classes[v:sub(1,-5)] = require('src.entities.'..v:sub(1,-5))
end


function entities:load()
	self.world = bump.newWorld()
	self.list = {}
	
	for i = 1,50 do
		self:add('Collider', {x = i*16, y = 400, w = 16, h = 16, isSolid = true})
	end
	self:add('Player', {x = 200, y = 300})
end

function entities:add(class,t)
	t = t or {}
	t.world = self.world
	local e = entities.classes[class]:new(t)
	e:init()
	table.insert(entities.list, e)
end

function entities:update(dt)
	for i,v in ipairs(entities.list) do
		v:update(dt)
		if v.remove then
			table.remove(entities.list, i)
		end
	end
end

function entities:draw()
	for i,v in ipairs(entities.list) do
		v:draw()
	end
end

return entities