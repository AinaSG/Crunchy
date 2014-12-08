gas = {}

function gas.loadAssets()
	gas.width = 70
	gas.height = 70
	gas.img = love.graphics.newImage("assets/gas.gif")
end

function gas.init()
	gas.blobs = {}
	gas.timeSinceLastSpray = 0
end

function gas.throw(pos, duration)
	if (gas.timeSinceLastSpray > 0.2) then
		TEsound.play("assets/spray.wav", "sfx")
		gas.timeSinceLastSpray = 0
	end
	local newThrow = {}
	newThrow.pos = pos
	newThrow.duration = duration
	newThrow.rot = love.math.random(0,359) * (math.pi/180)
	newThrow.alpha = love.math.random(70,140)
	table.insert(gas.blobs, newThrow)
end

function gas.update(dt) 
	gas.timeSinceLastSpray =  gas.timeSinceLastSpray + dt
	for i=#gas.blobs,1,-1 do
		gas.blobs[i].duration = gas.blobs[i].duration - dt
		if (gas.blobs[i].duration <= 0) then
			gas.blobs[i].alpha = gas.blobs[i].alpha - 16
			if (gas.blobs[i].alpha <= 0) then
		 		table.remove(gas.blobs, i)
		 	end
		end
	end
end

function gas.draw() 
	for i=#gas.blobs,1,-1 do
		local pos = gas.blobs[i].pos
		local rot = gas.blobs[i].rot
		love.graphics.setColor(255,255,255,gas.blobs[i].alpha)
		love.graphics.draw(gas.img, pos, groundHeight - gas.height/2, rot, 1, 1, gas.height/2, gas.height/2)
	end
	love.graphics.setColor(255,255,255,255)
end

function distance(a,b)
  return math.sqrt((a.x-b.x)^2 + (a.y-b.y)^2)
end

function gas.checkRoach() 
	if (roach.y + roach.height > groundHeight - gas.height) then
		for i=#gas.blobs,1,-1 do
			if (gas.blobs[i].alpha > 50) then
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

				if(distance(pt, center) < gas.width/2) then 
					return true;
				end
			end
		end
	end
	return false
end