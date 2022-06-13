local TweenService = game:GetService("TweenService")

local LevelColorService = require(game.ReplicatedStorage.Source.Services.LevelColorService)
local Triggers = require(game.ReplicatedStorage.Source.Game.Triggers)

local Scroller = {
    scroll = 0;
}

-- Vector Helper Functions
local function setX(v0, x)
    return Vector3.new(x, v0.Y, v0.Z)
end

local function setY(v0, y)
    return Vector3.new(v0.X, y, v0.Z)
end

-- Scroller Functions
function Scroller:SetFloor(floor)
    if self.floor then self.floor:Destroy() end

    self.floor = floor:Clone()
    self.floor.Parent = workspace.Scene.Boundaries
    LevelColorService:StoreInitialColor(self.floor)
end

function Scroller:SetCeiling(ceiling)
    if self.ceiling then self.ceiling:Destroy() end

    self.ceiling = ceiling:Clone()
    self.ceiling.Parent = workspace.Scene.Boundaries
    LevelColorService:StoreInitialColor(self.ceiling)
end

function Scroller:SetBackground(background)
    if self.background then self.background:Destroy() end

    self.background = background:Clone()
    self.background.Parent = workspace.Scene.Boundaries
    LevelColorService:StoreInitialColor(self.background)
end

function Scroller:Update()
    self.floor.Position = setX(self.floor.Position, self.scroll)
    self.ceiling.Position = setX(self.ceiling.Position, self.scroll)

    -- Texture Editing
    if self.background:FindFirstChild("Texture") then
        self.background.Texture.OffsetStudsU = (-self.scroll * -self.background.Speed.Value)
    end

    if self.floor:FindFirstChild("Texture") then
        self.floor.Texture.OffsetStudsU = (-self.scroll)
    end

    if self.ceiling:FindFirstChild("Texture") then
        self.ceiling.Texture.OffsetStudsU = (-self.scroll)
    end

    -- Update Triggers
    Triggers:Update(self.scroll)
end

function Scroller:AddToScene(part)
    part.Parent = workspace.Scene.Boundaries
end

function Scroller:RemoveFromScene(part)
    part.Parent = nil
end

function Scroller:SetScroll(scroll)
    self.scroll = scroll
end

function Scroller:GetScroll()
    return self.scroll
end

function Scroller:SetFloorHeight(height)
    if height then self:AddToScene(self.floor) else self:RemoveFromScene(self.floor) return end

    self.floor.Position = setY(self.floor.Position, height - self.floor.Size.Y / 2)
end

function Scroller:SetCeilingHeight(height)
    if height then self:AddToScene(self.ceiling) else self:RemoveFromScene(self.ceiling) return end

    self.ceiling.Position = setY(self.ceiling.Position, height + self.ceiling.Size.Y / 2)
end

function Scroller:GetFloorHeight()
    return self.floor.Position.Y + self.floor.Size.Y / 2
end

function Scroller:GetCeilingHeight()
    return self.ceiling.Position.Y - self.ceiling.Size.Y / 2
end

return Scroller