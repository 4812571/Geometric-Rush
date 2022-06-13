local MessageGui = require(game.ReplicatedStorage.Source.Gui.Message)
local Trigger = require(game.ReplicatedStorage.Source.Triggers.Trigger)

-- Class MessageTrigger inherits from Trigger
local MessageTrigger = {}
setmetatable(MessageTrigger, Trigger)
MessageTrigger.__index = MessageTrigger

function MessageTrigger.new(model)
    local self = Trigger.new(model)

    -- Properties
    self.message = model.Message.Value

    return setmetatable(self, MessageTrigger)
end

function MessageTrigger:Pass()
    -- Print
    MessageGui:Message(self.message)
end

return MessageTrigger