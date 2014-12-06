require "roach"
require "hand"
require "spray"
require "gas"

require("TEsound") --Llibreria per a controlar so


groundHeight = 460
scWidth = 1200
scHeight = 600
scMargin = 20
scStart = scMargin
scEnd = scWidth - scMargin
gravity = 2800

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
end

function love.load()
	globalTime = 0
	love.math.setRandomSeed(os.time())
	loadAssets()
	initKeys()

	roach.init()
	hand.init()
	spray.init()
	gas.init()
end

function love.update(dt)
	globalTime = globalTime + dt
	spray.update(dt)
	gas.update(dt)

	if (roach.state ~= "dead") then
		roach.update(dt)
	else 
		if (keys[" "]) then
			love.load()
		end
	end

	hand.update(dt)
	
	TEsound.cleanup()
end

function love.draw()
	love.graphics.draw(imgBackground,0,0)
	love.graphics.draw(roach.img, roach.sprites[1], roach.x, roach.y)
	love.graphics.draw(hand.img, hand.x, hand.y)
	gas.draw()
	--love.graphics.draw(spray.img, spray.x, spray.y)

	drawHealthBar()
end

function drawHealthBar()
	if (roach.health > 25 or globalTime%0.5 > 0.25) then
		love.graphics.setColor(255,0,0)
		love.graphics.rectangle("fill", 5, 5, math.max(1,roach.health/100 * 200), 20)
		love.graphics.setColor(255,255,255)
	end
end

function love.keypressed(key)
	if type(keys[key]) ~= nil then
		keys[key] = true
	end
end

function love.keyreleased(key)
	if type(keys[key]) ~= nil then
		keys[key] = false
	end
end