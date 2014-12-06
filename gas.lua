gas = {}

function gas.loadAssets()
	gas.img = love.graphics.newImage("assets/gas.png")
end

function gas.init() {
	gas.blobs = {}
	gas.height = gas.img:getHeight()
	gas.width = gas.img:getWidth()
}

function gas.throw(pos, duration)
	local newThrow = {}
	newThrow.pos = pos
	newThrow.duration = duration
	table.insert(gas.blobs, newThrow)
end

function gas.update(dt) 
	for i=#gas.blobs,1,-1 do
		gas.blobs[i].duration = gas.blobs.duration[i] - dt
		if (gas.blobs[i].duration <= 0) then
		 	table.remove(gas.blobs, i)
		end
	end
end

function gas.draw() 
	for i=#gas.blobs,1,-1 do
		local pos = gas.blos[i].pos
		love.graphics.draw(gas.img, pos, groundHeight - gas.height)
	end
end

function gas.checkRoach() {
	if (roach.y + roach.height > groundHeight - gas.height) then
		for i=#gas.blobs,1,-1 do
			local pos = gas.blos[i].pos
			if (roach.x + roach.width > pos and roach.x < pos + gas.width) then return true end
		end
	end
	return false
}