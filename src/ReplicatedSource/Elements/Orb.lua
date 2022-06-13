local TweenService = game:GetService("TweenService")
local Element = require(game.ReplicatedStorage.Source.Elements.Element)

-- Class: Orb inherits from Element
local Orb = {}
setmetatable(Orb, Element)
Orb.__index = Orb

function Orb.new(model)
    local self = Element.new(model)

    return setmetatable(self, Orb)
end

function Orb:Animate()
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

return Orb