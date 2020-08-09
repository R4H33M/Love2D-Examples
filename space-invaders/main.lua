function love.load()
    love.window.setMode(640, 480)
    love.window.setTitle("Space Invaders!")
    bg_image = love.graphics.newImage("darkPurple.png")
    bg_image:setWrap("repeat", "repeat")
    bg_quad = love.graphics.newQuad(0,0,640,480,bg_image:getWidth(),bg_image:getHeight())

    font = love.graphics.newFont("kenvector_future.ttf", 30)
    love.graphics.setFont(font)

    --setup player
    player = love.graphics.newImage("playerShip1_red.png")
    playerhy = player:getHeight()/2
    playerhx = player:getWidth()/2
    playerX = 320
    playerY = 400
    speed = 300
    life = 3

    --astroids
    astroidSpeed = 150
    astroids = {}
    astroid = love.graphics.newImage("meteorGrey_med2.png")
    astroidhx = astroid:getWidth()/2
    astroidhy = astroid:getHeight()/2
    nextAstroid = 3

    --bullets
    bullets = {}
    bullet = love.graphics.newImage("bullet.png")
    bulletCooldown = 0.5
    bullethx = bullet:getWidth()/2
    bullethy = bullet:getHeight()/2
    bulletSpeed = 400

    --powerups
    powerup = love.graphics.newImage("powerupRed_shield.png")
    powerupCooldown = love.math.random(15,20)
    powerupSpeed = 150
    poweruphx = powerup:getWidth()/2
    poweruphy = powerup:getHeight()/2

    --misc items
    misc = {}

    --gameover
    gameOver = false

end

function love.update(dt)

    if gameOver then
        return
    end

    if life == 0 or life < 0 then
        gameOver = true
    end

    --time dependent
    nextAstroid = nextAstroid - dt
    bulletCooldown = bulletCooldown - dt
    powerupCooldown = powerupCooldown - dt

    --spawn next astroid
    if nextAstroid < 0 then
        nextAstroid = love.math.random(0.5,3)
        table.insert(astroids,{love.math.random(40,600), 0, love.math.random(130,200)})
    end

    if powerupCooldown < 0 then
        powerupCooldown = love.math.random(15,20)
        table.insert(misc,{love.math.random(40,600), 0, 1})
    end

    --keyboard input
    if love.keyboard.isDown("right") then
        playerX = playerX + speed*dt
        if playerX > 640 + playerhx then
            playerX = 0
        end
    end
    if love.keyboard.isDown("left") then
        playerX = playerX - speed*dt
        if playerX + playerhx < 0 then
            playerX = 640
        end
    end
    if love.keyboard.isDown("space") and bulletCooldown < 0 then
        bulletCooldown = 0.5
        table.insert(bullets, {playerX,playerY-playerhy})
    end

    --update astroids
    for k, v in pairs(astroids) do
        v[2] = v[2] + v[3]*dt
        if (v[2] - (astroidhy/2)) > 480  then
            astroids[k] = nil
            life = life - 1
        end
    end

    --update misc
    for k,v in pairs(misc) do
        v[2] = v[2] + powerupSpeed*dt
    end

    --update bullets
    for k, v in pairs(bullets) do
        v[2] = v[2] - bulletSpeed*dt
    end

    --check for bullet-astroid collisions
    for i, b in pairs(bullets) do
        for j, a in pairs(astroids) do
            if b[1] + bullethx < a[1] + astroidhx and b[1] + bullethx > a[1] - astroidhx then
                if b[2] < a[2] + astroidhy then
                    bullets[i] = nil
                    astroids[j] = nil
                end
            end
            if b[1] - bullethx < a[1] + astroidhx and b[1] - bullethx > a[1] - astroidhx then
                if b[2] < a[2] + astroidhy then
                    bullets[i] = nil
                    astroids[j] = nil
                end
            end
        end
    end

    for k, v in pairs(misc) do
        if v[1] - (poweruphx) > playerX - playerhx and v[1] - (poweruphx) < playerX + playerhx then
            if v[2] + poweruphy > playerY - playerhy and v[2] + poweruphy < playerY + playerhy then
                if v[3] == 1 then
                    life = life + 1
                    misc[k] = nil
                end
            end
        elseif v[1] + (poweruphx) > playerX - playerhx and v[1] + (poweruphx) < playerX + playerhx then
            if v[2] + poweruphy > playerY - playerhy and v[2] + poweruphy < playerY + playerhy then
                if v[3] == 1 then
                    life = life + 1
                    misc[k] = nil
                end
            end
        end
    end

    for k,v in pairs(astroids) do
        if v[1] - (astroidhx) > playerX - playerhx and v[1] - (astroidhx) < playerX + playerhx then
            if v[2] + astroidhy > playerY - playerhy and v[2] + astroidhy < playerY + playerhy then
                life = life -1
                astroids[k] = nil
            end
        elseif v[1] + (astroidhx) > playerX - playerhx and v[1] + (astroidhx) < playerX + playerhx then
            if v[2] + astroidhy > playerY - playerhy and v[2] + astroidhy < playerY + playerhy then
                life = life -1
                astroids[k] = nil
            end
        end
    end
end

function love.draw()

    love.graphics.draw(bg_image,bg_quad,0,0)

    if gameOver then
        love.graphics.print("Game Over!",200, 50)
        return
    end

    love.graphics.draw(player, playerX-(playerhx), playerY-(playerhy))
    mx = love.mouse.getX()
    my = love.mouse.getY()
    love.graphics.print("Liv: " .. life)
    for k, v in pairs(astroids) do
        love.graphics.draw(astroid, v[1]-(astroidhx), v[2]-(astroidhy))
    end
    for k, v in pairs(bullets) do
        love.graphics.draw(bullet, v[1]-(bullethx), v[2]-(bullethy))
    end
    for k, v in pairs(misc) do
        if v[3] == 1 then
            love.graphics.draw(powerup, v[1]-(poweruphx), v[2]-(poweruphy))
        end
    end
end