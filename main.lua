love.graphics.setDefaultFilter('nearest', 'nearest')

input = require 'src.input'
anim8 = require 'src.libs.anim8'
entities = require 'src.entities'

function love.load()
	love.graphics.setBackgroundColor(.3,.3,.3)
	entities:load()
end

function love.update(dt)
	entities:update(dt)
	input:update(dt) -- MUST BE LAST
end

function love.draw()
	entities:draw()
	love.graphics.print(love.timer.getFPS())
end

function love.keypressed(key)
	input:keypressed(key)
	if key == 'escape' then
		love.event.push('quit')
	end
end

function love.keyreleased(key)
	input:keyreleased(key)
end