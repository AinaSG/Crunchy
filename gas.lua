gas = {}

function gas.loadAssets()
	gas.img = love.graphics.newImage("assets/gas.png")
end

function gas.init()
	gas.blobs = {}
	gas.height = gas.img:getHeight()
	gas.width = gas.img:getWidth()
end

function gas.throw(pos, duration)
	local newThrow = {}
	newThrow.pos = pos
	newThrow.duration = duration
	newThrow.rot = love.math.random(0,359) * (math.pi/180)
	table.insert(gas.blobs, newThrow)
end

function gas.update(dt) 
	for i=#gas.blobs,1,-1 do
		gas.blobs[i].duration = gas.blobs[i].duration - dt
		if (gas.blobs[i].duration <= 0) then
		 	table.remove(gas.blobs, i)
		end
	end
end

function gas.draw() 
	for i=#gas.blobs,1,-1 do
		local pos = gas.blobs[i].pos
		local rot = gas.blobs[i].rot
		love.graphics.draw(gas.img, pos, groundHeight - gas.height/2, rot, 1, 1, gas.height/2, gas.height/2)
	end
end

function distance(a,b)
  return math.sqrt((a.x-b.x)^2 + (a.y-b.y)^2)
end

function gas.checkRoach() 
	if (roach.y + roach.height > groundHeight - gas.height) then
		for i=#gas.blobs,1,-1 do

			local pt = {}
			pt.x = gas.blobs[i].pos
			pt.y = groundHeight - gas.height/2
			local center = {}
			center.x = pt.x
			center.y = pt.y

			local right = roach.x + roach.width
			local left = roach.x
			local top = roach.y
			local bottom = roach.y + roach.height
			if(pt.x > right) then pt.x = right end
			if(pt.x < left) then pt.x = left; end
			if(pt.y > bottom) then pt.y = bottom; end
			if(pt.y < top) then pt.y = top; end

			print(distance(pt, center))
			if(distance(pt, center) < gas.width/2) then 
				return true;
			end

			--if (roach.x + roach.width > pos - gas.width/2 and roach.x < pos + gas.width/2) then return true end
		end
	end
	return false
end