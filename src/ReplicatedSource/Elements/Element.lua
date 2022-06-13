local Event = require(game.ReplicatedStorage.Source.Core.Event)

local Element = {}
Element.__index = Element

function Element.new(model)
    local self = {
        -- Model
        model = model;
    }

    return setmetatable(self, Element)
end

function Element:Collide()

end

function Element:Interact()

end

function Element:GetModel()
    return self.model
end

return Element