local input = {
	keyboard = {},
	mouse = {},
	gamepad = {},
	touch = {},
}

 --Functions
function input:down(...)
	for _,v in ipairs({...}) do
		if self.keyboard[v] then
			return self.keyboard[v].down
		end
	end
	return false
end

function input:pressed(...)
	for _,v in ipairs({...}) do
		if self.keyboard[v] then
			return self.keyboard[v].pressed
		end
	end
	return false
end

function input:released(...)
	for _,v in ipairs({...}) do
		if self.keyboard[v] then
			return self.keyboard[v].released
		end
	end
	return false
end

 --Callbacks
function input:update(dt)  --CALL LAST, NOT FIRST
	for k,v in pairs(self.keyboard) do
		if v.pressed then v.pressed = false end
		if not v.time then v.time = 0 end
		v.time = v.time + dt
		
		if v.released then self.keyboard[k] = nil end
	end
end

function input:keypressed(key)
	self.keyboard[key] = {pressed = true, down = true, released = false}
end

function input:keyreleased(key)
	self.keyboard[key].down = false
	self.keyboard[key].released = true
end


return input