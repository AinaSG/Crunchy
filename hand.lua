hand = {}

function hand.loadAssets()
	hand.img = love.graphics.newImage("assets/vhand.png")
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
end

function hand.update(dt)
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