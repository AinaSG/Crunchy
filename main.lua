require "roach"
require "hand"
require "spray"
require "gas"

require("TEsound") --Llibreria per a controlar so
TEsound.playLooping("assets/fight.ogg", "music")



groundHeight = 460
scWidth = 1200
scHeight = 600
scMargin = 20
scStart = scMargin
scEnd = scWidth - scMargin
gravity = 2800
score = 0
										hastoped = false

function loadAssets()
	imgBackground = love.graphics.newImage("assets/background.png");
	leftlimit = 15
	rightlimit = 1200-15-roach.width
	roach.loadAssets()
	hand.loadAssets()
	spray.loadAssets()
	gas.loadAssets()
end

function initKeys() 
	keys = {}
	keys["d"] = false
	keys["a"] = false
	keys["w"] = false
	keys[" "] = false
	keys["t"] = false
end

function love.load()
							--canvas = love.graphics.newCanvas(64,64)
							--local str = love.filesystem.read('Shaders Locos/CTR.frag')
							--shader = love.graphics.newShader(str)
							--shader:send('inputSize', {love.graphics.getWidth(), love.graphics.getHeight()})
							--shader:send('textureSize', {love.graphics.getWidth(), love.graphics.getHeight()})

	globalTime = 0
	love.math.setRandomSeed(os.time())
	initKeys()
	loadAssets()
	

	roach.init()
	hand.init()
	spray.init()
	gas.init()
end

function love.update(dt)
								if not hastoped then
	globalTime = globalTime + dt
	score = math.floor(globalTime * 12) 
	spray.update(dt)
	gas.update(dt)

	if (roach.health > 0) then
		roach.update(dt)
	else 
		roach.state = "dead"
		if (keys[" "]) then
		love.load()
	end
	end

	hand.update(dt)
	TEsound.cleanup()
								end
end

function love.draw()
						--love.graphics.setCanvas(canvas)
	love.graphics.draw(imgBackground,0,0)
	roach.draw()
	hand.draw()
	gas.draw()
	love.graphics.draw(spray.img, spray.x, spray.y)
	drawScore()
	drawHealthBar()
						--love.graphics.setCanvas()
						--love.graphics.setShader(shader)
						--love.graphics.draw(canvas)
						--love.graphics.setShader()
end



function drawHealthBar()
	love.graphics.setColor(255,0,0)
	love.graphics.rectangle("fill", 5, 5,200, 20)
	love.graphics.setColor(255,255,255)
	if (roach.health > 25 or globalTime%0.5 > 0.25) then
		love.graphics.setColor(0,255,0)
		love.graphics.rectangle("fill", 5, 5, math.max(1,roach.health/100 * 200), 20)
	end
	love.graphics.setColor(255,255,255)
end

function drawScore()
	 love.graphics.printf("" .. score,0,136,800,"center")
end
function love.keypressed(key)
											if key == "p" then hastoped = not hastoped end
	if type(keys[key]) ~= nil then
		keys[key] = true
	end
end

function love.keyreleased(key)
	if type(keys[key]) ~= nil then
		keys[key] = false
	end
end
