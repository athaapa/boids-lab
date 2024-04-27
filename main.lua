Boid = require 'Boid'

boids = {}

love.window.setMode(500, 500, {["fullscreen"] = true})

--print(love.graphics.getDimensions());

for i=1,100 do
    table.insert(boids, Boid:new())
end

randomBoid = math.random(1, #boids)
boids[randomBoid].color = {1,0,0}

function love.update(dt)
    if love.keyboard.isDown("space") then
        love.event.quit()
    end

    for _, boid in pairs(boids) do
        boid:edges()
        boid:flock(boids)
        boid:update(dt)
    end
end

function love.mousepressed(x, y, istouch, presses)
    for _, boid in pairs(boids) do
        boid.position = Vector.new(math.random(0, 1280), math.random(0, 720))
        boid.velocity = Vector.new(math.random(-150, 150), math.random(-150, 150))
        boid.acceleration = Vector.new(0, 0)
        boid.color = {1,1,1}
    end
    randomBoid = math.random(1, #boids)
    boids[randomBoid].color = {1,0,0}
end

function love.draw()
    for _, boid in pairs(boids) do
        boid:draw()
    end

    local boidPos = boids[randomBoid].position
    local boidAcceleration = boids[randomBoid].acceleration
    local boidVelocity = boids[randomBoid].velocity
    --print(boidAcceleration.x, boidAcceleration.y)
    love.graphics.line(boidPos.x, boidPos.y, boidPos.x + boidVelocity.x, boidPos.y + boidVelocity.y)
    --love.graphics.print(boidAcceleration.x .. " " .. boidAcceleration.y, boidPos.x, boidPos.y + 10)
    --love.graphics.print(boidVelocity.x .. " " .. boidVelocity.y, boidPos.x, boidPos.y + 10)
    love.graphics.print(boidVelocity:getMagnitude(), boidPos.x, boidPos.y + 10)
end

