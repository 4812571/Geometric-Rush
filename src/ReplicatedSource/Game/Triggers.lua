local Triggers = {
    -- Template Cache
    triggers = {};

    -- Active
    activeTriggers = {};

    -- Spent
    spentTriggers = {};

    -- Trigger Classes
    triggerClasses = {};
}

function Triggers:Initialize()
    -- Load Modules
    for _, module in ipairs(game.ReplicatedStorage.Source.Triggers:GetChildren()) do
        self.triggerClasses[module.Name] = require(module)
    end
end

function Triggers:CopyToActive()
    for index, trigger in ipairs(self.triggers) do
        self.activeTriggers[index] = trigger
    end
end

function Triggers:Reset()
    -- Reset Spent
    for _, trigger in ipairs(self.spentTriggers) do
        trigger:Reset()
    end

    -- Clear Active & Spent
    self.activeTriggers = {}
    self.spentTriggers = {}

    -- Copy To Active
    self:CopyToActive()
end

function Triggers:Load(triggerFolder)
    -- Parse Trigger Folder
    for _, triggerModel in ipairs(triggerFolder:GetChildren()) do
        -- Create Trigger
        local trigger = self.triggerClasses[triggerModel.TriggerType.Value].new(triggerModel)

        -- Add Trigger to Cache
        table.insert(self.triggers, trigger)

        -- Sort Triggers
        table.sort(self.triggers, function(a, b) return a:GetScroll() < b:GetScroll() end)
    end

    self:Reset()
end

function Triggers:Update(scrollPosition)
    while self.activeTriggers[1] and self.activeTriggers[1]:GetScroll() <= scrollPosition do
        -- Pop Passed Triggers
        local popped = table.remove(self.activeTriggers, 1)

        -- Call Method
        popped:Pass()

        -- Add Spent
        table.insert(self.spentTriggers, popped)
    end
end

return Triggers