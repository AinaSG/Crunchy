roach = {}
roach.width = 64
roach.height = 128

function roach.loadAssets()
	roach.img = love.graphics.newImage("assets/roach.png")
	roach.sprites = {}
	roach.sprites[0] = love.graphics.newQuad(0, 0, roach.width, roach.height, roach.img:getDimensions())
	roach.sprites[1] = love.graphics.newQuad(roach.width, 0, roach.width, roach.height, roach.img:getDimensions())
	roach.sprites[2] = love.graphics.newQuad(0, roach.height, roach.width, roach.height, roach.img:getDimensions())
	roach.sprites[3] = love.graphics.newQuad(roach.width, roach.height, roach.width, roach.height, roach.img:getDimensions())
	TEsound.playLooping("assets/roach-move.mp3", "roachsound")
	TEsound.pause("roachsound")
end

function roach.init()
	roach.x = 0
	roach.y = groundHeight - roach.height
	roach.state = "alive"
	roach.soundIsPlaying = false;
end

function roach.update(dt)
	if (not (keys["a"] and keys["w"])) then
		if (keys["a"]) then 
			roach.x = roach.x - 12
			if (not roach.soundIsPlaying) then
				TEsound.resume("roachsound")
				roach.soundIsPlaying = true
			end
		elseif (keys["d"]) then
			roach.x = roach.x + 12
			if (not roach.soundIsPlaying) then
				TEsound.resume("roachsound")
				roach.soundIsPlaying = true
			end
		else
			TEsound.pause("roachsound")
			roach.soundIsPlaying = false
		end
	end
	if (roach.x < leftlimit) then 
		roach.x = leftlimit
		TEsound.pause("roachsound")
		roach.soundIsPlaying = false
	end
	if (roach.x > rightlimit) then 
		roach.x = rightlimit
		TEsound.pause("roachsound")
		roach.soundIsPlaying = false
	end
end