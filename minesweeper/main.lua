
function restart()
    win = false
    gameOver = false
    tiles = {
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    }
    tleft = 100
    hidden = {
        {1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1},
    }
    for p=1,10 do
        randx = love.math.random(1,10)
        randy = love.math.random(1,10)
        if tiles[randy][randx] == -1 then
            p = p - 1
        else 
            tiles[randy][randx] = -1
            for x=-1,1 do
                for y =-1,1 do
                    if randy+y > 0 and randy+y < 11 and randx+x > 0 and randx+x < 11 then
                        if not (tiles[randy + y][randx + x] == -1) and not (x == 0 and y == 0) then
                            tiles[randy + y][randx + x] = tiles[randy + y][randx + x] + 1
                        end
                    end
                end
            end
        end
    end
end


function love.load()
    love.window.setMode(640,640)
    love.window.setTitle("Minesweeper!")

    loseimg = love.graphics.newImage("lose.png")
    winimg = love.graphics.newImage("win.png")
    tileImages = {
        flag=love.graphics.newImage("MINESWEEPER_F.png"),
        hidden=love.graphics.newImage("MINESWEEPER_X.png"),
        [-1]=love.graphics.newImage("MINESWEEPER_M.png"),
        [0]=love.graphics.newImage("MINESWEEPER_0.png"),
        [1]=love.graphics.newImage("MINESWEEPER_1.png"),
        [2]=love.graphics.newImage("MINESWEEPER_2.png"),
        [3]=love.graphics.newImage("MINESWEEPER_3.png"),
        [4]=love.graphics.newImage("MINESWEEPER_4.png"),
        [5]=love.graphics.newImage("MINESWEEPER_5.png"),
        [6]=love.graphics.newImage("MINESWEEPER_6.png"),
        [7]=love.graphics.newImage("MINESWEEPER_7.png"),
        [8]=love.graphics.newImage("MINESWEEPER_8.png"),
    }
    restart()
end

function love.draw()
    for y=1,10 do
        for x=1,10 do
            if hidden[y][x] == 1 then
                love.graphics.draw(tileImages["hidden"], 64*(x-1), 64*(y-1), 0, 0.3, 0.3)
            elseif hidden[y][x] == -1 then
            love.graphics.draw(tileImages["flag"], 64*(x-1), 64*(y-1), 0, 0.3, 0.3)
            else
                love.graphics.draw(tileImages[tiles[y][x]], 64*(x-1), 64*(y-1), 0, 0.3, 0.3)
            end
        end
    end
    love.graphics.print(tleft)
    if gameOver then
        love.graphics.draw(loseimg, (640/2)-(loseimg:getWidth()/2),(640/2)-(loseimg:getHeight()/2))
    elseif win then
        love.graphics.draw(winimg, (640/2)-(winimg:getWidth()/2),(640/2)-(winimg:getHeight()/2))
    end
end

function clear(cx,cy)
    if tiles[cy][cx] == 0 and hidden[cy][cx] == 1 then
        hidden[cy][cx] = 0
        tleft = tleft - 1
        if cx+1 < 11 then clear(cx+1,cy) end
        if cx-1 > 0 then clear(cx-1,cy) end
        if cy+1 < 11 then clear(cx,cy+1) end
        if cy-1 > 0 then clear(cx,cy-1) end
    end
    if tiles[cy][cx] ~= 0 and hidden[cy][cx] == 1 then
        hidden[cy][cx] = 0
        tleft = tleft - 1
    end
end

function love.mousereleased(mx,my,but)
    if gameOver or win then
        restart()
        return
    end
    tx = math.ceil(mx/64)
    ty = math.ceil(my/64)
    if but == 1 and hidden[ty][tx] ~= -1 then
        if tiles[ty][tx] == 0 then
            clear(tx,ty)
        elseif tiles[ty][tx] == -1 then
            hidden[ty][tx] = 0
            gameOver = true
        else
            hidden[ty][tx] = 0
            tleft = tleft - 1
        end
    elseif but == 2 then
        if hidden[ty][tx] == 1 then hidden[ty][tx] = -1
        elseif hidden[ty][tx] == -1 then hidden[ty][tx] = 1 end
    end
    if tleft == 10 then
        win = true
    end
end