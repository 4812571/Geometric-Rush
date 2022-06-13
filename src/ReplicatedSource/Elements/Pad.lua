local TweenService = game:GetService("TweenService")
local Element = require(game.ReplicatedStorage.Source.Elements.Element)

-- Class: Pad inherits from Element
local Pad = {}
setmetatable(Pad, Element)
Pad.__index = Pad

function Pad.new(model)
    local self = Element.new(model)

    -- Used State
    self.used = false

    return setmetatable(self, Pad)
end

function Pad:Animate()
    local burstPart = self.model:FindFirstChild("Burst")

    -- Set Transparency
    burstPart.Transparency = 0.9

    -- Tween Size Down
    local tween = TweenService:Create(burstPart, TweenInfo.new(0.4), {Size = Vector3.new(1, 0.5, 0.5)})

    -- Tween Cleanup
    local function onComplete()
        burstPart.Transparency = 1
        burstPart.Size = Vector3.new(1, 1.4, 1.4)

        tween:Destroy()
    end

    -- Play Tween
    tween:Play()

    -- Completed
    tween.Completed:Connect(onComplete)
end

function Pad:Debounce()
    -- Guard
    if self.used then return false end

    -- Lock Debounce
    self.used = true

    return true
end

return Pad