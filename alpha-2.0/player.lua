Player = {}

-- remember player contact

function Player:load()
    self.x = 100
    self.y = 0

    self.width = 15
    self.height = 18

    self.xVel = 0
    self.yVel = 100
    self.gravity = 1500

    self.grounded = false

    self.maxSpeed = 200
    self.acceleration = 4000
    self.friction = 1000

    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
end

function Player:update(dt)
    self:syncPhysics()
    self:move(dt)
    self:applyGravity(dt)
    
end

function Player:applyGravity(dt)
    if not self.grounded then
        self.yVel = self.yVel + self.gravity * dt
    end
end

function Player:move(dt)
    if love.keyboard.isDown("d", "right") then
        if self.xVel < self.maxSpeed then
            if self.xVel + self.acceleration * dt < self.maxSpeed then
                self.xVel = self.xVel + self.acceleration * dt
            else
                self.xVel = self.maxSpeed
            end
        end
    elseif love.keyboard.isDown("a", "left") then
        if self.xVel > -self.maxSpeed then
            if self.xVel - self.acceleration * dt > -self.maxSpeed then
                self.xVel = self.xVel - self.acceleration * dt
            else
                self.xVel = -self.maxSpeed
            end
        end
    else
        self: apllyFriction(dt)
    end
end

function Player:apllyFriction(dt)
    if self.xVel > 0 then
        if self.xVel - self.friction * dt > 0 then 
            self.xVel = self.xVel - self.friction * dt
        else
            self.xVel = 0
        end
    elseif self.xVel < 0 then
        if self.xVel + self.friction * dt < 0 then 
            self.xVel = self.xVel + self.friction * dt
        else
            self.xVel = 0
        end
    
    end
    
end

function Player:beginContact(a, b, collision)
    if self.grounded == true then return end

    local nx, ny = collision:getNormal()

    if a == self.physics.fixture then
        if ny > 0 then
            self:land()
        end

    elseif b == self.physics.fixture then
        if ny < 0 then
            self:land()
        end
    end
    
end

function Player:land()
    self.yVel = 0
    self.grounded = true

end

function Player:endContact(a, b, collision)
    
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