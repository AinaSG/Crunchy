spray = {}

function spray.loadAssets()
	spray.img = love.graphics.newImage("assets/vsprai.png")
	spray.width = spray.img:getWidth()
	spray.height = spray.img:getHeight()
end

function spray.init()
	spray.speed = 450
	spray.currentSpeed = 450
	spray.maxSpeed = 600

	spray.minGasTime = 1
	spray.maxGasTime = 2
	spray.minGasDelay = 3
	spray.maxGasDelay = 6
	spray.timeForNextGas = floatRand(spray.minGasDelay, spray.maxGasDelay)
	spray.gasLength = love.math.random(1,3)
	spray.currentLenght = 0
	spray.minTime = 3

	spray.normalHeight = scHeight - spray.height + 650
	spray.x = 0
	spray.y = spray.normalHeight
end

function spray.update(dt)
	if (spray.currentSpeed < spray.maxSpeed) then
		spray.currentSpeed = spray.currentSpeed + dt
	end

	local roachPos = roach.x + roach.width/2
	local sprayPos = spray.x + spray.width/2
	
	if (roach.y + roach.height > groundHeight - gas.height
		and math.abs((spray.x + spray.width/2) - (roach.x + roach.width/2)) < roach.width/4) then
			gas.throw(spray.x + spray.width/2, floatRand(spray.minGasTime, spray.maxGasTime))
	else 
		spray.timeForNextGas = spray.timeForNextGas - dt
		if (spray.timeForNextGas <= 0) then
			if (spray.currentLenght <= spray.gasLength) then
				gas.throw(spray.x + spray.width/2, floatRand(spray.minGasTime, spray.maxGasTime))
				spray.currentLenght = spray.currentLenght + 1
			else
				spray.gasLength = love.math.random(3,5) 
				spray.timeForNextGas = floatRand(spray.minGasDelay, spray.maxGasDelay)
			end
		else 
			spray.currentLenght = 0
		end
	end

	if (sprayPos  > scWidth - scMargin) then
		spray.speed = -spray.currentSpeed
	elseif (sprayPos  < scMargin) then
		spray.speed = spray.currentSpeed
	end
	spray.x = spray.x + (spray.speed * dt)
end