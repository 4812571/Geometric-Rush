local LevelColorService = require(game.ReplicatedStorage.Source.Services.LevelColorService)
local Trigger = require(game.ReplicatedStorage.Source.Triggers.Trigger)

-- Class ColorTrigger inherits from Trigger
local ColorTrigger = {}
setmetatable(ColorTrigger, Trigger)
ColorTrigger.__index = ColorTrigger

function ColorTrigger:Pass()
    LevelColorService:Tween(self.color)
end

function ColorTrigger.new(model)
    local self = Trigger.new(model)
    self.color = self.model.Color.Value

    return setmetatable(self, ColorTrigger)
end

return ColorTrigger