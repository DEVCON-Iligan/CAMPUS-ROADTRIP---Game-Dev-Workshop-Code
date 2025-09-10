local STI = require("sti")
require("player")
require("coin")
love.graphics.setDefaultFilter("nearest", "nearest")

local time = 0
local floatSpeed = 0.5      -- how fast it moves
local floatAmount = 10    -- how many pixels up/down

function love.load()
    Map = STI("map/1.lua", {"box2d"})

    World = love.physics.newWorld( 0, 0 )
    World:setCallbacks(beginContact, endContact)
    Map:box2d_init(World)
    Map.layers.solid.visible = false

    background = love.graphics.newImage("assets/background/backdrop.png")

    Player:load()

    coin1 = Coin.new(300, 200)
    coin2 = Coin.new(400, 200)
    coin3 = Coin.new(500, 100)
end

function love.update(dt)
    time = time + dt
    World:update(dt)

    Player:update(dt)

end

function love.draw()
    local winW, winH = love.graphics.getWidth(), love.graphics.getHeight()
    local imgW, imgH = background:getWidth(), background:getHeight()

    local sx = winW / imgW  -- scale so image width matches window
    local sy = sx   -- keep aspect ratio

    local x = 0
    
    local baseY = (winH - imgH * sy) / 2
    local y = baseY + math.sin(time * floatSpeed) * floatAmount

    love.graphics.draw(background, x, y, 0, sx, sy)

    Map:draw(0, 0, 2, 2)

    love.graphics.push()
    love.graphics.scale(2, 2)

    Player:draw()
    coin1:draw()
    coin2:draw()
    coin3:draw()

    love.graphics.pop()

end

function love.keypressed(key)
    Player:jump(key)
end

function beginContact(a, b, collision)
    Player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
    Player:endContact(a, b, collision)
    print("end Contact Start")
end