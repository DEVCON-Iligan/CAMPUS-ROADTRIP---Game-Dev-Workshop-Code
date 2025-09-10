Spike = {}
Spike.__index =  Spike
ActiveSpikes = {}

function Spike.new(x, y)
    local instance = setmetatable({}, Spike)
    
    instance.x = x
    instance.y = y
    instance.img = love.graphics.newImage("assets/spikes")

    instance.width = instance.img:getWidth()
    instance.height = instance.img:getHeight()
    instance.scaleX = 1

    instance.randomTimeOffset = math.random(0, 100)

    instance.toBeRemoved = false

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body , instance.physics.shape)
    instance.physics.fixture:setSensor(true)

    table.insert(ActiveSpikes, instance)
end

function Spike:removed()
    for i, instance in ipairs(ActiveSpikes) do
        if instance == self then
            Player:incrementSpikes()
            print(Player.Spikes)
            self.physics.body:destroy()
            table.remove(ActiveSpikes, i)
        end
    end
end

function Spike:loadAssets()
    self.animation = {timer = 0, rate = 0.1}
    self.animation.gemAnimate = {total = 5, current = 1, img={}}

    for i=1, self.animation.gemAnimate.total do
        self.animation.gemAnimate.img[i] = love.graphics.newImage("assets/gem/gem-"..i..".png")
    end

    self.animation.draw = self.animation.gemAnimate.img[1]
    self.animation.width = self.animation.draw:getWidth()
    self.animation.height = self.animation.draw:getHeight()
end

function Spike:update(dt)
    self:spin(dt)
    self:animate(dt)
    self:checkRemoved()
end

function Spike:checkRemoved()
    if self.toBeRemoved then
        self:removed()
    end
end


function Spike:spin(dt)
    self.scaleX = math.sin((love.timer.getTime() * 1.0) + self.randomTimeOffset)
end

function Spike:animate(dt)
    self.animation.timer = self.animation.timer + ((dt * 0.35))
    if self.animation.timer > self.animation.rate then
        self.animation.timer = 0
        self.animation.gemAnimate.current = self.animation.gemAnimate.current + 1

        if self.animation.gemAnimate.current > self.animation.gemAnimate.total then
            self.animation.gemAnimate.current = 1
        end

        self.animation.draw = self.animation.gemAnimate.img[self.animation.gemAnimate.current]
    end
end

function Spike:draw()
    love.graphics.draw(
        self.animation.draw,
        self.x, self.y,
        0, self.scaleX, 
        1,
        self.animation.width / 2,
        self.animation.height / 2
    )
end

function Spike.updateAll(dt)
    for i, instance in ipairs(ActiveSpikes) do
        instance:update(dt)
    end
end

function Spike.drawAll()
    for i, instance in ipairs(ActiveSpikes) do
        instance:draw()
    end
end 

function Spike.beginContact(a, b, collision)
    for i, instance in ipairs(ActiveSpikes) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a== Player.physics.fixture or b == Player.physics.fixture then
                instance.toBeRemoved = true
                return true
            end
        end
    end
end