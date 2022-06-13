-- Get Player
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Level Module
local Level = require(game.ReplicatedStorage.Source.Game.Level)

local Message = {}

function Message:Enable()
    PlayerGui:WaitForChild("Message").Enabled = true
end

function Message:Disable()
    PlayerGui:WaitForChild("Message").Enabled = false
end

function Message:Message(text)
    -- Enable
    self:Enable()

    -- Set Message
    PlayerGui:WaitForChild("Message"):WaitForChild("Frame"):WaitForChild("Message").Text = text
end

function Message:Initialize()
    -- Clone Gui
    game.ReplicatedStorage.GuiAssets.Message:Clone().Parent = PlayerGui
end

return Message