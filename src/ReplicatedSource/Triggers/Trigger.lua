local Trigger = {}
Trigger.__index = Trigger

function Trigger.new(model)
    local self = {
        -- Model
        model = model;
    }

    return setmetatable(self, Trigger)
end

-- [Header]
function Trigger:Pass(avatar) end
function Trigger:Reset() end

function Trigger:GetScroll()
    local scroll = self.model.PrimaryPart.Position.X
    local offset = self.model:FindFirstChild("TimeOffset") and self.model.TimeOffset.Value * 10 or 0

    return scroll + offset
end

return Trigger