local CoreCamera = require(game.ReplicatedStorage.Source.Cameras.Core)
local Trigger = require(game.ReplicatedStorage.Source.Triggers.Trigger)

-- Class ShutterTrigger inherits from Trigger
local ShutterTrigger = {}
setmetatable(ShutterTrigger, Trigger)
ShutterTrigger.__index = ShutterTrigger

function ShutterTrigger.new(model)
    local self = Trigger.new(model)

    -- Properties
    self.action = self.model.Action.Value

    return setmetatable(self, ShutterTrigger)
end

function ShutterTrigger:Pass()
    -- Print
    print("ShutterTrigger:Pass()")

    if self.action == "Open" then
        CoreCamera:OpenShutter()
    end

    if self.action == "Close" then
        CoreCamera:CloseShutter()
    end
end

return ShutterTrigger