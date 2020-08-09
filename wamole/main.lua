function newMole()
    posx = love.math.random(640 - mole:getWidth())
    posy = love.math.random(480 - mole:getHeight())
    nextmole = 1.25
end

function love.load()
    love.window.setMode(640, 480)
    love.window.setTitle("Whac-A-Mole")
    mole = love.graphics.newImage("mole.png")
    hammer = love.graphics.newImage("hammer.png")
    ding = love.audio.newSource("ding.mp3", "stream")
    love.graphics.setFont(love.graphics.newFont(20))
    love.mouse.setVisible(false)
    score = 0
    time = 60*0.5
    gameover = false
    dm = 0.5
    newMole()
end

function love.update(dt)
    time = time - dt
    dm = dm - dt
    nextmole = nextmole - dt
    if nextmole < 0 then
        newMole()
    end
    if love.mouse.isDown(1) and dm < 0 then
        mx = love.mouse.getX()
        my = love.mouse.getY()
        if mx > posx and  mx < posx+mole:getWidth() and my > posy and my < posy+mole:getHeight() and gameover == false then
            score = score + 1
            love.audio.play(ding)
            newMole()
        end
        dm = 0.5
    end
    if time <= 0 then
        gameover = true
    end
end

function love.draw()

    love.graphics.setBackgroundColor(0.04, 0.196, 0.125)
    
    if gameover then
        love.graphics.print("Game Over! Du fikk: " .. score .. " poeng!")
        love.graphics.draw(hammer, love.mouse.getX(), love.mouse.getY())
        return
    end
    love.graphics.print("Tid igjen: " .. math.ceil(time), 0, 0)
    love.graphics.print("Poeng: " .. score, 530, 0)
    love.graphics.draw(mole, posx, posy)
    love.graphics.draw(hammer, love.mouse.getX(), love.mouse.getY())
end