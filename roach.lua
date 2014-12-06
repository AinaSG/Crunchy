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
	roach.sound = {}
	roach.sound.move = "assets/roach-move.mp3"
end

function roach.init()
	roach.x = 0
	roach.y = groundHeight - roach.height
	roach.state = "alive"
end

function roach.update(dt)
	if (not (keys["a"] and keys["w"])) then
		if (keys["a"]) then 
			roach.x = roach.x - 5 
			TEsound.play(roach.sound.move, "moveSound")
		elseif (keys["d"]) then
			roach.x = roach.x + 5
			TEsound.play(roach.sound.move, "moveSound")
		else
			TEsound.stop("movesound", false)
		end
	end
end