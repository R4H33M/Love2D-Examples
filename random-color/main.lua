function love.load()
    rød = 0
    blå = 0
    grønn = 0
end

function love.update()
    if love.keyboard.isDown("space") then
        rød = love.math.random()
        blå = love.math.random()
        grønn = love.math.random()
    end
end

function love.draw()
   love.graphics.setBackgroundColor(rød, blå, grønn)
end