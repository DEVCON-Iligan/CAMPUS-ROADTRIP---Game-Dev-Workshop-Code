local Player = {}

function Player:load()
    self.x = 100
    self.y = 0

    self.startX = self.x
    self.startY = self.y

    self.width = 15
    self.height = 18

    self.xVel = 0
    self.yVel = 0
    self.gravity = 1500

    self.color =  {
        red = 1,
        green = 1,
        blue = 1,
        speed = 3
    }

    self.health = {current = 3, max = 3}
    self.alive = true

    self.grounded = false
    self.jumpAmount = -500
    self.hasDoubleJump = false
    self.graceTime = 0
    self.graceDuration = 0.1

    self.direction = "right"
    self.state = "idle"

    self.maxSpeed = 200
    self.acceleration = 4000
    self.friction = 1500

    self.coins = 0

    self:loadAssets()

    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)

    -- self:takeDamage(1)
end

-- Player Death Logic

function Player:takeDamage(amount, knockbackDir)
    if self.health.current - amount > 0  then 
        self.health.current = self.health.current - amount
        self:tintRed()

        self.yVel = -400
        self.grounded = false

        if knockbackDir then
            self.xVel = 300 * knockbackDir
        end

        self.state = "hurt"

        self.hurtTimer = 0.4

        print("Player has recieved damage " ..self.health.current)
    else
        self.health.current = 0
        self:die()
    end 
    
    print("Player Health " ..self.health.current)
end

function Player:die()
    print("You are dead LMAO")
    self.alive = false
end

function Player:respawn()
    if not self.alive then
        self.physics.body:setPosition(self.startX, self.startY)
        self.health.current = self.health.max
        self.alive = true
    end
end


function Player:loadAssets()
    self.animation = {timer = 0, rate = 0.1}
    self.animation.run = {total = 6, current = 1, img={}}
    for i=1, self.animation.run.total do
        self.animation.run.img[i] = love.graphics.newImage("assets/player/run/"..i..".png")
    end

    self.animation.idle = {total = 4, current = 1, img={}}
    for i=1, self.animation.idle.total do
        self.animation.idle.img[i] = love.graphics.newImage("assets/player/idle/"..i..".png")
    end

    self.animation.air = {total = 4, current = 1, img={}}
    for i=1, self.animation.air.total do
        self.animation.air.img[i] = love.graphics.newImage("assets/player/air/"..i..".png")
    end

    self.animation.hurt = {total = 2, current = 1, img={}}
    for i=1, self.animation.hurt.total do
        self.animation.hurt.img[i] = love.graphics.newImage("assets/player/hurt/"..i..".png")
    end

    self.animation.draw = self.animation.idle.img[1]
    self.animation.width = self.animation.draw:getWidth()
    self.animation.height = self.animation.draw:getHeight()


end

function Player:tintRed()
    self.color.green = 0
    self.color.blue = 0
end

function Player:incrementCoins()
    self.coins = self.coins + 1

end

function Player:update(dt)
    self:unTint(dt)
    self:respawn()
    self:setAnimationState(dt)
    self:setDirection()
    self:animate(dt)
    self:decreaseGraceTime(dt)
    self:syncPhysics()
    self:move(dt)
    self:applyGravity(dt)
    
end

function Player:setAnimationState(dt)
    if self.state == "hurt" then
        self.hurtTimer = self.hurtTimer - dt
        if self.hurtTimer <= 0 then
            self.state = "idle"
        end 
    else
        self:setState()
    end
end


function Player:unTint(dt)
    self.color.red = math.min(self.color.red + self.color.speed * dt, 1)
    self.color.green = math.min(self.color.red + self.color.speed * dt, 1)
    self.color.blue = math.min(self.color.red + self.color.speed * dt, 1)
end

function Player:setState()
    if not self.grounded then
        self.state = "air"
    elseif self.xVel == 0 then
        self.state = "idle"
    else
        self.state = "run"
    end
    -- print(self.state)
end

function Player:setDirection()
    if self.xVel < 0 then
        self.direction = "left"
    elseif self.xVel > 0 then
        self.direction = "right"
    end
end

function Player:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
        self.animation.timer = 0
        self:setNewFrame()
    end    
end

function Player:setNewFrame()
    local anim = self.animation[self.state]

    if anim.current < anim.total then
        anim.current = anim.current + 1
    else
        anim.current = 1
    end

    self.animation.draw = anim.img[anim.current]
end

function Player: decreaseGraceTime(dt)
    if not self.grounded then
        self.graceTime = self.graceTime - dt
    end
end

function Player:applyGravity(dt)
    if not self.grounded then
        self.yVel = self.yVel + self.gravity * dt
    end
end

function Player:move(dt)
    if love.keyboard.isDown("d", "right") then
        self.xVel = math.min(self.xVel + self.acceleration * dt, self.maxSpeed)
    elseif love.keyboard.isDown("a", "left") then
        self.xVel = math.max(self.xVel - self.acceleration * dt, -self.maxSpeed)
    else
        self: applyFriction(dt)
    end
end

function Player:applyFriction(dt)
    if self.xVel > 0 then
        self.xVel = math.max(self.xVel - self.friction * dt, 0)
    elseif self.xVel < 0 then
        self.xVel = math.min(self.xVel + self.friction * dt, 0)
    end
    
end

function Player:syncPhysics()
    -- self.x = self.physics.body:getX()
    -- self.y = self.physics.body:getY()

    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel, self.yVel)
end

function Player:beginContact(a, b, collision)
    -- TODO: Have slope logic - up to 45 deg

    if self.grounded == true then return end
    local nx, ny = collision:getNormal()
    if a == self.physics.fixture then
        if ny > 0 then
            self:land(collision)
        elseif ny < 0 then
            self.yVel = 0
        end
    elseif b == self.physics.fixture then
        if ny < 0 then
            self:land(collision)
        elseif ny > 0 then
            self.yVel = 0
        end
        
   end
end

function Player:land(collision)
    self.currentGroundCollision = collision
    self.yVel = 0
    self.grounded = true
    self.hasDoubleJump = true
    self.graceTime = self.graceDuration
    -- print("player landed")

end

function Player:jump(key)
    if (key == "w" or key == "up") then

        if self.grounded or self.graceTime > 0 then
            self.yVel = self.jumpAmount
            self.grounded = false
            self.graceTime = 0
        elseif self.hasDoubleJump then
            self.hasDoubleJump = false
            self.yVel = self.jumpAmount * 0.6
        end

        print("Player jumped")
    end

end

function Player:endContact(a, b, collision)
    print("player has left the ground")
    if a == self.physics.fixture or b == self.physics.fixture then
        if self.currentGroundCollision == collision then
            self.grounded = false
            print("Player touching ground")

        end
    end
end

function Player:draw()
    -- love.graphics.rectangle("fill", self.x - self.width / 2, (self.y + (0.05 * self.height))  - self.height / 2, self.width, self.height)
    local scaleX = 1
    if self.direction == "left" then 
        scaleX = -1
    end

    love.graphics.setColor(self.color.red, self.color.green, self.color.blue )
    love.graphics.draw(self.animation.draw, self.x, self.y, 0, scaleX, 1, self.animation.width / 2, (self.animation.height + 12) / 2)

    love.graphics.setColor(1, 1, 1, 1)
end

return Player