-- Get Player
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Level Module
local Level = require(game.ReplicatedStorage.Source.Game.Level)

local LevelSelector = {}

function LevelSelector:Enable()
    PlayerGui:WaitForChild("LevelSelector").Enabled = true
end

function LevelSelector:Disable()
    PlayerGui:WaitForChild("LevelSelector").Enabled = false
end

function LevelSelector:SelectLevel(levelName)
    -- Get Template
    local template = game.ReplicatedStorage.Models.Levels:WaitForChild(levelName, 1)

    -- Create Level
    Level:Load(template)

    -- Disable
    self:Disable()
end

function LevelSelector:Initialize()
    -- Clone Gui
    game.ReplicatedStorage.GuiAssets.LevelSelector:Clone().Parent = PlayerGui

    -- Bind Buttons
    for _, v in ipairs(PlayerGui:WaitForChild("LevelSelector").Frame.Frame:GetChildren()) do
        if not v:IsA("TextButton") then continue end
        v.MouseButton1Click:Connect(function() self:SelectLevel(v.Text) end)
    end

    -- Display
    self:Enable()
end

return LevelSelector