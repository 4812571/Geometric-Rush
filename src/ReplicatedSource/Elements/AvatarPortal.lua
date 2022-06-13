local Element = require(game.ReplicatedStorage.Source.Elements.Element)
local AvatarManager = require(game.ReplicatedStorage.Source.Game.AvatarManager)
local Scroller = require(game.ReplicatedStorage.Source.Game.Scroller)

-- Class AvatarPortal inherits from Element
local AvatarPortal = {}
setmetatable(AvatarPortal, Element)
AvatarPortal.__index = AvatarPortal

function AvatarPortal:Collide(avatar)
    -- Cache Position
    local position = avatar.model.PrimaryPart.Position

    -- Spawn New Avatar
    AvatarManager:CreateAvatar(self.model.AvatarType.Value, position)

    -- Get Values
    local floorHeightValue = self.model:FindFirstChild("FloorHeight")
    local ceilingHeightValue = self.model:FindFirstChild("CeilingHeight")

    -- Set Floor
    if floorHeightValue then Scroller:SetFloorHeight(self.model.FloorHeight.Value) else Scroller:SetFloorHeight(nil) end

    -- Set Ceiling
    if ceilingHeightValue then Scroller:SetCeilingHeight(self.model.CeilingHeight.Value) else Scroller:SetCeilingHeight(nil) end
end

function AvatarPortal.new(model)
    -- Create Object
    local self = Element.new(model)

    return setmetatable(self, AvatarPortal)
end

return AvatarPortal