local Trigger = require(game.ReplicatedStorage.Source.Triggers.Trigger)

-- Class PrintTrigger inherits from Trigger
local PrintTrigger = {}
setmetatable(PrintTrigger, Trigger)
PrintTrigger.__index = PrintTrigger

function PrintTrigger:Pass()
    print("PrintTrigger:", self.model.Message.Value)
end

function PrintTrigger.new(model)
    local self = Trigger.new(model)

    return setmetatable(self, PrintTrigger)
end

return PrintTrigger