local Orb = require(game.ReplicatedStorage.Source.Elements.Orb)
local Level = require(game.ReplicatedStorage.Source.Game.Level)

-- Class BoostOrb inherits from Orb
local BoostOrb = {
    boost = 19.1;
}
setmetatable(BoostOrb, Orb)
BoostOrb.__index = BoostOrb

function BoostOrb:Interact(avatar)
    -- Debounce
    if self.used then return else self.used = true end

    -- Boost
    avatar:Boost(self.boost)

    -- Trail Handler
    if avatar:GetAvatarType() == "Cube" then
        avatar:EnableTrail()
    end

    -- Animate
    self:Animate()
end

function BoostOrb.new(model)
    -- Create Object
    local self = Orb.new(model)

    -- Bind Events
    Level.onReset:Connect(function()
        self.used = false
    end)

    -- Properties
    self.used = false

    return setmetatable(self, BoostOrb)
end

return BoostOrb