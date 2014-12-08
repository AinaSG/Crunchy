require "roach"
require "hand"
require "spray"
require "gas"
require "sick"

require("TEsound") --Llibreria per a controlar so

highscore.set("scores", 5, "", 0)
TEsound.playLooping("assets/fight.ogg", "music")
TEsound.volume("music", 0.3)

function floatRand(min,max)
	return love.math.random(0, (max-min)*1000000)/1000000 + min
end

groundHeight = 460
scWidth = 1200
scHeight = 600
scMargin = 20
scStart = scMargin
scEnd = scWidth - scMargin
gravity = 2800
gameState = "title"


function loadAssets()
	imgBackground = love.graphics.newImage("assets/background.png")
	titleBg = love.graphics.newImage("assets/titlebg.png")
	title = love.graphics.newImage("assets/title.png")
	highscoresBg = love.graphics.newImage("assets/postit.png")
	title_font = love.graphics.newFont("assets/ComingSoon.ttf",65)
	text_font = love.graphics.newFont("assets/ComingSoon.ttf",48)
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
	keys["h"] = false
end

function love.load()
	score = 0
	isPaused = false
	finishedGame = false
	timeSinceGameFinished = 0
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
	globalTime = globalTime + dt

	if gameState == "game" or gameState == "highscores" then
		if not isPaused then
			spray.update(dt)
			gas.update(dt)

			if (roach.health > 0) then
				score = score + dt* 12
				roach.update(dt)
			else 
				roach.die()
				if not finishedGame then
					finishedGame = true
					highscore.add("", math.floor(score))
					highscore.save()
				end
				timeSinceGameFinished = timeSinceGameFinished + dt
				if timeSinceGameFinished > 1.5 then
					local sc = math.floor(score)
					local lastSc
					for i, score, name in highscore() do
						lastSc = score
					end
					if (sc >= lastSc) then
						gameState = "highscores"
					end
				end
				if roach.y + roach.height < groundHeight then
					roach.y = math.min(groundHeight - roach.height, roach.y + (hand.fallSpeed * dt))
				end
				if keys[" "] then
					gameState = "game"
					love.load()
				elseif keys["h"] then
					gameState = "highscores"
				end
			end
			hand.update(dt)
		end
	end
	TEsound.cleanup()
end

function love.draw()
	if gameState == "title" then
		drawTitle()
	elseif gameState == "controls" then
		drawControls()
	elseif gameState == "game" or gameState == "highscores" then
		drawGame()
	end
	if gameState == "highscores" then
		drawHighscores()
	end
end

function drawTitle()
	love.graphics.draw(titleBg,0,0)
	love.graphics.draw(title,math.sin(globalTime * 10) * 5,math.sin(globalTime * 30) * 5)
end

function drawControls()
	love.graphics.draw(titleBg,0,0)
end 

function drawGame()
	love.graphics.draw(imgBackground,0,0)
	roach.draw()
	hand.draw()
	gas.draw()
	love.graphics.draw(spray.img, spray.x, spray.y)
	drawScore()
	drawHealthBar()
end

function drawHighscores()
	love.graphics.draw(highscoresBg,0,0)
	love.graphics.setColor(0,0,0)
	love.graphics.setFont(title_font)
	love.graphics.print("Highscores", 450, 80)
	love.graphics.setFont(text_font)
	for i, iscore, name in highscore() do
		if iscore == math.floor(score) then
			if globalTime%0.5 > 0.25 then
				love.graphics.print(i .. ". " .. iscore , 450, i * 65 + 110)
			end
		else
			love.graphics.print(i .. ". " .. iscore , 450, i * 65 + 110)
		end
	end

	love.graphics.setColor(255,255,255)
end



function drawHealthBar()
	love.graphics.setColor(20,20,20)
	love.graphics.rectangle("fill", 3, 3,204, 24)
	love.graphics.setColor(255,64,79)
	love.graphics.rectangle("fill", 5, 5,200, 20)
	if (roach.health > 25 or globalTime%0.5 > 0.25) then
		love.graphics.setColor(0,255,133)
		love.graphics.rectangle("fill", 5, 5, math.max(1,roach.health/100 * 200), 20)
	end
	love.graphics.setColor(255,255,255)
end

function drawScore()
	local sc = math.floor(score)
	love.graphics.setColor(0,0,0)
	love.graphics.setFont(text_font)
	love.graphics.printf(sc,1100,15,32,"center")
end
function love.keypressed(key)
	if key == "p" then isPaused = not isPaused end
	if key == "escape" then
	      love.event.push("quit")    
	end
	if type(keys[key]) ~= nil then
		keys[key] = true
	end
end

function love.keyreleased(key)
	if gameState == "title" then
		if keys[" "] then
			gameState = "controls"
		end
	elseif gameState == "controls" then
		if keys[" "] then
			gameState = "game"
		end
	end
	if type(keys[key]) ~= nil then
		keys[key] = false
	end
end
