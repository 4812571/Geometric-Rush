-- Modules
local Avatar = require(game.ReplicatedStorage.Source.Avatars.Avatar)
local Physics = require(game.ReplicatedStorage.Source.Game.Physics)
local Camera = require(game.ReplicatedStorage.Source.Cameras.Cube)

-- References
local cubeTemplate = game.ReplicatedStorage.Models.Avatars.Cube

-- Class Cube inherits from Avatar
local Cube = {
    -- Physics
    speed = 10;
    terminal = -26;
    gravity = -84.5;

    -- Angular Physics
    rotationSpeed = -math.rad(395.083406);
    rotationEasingSpeed = math.rad(440);

    -- Jump Physics
    jumpSpeed =  19.4;
}

setmetatable(Cube, {__index = Avatar})
Cube.__index = Cube

function Cube:GetPosition()
    return Physics:GetPosition(self.model)
end

function Cube:GetVelocity()
    return Physics:GetVelocity(self.model)
end

function Cube:Interact()
    -- [Super]
    Avatar.Interact(self)

    -- Debounce
    if not Physics:IsGrounded(self.model) then return end

    self:Boost(self.jumpSpeed)
end

function Cube:DisableTrail()
    self.model.Effects.Trail.Trail.Enabled = false
end

function Cube:EnableTrail()
    self.model.Effects.Trail.Trail.Enabled = true
end

function Cube:UpdateRotation(delta)
    -- Round Function
    local function round(n, m)
        return math.floor(n / m + 0.5) * m
    end

    local function absMin(n, maximum)
        return math.sign(n) * math.min(math.abs(n), maximum)
    end

    -- Return The Nearest 90 Degree Angle
    local function nearestAngle(angle)
        return round(angle, math.pi / 2)
    end

    local motor = self.model.Visualizer.Motor6D
    local currentAngle = motor.CurrentAngle

    if Physics:IsGrounded(self.model) then
        -- Calculate The Angle To Rotate To
        local desiredAngle = nearestAngle(currentAngle)
        local deltaAngle = desiredAngle - currentAngle
        local cappedAngle = absMin(deltaAngle, self.rotationEasingSpeed * delta)

        -- Set Motor Angle
        motor:SetDesiredAngle(currentAngle + cappedAngle)
    else
        -- Set Motor Angle
        motor:SetDesiredAngle(currentAngle + self.rotationSpeed * delta)
    end
end

function Cube:Update(delta)
    -- [Super]
    if not Avatar.Update(self, delta) then return end

    -- Update Camera
    Camera:Update(delta, self.model.PrimaryPart.Position)

    -- Update Skid Effect
    self.model.Effects.Skid.Emitter.Enabled = Physics:IsGrounded(self.model)

    -- Update Rotation
    self:UpdateRotation(delta)
end

function Cube.new(position)
    local model = cubeTemplate:Clone()

    -- [Super]
    local self = Avatar.new(model, "Cube")

    -- Load Cube
    model:SetPrimaryPartCFrame(CFrame.new(position))
    model.Parent = workspace.Scene.Avatars

    -- Bind Physics
    Physics:SetAcceleration(model, Vector3.new(0, Cube.gravity, 0))
    Physics:SetVelocity(model, Vector3.new(Cube.speed, 0, 0))
    Physics:SetVelocityRange(model, Vector3.new(-math.huge, Cube.terminal, -math.huge), Vector3.new(math.huge, math.huge, math.huge))

    -- Bind Physics Grounded
    Physics:GetGroundedEvent(model):Connect(function(isGrounded)
        -- Landing Effect
        if isGrounded then
            -- Disable Trail
            self:DisableTrail()

            -- Index Emitter
            local emitter = model.Effects.Land.Emitter

            -- Enable Landing Effect
            emitter.Enabled = true

            -- Disable Landing Effect
            task.delay(0.1, function() emitter.Enabled = false end)
        end
    end)

    -- Create Object
    return setmetatable(self, Cube)
end

function Cube:Destroy()
    -- [Super]
    Avatar.Destroy(self)
end

function Cube:Kill()
    -- [Super]
    Avatar.Kill(self)
    self:Destroy()
end

return Cube