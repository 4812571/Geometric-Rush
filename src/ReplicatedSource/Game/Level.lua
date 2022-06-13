local ElementRegistry = require(game.ReplicatedStorage.Source.Game.ElementRegistry)
local AvatarManager = require(game.ReplicatedStorage.Source.Game.AvatarManager)
local MusicService = require(game.ReplicatedStorage.Source.Services.MusicService)
local WeldService = require(game.ReplicatedStorage.Source.Services.WeldService)
local BeatService = require(game.ReplicatedStorage.Source.Services.BeatService)
local LevelColorService = require(game.ReplicatedStorage.Source.Services.LevelColorService)
local CoreCamera = require(game.ReplicatedStorage.Source.Cameras.Core)
local Scroller = require(game.ReplicatedStorage.Source.Game.Scroller)
local Triggers = require(game.ReplicatedStorage.Source.Game.Triggers)
local Event = require(game.ReplicatedStorage.Source.Core.Event)

local Level = {
    -- Cache
    elements = {};

    -- Events
    onReset = Event.new();

    -- Properties
    attemptCount = 1;
}

function Level:Load(templateModel)
    -- Clone Template
    local levelModel = templateModel:Clone()

    -- Weld
    for _, model in ipairs(levelModel.MovingElements:GetChildren()) do
        WeldService:WeldModel(model)
        WeldService:UnanchorModel(model)
    end

    -- Move
    for _, model in ipairs(levelModel.MovingElements:GetChildren()) do
        model.Parent = levelModel
    end

    -- Index Data
    local Data = levelModel:WaitForChild("Data")

    -- Lighting
    if Data:FindFirstChild("Bloom") and Data.Bloom.Value then
        game.Lighting.Bloom.Enabled = true
        game.Lighting.ColorCorrection.Enabled = true
    else
        game.Lighting.Bloom.Enabled = false
        game.Lighting.ColorCorrection.Enabled = false
    end

    -- Trigger System
    local triggerFolder = levelModel:WaitForChild("Triggers")
    Triggers:Load(triggerFolder)

    -- Destroy Triggers
    for _, triggerModel in ipairs(triggerFolder:GetChildren()) do
        triggerModel.Parent = nil
    end

    -- Load BeatService
    BeatService:Start(Data.BPM.Value)

    -- Set Floor + Ceiling
    local function setBoundaries()
        -- Get Values
        local floorHeightValue = levelModel.Data:FindFirstChild("FloorHeight")
        local ceilingHeightValue = levelModel.Data:FindFirstChild("CeilingHeight")

        -- Set Floor
        if floorHeightValue then Scroller:SetFloorHeight(floorHeightValue.Value) else Scroller:SetFloorHeight(nil) end

        -- Set Ceiling
        if ceilingHeightValue then Scroller:SetCeilingHeight(ceilingHeightValue.Value) else Scroller:SetCeilingHeight(nil) end

        -- Update Scroller
        Scroller:Update()
    end

    -- Register Elements
    for _, model in pairs(levelModel:GetChildren()) do
        if not model:IsA("Model") then continue end
        table.insert(self.elements, ElementRegistry:Register(model))
    end

    -- Move Level
    levelModel.Parent = workspace

    -- Move Boundaries
    Scroller:SetFloor(levelModel.Data.Floor.Value)
    Scroller:SetCeiling(levelModel.Data.Ceiling.Value)
    Scroller:SetBackground(levelModel.Data.Background.Value)

    -- Clear Boundaries
    for _, boundary in ipairs(levelModel.Boundaries:GetChildren()) do
        boundary.Parent = nil
    end

    -- Handle Death
    local function spawnAvatar()
        -- Update Boundaries
        setBoundaries()

        -- Open Shutter
        CoreCamera:InstantOpenShutter()

        -- Load Level
        LevelColorService:Reset()
        MusicService:Play(Data.Music.Value)
        AvatarManager:CreateAvatar(Data.AvatarType.Value, Vector3.new(0, 1, 0))

        Triggers:Reset()
    end

    -- Automatically Spawn Avatar + Reset Level
    self.respawnConnection = AvatarManager.avatarDied:Connect(function()
        self.attemptCount = self.attemptCount + 1
        workspace.Scene.Death.SurfaceGui.TextLabel.Text = "Attempt " .. tostring(self.attemptCount)

        self.onReset:Fire()

        -- Respawn Avatar
        spawnAvatar()
    end)

    -- Spawn Avatar
    spawnAvatar()
end

function Level:Clear()
    -- Clear Avatar
    AvatarManager:ClearAvatar()

    -- Disable Respawn
    self.respawnConnection:Disconnect()
end

return Level