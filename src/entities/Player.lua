local Collider = require 'src.entities.Collider'

local Player = Collider:new({
	w = 8, h = 12,
	vx = 0, vy = 0, 
	
	speed = 20,
	friction = 10,
	jumpStrength = 6,
	gravity = 20,
	
	onGround = false,
	hp = 3,
	invincible = 0,
	
	dir = 1,
	state = 'idle',
	
	cooldown = 0,
})

Player.sprite = {
	img = love.graphics.newImage('assets/images/entities/Player/player.png'),
	img2 = love.graphics.newImage('assets/images/entities/Player/player_no_scarf.png'),
	ox = 4, oy = 3,
}
local g = anim8.newGrid(16,16,Player.sprite.img:getDimensions())
Player.sprite.anim = {
	idle = anim8.newAnimation(g("1-6",1), {0.07, 2, 0.1, 0.1, 2, 0.1}, function() Player.sprite.anim[Player.state]:gotoFrame(2) end), 
  	run = anim8.newAnimation(g("1-4", 2), 0.07),
  	jump = anim8.newAnimation(g(7,1), 3), 
  	fall = anim8.newAnimation(g("5-8",2), 0.07, function() Player.sprite.anim[Player.state]:gotoFrame(3) end), 
}

function Player:update(dt)
	local state = 'idle'
	self.onGround = false
	self.invincible = math.max(0, self.invincible - dt)
	self.cooldown = math.max(0, self.cooldown - dt)
	self.x, self.y = self.x % love.graphics.getWidth(), self.y % love.graphics.getHeight()
	self.world:update(self, self.x, self.y)
	
	self.x, self.y, cols = self.world:move(self, self.x + self.vx, self.y + self.vy, self.filter)
	for _,col in ipairs(cols) do
		if col.other.isSolid and col.normal.y == -1 then
			self.vy = .0001
			self.onGround = true
		end
		if col.other.hurtPlayer and self.invincible == 0 then
			self.vx, self.vy = -self.vx, -self.vy
			self.hp = self.hp - 1
			self.invincible = 1
		end
	end
	
	
	self.vx = self.vx * (1 - math.min(self.friction * dt, 1))
	if not self.onGround then
		self.vy = math.min(10, self.vy + self.gravity * dt)
		state = 'fall'
		if self.vy < 0 then
			state = 'jump'
		end
	end
	
	if input:pressed('up','k') and self.onGround then
		self.vy = -self.jumpStrength
	end
	if input:down('left','a') then
		self.vx = self.vx - self.speed * dt
		self.dir = -1
		if self.onGround then state = 'run' end
	end
	if input:down('right','d') then
		self.vx = self.vx + self.speed * dt
		self.dir = 1
		if self.onGround then state = 'run' end
	end
	
	if input:pressed('down','j') and self.cooldown == 0 then
		entities:add('Bullet', {x = self.x, y = self.y, vx = 400})
		self.cooldown = 1
	end
	
	if self.hp <= 0 then 
		entities:load()
	end
	
	self.sprite.anim[self.state]:update(dt)
	if state ~= self.state then
		self.state = state
		self.sprite.anim[self.state]:gotoFrame(1)
	end
end

function Player:draw()
	local img = self.sprite.img
	if self.cooldown > 0 then img = self.sprite.img2 end
	self.sprite.anim[self.state]:draw(img, self.x - self.sprite.ox - ((self.dir - 1) * 8), self.y - self.sprite.oy, 0, self.dir, 1)
end


return Player