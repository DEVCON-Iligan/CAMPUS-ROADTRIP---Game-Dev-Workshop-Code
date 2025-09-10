GUI = {}

function GUI:load()
    self.coins = {}
    self.coins.img = love.graphics.newImage("assets/gem/gem-1.png")
    self.coins.width = self.coins.img:getWidth()
    self.coins.height = self.coins.img:getHeight()
    self.coins.scale = 3
    self.coins.x = 50
    self.coins.y = 50
end

function GUI:update()
    
end

function GUI:draw()
    self:displayCoins()

end
 
function GUI:displayCoins()
    love.graphics.draw(self.coins.img, self.coins.x, self.coins.y, 0, self.coins.scale, self.coins.scale)

end
