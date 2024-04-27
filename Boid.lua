local Boid = {}
Vector = require 'Vector'

function Boid:new()
    return setmetatable({
        position = Vector.new(math.random(0, 1280), math.random(0, 720)),
        velocity = Vector.new(math.random(-150, 150), math.random(-150, 150)),
        acceleration = Vector.new(0, 0),
        radius = 75,
        maxForce = 250,
        maxSpeed = 500,
        color = {1, 1, 1}
    }, {__index = Boid})
end

function Boid:edges()
    if (self.position.x > 1300) then
        self.position.x = -15
    elseif (self.position.x < -15) then
        self.position.x = 1300;
    end

    if (self.position.y > 750) then
        self.position.y = -15
    elseif (self.position.y < -15) then
        self.position.y = 750;
    end
end

function Boid:align(boids)
    local avg = Vector.new()
    local len = 0;
    for _, boid in pairs(boids) do
        local magnitude = (self.position - boid.position):getMagnitude()
        if (boid ~= self and magnitude <= self.radius) then
            avg = avg + boid.velocity
            len = len + 1;
        end
    end
    if (len > 0) then
        avg = avg / len
        avg = avg:setMagnitude(self.maxSpeed)
        avg = avg - self.velocity
        avg = avg:clamp(self.maxForce);
    end
    return avg
end

function Boid:cohesion(boids)
    local avg = Vector.new()
    local len = 0;
    for _, boid in pairs(boids) do
        local magnitude = (self.position - boid.position):getMagnitude()
        if (boid ~= self and magnitude <= self.radius) then
            avg = avg + boid.position
            len = len + 1
        end
    end
    if (len > 0) then
        avg = avg / len
        avg = avg - self.position
        avg = avg:setMagnitude(self.maxSpeed)
        avg = avg - self.velocity
        avg = avg:clamp(self.maxForce)
    end
    return avg
end

function Boid:separation(boids)
    local avg = Vector.new()
    local len = 0;
    for _, boid in pairs (boids) do
        local magnitude = (self.position - boid.position):getMagnitude()
        if (boid ~= self and magnitude <= 50) then
            avg = avg + (self.position - boid.position) / magnitude
            len = len + 1
        end
    end

    if (len > 0) then
        avg = avg / len
        avg = avg:setMagnitude(self.maxSpeed)
        avg = avg - self.velocity
        avg = avg:clamp(self.maxForce)
    end
    return avg
end

function Boid:flock(boids)
    local alignment = self:align(boids)
    local cohesion = self:cohesion(boids)
    local separation = self:separation(boids)

    self.acceleration = self.acceleration + separation
    self.acceleration = self.acceleration + cohesion
    self.acceleration = self.acceleration + alignment


end

function Boid:update(dt)
    self.position = self.position + self.velocity * dt
    self.velocity = self.velocity + self.acceleration * dt
    self.velocity = self.velocity:clamp(self.maxSpeed)
    self.acceleration = Vector.new(0,0)
end

function Boid:draw()
    love.graphics.setColor(self.color[1], self.color[2], self.color[3]);
    love.graphics.circle("fill", self.position.x, self.position.y, 12.5/2);
end



return Boid