local Orb = require(game.ReplicatedStorage.Source.Elements.Orb)
local Level = require(game.ReplicatedStorage.Source.Game.Level)

-- Class SwingOrb inherits from Orb
local SwingOrb = {
    boost = 16.8;
}
setmetatable(SwingOrb, Orb)
SwingOrb.__index = SwingOrb

function SwingOrb:Interact(avatar)
    -- Print
    print("SwingOrb:Interact()")

    -- Debounce
    if self.used then return else self.used = true end

    -- Flip Gravity + Boost
    avatar:InvertGravity()
    avatar:Boost(self.boost)

    -- Trail Handler
    if avatar:GetAvatarType() == "Cube" then
        avatar:EnableTrail()
    end

    -- Animate
    self:Animate()
end

function SwingOrb.new(model)
    -- Create Object
    local self = Orb.new(model)

    -- Bind Events
    Level.onReset:Connect(function()
        self.used = false
    end)

    -- Properties
    self.used = false

    return setmetatable(self, SwingOrb)
end

return SwingOrb