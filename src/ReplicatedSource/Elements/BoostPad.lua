local Pad = require(game.ReplicatedStorage.Source.Elements.Pad)
local Level = require(game.ReplicatedStorage.Source.Game.Level)

-- Class BoostPad inherits from Pad
local BoostPad = {
    boost = 27.7;
}
setmetatable(BoostPad, Pad)
BoostPad.__index = BoostPad

function BoostPad:Collide(avatar)
    -- Debounce
    if not self:Debounce() then return end

    -- Flip Gravity + Boost
    avatar:Boost(self.boost)

    -- Trail Handler
    if avatar:GetAvatarType() == "Cube" then
        avatar:EnableTrail()
    end

    -- Animate
    self:Animate()
end

function BoostPad.new(model)
    -- Create Object
    local self = Pad.new(model)

    -- Bind Events
    Level.onReset:Connect(function()
        self.used = false
    end)

    -- Properties
    self.used = false

    return setmetatable(self, BoostPad)
end

return BoostPad