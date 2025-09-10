local Player = require("player")

local Stone = {img = love.graphics.newImage("assets/stone-2.png")}
Stone.__index =  Stone

Stone.width = Stone.img:getWidth()
Stone.height = Stone.img:getHeight()

local ActiveStones = {}

function Stone.new(x, y)
    local instance = setmetatable({}, Stone)
    instance.x = x
    instance.y = y
    instance.r = 0 

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "dynamic")
    instance.physics.shape = love.physics.newRectangleShape((instance.width * 0.35), (instance.height * 0.35))
    instance.physics.fixture = love.physics.newFixture(instance.physics.body , instance.physics.shape)

    instance.physics.body:setMass(25)

    table.insert(ActiveStones, instance)
end

function Stone:update(dt)
    self:syncPhysics()
end

function Stone:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.r = self.physics.body:getAngle()
end

function Stone:draw()
    love.graphics.draw(
        self.img,
        self.x, self.y,
        self.r, 0.45, 0.45,
        (self.width ) / 2,
        (self.height) / 2
    )
end

function Stone.updateAll(dt)
    for i, instance in ipairs(ActiveStones) do
        instance:update(dt)
    end
end

function Stone.drawAll()
    for i, instance in ipairs(ActiveStones) do
        instance:draw()
    end
end 

return Stone

