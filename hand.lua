hand = {}

function hand.loadAssets()
	hand.img = love.graphics.newImage("assets/hand.png")
	hand.width = hand.img:getWidth()
	hand.height = hand.img:getHeight()
end

function hand.init()
	hand.speed = 500
	hand.currentSpeed = 500
	hand.fallSpeed = 700

	hand.fingerOffset = 230
	hand.fingerSize = 60
	
	hand.state = "follow"
	hand.normalHeight = -900

	hand.x = 600
	hand.y = hand.normalHeight
	hand.initblood()
end

function hand.draw()
	love.graphics.draw(hand.img, hand.x, hand.y)
	love.graphics.draw(system2, 0, 0)
	love.graphics.draw(system, 0, 0)
end

function hand.initblood()
	hand.bloodimage = love.graphics.newImage("assets/blood.png")
	system = love.graphics.newParticleSystem( hand.bloodimage, 400 )
	system:setPosition( 536, 536 )
	system:setOffset( 0, 0 )
	system:setBufferSize( 2000 )
	system:setEmissionRate( 400 )
	system:setEmitterLifetime( 0.5 )
	system:setParticleLifetime( 2.05 )
	system:setColors( 255, 0, 0, 0, 255, 48, 0, 255 )
	system:setSizes( 3, 2, 1  )
	system:setSpeed( 205+200, 305+200  )
	system:setDirection( math.rad(90) )
	system:setSpread( math.rad(321) )
	system:setLinearAcceleration( 9, 13 )
	system:setRotation( math.rad(0), math.rad(0) )
	system:setSpin( math.rad(6.5), math.rad(1), 1 )
	system:setRadialAcceleration( 0 )
	system:setTangentialAcceleration( 0 )
	system:stop()

	hand.visceraimage = love.graphics.newImage("assets/viscera.png")
	system2 = love.graphics.newParticleSystem( hand.visceraimage, 10 )
	system2:setPosition( 536, 536 )
	system2:setOffset( 0, 0 )
	system2:setBufferSize( 25 )
	system2:setEmissionRate( 400 )
	system2:setEmitterLifetime( 0.5 )
	system2:setParticleLifetime( 2.05 )
	system2:setColors( 255, 0, 0, 0, 255, 48, 0, 255 )
	system2:setSizes( 5, 4, 1 )
	system2:setSpeed( 205+100, 305+100  )
	system2:setDirection( math.rad(90) )
	system2:setSpread( math.rad(321) )
	system2:setLinearAcceleration( 9, 13 )
	system2:setRotation( math.rad(1), math.rad(3) )
	system2:setSpin( math.rad(6.5), math.rad(1), 1 )
	system2:setRadialAcceleration( 0 )
	system2:setTangentialAcceleration( 0 )
	system2:stop()
end


function hand.moveRight(dt)
	hand.speed = hand.speed + (hand.runSpeed * dt)
	hand.speed = math.min(hand.speed, hand.runSpeed)
end

function hand.moveLeft(dt)
	hand.speed = hand.speed - (hand.runSpeed * dt)
	hand.speed = math.max(hand.speed, -hand.runSpeed)
end

function hand.update(dt)
	system:update(dt)
	system2:update(dt)
	local fingerPos = hand.x + hand.fingerOffset
	local roachPos = roach.x +  roach.width/2
	
	if hand.state == "follow" then
		if (math.abs(roachPos - fingerPos) < hand.fingerSize/4) then
			hand.speed = 0
			hand.state = "kill"
		else 
			if (fingerPos > roachPos) then
				hand.speed = -hand.currentSpeed
			else 
				hand.speed = hand.currentSpeed
			end
			hand.x = hand.x + (hand.speed * dt)
		end
	elseif hand.state == "kill" then
		hand.y = hand.y + (hand.fallSpeed * dt)
		if (hand.y + hand.height > roach.y and math.abs(roachPos - fingerPos) < hand.fingerSize/2) then
				roach.health = 0
				if (not (roach.state =="death")) then
					print("let the blood beggin")
					system:setPosition( hand.x + hand.fingerOffset, hand.y + hand.height )
					system:start()
					system2:setPosition( hand.x + hand.fingerOffset, hand.y + hand.height )
					system2:start()
				end
				roach.state = "death"
			end
		if (hand.y > groundHeight - hand.height) then
			hand.y = groundHeight - hand.height
			hand.state = "recover"
		end
	elseif hand.state == "recover" then
		hand.y = hand.y - (hand.fallSpeed * dt)
		if (hand.y < hand.normalHeight) then
			hand.y = hand.normalHeight
			hand.state = "follow"
		end
	end
end