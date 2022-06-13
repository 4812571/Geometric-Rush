local Element = require(game.ReplicatedStorage.Source.Elements.Element)
local RotationService = require(game.ReplicatedStorage.Source.Services.RotationService)

-- Class: Spinner inherits from Element
local Spinner = {}
setmetatable(Spinner, Element)
Spinner.__index = Spinner

function Spinner:Collide(avatar)
    avatar:Kill()
end

function Spinner.new(model)
    -- Create Object
    local self = Element.new(model)

    -- Extract Values
    local rotationValue = model:FindFirstChild("Rotation")
    local bobbingValue  = model:FindFirstChild("Bobbing")

    -- Extract Values
    local rotation = rotationValue and rotationValue.Value or Vector3.new(0, 0, 0)
    local bobbing  = bobbingValue  and bobbingValue.Value  or 0

    RotationService:AddItem(model, rotation, bobbing)

    return setmetatable(self, Spinner)
end

return Spinner