Player = {}

function Player:load()
    self.x = 100
    self.y = 0

    self.width = 15
    self.height = 18

    self.xVel = 0
    self.yVel = 100

    self.maxSpeed = 200
    self.acceleration = 4000
    self.friction = 3500

    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
end

function Player:update(dt)
    self:syncPhysics()
end

function Player:syncPhysics()
    -- self.x = self.physics.body:getX()
    -- self.y = self.physics.body:getY()

    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel, self.yVel)
end

function Player:draw()
    love.graphics.rectangle("fill", self.x - self.width / 2, (self.y + (0.05 * self.height))  - self.height / 2, self.width, self.height)
end