local Entity = require 'src.entities.Entity'

local Collider = Entity:new({
	w = 0, h = 0, 
	world = nil, 
	filter = function(item, other)
		if other.isSolid and not item.isGhost then
			return 'slide'
		else
			return 'cross'
		end
	end
})

function Collider:init()
	self.world:add(self, self.x, self.y, self.w, self.h)
end

function Collider:draw()
	love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
end

return Collider