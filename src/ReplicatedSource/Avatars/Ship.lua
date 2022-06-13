-- Modules
local Avatar = require(game.ReplicatedStorage.Source.Avatars.Avatar)
local Physics = require(game.ReplicatedStorage.Source.Game.Physics)
local Camera = require(game.ReplicatedStorage.Source.Cameras.Ship)

-- References
local shipTemplate = game.ReplicatedStorage.Models.Avatars.Ship

-- Class Ship inherits from Avatar
local Ship = {
    -- Physics
    speed = 10;
    terminal = 10;
    thrust = 34.7755102;
    gravity = -26.3799164;

    -- State Cache
    isThrusting = false;
}
setmetatable(Ship, {__index = Avatar})
Ship.__index = Ship

function Ship:GetPosition()
    return Physics:GetPosition(self.model)
end

function Ship:GetVelocity()
    return Physics:GetVelocity(self.model)
end

function Ship:Interact()
    -- [Super]
    Avatar.Interact(self)

    -- Set State
    self.isThrusting = true
end

function Ship:UpdateRotation(delta)
    -- Rotate Along the Velocity
    local velocity = Physics:GetVelocity(self.model)
    local rotation = -math.atan(math.abs(velocity.Y) / math.abs(velocity.X)) * math.sign(velocity.Y)

    -- Update Motor
    local motor = self.model.Visualizer.Motor6D
    motor:SetDesiredAngle(rotation)
end

function Ship:Update(delta)
    -- [Super]
    if not Avatar.Update(self, delta) then return end

    -- Set Camera
    Camera:Update(delta, self.model.PrimaryPart.Position)

    -- Update Boost Effect
    if self.isThrusting then
        self.model.Effects.Engine.Boost.Enabled = true
    else
        self.model.Effects.Engine.Boost.Enabled = false
    end

    -- Handle Thrust
    if self.isThrusting then
        Physics:SetAcceleration(self.model, Vector3.new(0, self.thrust, 0))
    else
        Physics:SetAcceleration(self.model, Vector3.new(0, self.gravity, 0))
    end

    -- Reset State
    self.isThrusting = false

    -- Update Rotation
    self:UpdateRotation(delta)
end

function Ship.new(position)
    local model = shipTemplate:Clone()

    -- [Super]
    local self = Avatar.new(model, "Ship")

    -- Load Ship
    model:SetPrimaryPartCFrame(CFrame.new(position))
    model.Parent = workspace.Scene.Avatars

    -- Bind Physics
    Physics:SetVelocity(model, Vector3.new(Ship.speed, 0, 0))
    Physics:SetVelocityRange(model, Vector3.new(-math.huge, -Ship.terminal, -math.huge), Vector3.new(math.huge, Ship.terminal, math.huge))

    -- Create Object
    return setmetatable(self, Ship)
end

function Ship:Destroy()
    -- [Super]
    Avatar.Destroy(self)
end

function Ship:Kill()
    -- [Super]
    Avatar.Kill(self)
    self:Destroy()
end

return Ship