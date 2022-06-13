-- Modules
local Avatar = require(game.ReplicatedStorage.Source.Avatars.Avatar)
local Physics = require(game.ReplicatedStorage.Source.Game.Physics)
local Camera = require(game.ReplicatedStorage.Source.Cameras.UFO)

-- References
local UFOTemplate = game.ReplicatedStorage.Models.Avatars.UFO

-- Helper Functions
local function setY(v0, y)
    return Vector3.new(v0.X, y, v0.Z)
end

-- Class UFO inherits from Avatar
local UFO = {
    -- Physics
    speed = 10.2031367726;
    terminal = -10;
    gravity = -36.4;

    -- Angular Physics
    rotationSpeed = -math.rad(395.083406);
    rotationEasingSpeed = math.rad(440);

    -- Jump Physics
    interactSinked = false;
    jumpSpeed =  10;
}
setmetatable(UFO, {__index = Avatar})
UFO.__index = UFO

function UFO:GetPosition()
    return Physics:GetPosition(self.model)
end

function UFO:GetVelocity()
    return Physics:GetVelocity(self.model)
end

function UFO:Interact()
    -- [Super]
    Avatar.Interact(self)

    -- Manage Interaction
    if self.interactSinked then return end

    -- Bounce
    self:Boost(self.jumpSpeed)

    -- Handle Sinking
    self.interactSinked = true
end

function UFO:DisableTrail()
    self.model.Effects.Trail.Trail.Enabled = false
end

function UFO:EnableTrail()
    self.model.Effects.Trail.Trail.Enabled = true
end

function UFO:Update(delta)
    -- Update Camera
    Camera:Update(delta, self.model.PrimaryPart.Position)

    -- Update Interaction
    if not self:IsInteracting() then
        print("Not Interacting")
        self.interactSinked = false
    end

    -- [Super]
    if not Avatar.Update(self, delta) then return end
end

function UFO.new(position)
    local model = UFOTemplate:Clone()

    -- [Super]
    local self = Avatar.new(model, "UFO")

    -- Load UFO
    model:SetPrimaryPartCFrame(CFrame.new(position))
    model.Parent = workspace.Scene.Avatars

    -- Bind Physics
    Physics:SetAcceleration(model, Vector3.new(0, UFO.gravity, 0))
    Physics:SetVelocity(model, Vector3.new(UFO.speed, 0, 0))
    Physics:SetVelocityRange(model, Vector3.new(-math.huge, UFO.terminal, -math.huge), Vector3.new(math.huge, math.huge, math.huge))

    -- Create Object
    return setmetatable(self, UFO)
end

function UFO:Destroy()
    -- [Super]
    Avatar.Destroy(self)
end

function UFO:Kill()
    -- [Super]
    Avatar.Kill(self)
    self:Destroy()
end

return UFO