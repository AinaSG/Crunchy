spray = {}

function spray.loadAssets()
	spray.img = love.graphics.newImage("assets/hand.png")
	spray.width = spray.img:getWidth()
	spray.height = spray.img:getHeight()
end

function spray.init()
	spray.speed = 10
	spray.currentSpeed = 10
	
	spray.timeForNextGas = 5
	spray.minTime = 3

	spray.normalHeight = scHeight - spray.height
	spray.x = 0
	spray.y = spray.normalHeight
end

function spray.update(dt)
	local roachPos = roach.x + roach.width/2
	local sprayPos = spray.x + spray.width/2
	
	spray.timeForNextGas = spray.timeForNextGas - dt
	if (spray.timeForNextGas <= 0) then
		gas.throw(spray.x+spray.width, 4)
		spray.timeForNextGas = love.math.random(0, 2*1000)/1000 + spray.minTime
	end


	if (sprayPos  > scWidth - spray.width/2 - scMargin) then
		spray.speed = -spray.currentSpeed
	elseif (sprayPos  < spray.width/2 + scMargin) then
		spray.speed = spray.currentSpeed
	end
	spray.x = spray.x + spray.speed
end