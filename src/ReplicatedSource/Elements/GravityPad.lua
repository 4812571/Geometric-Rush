local Pad = require(game.ReplicatedStorage.Source.Elements.Pad)
local Level = require(game.ReplicatedStorage.Source.Game.Level)

-- Class GravityPad inherits from Pad
local GravityPad = {}
setmetatable(GravityPad, Pad)
GravityPad.__index = GravityPad

function GravityPad:Collide(avatar)
    -- Debounce
    if not self:Debounce() then return end

    -- Flip Gravity + Boost
    avatar:InvertGravity()

    -- Trail Handler
    if avatar:GetAvatarType() == "Cube" then
        avatar:EnableTrail()
    end

    -- Animate
    self:Animate()
end

function GravityPad.new(model)
    -- Create Object
    local self = Pad.new(model)

    -- Bind Events
    Level.onReset:Connect(function()
        self.used = false
    end)

    -- Properties
    self.used = false

    return setmetatable(self, GravityPad)
end

return GravityPad