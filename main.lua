require "roach"
require "hand"
require("TEsound") --Llibreria per a controlar so


groundHeight = 460
scWidth = 1200
scHeight = 600

function loadAssets()
	imgBackground = love.graphics.newImage("assets/background.png");
	leftlimit = 15
	rightlimit = 1200-15-roach.width
	roach.loadAssets()
	hand.loadAssets()
end

function initKeys() 
	keys = {}
	keys["d"] = false
	keys["a"] = false
	keys[" "] = false
end

function love.load()
	love.math.setRandomSeed(os.time())
	loadAssets()
	initKeys()

	roach.init()
	hand.init()
end

function love.update(dt)

	if (roach.state == "alive") then
		roach.update(dt)
	else 

	end
	hand.update(dt)
	TEsound.cleanup()
end
function love.draw()
	love.graphics.draw(imgBackground,0,0)
	love.graphics.draw(roach.img, roach.sprites[1], roach.x, roach.y)
	love.graphics.draw(hand.img, hand.x, hand.y)
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