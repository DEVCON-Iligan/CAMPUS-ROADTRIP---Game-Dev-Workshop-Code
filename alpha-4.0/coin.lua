Coin = {}
Coin.__index =  Coin

function Coin.new(x, y)
    local instance = setmetatable({}, Coin)
    
    instance.x = x
    instance.y = y
    instance.img = love.graphics.newImage("assets/gem/gem-1.png")

    instance.width = instance.img:getWidth()
    instance.height = instance.img:getHeight()

    return instance
end

function Coin:draw()
    love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, self.width / 2, self.height / 2)
    
end