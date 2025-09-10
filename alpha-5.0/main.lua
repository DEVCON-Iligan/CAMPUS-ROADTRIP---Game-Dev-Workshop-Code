local STI = require("sti")
local Player = require("player")
local Coin = require("coin")
local GUI = require("gui")
love.graphics.setDefaultFilter("nearest", "nearest")
local Spike = require("spike")

local time = 0
local floatSpeed = 0.5      -- how fast it moves
local floatAmount = 10    -- how many pixels up/down

function love.load()
    Map = STI("map/2.lua", {"box2d"})

    World = love.physics.newWorld( 0, 0 )
    World:setCallbacks(beginContact, endContact)
    Map:box2d_init(World)
    Map.layers.solid.visible = false

    background = love.graphics.newImage("assets/background/backdrop.png")

    Player:load()
    Coin:loadAssets()
    GUI:load()

    Coin.new(300, 100)
    Coin.new(400, 200)
    Coin.new(500, 100)

    Spike.new(175, 189)
    Spike.new(195, 189)
    Spike.new(215, 189)
end

function love.update(dt)
    time = time + dt
    World:update(dt)
    Player:update(dt)
    Coin.updateAll(dt)
    Spike.updateAll(dt)
    GUI:update(dt)
end

function love.draw()
    local x, y, sx, sy = love.animateBackground()

    love.graphics.draw(background, x, y, 0, sx, sy)
    Map:draw(0, 0, 2, 2)

    love.graphics.push()
    love.graphics.scale(2, 2)

    Player:draw()
    Coin.drawAll()
    Spike.drawAll(dt)

    love.graphics.pop()
    GUI:draw()
end

function love.animateBackground()
    local winW, winH = love.graphics.getWidth(), love.graphics.getHeight()
    local imgW, imgH = background:getWidth(), background:getHeight()

    local sx = winW / imgW  -- scale so image width matches window
    local sy = sx           -- keep aspect ratio

    local x = 0
    local baseY = (winH - imgH * sy) / 2
    local y = baseY + math.sin(time * floatSpeed) * floatAmount

    return x, y, sx, sy
end

function love.keypressed(key)
    Player:jump(key)
end

function beginContact(a, b, collision)
    if Coin.beginContact(a, b, collision) then return end
    if Spike.beginContact(a, b, collision) then return end
    Player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
    Player:endContact(a, b, collision)
    print("end Contact Start")
end