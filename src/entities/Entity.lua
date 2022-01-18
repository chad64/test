local Entity = {
	x = 0, y = 0,
} 

function Entity:new(t) 
	new = t or {} 
	setmetatable(new, self) 
	self.__index = self 
	return new
end 

function Entity:init() end
function Entity:update(dt) end
function Entity:draw() end

return Entity