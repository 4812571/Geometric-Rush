-- Game Services
local RunService = game:GetService("RunService")

-- References
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Bootloader = {}

function Bootloader:Initialize()
    -- Game Modules
    local ElementRegistry = require(ReplicatedStorage.Source.Game.ElementRegistry)
    local Physics = require(ReplicatedStorage.Source.Game.Physics)
    local AvatarManager = require(ReplicatedStorage.Source.Game.AvatarManager)
    local Triggers = require(ReplicatedStorage.Source.Game.Triggers)

    -- Gui
    local LevelSelector = require(ReplicatedStorage.Source.Gui.LevelSelector)
    local Message = require(ReplicatedStorage.Source.Gui.Message)

    -- Services
    local RotationService = require(ReplicatedStorage.Source.Services.RotationService)
    local BeatService = require(ReplicatedStorage.Source.Services.BeatService)

    -- Scriptable Camera
    workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable

    -- Ease
    task.wait(2)

    -- Initialize
    ElementRegistry:Initialize()
    AvatarManager:Initialize()
    Triggers:Initialize()
    LevelSelector:Initialize()
    Message:Initialize()

    -- Update
    local function update(delta)
        -- Core
        Physics:Update(delta)

        -- Game
        AvatarManager:Update(delta)

        -- Effects
        RotationService:Update(delta)
        BeatService:Update(delta)
    end

    RunService.RenderStepped:Connect(update)
    --while true do task.wait(1) update(1/60) end
end

return Bootloader