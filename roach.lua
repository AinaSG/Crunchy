roach = {}
roach.width = 84
roach.offset = 41
roach.height = 108

function roach.loadAssets(snowman)
	if snowman then
		roach.img = love.graphics.newImage("assets/snowmant.png")
	else
		roach.img = love.graphics.newImage("assets/blushed3.png")
	end
	roach.isSnowMan = snowman or false
	roach.sprites = {}
	roach.sprites[1] = love.graphics.newQuad(0, 0, roach.width, roach.height, roach.img:getDimensions())
	roach.sprites[2] = love.graphics.newQuad(roach.width, 0, roach.width, roach.height, roach.img:getDimensions())
	roach.sprites[3] = love.graphics.newQuad(roach.width*2, 0, roach.width, roach.height, roach.img:getDimensions())
	roach.sprites[4] = love.graphics.newQuad(roach.width*3, 0, roach.width, roach.height, roach.img:getDimensions())
end

function roach.init()
	roach.x = 0
	roach.y = groundHeight - roach.height
	roach.xSpeed = 0
	roach.ySpeed = 0
	roach.runSpeed = 5000
	roach.jumpSpeed = -800
	roach.friction = 10
	roach.canJump = false
	roach.state = "alive"
	roach.soundIsPlaying = false;
	roach.health = 100
	roach.actualsprite = 1
	roach.direction = 1
end


function roach.die(fromHand)
	if fromHand then
		system:setPosition( hand.x + hand.fingerOffset, hand.y + hand.height )
		system:start()
		system2:setPosition( hand.x + hand.fingerOffset, hand.y + hand.height )
		system2:start()
		if roach.state ~= "dead" then TEsound.play("assets/splat.wav", "sfx") end
	end
	if roach.soundIsPlaying then roach.pauseSound() end
	roach.state = "dead"
	roach.actualsprite = 4
end

function roach.jump()
	if roach.canJump then
		roach.ySpeed = roach.jumpSpeed
		roach.canJump = false
	end
end

function roach.moveRight(dt)
	roach.xSpeed = roach.xSpeed + (roach.runSpeed * dt)
	roach.xSpeed = math.min(roach.xSpeed, roach.runSpeed)
	roach.state = "moveRight"
	roach.direction = -1
end

function roach.moveLeft(dt)
	roach.xSpeed = roach.xSpeed - (roach.runSpeed * dt)
	roach.xSpeed = math.max(roach.xSpeed, -roach.runSpeed)
	roach.state = "moveLeft"
	roach.direction = 1
end

function roach.stop()
	roach.xSpeed = 0
end

function roach.hitFloor(maxY)
	roach.y = maxY - roach.height
	roach.ySpeed = 0
	roach.canJump = true
end

function roach.pauseSound()
	TEsound.pause("roachsound")
	roach.soundIsPlaying = false
end

function roach.draw()
	if (roach.direction == 1 ) then 
		love.graphics.draw(roach.img, roach.sprites[roach.actualsprite], roach.x, roach.y, 0, 1, 1)
	else
		love.graphics.draw(roach.img, roach.sprites[roach.actualsprite], roach.x, roach.y, 0, -1, 1, roach.width)
	end

end

function roach.update(dt)

	if (gas.checkRoach()) then
		roach.health = roach.health - dt*100/2
	end

	--Posició
	roach.x = roach.x + (roach.xSpeed * dt)
	roach.y = roach.y + (roach.ySpeed * dt)

	--Gravetat
	roach.ySpeed = roach.ySpeed + (gravity * dt)
	roach.xSpeed = roach.xSpeed * (1 - math.min(dt * roach.friction, 1))

	--Update estat
	if not (roach.canJump) then
		if roach.ySpeed < 0 then
			roach.state = "jump"
		elseif roach.ySpeed > 0 then
				roach.state = "fall"
		end
	else
		if roach.xSpeed > 2 then
			roach.state = "moveRight"
		elseif roach.xSpeed < -2 then
			roach.state = "moveLeft"
		else
			roach.xSpeed = 0
			roach.state = "stand"
		end
	end

	if roach.x > scEnd - roach.width then roach.x = scEnd - roach.width end
    if roach.x < scStart then roach.x = scStart end
    if roach.y > groundHeight - roach.height then
        roach.hitFloor(460)
    end

    if (roach.state == "moveRight" or roach.state == "moveLeft") then
    	TEsound.resume("roachsound")
		roach.soundIsPlaying = true
	else 
		roach.pauseSound()
	end
	if (keys["a"] or keys["d"])then
		local temp_frame = (love.timer.getTime()*3000)%480
			if temp_frame > 320 then
				roach.actualsprite = 2
			elseif temp_frame > 240 then
				roach.actualsprite = 1
			elseif temp_frame > 120 then
					roach.actualsprite = 3
			else -- temp_frame <= 120
					roach.actualsprite = 1
			end
	else
		if roach.state == "jump" then
			roach.actualsprite = 3
		else
			roach.actualsprite = 1
		end
	end


	if keys["d"] then
        roach.moveRight(dt)
    end
    if keys["a"] then
        roach.moveLeft(dt)
    end
    if keys["w"] then
        roach.jump()
    end 
end
