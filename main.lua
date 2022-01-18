function love.load()
	
end

function love.update(dt)
	
end

function love.draw()
	love.graphics.print('hello world')	
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.push('quit')
	end
end