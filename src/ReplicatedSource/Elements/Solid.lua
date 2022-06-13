local Element = require(game.ReplicatedStorage.Source.Elements.Element)

-- Class: Solid inherits from Element
local Solid = {}
setmetatable(Solid, Element)
Solid.__index = Solid

function Solid:Collide(avatar)
    -- Debug
    print("Solid:Collide:", self.model:GetFullName())

    -- Kill
    avatar:Kill()
end

function Solid.new(model)
    -- Create Object
    local self = Element.new(model)

    return setmetatable(self, Solid)
end

return Solid