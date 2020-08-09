function love.load()

	--setup
	speed = 300
	bspeed = 350
	speedinc = 20
	winner = ""
	mode = 1
	love.window.setMode(640,480)
	love.window.setTitle("LUApong")

	bg_img = love.graphics.newImage("img/bg.png")
	bg_img:setWrap("repeat","repeat")
	bg_quad = love.graphics.newQuad(0,0,640,480,bg_img:getWidth(), bg_img:getHeight())


	--title screen
	tscreen = love.graphics.newImage("img/titleScreen.png")

	--font
	font = love.graphics.newFont("Kenney Future.ttf", 40)
	fontsm = love.graphics.newFont("Kenney Future.ttf", 20)
	love.graphics.setFont(font)

	--set up red player
	pred = love.graphics.newImage("img/paddleRed.png")
	rx = 320
	ry = 420
	rscore = 0

	--set up blue player
	pblue = love.graphics.newImage("img/paddleBlu.png")
	bx = 320
	by = 60
	bscore = 0

	--set up ball
	ball = love.graphics.newImage("img/ballGrey.png")
	gx = 320
	gy = 240
	gdx = bspeed * love.math.random()
	gdy = bspeed - gdx
	frozen = true
	timer = 1

end

function love.update(dt)

	if mode == 1 then
		if (love.mouse.isDown(1)) then
			mode = 2
		end
		return
	end

	if mode == 3 then
		return
	end

	--update the timer, and ball state
	timer = timer - dt
	if timer <= 0 then
		frozen = false
	end

	--red player movement
	if love.keyboard.isDown("right") then
		rx = rx + speed*dt
	elseif love.keyboard.isDown("left") then
		rx = rx - speed*dt
	end

	--check if red player out of bounds
	if rx < 0 then
		rx = 0
	end
	if rx + pred:getWidth() > 640 then
		rx = 640 - pred:getWidth()
	end

	--quit game with escape
	if love.keyboard.isDown("escape") then
		love.event.quit()
	end

	--blue player movement
	if love.keyboard.isDown("x") then
		bx = bx + speed*dt
	elseif love.keyboard.isDown("z") then
		bx = bx - speed*dt
	end

	--blue player wall collision
	if bx < 0 then
		bx = 0
	end
	if bx + pblue:getWidth() > 640 then
		bx = 640 - pblue:getWidth()
	end

	--update ball position if not frozen
	if frozen == false then
		gx = gx + gdx * dt
		gy = gy + gdy * dt
	end

	--check if the ball is out of bounds horizontally (no goal)
	if gx + ball:getWidth() > 640 or gx < 0 then
		gdx = -gdx
	end

	--Check if someone has scored
	if (gy < 0) then
		rscore = rscore + 1
		gy = 240
		gx = 320
		frozen = true
		timer = 1
		gdx = bspeed * love.math.random()
		gdy = bspeed - gdx
		gdy = -gdy
	end

	if (gy > 480) then
		bscore = bscore + 1
		gy = 240
		gx = 320
		frozen = true
		timer = 1
		gdx = bspeed * love.math.random()
		gdy = bspeed - gdx
	end

	--increase ball speed
	if gdx > 0 then
		gdx = gdx + dt*speedinc
	else
		gdx = gdx - dt*speedinc
	end
	if gdy > 0 then
		gdy = gdy + dt*speedinc
	else
		gdy = gdy - dt*speedinc
	end

	--check if ball is hitting red paddle
	if gy + ball:getHeight() >= ry and gy + ball:getHeight() <= ry + pred:getHeight() and gx >= rx and gx <= rx + pred:getWidth() then
		gdy = -gdy
		gy = ry - ball:getHeight()
	end

	--check if ball is hitting blue paddle
	if gy >= by and gy <= by + pblue:getHeight() and gx >= bx and gx <= bx + pblue:getWidth() then
		gdy = -gdy
		gy = by + pblue:getHeight()
	end

	--check if red player has won
	if rscore >= 10 then
		mode = 3
		winner = "RED"
	end

	--check if blue player has won
	if bscore >= 10 then
		mode = 3
		winner = "BLUE"
	end

end

function love.draw()

	love.graphics.draw(bg_img,bg_quad)

	if mode == 1 then
		love.graphics.draw(tscreen, 0,0)
		return
	end

	if mode == 3 then
		love.graphics.print("The winner is: " .. winner .. "!",50, 200)
		return
	end

	--draw stuff
	love.graphics.setColor(255,0,0,255)
	love.graphics.print(rscore, 570, 250)
	love.graphics.setColor(0,0,255,255)
	love.graphics.print(bscore, 570, 190)
	love.graphics.setColor(255,255,255,255)
	if frozen then
		love.graphics.setFont(fontsm)
		love.graphics.print("GET READY!", 260, 190)
		love.graphics.setFont(font)
	end
	love.graphics.setLineWidth(3)
	love.graphics.line(610, 240, 560, 240)
	love.graphics.draw(pred, rx, ry)
	love.graphics.draw(pblue, bx, by)
	love.graphics.draw(ball, gx, gy)

end

