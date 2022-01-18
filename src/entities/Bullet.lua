local Entity = require 'src.entities.Entity'

local Bullet = Entity:new({
	vx = 0, vy = 0,
	time = 0, lifetime = 1,
})

function Bullet:update(dt) 
	self.x, self.y = self.x + self.vx * dt, self.y + self.vy * dt
	self.time = self.time + dt
	
	if self.time >= self.lifetime then
		self.remove = true
	end
end

function Bullet:draw()
	love.graphics.circle('line', self.x, self.y, 5)
end

return Bullet