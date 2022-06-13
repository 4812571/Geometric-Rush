-- Modules
local Controls = require(game.ReplicatedStorage.Source.Game.Controls)
local Collisions = require(game.ReplicatedStorage.Source.Game.Collisions)
local Event = require(game.ReplicatedStorage.Source.Core.Event)

local AvatarManager = {
    avatarClasses = {};
    avatarDied = Event.new();
}

function AvatarManager:Initialize()
    for _, avatarSource in ipairs(game.ReplicatedStorage.Source.Avatars:GetChildren()) do
        self.avatarClasses[avatarSource.Name] = require(avatarSource)
    end
end

function AvatarManager:Update(delta)
    -- Check Avatar
    if not self.avatar then return end
    if not self.avatar:IsAlive() then return end

    -- Update Subsystems
    Controls:Update(delta)
    Collisions:Update(delta)

    -- Propogate Events [Collision]
    for element, _ in pairs(Collisions:GetColliding()) do
        element:Collide(self.avatar)
        if not self.avatar:IsAlive() then return end
    end

    -- Propogate Events [Interaction]
    if self.avatar:IsInteracting() then
        for element, _ in pairs(Collisions:GetTouching()) do
            element:Interact(self.avatar)
            if not self.avatar:IsAlive() then return end
        end
    end

    -- Update Avatar
    self.avatar:Update(delta)
end

function AvatarManager:ClearAvatar()
    -- Destroy Avatar
    if self.avatar then
        self.avatar:Destroy()
    end

    -- Disable Collisions
    Collisions:ClearBoxes()

    -- Unbind Controls
    Controls:Unbind()

    -- Clear Avatar
    self.avatar = nil
end

function AvatarManager:CreateAvatar(avatarName, avatarParameters)
    -- Clear Previous Avatar
    self:ClearAvatar()

    -- Create Avatar
    self.avatar = self.avatarClasses[avatarName].new(avatarParameters)

    -- Enable Collisions
    for _, hurtBox in ipairs(self.avatar:GetHurtBoxes()) do
        Collisions:AddHurtBox(hurtBox)
    end

    -- Bind Controls
    Controls:Bind(self.avatar)

    -- Link Event
    self.avatar.died:Connect(function()
        self.avatarDied:Fire()
    end)

    return self.avatar
end

function AvatarManager:GetAvatar()
    return self.avatar
end

return AvatarManager