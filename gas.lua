gas = {}

function gas.loadAssets()
	gas.width = 70
	gas.height = 70
	gas.img = love.graphics.newImage("assets/gas.gif")
	--gas.sprites = {}
	--gas.sprites[1] = love.graphics.newQuad(0, 0, gas.width, gas.height, gas.img:getDimensions())
	--gas.sprites[2] = love.graphics.newQuad(gas.width, 0, gas.width, gas.height, gas.img:getDimensions())
	--gas.sprites[3] = love.graphics.newQuad(gas.width*2, 0, gas.width, gas.height, gas.img:getDimensions())
end

function gas.init()
	gas.blobs = {}
	--gas.actualsprite = 1
	--gas.height = gas.img:getHeight()
	--gas.width = gas.img:getWidth()
end

function gas.throw(pos, duration)
	local newThrow = {}
	newThrow.pos = pos
	newThrow.duration = duration
	newThrow.rot = love.math.random(0,359) * (math.pi/180)
	newThrow.alpha = love.math.random(70,140)
	table.insert(gas.blobs, newThrow)
end

function gas.update(dt) 
	for i=#gas.blobs,1,-1 do
		gas.blobs[i].duration = gas.blobs[i].duration - dt
		if (gas.blobs[i].duration <= 0) then
			gas.blobs[i].alpha = gas.blobs[i].alpha - 16
			if (gas.blobs[i].alpha <= 0) then
		 		table.remove(gas.blobs, i)
		 	end
		end
	end

	--[[local temp_frame = (love.timer.getTime()*100)%480
			if temp_frame > 320 then
				gas.actualsprite = 2
			elseif temp_frame > 240 then
				gas.actualsprite = 1
			elseif temp_frame > 120 then
					gas.actualsprite = 3
			else -- temp_frame <= 120
					gas.actualsprite = 1
			end]]--
end

function gas.draw() 
	for i=#gas.blobs,1,-1 do
		local pos = gas.blobs[i].pos
		local rot = gas.blobs[i].rot
		love.graphics.setColor(255,255,255,gas.blobs[i].alpha)
		--love.graphics.draw(gas.img, gas.sprites[gas.actualsprite], pos, groundHeight - gas.height/2, rot, 1, 1)
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

				--print(distance(pt, center))
				if(distance(pt, center) < gas.width/2) then 
					return true;
				end
			end
		end
	end
	return false
end