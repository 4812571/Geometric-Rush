local TweenService = game:GetService("TweenService")
local Trigger = require(game.ReplicatedStorage.Source.Triggers.Trigger)

-- Class TweenTrigger inherits from Trigger
local TweenTrigger = {}
setmetatable(TweenTrigger, Trigger)
TweenTrigger.__index = TweenTrigger



function TweenTrigger.new(model)
    local self = Trigger.new(model)

    -- Properties
    self.adornee = self.model.Adornee.Value
    self.duration = self.model.Duration.Value
    self.originalCFrame = self.adornee.PrimaryPart.CFrame
    self.cFrame = self.originalCFrame + self.model.Offset.Value

    return setmetatable(self, TweenTrigger)
end

function TweenTrigger:Reset()
    print("TweenTrigger:Reset()")
    self.adornee.PrimaryPart.CFrame = self.originalCFrame
end

function TweenTrigger:Pass()
    -- Print
    print("TweenTrigger:Pass()")

    -- Create Tween Info
    local tweenInfo = TweenInfo.new(self.duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

    -- Create Tween
    local tween = TweenService:Create(self.adornee.PrimaryPart, tweenInfo, {CFrame = self.cFrame})

    -- Play Tween
    tween:Play()
end

return TweenTrigger