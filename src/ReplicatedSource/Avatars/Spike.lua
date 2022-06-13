-- Modules
local Avatar = require(game.ReplicatedStorage.Source.Avatars.Avatar)
local Physics = require(game.ReplicatedStorage.Source.Game.Physics)
local Camera = require(game.ReplicatedStorage.Source.Cameras.Spike)

-- References
local SpikeTemplate = game.ReplicatedStorage.Models.Avatars.Spike

-- Helper Functions
local function setY(v0, y)
    return Vector3.new(v0.X, y, v0.Z)
end

-- Class Spike inherits from Avatar
local Spike = {
    -- Physics
    speed = 10;
    terminal = -26;
    gravity = -51.95;

    -- Boost
    boost = 12;

    -- Angular Physics
    rotationSpeed = -math.rad(395.083406);
    rotationEasingSpeed = math.rad(440);
}
setmetatable(Spike, {__index = Avatar})
Spike.__index = Spike

function Spike:GetPosition()
    return Physics:GetPosition(self.model)
end

function Spike:GetVelocity()
    return Physics:GetVelocity(self.model)
end

function Spike:Boost(amount)
    -- [Super]
    Avatar.Boost(self, amount * 0.65);
end

function Spike:InvertGravity()
    -- Invert Model
    self.model:SetPrimaryPartCFrame(self.model.PrimaryPart.CFrame * CFrame.Angles(math.rad(180), 0, 0))

    -- [Super]
    Avatar.InvertGravity(self)
end

function Spike:Interact()
    -- [Super]
    Avatar.Interact(self)

    -- Debounce
    if not Physics:IsGrounded(self.model) then return end

    -- Disable Skid Effect
    self.model.Effects.Skid.Emitter.Enabled = false

    -- Boost
    self:Boost(self.boost)

    -- Invert Gravity
    self:InvertGravity()
end

function Spike:DisableTrail()
    self.model.Effects.Trail.Trail.Enabled = false
end

function Spike:EnableTrail()
    self.model.Effects.Trail.Trail.Enabled = true
end

function Spike:UpdateRotation(delta)
    -- Get Motor
    local motor = self.model.Visualizer.Motor6D

    -- Get Angle
    local currentAngle = motor.CurrentAngle

    -- Get Desired Angle
    local desiredAngle = currentAngle + self.rotationSpeed * delta

    -- Set Motor Angle
    motor:SetDesiredAngle(desiredAngle)
end

function Spike:Update(delta)
    -- [Super]
    if not Avatar.Update(self, delta) then return end

    -- Update Camera
    Camera:Update(delta, self.model.PrimaryPart.Position)

    -- Update Skid Effect
    self.model.Effects.Skid.Emitter.Enabled = Physics:IsGrounded(self.model)

    -- Update Rotation
    self:UpdateRotation(delta)
end

function Spike.new(position)
    local model = SpikeTemplate:Clone()

    -- [Super]
    local self = Avatar.new(model, "Spike")

    -- Load Spike
    model:SetPrimaryPartCFrame(CFrame.new(position))
    model.Parent = workspace.Scene.Avatars

    -- Bind Physics
    Physics:SetAcceleration(model, Vector3.new(0, Spike.gravity, 0))
    Physics:SetVelocity(model, Vector3.new(Spike.speed, 0, 0))
    Physics:SetVelocityRange(model, Vector3.new(-math.huge, Spike.terminal, -math.huge), Vector3.new(math.huge, math.huge, math.huge))

    -- Bind Physics Grounded
    Physics:GetGroundedEvent(model):Connect(function(isGrounded)
        -- Update Skid Effect
        model.Effects.Skid.Emitter.Enabled = isGrounded

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
    return setmetatable(self, Spike)
end

function Spike:Destroy()
    -- [Super]
    Avatar.Destroy(self)
end

function Spike:Kill()
    -- [Super]
    Avatar.Kill(self)
    self:Destroy()
end

return Spike